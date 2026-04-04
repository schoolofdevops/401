# Phase 3: Day 2 Modules — Research

**Researched:** 2026-04-04
**Domain:** Course content — Helm charts, CI/CD pipelines, GSD workflow, ArgoCD GitOps, Terraform IaC, Prometheus monitoring, context engineering pedagogy
**Confidence:** HIGH for content structure and tooling patterns; MEDIUM for ArgoCD minimal resource specs and Terraform mock_provider on local machine

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-32:** Split Module 5 into two sub-modules:
  - **Module 5a: Structured AI Coding** — Track A (Helm chart) OR Track B (CI/CD pipeline). Participant picks one.
  - **Module 5b: AI Workflow Tools** — GSD workflow lab, context engineering practical, memory systems, plan modes. Superpowers as exploratory.
- **D-33:** Participants choose ONE track per module, not all.
- **D-34:** Track A: Build a production Helm chart for the reference app via structured AI workflow (Brainstorm → Design → Blueprint → Implement → Validate)
- **D-35:** Track B: Build a CI/CD pipeline (GitHub Actions) for the reference app via structured AI workflow
- **D-36:** GSD Workflow lab: Full cycle (new-project → discuss → plan → execute → verify) building a **monitoring stack** (Prometheus alerting rules + Grafana dashboard config) for the reference app (api-gateway, catalog, worker)
- **D-37:** Context engineering practical: CLAUDE.md files, context window management, selective injection
- **D-38:** Memory systems lab: claude-mem for Claude Code, MCP-based memory for OpenCode/Crush
- **D-39:** Plan modes lab: Claude Code plan mode, GSD plan-phase
- **D-40:** Superpowers workflow: TDD, debugging, code review as exploratory content
- **D-41:** Skip Argo Workflows track entirely — only Track A and Track B remain for Module 6
- **D-42:** Track A: Terraform module for real AWS resources (free tier) with CloudWatch alarms + SNS. Mock fallback documented.
- **D-43:** Track B: K8s + Helm + ArgoCD GitOps on KIND — ArgoCD is appropriate when participants are actively learning GitOps (vs too heavy for Day 1)
- **D-44:** Participants choose ONE track.
- **D-45:** Guided generation — Lab gives specific prompts/context to feed the AI tool at each step. Solution files provided for comparison.
- **D-46:** Every lab step includes "Expected result:" block so participants know if they succeeded.

### Claude's Discretion

- Specific Prometheus alerting rules and Grafana dashboard configs for the GSD lab
- How to structure the guided generation prompts for each track
- Memory systems MCP server recommendation for OpenCode/Crush
- Superpowers exploratory depth and format

### Deferred Ideas (OUT OF SCOPE)

- Argo Workflows track (D-41) — explicitly dropped from Module 6
- Advanced multi-model orchestration — v2 content
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| MOD5-01 | Lab Track A — Build production Helm chart via structured AI workflow | Existing chart at reference-app/helm/reference-app/ is the teaching example; missing: health probes, resource limits, HPA template |
| MOD5-02 | Lab Track B — Build CI/CD pipeline (GitHub Actions) via structured AI workflow | Existing .github/workflows/ci.yml is the reference; gap analysis: no OIDC, no env-specific deploy, no secrets audit |
| MOD5-03 | GSD Workflow lab — Full /gsd:new-project → discuss → plan → execute → verify cycle | GSD 1.28.0 installed; cycle produces monitoring stack files; Prometheus rules + Grafana JSON are the deliverable |
| MOD5-04 | Context engineering practical — CLAUDE.md files, context window management | CLAUDE.md pattern established; 4-layer context model already taught in Module 1 |
| MOD5-05 | Memory systems lab — claude-mem for Claude Code, MCP for Crush | claude-mem plugin installed (port 37777 + ChromaDB); Crush uses .crush.json MCP config |
| MOD5-06 | Plan modes lab — Claude Code plan mode, GSD plan-phase | GSD plan-phase is the same workflow participants are in now; Claude Code --plan flag |
| MOD5-07 | Superpowers workflow (exploratory) — TDD, debugging, code review | ~/.claude/superpowers/ files available as reference material |
| MOD5-08 | Reading — Why unstructured prompting fails for production infrastructure | Contrast with context engineering philosophy; DevOps analogies |
| MOD5-09 | Reading — GSD workflow reference, plan modes, memory systems, context engineering techniques | Synthesize from GSD USER-GUIDE + claude-mem docs + superpowers |
| MOD5-10 | Quiz covering structured coding, context engineering, AI workflow patterns | 5-8 questions; concept-focused |
| MOD6-01 | Lab Track A — Terraform module for real AWS resources (free tier) with mock fallback | Terraform 1.4.6 on this machine — below 1.7 threshold for mock_provider; participants must install 1.7+ or use tfvars override pattern |
| MOD6-02 | Lab Track B — K8s + Helm + ArgoCD GitOps config on KIND | ArgoCD 2.1.3 installed locally (very old; latest stable 3.3.6); needs install from stable manifests into KIND |
| MOD6-03 | Lab Track C (DESCOPED per D-41) | Out of scope — do not implement |
| MOD6-04 | Each track: starter, solution, expected outputs, validation steps | Guided generation pattern (D-45 + D-46) |
| MOD6-05 | Reading — AI failure modes in infrastructure generation | Common AI errors: drift from schema, wrong provider API versions, hallucinated attributes |
| MOD6-06 | Quiz covering IaC validation, AI error patterns | 5-8 questions |
</phase_requirements>

---

## Summary

Phase 3 builds five interleaved content streams: Module 5a (two structured AI coding lab tracks), Module 5b (four AI workflow tool labs), and Module 6 (two IaC generation tracks). All content lives in the Docusaurus site at `course-site/docs/` as MDX files. The reference app built in Phase 1 is the target for every lab — participants already understand the system they are instrumenting, deploying, or monitoring.

The GSD lab (MOD5-03) is the most pedagogically valuable piece: participants experience the exact workflow they will use for the rest of the course. The deliverable is a monitoring stack (Prometheus alerting rules + Grafana dashboard config) for the same api-gateway/catalog/worker services. Because the reference app exposes `/health/live`, `/health/ready`, `/version`, and `/api/status`, the alerting rules are straightforward and testable locally.

Two important environmental constraints affect the plan: (1) Terraform on participant machines may not have 1.7+ (required for `mock_provider`), so Module 6 Track A must document the version requirement prominently and provide a tfvars-based real-AWS path alongside the mock path; (2) The locally installed ArgoCD binary is 2.1.3 but the lab must install ArgoCD into KIND from the stable manifests (3.3.6), so the binary version is irrelevant — the lab uses `kubectl apply` not the `argocd` CLI for core operations.

**Primary recommendation:** Build labs in this order — GSD lab first (it teaches the meta-skill), then Module 5a tracks, then Module 6 tracks. Each lab uses the guided-generation pattern: provide the AI prompt verbatim, show the expected output, then show the solution file.

---

## Standard Stack

### Core
| Library/Tool | Version | Purpose | Why Standard |
|---|---|---|---|
| Docusaurus | 3.9.2 | Course site MDX hosting | Already in course-site/ (Phase 2) |
| Helm | v3.18.4 | Kubernetes package manager | Installed; used by reference app |
| KIND | v0.27.0 | Local Kubernetes clusters | Installed; lab cluster "lab" exists |
| kubectl | v1.32.3 | K8s API client | Installed |
| Terraform | 1.14.8 (latest) | IaC for Module 6 Track A | Participants must install 1.7+ for mock_provider; locally 1.4.6 — upgrade required |
| ArgoCD | 3.3.6 (stable) | GitOps controller for Module 6 Track B | Install from stable manifests into KIND, not local binary |
| Prometheus | via kube-prometheus-stack | Metrics + alerting | Already deployed via `infrastructure/helm/prometheus-lab-values.yaml` |
| Grafana | via kube-prometheus-stack | Dashboards | NodePort 30090 per cluster-config.yaml |

### Supporting
| Library/Tool | Version | Purpose | When to Use |
|---|---|---|---|
| GSD (get-shit-done) | 1.28.0 | AI workflow orchestrator | Module 5b GSD lab — participants run /gsd:new-project |
| claude-mem | plugin via bun | Cross-session memory for Claude Code | Module 5b memory lab |
| Crush | latest stable | Alternative AI coding agent (Charmbracelet) | Module 5b memory lab — MCP memory config |
| axum-prometheus | 0.8.x | Prometheus metrics middleware for Axum | Needed to expose /metrics endpoint on reference app services for real Prometheus scraping |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|---|---|---|
| ArgoCD on KIND | Flux CD on KIND | ArgoCD has better UI for teaching; GitOps push→sync is more demonstrable |
| Terraform mock_provider | LocalStack | LocalStack community edition EOL'd March 2026 (documented in STATE.md) — do not use |
| GSD for monitoring stack | Manual YAML writing | GSD is the point of the lab — skip the tool = miss the lesson |

---

## Architecture Patterns

### Module 5a: Structured AI Coding Lab Pattern

Both Track A (Helm) and Track B (CI/CD) follow the same 5-phase structured workflow:

```
Phase 1: Brainstorm  → /gsd:discuss  → lock requirements
Phase 2: Design      → /gsd:plan     → review the plan
Phase 3: Blueprint   → starter files → Claude Code generates
Phase 4: Implement   → Claude Code fills in production details
Phase 5: Validate    → helm lint / act / kubectl apply --dry-run
```

The lab provides the AI prompt to use at each phase. Participants feed it verbatim, then compare output to the solution file.

### Module 5a Track A: Production Helm Chart Gaps

The existing chart at `reference-app/helm/reference-app/` is the teaching baseline. Participants build a "production-quality" version that adds what the baseline lacks:

```yaml
# What the existing chart has (baseline):
- Deployments for all 4 services
- livenessProbe / readinessProbe (httpGet to /health/live and /health/ready)
- Resource requests defined
- ConfigMap for env vars
- NodePort for dashboard

# What participants add in the lab (production quality):
- Resource limits (not just requests)
- HorizontalPodAutoscaler template
- PodDisruptionBudget template
- ServiceMonitor (for Prometheus scraping)
- helm lint clean output
- NOTES.txt with post-install instructions
```

This is the "gap analysis" that motivates the structured AI workflow: show baseline, identify gaps, use AI to fill them systematically.

### Module 5a Track B: CI/CD Pipeline Gaps

The existing `.github/workflows/ci.yml` is the teaching baseline. Participants build a "production-quality" version:

```yaml
# What the existing pipeline has (baseline):
- cargo test --workspace
- Docker image builds
- KIND cluster creation
- Helm deploy
- Health endpoint verification

# What participants add in the lab (production quality):
- matrix: strategy for multi-version testing
- OIDC-based AWS credential exchange (no long-lived secrets)
- Separate staging/production deploy jobs
- docker/metadata-action for proper image tagging
- Job output summary with deployed versions
```

### Module 5b: GSD Workflow Lab Structure

The lab follows the complete GSD cycle applied to a well-scoped deliverable: a monitoring stack for the reference app.

```
Step 1: /gsd:new-project
   → Participants describe the project: "Add Prometheus alerts and Grafana dashboard for our reference app"
   → GSD gathers requirements, creates PROJECT.md

Step 2: /gsd:discuss-phase 1
   → Lock alert thresholds, dashboard layout decisions
   → Produces CONTEXT.md

Step 3: /gsd:plan-phase 1
   → Research → plan → plan-check cycle
   → Produces PLAN.md files

Step 4: /gsd:execute-phase 1
   → Claude Code writes alerting-rules.yaml + grafana-dashboard.json
   → Commits are atomic

Step 5: /gsd:verify-work
   → Participants validate rules load into Prometheus
   → Dashboard imports cleanly into Grafana
```

**Deliverable artifacts for the GSD lab:**

```
monitoring/
├── alerting-rules.yaml         # Prometheus PrometheusRule CRD
└── grafana-dashboard.json      # Grafana dashboard provisioning JSON
```

### Module 6 Track B: ArgoCD on KIND Pattern

Install ArgoCD from stable manifests into the existing KIND cluster:

```bash
# 1. Create argocd namespace
kubectl create namespace argocd

# 2. Install from stable (NOT core — we need the UI for teaching)
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Reduce memory for laptop constraints
kubectl patch deployment argocd-repo-server -n argocd --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"256Mi"}]'

# 4. Port-forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8443:443

# 5. Get initial admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d
```

The Application CRD points to the reference app's Helm chart in the course repo:

```yaml
# argocd-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: reference-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<participant>/agentic-devops-course
    targetRevision: HEAD
    path: reference-app/helm/reference-app
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

The "push → sync" demo: participant edits `values.yaml` (changes a replica count), commits, pushes to their fork → ArgoCD detects drift within 3 minutes → auto-syncs.

### Module 6 Track A: Terraform Module with Mock Fallback

The Terraform lab builds a module for EC2 + CloudWatch alarm + SNS notification:

```hcl
# modules/ec2-monitored/main.tf
resource "aws_instance" "this" { ... }
resource "aws_cloudwatch_metric_alarm" "cpu_high" { ... }
resource "aws_sns_topic" "alerts" { ... }
resource "aws_sns_topic_subscription" "email" { ... }
```

**Real AWS path (D-42):** `terraform apply` against free-tier account with `AWS_PROFILE` set.

**Mock fallback (for participants without AWS access):**

```hcl
# tests/main.tftest.hcl  (requires Terraform 1.7+)
mock_provider "aws" {}

run "ec2_alarm_has_correct_threshold" {
  assert {
    condition     = aws_cloudwatch_metric_alarm.cpu_high.threshold == 80
    error_message = "CPU alarm threshold should be 80%"
  }
}
```

**Important version constraint:** The locally installed Terraform is 1.4.6. Mock_provider requires 1.7.0+. The lab must include a prominent "Version Requirements" block and the `terraform version` check as Step 0. For participants with < 1.7, provide the tfvars-based "plan only" fallback using `terraform plan -input=false`.

### Anti-Patterns to Avoid

- **Showing mock and real paths side-by-side in the same lab step:** Confusing. Use a collapsible `<details>` block labeled "Alternative: Mock fallback (no AWS required)" placed after the primary instruction.
- **ArgoCD CLI-heavy labs:** ArgoCD's web UI is the teaching surface — the push-to-sync demo is visual. Keep `argocd` CLI commands to minimum (login + app list); everything else via `kubectl apply` or UI.
- **Context window busting in GSD lab:** The monitoring stack deliverable must be scoped tightly (2 files: alerting-rules.yaml + grafana-dashboard.json). Do not expand to full kube-prometheus-stack reconfiguration.
- **Treating GSD as a "prompt tool":** Language in Module 5b must enforce the course vocabulary — it is a "context engineering harness" not a "prompting framework."

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Prometheus ServiceMonitor CRD | Custom YAML schema | kube-prometheus-stack CRD definitions | Schema is versioned; wrong CRD version causes silent failures |
| Grafana dashboard JSON | Write from scratch | Grafana's export-as-JSON feature; provide template | 400+ line JSON; AI gets confused without a working base template |
| ArgoCD Application resource | Custom Git polling | ArgoCD Application CRD with automated syncPolicy | ArgoCD handles reconciliation loop, retry, health status |
| Terraform AWS provider version pinning | Guessing | Lock to provider version matching lab terraform (requires_providers block) | Provider schema changes between major versions |
| GSD project structure | Custom file layout | `/gsd:new-project` creates the .planning/ tree | Consistent structure is what the rest of the GSD cycle depends on |

**Key insight:** In IaC content, the AI-generated artifacts are only as good as the schema/type information provided. Guided generation prompts must include resource types, required attributes, and version constraints — not just natural language intent.

---

## Prometheus Alerting Rules for the Reference App

The reference app services expose these endpoints relevant to alerting:

| Service | Port | Endpoints | Observable Behavior |
|---------|------|-----------|---------------------|
| api-gateway | 8080 | `/health/live`, `/health/ready`, `/api/status` | Readiness returns 503 if catalog or worker down |
| catalog | 8081 | `/health/live`, `/health/ready`, `/items` | Readiness returns 503 if PostgreSQL unavailable |
| worker | 8082 | `/health/live`, `/health/ready`, `/events` | Writes heartbeat event every 60 seconds |

**Note:** The reference app services do NOT currently expose `/metrics` (Prometheus format). For real Prometheus scraping, participants would need to add `axum-prometheus` middleware. For the GSD lab scope, use the Blackbox Exporter probe approach (scrape the health endpoints as HTTP checks) rather than requiring code changes to the reference app.

### Recommended alerting rules for the GSD lab deliverable:

```yaml
# alerting-rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: reference-app-alerts
  namespace: monitoring
  labels:
    app: kube-prometheus-stack
    release: prometheus
spec:
  groups:
  - name: reference-app.health
    interval: 30s
    rules:
    # Alert when api-gateway readiness probe fails
    - alert: ApiGatewayDegraded
      expr: |
        probe_success{job="blackbox-http",
                      instance=~".*api-gateway.*health.*ready.*"} == 0
      for: 1m
      labels:
        severity: warning
        team: platform
      annotations:
        summary: "API Gateway readiness probe failing"
        description: "api-gateway /health/ready returning non-200 for > 1 minute"

    # Alert when catalog service is down
    - alert: CatalogServiceDown
      expr: |
        probe_success{job="blackbox-http",
                      instance=~".*catalog.*health.*ready.*"} == 0
      for: 2m
      labels:
        severity: critical
        team: platform
      annotations:
        summary: "Catalog service unavailable"
        description: "catalog /health/ready has been failing for > 2 minutes"

    # Alert when worker heartbeat stops (no events written in 3 minutes)
    - alert: WorkerHeartbeatMissing
      expr: |
        time() - pg_stat_activity_count{datname="refapp"} > 180
      for: 0m
      labels:
        severity: warning
        team: platform
      annotations:
        summary: "Worker heartbeat may have stopped"
        description: "No DB activity detected in refapp database for > 3 minutes"
```

**Confidence note:** The blackbox probe approach is HIGH confidence — it works with the existing prometheus-lab-values.yaml which already has ServiceMonitors enabled. The worker heartbeat alert using pg_stat_activity is MEDIUM confidence — requires postgres-exporter sidecar to be deployed. For the lab, teach the pattern with the api-gateway + catalog alerts; the worker alert is an exercise.

---

## Context Engineering as a Teachable Skill

The course emphasizes context engineering over prompt engineering. Module 5b must make this concrete.

### The 4-Layer Context Model (established in Module 1)

Module 1 already introduced this model with CloudWatch data. Module 5b's context engineering practical reinvests it for IaC:

```
Layer 1: TASK context      → What you want (the output: "Helm chart with HPA")
Layer 2: ROLE context      → Who you are (the actor: "senior SRE on platform team")
Layer 3: SYSTEM context    → What exists (the environment: reference app services, ports, health endpoints)
Layer 4: PROCEDURE context → How to do it (the constraints: "use Kubernetes 1.32 API, Helm 3.18, no Alpha APIs")
```

### CLAUDE.md as System Context

The CLAUDE.md file is the most teachable artifact. For Module 5b:

```markdown
# IaC Context Lab — What participants create

## Project: Monitoring Stack for Reference App

## System State
- KIND cluster: context "kind-lab"
- Services: api-gateway (8080), catalog (8081), worker (8082)
- Namespace: app (reference app), monitoring (Prometheus + Grafana)
- Prometheus: NodePort 30091, Grafana: NodePort 30090

## Constraints
- No paid services — all resources local or free-tier
- Kubernetes 1.32, Helm 3.18, Prometheus Operator CRD v1
- Do not modify reference app source code

## Vocabulary
- "alerting rules" → PrometheusRule CRD in monitoring namespace
- "dashboard" → Grafana JSON provisioning file in configmap
```

The lab shows the before/after: without CLAUDE.md, AI generates generic Kubernetes YAML. With CLAUDE.md, it generates namespace-aware, version-specific, constraint-respecting configs.

### Context Window Management

For the Module 5b practical, teach these three patterns:

1. **Selective injection:** `@CLAUDE.md` vs `@entire-repo` — show token count difference
2. **YOLO mode vs ask mode:** When to let AI proceed vs request approval (maps to autonomy spectrum taught in Module 1)
3. **Session handoff:** GSD STATE.md as a cross-session anchor — this is what enables picking up work across sessions

---

## Memory Systems Lab: claude-mem and Crush

### claude-mem (for Claude Code users)

claude-mem is installed on this machine as a bun-based plugin:
- Worker service runs on port 37777 with a web UI
- SQLite + ChromaDB for hybrid semantic + keyword search
- MCP server at `~/.claude/plugins/marketplaces/thedotmack/plugin/scripts/mcp-server.cjs`
- 5 lifecycle hooks: SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd

**Lab teaching moment:** Show the web UI at localhost:37777 after a session. Participants see their activity logged and searchable. Then start a new session, reference a past decision, and watch claude-mem inject it automatically.

**Commands:**
```bash
# These are available via claude-mem plugin hooks (not slash commands):
/mem search "Helm chart resource limits"    # search past observations
/mem timeline                                # show recent activity
```

### Crush (for non-Claude Code users)

Crush uses `.crush.json` for MCP server configuration. For memory, recommend the `mcp-memory` server pattern:

```json
{
  "mcp": {
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

Config file location: `~/.config/crush/crush.json` (global) or `.crush.json` (project-level).

**Lab teaching moment:** Show that both tools solve the same problem (cross-session persistence) with different mechanisms. Claude Code's memory is tightly integrated (auto-captures); Crush requires explicit MCP configuration but supports any standards-compliant MCP server.

### Plan Modes Lab

Claude Code plan mode: `claude --plan` flag (or `/plan` in interactive mode) produces a structured markdown plan before executing. GSD's plan-phase is the production-grade equivalent.

Teaching comparison:

| Mode | When | Output | Example |
|------|------|--------|---------|
| Claude Code `/plan` | Quick, single task | Plan in chat | "Add HPA to Helm chart" |
| GSD `/gsd:plan-phase` | Multi-file, production work | PLAN.md files with waves | "Build monitoring stack" |

---

## Common Pitfalls

### Pitfall 1: Terraform Version Below 1.7 for Mock Tests
**What goes wrong:** `mock_provider` block in `.tftest.hcl` fails with "unsupported argument" on Terraform 1.4.x or lower.
**Why it happens:** Mock provider support landed in Terraform 1.7.0 (January 2024). Many machines have older versions.
**How to avoid:** Make Step 0 of Track A lab a `terraform version` check with explicit minimum version callout. Provide a `terraform plan -input=false -var-file=test.tfvars` fallback that does not require AWS credentials but shows the plan output.
**Warning signs:** Error message contains "An argument named mock_provider is not expected here."

### Pitfall 2: ArgoCD Install Exhausts KIND Memory
**What goes wrong:** ArgoCD standard install requests ~1.3GB memory total across its components. On 8GB machines with KIND + reference app + Prometheus already running, this causes OOM evictions.
**Why it happens:** Standard `install.yaml` has no resource limits; Kubernetes schedules based on requests but doesn't cap usage.
**How to avoid:** Lab must include resource patch step immediately after `kubectl apply`. Key patches: argocd-server (256Mi limit), argocd-repo-server (256Mi limit), argocd-application-controller (512Mi limit). Alternatively, use `--timeout 300s` on the apply and check node memory with `kubectl describe nodes` if pods stay Pending.
**Warning signs:** Pods stay in `Pending` state; `kubectl describe pod` shows "Insufficient memory" in Events.

### Pitfall 3: ArgoCD Syncing from Local File Path (Not Git)
**What goes wrong:** Participants try to point ArgoCD at a local path (`file:///Users/...`) instead of a Git repo URL.
**Why it happens:** Natural confusion — they have the repo locally, why not point to it directly?
**How to avoid:** Lab must explicitly state: "ArgoCD pulls from Git, not your local filesystem." Participants must push their changes to their GitHub fork before the sync demo works. Include a "fork the repo" prereq step at the top of Track B.
**Warning signs:** Application stays OutOfSync with "failed to get git client" error.

### Pitfall 4: GSD Lab Scope Creep
**What goes wrong:** Participants (or Claude Code) expand the GSD lab to modify the reference app source code, add new services, or reconfigure the entire Prometheus stack.
**Why it happens:** GSD's discuss-phase encourages comprehensive requirements; without tight scope, AI includes "nice to have" items.
**How to avoid:** The lab's CLAUDE.md (Layer 3/4 context) must include explicit constraint: "Do not modify reference-app/ source code. Deliverables: alerting-rules.yaml and grafana-dashboard.json only." Make this the first thing participants add to their project context.
**Warning signs:** discuss-phase produces requirements for new Rust endpoints or PostgreSQL exporter installation.

### Pitfall 5: Guided Generation Prompts Too Generic
**What goes wrong:** Participants copy the lab's provided AI prompt but get unusable output because the prompt lacks system context.
**Why it happens:** The guided generation pattern fails if the prompt is written as a standalone instruction rather than as context + instruction.
**How to avoid:** Every guided generation prompt in the lab must be prefixed with a CLAUDE.md snippet that participants have already created. The lesson structure is: (1) create CLAUDE.md, (2) use it as context, (3) write the instruction. This reinforces Module 5b's context engineering lesson within Module 6.
**Warning signs:** Solution files look very different from participant-generated output — usually means CLAUDE.md was skipped.

### Pitfall 6: MOD6-03 Content Appearing (Argo Workflows descoped)
**What goes wrong:** A third track (Argo Workflows / CI/CD) gets accidentally included in planning or implementation.
**Why it happens:** REQUIREMENTS.md still lists MOD6-03 as a requirement line item; easy to include without checking D-41.
**How to avoid:** REQUIREMENTS.md MOD6-03 should be noted in RESEARCH and in any plan as explicitly out of scope per D-41. Do not create any module-06 Track C directory.

---

## Code Examples

### Docusaurus MDX Pattern (from Module 1 reference)

```mdx
---
id: module-05a-lab
title: "Lab: Structured AI Coding — Track A (Helm)"
sidebar_label: "Lab Track A: Helm"
sidebar_position: 1
description: "Build a production Helm chart using structured AI workflow"
---

# Lab: Structured AI Coding — Helm Chart Track

**Duration:** 60 minutes
**Deliverable:** Production-quality Helm chart with HPA, PDB, ServiceMonitor

## What You Need
...

## Step 1: Baseline Analysis

<details>
<summary>Expected result</summary>
...
</details>
```

Source: `course-site/docs/module-01-foundations/lab/LAB.mdx`

### PrometheusRule CRD Pattern

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: reference-app-alerts
  namespace: monitoring
  labels:
    release: prometheus        # Must match kube-prometheus-stack release name
spec:
  groups:
  - name: reference-app.rules
    rules:
    - alert: ServiceUnhealthy
      expr: up{job="reference-app"} == 0
      for: 2m
      labels:
        severity: critical
      annotations:
        summary: "{{ $labels.instance }} is down"
```

The `release: prometheus` label is required for the kube-prometheus-stack to pick up the rule. Missing this label is the single most common Prometheus rule deployment failure.

### Terraform Module Structure for Track A

```
modules/
└── ec2-monitored/
    ├── main.tf           # aws_instance, aws_cloudwatch_metric_alarm, aws_sns_topic
    ├── variables.tf      # instance_type, alarm_threshold, email_address
    ├── outputs.tf        # instance_id, alarm_arn
    └── versions.tf       # required_providers { aws >= 5.0 }

tests/
└── unit.tftest.hcl       # mock_provider "aws" {} + assertions

environments/
└── lab/
    ├── main.tf           # module "app" { source = "../../modules/ec2-monitored" }
    └── terraform.tfvars  # instance_type = "t2.micro" (free tier)
```

### ArgoCD Application CRD for Track B

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: reference-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/PARTICIPANT/agentic-devops-course
    targetRevision: HEAD
    path: reference-app/helm/reference-app
    helm:
      releaseName: reference-app
      valueFiles: [values.yaml]
  destination:
    server: https://kubernetes.default.svc
    namespace: app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### Crush MCP Memory Config

```json
// ~/.config/crush/crush.json
{
  "mcp": {
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "timeout": 120
    }
  }
}
```

Source: Crush documentation (github.com/charmbracelet/crush), verified April 2026.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| OpenCode (opencode-ai/opencode) | Crush (charmbracelet/crush) | OpenCode archived Sept 18, 2025 | All "OpenCode" references in content must say "Crush" |
| LocalStack community for AWS mocking | Terraform mock_provider | LocalStack community EOL March 2026 | Track A uses mock_provider, not LocalStack |
| Terraform < 1.7 (no test framework) | Terraform 1.7+ test framework + mock_provider | Terraform 1.7.0, January 2024 | Lab must specify minimum version |
| ArgoCD v2.x | ArgoCD v3.x (stable 3.3.6) | ArgoCD 3.0 released 2025 | Local binary is 2.1.3 (outdated); lab installs from stable manifests |
| Prompt engineering | Context engineering | Course design decision | Vocabulary enforced from Module 1; "prompt" appears only in contrast/negation |

**Deprecated/outdated:**
- OpenCode (opencode-ai/opencode): archived; replaced by Crush
- LocalStack community edition: EOL March 2026; `terraform mock_provider` is the correct replacement for lab use
- ArgoCD 2.x local binary: outdated; ignore `argocd version --client` output; deploy from stable manifests

---

## Open Questions

1. **Does the reference app need a /metrics endpoint for real Prometheus scraping?**
   - What we know: Current services expose only health and API endpoints, no Prometheus metrics
   - What's unclear: Whether the GSD lab teaches metric-based alerting or health-probe-based alerting
   - Recommendation: Scope GSD lab to Blackbox Exporter / health probe alerting (no code changes to reference app). This is teachable and realistic. Reserve native metrics exposition for an exploratory extension.

2. **ArgoCD push→sync demo: which Git host?**
   - What we know: ArgoCD requires a reachable Git URL; local file paths do not work
   - What's unclear: Whether participants have GitHub accounts or prefer GitLab/other
   - Recommendation: Assume GitHub (course already uses GitHub Actions). Lab step 1 should be "fork this repo to your GitHub account." Note: participants on corporate networks with no outbound Git may need a local Gitea fallback (MEDIUM confidence that Gitea+ArgoCD works on KIND; worth noting as a stretch option).

3. **Terraform version on participant machines**
   - What we know: Latest stable is 1.14.8; mock_provider requires 1.7.0+; this machine has 1.4.6
   - What's unclear: What version participants will have (corporate environments often run older versions)
   - Recommendation: Make `terraform version` Step 0 of Module 6 Track A. Document 1.7+ as hard requirement for mock_provider path. Provide `terraform plan` fallback with real tfvars for those with older versions or without AWS credentials. Add `tfenv` recommendation for version management.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|---|---|---|---|---|
| Helm | All K8s labs | Yes | v3.18.4 | — |
| KIND | All K8s labs | Yes | v0.27.0 | — |
| kubectl | All K8s labs | Yes | v1.32.3 | — |
| ArgoCD binary | MOD6-02 UI/login | Yes (stale) | 2.1.3 (latest: 3.3.6) | Use kubectl port-forward + web UI only |
| Terraform | MOD6-01 | Yes | 1.4.6 (latest: 1.14.8) | Upgrade required for mock_provider; plan-only fallback for older versions |
| GSD tooling | MOD5-03 | Yes | 1.28.0 | — |
| claude-mem plugin | MOD5-05 | Yes | bun-based plugin | — |
| Crush | MOD5-05 | No | — | Lab documents install steps; MCP config pattern still teachable |
| Prometheus on KIND | MOD5-03 | Configured | via prometheus-lab-values.yaml | Participants deploy per setup guide |
| Grafana on KIND | MOD5-03 | Configured | NodePort 30090 | Participants deploy per setup guide |

**Missing dependencies with no fallback:**
- None that block Phase 3 content creation. All labs are about writing content files (MDX), not running the labs.

**Missing dependencies with fallback:**
- Crush: not installed locally, but content can be written from documentation. Lab includes install instructions (`brew install charmbracelet/tap/crush`).
- ArgoCD (current version): the 2.1.3 binary is stale. Lab uses `kubectl apply` approach, not the CLI binary. No fallback needed — just don't rely on local CLI.
- Terraform (current version): mock_provider fallback documented above.

---

## Validation Architecture

`nyquist_validation` is set to `false` in `.planning/config.json` — this section is skipped.

---

## Project Constraints (from CLAUDE.md)

The following directives from `./CLAUDE.md` constrain all content in this phase:

| Directive | Impact on Phase 3 |
|---|---|
| Labs/projects FIRST, then explainers/concepts | Build LAB.mdx before reading/concepts.md for every module |
| DevOps scope is BROAD | Labs cover IaC, K8s, CI/CD, monitoring — not just one domain |
| Dual format: live workshop + Udemy | Labs must be solo-completable (no team dependency) |
| Context engineering > prompt engineering | Vocabulary enforced: use "context" not "prompt" throughout |
| No paid API access | All labs use free-tier or local tools; no paid observability |
| Free tier infrastructure | KIND local, AWS free-tier only, Prometheus on KIND |
| `course-site/` is Docusaurus 3.9.2 | All content as MDX with frontmatter |
| MDX cross-links use document id | Use `./module-05a-lab` not relative path |
| MDX `<` character causes parse errors | Use prose substitution in code blocks inside .md starter files |
| Build strategy: labs first | Module 5a, 5b, 6 LAB.mdx before reading.md or quiz.md |
| OpenCode replaced by Crush | All references use "Crush" not "OpenCode" |

---

## Sources

### Primary (HIGH confidence)
- Reference app source code — `reference-app/services/*/src/main.rs` (verified locally)
- Helm chart at `reference-app/helm/reference-app/` (verified locally)
- KIND cluster config at `infrastructure/kind/cluster-config.yaml` (verified locally)
- Prometheus lab values at `infrastructure/helm/prometheus-lab-values.yaml` (verified locally)
- GSD tooling v1.28.0 — `~/.claude/get-shit-done/` (verified locally)
- claude-mem plugin — `~/.claude/plugins/marketplaces/thedotmack/plugin/` (verified locally)
- Docusaurus MDX pattern — `course-site/docs/module-01-foundations/lab/LAB.mdx` (verified locally)
- Terraform mock_provider docs — developer.hashicorp.com/terraform/language/tests/mocking (fetched directly)
- Crush configuration docs — github.com/charmbracelet/crush (fetched April 2026)

### Secondary (MEDIUM confidence)
- ArgoCD installation pattern — argo-cd.readthedocs.io/en/stable/getting_started/ (search verified April 2026; official docs 403'd but content confirmed via search)
- ArgoCD resource requirements for KIND — github.com/argoproj/argo-cd/issues/4110 + operator docs
- Prometheus alerting rules for HTTP health checks — multiple DevOps blogs cross-verified with Prometheus docs
- claude-mem features and architecture — github.com/thedotmack/claude-mem + docs.claude-mem.ai (fetched April 2026)

### Tertiary (LOW confidence)
- Crush MCP memory: `@modelcontextprotocol/server-memory` recommendation — inferred from MCP ecosystem patterns; not officially documented by Charmbracelet
- Worker heartbeat alerting via pg_stat_activity — valid pattern but requires postgres-exporter deployment not yet in lab setup

---

## Metadata

**Confidence breakdown:**
- Content structure and MDX patterns: HIGH — existing modules provide clear precedent
- GSD workflow lab design: HIGH — GSD tooling verified locally, cycle is well-documented
- ArgoCD on KIND: MEDIUM — install pattern verified from official docs; resource constraints based on community reports
- Terraform mock_provider: HIGH for syntax/API; MEDIUM for version constraint impact on participants
- Prometheus alerting rules: MEDIUM — blackbox exporter approach verified; native /metrics approach would require code changes
- Memory systems lab: HIGH for claude-mem (installed locally); MEDIUM for Crush (not installed, docs-based)
- Context engineering pedagogy: HIGH — course vocabulary and 4-layer model established in Phase 2

**Research date:** 2026-04-04
**Valid until:** 2026-05-04 (ArgoCD version numbers and Terraform version may change; content structure is stable)
