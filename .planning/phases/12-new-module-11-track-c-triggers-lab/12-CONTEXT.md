# Phase 12: New Module 11 Track C Triggers Lab — Context

**Gathered:** 2026-04-09
**Status:** Ready for planning

<domain>

## Phase Boundary

Create a dedicated Track C triggers lab (`LAB-track-c-kubernetes.mdx`) for Module 11 (Triggers, Scheduling, and Interfaces — formerly Module 12). This lab uses real KIND infrastructure throughout — no mock mode, no HERMES_LAB_MODE, no wrapper scripts.

**Source material:** The existing unified `LAB.mdx` (1308 lines, 16 steps) contains Track C content embedded as track-specific callouts. The new Track C lab extracts and streamlines this into a K8s-focused experience.

</domain>

<decisions>

## Implementation Decisions

### Lab Scope: 5 Trigger Types, All Real Infrastructure
The Track C lab covers these triggers (in order):
1. **Hermes cron** — `daily-k8s-check` using `kubernetes-health` skill (10 min)
2. **AlertManager webhook** — Prometheus stack on KIND, PodCrashLooping alert fires, agent diagnoses (20 min)
3. **K8s CronJob** — Docker build, KIND load, apply CronJob manifest for periodic health checks (15 min)
4. **GitHub webhook** — smee.io tunnel, agent reviews K8s manifests in PRs (15 min)
5. **Telegram bot** — @BotFather setup, `/diagnose` slash command triggers agent (10 min)

**Excluded from Track C lab:**
- CloudWatch webhook simulation (Steps 6-7 of unified lab — not relevant for K8s track)
- Slack production reference (Step 8 — keep in unified lab only, mention as "see unified lab")

### No Mock Mode — Real Infrastructure Only
- Zero `HERMES_LAB_MODE` environment variables
- Zero `MOCK_DATA_DIR` references
- Zero `HERMES_LAB_TRACK` environment variables
- Agent runs real kubectl against real KIND cluster
- AlertManager fires real alerts from real Prometheus on real crashloop pods

### AlertManager Setup Is Self-Contained
The lab includes AlertManager/Prometheus setup steps within it (not assumed from elsewhere):
- Enable AlertManager in existing Helm values
- Apply PrometheusRule for PodCrashLooping
- Verify in Prometheus UI
This was Steps 9-10 in the unified lab; the Track C lab makes it a required step, not optional.

### Prerequisites: Module 8 Track C Agent + KIND
- Track C agent profile from Module 8 (consolidated BUILD-AND-TEST lab)
- KIND cluster running (from Module 6 setup, verified in Module 8)
- No Module 10 prerequisite (Track C skips Module 10)

### Duration: 90 minutes
- 70 min guided (5 trigger types)
- 20 min free explore (challenges)

</decisions>

<canonical_refs>

## Canonical References

### Source Material (Extract Track C Content From)
- `course-site/docs/module-11-triggers/lab/LAB.mdx` — Unified lab (1308 lines). Track C content at: Step 2 (line 111-117), Steps 9-10 (AlertManager), Step 11 (K8s CronJob), Steps 12-16 (GitHub, Telegram)

### Target File (Create)
- `course-site/docs/module-11-triggers/lab/LAB-track-c-kubernetes.mdx` — New Track C lab

### Module README (Update)
- `course-site/docs/module-11-triggers/README.mdx` — Add Track C lab reference

### Infrastructure Files (Referenced in Lab)
- `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml` — PrometheusRule for PodCrashLooping
- `infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml` — K8s CronJob manifest
- `infrastructure/scenarios/k8s/cronjob/` — Dockerfile for CronJob image
- `infrastructure/scenarios/k8s/github-webhook/smee-setup.sh` — GitHub webhook setup script
- `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` — Crashloop scenario for AlertManager demo
- `infrastructure/helm/prometheus-lab-values.yaml` — Helm values for Prometheus stack

### Agent Profile (Referenced)
- `agents/track-c-kubernetes/` — Kiran agent profile (SOUL.md, config.yaml, skills/)

</canonical_refs>

<specifics>

## Track C Lab Structure

### Frontmatter
```yaml
id: module-11-lab-track-c
title: "Module 11 Lab: Triggers & Scheduling for Kubernetes (Track C)"
sidebar_label: "Lab — Track C: Kubernetes"
sidebar_position: 2
```

### Step Outline

**Prerequisites (5 min)**
- Verify KIND cluster: `kubectl cluster-info --context kind-lab`
- Verify Track C agent: `hermes -p track-c chat` → agent responds
- Verify Hermes gateway capability: `hermes --version`

**Step 1: Hermes Cron — Daily K8s Health Check (10 min)**
- `hermes cron create daily-k8s-check --schedule "0 8 * * *" --skill kubernetes-health --prompt "Run morning pod health check across all namespaces"`
- Trigger manually: `hermes cron trigger daily-k8s-check`
- Verify output shows real kubectl results from KIND cluster
- Pause/resume lifecycle

**Step 2: AlertManager — Prometheus Stack + Webhook (20 min)**
- Enable AlertManager in Helm values
- `helm upgrade --install` Prometheus stack
- Apply PrometheusRule: `kubectl apply -f infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml`
- Verify rule loaded in Prometheus UI
- Apply crashloop scenario: `kubectl apply -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml`
- Start gateway: `hermes gateway start`
- Subscribe: `hermes webhook subscribe alertmanager --url http://localhost:9093`
- Observe: AlertManager fires PodCrashLooping → agent receives webhook → runs diagnosis

**Step 3: K8s CronJob — Agent as a Kubernetes Workload (15 min)**
- Build Docker image: `docker build -t hermes-lab:cronjob infrastructure/scenarios/k8s/cronjob/`
- Load to KIND: `kind load docker-image hermes-lab:cronjob --name lab`
- Create secret with API key
- Apply CronJob: `kubectl apply -f infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml -l track=track-c`
- Watch execution: `kubectl get pods -w`
- Read logs from completed pod
- Clean up

**Step 4: GitHub Webhook — PR Review Bot (15 min)**
- Get smee.io channel
- Get GitHub PAT
- Start gateway + smee-client
- Add webhook to GitHub repo
- Subscribe: `hermes webhook subscribe github`
- Push a commit, observe agent comment

**Step 5: Telegram Bot — Chat Interface (10 min)**
- Create bot via @BotFather
- Get user ID via @userinfobot
- Configure env vars (TELEGRAM_BOT_TOKEN, TELEGRAM_ALLOWED_USERS)
- Start gateway with Telegram adapter
- Send `/diagnose` from phone → agent responds with pod health

**Verification Checklist (5 min)**
- All 5 triggers verified

**Free Explore (20 min)**
- Challenge 1: Cross-namespace cron (check kube-system + default)
- Challenge 2: AlertManager → Telegram notification chain
- Challenge 3: GitHub PR triggers full diagnosis and posts report

</specifics>

<deferred>

## Deferred Ideas

- Slack integration (production reference only, not hands-on in Track C)
- CloudWatch webhook (not relevant for K8s track)

</deferred>

---
*Phase: 12*
*Context gathered: 2026-04-09*
