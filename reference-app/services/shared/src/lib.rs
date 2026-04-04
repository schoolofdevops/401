use serde::{Deserialize, Serialize};

/// Version information returned by every service's GET /version endpoint.
/// Used by the Svelte dashboard to show which version is running (CI/CD proof-of-life).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VersionInfo {
    pub service: String,
    pub version: String,
    pub git_sha: String,
}

/// Health status of a single downstream service, as reported by api-gateway.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ServiceHealth {
    pub name: String,
    pub status: String,
    pub version: Option<String>,
    pub latency_ms: Option<u64>,
}

/// Package version baked in at compile time.
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Git SHA baked in at build time via GIT_SHA env var; falls back to "dev" in local builds.
pub const GIT_SHA: &str = match option_env!("GIT_SHA") {
    Some(sha) => sha,
    None => "dev",
};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn version_info_serializes() {
        let v = VersionInfo {
            service: "api-gateway".to_string(),
            version: "1.0.0".to_string(),
            git_sha: "abc1234".to_string(),
        };
        let json = serde_json::to_string(&v).unwrap();
        assert!(json.contains("\"service\":\"api-gateway\""));
        assert!(json.contains("\"version\":\"1.0.0\""));
        assert!(json.contains("\"git_sha\":\"abc1234\""));
    }

    #[test]
    fn service_health_with_optional_fields() {
        let h = ServiceHealth {
            name: "catalog".to_string(),
            status: "ready".to_string(),
            version: Some("1.0.0".to_string()),
            latency_ms: Some(12),
        };
        let json = serde_json::to_string(&h).unwrap();
        assert!(json.contains("\"name\":\"catalog\""));
        assert!(json.contains("\"latency_ms\":12"));
    }

    #[test]
    fn service_health_none_fields_serialize_null() {
        let h = ServiceHealth {
            name: "worker".to_string(),
            status: "degraded".to_string(),
            version: None,
            latency_ms: None,
        };
        let json = serde_json::to_string(&h).unwrap();
        assert!(json.contains("\"version\":null"));
        assert!(json.contains("\"latency_ms\":null"));
    }
}
