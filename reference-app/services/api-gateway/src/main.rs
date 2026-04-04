use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use shared::{GIT_SHA, VERSION};
use std::sync::Arc;
use tower_http::cors::CorsLayer;

/// Application state shared across all request handlers.
#[derive(Clone)]
struct AppState {
    catalog_url: String,
    worker_url: String,
    http_client: reqwest::Client,
}

/// GET /version — returns build metadata for this service.
/// The Svelte dashboard polls this to display which version is deployed.
async fn version() -> Json<Value> {
    Json(json!({
        "service": "api-gateway",
        "version": VERSION,
        "git_sha": GIT_SHA,
    }))
}

/// GET /health/live — liveness probe: the process is alive.
/// Kubernetes uses this to decide whether to restart the container.
/// Always returns 200 — if the process can handle a request, it's alive.
async fn liveness() -> StatusCode {
    StatusCode::OK
}

/// Readiness response body for the aggregate check.
#[derive(Debug, Serialize, Deserialize)]
struct ReadinessResponse {
    status: String,
    catalog: bool,
    worker: bool,
}

/// GET /health/ready — readiness probe: the service can handle traffic.
/// Returns 200 only when both catalog and worker are reachable.
/// Returns 503 with {"status":"degraded"} when either downstream is down (D-02).
async fn readiness(State(state): State<Arc<AppState>>) -> (StatusCode, Json<ReadinessResponse>) {
    let catalog_ok = check_downstream(&state.http_client, &state.catalog_url).await;
    let worker_ok = check_downstream(&state.http_client, &state.worker_url).await;

    let all_ok = catalog_ok && worker_ok;
    let status = if all_ok { "ready" } else { "degraded" };
    let http_status = if all_ok {
        StatusCode::OK
    } else {
        StatusCode::SERVICE_UNAVAILABLE
    };

    (
        http_status,
        Json(ReadinessResponse {
            status: status.to_string(),
            catalog: catalog_ok,
            worker: worker_ok,
        }),
    )
}

/// GET /api/status — aggregated status for the Svelte dashboard.
/// Collects version + health from both downstream services in parallel.
async fn api_status(State(state): State<Arc<AppState>>) -> Json<Value> {
    let catalog_url = state.catalog_url.clone();
    let worker_url = state.worker_url.clone();
    let client = state.http_client.clone();

    let (catalog_version, worker_version) = tokio::join!(
        fetch_version(&client, &catalog_url),
        fetch_version(&client, &worker_url),
    );

    let (catalog_ready, worker_ready) = tokio::join!(
        check_downstream(&client, &catalog_url),
        check_downstream(&client, &worker_url),
    );

    Json(json!({
        "gateway": {
            "service": "api-gateway",
            "version": VERSION,
            "git_sha": GIT_SHA,
            "status": "ready",
        },
        "catalog": {
            "status": if catalog_ready { "ready" } else { "degraded" },
            "version": catalog_version,
        },
        "worker": {
            "status": if worker_ready { "ready" } else { "degraded" },
            "version": worker_version,
        },
    }))
}

/// Probe a downstream service's /health/ready endpoint with a 3-second timeout.
/// Returns true if the service responds with HTTP 200.
async fn check_downstream(client: &reqwest::Client, base_url: &str) -> bool {
    let url = format!("{}/health/ready", base_url);
    match client
        .get(&url)
        .timeout(std::time::Duration::from_secs(3))
        .send()
        .await
    {
        Ok(resp) => resp.status().is_success(),
        Err(_) => false,
    }
}

/// Fetch version info from a downstream service's /version endpoint.
/// Returns None if the service is unreachable (graceful degradation).
async fn fetch_version(client: &reqwest::Client, base_url: &str) -> Option<String> {
    let url = format!("{}/version", base_url);
    match client
        .get(&url)
        .timeout(std::time::Duration::from_secs(3))
        .send()
        .await
    {
        Ok(resp) if resp.status().is_success() => {
            if let Ok(data) = resp.json::<Value>().await {
                data["version"].as_str().map(|s| s.to_string())
            } else {
                None
            }
        }
        _ => None,
    }
}

fn build_router(state: Arc<AppState>) -> Router {
    Router::new()
        .route("/version", get(version))
        .route("/health/live", get(liveness))
        .route("/health/ready", get(readiness))
        .route("/api/status", get(api_status))
        .layer(CorsLayer::permissive())
        .with_state(state)
}

#[tokio::main]
async fn main() {
    let catalog_url = std::env::var("CATALOG_URL")
        .unwrap_or_else(|_| "http://catalog:8081".to_string());
    let worker_url = std::env::var("WORKER_URL")
        .unwrap_or_else(|_| "http://worker:8082".to_string());

    let state = Arc::new(AppState {
        catalog_url,
        worker_url,
        http_client: reqwest::Client::new(),
    });

    let app = build_router(state);
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    println!("api-gateway listening on 0.0.0.0:8080");
    axum::serve(listener, app).await.unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::body::Body;
    use axum::http::Request;
    use tower::util::ServiceExt;

    fn test_state() -> Arc<AppState> {
        Arc::new(AppState {
            catalog_url: "http://localhost:19999".to_string(), // unreachable port
            worker_url: "http://localhost:19998".to_string(),  // unreachable port
            http_client: reqwest::Client::new(),
        })
    }

    #[tokio::test]
    async fn version_returns_json_with_service_field() {
        let app = build_router(test_state());
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
        assert_eq!(json["service"], "api-gateway");
        assert!(json["version"].is_string());
        assert!(json["git_sha"].is_string());
    }

    #[tokio::test]
    async fn liveness_returns_200() {
        let app = build_router(test_state());
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
    async fn readiness_degraded_when_downstreams_unreachable() {
        let app = build_router(test_state());
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
        assert_eq!(json["catalog"], false);
        assert_eq!(json["worker"], false);
    }

    #[tokio::test]
    async fn readiness_response_has_boolean_downstream_fields() {
        let app = build_router(test_state());
        let response = app
            .oneshot(
                Request::builder()
                    .uri("/health/ready")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();

        let body = axum::body::to_bytes(response.into_body(), usize::MAX)
            .await
            .unwrap();
        let json: Value = serde_json::from_slice(&body).unwrap();
        // Both fields must be present and boolean
        assert!(json["catalog"].is_boolean());
        assert!(json["worker"].is_boolean());
    }
}
