# Agentic DevOps Reference App

A purpose-built microservices application used as the hands-on lab target for the **Agentic DevOps** course. It gives participants a realistic multi-service system to practice AI-assisted operations: health monitoring, log triage, database investigation, deployment automation, and observability.

## What it is

The app simulates a small production-grade platform with three backend services, a database, and a live operations dashboard (NovaDeploy). It is intentionally observable — every service exposes structured health endpoints, version metadata, and generates write traffic — so that AI agents have something meaningful to query and reason about.

## Quick Start (pre-built images)

No build step required. Images are published to Docker Hub.

```bash
docker compose up -d
```

| URL | What you see |
|-----|-------------|
| http://localhost:3000 | NovaDeploy operations dashboard |
| http://localhost:8080 | API Gateway |
| http://localhost:8081 | Catalog service |
| http://localhost:8082 | Worker service |
| localhost:5432 | PostgreSQL (`refapp` / `refapp-lab-password` / `refapp`) |

To stop: `docker compose down`

## Docker Hub

Pre-built images are at `schoolofdevops` on Docker Hub:

| Image | Tag |
|-------|-----|
| `schoolofdevops/refapp-gateway` | `1.0.0`, `latest` |
| `schoolofdevops/refapp-catalog` | `1.0.0`, `latest` |
| `schoolofdevops/refapp-worker` | `1.0.0`, `latest` |
| `schoolofdevops/refapp-dashboard` | `1.0.0`, `latest` |

## Architecture

```
Browser
  └── Dashboard (SvelteKit → nginx :3000)
        └── /api-gateway/*  ──proxy──► API Gateway (:8080)
        └── /catalog/*      ──proxy──► Catalog     (:8081)
        └── /worker/*       ──proxy──► Worker      (:8082)

API Gateway (:8080)
  ├── GET /api/status   (aggregates catalog + worker health)
  ├── GET /version
  └── GET /health/live|ready

Catalog (:8081)              Worker (:8082)
  ├── GET /items               ├── POST /events
  ├── GET /items/:id           ├── GET  /events/recent
  ├── GET /version             ├── GET  /version
  └── GET /health/live|ready   └── GET  /health/live|ready
          │                              │
          └──────────┬───────────────────┘
                     ▼
              PostgreSQL :5432
              ├── items   (catalog reads)
              └── events  (worker writes, heartbeat every 60s)
```

### Services

| Service | Port | Language | Role |
|---------|------|----------|------|
| dashboard | 3000 | SvelteKit + nginx | Operations dashboard, proxies API calls to backends |
| api-gateway | 8080 | Rust / Axum | Aggregates catalog + worker health for the dashboard |
| catalog | 8081 | Rust / Axum | Read-only item catalog backed by PostgreSQL |
| worker | 8082 | Rust / Axum | Event writer; background heartbeat loop every 60s |
| postgres | 5432 | PostgreSQL 16 | Single database with `items` and `events` tables |

### Key Design Choices

- **Rust workspace** — all three backend services share a `services/shared` crate that injects `VERSION` and `GIT_SHA` at compile time.
- **Health endpoints** — every service has `/health/live` (process alive) and `/health/ready` (DB connection available). The dashboard polls these every 30 s.
- **Degraded state** — when a service is unreachable the dashboard shows "last known state" rather than crashing. This is intentional for observability labs.
- **Observable write traffic** — the worker writes a heartbeat event every 60 s, giving agents a live data stream to query.
- **Seed data** — the DB migration pre-populates `items` with realistic-looking service names (including one intentionally `degraded`) for agent query labs.

## Prerequisites

- Docker (with Compose V2)
- `make`
- `kind` + `kubectl` + `helm` — required only for Kubernetes deployment

## Deploy with Docker Compose

### Option 1 — Pre-built images (recommended for course participants)

Pulls images from Docker Hub. No Rust toolchain or build time required.

```bash
make compose-up
# or: docker compose up -d
```

### Option 2 — Build from source

Compiles all services locally. Takes several minutes on first build (Rust compilation).

```bash
make compose-build-up
# or: docker compose -f docker-compose.yml -f docker-compose.build.yml up --build -d
```

### How it starts up

```
postgres  ──healthy──► catalog ──┐
                                  ├──► api-gateway ──► dashboard
postgres  ──healthy──► worker  ──┘
```

PostgreSQL must pass its `pg_isready` healthcheck before catalog and worker start. The DB migration (`001_init.sql`) runs automatically via `docker-entrypoint-initdb.d`.

### Resetting the database

```bash
# Remove the pgdata volume to re-run the seed migration
docker compose down -v
docker compose up -d
```

### Rebuilding a single service after code changes

```bash
docker compose -f docker-compose.yml -f docker-compose.build.yml build catalog
docker compose up -d catalog
```

## Deploy on Kubernetes (KIND)

Uses a local KIND cluster with Helm. Includes Prometheus + Grafana for the observability labs.

### One-command deploy

```bash
make deploy
```

This runs the full sequence:

1. `cluster` — creates a KIND cluster named `lab` (idempotent; skips if already exists)
2. `db` — installs PostgreSQL via Bitnami Helm chart into the `db` namespace
3. `monitoring` — installs `kube-prometheus-stack` into the `monitoring` namespace
4. `build` — builds all four Docker images locally
5. `load-images` — loads images into the KIND cluster (bypasses a registry)
6. `app` — installs the `helm/reference-app` chart into the `app` namespace

Once deployed:

| URL | What you see |
|-----|-------------|
| http://localhost:30080 | Operations dashboard |
| http://localhost:30090 | Grafana (admin / admin) |
| http://localhost:30091 | Prometheus |

### Individual steps

```bash
make cluster       # Create KIND cluster only
make db            # Install PostgreSQL
make monitoring    # Install Prometheus + Grafana
make build         # Build Docker images (also tags for Docker Hub)
make publish       # Build + push images to Docker Hub
make load-images   # Load images into KIND
make app           # Deploy the application chart
make status        # Show pod status across all namespaces
make destroy       # Delete the entire KIND cluster
```

## Publishing images

```bash
docker login
make publish
```

Builds all four images, tags as both `1.0.0` and `latest`, and pushes to `schoolofdevops/*` on Docker Hub.

## Project structure

```
reference-app/
├── Cargo.toml                    # Rust workspace root
├── docker-compose.yml            # Default compose (pre-built images)
├── docker-compose.build.yml      # Build override (compile from source)
├── Makefile                      # All deployment commands
├── services/
│   ├── shared/                   # Shared crate: VERSION + GIT_SHA constants
│   ├── api-gateway/              # Rust/Axum service, port 8080
│   │   ├── src/main.rs
│   │   └── Dockerfile
│   ├── catalog/                  # Rust/Axum service, port 8081
│   │   ├── src/main.rs
│   │   ├── migrations/001_init.sql
│   │   └── Dockerfile
│   └── worker/                   # Rust/Axum service, port 8082
│       ├── src/main.rs
│       └── Dockerfile
├── dashboard/                    # SvelteKit SPA
│   ├── src/
│   │   ├── lib/health.ts         # Polling + data fetch logic
│   │   └── routes/+page.svelte   # Dashboard UI
│   ├── nginx.conf                # Serves static build + proxies to backends
│   └── Dockerfile
└── helm/
    └── reference-app/            # Helm chart for K8s deployment
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
```

## API reference

### API Gateway (`localhost:8080`)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Service index with endpoint list |
| GET | `/version` | Build metadata (version, git SHA) |
| GET | `/health/live` | Liveness probe — always 200 |
| GET | `/health/ready` | Readiness — checks downstream reachability |
| GET | `/api/status` | Aggregated status (used by dashboard) |

### Catalog (`localhost:8081`)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Service index |
| GET | `/version` | Build metadata |
| GET | `/health/live` | Liveness probe |
| GET | `/health/ready` | Readiness — checks PostgreSQL |
| GET | `/items` | List all catalog items |
| GET | `/items/:id` | Get single item by ID |

### Worker (`localhost:8082`)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Service index |
| GET | `/version` | Build metadata |
| GET | `/health/live` | Liveness probe |
| GET | `/health/ready` | Readiness — checks PostgreSQL |
| POST | `/events` | Create an event `{source, event_type, payload}` |
| GET | `/events/recent` | Last 50 events |

## Database schema

```sql
-- Catalog reads from this table
CREATE TABLE items (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    status      VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Worker writes to this table; heartbeat every 60s
CREATE TABLE events (
    id          SERIAL PRIMARY KEY,
    source      VARCHAR(100) NOT NULL,
    event_type  VARCHAR(100) NOT NULL,
    payload     JSONB NOT NULL DEFAULT '{}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Connection string: `postgres://refapp:refapp-lab-password@localhost:5432/refapp`
