# Phase 8: Agent Triggers — Research

**Researched:** 2026-04-07
**Domain:** Hermes gateway triggers (AlertManager webhook, K8s CronJob, GitHub webhook via smee.io, Telegram chat bot)
**Confidence:** HIGH (all 4 trigger paths verified against Hermes source; external services confirmed live)

---

## DISCOVERED BLOCKERS — READ BEFORE PLANNING

Two items require decisions before tasks are written:

**BLOCKER-01 (Resolved — no blocker): Telegram adapter EXISTS.**
`gateway/platforms/telegram.py` (2145 lines) is a full-featured Telegram platform adapter using `python-telegram-bot` v22.6+. It handles both inbound slash commands (`_handle_command` at line 1549) and outbound delivery. The adapter is NOT a new build — it ships with Hermes today. The install extra is `pip install -e ".[messaging]"` (or `[all]`). `TELEGRAM_BOT_TOKEN` env var activates it. Admin user restriction via `TELEGRAM_ALLOWED_USERS` env var. **No new code needed for basic TRIG-04.**

**BLOCKER-02 (Decision required): Hermes Docker image is published but built from source.**
`nousresearch/hermes-agent:latest` exists on Docker Hub (GitHub Actions `docker-publish.yml` confirms). The image is `debian:13.4` + `pip install -e ".[all]"` + Playwright. It is NOT a tiny Alpine image. This is too large for K8s CronJob in a lab (Playwright, ffmpeg, Node.js all included; image is likely 2-3GB+). Two options for the K8s CronJob step:
- **Option A (recommended):** Ship a minimal `infrastructure/scenarios/k8s/cronjob/Dockerfile` based on `python:3.12-slim` + `pip install "hermes-agent[messaging,cron]" --extra-index-url ...`. NOTE: `hermes-agent` is NOT on PyPI — must install from GitHub: `pip install "git+https://github.com/NousResearch/hermes-agent.git[messaging,cron]"`. Image is smaller (~800MB still due to deps, but no Playwright/ffmpeg).
- **Option B:** Reference `nousresearch/hermes-agent:latest` with an `imagePullPolicy: IfNotPresent` and document the 2-3GB pull in a warning callout.
- **Researcher recommends Option A** — the Dockerfile becomes a teaching artifact about "packaging agents for K8s."

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Lab Structure**
- D-01: Extend Module 12 (don't rewrite). Existing Steps 1-8 stay intact. Phase 8 adds GUIDED steps after Step 8. Free explore section shifts to end. Final count approximately 16-18 GUIDED steps.
- D-02: Phase 7 governance inherited universally — HERMES_LAB_GOVERNANCE from execution environment (CronJob env, gateway process env, bot config).

**TRIG-01: AlertManager Webhook**
- D-03: Full real Prometheus + AlertManager stack on KIND. Enable `alertmanager.enabled: true` in `infrastructure/helm/prometheus-lab-values.yaml`.
- D-04: Alert fires on Phase 6 crashloop2 scenario (namespace `k8s-trouble-crashloop`). Rule: `increase(kube_pod_container_status_restarts_total{namespace="k8s-trouble-crashloop"}[2m]) > 2`, for 30s.
- D-05: Networking via `host.docker.internal:8644`. KIND extraPortMapping research-gated.
- D-06: New `infrastructure/scenarios/k8s/alertmanager/` directory for PrometheusRule manifest.
- D-07: New `hermes webhook subscribe alertmanager` with `--events alertmanager-alert`.

**TRIG-02: K8s CronJob**
- D-08: Hermes cron is PRIMARY (Module 12 Steps 2-4 reframed as production pattern).
- D-09: ONE new K8s CronJob comparison step only.
- D-10: "Use this when…" callout documenting Hermes cron vs K8s CronJob tradeoffs.
- D-11: K8s CronJob image source research-gated (see BLOCKER-02 above).

**TRIG-03: GitHub Webhook**
- D-12: smee.io public proxy + real GitHub webhook as primary path.
- D-13: Solo Learner fallback: `hermes webhook test github-pr --payload '{...}'`.
- D-14: GitHub PAT scope: `repo` (classic PAT). Stored in `~/.hermes/secrets/github.token` or `GITHUB_TOKEN`.
- D-15: Agent posts review comment back via `gh pr comment`.

**TRIG-04: Telegram Chat Bot**
- D-16: Telegram primary, hands-on. @BotFather flow. `hermes gateway setup` with telegram enabled.
- D-17: Slack documented as production reference ONLY, NOT hands-on.
- D-18: Three slash commands: `/diagnose <arg>`, `/status`, `/help`.
- D-19: Default L2 governance; `/diagnose --governance L4 <arg>` for admin override (admin_user_ids allowlist).
- D-20: Reply in same Telegram chat thread. 4096 char limit applies.

**Cross-Cutting**
- D-21: Step numbering: Steps 1-8 stay; new Steps 9-16 for 4 triggers; free explore shifts down.
- D-22: Per-track variants in callouts (Track A/B/C).
- D-23: Both Module 12 lab mirrors updated (`.mdx` and `modules/module-12-triggers/LAB.md`).
- D-24: Reading reference.mdx light-touch update with 4 trigger type table.
- D-25: 2-3 new quiz questions.
- D-26: New env vars: `GITHUB_TOKEN`, `TELEGRAM_BOT_TOKEN`, `SMEE_URL`.

### Claude's Discretion
- Exact PrometheusRule expression syntax
- AlertManager receiver YAML format (config_reload helm values vs ConfigMap)
- Specific Dockerfile contents for K8s CronJob image (if Hermes doesn't publish a minimal one)
- Telegram bot adapter implementation in Hermes (confirmed: it exists)
- smee-client installation method (npm vs npx vs binary download)
- Exact wording of "use Hermes cron when…" callout
- Module 12 reading reference.mdx structural changes
- Quiz question phrasing
- Whether to add Phase 8 exploratory PROJECTS.mdx entry

### Deferred Ideas (OUT OF SCOPE)
- Multi-agent orchestration via triggers (Phase 9 / FLEET-01)
- Fleet coordinator (Morgan) wiring (Phase 9 / FLEET-02)
- K8s Agent Sandbox (Phase 9 / PROD-01)
- Productionization patterns (Phase 9 / PROD-02)
- Discord adapter (v1.2)
- GitLab webhook (v1.2)
- Mattermost/Rocket.Chat adapters (v1.2)
- Telegram bot deployed as K8s Pod (Phase 9 + v1.2)
- AlertManager grouping/inhibition tuning (v1.2)
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| TRIG-01 | AlertManager webhook triggers triage agent that diagnoses pod issues on KIND with Prometheus stack | Hermes webhook adapter confirmed (webhook.py), AlertManager payload format verified, PrometheusRule API confirmed, KIND networking path researched |
| TRIG-02 | K8s CronJob scheduled agent runs periodic health checks and reports status | Hermes cron API verified (cron.py), K8s CronJob manifest pattern documented, image source decision resolved (BLOCKER-02) |
| TRIG-03 | GitHub webhook/command triggers PR review bot agent | smee.io confirmed alive, smee-client v5.0.0 current, github_comment deliver type built into webhook adapter, gh CLI required |
| TRIG-04 | Chat bot via Telegram — slash commands trigger agent workflows, results posted back | Telegram adapter fully exists in gateway/platforms/telegram.py, CommandHandler registered, TELEGRAM_BOT_TOKEN env var activates it, python-telegram-bot v22.6+ in [messaging] extra |
</phase_requirements>

---

## Summary

All four trigger mechanisms are implementable with existing Hermes infrastructure. The Telegram bot adapter is production-quality (2145-line file, full slash command support via `CommandHandler`, long-polling mode by default). The webhook adapter has a built-in `github_comment` deliver type that uses `gh pr comment` — no custom code needed for GitHub PR feedback. The webhook default port is 8644 (confirmed in `hermes_cli/webhook.py`). smee.io is alive (landing page active April 2026), smee-client v5.0.0 published November 2025.

The primary unresolved design choice is the K8s CronJob container image. Hermes publishes `nousresearch/hermes-agent:latest` on Docker Hub, but the image includes Playwright/ffmpeg and is large. The recommended approach ships a minimal `Dockerfile` in `infrastructure/scenarios/k8s/cronjob/` using `python:3.12-slim` + `pip install "git+https://github.com/NousResearch/hermes-agent.git[messaging,cron]"`. This becomes a teaching artifact.

KIND's `cluster-config.yaml` does NOT currently expose port 8644 via `extraPortMappings`. On macOS with Docker Desktop, `host.docker.internal` resolves correctly from within KIND pods WITHOUT a port mapping — this is Docker Desktop behavior (DNS resolution to host, not a port forward). On Linux Docker (not Docker Desktop), an explicit port mapping IS needed. The lab should document this distinction with a Solo Learner callout for the Linux edge case.

**Primary recommendation:** All four trigger paths use existing Hermes platform adapters — no new Hermes adapter code is required. Phase 8 is a content and infrastructure configuration phase.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| python-telegram-bot | >=22.6, <23 | Hermes Telegram adapter dependency | Ships in `hermes-agent[messaging]`; CommandHandler natively handles slash commands |
| aiohttp | >=3.13.3, <4 | Hermes webhook server | Ships in `hermes-agent[messaging]`; already running when gateway is active |
| smee-client | 5.0.0 (npm) | Public webhook proxy client for TRIG-03 | Probot's official client; last published Nov 2025; installs as `npx smee-client` |
| kube-prometheus-stack | Current via Helm | AlertManager + Prometheus on KIND | Standard cloud-native monitoring stack; `alertmanager.enabled: true` toggle |
| python-telegram-bot | >=22.6 | Long-polling Telegram bot | Async by default; handles both commands and text messages |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| gh CLI | Current | Post GitHub PR comments from webhook deliver | Required for `github_comment` deliver type in webhook adapter |
| kubectl | >=1.28 | Apply K8s CronJob manifest for TRIG-02 | Already present from Phase 6 KIND labs |
| helm | 3.x | Update kube-prometheus-stack with AlertManager enabled | Phase 1 infra, already installed |
| python:3.12-slim | Docker base | K8s CronJob container image base | Minimal, arm64/amd64 multi-arch, low overhead |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| smee.io | ngrok free tier | ngrok free tier now requires account; smee.io is sessionless (no account needed) |
| smee.io | localtunnel (`npx localtunnel`) | localtunnel still works but less reliable; smee.io is GitHub-endorsed for webhook testing |
| Long-polling Telegram | Telegram webhook mode | Webhook mode needs public HTTPS URL; long polling works from behind NAT/firewall (correct for lab) |
| `nousresearch/hermes-agent:latest` | Custom Dockerfile | Official image is 2-3GB (Playwright/ffmpeg); custom Dockerfile is ~800MB and is a teaching artifact |
| `gh pr comment` via webhook adapter | Direct `curl` to GitHub API | `gh pr comment` is simpler and `gh` is already installed in lab environment from Phase 1 |

**Installation:**
```bash
# smee-client (for TRIG-03 GitHub webhook)
npx smee-client --url $SMEE_URL --target http://localhost:8644/webhooks/github

# Hermes with messaging extras (already installed if participant ran setup-hermes.sh)
pip install -e ".[all]"

# Verify telegram dependency installed
python3 -c "from telegram import Bot; print('telegram OK')"
```

**Version verification:**
- smee-client: `npm view smee-client version` → 5.0.0 (verified 2026-04-07)
- python-telegram-bot: `pip show python-telegram-bot` → 22.6+ (in hermes-agent[messaging])
- hermes-agent: `hermes --version` → 0.7.0 (pyproject.toml)

---

## Architecture Patterns

### Recommended Project Structure (Phase 8 additions)
```
infrastructure/
├── helm/
│   └── prometheus-lab-values.yaml     # MODIFY: alertmanager.enabled: true
├── kind/
│   └── cluster-config.yaml            # MAYBE MODIFY: extraPortMappings for Linux
├── scenarios/
│   └── k8s/
│       ├── 02-crashloop-backoff.yaml  # EXISTING — TRIG-01 fires on this
│       └── alertmanager/              # NEW (D-06)
│           ├── prometheus-rules.yaml  # PrometheusRule manifest
│           ├── alertmanager-config.yaml  # AlertManager receiver ConfigMap
│           └── README.md              # Flow diagram: pod → kube-state-metrics → rule → AM → Hermes
│       └── cronjob/                   # NEW (D-09)
│           ├── agent-health-check.yaml   # K8s CronJob manifest
│           └── Dockerfile             # Minimal hermes image for K8s (BLOCKER-02 resolution)
course-site/docs/module-12-triggers/
├── lab/
│   └── LAB.mdx                        # EXTEND: Steps 9-16 after existing Step 8
├── reading/
│   └── reference.mdx                  # LIGHT TOUCH: 4 trigger types comparison table
└── quiz/
    └── QUIZ.mdx                       # ADD: 2-3 questions
modules/module-12-triggers/
└── LAB.md                             # MIRROR: same changes as LAB.mdx
```

### Pattern 1: AlertManager Webhook Trigger (TRIG-01)

**What:** PrometheusRule fires on `kube_pod_container_status_restarts_total` increase. AlertManager receiver POSTs to Hermes webhook gateway. Agent receives the alert payload and diagnoses the pod.

**When to use:** Event-driven incident response triggered by real Prometheus alerting infrastructure.

```yaml
# Source: infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml
# Prometheus Operator PrometheusRule CRD
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: hermes-lab-rules
  namespace: monitoring
  labels:
    release: kube-prometheus  # Must match the Helm release label selector
spec:
  groups:
    - name: hermes-lab.k8s-crashloop
      rules:
        - alert: PodCrashLooping
          expr: increase(kube_pod_container_status_restarts_total{namespace="k8s-trouble-crashloop"}[2m]) > 2
          for: 30s
          labels:
            severity: warning
            track: c
          annotations:
            summary: "Pod {{ $labels.pod }} restarting repeatedly"
            namespace: "{{ $labels.namespace }}"
```

```yaml
# AlertManager receiver config (via helm values override)
# Source: infrastructure/scenarios/k8s/alertmanager/alertmanager-config.yaml
alertmanager:
  enabled: true
  config:
    global:
      resolve_timeout: 5m
    route:
      group_by: ['alertname', 'namespace']
      group_wait: 10s
      group_interval: 5m
      repeat_interval: 12h
      receiver: hermes-webhook
    receivers:
      - name: hermes-webhook
        webhook_configs:
          - url: "http://host.docker.internal:8644/webhooks/alertmanager"
            send_resolved: false
```

**Hermes webhook subscription:**
```bash
hermes webhook subscribe alertmanager \
  --events "alertmanager-alert" \
  --prompt "AlertManager fired: {alerts} — Diagnose the affected pod. Load the kubernetes-pod-health skill." \
  --skill "sre-k8s-pod-health" \
  --deliver local
```

**Payload template note:** `{alerts}` expands to the full `alerts` array as JSON (2000 char limit). The agent sees the full alert context including `labels.pod`, `labels.namespace`, `annotations.summary`. The prompt template dot-notation (`{alerts[0].labels.pod}`) does NOT work for array index access — use `{alerts}` to pass the full array and let the agent parse it.

### Pattern 2: K8s CronJob (TRIG-02)

**What:** A Kubernetes CronJob manifest invokes `hermes run` in a container on a schedule. The container has Hermes installed, governance env vars set, and skill files mounted.

**When to use:** GitOps-managed schedules, stateless one-shot diagnostics, multi-tenant K8s environments where native K8s primitives are preferred.

```yaml
# Source: infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hermes-k8s-health
  namespace: default
spec:
  schedule: "*/5 * * * *"  # Every 5 min for lab; change to "0 8 * * *" for production
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: hermes-agent
              image: hermes-lab:cronjob  # Built from infrastructure/scenarios/k8s/cronjob/Dockerfile
              imagePullPolicy: IfNotPresent
              env:
                - name: HERMES_LAB_MODE
                  value: "mock"
                - name: HERMES_LAB_SCENARIO
                  value: "crashloop2"
                - name: HERMES_LAB_GOVERNANCE
                  value: "L2"
                - name: HERMES_LAB_TRACK
                  value: "track-c"
                - name: MOCK_DATA_DIR
                  value: "/data/mock-data/kubernetes"
                - name: ANTHROPIC_API_KEY
                  valueFrom:
                    secretKeyRef:
                      name: hermes-secrets
                      key: anthropic-api-key
              command:
                - hermes
                - run
                - --skill
                - sre-k8s-pod-health
                - --prompt
                - "Run daily K8s cluster health check. Report only if pods or nodes show issues."
```

**K8s CronJob "use this when" decision criteria (D-10):**
| Pattern | Use When |
|---------|----------|
| Hermes cron | Agent needs gateway state (skills, audit trail, conversation history), fast iteration, not in K8s |
| K8s CronJob | Stateless one-shot, GitOps schedule-in-git, K8s-native observability, multi-tenant resource quotas |

### Pattern 3: GitHub Webhook via smee.io (TRIG-03)

**What:** smee.io public channel relays GitHub webhook events to local Hermes gateway. The webhook adapter fires the agent with PR context, then posts a comment back via `gh pr comment`.

**When to use:** Hands-on lab for GitHub webhook trigger without requiring public HTTPS endpoint.

```bash
# Step 1: Get a smee.io channel (visit https://smee.io/ → "Start a new channel")
export SMEE_URL="https://smee.io/YOUR_CHANNEL_ID"

# Step 2: Run smee-client to forward events to local gateway
npx smee-client --url $SMEE_URL --target http://localhost:8644/webhooks/github

# Step 3: Subscribe Hermes webhook to receive github events
hermes webhook subscribe github \
  --events "pull_request" \
  --prompt "GitHub PR event received: PR #{pull_request.number} — {pull_request.title}. Briefly review the changes and post a summary comment." \
  --deliver github_comment \
  --deliver-chat-id "{repository.full_name}:{pull_request.number}"
```

**Built-in `github_comment` deliver type:**
The webhook adapter (line 525-558 of `gateway/platforms/webhook.py`) has native `github_comment` delivery that calls `gh pr comment {pr_number} --repo {repo} --body "{content}"`. This requires `gh` CLI authenticated with `GITHUB_TOKEN`. No custom code needed.

**GitHub PAT requirements:**
- Classic PAT: `repo` scope (read/write to repo, needed for posting comments)
- Fine-grained PAT alternative: "Pull requests" permission (Read and Write) on target repo
- Storage: `export GITHUB_TOKEN="ghp_..."` or `~/.hermes/.env` (gitignored)

**Solo Learner fallback (D-13):**
```bash
hermes webhook test github \
  --payload '{"pull_request": {"number": 42, "title": "feat: add health endpoint", "body": "Adds /health route"}, "repository": {"full_name": "octocat/test-repo"}}'
```

### Pattern 4: Telegram Chat Bot (TRIG-04)

**What:** Real Telegram bot using @BotFather token, connected to Hermes gateway. Participants send `/diagnose`, `/status`, or `/help` commands — bot replies in the same chat thread.

**Setup:**
```bash
# Bot setup — one time
# 1. In Telegram: search @BotFather → /newbot → get token
export TELEGRAM_BOT_TOKEN="123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

# 2. Configure Hermes gateway (hermes gateway setup with telegram enabled)
# OR add to ~/.hermes/.env:
# TELEGRAM_BOT_TOKEN=...
# TELEGRAM_ALLOWED_USERS=your_telegram_user_id   # Restrict to yourself

# 3. Start gateway with telegram enabled
hermes gateway run

# 4. Test in Telegram
# Send: /help
# Expected: Bot replies with command list
# Send: /diagnose crashloop-pod
# Expected: Bot runs sre-k8s-pod-health skill and replies with diagnosis
```

**Telegram adapter key facts:**
- `_handle_command` method at line 1549 handles ALL slash commands by default (no per-command registration needed)
- Commands are passed through to agent as plain text (e.g., `/diagnose pod-name` becomes the agent's prompt)
- `TELEGRAM_ALLOWED_USERS` env var restricts bot to comma-separated user IDs (this is the admin_user_ids mechanism from D-19)
- Message length limit: 4096 chars (enforced in `TelegramAdapter.MAX_MESSAGE_LENGTH`)
- Adapter automatically splits long messages into multiple Telegram messages (truncation at 4096 per message)
- Replies in same chat thread via `_should_thread_reply` method
- Long polling mode by default (correct for lab — works behind NAT/firewall)

**Governance per-command override (D-19):**
The HERMES_LAB_GOVERNANCE env var is set at gateway startup and inherited by all agent runs triggered by the Telegram bot. To implement the `/diagnose --governance L4` override, the lab step walks participants through modifying the gateway env and restarting — the governance level is per-process, not per-message. The `TELEGRAM_ALLOWED_USERS` restriction implements the "admin user" gating.

**Slack as production reference (D-17):**
Hermes has a full Slack adapter (`gateway/platforms/slack.py`) using `slack-bolt>=1.18.0`. Configuration is identical to Telegram: `SLACK_BOT_TOKEN` env var + `hermes gateway setup`. Document as :::note Demo-only section with config snippets but no hands-on steps.

### Anti-Patterns to Avoid
- **Using `alertmanager.enabled: true` without the PrometheusRule label selector.** The kube-prometheus-stack uses label selectors to discover PrometheusRule CRDs. The rule MUST have `release: kube-prometheus` (or whatever the Helm release name is) in its labels, otherwise Prometheus never loads it.
- **Using `{alerts[0].labels.pod}` array index in webhook prompt template.** The Hermes webhook adapter's `_render_prompt` method resolves dot-notation by traversing dict keys only. Array index access (`[0]`) is NOT supported. Use `{alerts}` to get the full JSON-serialized array and let the agent extract what it needs.
- **Starting the Telegram bot before stopping other gateway instances.** The Telegram adapter has a single-token lock (`acquire_scoped_lock`). Two gateway instances using the same token cause a `telegram_polling_conflict` fatal error after 3 retries (line 296).
- **Omitting `imagePullPolicy: IfNotPresent` in K8s CronJob.** Without this, each CronJob run attempts to pull the image, which fails if the image was loaded locally via `kind load docker-image`.
- **Using `host.docker.internal` on Linux without explicit extraPortMapping.** On macOS (Docker Desktop), `host.docker.internal` resolves from KIND pods without a port mapping. On Linux Docker (not Docker Desktop), a KIND `extraPortMappings` entry is required.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Telegram bot inbound command handling | Custom Python telegram bot | `gateway/platforms/telegram.py` in Hermes | Full adapter already exists; handles polling, auth, slash commands, thread replies |
| GitHub PR comment posting | `curl` to GitHub API | `deliver: github_comment` in webhook subscription + `gh pr comment` CLI | Built into `webhook.py` lines 525-558; handles retries, auth, error logging |
| Webhook payload templating | Custom Jinja2 renderer | Hermes `--prompt` template with `{field.path}` interpolation | Already implemented in `_render_prompt()` at line 488; dot-notation access |
| AlertManager → agent wiring | Custom Python listener | `hermes webhook subscribe alertmanager` | Same webhook pathway already used for CloudWatch in Module 12 Steps 6-7 |
| Webhook signature validation | Custom HMAC code | Hermes built-in HMAC (`_validate_signature` in `webhook.py`) | Handles X-Hub-Signature-256 (GitHub), X-Gitlab-Token, and generic X-Webhook-Signature |
| Public tunnel for local webhook testing | ngrok | smee.io + `npx smee-client` | No account required, GitHub-endorsed, stable 3+ years |

**Key insight:** All four trigger types use Hermes gateway infrastructure that participants have already configured in Module 12 Steps 5-7. Phase 8's teaching is about wiring REAL external sources to the already-running gateway, not about building new infrastructure.

---

## Common Pitfalls

### Pitfall 1: PrometheusRule Label Selector Mismatch
**What goes wrong:** PrometheusRule manifest is applied but never loaded by Prometheus. Alert never fires regardless of pod restarts.
**Why it happens:** kube-prometheus-stack Helm chart configures Prometheus to only watch PrometheusRule CRDs with specific labels (typically `release: kube-prometheus`). Missing this label = silently ignored.
**How to avoid:** Include `labels: release: kube-prometheus` in the PrometheusRule metadata. Verify with `kubectl get prometheusrule -n monitoring -o yaml | grep -A2 labels`.
**Warning signs:** `hermes cron trigger` receives no events after crashloop pod is applied. `kubectl get prometheusrule` shows the resource but Prometheus `targets` page doesn't list it.

### Pitfall 2: AlertManager Receives Alert But Gateway is Down
**What goes wrong:** AlertManager fires, logs show POST attempt to `host.docker.internal:8644`, but Hermes never receives it.
**Why it happens:** Participant didn't run `hermes gateway run` before applying the crashloop pod. AlertManager fires within 30s; if the gateway wasn't started first, the event is lost (AlertManager retries for `group_interval` duration, typically 5 min).
**How to avoid:** Lab step order matters: (1) start gateway, (2) subscribe webhook, (3) apply crashloop pod. Add a checklist callout at the start of Step 9.
**Warning signs:** `curl http://localhost:8644/health` returns connection refused.

### Pitfall 3: host.docker.internal on Linux Docker (non-Desktop)
**What goes wrong:** AlertManager POST to `host.docker.internal:8644` fails with DNS resolution error in cluster logs. Agent never receives the alert.
**Why it happens:** `host.docker.internal` is Docker Desktop's convenience DNS name. On Linux with native Docker (not Docker Desktop), KIND nodes cannot resolve this name without additional configuration.
**How to avoid:** On Linux, add `extraPortMappings` entry for port 8644 in `cluster-config.yaml` AND change the AlertManager receiver URL to `http://172.17.0.1:8644/webhooks/alertmanager` (the default docker0 bridge gateway IP). Document as a Linux-specific Solo Learner callout.
**Warning signs:** `kubectl logs -n monitoring -l app.kubernetes.io/name=alertmanager` shows dial error for host.docker.internal.

### Pitfall 4: Telegram Polling Conflict
**What goes wrong:** `hermes gateway run` starts, Telegram section shows fatal error: "Another Telegram bot poller is already using this token."
**Why it happens:** A previous gateway instance wasn't properly stopped. Telegram's `getUpdates` long-poll holds a session for ~30 seconds after disconnect.
**How to avoid:** `hermes gateway stop` before restarting. Wait 30-35 seconds between stop and start if conflict persists. Lab step should explicitly call `hermes gateway stop` before setup.
**Warning signs:** Gateway starts other platforms fine but exits for Telegram specifically.

### Pitfall 5: smee.io Channel URL Mismatch
**What goes wrong:** GitHub webhook fires, smee.io relays correctly, but Hermes receives nothing.
**Why it happens:** Participant set the smee.io channel URL in GitHub webhook settings correctly, but ran `smee --url $SMEE_URL --target http://localhost:8644/webhooks/github` with the WRONG target route name (e.g., `github-webhook` vs `github`).
**How to avoid:** Lab step must show the exact target URL matching the `hermes webhook subscribe` name. Convention: use `github` (matches subscription name → route `/webhooks/github`).
**Warning signs:** smee.io terminal shows "Forwarding events to localhost:8644/webhooks/github" but nothing appears in Hermes logs.

### Pitfall 6: K8s CronJob ANTHROPIC_API_KEY Not in Secret
**What goes wrong:** CronJob pod starts, hermes CLI launches, then immediately exits with "No API key configured".
**Why it happens:** The CronJob manifest references a Kubernetes Secret (`hermes-secrets`) that doesn't exist.
**How to avoid:** Lab step must include explicit `kubectl create secret generic hermes-secrets --from-literal=anthropic-api-key=$ANTHROPIC_API_KEY` before applying the CronJob manifest. Include verification: `kubectl get secret hermes-secrets`.
**Warning signs:** `kubectl logs -l job-name=hermes-k8s-health` shows authentication error on first line.

### Pitfall 7: GitHub PAT Scope Too Narrow
**What goes wrong:** Agent receives the PR event, generates a comment, webhook adapter runs `gh pr comment`, but it fails with 403 Unauthorized.
**Why it happens:** Participant created a fine-grained PAT with only "Contents" read permission, not "Pull requests" read+write permission.
**How to avoid:** Lab step specifies exact scope: classic PAT with `repo` scope, OR fine-grained PAT with "Pull requests: Read and Write." Show the GitHub settings page screenshot-equivalent in text.
**Warning signs:** `gh auth status` shows authentication OK but `gh pr comment` fails with 403.

---

## Code Examples

### AlertManager payload format (verified against Prometheus docs)
```json
{
  "version": "4",
  "groupKey": "{}:{alertname=\"PodCrashLooping\"}",
  "truncatedAlerts": 0,
  "status": "firing",
  "receiver": "hermes-webhook",
  "groupLabels": {"alertname": "PodCrashLooping"},
  "commonLabels": {"alertname": "PodCrashLooping", "namespace": "k8s-trouble-crashloop", "severity": "warning"},
  "commonAnnotations": {"summary": "Pod api-deployment-xyz restarting repeatedly"},
  "externalURL": "http://alertmanager:9093",
  "alerts": [
    {
      "status": "firing",
      "labels": {
        "alertname": "PodCrashLooping",
        "namespace": "k8s-trouble-crashloop",
        "pod": "api-deployment-xyz-abc12",
        "container": "api",
        "severity": "warning",
        "track": "c"
      },
      "annotations": {
        "summary": "Pod api-deployment-xyz-abc12 restarting repeatedly",
        "namespace": "k8s-trouble-crashloop"
      },
      "startsAt": "2026-04-07T10:00:00Z",
      "endsAt": "0001-01-01T00:00:00Z",
      "generatorURL": "http://prometheus:9090/...",
      "fingerprint": "abc123"
    }
  ]
}
```

**Template that works:**
```bash
# {alerts} expands to the full JSON array — the agent parses it
hermes webhook subscribe alertmanager \
  --events "alertmanager-alert" \
  --prompt "AlertManager PodCrashLooping alert fired. Details: {alerts}. Load the sre-k8s-pod-health skill and diagnose the affected pod in the namespace shown in the alert labels." \
  --skill "sre-k8s-pod-health" \
  --deliver local
```

**Template that does NOT work:**
```bash
# WRONG: array index access not supported in _render_prompt
--prompt "Pod {alerts[0].labels.pod} is crashing..."
```

### Hermes gateway Telegram config
```bash
# Source: .env.example lines 236-248
export TELEGRAM_BOT_TOKEN="123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
export TELEGRAM_ALLOWED_USERS="your_telegram_user_id"   # Get from @userinfobot
export TELEGRAM_HOME_CHANNEL="your_chat_id"             # For cron deliver=telegram

# OR in ~/.hermes/.env:
TELEGRAM_BOT_TOKEN=123456:ABC-DEF...
TELEGRAM_ALLOWED_USERS=987654321
```

### Minimum K8s CronJob Dockerfile
```dockerfile
# Source: infrastructure/scenarios/k8s/cronjob/Dockerfile (NEW)
# python:3.12-slim is ~130MB before deps; final image ~700-900MB with hermes-agent
FROM python:3.12-slim

# Install system dependencies for hermes-agent
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ripgrep nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install hermes-agent with messaging + cron extras (no Playwright/ffmpeg)
RUN pip install --no-cache-dir \
    "git+https://github.com/NousResearch/hermes-agent.git#egg=hermes-agent[messaging,cron]"

WORKDIR /work
ENTRYPOINT ["hermes"]
```

### KIND cluster config addition for Linux (if needed)
```yaml
# Add to infrastructure/kind/cluster-config.yaml extraPortMappings
# ONLY NEEDED on Linux Docker (not Docker Desktop)
extraPortMappings:
  # ... existing entries ...
  # Hermes webhook gateway (for AlertManager on Linux)
  - containerPort: 8644
    hostPort: 8644
    protocol: TCP
```

---

## Runtime State Inventory

*This phase is greenfield content authoring — no rename/refactor involved. The only runtime state items are external service credentials that participants acquire fresh.*

| Category | Items Found | Action Required |
|----------|-------------|-----------------|
| Stored data | No existing lab data stores references Phase 8 triggers | None |
| Live service config | KIND cluster (from Phase 6) does NOT expose port 8644 in extraPortMappings | Code edit to cluster-config.yaml (Linux path); none needed on macOS Docker Desktop |
| OS-registered state | None — Phase 8 creates new gateway subscriptions, not OS-level registrations | None |
| Secrets/env vars | TELEGRAM_BOT_TOKEN, GITHUB_TOKEN, SMEE_URL — all NEW, participants acquire fresh | Lab setup steps walk through acquisition |
| Build artifacts | No pre-existing K8s CronJob image; participants build from Dockerfile | Lab step: `docker build -t hermes-lab:cronjob infrastructure/scenarios/k8s/cronjob/` |

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| KIND | TRIG-01, TRIG-02 | ✓ | v0.27.0 (darwin/arm64) | — |
| Node.js / npm | smee-client (TRIG-03) | ✓ | Node v22.21.1, npm 10.9.4 | `pip install pysmee` (Python alternative) |
| Python 3.12+ | Hermes, K8s CronJob Dockerfile | ✓ | Python 3.13.7 | — |
| gh CLI | github_comment delivery (TRIG-03) | Likely present (Phase 1 infra) | Not confirmed — see note | `curl` to GitHub API as fallback |
| Hermes gateway | All 4 triggers | ✓ (Phase 6/7 dependency) | 0.7.0 | — |
| Docker | K8s CronJob image build | Not confirmed running | Docker Desktop check failed | See note |
| python-telegram-bot | TRIG-04 Telegram | In `[messaging]` extra | 22.6+ | — |
| Telegram account | TRIG-04 | Participant provides | — | Slack reference-only path |
| GitHub repo + PAT | TRIG-03 | Participant provides | — | `hermes webhook test` Solo Learner fallback |

**Missing dependencies with no fallback:**
- KIND cluster must be running for TRIG-01 and TRIG-02. Lab Step 9 should include a preflight check (`kubectl cluster-info`).

**Missing dependencies with fallback:**
- `gh` CLI: If not installed, TRIG-03 github_comment delivery fails silently. Lab should check `gh --version` and document fallback: use `--deliver log` and manually inspect output.
- Docker Desktop not confirmed running on this machine. K8s CronJob image build (TRIG-02) requires Docker. Lab should note: "If Docker Desktop is not running, start it now."

**Note on gh CLI:** Phase 1 lab installed gh CLI as part of the reference app setup. It should be present in participant environments. However, it must be authenticated: `gh auth status` should show logged in with `repo` scope.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Self-hosted webhook relay (custom Python) | smee.io public proxy + npx smee-client | 2019 (Probot v5) | Zero-setup tunnel; no ngrok account needed |
| Telegram Bot API polling via requests library | python-telegram-bot v20+ async ApplicationBuilder | 2022 (v20 async rewrite) | Async-native; CommandHandler registered per-app, not per-function |
| python-telegram-bot v13 synchronous API | v20+ async API (v22.6 in hermes-agent) | 2022 | All handlers are `async def`; breaking API change from v13 |
| OpenCode for multi-provider agent | Crush (charmbracelet/crush) | Sept 2025 | OpenCode archived; Crush is the successor |
| Gemini 2.0 Flash | Gemini 2.5 Flash | Feb 2026 (deprecation announced) | Model name in any lab content must use 2.5 generation |

**Deprecated/outdated:**
- `python-telegram-bot v13` synchronous API: handlers were registered as plain functions. v20+ requires async functions. Any old Hermes code referencing `Updater` instead of `Application` is pre-v20.
- AlertManager webhook_config `http_config.basic_auth`: deprecated in AlertManager v0.25+ for webhook receivers. Use HMAC via Hermes secret instead.

---

## Open Questions

1. **K8s CronJob image size acceptability**
   - What we know: `nousresearch/hermes-agent:latest` is ~2-3GB (includes Playwright, ffmpeg, Node.js, Chromium). A custom `python:3.12-slim` image with `hermes-agent[messaging,cron]` is still ~700-900MB.
   - What's unclear: Is 700-900MB acceptable for a lab image that participants `kind load docker-image` locally? Or does the lab skip the actual image build and just explain the pattern?
   - Recommendation: Ship the Dockerfile as a teaching artifact and use `kind load docker-image` for the lab. Document the pull size clearly. Alternative: make the K8s CronJob manifest step reference a pre-built tiny "echo agent" image as a placeholder, with the full Dockerfile as an exploratory extension.

2. **PrometheusRule label selector value**
   - What we know: kube-prometheus-stack uses a `ruleSelector` in its Prometheus CRD config. The default behavior depends on the helm chart values (`ruleSelector: {}` means all rules, vs matching labels).
   - What's unclear: What label selector is currently active in the course's kube-prometheus-stack installation? The existing `prometheus-lab-values.yaml` doesn't set `ruleSelector`.
   - Recommendation: Lab step should verify with `kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.ruleSelector}'`. If empty (`{}`), any PrometheusRule is picked up. If set, the PrometheusRule must match.

3. **hermes gateway run vs hermes gateway install in lab context**
   - What we know: `hermes gateway run` runs in foreground; `hermes gateway install` runs as a background service.
   - What's unclear: Do Phase 8 steps use foreground gateway (participants see log output from alerts firing) or background service (participants only see agent output)?
   - Recommendation: Use foreground (`hermes gateway run` in a second terminal) for the alert trigger steps — participants should see the live POST from AlertManager arrive. Use background for the Telegram bot steps (so Telegram bot stays running while participants use their phone).

---

## Sources

### Primary (HIGH confidence)
- `/Users/gshah/work/agentic/devops/hermes-agent/gateway/platforms/telegram.py` — Full Telegram adapter (2145 lines). CommandHandler, slash command handling, TELEGRAM_BOT_TOKEN config. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/gateway/platforms/webhook.py` — Webhook adapter with built-in `github_comment` deliver type, HMAC validation, `_render_prompt` dot-notation, AlertManager payload routing. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/gateway/config.py` — PlatformConfig, TELEGRAM_BOT_TOKEN env var at line 634, TELEGRAM_ALLOWED_USERS at line 240. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/.github/workflows/docker-publish.yml` — Confirms Docker Hub image `nousresearch/hermes-agent:latest` published on main branch push. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/Dockerfile` — FROM debian:13.4, pip install `.[all]`, includes Playwright. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/pyproject.toml` — `messaging` extra = `python-telegram-bot>=22.6,<23`. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/webhook.py` — Default port 8644 (line 78). `hermes webhook subscribe` command with `--events`, `--prompt`, `--skill`, `--deliver` flags. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/cron.py` — `hermes cron create/list/trigger/pause/resume/run/remove/status/tick`. Verified 2026-04-07.
- `/Users/gshah/work/agentic/devops/course/infrastructure/kind/cluster-config.yaml` — NO port 8644 in extraPortMappings. Confirmed 2026-04-07.
- `/Users/gshah/work/agentic/devops/course/infrastructure/helm/prometheus-lab-values.yaml` — `alertmanager.enabled: false`. Phase 8 sets to true. Confirmed 2026-04-07.
- `/Users/gshah/work/agentic/devops/course/course-site/docs/module-12-triggers/lab/LAB.mdx` — 8 GUIDED steps + FREE EXPLORE with 3 challenges. Step 8 is Slack. Phase 8 inserts after Step 8. Confirmed 2026-04-07.
- `/Users/gshah/work/agentic/devops/course/modules/module-12-triggers/LAB.md` — Source-of-truth mirror EXISTS. Confirmed 2026-04-07.
- Prometheus AlertManager webhook_config docs (https://prometheus.io/docs/alerting/latest/configuration/#webhook_config) — Payload structure verified: `{version, groupKey, status, alerts[]}` with `alerts[].labels` and `alerts[].annotations`. MEDIUM confidence (fetched 2026-04-07).

### Secondary (MEDIUM confidence)
- smee.io landing page (https://smee.io/) — No deprecation notice as of April 2026. Maintained by Probot team.
- `npm view smee-client` — v5.0.0, published 2025-11-25. Active maintenance confirmed.
- WebSearch: hermes-agent install — `pip install "git+https://github.com/NousResearch/hermes-agent.git"` works; not on PyPI directly. From official docs: https://hermes-agent.nousresearch.com/docs/getting-started/installation/

### Tertiary (LOW confidence)
- K8s CronJob image size estimate (~700-900MB for slim build) — Based on known python-telegram-bot + hermes deps; not verified by actual build.
- Docker Desktop `host.docker.internal` resolution from KIND pods — Based on established Docker Desktop behavior; not tested in this session. Official Docker Desktop docs confirm this is expected behavior.

---

## Metadata

**Confidence breakdown:**
- Telegram adapter: HIGH — source code read, all methods verified
- Webhook gateway: HIGH — source code read, github_comment delivery confirmed
- Hermes Docker image: HIGH — CI workflow read, confirms nousresearch/hermes-agent:latest on Docker Hub
- smee.io status: MEDIUM — landing page active, npm version current
- AlertManager payload format: MEDIUM — official docs verified
- host.docker.internal on Linux: MEDIUM — documented behavior, not tested
- K8s CronJob image size: LOW — estimate only

**Research date:** 2026-04-07
**Valid until:** 2026-05-07 (stable — Hermes source, AlertManager format, Telegram API)
