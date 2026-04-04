use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use shared::{GIT_SHA, VERSION};
use sqlx::{PgPool, Row};
use std::sync::Arc;

/// Application state shared across all request handlers.
#[derive(Clone)]
struct AppState {
    db: PgPool,
}

/// An event as stored in PostgreSQL.
#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
struct Event {
    id: i32,
    source: String,
    event_type: String,
    payload: serde_json::Value,
    created_at: chrono::DateTime<chrono::Utc>,
}

/// Incoming event creation request body.
#[derive(Debug, Deserialize)]
struct CreateEventRequest {
    source: String,
    event_type: String,
    #[serde(default = "default_payload")]
    payload: serde_json::Value,
}

fn default_payload() -> serde_json::Value {
    json!({})
}

/// GET /version — returns build metadata for this service.
async fn version() -> Json<Value> {
    Json(json!({
        "service": "worker",
        "version": VERSION,
        "git_sha": GIT_SHA,
    }))
}

/// GET /health/live — liveness probe: the process is running.
async fn liveness() -> StatusCode {
    StatusCode::OK
}

/// GET /health/ready — readiness probe: checks PostgreSQL pool availability.
async fn readiness(State(state): State<Arc<AppState>>) -> (StatusCode, Json<Value>) {
    match state.db.acquire().await {
        Ok(_) => (StatusCode::OK, Json(json!({"status": "ready"}))),
        Err(_) => (
            StatusCode::SERVICE_UNAVAILABLE,
            Json(json!({"status": "degraded", "reason": "database unavailable"})),
        ),
    }
}

/// POST /events — create an event in the events table.
/// Accepts JSON `{"source": "...", "event_type": "...", "payload": {...}}`.
/// Returns 201 Created with the new event's ID.
async fn create_event(
    State(state): State<Arc<AppState>>,
    Json(req): Json<CreateEventRequest>,
) -> (StatusCode, Json<Value>) {
    let result = sqlx::query(
        "INSERT INTO events (source, event_type, payload) VALUES ($1, $2, $3) RETURNING id",
    )
    .bind(&req.source)
    .bind(&req.event_type)
    .bind(&req.payload)
    .fetch_one(&state.db)
    .await;

    match result {
        Ok(row) => {
            let id: i32 = row.get("id");
            (
                StatusCode::CREATED,
                Json(json!({
                    "id": id,
                    "source": req.source,
                    "event_type": req.event_type,
                })),
            )
        }
        Err(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(json!({"error": e.to_string()})),
        ),
    }
}

/// GET /events/recent — return the 50 most recent events.
/// Used by observability labs and database agents (Module 10).
///
/// SQL intentionally readable:
/// `SELECT id, source, event_type, payload, created_at FROM events ORDER BY created_at DESC LIMIT 50`
async fn recent_events(State(state): State<Arc<AppState>>) -> (StatusCode, Json<Value>) {
    let result = sqlx::query_as::<_, Event>(
        "SELECT id, source, event_type, payload, created_at FROM events ORDER BY created_at DESC LIMIT 50",
    )
    .fetch_all(&state.db)
    .await;

    match result {
        Ok(events) => {
            let events_json: Vec<Value> = events
                .iter()
                .map(|e| {
                    json!({
                        "id": e.id,
                        "source": e.source,
                        "event_type": e.event_type,
                        "payload": e.payload,
                        "created_at": e.created_at,
                    })
                })
                .collect();
            (StatusCode::OK, Json(json!({"events": events_json})))
        }
        Err(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(json!({"error": e.to_string()})),
        ),
    }
}

/// Background heartbeat loop — writes a heartbeat event every 60 seconds.
/// Generates observable write traffic for monitoring/observability labs (D-07).
/// Participants can see this in Prometheus metrics and PostgreSQL query logs.
async fn heartbeat_loop(db: PgPool) {
    loop {
        tokio::time::sleep(tokio::time::Duration::from_secs(60)).await;
        let result = sqlx::query(
            "INSERT INTO events (source, event_type, payload) VALUES ('worker', 'heartbeat', '{\"status\":\"alive\"}')",
        )
        .execute(&db)
        .await;

        if let Err(e) = result {
            eprintln!("heartbeat insert failed: {}", e);
        }
    }
}

fn build_router(state: Arc<AppState>) -> Router {
    Router::new()
        .route("/version", get(version))
        .route("/health/live", get(liveness))
        .route("/health/ready", get(readiness))
        .route("/events", post(create_event))
        .route("/events/recent", get(recent_events))
        .with_state(state)
}

#[tokio::main]
async fn main() {
    let database_url = std::env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set — provided by Kubernetes secret in production");

    let db = PgPool::connect(&database_url)
        .await
        .expect("Failed to connect to PostgreSQL");

    // Spawn the background heartbeat writer — generates observable write traffic
    tokio::spawn(heartbeat_loop(db.clone()));

    let state = Arc::new(AppState { db });
    let app = build_router(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8082").await.unwrap();
    println!("worker listening on 0.0.0.0:8082");
    axum::serve(listener, app).await.unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::body::Body;
    use axum::http::{header, Request};
    use tower::util::ServiceExt;

    fn fake_pool() -> PgPool {
        PgPool::connect_lazy("postgres://test:test@localhost:15432/test")
            .expect("lazy pool creation never fails")
    }

    #[tokio::test]
    async fn version_returns_worker_service() {
        let state = Arc::new(AppState { db: fake_pool() });
        let app = build_router(state);
        let response = app
            .oneshot(
                Request::builder()
                    .uri("/version")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();

        assert_eq!(response.status(), StatusCode::OK);
        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let json: Value = serde_json::from_slice(&body).unwrap();
        assert_eq!(json["service"], "worker");
        assert!(json["version"].is_string());
        assert!(json["git_sha"].is_string());
    }

    #[tokio::test]
    async fn liveness_returns_200() {
        let state = Arc::new(AppState { db: fake_pool() });
        let app = build_router(state);
        let response = app
            .oneshot(
                Request::builder()
                    .uri("/health/live")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();

        assert_eq!(response.status(), StatusCode::OK);
    }

    #[tokio::test]
    async fn readiness_degraded_when_db_unreachable() {
        let state = Arc::new(AppState { db: fake_pool() });
        let app = build_router(state);
        let response = app
            .oneshot(
                Request::builder()
                    .uri("/health/ready")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();

        assert_eq!(response.status(), StatusCode::SERVICE_UNAVAILABLE);
        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let json: Value = serde_json::from_slice(&body).unwrap();
        assert_eq!(json["status"], "degraded");
    }

    #[tokio::test]
    async fn create_event_accepts_json_body() {
        // With a fake/unreachable DB, we expect a 500 error (not a panic or 422).
        // This validates the route exists and the JSON deserializer accepts the body.
        let state = Arc::new(AppState { db: fake_pool() });
        let app = build_router(state);
        let response = app
            .oneshot(
                Request::builder()
                    .method("POST")
                    .uri("/events")
                    .header(header::CONTENT_TYPE, "application/json")
                    .body(Body::from(
                        r#"{"source":"test","event_type":"test-event","payload":{"key":"value"}}"#,
                    ))
                    .unwrap(),
            )
            .await
            .unwrap();

        // With unreachable DB: 500 (not 422 — JSON deserialization succeeded)
        // In a real integration test against a live DB, this would return 201
        assert_ne!(response.status(), StatusCode::UNPROCESSABLE_ENTITY);
        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let _json: Value = serde_json::from_slice(&body).expect("response must be valid JSON");
    }
}
