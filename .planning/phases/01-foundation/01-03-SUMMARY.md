---
phase: 01-foundation
plan: "03"
subsystem: infra
tags: [svelte5, sveltekit, tailwind, helm, kubernetes, kind, prometheus, grafana, github-actions, nginx, docker]

requires:
  - phase: 01-foundation/01-01
    provides: "Rust services (api-gateway:8080, catalog:8081, worker:8082) with /version, /health/live, /health/ready endpoints"

provides:
  - "Svelte 5 health dashboard SPA (SvelteKit + Tailwind CSS) with 30s polling and graceful degradation"
  - "Helm chart packaging all 4 workloads with health probes, resource limits, NodePort for dashboard"
  - "KIND cluster config with port mappings for dashboard (30080), Grafana (30090), Prometheus (30091)"
  - "Prometheus + Grafana lab values (alertmanager disabled, laptop-sized resources)"
  - "make deploy: one-command full stack deployment (cluster + DB + monitoring + images + app)"
  - "GitHub Actions CI/CD: test -> build -> KIND deploy -> verify flow without ArgoCD"

affects:
  - module-5-structured-coding
  - module-6-iac-labs
  - module-9-design-patterns

tech-stack:
  added:
    - "SvelteKit 2.x with adapter-static (SPA mode)"
    - "Svelte 5.x with runes (\$state, \$effect, \$derived)"
    - "Tailwind CSS 4.x via @tailwindcss/vite plugin"
    - "nginx:1.27-alpine for dashboard static serving in K8s"
    - "Helm chart for reference-app (apiVersion: v2)"
    - "kube-prometheus-stack (via prometheus-community Helm chart)"
    - "bitnami/postgresql Helm chart"
    - "helm/kind-action@v1 for CI KIND cluster creation"
  patterns:
    - "SPA fallback: nginx try_files $uri $uri/ /index.html"
    - "nginx proxy_pass using K8s service names as hostnames"
    - "Helm values.yaml with explicit image tags updated by CI/CD (D-04 proof-of-life)"
    - "initContainer for DB migration before catalog container starts"
    - "Svelte 5 $effect with cleanup return for polling intervals"
    - "AbortSignal.timeout(3000) for bounded fetch calls in dashboard"

key-files:
  created:
    - reference-app/dashboard/src/lib/health.ts
    - reference-app/dashboard/src/lib/types.ts
    - reference-app/dashboard/src/routes/+page.svelte
    - reference-app/dashboard/src/routes/+layout.ts
    - reference-app/dashboard/nginx.conf
    - reference-app/dashboard/Dockerfile
    - reference-app/helm/reference-app/Chart.yaml
    - reference-app/helm/reference-app/values.yaml
    - reference-app/helm/reference-app/templates/catalog-deployment.yaml
    - reference-app/helm/reference-app/templates/db-secret.yaml
    - reference-app/helm/reference-app/templates/configmap.yaml
    - reference-app/helm/reference-app/templates/migrations-configmap.yaml
    - infrastructure/kind/cluster-config.yaml
    - infrastructure/helm/prometheus-lab-values.yaml
    - reference-app/Makefile
    - .github/workflows/ci.yml
  modified: []

key-decisions:
  - "No ArgoCD per D-06 — CI/CD pipeline does direct helm upgrade (GitOps taught conceptually in later modules)"
  - "nginx service-name proxy pattern: /api-gateway/*, /catalog/*, /worker/* map to K8s service hostnames"
  - "Svelte 5 runes only — no Svelte 4 stores (research deprecation warning)"
  - "AbortSignal.timeout(3000) mandatory: stalled service must not block dashboard (research Pattern 2)"
  - "initContainer for migration over Kubernetes Job: simpler lifecycle, guaranteed before catalog starts"
  - "SPA mode (ssr=false, prerender=true): dashboard is static file, served by nginx in K8s"

patterns-established:
  - "Helm values.yaml pattern: explicit image tags CI updates via --set service.image.tag=ci"
  - "Dashboard graceful degradation: status='degraded' (yellow border + message), never crash or throw"
  - "All K8s services use ClusterIP except dashboard (NodePort 30080)"
  - "KIND ports: 30080=dashboard, 30090=Grafana, 30091=Prometheus — fixed for all labs"

requirements-completed:
  - FOUND-01
  - FOUND-02
  - FOUND-03
  - FOUND-04

duration: 8min
completed: 2026-04-04
---

# Phase 1 Plan 03: Dashboard, Helm Chart, KIND, and CI/CD Summary

**Svelte 5 SPA health dashboard with 30s polling/graceful degradation, Helm chart packaging 4 workloads with probes, KIND cluster + Prometheus stack, and GitHub Actions test-build-deploy pipeline**

## Performance

- **Duration:** 8 min
- **Started:** 2026-04-04T16:40:51Z
- **Completed:** 2026-04-04T16:49:07Z
- **Tasks:** 3
- **Files modified:** 30

## Accomplishments

- Svelte 5 health dashboard builds as static SPA, polls all 3 services every 30s with 3s timeout, shows graceful degradation (yellow border + "Service Unavailable") instead of crashing, displays version + git SHA per D-04
- Helm chart renders 4 Deployments + 4 Services + 1 Secret + 2 ConfigMaps — `helm lint` passes, `helm template` produces valid manifests for all workloads with liveness/readiness probes
- GitHub Actions pipeline: Rust unit tests first (fast feedback), then Docker build with GIT_SHA, KIND cluster via `helm/kind-action@v1`, local image loading (no Docker Hub), Helm deploy, health verification via port-forward + curl + jq

## Task Commits

Each task was committed atomically:

1. **Task 1: Svelte 5 health dashboard** - `e36a156` (feat)
2. **Task 2: Helm chart + KIND config + Prometheus values + Makefile** - `0926671` (feat)
3. **Task 3: GitHub Actions CI/CD workflow** - `912338c` (feat)

## Files Created/Modified

- `reference-app/dashboard/src/lib/health.ts` — pollServices() with AbortSignal.timeout(3000), graceful degradation, api-gateway downstream dep check
- `reference-app/dashboard/src/lib/types.ts` — ServiceHealth, ServiceStatus, SystemStatus, ServiceConfig types
- `reference-app/dashboard/src/routes/+page.svelte` — Svelte 5 runes dashboard with 3-column Tailwind grid
- `reference-app/dashboard/src/routes/+layout.ts` — SPA mode: ssr=false, prerender=true
- `reference-app/dashboard/nginx.conf` — SPA fallback + proxy_pass to K8s service names
- `reference-app/dashboard/Dockerfile` — multi-stage: node:22-alpine builder + nginx:1.27-alpine runtime
- `reference-app/helm/reference-app/Chart.yaml` — chart metadata (name: reference-app, version: 1.0.0)
- `reference-app/helm/reference-app/values.yaml` — explicit 1.0.0 image tags, dashboard NodePort 30080
- `reference-app/helm/reference-app/templates/catalog-deployment.yaml` — initContainer migration + liveness/readiness probes
- `reference-app/helm/reference-app/templates/db-secret.yaml` — DATABASE_URL + password secret
- `reference-app/helm/reference-app/templates/configmap.yaml` — CATALOG_URL + WORKER_URL
- `reference-app/helm/reference-app/templates/migrations-configmap.yaml` — embedded 001_init.sql
- `infrastructure/kind/cluster-config.yaml` — ports 30080/30090/30091 mapped to host
- `infrastructure/helm/prometheus-lab-values.yaml` — alertmanager disabled, laptop-sized resources
- `reference-app/Makefile` — make deploy: cluster + db + monitoring + build + load-images + app
- `.github/workflows/ci.yml` — test (cargo test) + build-and-deploy (KIND + Helm) CI pipeline

## Decisions Made

- No ArgoCD per D-06 — pipeline does direct `helm upgrade --install` into KIND
- nginx proxies by K8s service name (`http://api-gateway:8080`), not ClusterIP — works in K8s DNS, dev uses vite proxy
- initContainer (not K8s Job) for DB migration — simpler lifecycle, co-located with catalog
- Svelte 5 runes only (`$state`, `$effect`, `$derived`) — research warned against Svelte 4 stores path
- SPA mode forced by static nginx serving — `ssr=false` required or prerender fails on API-polling page

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added missing favicon.png to static/**
- **Found during:** Task 1 (dashboard build)
- **Issue:** Build failed with `[404] GET /favicon.png` — prerender phase requests favicon, 404 causes hard failure
- **Fix:** Generated 1x1 minimal PNG placeholder at `reference-app/dashboard/static/favicon.png`
- **Files modified:** reference-app/dashboard/static/favicon.png
- **Verification:** npm run build exits 0 after fix
- **Committed in:** e36a156 (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** favicon placeholder is a standard SvelteKit requirement. No scope creep.

## Issues Encountered

- Build environment has `rtk` proxy intercepting `grep -q` flags — used Grep tool for file content verification instead of shell grep

## Known Stubs

None. All data flows are wired:
- Dashboard polls real service endpoints via `pollServices()` (not mocked)
- Health data renders from actual fetch results
- Version and git SHA come from `/version` endpoint responses

## Next Phase Readiness

- Reference app fully packaged: dashboard + 3 Rust services + Helm chart + KIND config + Makefile
- Participants can run `make deploy` for complete stack (dashboard + PostgreSQL + Prometheus + Grafana)
- CI/CD pipeline ready to demonstrate in Module 5/6 labs
- Dashboard provides visual proof-of-life when services deploy (version changes visible per D-04)
- Blocked by nothing — Phase 01-02 (setup guide) and 01-04 (mock AWS data) are independent

---
*Phase: 01-foundation*
*Completed: 2026-04-04*
