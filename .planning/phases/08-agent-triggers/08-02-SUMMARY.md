---
phase: 08-agent-triggers
plan: 02
subsystem: external-services-infrastructure
tags: [trig-03, trig-04, github-webhook, telegram-bot, smee.io, hermes-gateway]
dependency_graph:
  requires:
    - 06-k8s-skills-agents (sre-k8s-pod-health, sre-dba-rds-slow-query, sre-ec2-health-check skills exist)
    - 07-guardrails-governance (HERMES_LAB_GOVERNANCE env var pattern, wrapper enforcement)
  provides:
    - infrastructure/scenarios/k8s/github-webhook/ (4 files: README, smee-setup.sh, sample-pr-payload.json, agent-prompt-template.txt)
    - infrastructure/scenarios/k8s/telegram-bot/ (4 files: README, bot-config.example.yaml, admin-allowlist.example.yaml, slash-command-spec.md)
  affects:
    - 08-03 (Module 12 lab extension references these files)
tech_stack:
  added: []
  patterns:
    - smee.io webhook proxy (npx smee-client, no global install)
    - Telegram long-polling via existing gateway/platforms/telegram.py adapter
    - Dot-notation prompt interpolation only (no array index access)
    - HERMES_LAB_GOVERNANCE env-var propagation to triggered agents
    - Per-track slash command examples (Track A/B/C)
key_files:
  created:
    - infrastructure/scenarios/k8s/github-webhook/README.md
    - infrastructure/scenarios/k8s/github-webhook/smee-setup.sh
    - infrastructure/scenarios/k8s/github-webhook/sample-pr-payload.json
    - infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt
    - infrastructure/scenarios/k8s/telegram-bot/README.md
    - infrastructure/scenarios/k8s/telegram-bot/bot-config.example.yaml
    - infrastructure/scenarios/k8s/telegram-bot/admin-allowlist.example.yaml
    - infrastructure/scenarios/k8s/telegram-bot/slash-command-spec.md
  modified: []
decisions:
  - "smee-client pinned at v5.0.0 via npx (no global npm install required) — reproducibility + zero friction"
  - "Solo Learner fallback documented as --deliver local + hermes webhook test github --payload @sample-pr-payload.json"
  - "Telegram long-polling mode confirmed as lab default (no public HTTPS needed, works behind NAT)"
  - "TELEGRAM_ALLOWED_USERS enforced via env var; admin-allowlist.example.yaml is documentation only"
  - "Per-command governance escalation is per-process (gateway restart), not per-message"
metrics:
  duration: 5 minutes
  completed_date: "2026-04-07T13:43:43Z"
  tasks_completed: 2
  files_created: 8
  files_modified: 0
---

# Phase 08 Plan 02: External Services Infrastructure (TRIG-03 + TRIG-04) Summary

**One-liner:** smee.io proxy script + GitHub PR payload + Telegram bot config + slash command spec for TRIG-03/TRIG-04 external-service triggers.

## What Was Built

### TRIG-03: GitHub Webhook (4 files in `infrastructure/scenarios/k8s/github-webhook/`)

**README.md** — Setup walkthrough covering:
- Why smee.io (no ngrok timeout, no account, sessionless)
- GitHub PAT setup (classic with `repo` scope vs fine-grained alternative)
- gh CLI dependency and authentication
- Primary path: 3-terminal flow (smee-client, hermes gateway, hermes webhook subscribe)
- `--deliver github_comment` built-in delivery (references gateway/platforms/webhook.py lines 525-558)
- Solo Learner fallback: `hermes webhook test github --payload @sample-pr-payload.json`
- Common pitfalls table (smee target mismatch, PAT scope, smee-client not installed, webhook secret mismatch)

**smee-setup.sh** — Executable bash helper:
- Uses `npx --yes smee-client@5.0.0` (SMEE_CLIENT_VERSION env var override supported)
- Validates SMEE_URL is set and matches `https://smee.io/` pattern
- Checks Node.js/npx is available
- Warns if Hermes gateway not reachable (5-second grace period)
- Targets `http://localhost:8644/webhooks/github` (HERMES_TARGET env var override supported)

**sample-pr-payload.json** — Valid GitHub PR webhook payload (PR #42, `feat(api): add /health readiness endpoint`):
- Contains: `action`, `number`, `pull_request` (id, number, state, title, body, user, head, base, additions, deletions, changed_files, html_url), `repository` (id, name, full_name, owner), `sender`
- Passes `python3 -c "import json; json.load(open(...))"` validation

**agent-prompt-template.txt** — Reference prompt using ONLY dot-notation:
- Uses: `{pull_request.number}`, `{repository.full_name}`, `{pull_request.title}`, `{pull_request.user.login}`, `{pull_request.head.ref}`, `{pull_request.base.ref}`, `{pull_request.changed_files}`, `{pull_request.additions}`, `{pull_request.deletions}`, `{pull_request.body}`
- Zero array index syntax (`[0]`) — compliant with `_render_prompt` constraint from gateway/platforms/webhook.py line 488

### TRIG-04: Telegram Bot (4 files in `infrastructure/scenarios/k8s/telegram-bot/`)

**README.md** — Setup walkthrough covering:
- Why Telegram over Slack (free, no admin approval, long-polling works behind NAT)
- @BotFather flow (7-step walkthrough)
- @userinfobot for finding your Telegram user ID
- env var configuration (`~/.hermes/.env` and export inline patterns)
- Gateway start with polling conflict warning (30-second wait after `hermes gateway stop`)
- How slash commands work (gateway/platforms/telegram.py `_handle_command` line 1549 — no per-command registration)
- 4096 char limit and auto-split behavior
- Phase 7 governance inheritance (HERMES_LAB_GOVERNANCE from gateway process env)
- Common pitfalls table (polling conflict, bot ignores users, token leaked, char limit, git commit accident)
- Slack as production reference only (Module 12 Step 8 for the existing Slack overview)

**bot-config.example.yaml** — Reference YAML config:
- `bot_token: "${TELEGRAM_BOT_TOKEN}"` — env var reference, never literal
- `allowed_users: "${TELEGRAM_ALLOWED_USERS}"` — env var reference
- `thread_replies: true` — replies attach to original command in Telegram
- `inherit_governance: true` — Phase 7 governance inheritance flag
- `mode: long_polling` — correct for lab (no public HTTPS required)
- `max_message_length: 4096` — Telegram hard limit

**admin-allowlist.example.yaml** — TELEGRAM_ALLOWED_USERS documentation:
- Three placeholder users (primary_admin L4, secondary_admin L3, observer L2)
- `governance_max` per user is documentation only (actual governance is per-process)
- Includes `yq` one-liner to extract IDs as comma-separated string for env var

**slash-command-spec.md** — Three-command spec with per-track examples:
- `/diagnose <argument>`: per-track table (Track A: db-name/sre-dba-rds-slow-query, Track B: account-id/sre-ec2-health-check, Track C: pod-name/sre-k8s-pod-health)
- `/status`: example session showing governance level, cron jobs, webhook subscriptions
- `/help`: per-track example sessions (A/B/C)
- HERMES_LAB_GOVERNANCE escalation pattern (gateway restart with L4 env var)

## Decisions Made

| Decision | Context | Rationale |
|---|---|---|
| smee-client pinned at v5.0.0 | smee-setup.sh | Reproducibility across course delivery dates (v5.0.0 published 2025-11-25, verified in RESEARCH) |
| Solo Learner fallback uses --deliver local | README fallback path | Participants without a GitHub repo see agent output in terminal; no external service required |
| TELEGRAM_ALLOWED_USERS as env var, not YAML list | bot-config.example.yaml | The Hermes adapter reads the env var directly; YAML file is documentation/team-roster only |
| Per-command governance is per-process | slash-command-spec.md + README | Matches how AlertManager and CronJob agents work — operator sets governance at gateway start, all commands inherit it |
| Slack documented only, not hands-on | README | Mirrors existing Module 12 Step 8 pattern; workspace admin requirement blocks Udemy solo learners |

## Research Findings Incorporated

| Finding | Source | Implementation |
|---|---|---|
| Telegram adapter EXISTS (2145 lines) | BLOCKER-01 resolution, RESEARCH.md | No new adapter code — only config templates and documentation. References gateway/platforms/telegram.py throughout |
| `--deliver github_comment` is built-in | RESEARCH.md interfaces section, webhook.py 525-558 | README documents this explicitly; README warns "you don't write any HTTP code" |
| smee-client via npx, pin v5.0.0 | RESEARCH.md smee.io section | smee-setup.sh uses `npx --yes "smee-client@${SMEE_CLIENT_VERSION:-5.0.0}"` |
| `_render_prompt` dot-notation only | RESEARCH.md prompt template constraint, webhook.py line 488 | agent-prompt-template.txt uses zero array index syntax; comment in README explains the constraint |
| Polling conflict fatal after 3 retries | RESEARCH.md Pitfall 4 | README has prominent WARNING callout with 30-second wait guidance |
| TELEGRAM_ALLOWED_USERS comma-separated | RESEARCH.md interfaces, telegram.py line 240 | admin-allowlist.example.yaml has yq one-liner to generate the correct format |

## Context Decisions Honored

| Decision | How Honored |
|---|---|
| D-12: smee.io primary path | README primary path section with 8-step walkthrough |
| D-13: Solo Learner fallback | README fallback section with `hermes webhook test github --payload @...` |
| D-14: GitHub PAT repo scope | README PAT setup section with classic PAT instructions |
| D-15: gh pr comment via github_comment | README explains built-in delivery; subscription command shown |
| D-16: Telegram primary hands-on | README full @BotFather walkthrough |
| D-17: Slack as production reference only | README references Module 12 Step 8 without adding Slack setup |
| D-18: Three slash commands | slash-command-spec.md: /diagnose, /status, /help |
| D-19: Default L2 governance + admin gate | README governance section + slash-command-spec.md escalation pattern |
| D-20: thread_replies: true | bot-config.example.yaml has `thread_replies: true` |
| D-22: Per-track variants in callouts | slash-command-spec.md: Track A/B/C table + example sessions for each |
| D-26: GITHUB_TOKEN + TELEGRAM_BOT_TOKEN + SMEE_URL | Both READMEs and config files use these env vars as specified |

## Verification Results

| Check | Result |
|---|---|
| All 8 files exist | PASS |
| sample-pr-payload.json valid JSON | PASS |
| bot-config.example.yaml valid YAML | PASS |
| admin-allowlist.example.yaml valid YAML | PASS |
| smee-setup.sh bash -n syntax | PASS |
| smee-setup.sh executable bit | PASS |
| smee-setup.sh uses npx | PASS |
| smee-setup.sh targets localhost:8644/webhooks/github | PASS |
| agent-prompt-template.txt: no array index syntax | PASS |
| bot-config.example.yaml: uses ${TELEGRAM_BOT_TOKEN} not literal | PASS |
| No literal Telegram token pattern in committed files | PASS |
| Solo Learner callout in github-webhook README | PASS |
| @BotFather in telegram-bot README | PASS |
| polling conflict warning in telegram-bot README | PASS |

## Deviations from Plan

None — plan executed exactly as written. All content in the action blocks was implemented verbatim. The only discretionary choices made were:

1. Added an extra `/help` per-track example for Track A (Database) and Track B (FinOps) in slash-command-spec.md beyond the minimum spec — the plan specified Track C only as an example but per-track completeness was clearly the intent.
2. Added a `Missing [messaging] extra` pitfall row to the Telegram README pitfalls table — an important practical troubleshooting step not explicitly listed but consistent with the research findings about the `[messaging]` install extra requirement.

## Known Stubs

None. All files contain complete, functional content. No placeholder code paths that block plan goals.

## Self-Check: PASSED

Files verified present on disk:
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/github-webhook/README.md — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/github-webhook/smee-setup.sh — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/github-webhook/sample-pr-payload.json — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/telegram-bot/README.md — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/telegram-bot/bot-config.example.yaml — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/telegram-bot/admin-allowlist.example.yaml — FOUND
- /Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/telegram-bot/slash-command-spec.md — FOUND

Commits verified:
- c8b2a3b — feat(08-02): add TRIG-03 GitHub webhook infrastructure — FOUND
- 0aa624e — feat(08-02): add TRIG-04 Telegram bot infrastructure — FOUND
