---
phase: 01-foundation
plan: 01
subsystem: infra
tags: [rust, axum, sqlx, postgresql, tokio, cargo-workspace, docker, microservices]

# Dependency graph
requires: []
provides:
  - "Cargo workspace with 4 crates: shared, api-gateway, catalog, worker"
  - "shared crate: VersionInfo and ServiceHealth structs, VERSION and GIT_SHA constants"
  - "api-gateway service (port 8080): /version, /health/live, /health/ready with graceful degradation, /api/status"
  - "catalog service (port 8081): /version, /health/live, /health/ready, /items, /items/{id} — reads from PostgreSQL"
  - "worker service (port 8082): /version, /health/live, /health/ready, POST /events, GET /events/recent — writes to PostgreSQL"
  - "worker background heartbeat loop (60s) generating observable write traffic"
  - "PostgreSQL migration: 001_init.sql creating items + events tables with seed data"
  - "Multi-stage Dockerfiles for all 3 services (rust:1.87-slim builder + debian:bookworm-slim runtime)"
affects: [01-02, 01-03, all-module-labs]

# Tech tracking
tech-stack:
  added:
    - "axum 0.8.8 — Rust HTTP framework"
    - "tokio 1.x — async runtime"
    - "sqlx 0.8.6 — async PostgreSQL client"
    - "reqwest 0.12 — HTTP client for downstream health checks"
    - "tower-http 0.6 — CORS middleware"
    - "serde/serde_json 1 — JSON serialization"
    - "chrono 0.4 — timestamp handling"
    - "uuid 1 — event ID generation (installed)"
  patterns:
    - "Cargo workspace with resolver = 2 for all 4 crates"
    - "Shared library crate pattern for common types (VersionInfo, ServiceHealth)"
    - "Arc<AppState> pattern for handler state sharing"
    - "PgPool::connect_lazy for unit-testable services (no live DB required)"
    - "Multi-stage Docker build with dependency-cache layer"
    - "axum 0.8 path params use {id} syntax (not :id)"
    - "sqlx::query runtime queries (not macros) to avoid compile-time DATABASE_URL requirement"

key-files:
  created:
    - "reference-app/Cargo.toml"
    - "reference-app/services/shared/Cargo.toml"
    - "reference-app/services/shared/src/lib.rs"
    - "reference-app/services/api-gateway/Cargo.toml"
    - "reference-app/services/api-gateway/src/main.rs"
    - "reference-app/services/api-gateway/Dockerfile"
    - "reference-app/services/catalog/Cargo.toml"
    - "reference-app/services/catalog/src/main.rs"
    - "reference-app/services/catalog/Dockerfile"
    - "reference-app/services/catalog/migrations/001_init.sql"
    - "reference-app/services/worker/Cargo.toml"
    - "reference-app/services/worker/src/main.rs"
    - "reference-app/services/worker/Dockerfile"
  modified: []

key-decisions:
  - "Used runtime sqlx::query (not sqlx::query! macros) to avoid DATABASE_URL at compile time"
  - "axum 0.8 path param syntax is {id} not :id — updated catalog route"
  - "PgPool::connect_lazy for test fake pools — tests run without a live database"
  - "axum-test version is 20.x (not 0.9 as in plan) — crate uses major version for breaking changes"
  - "Added tower to dev-deps for ServiceExt::oneshot in unit tests"

patterns-established:
  - "Pattern: All Rust services follow: version()/liveness()/readiness() handler trinity"
  - "Pattern: Health readiness returns {status: 'ready'|'degraded'} with 200/503"
  - "Pattern: Services bind 0.0.0.0 port via TcpListener, port from env or default"
  - "Pattern: Unit tests use fake_pool() via PgPool::connect_lazy for DB services"
  - "Pattern: All services include #[cfg(test)] block with at least 4 unit tests"

requirements-completed: [FOUND-01]

# Metrics
duration: 11min
completed: 2026-04-04
---

# Phase 01 Plan 01: Rust Microservices (api-gateway, catalog, worker) Summary

**Three-service Rust workspace with Axum 0.8 + SQLx 0.8 health checks, PostgreSQL integration, graceful degradation, and 15 passing unit tests**

## Performance

- **Duration:** 11 min
- **Started:** 2026-04-04T16:26:34Z
- **Completed:** 2026-04-04T16:37:30Z
- **Tasks:** 2 of 2 completed
- **Files modified:** 13 created

## Accomplishments

- Cargo workspace with 4 crates compiles from workspace root with zero errors
- api-gateway aggregates downstream health with 3s timeout; returns `degraded` + 503 when either catalog or worker is down
- catalog reads from PostgreSQL via visible `sqlx::query_as` SQL; worker writes via background heartbeat loop every 60s
- 15 unit tests pass: 4 api-gateway, 4 catalog, 4 worker, 3 shared — all without a live database
- All three Dockerfiles use multi-stage builds with correct port EXPOSE declarations

## Task Commits

Each task was committed atomically:

1. **Task 1: Cargo workspace + shared crate + api-gateway** - `778eabd` (feat)
2. **Task 2: catalog service + worker service** - `32da17e` (feat)

## Files Created/Modified

- `reference-app/Cargo.toml` — Workspace configuration with 4 members, resolver = "2"
- `reference-app/services/shared/src/lib.rs` — VersionInfo, ServiceHealth structs; VERSION and GIT_SHA constants
- `reference-app/services/api-gateway/src/main.rs` — HTTP gateway with health aggregation; calls catalog + worker with 3s timeout
- `reference-app/services/api-gateway/Dockerfile` — Multi-stage build, EXPOSE 8080
- `reference-app/services/catalog/src/main.rs` — PostgreSQL reads via sqlx::query_as; /items + /items/{id}
- `reference-app/services/catalog/Dockerfile` — Multi-stage build, EXPOSE 8081
- `reference-app/services/catalog/migrations/001_init.sql` — items + events tables + 5 seed items
- `reference-app/services/worker/src/main.rs` — PostgreSQL writes; POST /events; background heartbeat_loop via tokio::spawn
- `reference-app/services/worker/Dockerfile` — Multi-stage build, EXPOSE 8082

## Decisions Made

- **Runtime SQLx queries**: Used `sqlx::query` / `sqlx::query_as` (not `sqlx::query!` macros) to avoid requiring `DATABASE_URL` at compile time. This is the right tradeoff for a course app — lower setup friction for instructors and CI.
- **axum 0.8 path syntax**: Axum 0.8 uses `{id}` not `:id` for path parameters. Caught and fixed during Task 2 testing.
- **axum-test version**: The `axum-test` crate uses major version bumps (not semver minor) — current is `20.0.0`. Plan specified `0.9`, which doesn't exist. Used `20.0.0`.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] axum-test version mismatch**
- **Found during:** Task 1 (cargo build)
- **Issue:** Plan specified `axum-test = "0.9"` but crate uses major versioning; latest is `20.0.0`
- **Fix:** Changed dev-dependency to `axum-test = "20.0.0"`
- **Files modified:** `reference-app/services/api-gateway/Cargo.toml`
- **Verification:** Build succeeded after correction
- **Committed in:** 778eabd (Task 1 commit)

**2. [Rule 3 - Blocking] Missing tower dev-dependency for ServiceExt**
- **Found during:** Task 1 (cargo test compile error)
- **Issue:** `use tower::ServiceExt` unresolved — tower not in dev-deps; import path wrong
- **Fix:** Added `tower = { version = "0.5", features = ["util"] }` to dev-deps; changed import to `tower::util::ServiceExt`
- **Files modified:** `reference-app/services/api-gateway/Cargo.toml`, `src/main.rs`
- **Verification:** `cargo test --package api-gateway` passes 4 tests
- **Committed in:** 778eabd (Task 1 commit)

**3. [Rule 1 - Bug] axum 0.8 path parameter syntax**
- **Found during:** Task 2 (cargo test panic)
- **Issue:** Route registered as `/items/:id` but axum 0.8 requires `{id}` syntax; panicked with "Path segments must not start with `:`"
- **Fix:** Changed route to `/items/{id}`
- **Files modified:** `reference-app/services/catalog/src/main.rs`
- **Verification:** `cargo test --package catalog` passes all 4 tests
- **Committed in:** 32da17e (Task 2 commit)

---

**Total deviations:** 3 auto-fixed (1 wrong version, 1 missing dep, 1 syntax bug)
**Impact on plan:** All three fixes required for compilation and test correctness. Zero scope creep.

## Issues Encountered

- DB-dependent tests (readiness, items) take ~30s to time out in test mode because they attempt a real TCP connection to the fake pool URL. This is expected behavior — tests pass, just slowly. Production catalog + worker tests should run against a real PgPool (Module 5/6 CI/CD labs).

## Known Stubs

None — all endpoints are fully implemented. DB-connected routes return proper error responses when the database is unreachable rather than stub values.

## User Setup Required

None — no external service configuration required for compilation or unit tests.

## Next Phase Readiness

- Rust workspace ready for Plan 02 (Helm chart packaging)
- All three services compile to release binaries and have Dockerfiles
- PostgreSQL migration in `catalog/migrations/001_init.sql` is ready for Helm chart deployment
- Worker heartbeat loop will generate observable traffic once DB is wired in K8s deployment

---
*Phase: 01-foundation*
*Completed: 2026-04-04*
