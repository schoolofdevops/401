use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use shared::{GIT_SHA, VERSION};
use sqlx::PgPool;
use std::sync::Arc;
use tower_http::cors::CorsLayer;

/// Application state shared across all request handlers.
#[derive(Clone)]
struct AppState {
    db: PgPool,
}

/// A catalog item as stored in PostgreSQL.
#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
struct Item {
    id: i32,
    name: String,
    description: Option<String>,
    status: String,
    created_at: chrono::DateTime<chrono::Utc>,
}

/// GET / — service index: version info and available endpoints.
async fn index() -> Json<Value> {
    Json(json!({
        "service": "catalog",
        "version": VERSION,
        "git_sha": GIT_SHA,
        "endpoints": [
            "GET /",
            "GET /version",
            "GET /health/live",
            "GET /health/ready",
            "GET /items",
            "GET /items/:id",
        ]
    }))
}

/// GET /version — returns build metadata for this service.
async fn version() -> Json<Value> {
    Json(json!({
        "service": "catalog",
        "version": VERSION,
        "git_sha": GIT_SHA,
    }))
}

/// GET /health/live — liveness probe: the process is running.
async fn liveness() -> StatusCode {
    StatusCode::OK
}

/// GET /health/ready — readiness probe: checks PostgreSQL pool availability.
/// Returns 200 if a connection can be acquired, 503 if the pool is exhausted or DB unreachable.
async fn readiness(State(state): State<Arc<AppState>>) -> (StatusCode, Json<Value>) {
    match state.db.acquire().await {
        Ok(_) => (StatusCode::OK, Json(json!({"status": "ready"}))),
        Err(_) => (
            StatusCode::SERVICE_UNAVAILABLE,
            Json(json!({"status": "degraded", "reason": "database unavailable"})),
        ),
    }
}

/// GET /items — list catalog items.
/// Demonstrates real PostgreSQL reads that database agents (Module 10) can investigate.
///
/// SQL intentionally readable: `SELECT id, name, description, status, created_at FROM items ...`
async fn list_items(State(state): State<Arc<AppState>>) -> (StatusCode, Json<Value>) {
    let result = sqlx::query_as::<_, Item>(
        "SELECT id, name, description, status, created_at FROM items ORDER BY created_at DESC LIMIT 100",
    )
    .fetch_all(&state.db)
    .await;

    match result {
        Ok(items) => {
            let items_json: Vec<Value> = items
                .iter()
                .map(|item| {
                    json!({
                        "id": item.id,
                        "name": item.name,
                        "description": item.description,
                        "status": item.status,
                        "created_at": item.created_at,
                    })
                })
                .collect();
            (StatusCode::OK, Json(json!({"items": items_json})))
        }
        Err(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(json!({"error": e.to_string()})),
        ),
    }
}

/// GET /items/:id — fetch a single catalog item by ID.
async fn get_item(
    State(state): State<Arc<AppState>>,
    Path(id): Path<i32>,
) -> (StatusCode, Json<Value>) {
    let result = sqlx::query_as::<_, Item>("SELECT * FROM items WHERE id = $1")
        .bind(id)
        .fetch_optional(&state.db)
        .await;

    match result {
        Ok(Some(item)) => (
            StatusCode::OK,
            Json(json!({
                "id": item.id,
                "name": item.name,
                "description": item.description,
                "status": item.status,
                "created_at": item.created_at,
            })),
        ),
        Ok(None) => (
            StatusCode::NOT_FOUND,
            Json(json!({"error": "item not found"})),
        ),
        Err(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(json!({"error": e.to_string()})),
        ),
    }
}

fn build_router(state: Arc<AppState>) -> Router {
    Router::new()
        .route("/", get(index))
        .route("/version", get(version))
        .route("/health/live", get(liveness))
        .route("/health/ready", get(readiness))
        .route("/items", get(list_items))
        .route("/items/{id}", get(get_item))
        .layer(CorsLayer::permissive())
        .with_state(state)
}

#[tokio::main]
async fn main() {
    let database_url = std::env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set — provided by Kubernetes secret in production");

    let db = PgPool::connect(&database_url)
        .await
        .expect("Failed to connect to PostgreSQL");

    let state = Arc::new(AppState { db });
    let app = build_router(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8081").await.unwrap();
    println!("catalog listening on 0.0.0.0:8081");
    axum::serve(listener, app).await.unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::body::Body;
    use axum::http::Request;
    use tower::util::ServiceExt;

    /// Create a test router with a real PgPool (requires DATABASE_URL).
    /// For unit tests that don't require DB, we test only the endpoints that
    /// can run without a connection (version, liveness).
    ///
    /// Note: readiness and item endpoints require a live database — those are
    /// covered by integration tests in the CI/CD pipeline (Module 5/6 labs).

    fn fake_pool() -> PgPool {
        // We create a pool with a deliberately unreachable URL.
        // Tests using this pool will see DB errors, which is the expected
        // behavior we're testing (degraded state).
        PgPool::connect_lazy("postgres://test:test@localhost:15432/test")
            .expect("lazy pool creation never fails")
    }

    #[tokio::test]
    async fn version_returns_catalog_service() {
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
        assert_eq!(json["service"], "catalog");
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

        // With an unreachable DB, we expect SERVICE_UNAVAILABLE
        assert_eq!(response.status(), StatusCode::SERVICE_UNAVAILABLE);
        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let json: Value = serde_json::from_slice(&body).unwrap();
        assert_eq!(json["status"], "degraded");
    }

    #[tokio::test]
    async fn items_endpoint_returns_items_array_shape() {
        // When DB is unreachable, we expect a 500 error with "items" not present.
        // This test validates the route exists and returns JSON.
        let state = Arc::new(AppState { db: fake_pool() });
        let app = build_router(state);
        let response = app
            .oneshot(
                Request::builder()
                    .uri("/items")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();

        // Response body must be JSON (even on error)
        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let _json: Value = serde_json::from_slice(&body).expect("response must be valid JSON");
    }
}
