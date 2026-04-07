# Phase 8: Agent Triggers - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-07
**Phase:** 08-agent-triggers
**Areas discussed:** Lab structure, TRIG-01 AlertManager scope, TRIG-02 + TRIG-03 literal vs simulated, TRIG-04 chat platform

---

## Lab structure

### Q1: Where should Phase 8 content live?

| Option | Description | Selected |
|--------|-------------|----------|
| Extend Module 12 | Keep existing 8 steps, add new steps for 4 trigger types after Step 8. Same pattern as Phase 5/6/7. | ✓ |
| Rewrite Module 12 | Replace synthetic webhook content with real AlertManager + K8s CronJob walkthrough. More cohesive but disrupts existing progress. | |
| New companion lab section | Module 12 stays, Phase 8 builds new content elsewhere. Clean separation but two trigger labs to maintain. | |

**User's choice:** Extend Module 12 (Recommended)
**Notes:** Mirrors Phase 7's Module 13 extend pattern. Existing Hermes cron + simulated webhook content stays as foundational walkthrough.

---

### Q2: Should Phase 7's wrapper governance enforcement apply to triggered agents?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — inherit HERMES_LAB_GOVERNANCE from environment | Triggered agents read env var same as interactive ones. K8s CronJob env vars, gateway env propagation, bot config inheritance. Universal. | ✓ |
| Document but don't enforce | Trigger configs document recommended level but don't enforce mechanically. | |
| Default L2 for triggers always | Hardcoded L2. Most conservative, breaks per-context flexibility. | |

**User's choice:** Yes — inherit HERMES_LAB_GOVERNANCE from environment (Recommended)
**Notes:** Universal governance model. Triggered agents are governed exactly like interactive ones.

---

## TRIG-01 AlertManager scope

### Q1: How real should the AlertManager integration be?

| Option | Description | Selected |
|--------|-------------|----------|
| Full real stack on KIND | Enable alertmanager helm value, ship PrometheusRule, configure receiver, fire real alert with broken pod. End-to-end real flow. | ✓ |
| Hybrid — enable stack + curl-simulated POST | Enable AlertManager + rules, use curl to simulate the POST. Faster lab, less timing fragility. | |
| Document-only — extend existing simulated webhook | Keep current synthetic content, add documentation of what real AlertManager looks like. | |

**User's choice:** Full real stack on KIND (Recommended)
**Notes:** Honors K8S-03 ethos of real infrastructure. Reuses Phase 6 broken-pod scenarios.

---

### Q2: Which broken-pod scenario from Phase 6 should fire the alert?

| Option | Description | Selected |
|--------|-------------|----------|
| crashloop2 | Phase 6 baked CrashLoopBackOff scenario. Reliable, fast-firing, kube-state-metrics-friendly. | ✓ |
| oom (OOMKilled) | Phase 6 Apple-Silicon-safe OOM scenario. More dramatic but slower restart timing. | |
| image-pull (ImagePullBackOff) | Phase 6 image-pull scenario. Pod never starts, requires different alert rule. | |

**User's choice:** crashloop2 (Recommended)
**Notes:** Reliable timing, reuses Phase 6 work, naturally K8s-relevant.

---

### Q3: How should AlertManager reach the Hermes webhook gateway?

| Option | Description | Selected |
|--------|-------------|----------|
| kind extraPortMapping + host.docker.internal | In-cluster AlertManager hits host.docker.internal:8644. Reliable on macOS Docker Desktop. | ✓ |
| Run hermes gateway as a Pod inside KIND | Deploy gateway in-cluster, hit via ClusterIP. More authentic but overlaps with Phase 9 PROD-01. | |
| Sidecar pattern with kubectl port-forward | Lab manages port-forward process. Simpler but more manual. | |

**User's choice:** kind extraPortMapping + host.docker.internal (Recommended)
**Notes:** Researcher confirms whether port 8644 needs explicit extraPortMapping addition.

---

### Q4: Where should the new alert rules live?

| Option | Description | Selected |
|--------|-------------|----------|
| New Phase 8 PrometheusRule manifest | infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml. Self-contained. | ✓ |
| Extend reference-app Helm chart | Add into reference-app/helm/templates/. Tighter coupling. | |
| Use ServiceMonitor + auto-discover | Operator-style auto-discovery. Elegant but more complex. | |

**User's choice:** New Phase 8 PrometheusRule manifest (Recommended)
**Notes:** Self-contained, clean separation from Phase 6 scenarios.

---

## TRIG-02 + TRIG-03 literal vs simulated

### Q1: TRIG-02 literal K8s CronJob or Hermes internal cron?

| Option | Description | Selected |
|--------|-------------|----------|
| Hermes cron primary, brief K8s CronJob comparison | Reuse Module 12 Steps 2-4 (Hermes cron). Add ONE K8s CronJob step with explicit "use this when…" guidance. Honors literal requirement minimally with honest framing. | ✓ |
| Hermes cron only — reframe TRIG-02 | Refine wording, document why K8s CronJob is wrong tool for stateful agents. | |
| K8s CronJob primary as originally specified | Real Dockerized K8s CronJob. Most authentic K8s, ignores state-sharing question. | |
| Both at equal depth | Two parallel new steps. Most pedagogical but doubles authoring. | |

**User's choice:** Hermes cron primary, brief K8s CronJob comparison (Recommended)
**Notes:** User correctly observed Hermes cron is the more pragmatic real-world pattern. K8s CronJob shines for stateless one-shot diagnostics. Phase 8 teaches both with explicit "use this when…" tradeoff guidance.

---

### Q2: TRIG-03 GitHub webhook approach?

| Option | Description | Selected |
|--------|-------------|----------|
| smee.io public proxy + real GitHub webhook | Lab uses smee.io free proxy, real GitHub webhook on personal repo, agent posts comment back via PAT. Authentic flow. | ✓ |
| GitHub Actions workflow_dispatch + curl | Skip public webhook, use workflow_dispatch. Less direct. | |
| Simulated payload only | hermes webhook test with hand-crafted GitHub payload. Easiest, weakest. | |
| smee.io + simulated fallback | Primary path real with Solo Learner simulated fallback. Dual-format. | |

**User's choice:** smee.io public proxy + real GitHub webhook (Recommended)
**Notes:** Real webhook flow matches TRIG-03 success criterion. Solo Learner fallback added per D-13 for Udemy learners without GitHub PAT.

---

## TRIG-04 chat platform

### Q1: Telegram, Slack, or both?

| Option | Description | Selected |
|--------|-------------|----------|
| Telegram primary, Slack documented | Real Telegram setup via @BotFather (2 min, no admin), Slack as production reference snippets only. Universally accessible. | ✓ |
| Slack only | More enterprise-relevant. Blocks Udemy learners without admin. | |
| Telegram only | Skips Slack entirely. | |
| Both with parallel paths | Maximum coverage but doubles authoring. | |

**User's choice:** Telegram primary, Slack documented (Recommended)
**Notes:** Mirrors Module 12 Step 8 existing Slack-as-reference pattern. Telegram is the most accessible chat platform.

---

### Q2: Which slash commands should the chat bot support?

| Option | Description | Selected |
|--------|-------------|----------|
| Three core commands per track | /diagnose <arg>, /status, /help. Compact, demonstrates argument parsing, useful for on-call. | ✓ |
| Single /agent <freeform> | One command, free-text. Simpler but less structured. | |
| Pattern from Module 12 cron flag set | /run <skill> <prompt>. Most flexible but most complex. | |

**User's choice:** Three core commands per track (Recommended)
**Notes:** Per-track examples in callouts. Three commands is the right size for the lab.

---

### Q3: How should chat bot output be delivered back?

| Option | Description | Selected |
|--------|-------------|----------|
| Reply in same chat thread | Markdown-formatted reply in same Telegram chat. Truncate at 4096 chars with "see full report at <link>". | ✓ |
| Reply in chat + persist to file | Same plus filesystem state for full report. | |
| DM the user, not the channel | Private message to user, not the channel. Cleaner for noise but breaks chat-ops visibility. | |

**User's choice:** Reply in same chat thread (Recommended)
**Notes:** Bidirectional UX matches "results posted back to the channel" requirement.

---

### Q4: Should the chat bot inherit Phase 7 governance?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — default L2 with override per command | Default L2, /diagnose --governance L4 for admin user_ids in allowlist. Per-context with explicit escalation. | ✓ |
| Always L2 — no override | Hardcoded L2. Most conservative. | |
| Inherit from gateway env var | Whatever gateway started with. Simplest but depends on shell history. | |

**User's choice:** Yes — default L2 with override per command (Recommended)
**Notes:** Mirrors AlertManager and CronJob env-var-driven governance with per-context override.

---

## User Note: K8s CronJob real-world analysis

Mid-discussion, user asked: "is there any value in using a K-test cron job? I am not sure if that is how, in the real world, people will use it… I think if I were to use this, I would most likely be looking at an Hermes cron job or scheduled job."

Claude analyzed the real-world pattern:
- **Hermes cron wins when:** agent benefits from gateway-shared state (skills, audit trail, conversation history), iterating fast, not yet in K8s
- **K8s CronJob wins when:** stateless one-shot diagnostics, GitOps with schedule in git, K8s observability, multi-team isolation
- **Honest truth:** Most agent work uses Hermes cron because state matters; K8s CronJob shines for fire-and-forget jobs

User's instinct was correct. Phase 8 captured this in D-08 (Hermes cron primary), D-09 (one new K8s CronJob comparison step), D-10 (explicit "use this when…" callout).

## Claude's Discretion

These are intentionally left to Claude during research, planning, and execution:

- Exact PrometheusRule expression syntax
- AlertManager receiver YAML format
- Specific Dockerfile contents for K8s CronJob image
- Telegram bot adapter implementation in Hermes
- smee-client installation method
- Exact wording of "use Hermes cron when…" callout
- Module 12 reading reference.mdx structural changes
- Quiz question phrasing
- Whether to add Phase 8 exploratory PROJECTS.mdx entry

## Deferred Ideas

- **Phase 9 territory:** Multi-agent orchestration via triggers (FLEET-01), fleet coordinator wiring (FLEET-02), K8s Agent Sandbox (PROD-01), productionization (PROD-02)
- **v1.2:** Discord adapter, GitLab webhook, Mattermost/Rocket.Chat adapters, webhook signature verification deep-dive, trigger composition patterns, AlertManager grouping/inhibition tuning
