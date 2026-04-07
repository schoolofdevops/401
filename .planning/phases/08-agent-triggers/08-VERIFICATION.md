---
phase: 08-agent-triggers
verified: 2026-04-07T15:30:00Z
status: passed
score: 4/4 must-haves verified
re_verification: null
gaps: []
human_verification:
  - test: "AlertManager fires and Hermes gateway receives POST"
    expected: "After applying the crashloop2 scenario, the alert transitions from Pending to Firing within 2 minutes and the Hermes gateway logs show an incoming POST to /webhooks/alertmanager"
    why_human: "Requires a running KIND cluster with kube-prometheus-stack deployed; cannot verify webhook delivery programmatically without live infra"
  - test: "K8s CronJob spawns a Job pod and produces agent output"
    expected: "After kubectl apply -f agent-health-check.yaml, a Job pod spawns on schedule, runs hermes CLI, writes a status report, and completes with exit 0"
    why_human: "Requires live KIND cluster and locally-built hermes-lab:cronjob image; cannot verify without running infra"
  - test: "GitHub webhook arrives and agent posts review comment"
    expected: "After configuring smee.io and opening a PR, the Hermes gateway receives the event and posts a comment back via --deliver github_comment"
    why_human: "Requires live GitHub repo, PAT, smee.io channel, and running gateway; cannot verify externally"
  - test: "Telegram /diagnose command produces agent reply in chat"
    expected: "After starting gateway with TELEGRAM_BOT_TOKEN set, sending /diagnose <arg> receives an agent reply in the same chat thread within ~10 seconds"
    why_human: "Requires real Telegram bot token, running gateway, and Telegram client; cannot verify without live service"
---

# Phase 8: Agent Triggers Verification Report

**Phase Goal:** Participants can wire an agent to four external trigger sources and observe automated agent invocation — not just manual CLI execution
**Verified:** 2026-04-07T15:30:00Z
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths (from Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Participant fires synthetic AlertManager alert on KIND and observes triage agent receiving webhook and diagnosing affected pod | VERIFIED | PrometheusRule firing on k8s-trouble-crashloop namespace (`prometheus-rules.yaml` line 24), AlertManager receiver pointing at `host.docker.internal:8644/webhooks/alertmanager` (`alertmanager-config.yaml` line 26), LAB.mdx Steps 9-10 walk through the full flow |
| 2 | Participant applying CronJob manifest to KIND observes scheduled agent running and writing status report — without manual invocation | VERIFIED | `agent-health-check.yaml` contains 3 per-track CronJob resources with `HERMES_LAB_GOVERNANCE` env propagation; `imagePullPolicy: IfNotPresent` on all 3 (count confirmed: 3); Dockerfile builds `hermes-lab:cronjob` from `python:3.12-slim`; LAB.mdx Step 11 guides through build+apply+observe |
| 3 | Participant sending GitHub webhook event observes agent receiving event and producing review comment or summary output | VERIFIED | `smee-setup.sh` forwards to `localhost:8644/webhooks/github`; `agent-prompt-template.txt` uses dot-notation only; LAB.mdx Steps 12-13 cover smee.io setup and `--deliver github_comment` full round-trip; Solo Learner fallback uses `sample-pr-payload.json` |
| 4 | Participant sends slash command via Telegram and receives agent response posted back — full round-trip without terminal interaction | VERIFIED | `bot-config.example.yaml` has `TELEGRAM_BOT_TOKEN` env ref and `thread_replies: true`; `admin-allowlist.example.yaml` documents `TELEGRAM_ALLOWED_USERS` pattern; `slash-command-spec.md` has 3 commands per track; LAB.mdx Steps 14-16 walk through @BotFather setup through governance escalation; polling conflict warning present (README line 78, LAB.mdx Step 14) |

**Score:** 4/4 truths verified

---

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `infrastructure/helm/prometheus-lab-values.yaml` | alertmanager.enabled: true + receiver config | VERIFIED | Line 7: `enabled: true`; AlertManager config block with NodePort 30093 and webhook receiver present |
| `infrastructure/kind/cluster-config.yaml` | containerPort: 8644 added | VERIFIED | Line 32: `containerPort: 8644` (Linux extraPortMapping for Hermes gateway) |
| `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml` | PrometheusRule with release: kube-prometheus label, fires on k8s-trouble-crashloop | VERIFIED | `release: kube-prometheus` at line 15; PromQL expression targets `namespace="k8s-trouble-crashloop"` at line 24 |
| `infrastructure/scenarios/k8s/alertmanager/alertmanager-config.yaml` | receiver pointing at host.docker.internal:8644 | VERIFIED | URL at line 26: `http://host.docker.internal:8644/webhooks/alertmanager` |
| `infrastructure/scenarios/k8s/alertmanager/README.md` | Flow documentation | VERIFIED | Contains host.docker.internal reference and {alerts} template constraint |
| `infrastructure/scenarios/k8s/cronjob/Dockerfile` | FROM python:3.12-slim | VERIFIED | Line 21: `FROM python:3.12-slim` |
| `infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml` | 3 CronJobs with imagePullPolicy: IfNotPresent | VERIFIED | 3 occurrences of `imagePullPolicy: IfNotPresent`; 3 occurrences of `HERMES_LAB_GOVERNANCE`; image: `hermes-lab:cronjob` |
| `infrastructure/scenarios/k8s/cronjob/README.md` | "Use Hermes cron when / Use K8s CronJob when" callout | VERIFIED | Line 9: `### Use Hermes cron when:` |
| `infrastructure/scenarios/k8s/github-webhook/README.md` | smee.io walkthrough with Solo Learner fallback | VERIFIED | smee.io in multiple locations; Solo Learner callout present |
| `infrastructure/scenarios/k8s/github-webhook/smee-setup.sh` | uses npx smee-client@5.0.0 | VERIFIED | Line 28: `SMEE_CLIENT_VERSION="${SMEE_CLIENT_VERSION:-5.0.0}"`; line 82: `npx --yes "smee-client@${SMEE_CLIENT_VERSION}"`; targets `localhost:8644/webhooks/github` |
| `infrastructure/scenarios/k8s/github-webhook/sample-pr-payload.json` | valid GitHub PR payload with pull_request key | VERIFIED | Contains `"pull_request"` root key at line 4; valid JSON |
| `infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt` | dot-notation only, {pull_request.number} | VERIFIED | Line 1 uses `{pull_request.number}`, `{repository.full_name}`; zero array index syntax |
| `infrastructure/scenarios/k8s/telegram-bot/README.md` | @BotFather walkthrough, polling conflict warning | VERIFIED | @BotFather present; polling conflict warning at line 78 with explicit 30-second wait guidance |
| `infrastructure/scenarios/k8s/telegram-bot/bot-config.example.yaml` | TELEGRAM_BOT_TOKEN env ref, thread_replies: true | VERIFIED | `bot_token: "${TELEGRAM_BOT_TOKEN}"` at line 21; `thread_replies: true` at line 45 |
| `infrastructure/scenarios/k8s/telegram-bot/admin-allowlist.example.yaml` | TELEGRAM_ALLOWED_USERS pattern, placeholder IDs | VERIFIED | References `TELEGRAM_ALLOWED_USERS` env var; 3 placeholder IDs clearly marked |
| `infrastructure/scenarios/k8s/telegram-bot/slash-command-spec.md` | 3 commands per track (/diagnose, /status, /help) | VERIFIED | /diagnose, /status, /help with per-track examples for Track A/B/C |
| `course-site/docs/module-12-triggers/lab/LAB.mdx` | 16 GUIDED steps (8 existing + 8 new) | VERIFIED | Confirmed 16 `## Step` headings; Steps 1-8 intact, Steps 9-16 are the Phase 8 additions |
| `modules/module-12-triggers/LAB.md` | mirror with same 16 GUIDED steps | VERIFIED | Confirmed 16 `## Step` headings in mirror |
| `course-site/docs/module-12-triggers/reading/reference.mdx` | 4-trigger comparison table + Phase 8 env var section | VERIFIED | Section 6 (lines 228-263): 6-row trigger comparison table; Section 7 (lines 265-289): Phase 8 env var table with acquisition notes |
| `course-site/docs/module-12-triggers/quiz/QUIZ.mdx` | 3 new questions (cron tradeoffs, AlertManager flow, governance) | VERIFIED | 9 total questions confirmed (6 original + 3 new: Q7 Hermes Cron vs K8s CronJob, Q8 AlertManager troubleshooting, Q9 governance inheritance) |

---

## Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `prometheus-rules.yaml` | Phase 6 crashloop2 namespace | PromQL `namespace="k8s-trouble-crashloop"` | WIRED | Exact pattern found at line 24 |
| `alertmanager-config.yaml` | Hermes gateway (host.docker.internal:8644) | AlertManager webhook_config URL | WIRED | `http://host.docker.internal:8644/webhooks/alertmanager` at line 26 |
| `agent-health-check.yaml` | `hermes-lab:cronjob` image | container image reference | WIRED | `image: hermes-lab:cronjob` appears 3 times |
| `agent-health-check.yaml` | Phase 7 governance wrappers | container env `HERMES_LAB_GOVERNANCE` | WIRED | 3 occurrences in container env specs |
| `smee-setup.sh` | Hermes webhook gateway | `--target` flag | WIRED | `localhost:8644/webhooks/github` at line 82 |
| `sample-pr-payload.json` | `hermes webhook test github` fallback | `pull_request` key | WIRED | Present; lab Step 13 references `@sample-pr-payload.json` |
| `bot-config.example.yaml` | TELEGRAM_BOT_TOKEN env var | env var reference in YAML | WIRED | `"${TELEGRAM_BOT_TOKEN}"` at line 21 |
| `admin-allowlist.example.yaml` | TELEGRAM_ALLOWED_USERS env var | comma-separated IDs pattern | WIRED | Pattern and yq one-liner both present |
| LAB.mdx Step 9 | `alertmanager/prometheus-rules.yaml` | kubectl apply command | WIRED | `alertmanager/prometheus-rules.yaml` appears in step body |
| LAB.mdx Step 11 | `cronjob/Dockerfile` + `agent-health-check.yaml` | docker build + kubectl apply | WIRED | `scenarios/k8s/cronjob/` referenced in step |
| LAB.mdx Step 12 | `github-webhook/smee-setup.sh` | bash invocation | WIRED | `./infrastructure/scenarios/k8s/github-webhook/smee-setup.sh` at lines 775, 1237 |
| LAB.mdx Step 13 | `github-webhook/agent-prompt-template.txt` | `$(cat ...)` substitution | WIRED | `cat infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt` at lines 831, 867 |
| LAB.mdx Step 14 | `telegram-bot/` directory | cross-reference in step | WIRED | `telegram-bot/` referenced in step body |
| `modules/module-12-triggers/LAB.md` | `course-site/docs/module-12-triggers/lab/LAB.mdx` | identical step structure | WIRED | Both have same 16 steps with same titles; mirrors confirmed |

---

## Data-Flow Trace (Level 4)

This phase produces course content (Markdown/MDX) and infrastructure configuration files, not runnable UI components with dynamic state. Level 4 data-flow tracing applies to the infrastructure wiring rather than rendering pipelines:

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|-------------------|--------|
| `prometheus-rules.yaml` | kube_pod_container_status_restarts_total metric | Live Prometheus scrape of kube-state-metrics in k8s-trouble-crashloop namespace | Yes (real PromQL query, not static) | FLOWING |
| `alertmanager-config.yaml` | alerts JSON payload | AlertManager fires when PrometheusRule expression fires | Yes (real webhook dispatch) | FLOWING |
| `agent-health-check.yaml` | hermes CLI execution | K8s Job pod runs hermes with env vars from container spec | Yes (real agent invocation on each schedule) | FLOWING |
| `smee-setup.sh` | GitHub webhook events | Real GitHub webhook via smee.io proxy channel | Yes (real HTTP forwarding) | FLOWING |
| `agent-prompt-template.txt` | PR context fields | GitHub PR webhook payload via Hermes _render_prompt | Yes (dot-notation substitution from real payload) | FLOWING |
| `bot-config.example.yaml` | Telegram messages | Real Telegram long-polling via gateway/platforms/telegram.py | Yes (live Telegram API) | FLOWING |

---

## Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Phase 7 governance wrapper still rejects `delete` at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock infrastructure/wrappers/mock-kubectl delete pod foo` | Output shows `[ GOVERNANCE REJECTED ]` | PASS |
| Phase 7 governance wrapper allows `get` at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock infrastructure/wrappers/mock-kubectl get pods` | Output shows `[ MOCK MODE ]` header without rejection | PASS |
| Phase 6 crashloop manifest preserved | `test -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` | File exists | PASS |
| AlertManager enabled in helm values | grep for `enabled: true` after `alertmanager:` | Found at line 7 | PASS |
| PrometheusRule discovery label present | grep for `release: kube-prometheus` | Found at line 15 | PASS |
| CronJob imagePullPolicy count | grep count for `imagePullPolicy: IfNotPresent` | 3 occurrences (one per track) | PASS |
| Phase 8 env vars in LAB.mdx | grep for TELEGRAM_BOT_TOKEN, GITHUB_TOKEN, SMEE_URL, TELEGRAM_ALLOWED_USERS | All 4 present, multiple occurrences each | PASS |
| Steps 1-8 not deleted | git diff HEAD~10 -- LAB.mdx showing no `-## Step [1-8]` removals | No Step 1-8 headings deleted | PASS |
| "Use Hermes cron when" callout present | grep in LAB.mdx and cronjob/README.md | Found in both files | PASS |
| Telegram adapter NOT rebuilt | ls telegram-bot/ for .py files | Directory contains only 4 YAML/MD files, zero .py files | PASS |
| smee-setup.sh pins to v5.0.0 | grep for version | `SMEE_CLIENT_VERSION:-5.0.0` default | PASS |
| {alerts[0]} anti-pattern absent from lab | grep in LAB.mdx | WARNING admonition teaches the constraint without using forbidden pattern | PASS |
| Quiz has 9 questions (6 original + 3 new) | grep count for `### Question` | 9 questions confirmed | PASS |
| Both lab mirrors have 16 steps | grep count for `## Step` | LAB.mdx: 16, LAB.md: 16 | PASS |

---

## Requirements Coverage

| Requirement | Source Plans | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| TRIG-01 | 08-01, 08-03 | AlertManager webhook triggers triage agent that diagnoses pod issues on KIND with Prometheus stack | SATISFIED | prometheus-rules.yaml fires on crashloop2 namespace; alertmanager-config.yaml wires to host.docker.internal:8644; LAB.mdx Steps 9-10 walk the full flow; REQUIREMENTS.md marked Complete |
| TRIG-02 | 08-01, 08-03 | K8s CronJob scheduled agent runs periodic health checks and reports status | SATISFIED | agent-health-check.yaml has 3 per-track CronJobs; Dockerfile provides hermes-lab:cronjob image; LAB.mdx Step 11 guides through build+apply+observe; REQUIREMENTS.md marked Complete |
| TRIG-03 | 08-02, 08-03 | GitHub webhook/command triggers PR review bot agent | SATISFIED | smee-setup.sh proxies to localhost:8644/webhooks/github; sample-pr-payload.json provides Solo Learner fallback; --deliver github_comment demonstrated in LAB.mdx Step 13; REQUIREMENTS.md marked Complete |
| TRIG-04 | 08-02, 08-03 | Chat bot interaction via Telegram or Slack — slash commands trigger agent workflows, results posted back | SATISFIED | bot-config.example.yaml configures Telegram adapter; slash-command-spec.md defines 3 commands per track; LAB.mdx Steps 14-16 walk through bot setup, /diagnose, and governance escalation; REQUIREMENTS.md marked Complete |

**Orphaned requirements check:** No requirements in REQUIREMENTS.md map to Phase 8 beyond TRIG-01 through TRIG-04.

---

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `course-site/docs/module-12-triggers/lab/LAB.mdx` | 604 | "placeholder" appears as a teaching word in a WARNING admonition (not a code stub) | Info | Teaching context only — the sentence explains what happens when `{alerts}` is used correctly vs incorrectly; not a code stub |

No blocker or warning anti-patterns found. The single info-level match is instructional text, not a placeholder implementation.

---

## Human Verification Required

### 1. AlertManager Alert Firing and Webhook Delivery

**Test:** Deploy kube-prometheus-stack with `helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f infrastructure/helm/prometheus-lab-values.yaml -n monitoring`. Apply `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml`, then apply `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml`. Wait 2 minutes and check AlertManager UI on `http://localhost:30093`.
**Expected:** PodCrashLooping alert transitions from Pending to Firing. Gateway logs show `POST /webhooks/alertmanager` request. Agent produces a diagnosis referencing the pod name from the alerts array.
**Why human:** Requires running KIND cluster, deployed kube-prometheus-stack, live Prometheus scrape pipeline, and running Hermes gateway. Cannot be verified statically.

### 2. K8s CronJob Spawns and Runs Agent

**Test:** `docker build -t hermes-lab:cronjob infrastructure/scenarios/k8s/cronjob/`. `kind load docker-image hermes-lab:cronjob`. `kubectl apply -f infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml`. Watch with `kubectl get jobs --watch` until a Job spawns. Then `kubectl logs <job-pod-name>` to see agent output.
**Expected:** CronJob appears in `kubectl get cronjob`. On first scheduled trigger, a Job pod spawns, runs `hermes` CLI, produces a health check report, and exits 0. No manual `hermes` invocation needed.
**Why human:** Requires local Docker, KIND cluster, `hermes-agent[messaging,cron]` pip-installable from GitHub, and a scheduled trigger window. Cannot verify the scheduled invocation mechanism statically.

### 3. GitHub Webhook End-to-End Round-Trip

**Test:** Visit smee.io, get a channel URL. `export SMEE_URL=https://smee.io/<channel>`. Run `infrastructure/scenarios/k8s/github-webhook/smee-setup.sh`. Configure a webhook on a personal GitHub repo pointing at the smee.io URL. Start the Hermes gateway and subscribe: `hermes webhook subscribe github --deliver github_comment --prompt "$(cat infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt)"`. Open a PR on the test repo.
**Expected:** smee-client terminal shows event forwarded. Gateway terminal shows `POST /webhooks/github` received. A comment appears on the GitHub PR posted by the agent.
**Why human:** Requires smee.io channel, GitHub personal repo, GITHUB_TOKEN with repo scope, and live running gateway and smee-client. Full external service dependency chain.

### 4. Telegram Slash Command Full Round-Trip

**Test:** Create bot via @BotFather. `export TELEGRAM_BOT_TOKEN=<token>`. `export TELEGRAM_ALLOWED_USERS=<your-id>`. `hermes gateway run`. Send `/diagnose <arg>` from Telegram app.
**Expected:** Gateway logs show slash command received. Within ~10 seconds, the bot replies in the same Telegram chat thread with agent findings. Message appears as a reply to the original command (thread_replies: true behavior).
**Why human:** Requires real Telegram account, bot token from @BotFather, running Hermes gateway with `[messaging]` extra installed, and Telegram client to send and receive messages. External service dependency.

---

## Gaps Summary

No gaps found. All four trigger types (TRIG-01 through TRIG-04) are fully implemented:

- **TRIG-01 (AlertManager):** PrometheusRule, alertmanager-config, helm values, and KIND cluster config are all wired end-to-end. Lab Steps 9-10 guide the full flow including the `{alerts}` anti-pattern warning.
- **TRIG-02 (K8s CronJob):** Dockerfile, per-track manifest with 3 CronJob resources, governance env var inheritance, and `imagePullPolicy: IfNotPresent` all present. Lab Step 11 includes the "Use Hermes cron when / Use K8s CronJob when" decision callout.
- **TRIG-03 (GitHub webhook):** smee-setup.sh (v5.0.0 pinned), sample-pr-payload.json, agent-prompt-template.txt (dot-notation only), and `--deliver github_comment` documented. Lab Steps 12-13 include Solo Learner fallback.
- **TRIG-04 (Telegram bot):** bot-config.example.yaml (env var references, thread_replies: true), admin-allowlist.example.yaml, slash-command-spec.md (3 commands per track). Lab Steps 14-16 include polling conflict warning and governance escalation. Zero Python adapter code shipped (Hermes adapter exists at gateway/platforms/telegram.py and is not duplicated).

All four items in the phase's Human Verification list require live running infrastructure that cannot be tested statically — they are flagged for workshop or participant validation, not because of gaps in implementation.

---

_Verified: 2026-04-07T15:30:00Z_
_Verifier: Claude (gsd-verifier)_
