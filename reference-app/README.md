# Agentic DevOps Reference App

A purpose-built microservices application used as the hands-on lab target for the **Agentic DevOps** course. It gives participants a realistic multi-service system to practice AI-assisted operations: health monitoring, log triage, database investigation, deployment automation, and observability.

## What it is

The app simulates a small production-grade platform with three backend services, a database, and a live health dashboard. It is intentionally observable — every service exposes structured health endpoints, version metadata, and generates write traffic — so that AI agents have something meaningful to query and reason about.

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
| dashboard | 3000 | SvelteKit + nginx | Health dashboard UI, proxies API calls to backends |
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

- Docker (with Compose V2) — required for both deployment modes
- `make` — orchestrates all commands
- `kind` + `kubectl` + `helm` — required only for the Kubernetes deployment

## Deploy with Docker Compose

The quickest path. No Kubernetes required.

```bash
# Build all images and start the stack
make compose-up

# Tail logs across all services
make compose-logs

# Tear down (removes containers; PostgreSQL data persists in named volume)
make compose-down
```

Once running:

| URL | What you see |
|-----|-------------|
| http://localhost:3000 | Health dashboard |
| http://localhost:8080 | API Gateway (JSON index + endpoints) |
| http://localhost:8081 | Catalog service |
| http://localhost:8082 | Worker service |
| localhost:5432 | PostgreSQL (`refapp` / `refapp-lab-password` / `refapp`) |

### How it starts up

```
postgres  ──healthy──► catalog ──┐
                                  ├──► api-gateway ──► dashboard
postgres  ──healthy──► worker  ──┘
```

Docker Compose respects `depends_on` health conditions. PostgreSQL must pass its `pg_isready` check before catalog and worker start. The DB migration (`001_init.sql`) runs automatically via `docker-entrypoint-initdb.d`.

### Rebuilding after code changes

```bash
# Rebuild a single service (e.g. after editing catalog)
docker compose build catalog
docker compose up -d catalog

# Force full rebuild (bypasses layer cache)
docker compose build --no-cache
docker compose up -d
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
| http://localhost:30080 | Health dashboard |
| http://localhost:30090 | Grafana (admin / admin) |
| http://localhost:30091 | Prometheus |

### Individual steps

```bash
make cluster       # Create KIND cluster only
make db            # Install PostgreSQL
make monitoring    # Install Prometheus + Grafana
make build         # Build Docker images
make load-images   # Load images into KIND
make app           # Deploy the application chart
make status        # Show pod status across all namespaces
make destroy       # Delete the entire KIND cluster
```

### KIND cluster config

The cluster config is at `../infrastructure/kind/cluster-config.yaml` (relative to this directory). It sets up the node port mappings that expose the dashboard, Grafana, and Prometheus on localhost.

### Helm chart

The chart at `helm/reference-app/` deploys all four application services as Kubernetes Deployments with Services. Key values in `helm/reference-app/values.yaml`:

- Image tags default to `1.0.0` (matches the `IMAGE_TAG` in the Makefile)
- Services are exposed via NodePort for local KIND access
- `DATABASE_URL`, `CATALOG_URL`, and `WORKER_URL` are injected as environment variables

## Project structure

```
reference-app/
├── Cargo.toml                  # Rust workspace root
├── docker-compose.yml          # Docker Compose stack
├── Makefile                    # All deployment commands
├── services/
│   ├── shared/                 # Shared crate: VERSION + GIT_SHA constants
│   ├── api-gateway/            # Rust/Axum service, port 8080
│   │   ├── src/main.rs
│   │   └── Dockerfile
│   ├── catalog/                # Rust/Axum service, port 8081
│   │   ├── src/main.rs
│   │   ├── migrations/001_init.sql
│   │   └── Dockerfile
│   └── worker/                 # Rust/Axum service, port 8082
│       ├── src/main.rs
│       └── Dockerfile
├── dashboard/                  # SvelteKit SPA
│   ├── src/
│   │   ├── lib/health.ts       # Polling logic
│   │   └── routes/+page.svelte # Dashboard UI
│   ├── nginx.conf              # Serves static build + proxies to backends
│   └── Dockerfile
└── helm/
    └── reference-app/          # Helm chart for K8s deployment
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

Connection string (Docker Compose): `postgres://refapp:refapp-lab-password@localhost:5432/refapp`
