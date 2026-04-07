# Telegram Bot Slash Command Spec

**Phase 8 / TRIG-04** — Three slash commands for the Hermes Telegram bot, with per-track examples (Track A Database, Track B FinOps, Track C Kubernetes).

## How slash commands work in Hermes

The Telegram adapter (`gateway/platforms/telegram.py`, `_handle_command` line 1549) passes ALL slash commands through to the agent as plain text. The agent's loaded skills and SOUL.md determine the response.

**Implication:** the three commands documented below are conventions, not registered handlers. You can send any slash command and the agent will see it as `/whatever args` in its prompt. The course teaches three commands as the standard set, but participants can experiment.

## The three commands

### `/diagnose <argument>`

**Purpose:** Fire the diagnostic agent with the given argument.

**Behavior:** The agent loads its primary diagnostic skill and uses the argument as the target. Returns findings as a markdown-formatted reply in the same Telegram chat thread.

**Per-track examples:**

| Track | Command | Argument meaning | Expected agent skill |
|---|---|---|---|
| A (Database) | `/diagnose prod-db-01` | RDS instance name | `sre-dba-rds-slow-query` |
| A (Database) | `/diagnose users` | Table name with suspected issues | `sre-dba-rds-slow-query` |
| B (FinOps) | `/diagnose 123456789012` | AWS account ID | `sre-ec2-health-check` |
| B (FinOps) | `/diagnose web-tier` | EC2 service tier name | `sre-ec2-health-check` |
| C (Kubernetes) | `/diagnose crashloop-pod` | Pod name | `sre-k8s-pod-health` |
| C (Kubernetes) | `/diagnose k8s-trouble-crashloop` | Namespace name | `sre-k8s-pod-health` |

**Example session (Track C):**

```
You: /diagnose k8s-trouble-crashloop

Bot: Investigating pods in namespace `k8s-trouble-crashloop`...

Found 1 pod with issues:
- `crasher-67d9b46f8c-xyz12`: CrashLoopBackOff (8 restarts in last 10 min)

Container `crasher` exits with code 1 immediately. Logs show:
  starting...
  fatal: missing config

Recommendation: Check the deployment spec for the missing config file or env var. The container's command hard-codes `exit 1` after printing the error — this looks like a synthetic test scenario.

— hermes-lab Track C
```

### `/status`

**Purpose:** Return Hermes gateway and agent health, including governance level, registered cron jobs, and recent webhook activity.

**Behavior:** The agent reads gateway state (sessions, cron list, webhook subscriptions) and returns a compact summary.

**No arguments.** Same command across all three tracks.

**Example session:**

```
You: /status

Bot: Hermes gateway: Running (pid 12345, uptime 2h 17m)

Governance: L2 (read-only diagnostics)
Track: track-c
Mode: live

Cron jobs (3 registered):
- daily-k8s-health [active] — runs at 08:00 UTC
- hourly-pod-restart-check [active] — runs every hour
- weekly-resource-quota [paused]

Webhook subscriptions (2):
- alertmanager → sre-k8s-pod-health [last fired 23 min ago]
- github → sre-pr-reviewer [last fired 4h ago]

Recent sessions: 14 today (12 successful, 2 with warnings)

— hermes-lab
```

### `/help`

**Purpose:** List available commands and example usage.

**Behavior:** Static-ish reply that the agent generates from its loaded SOUL.md plus the bot's slash command spec. The agent may also list its loaded skills.

**No arguments.** Same command across all three tracks.

**Example session (Track C):**

```
You: /help

Bot: Hermes Lab Bot — Track C (Kubernetes)

Commands:
- /diagnose <pod-or-namespace> — investigate a pod or namespace
- /status — show gateway, governance, cron, and webhook state
- /help — show this message

Loaded skills:
- sre-k8s-pod-health (primary)
- sre-k8s-node-health (starter)
- sre-k8s-resource-quota (starter)
- sre-k8s-rollback-investigator (starter)

Governance: L2 (read-only — kubectl get/describe/logs/top only)

Try: /diagnose k8s-trouble-crashloop
```

**Example session (Track A):**

```
You: /help

Bot: Hermes Lab Bot — Track A (Database)

Commands:
- /diagnose <db-name-or-table> — investigate an RDS instance or table
- /status — show gateway, governance, cron, and webhook state
- /help — show this message

Loaded skills:
- sre-dba-rds-slow-query (primary)

Governance: L2 (read-only — psql SELECT and EXPLAIN only)

Try: /diagnose prod-db-01
```

**Example session (Track B):**

```
You: /help

Bot: Hermes Lab Bot — Track B (FinOps)

Commands:
- /diagnose <account-id-or-service> — investigate an AWS account or service tier
- /status — show gateway, governance, cron, and webhook state
- /help — show this message

Loaded skills:
- sre-ec2-health-check (primary)

Governance: L2 (read-only — aws describe/get/list only)

Try: /diagnose 123456789012
```

## Why exactly three commands?

Per CONTEXT.md D-18, three is the right number because:

- **Compact** — easy to remember, easy to teach in a 5-minute lab step
- **Demonstrates argument parsing** — `/diagnose <arg>` shows how the bot extracts the trailing text
- **Useful in real on-call workflows** — actual SRE teams using chat ops typically have 3-5 verbs per service (this is the "/diagnose, /status, /help" pattern)
- **Per-track variants stay obvious** — the same three commands across all three tracks, just with different argument semantics

## Adding more commands (free explore territory)

The Telegram adapter handles any `/command` automatically. To add a `/restart` or `/runbook` command, just include it in the agent's SOUL.md and start using it. No code changes needed.

But: any new command that maps to a write operation (delete, drain, exec, restart) should be gated by the Phase 7 wrapper_allowlist via `HERMES_LAB_GOVERNANCE`. A `/restart` command at L2 should fail with the GOVERNANCE REJECTED banner from the wrapper.

## Governance escalation pattern (D-19)

To run the bot at L4 with admin override:

```bash
# 1. Stop existing gateway
hermes gateway stop

# 2. Restart with L4 governance
export HERMES_LAB_GOVERNANCE=L4
export HERMES_LAB_TRACK=track-c
export TELEGRAM_BOT_TOKEN="..."
export TELEGRAM_ALLOWED_USERS="987654321"  # Only this user can interact
hermes gateway run
```

The combination of `TELEGRAM_ALLOWED_USERS` (who can talk to the bot) plus `HERMES_LAB_GOVERNANCE` (what the bot can do) implements the per-context governance model from CONTEXT.md D-19. There's no per-message escalation — governance is set at gateway start time and inherited by every slash command run during that gateway's lifetime.
