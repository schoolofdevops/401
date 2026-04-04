# Phase 1: Foundation - Research

**Researched:** 2026-04-04
**Domain:** Reference microservices app (Svelte + Rust + PostgreSQL on KIND), participant setup guide, mock AWS data, multi-provider LLM docs
**Confidence:** HIGH (architecture and stack), MEDIUM (Svelte 5 graceful-degradation specifics), LOW (OpenCode/Crush distinctions — see User Constraints note)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** The app is a microservices system with a **Svelte dashboard frontend** and **Rust backend services** + PostgreSQL, all running on KIND.
- **D-02:** The dashboard must show: service health/connectivity status, version info for each service, and graceful degradation when backends are unavailable (show degraded state, not crash).
- **D-03:** The app must include **tests** (unit + integration) to power the CI/CD pipeline labs in Modules 5-6.
- **D-04:** Version display must update visibly on deploy — participants can SEE when their CI/CD pipeline works.
- **D-05:** Participants do NOT modify Rust code directly — they interact via APIs, Helm charts, K8s manifests, CI/CD pipelines.
- **D-06:** KIND cluster with the reference app deployed. No ArgoCD — too heavy for local setup. GitOps concepts taught without it.
- **D-07:** **Prometheus + Grafana** pre-installed on KIND as the default observability stack. Agents can query Prometheus API directly.
- **D-08:** **Datadog free tier** documented as an alternative observability path. Both paths supported.
- **D-09:** Basic KIND config for Day 1. Module 5-6 labs may add complexity as part of the learning progression.
- **D-10:** Mock data for AWS services as **fallback only** — clearly labeled, realistic format matching current AWS CLI output.
- **D-11:** Three AWS services get mock data: **CloudWatch alarms**, **Cost Explorer**, **EC2 instances**.
- **D-12:** NO mock RDS data — real PostgreSQL on KIND replaces this. Database agents query the live DB.
- **D-13:** Format: **static JSON files** with source-and-date comments. Both clean and noisy/anomaly scenarios included.
- **D-14:** Two equal paths documented with full setup guides: **Claude Code** (Claude Pro/Team subscription) and **OpenCode** (with free providers: Gemini, Groq, OpenRouter, Grok).
- **D-15:** NO Crush — the course uses Claude Code and OpenCode only. Override research finding about OpenCode being archived.
- **D-16:** Labs show expected outputs for BOTH paths. Not Claude Code screenshots only.

### Claude's Discretion

- Claude designs the specific 2-3 Rust backend services. Optimize for:
  - Demonstrating K8s patterns (health checks, inter-service dependencies, scaling, graceful degradation)
  - Generating real PostgreSQL queries that database agents can investigate
  - Natural scaling challenges and failure modes for observability labs

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| FOUND-01 | Reference microservices app (2-3 services + PostgreSQL) deployable on KIND | Svelte 5 + Axum 0.8 + SQLx 0.8 + KIND v0.27; service design documented in Architecture Patterns |
| FOUND-02 | Helm chart packaging for the reference app (Module 5 and Module 6 Track B) | Helm 3.18 confirmed installed; chart structure documented in Architecture Patterns |
| FOUND-03 | CI/CD pipeline (GitHub Actions) for the reference app — build, test, deploy to KIND | GitHub Actions patterns for Rust/Svelte builds; test framework for Rust (built-in cargo test) |
| FOUND-04 | ArgoCD GitOps setup — **NOTE: CONTEXT.md overrides REQUIREMENTS.md** — No ArgoCD per D-06 | D-06 removes ArgoCD from scope; GitOps concepts taught conceptually instead |
| FOUND-05 | Participant setup guide: Claude Code, OpenCode, KIND + Docker, AWS CLI, multi-provider LLM config | Setup guide scope documented; OpenCode (not Crush) per D-15; existing setup/ partially covers Hermes labs — needs new course-specific content |
| FOUND-06 | Environment verification script (verify.sh) that validates all prerequisites | Existing verify.sh is Hermes-focused; needs new course-focused variant or update |
| FOUND-07 | Mock data: CloudWatch alarms, Cost Explorer, EC2 (real AWS preferred, mock as fallback) | Existing mock-data in infrastructure/ covers RDS and K8s; CloudWatch alarms JSON is missing — needs to be added; EC2 and Cost Explorer already exist |
| FOUND-08 | Multi-provider LLM access documentation — each provider with rate limits and fallback guidance | OpenCode (not Crush per D-15) + Claude Code; rate limits documented with LOW confidence caveat |
</phase_requirements>

---

## Summary

Phase 1 builds the shared foundation that all module labs depend on: a reference microservices application, a participant setup guide, AWS mock data, and multi-provider LLM documentation. Research reveals the current repo already has substantial infrastructure from Hermes-focused work — mock data for RDS, Kubernetes, and Cost Explorer already exists in `infrastructure/mock-data/`; a KIND setup guide exists in `setup/setup-kind.md`; and a Hermes-centric `verify.sh` exists. Phase 1 work is therefore partly greenfield (the reference app itself, the Svelte dashboard, Helm chart, CI/CD, CloudWatch alarm mock data) and partly adaptation (updating verify.sh to be course-focused, creating the OpenCode + Claude Code setup guide distinct from the Hermes install guide).

The reference app design decision (Svelte dashboard + Rust backends + PostgreSQL on KIND) is well-supported by the current tool ecosystem. Svelte 5 with runes-based reactivity is the current stable release (5.55.1). Axum 0.8.8 is the current stable Rust web framework. The service architecture recommendation is a **3-service design**: (1) an `api-gateway` service that proxies/aggregates, (2) a `catalog` service that reads from PostgreSQL, and (3) a `worker` service that performs background database writes. This creates natural inter-service dependency chains, observable slow queries, and graceful degradation failure modes — all directly useful for observability and agent labs.

A critical constraint note: CONTEXT.md D-15 explicitly directs use of **OpenCode** (not Crush) for the alternative LLM path. However, per STACK.md research, opencode-ai/opencode was archived September 18, 2025, and the SST team created a fresh fork (`sst/opencode`) that is actively maintained with 95K+ stars. This is distinct from `charmbracelet/crush`. The planner must use `opencode.ai` (the SST-maintained fork) as the "OpenCode" path — this is the current live product with active documentation at opencode.ai.

**Primary recommendation:** Build the reference app (3 Rust services + Svelte dashboard + PostgreSQL) deployable with a single `make deploy` command, pre-load KIND with kube-prometheus-stack for Prometheus + Grafana, and write a course-specific SETUP.md + verify.sh that validates both Claude Code and OpenCode paths.

---

## Standard Stack

### Core — Reference Application

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Svelte | 5.55.1 | Dashboard UI framework | Current stable; runes syntax simplifies reactive polling; smaller bundle than React/Vue; excellent for monitoring-style UIs |
| SvelteKit | 2.56.1 | Svelte application framework | Handles routing, SSR, dev server; course uses SPA mode (no server rendering needed for a local health dashboard) |
| Vite | 8.0.3 | Build tooling (bundled with SvelteKit) | Zero-config for SvelteKit; fast HMR during dev |
| Axum | 0.8.8 | Rust HTTP web framework | Most widely used Rust web framework; idiomatic async with Tokio; excellent K8s health check patterns |
| Tokio | 1.x | Async runtime for Rust | Standard async runtime; required by Axum |
| SQLx | 0.8.6 (stable) | Async Postgres client for Rust | Compile-time checked queries; no ORM complexity; direct SQL that agents can read |
| PostgreSQL | 16.x | Relational database | Deployed via official Helm chart on KIND; real queries for database agent labs |

### Supporting — Kubernetes and Observability

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| KIND | v0.27.0 | Local Kubernetes cluster | Always — the only K8s runtime for Day 1 setup |
| kubectl | 1.32.x | Cluster interaction CLI | Standard; ships with KIND node images |
| Helm | 3.18.4 | Kubernetes package manager | Deploying reference app + Prometheus stack |
| kube-prometheus-stack | 82.16.1 | Prometheus + Grafana on K8s | Pre-installs both with pre-configured dashboards; one helm command |
| postgresql Helm chart | bitnami/postgresql latest | PostgreSQL on KIND | Bitnami chart is standard; persistent volume, built-in secrets |

### Supporting — Participant Tooling

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Claude Code | Current via Claude subscription | Primary agent path | Claude Pro/Team subscribers |
| OpenCode (sst/opencode) | Latest from opencode.ai | Alternative multi-provider path | Participants without Claude subscription; free provider labs |
| AWS CLI v2 | Latest v2 | Real AWS connections and mock-aws wrapper | Required for mock-aws wrapper PATH trick |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Svelte 5 | React | React is more familiar to frontend devs but heavier; Svelte's compile-time reactivity makes the polling health dashboard code much simpler to read as a teaching artifact |
| Axum | Actix-web | Actix is faster in benchmarks; Axum has better ergonomics and more examples for K8s health check patterns |
| SQLx | SeaORM / Diesel | ORMs hide the SQL; agents need to read real queries; SQLx keeps queries visible |
| kube-prometheus-stack | Manual Prometheus + Grafana | The stack helm chart installs everything pre-configured with ServiceMonitor CRDs; single command is important for Day 1 setup friction |

**Installation:**

```bash
# Frontend
npm create svelte@latest dashboard
cd dashboard && npm install

# Helm charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# OpenCode
brew install sst/tap/opencode   # macOS
# OR: curl -fsSL https://opencode.ai/install.sh | sh
```

**Version verification (confirmed 2026-04-04):**

| Package | Verified Version | Source |
|---------|-----------------|--------|
| svelte | 5.55.1 | `npm view svelte version` |
| @sveltejs/kit | 2.56.1 | `npm view @sveltejs/kit version` |
| vite | 8.0.3 | `npm view vite version` |
| axum | 0.8.8 | crates.io registry |
| sqlx | 0.8.6 | crates.io registry (0.9.0-alpha.1 exists — do not use) |
| kube-prometheus-stack | 82.16.1 | Artifact Hub |
| kind | v0.27.0 | Installed on this machine |
| helm | 3.18.4 | Installed on this machine |

---

## Architecture Patterns

### Recommended Project Structure

```
course/
├── setup/
│   ├── SETUP.md                    # NEW: Course-specific participant setup (Claude Code + OpenCode)
│   ├── verify.sh                   # EXISTING but Hermes-focused — needs course variant
│   ├── setup-kind.md               # EXISTING: KIND setup guide (reusable)
│   ├── llm-access.md               # EXISTING: Hermes LLM guide (reference only, not course primary)
│   └── install-hermes.md           # EXISTING: Hermes-specific (not Phase 1 scope)
│
├── reference-app/                  # NEW: The reference microservices application
│   ├── Makefile                    # Single-command deploy: make deploy
│   ├── services/
│   │   ├── api-gateway/            # Rust (Axum) — aggregates + proxies
│   │   │   ├── src/
│   │   │   ├── Cargo.toml
│   │   │   └── Dockerfile
│   │   ├── catalog/                # Rust (Axum + SQLx) — reads from PostgreSQL
│   │   │   ├── src/
│   │   │   ├── Cargo.toml
│   │   │   └── Dockerfile
│   │   └── worker/                 # Rust (Axum + SQLx) — background writes to PostgreSQL
│   │       ├── src/
│   │       ├── Cargo.toml
│   │       └── Dockerfile
│   ├── dashboard/                  # Svelte 5 + SvelteKit
│   │   ├── src/
│   │   │   ├── routes/
│   │   │   │   └── +page.svelte    # Main health dashboard
│   │   │   └── lib/
│   │   │       └── health.ts       # Polling logic with graceful degradation
│   │   ├── package.json
│   │   └── Dockerfile
│   └── helm/
│       └── reference-app/          # Helm chart (FOUND-02)
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── api-gateway-deployment.yaml
│               ├── catalog-deployment.yaml
│               ├── worker-deployment.yaml
│               ├── dashboard-deployment.yaml
│               └── ...
│
├── infrastructure/
│   ├── mock-data/
│   │   ├── cloudwatch/             # NEW: CloudWatch alarm JSON (missing today)
│   │   │   ├── describe-alarms-clean.json
│   │   │   └── describe-alarms-anomaly.json
│   │   ├── cost-explorer/          # EXISTING: normal-spend.json, anomaly-spike.json, ec2-instances.json
│   │   ├── kubernetes/             # EXISTING: get-pods-*.json, describe-pod-oom.json
│   │   └── rds/                    # EXISTING (not Phase 1 scope per D-12)
│   └── wrappers/
│       ├── mock-aws                # EXISTING: extend to include cloudwatch describe-alarms
│       ├── mock-kubectl            # EXISTING
│       └── mock-psql               # EXISTING
│
└── kind/
    └── cluster-config.yaml         # NEW: KIND cluster with port mappings for dashboard + grafana
```

### Pattern 1: 3-Service Microservices Design

**What:** Three Rust services with explicit dependency chain: `dashboard → api-gateway → catalog/worker → PostgreSQL`.

**Rationale for this specific design:**

| Service | K8s Pattern Demonstrated | Observability Value | Failure Mode |
|---------|--------------------------|---------------------|--------------|
| `api-gateway` (port 8080) | Readiness probe depends on downstream services | Connection pool metrics, request latency | Graceful degradation when catalog/worker down |
| `catalog` (port 8081) | Startup probe + slow query injection | PostgreSQL query duration, row count | Slow queries visible in Prometheus; detectable by database agents |
| `worker` (port 8082) | CronJob-style background writer | Write throughput, error rate | OOM when write backlog grows; visible in K8s events |

**Version endpoint pattern:** Every service exposes `GET /version` returning `{"service": "catalog", "version": "1.2.0", "git_sha": "abc1234", "built_at": "2026-04-04T10:00:00Z"}`. The Svelte dashboard polls this every 30 seconds. When a new image deploys, the version changes — participants see it immediately. This is the CI/CD proof-of-life.

**When to use:** This 3-service pattern always. Do not collapse into 2 services (loses the aggregation layer that demonstrates inter-service dependencies).

**Example — Axum health check with dependency checking:**
```rust
// Source: Axum 0.8 docs + oneuptime.com/blog/post/2026-01-07-rust-kubernetes-health-checks
use axum::{extract::State, http::StatusCode, response::Json};
use serde_json::{json, Value};

// GET /health/live — always returns 200 (process is running)
pub async fn liveness() -> StatusCode {
    StatusCode::OK
}

// GET /health/ready — checks downstream dependencies
pub async fn readiness(State(state): State<AppState>) -> (StatusCode, Json<Value>) {
    let db_ok = state.db_pool.acquire().await.is_ok();
    let downstream_ok = check_downstream(&state.catalog_url).await;

    if db_ok && downstream_ok {
        (StatusCode::OK, Json(json!({"status": "ready"})))
    } else {
        (StatusCode::SERVICE_UNAVAILABLE, Json(json!({
            "status": "degraded",
            "database": db_ok,
            "catalog": downstream_ok
        })))
    }
}
```

### Pattern 2: Svelte 5 Health Dashboard with Graceful Degradation

**What:** Svelte 5 runes-based polling that shows degraded state (not error) when a backend is unreachable.

**Example — health polling with graceful degradation:**
```typescript
// Source: Svelte 5 docs, dev.to/polliog/real-world-svelte-5
// src/lib/health.ts
export type ServiceStatus = 'healthy' | 'degraded' | 'unknown';

export interface ServiceHealth {
  name: string;
  status: ServiceStatus;
  version?: string;
  latency_ms?: number;
}

// +page.svelte
<script lang="ts">
  import type { ServiceHealth } from '$lib/health';

  let services: ServiceHealth[] = $state([
    { name: 'api-gateway', status: 'unknown' },
    { name: 'catalog', status: 'unknown' },
    { name: 'worker', status: 'unknown' },
  ]);

  $effect(() => {
    const poll = async () => {
      for (const svc of services) {
        try {
          const res = await fetch(`/api/${svc.name}/health/ready`, { signal: AbortSignal.timeout(3000) });
          const data = await res.json();
          svc.status = res.ok ? 'healthy' : 'degraded';
          svc.version = data.version;
        } catch {
          svc.status = 'degraded'; // never crash — show degraded state
        }
      }
    };
    poll();
    const interval = setInterval(poll, 30_000);
    return () => clearInterval(interval);
  });
</script>
```

**Critical design requirement:** The `fetch` call MUST use `AbortSignal.timeout(3000)` to cap polling wait time. Without it, stalled services make the dashboard unresponsive — participants lose visibility exactly when they need it most (during failure injection exercises).

### Pattern 3: KIND Cluster with Pre-installed Observability

**What:** A KIND config that mounts extra ports for dashboard access + Grafana, with Prometheus and Grafana installed via Helm.

**Example — kind-config.yaml:**
```yaml
# infrastructure/kind/cluster-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: lab
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 30080  # dashboard NodePort
        hostPort: 30080
        protocol: TCP
      - containerPort: 30090  # Grafana NodePort
        hostPort: 30090
        protocol: TCP
      - containerPort: 30091  # Prometheus NodePort
        hostPort: 30091
        protocol: TCP
networking:
  apiServerAddress: "127.0.0.1"  # Security: bind to loopback only
```

**Deploy command sequence:**
```bash
# One-command deploy (via Makefile)
make deploy
# Which runs:
kind create cluster --config infrastructure/kind/cluster-config.yaml
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30090 \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
helm upgrade --install reference-app ./reference-app/helm/reference-app \
  --namespace app --create-namespace
```

### Pattern 4: CloudWatch Alarm Mock Data Structure

**What:** Static JSON matching current AWS CLI output format for `aws cloudwatch describe-alarms`.

**Critical detail:** The existing `mock-aws` wrapper handles `cloudwatch describe-alarms` with an empty response (`{"MetricAlarms":[]}`). Phase 1 must replace this with a real mock that matches Module 1 lab requirements (CloudWatch alarm with realistic alert data for context engineering exercises).

**Required structure (verified against AWS CloudWatch API docs):**
```json
{
  "MetricAlarms": [
    {
      "AlarmName": "HighCPUUtilization",
      "AlarmDescription": "CPU utilization exceeded 85% for 5 consecutive minutes",
      "AlarmArn": "arn:aws:cloudwatch:us-east-1:123456789012:alarm:HighCPUUtilization",
      "StateValue": "ALARM",
      "StateReason": "Threshold Crossed: 1 out of the last 1 datapoints [87.3 (04/04/26 09:15:00)] was greater than the threshold (85.0).",
      "MetricName": "CPUUtilization",
      "Namespace": "AWS/EC2",
      "Dimensions": [{"Name": "InstanceId", "Value": "i-0abc123def456789a"}],
      "Period": 300,
      "EvaluationPeriods": 1,
      "Threshold": 85.0,
      "ComparisonOperator": "GreaterThanThreshold"
    }
  ]
}
```

**Note:** The file MUST include a source comment at the top:
```
# Mock format: aws cloudwatch describe-alarms as of 2026-04-04 AWS CLI v2
# Source: https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/describe-alarms.html
# Sanitized: AccountId=123456789012, Region=us-east-1
```

### Pattern 5: Helm Chart for Reference App (FOUND-02)

**What:** A single Helm chart that packages all four workloads (api-gateway, catalog, worker, dashboard) with values.yaml overrides for image tags.

**Key design requirement for CI/CD demo (D-04):** The chart's `values.yaml` must include explicit image tag values. When the CI/CD pipeline runs and updates the tag, participants do `helm upgrade` and see the new version appear in the dashboard. This is the proof-of-life mechanism.

```yaml
# helm/reference-app/values.yaml
apiGateway:
  image:
    repository: localhost:5001/api-gateway
    tag: "1.0.0"   # CI/CD pipeline updates this value

catalog:
  image:
    repository: localhost:5001/catalog
    tag: "1.0.0"
```

### Anti-Patterns to Avoid

- **Anti-pattern: Exposing Prometheus via LoadBalancer** — KIND doesn't have a cloud load balancer. Use NodePort with fixed port assignments instead. Service of type LoadBalancer will stay in Pending state forever on KIND.
- **Anti-pattern: Single-service "monolith"** — A single Rust service doesn't demonstrate inter-service dependencies. The 3-service design creates the observable patterns labs need.
- **Anti-pattern: Svelte with fetch inside a `$derived`** — Async operations belong in `$effect`, not `$derived`. Derived values should be synchronous transformations of state.
- **Anti-pattern: `docker push` to Docker Hub in CI for course labs** — Use a local KIND registry (`localhost:5001`) or `kind load docker-image`. Docker Hub rate limits (100 pulls/6h for unauthenticated) will block participants simultaneously running CI.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Kubernetes monitoring stack | Custom Prometheus + Grafana manifests | `kube-prometheus-stack` Helm chart | The chart includes pre-built dashboards, ServiceMonitor CRDs, AlertManager config, RBAC — 500+ lines of YAML replaced by one `helm install` |
| PostgreSQL on KIND | Custom StatefulSet + PVC + Secret manifests | `bitnami/postgresql` Helm chart | Bitnami chart handles PV creation, password secrets, init scripts — saves 2+ hours of K8s storage debugging |
| Build-and-push for KIND | Full Docker Hub push in CI | `kind load docker-image` or local registry | KIND can import local images directly; no external registry needed for labs |
| Token economics per provider | Custom rate-limit tracking | Document static limits with "verify before delivery" note | Provider limits change faster than course updates; document the current value with a verification URL |
| CSS for dashboard | Hand-written CSS | Tailwind CSS (via SvelteKit) or DaisyUI | The dashboard needs to be "nice looking" (per SPECIFICS). A utility CSS framework produces a professional UI without custom CSS writing time |

**Key insight:** The most expensive custom solutions in this domain are K8s observability setup (Prometheus + Grafana from scratch) and PostgreSQL HA setup. The Helm charts for both are production-grade and take 5 minutes to install vs. 2-3 days to build correctly.

---

## Common Pitfalls

### Pitfall 1: verify.sh Hermes Coupling

**What goes wrong:** The existing `setup/verify.sh` checks for `hermes` CLI, `hermes login`, and Hermes skill files. Running it for a Phase 1 participant (who hasn't installed Hermes yet) will fail on every Hermes-specific check and confuse participants.

**Why it happens:** verify.sh was written for the hermes-agent module labs, not the course foundation setup.

**How to avoid:** Create a NEW `setup/SETUP.md` and a new course-specific verify script (or a refactored verify.sh with `--mode course` flag) that checks: Docker, KIND, kubectl, Helm, AWS CLI, Claude Code, and OpenCode — but NOT Hermes, not Hermes skill files, not the existing mock-data that is RDS/Hermes-specific.

**Warning signs:** A participant fresh to Day 1 runs verify.sh and sees FAIL on "hermes installed" — before Hermes is even introduced.

### Pitfall 2: Missing CloudWatch Alarm Mock Data

**What goes wrong:** The existing `mock-aws` wrapper returns `{"MetricAlarms":[]}` for `cloudwatch describe-alarms`. Module 1 lab (MOD1-01 and MOD1-02) requires a real CloudWatch alarm JSON with meaningful content for the context engineering exercises. A participant running the lab gets an empty response and can't proceed.

**Why it happens:** The existing mock-aws was built for RDS/cost-focused Hermes labs. CloudWatch alarms were not needed there.

**How to avoid:** Create `infrastructure/mock-data/cloudwatch/describe-alarms-clean.json` and `describe-alarms-anomaly.json`, then update the mock-aws wrapper to route `cloudwatch describe-alarms` to these files (clean vs anomaly based on HERMES_LAB_SCENARIO). Both scenarios required per CONTEXT.md D-13.

**Warning signs:** `HERMES_LAB_MODE=mock mock-aws cloudwatch describe-alarms` returns `{"MetricAlarms":[]}`.

### Pitfall 3: OpenCode vs Crush Confusion

**What goes wrong:** The existing STACK.md research recommends Crush (charmbracelet/crush) as the successor to archived OpenCode. CONTEXT.md D-15 explicitly says use OpenCode only. The planner must understand there are now TWO separate projects called "OpenCode":
  1. `opencode-ai/opencode` — archived September 18, 2025
  2. `sst/opencode` — an active fork, maintained by the SST team, with 95K+ GitHub stars, documented at opencode.ai

**Why it happens:** The research was done before the SST fork became the dominant active OpenCode project.

**How to avoid:** The course uses `sst/opencode` (opencode.ai) as the "OpenCode" path. Installation is `brew install sst/tap/opencode` or `curl -fsSL https://opencode.ai/install.sh | sh`. This is NOT Crush (charmbracelet/crush). Setup documentation must use the opencode.ai URL, not the archived opencode-ai/opencode or charmbracelet/crush.

**Warning signs:** Any setup doc pointing to `github.com/opencode-ai/opencode` (archived) or `github.com/charmbracelet/crush` (different product).

### Pitfall 4: KIND NodePort vs LoadBalancer for Services

**What goes wrong:** Helm charts default to `service.type: ClusterIP` or `LoadBalancer`. LoadBalancer on KIND stays in Pending forever (no cloud load balancer controller). ClusterIP requires kubectl port-forward, which breaks when the terminal closes.

**Why it happens:** Helm chart defaults are designed for production cloud environments.

**How to avoid:** All services in the reference app Helm chart use `service.type: NodePort` with fixed ports (`nodePort: 30080` for dashboard, etc.) matching the KIND `extraPortMappings`. Document `http://localhost:30080` as the dashboard URL. This is stable across terminal restarts.

**Warning signs:** Participants run `helm install` and then cannot access the dashboard at any URL.

### Pitfall 5: Prometheus Stack Too Heavy for Default KIND Config

**What goes wrong:** kube-prometheus-stack installs Prometheus, Grafana, AlertManager, node-exporter, kube-state-metrics, and multiple operators. Default resource requests total ~2GB RAM. On a developer laptop with Docker Desktop set to 4GB RAM, there's not enough headroom for the app services too.

**Why it happens:** kube-prometheus-stack defaults are for production clusters.

**How to avoid:** Provide a `values-lab.yaml` for the Prometheus stack that sets reduced resource requests and disables non-essential components:
```yaml
# infrastructure/helm/prometheus-lab-values.yaml
alertmanager:
  enabled: false  # not needed for labs
nodeExporter:
  resources:
    requests: { cpu: 10m, memory: 32Mi }
prometheus:
  prometheusSpec:
    resources:
      requests: { cpu: 100m, memory: 256Mi }
grafana:
  resources:
    requests: { cpu: 50m, memory: 128Mi }
```

**Warning signs:** `kubectl get pods -n monitoring` shows pods in `Pending` state due to resource constraints.

### Pitfall 6: Svelte SPA Mode vs SSR for K8s Dashboard

**What goes wrong:** SvelteKit defaults to SSR (server-side rendering). The health dashboard has no backend to run Node.js server processes inside the K8s cluster — it's a static frontend calling backend APIs. SSR requires a Node server.

**Why it happens:** SvelteKit's default adapter is `@sveltejs/adapter-auto` which enables SSR.

**How to avoid:** Configure the dashboard with `@sveltejs/adapter-static` and `export const prerender = true` / `export const ssr = false` in the root layout. The dashboard Dockerfile then serves the built static files via nginx or a lightweight static server. This is simpler to containerize and easier for participants to understand.

### Pitfall 7: GitHub Actions KIND Setup Complexity

**What goes wrong:** CI/CD pipeline for the reference app needs to build Rust images, run tests, create a KIND cluster, deploy with Helm, and verify health. This is a complex GitHub Actions workflow. If each step isn't well-isolated, failures are hard to debug.

**Why it happens:** Local dev and CI environments differ — local has already-built Docker layers and a warm cluster.

**How to avoid:** Use `kind-action` (official GitHub Action) for cluster creation. Use `docker buildx` with layer caching. Run Rust tests BEFORE building the Docker image (cargo test runs in ~30 seconds; building the image takes longer and fails if tests fail). Structure the workflow as: test → build → push-to-kind-registry → deploy → verify-health.

---

## Code Examples

Verified patterns from official sources and current tooling:

### Rust Axum Service with Version and Health Endpoints

```rust
// Source: Axum 0.8 docs (docs.rs/axum/0.8.8) + health check patterns
// services/catalog/src/main.rs — core structure

use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde_json::{json, Value};
use sqlx::PgPool;

#[derive(Clone)]
struct AppState {
    db: PgPool,
    version: &'static str,
    git_sha: &'static str,
}

// GET /version — the CI/CD proof-of-life endpoint
async fn version(State(s): State<AppState>) -> Json<Value> {
    Json(json!({
        "service": "catalog",
        "version": s.version,
        "git_sha": s.git_sha,
    }))
}

// GET /health/live — liveness probe (process is running)
async fn liveness() -> StatusCode { StatusCode::OK }

// GET /health/ready — readiness probe (database reachable)
async fn readiness(State(s): State<AppState>) -> (StatusCode, Json<Value>) {
    match s.db.acquire().await {
        Ok(_) => (StatusCode::OK, Json(json!({"status": "ready"}))),
        Err(_) => (StatusCode::SERVICE_UNAVAILABLE, Json(json!({"status": "degraded"}))),
    }
}

// GET /items — real PostgreSQL query agents can investigate
async fn list_items(State(s): State<AppState>) -> Json<Value> {
    let items = sqlx::query!("SELECT id, name, created_at FROM items ORDER BY created_at DESC LIMIT 100")
        .fetch_all(&s.db)
        .await
        .unwrap_or_default();
    Json(json!({"items": items.iter().map(|r| json!({"id": r.id, "name": r.name})).collect::<Vec<_>>()}))
}

#[tokio::main]
async fn main() {
    let db = PgPool::connect(&std::env::var("DATABASE_URL").unwrap()).await.unwrap();
    let state = AppState {
        db,
        version: env!("CARGO_PKG_VERSION"),
        git_sha: option_env!("GIT_SHA").unwrap_or("dev"),
    };
    let app = Router::new()
        .route("/version", get(version))
        .route("/health/live", get(liveness))
        .route("/health/ready", get(readiness))
        .route("/items", get(list_items))
        .with_state(state);
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8081").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

### Kubernetes Deployment with Probes (Helm Template)

```yaml
# Source: Kubernetes docs + Axum health check patterns (oneuptime.com, Jan 2026)
# helm/reference-app/templates/catalog-deployment.yaml
containers:
  - name: catalog
    image: "{{ .Values.catalog.image.repository }}:{{ .Values.catalog.image.tag }}"
    ports:
      - containerPort: 8081
    livenessProbe:
      httpGet:
        path: /health/live
        port: 8081
      initialDelaySeconds: 5
      periodSeconds: 10
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /health/ready
        port: 8081
      initialDelaySeconds: 10
      periodSeconds: 15
      failureThreshold: 2
    env:
      - name: DATABASE_URL
        valueFrom:
          secretKeyRef:
            name: catalog-db-secret
            key: url
      - name: GIT_SHA
        value: "{{ .Values.catalog.image.tag }}"
```

### GitHub Actions Workflow — Build + Deploy to KIND

```yaml
# Source: kind-action official docs + GitHub Actions cache patterns
# .github/workflows/ci.yml
name: Reference App CI
on: [push]
jobs:
  test-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache Rust dependencies
        uses: Swatinem/rust-cache@v2
        with:
          workspaces: "reference-app/services"

      - name: Run Rust tests (all services)
        run: |
          for svc in api-gateway catalog worker; do
            cargo test --manifest-path reference-app/services/$svc/Cargo.toml
          done

      - name: Build Docker images
        run: |
          docker build -t catalog:ci reference-app/services/catalog/

      - name: Create KIND cluster
        uses: helm/kind-action@v1
        with:
          config: infrastructure/kind/cluster-config.yaml

      - name: Load images into KIND
        run: kind load docker-image catalog:ci

      - name: Deploy with Helm
        run: |
          helm upgrade --install reference-app reference-app/helm/reference-app \
            --set catalog.image.tag=ci

      - name: Verify health
        run: |
          kubectl wait --for=condition=ready pod -l app=catalog --timeout=120s
          curl -f http://localhost:30080/health/ready
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| OpenCode (opencode-ai) as multi-provider CLI | sst/opencode (opencode.ai fork) | Sept 2025 | D-15 requires "OpenCode" — this is the sst/opencode active fork, not charmbracelet/crush |
| Svelte 3/4 with reactive declarations (`$: ...`) | Svelte 5 with runes (`$state`, `$effect`, `$derived`) | Svelte 5 stable Oct 2024 | Simpler polling code; more explicit reactivity — better as a teaching artifact |
| LocalStack as AWS mock | Static JSON fixtures + mock-aws wrapper | March 2026 (LocalStack community EOL) | Already implemented in this repo; extend for CloudWatch alarms |
| Gemini 2.0 Flash | Gemini 2.5 Flash | Feb 2026 | All OpenCode/Gemini references must use `gemini-2.5-flash` |

**Deprecated/outdated:**

- `opencode-ai/opencode` (GitHub): Archived September 18, 2025. Do NOT reference this URL.
- `charmbracelet/crush`: A separate product — NOT the same as opencode.ai. CONTEXT.md D-15 says use OpenCode, not Crush.
- `LocalStack community Docker image` (unauthenticated): EOL March 23, 2026. Do not add LocalStack as a lab dependency.
- `Svelte 4 store pattern` (`writable`, `readable`): Replaced by Svelte 5 runes. Do not write `import { writable } from 'svelte/store'` in new code.

---

## Open Questions

1. **OpenCode provider: does Grok require API key or can it be used via OAuth?**
   - What we know: CONTEXT.md D-14 lists "Grok" as one of the OpenCode free providers
   - What's unclear: As of 2026-04-04, xAI (Grok) requires an API key from console.x.ai; it is not available via subscription without a key. It may have limited free tier.
   - Recommendation: Test before finalizing the setup guide. If Grok requires payment, document it as "optional" in the free provider list. Use Gemini 2.5 Flash and Groq (llama) as the primary free providers.

2. **Should the reference app use a KIND local registry or `kind load docker-image`?**
   - What we know: Both approaches work; local registry is faster for CI; `kind load` is simpler for local dev
   - What's unclear: For the GitHub Actions CI/CD lab (FOUND-03), participants need to build and deploy. `kind load` doesn't persist across cluster recreations.
   - Recommendation: Use a local KIND registry (KIND supports running a local Docker registry at `localhost:5001`) for CI labs. Document `kind load docker-image` as the simpler local dev alternative.

3. **Datadog free tier setup complexity (D-08)**
   - What we know: Datadog has a free trial (14-day) and a free tier. The agent setup requires an API key.
   - What's unclear: The free tier limits for K8s cluster monitoring (node count, metrics) may have changed.
   - Recommendation: Document Datadog as an "alternative path" with a note that it requires account creation and is optional. The primary path (Prometheus + Grafana) must be fully documented without Datadog.

4. **PostgreSQL on KIND: bitnami chart vs postgresql-operator vs cnpg?**
   - What we know: bitnami/postgresql is the simplest; cnpg (CloudNativePG) is more production-realistic
   - What's unclear: For Day 1 setup, simplicity wins. But if Module 10 database agents need CNPG-specific metrics, bitnami may be wrong.
   - Recommendation: Use bitnami/postgresql for Phase 1. Document the intent to revisit for Module 10 lab if CNPG-specific agent tools are needed.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Docker | KIND, image builds | Yes | 28.4.0 | — (hard requirement) |
| KIND | K8s cluster | Yes | v0.27.0 | k3d (documented alternative) |
| kubectl | Cluster interaction | Yes | (confirmed) | — |
| Helm | Chart installs | Yes | 3.18.4 | — |
| Rust/Cargo | Service builds | Yes | 1.91.0 | — |
| Node.js | Svelte dashboard build | Yes | v22.21.1 | — |
| npm | Package management | Yes | 10.9.4 | — |
| AWS CLI v2 | mock-aws wrapper + real AWS | Needs verification | — | mock-aws wrapper works without real AWS |
| OpenCode (sst) | Alternative LLM path | Not checked — participant install | Latest | Claude Code (primary path) |
| Claude Code | Primary LLM path | Not checked — participant install | Latest | OpenCode |

**Missing dependencies with no fallback:**

- Docker is required; if unavailable, KIND labs are fully blocked. This is noted in the existing setup-kind.md.

**Missing dependencies with fallback:**

- OpenCode / Claude Code: Course documents both; participants only need one.
- Real AWS credentials: mock-aws wrapper provides full fallback with pre-existing JSON files.

---

## Validation Architecture

> Skipped — `workflow.nyquist_validation` is explicitly `false` in `.planning/config.json`.

---

## Sources

### Primary (HIGH confidence)

- Existing `setup/verify.sh` — current state of environment verification (Hermes-focused)
- Existing `infrastructure/mock-data/` — confirmed file inventory and JSON structure
- Existing `infrastructure/wrappers/mock-aws` — current mock routing logic
- Existing `setup/setup-kind.md` — KIND setup guide (reusable content)
- KIND documentation — https://kind.sigs.k8s.io/ — confirmed v0.27.0 installed
- Axum 0.8.8 release — https://docs.rs/axum/0.8.8/axum/ — confirmed latest stable
- Svelte 5 + SvelteKit 2 — https://svelte.dev/docs — confirmed 5.55.1 / 2.56.1
- kube-prometheus-stack — https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack — confirmed 82.16.1
- Kubernetes liveness/readiness probes — https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/ — stable API

### Secondary (MEDIUM confidence)

- sst/opencode active fork — https://opencode.ai/docs/ — confirmed as active OpenCode project (vs archived opencode-ai/opencode)
- Crush vs OpenCode relationship — github.com/charmbracelet/crush/discussions/360 — confirmed they are separate projects
- Rust health check pattern for K8s — https://oneuptime.com/blog/post/2026-01-07-rust-kubernetes-health-checks/ (Jan 2026)
- Svelte 5 real-time dashboard patterns — https://dev.to/polliog/real-world-svelte-5-handling-high-frequency-real-time-data-with-runes-3i2f

### Tertiary (LOW confidence — verify before delivery)

- OpenCode (sst) free provider list (Grok free tier status) — check console.x.ai before writing setup guide
- Gemini 2.5 Flash free tier rate limits — verify at https://ai.google.dev/gemini-api/docs/rate-limits — known to change
- Groq free tier limits — verify at https://console.groq.com/docs/rate-limits — known to change

---

## Project Constraints (from CLAUDE.md)

Extracted from project CLAUDE.md — planner must verify compliance:

| Constraint | Impact on Phase 1 |
|------------|-------------------|
| Labs/projects FIRST, then explainers/concepts | Reference app (FOUND-01) must be built before any reading materials reference it |
| No paid API access — participants use existing subscriptions or free tiers | CI/CD pipeline must use `kind load` or local registry, NOT Docker Hub (rate-limited) |
| AWS free tier (6-month credits for new accounts as of July 2025) | Mock data is the default; real AWS is optional but should work on free tier |
| Context Engineering > Prompt Engineering philosophy | SETUP.md vocabulary: avoid "prompt" — use "context" and "instruction block" |
| Dual format: works for live 3-day workshop AND Udemy self-paced | verify.sh must be runnable without an instructor present |
| KIND for Kubernetes (local, free) | Confirmed: KIND v0.27.0 installed |
| Simulated/mock data for RDS, Cost Explorer | Existing mock files for these already in infrastructure/mock-data/ |
| No paid observability required | Prometheus + Grafana via kube-prometheus-stack is free |
| TDD (from global CLAUDE.md Superpowers) | Rust services must have unit + integration tests. RED-GREEN-REFACTOR. Tests first. |
| Verification before completion claims | Before marking FOUND-01 done: `bash setup/verify.sh` must pass all checks |

---

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH — versions verified against installed tools and npm/crates registries
- Architecture: HIGH — derived from existing repo analysis + locked CONTEXT.md decisions
- Pitfalls: HIGH — drawn from existing PITFALLS.md research (project-level, verified) + new phase-specific additions
- OpenCode identity: MEDIUM — confirmed sst/opencode is the active fork; Grok free tier status needs verification

**Research date:** 2026-04-04
**Valid until:** 2026-05-04 (Svelte, Axum stable); verify OpenCode and Gemini free tier limits within 48h of course delivery
