# K8s CronJob — Scheduled Agent via Kubernetes Primitives

**Phase 8 / TRIG-02** — Demonstrates running a scheduled Hermes agent as a native K8s CronJob resource, for comparison with the Hermes-cron primary pattern taught in Module 12 Steps 2-4.

## When to use which pattern

Module 12 teaches **both** Hermes cron and K8s CronJob because they serve different use cases. Neither is universally better — pick based on what your agent actually needs.

### Use Hermes cron when:

- **The agent benefits from gateway-shared state** — loaded skills, audit trail, conversation history, config hot-reload. Hermes cron lives inside the gateway process and has immediate access to all of this.
- **You want one-stop CLI management** — `hermes cron create/list/trigger/pause/resume` is the whole API. No kubectl context switching.
- **You're iterating fast** — tweak a prompt, re-register the cron, done. No image rebuild, no kubectl apply cycle.
- **You need audit trail context** — Hermes sessions link cron runs to the skill and prompt version. K8s CronJob history is just pod logs.
- **You're not (yet) in Kubernetes** — Hermes cron runs wherever the gateway runs. Laptops, VMs, bare-metal servers.

### Use K8s CronJob when:

- **Stateless one-shot diagnostics** — the agent doesn't need any state carried from previous runs.
- **GitOps-managed schedules** — you want the schedule and prompt in git, reviewed via PR, deployed via ArgoCD or Flux. `CronJob` YAML fits this perfectly.
- **K8s-native observability** — you want Prometheus `kube_job_status_*` metrics, `kubectl get jobs`, pod log aggregation via Loki/Vector. All free with K8s.
- **Multi-tenant / multi-team environments** — namespace isolation, NetworkPolicies, resource quotas, Secrets, ServiceAccounts. All native K8s primitives.
- **You want declarative scaling** — `parallelism`, `completions`, `backoffLimit`, `ttlSecondsAfterFinished` — all on the K8s object.

### Real-world honest stance

Most agent work uses **Hermes cron** because state matters. The skill is already loaded in the gateway, the conversation history from yesterday's run informs today's run, and managing schedules alongside manual runs is frictionless.

**K8s CronJob shines for fire-and-forget diagnostic jobs** — the kind where you never need to correlate today's run with yesterday's, you just want "is the cluster OK?" dropped into a ticket at 08:00 UTC every day, deployed via the same GitOps pipeline as everything else.

## Files

- `Dockerfile` — Minimal hermes-agent container image (python:3.12-slim based)
- `agent-health-check.yaml` — Three per-track CronJob manifests (Track A/B/C)
- `README.md` — This file

## Build and apply

```bash
# 1. Build the minimal hermes-agent image (~700-900MB, mostly Python deps)
docker build -t hermes-lab:cronjob infrastructure/scenarios/k8s/cronjob/

# 2. Load the image into KIND (required because CronJob uses imagePullPolicy: IfNotPresent)
kind load docker-image hermes-lab:cronjob --name lab

# 3. Create the Anthropic API key secret (never commit tokens to git)
kubectl create secret generic hermes-secrets \
  --from-literal=anthropic-api-key="$ANTHROPIC_API_KEY"

# 4. Apply ONE track's CronJob (pick your track)
kubectl apply -f infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml -l track=track-c

# 5. Watch jobs spawn
watch kubectl get jobs,pods

# 6. View logs from the latest job
kubectl logs -l job-name=$(kubectl get jobs -o jsonpath='{.items[-1].metadata.name}')
```

## Phase 7 governance inheritance

The CronJob container sets `HERMES_LAB_GOVERNANCE=L2` and `HERMES_LAB_TRACK=track-*`. These env vars propagate into the container, and the Phase 7 wrappers (`infrastructure/wrappers/mock-kubectl`, `mock-aws`, `mock-psql`) read them to enforce the `wrapper_allowlist` from the corresponding `governance/governance-L2.yaml` (or track-specific file).

**Teaching point:** Scheduled agents running unattended are MORE dangerous than interactive ones because no human is watching. Phase 7 governance applies automatically, so a scheduled agent inherits the same "delete/drain/exec" prohibitions as its interactive counterpart. There is no special "scheduled agent" governance — it's the same L1-L4 progression, just dispatched differently.

## Why `imagePullPolicy: IfNotPresent` is required

Without it, each CronJob run attempts to pull `hermes-lab:cronjob` from a remote registry, which fails because the image was loaded locally via `kind load docker-image` and no registry entry exists. See 08-RESEARCH.md Pitfall 4.

## Why the image is ~700-900MB, not under 100MB

hermes-agent has transitive dependencies on `python-telegram-bot`, `aiohttp`, `pydantic`, `openai`, `anthropic`, and the full `[messaging,cron]` extras set. The official image (`nousresearch/hermes-agent:latest`) is ~2-3GB because it also bundles Playwright, ffmpeg, Node.js, and Chromium for Hermes's web-automation use cases. This CronJob Dockerfile strips those out since a diagnostic agent doesn't need a headless browser.

## Cleanup

```bash
kubectl delete -f infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml
kubectl delete secret hermes-secrets
```
