# Phase 8: Agent Triggers - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Wire agents to 4 external trigger sources so participants observe automated invocation rather than manual CLI execution. Module 12 (Triggers) is extended with new GUIDED steps after the existing Step 8, covering each of the 4 trigger types end-to-end on KIND with real infrastructure where feasible and a Solo Learner fallback for Udemy.

Phase 8 ships:
1. **TRIG-01:** Real Prometheus + AlertManager stack on KIND (re-enable in helm values), real PrometheusRule firing on Phase 6 crashloop2 scenario, AlertManager receiver POSTing to Hermes webhook gateway, agent diagnoses the affected pod
2. **TRIG-02:** Hermes cron primary (already in Module 12 Steps 2-4, reframed as "production scheduled agents") + ONE new step demonstrating the same agent wrapped in a K8s CronJob manifest with explicit "use this when…" guidance
3. **TRIG-03:** smee.io public webhook proxy + real GitHub webhook on a personal/sample repo, agent receives push/PR events and posts a comment back via GitHub API. Solo Learner fallback uses `hermes webhook test` with a hand-crafted GitHub payload
4. **TRIG-04:** Real Telegram bot via @BotFather (no admin needed, free), three slash commands per track (`/diagnose`, `/status`, `/help`), agent reply posted back in the same chat thread. Slack documented as production reference (not hands-on)
5. **Phase 7 governance inheritance** — all 4 trigger paths read `HERMES_LAB_GOVERNANCE` from execution environment (CronJob env, gateway process env, bot config) — triggered agents are governed exactly like interactive ones
6. Module 12 lab extension (matching Phase 5/6/7 extend-pattern), updated reading and quiz where the new content needs cross-references

Phase 8 does NOT touch:
- Multi-agent fleet workflows or K8s Agent Sandbox (Phase 9 / FLEET-01..02, PROD-01..02)
- Fleet coordinator (Morgan) wiring (Phase 9)
- Module 13 governance content (Phase 7 just shipped that)
- Module 1-7 content (out of scope)

</domain>

<decisions>
## Implementation Decisions

### Lab Structure

- **D-01:** **Extend Module 12** (don't rewrite). Existing Steps 1-8 remain intact as the foundational concept walkthrough (Hermes cron + simulated webhook). Phase 8 adds new GUIDED steps after Step 8 for each of the 4 trigger types. Same extend-pattern Phase 7 used for Module 13. Final lab step count grows by approximately 12-16 steps (3-4 per new trigger × 4 triggers). Existing free-explore section (Steps 9-10+ in current Module 12) shifts to the end.
- **D-02:** **Phase 7 governance inherited universally.** Triggered agents read `HERMES_LAB_GOVERNANCE` from their execution environment:
  - **K8s CronJob:** env vars set in container spec (`spec.jobTemplate.spec.template.spec.containers[].env`)
  - **AlertManager webhook:** Hermes gateway process env propagates to spawned agent runs
  - **GitHub webhook (smee.io):** Same as AlertManager — gateway env propagates
  - **Chat bot (Telegram):** Bot config inherits from gateway env, with per-command override (D-19)
  This makes governance universal and consistent — the wrapper enforcement built in Phase 7 fires on triggered agents the same way it fires on interactive ones.

### TRIG-01: AlertManager Webhook (Full Real Stack)

- **D-03:** **Full real Prometheus + AlertManager stack on KIND.** Enable `alertmanager.enabled: true` in `infrastructure/helm/prometheus-lab-values.yaml` (currently false). Ship a real `PrometheusRule` manifest in `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml`. Configure AlertManager receiver to POST to Hermes webhook gateway. End-to-end flow: broken pod → kube-state-metrics → Prometheus scrape → alert rule fires → AlertManager dispatches → webhook receiver hits Hermes → agent runs diagnosis with real wall-clock latency.
- **D-04:** **TRIG-01 alert fires on the Phase 6 crashloop2 scenario.** Reuses `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` from Phase 6. Alert rule:
  ```yaml
  expr: increase(kube_pod_container_status_restarts_total{namespace="k8s-trouble-crashloop"}[2m]) > 2
  for: 30s
  labels:
    severity: warning
    track: c
  annotations:
    summary: "Pod {{ $labels.pod }} restarting repeatedly"
  ```
  Reliable, fast-firing (2 min window), reuses Phase 6 work, naturally K8s-relevant.
- **D-05:** **Networking via host.docker.internal.** Hermes webhook gateway runs on host port 8644. AlertManager (in-cluster KIND) POSTs to `http://host.docker.internal:8644/webhooks/alertmanager`. Reliable on macOS and Docker Desktop. Phase 8 may need to add port 8644 to `infrastructure/kind/cluster-config.yaml` `extraPortMappings` (researcher confirms whether host.docker.internal works without explicit mapping).
- **D-06:** **PrometheusRule lives in new dedicated subdirectory.** `infrastructure/scenarios/k8s/alertmanager/` directory holds Phase 8 alerting infrastructure: PrometheusRule manifest, AlertManager receiver config (ConfigMap or values override), README explaining the flow. Self-contained, separate from Phase 6 scenario manifests.
- **D-07:** **Hermes webhook gateway needs an `alertmanager` route subscription.** New `hermes webhook subscribe alertmanager --events alertmanager-alert --prompt "..."`. The agent's prompt template parses AlertManager's payload format (alerts[].labels.pod, alerts[].annotations.summary).

### TRIG-02: K8s CronJob (Hermes-cron primary, K8s comparison)

- **D-08:** **Hermes cron is the primary scheduled-agent pattern.** Module 12 Steps 2-4 already cover this beautifully. Phase 8 reframes those as "production scheduled agents" without rewriting them. The teaching: Hermes cron is the right answer when the agent benefits from gateway-shared state (loaded skills, audit trail, conversation history, config), which is most agent work.
- **D-09:** **ONE new K8s CronJob comparison step.** Add a single new step demonstrating the same scheduled health-check agent wrapped in a K8s `CronJob` manifest. Ship `infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml` with a real K8s CronJob resource invoking `hermes` CLI from a container image. Lab applies via `kubectl apply -f`, watches Job pods spawn, `kubectl logs` the Job pod to see agent output, then deletes via `kubectl delete cronjob`. Includes explicit "use this when:" callout listing the tradeoffs (D-10).
- **D-10:** **K8s CronJob "use this when" decision criteria.** The new step includes a teaching callout listing when each pattern wins:
  - **Use Hermes cron when:** agent benefits from shared gateway state, you want one-stop CLI management, you're iterating fast, you need audit trail context, you're not (yet) in K8s
  - **Use K8s CronJob when:** stateless one-shot diagnostics, you want native K8s observability (Prometheus job_metrics), declarative GitOps with schedule in git, K8s primitives (Secrets, NetworkPolicies, resource quotas), multi-team / multi-tenant
  - **Real-world honest stance:** Most agent work uses Hermes cron because state matters; K8s CronJob shines for fire-and-forget diagnostic jobs.
- **D-11:** **K8s CronJob image source.** The CronJob manifest references a container image with `hermes` CLI. Researcher must determine: does Hermes publish a docker image? If yes, use it. If no, ship a small `infrastructure/scenarios/k8s/cronjob/Dockerfile` building from `python:3.12-alpine` + `pip install hermes-agent` (or whatever the install path is). Researcher resolves before planning.

### TRIG-03: GitHub Webhook (smee.io + real, with simulated fallback)

- **D-12:** **smee.io public proxy + real GitHub webhook is the primary path.** smee.io is the Probot project's free public webhook proxy. Lab walkthrough:
  1. Visit smee.io, click "Start a new channel" → get a unique URL like `https://smee.io/abc123`
  2. Install smee-client locally: `npm install -g smee-client` (or use `npx smee-client`)
  3. Run `smee --url https://smee.io/abc123 --target http://localhost:8644/webhooks/github`
  4. Create webhook on a personal/sample GitHub repo pointing at the smee.io URL
  5. Push a commit or open a PR on the repo
  6. Observe Hermes gateway receiving the GitHub event, agent fires with PR context
  7. Agent posts a review comment back via `gh api` or `curl` with personal access token
- **D-13:** **Solo Learner fallback for Udemy:** `hermes webhook test github-pr --payload '{...}'` with a hand-crafted GitHub PR webhook payload. Documented as `:::info Solo Learner` callout in every TRIG-03 step. Mirrors Phase 6 mock fallback pattern.
- **D-14:** **GitHub PAT scope:** Personal Access Token needs `repo` scope (read PRs, post comments). Lab includes a setup callout walking through GitHub Settings → Developer settings → Personal access tokens (classic) → Generate new → repo scope. PAT stored in `~/.hermes/secrets/github.token` (gitignored). Researcher confirms current GitHub PAT creation flow.
- **D-15:** **GitHub agent action:** Lab demonstrates posting a review comment back via GitHub API. The agent prompt template includes PR context (title, files changed, diff stats). The post-back action uses `gh pr comment` or direct `curl` against `https://api.github.com/repos/{owner}/{repo}/issues/{number}/comments`. Demonstrates bidirectional flow (event in → action out).

### TRIG-04: Telegram Chat Bot (real, hands-on)

- **D-16:** **Telegram primary, hands-on, real bot.** Walkthrough:
  1. Open Telegram, search for `@BotFather`
  2. Send `/newbot`, follow the prompts (bot name, username)
  3. Receive bot token (looks like `123456:ABC-DEF...`)
  4. Configure Hermes Telegram adapter (`hermes gateway setup` with telegram enabled, paste token)
  5. Find your bot in Telegram, send `/help`
  6. Observe Hermes receiving the message, agent responds in same chat thread
  Free, no admin approval, works for every Udemy learner. Telegram is the most accessible chat platform for the course.
- **D-17:** **Slack documented as production reference, NOT hands-on.** Mirror existing Module 12 Step 8 pattern. Show the Slack bot config snippets, OAuth scopes, slash command definitions, but do NOT require participants to set it up. Caveat about workspace admin requirement clearly stated. Slack walkthrough is a `:::note Demo-only section` admonition.
- **D-18:** **Three slash commands per track:**
  - `/diagnose <argument>` — fires the diagnostic agent with the argument (Track A: db-name, Track B: account-id or service, Track C: pod-name or namespace)
  - `/status` — returns gateway + agent health status, including current governance level, registered cron jobs, recent webhook activity
  - `/help` — lists available commands and example usage
  Compact (3 commands), demonstrates argument parsing, useful for actual on-call teams. Per-track examples show participants what their specific track's commands look like.
- **D-19:** **Chat bot governance inheritance with per-command override.** Default governance is L2 (read-only diagnostics). Advanced users can prefix command with `/diagnose --governance L4 <arg>` to escalate, BUT only if their Telegram user_id is listed in an `admin_user_ids` allowlist in the bot config (`~/.hermes/telegram.yaml` or similar). Mirrors how AlertManager and CronJob agents inherit env-var-driven governance — per-context with explicit escalation.
- **D-20:** **Output delivery — reply in same chat thread.** Agent's diagnostic output posted as a reply in the same Telegram chat where the slash command originated. Markdown-formatted findings, code blocks for kubectl/SQL output. Telegram message limit is 4096 chars — if exceeded, truncate with "see full report at <link>" pointing to a saved file. Bidirectional UX matches the requirement "results posted back to the channel".

### Cross-Cutting

- **D-21:** **Module 12 lab numbering after extension.** Existing Steps 1-8 stay as-is. New Phase 8 steps insert after Step 8 in this order: Step 9 (AlertManager setup) → Step 10 (AlertManager fire+observe) → Step 11 (K8s CronJob comparison) → Step 12 (GitHub webhook setup with smee.io) → Step 13 (GitHub agent comment back) → Step 14 (Telegram bot setup) → Step 15 (Telegram /diagnose command) → Step 16 (Telegram governance escalation). Existing free-explore steps shift down. Final count approximately 16-18 GUIDED steps.
- **D-22:** **Per-track variants:** Where commands differ by track (A/B/C), Phase 8 ships per-track examples in callouts the same way Module 12 currently does (Track A: dba-rds-slow-query, Track B: cost-anomaly, Track C: kubernetes-health). The 3 slash commands and the K8s CronJob manifest are track-parameterized.
- **D-23:** **Both Module 12 lab mirrors updated.** `course-site/docs/module-12-triggers/lab/LAB.mdx` (Docusaurus) AND `modules/module-12-triggers/LAB.md` (source-of-truth, if exists — researcher confirms). Same dual-mirror pattern as Module 13 in Phase 7.
- **D-24:** **Reading reference.mdx update.** Module 12 reading documents trigger patterns conceptually. Phase 8 updates it with the 4 real trigger types and includes a comparison table showing when to use each. Light touch — not a rewrite.
- **D-25:** **Quiz updates.** Add 2-3 new questions: one on the Hermes-cron-vs-K8s-CronJob tradeoff, one on the AlertManager → webhook → agent flow, one on the chat bot governance inheritance. Existing Module 12 quiz questions stay intact.

### Environment Variables (Phase 8 additions)

- **D-26:** **Phase 8 adds these env vars to the lab export block** (extending Phase 7 D-05):

  | Env Var | Values | Source | Purpose |
  |---|---|---|---|
  | `HERMES_LAB_MODE` | mock \| live | Phase 1 | Existing |
  | `HERMES_LAB_SCENARIO` | clean \| crashloop2 \| ... | Phase 1+6 | Existing |
  | `HERMES_LAB_GOVERNANCE` | L1 \| L2 \| L3 \| L4 | Phase 7 | Existing — inherited by triggered agents |
  | `HERMES_LAB_TRACK` | track-a \| track-b \| track-c | Phase 7 | Existing |
  | `MOCK_DATA_DIR` | path | Phase 1 | Existing |
  | `PATH` additions | `infrastructure/wrappers:$PATH` | Phase 1 | Existing |
  | `GITHUB_TOKEN` | PAT with repo scope | **Phase 8 NEW** (TRIG-03) | GitHub webhook + agent comment posting |
  | `TELEGRAM_BOT_TOKEN` | bot token from @BotFather | **Phase 8 NEW** (TRIG-04) | Telegram bot connection |
  | `SMEE_URL` | https://smee.io/{channel} | **Phase 8 NEW** (TRIG-03) | Public webhook proxy URL |

  Lab steps that exercise GitHub require `GITHUB_TOKEN`. Lab steps that exercise Telegram require `TELEGRAM_BOT_TOKEN`. Lab steps that exercise smee.io require `SMEE_URL`. Solo Learner callouts explain how to get each. The 6 base env vars (MODE/SCENARIO/GOVERNANCE/TRACK/MOCK_DATA_DIR/PATH) are still shown in every step's complete export block per Phase 7 D-05.

### Claude's Discretion

- Exact PrometheusRule expression syntax (D-04 has the gist)
- AlertManager receiver YAML (config_reload helm values vs ConfigMap)
- Specific Dockerfile contents for K8s CronJob image (if Hermes doesn't publish one)
- Telegram bot adapter implementation in Hermes (researcher confirms whether it exists)
- smee-client installation method (npm vs npx vs binary download)
- Exact wording of the "use Hermes cron when…" callout
- Module 12 reading reference.mdx structural changes
- Quiz question phrasing (collapsible explanation pattern)
- Whether to add a Phase 8 exploratory PROJECTS.mdx entry (e.g., Discord adapter, Mattermost, GitLab webhook)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing Module 12 Content (Phase 8 extends)
- `course-site/docs/module-12-triggers/lab/LAB.mdx` — Existing 8-step lab walking Hermes cron + simulated webhooks. **Phase 8 extends after Step 8.** Do NOT rewrite Steps 1-8 narrative.
- `modules/module-12-triggers/LAB.md` — Source-of-truth mirror (researcher confirms it exists).
- `course-site/docs/module-12-triggers/reading/reference.mdx` — Module 12 reference reading. Phase 8 updates with the 4 real trigger types and comparison table.
- `course-site/docs/module-12-triggers/reading/concepts.mdx` — Light-touch updates only where new triggers need conceptual cross-reference.
- `course-site/docs/module-12-triggers/quiz/QUIZ.mdx` — Add 2-3 new questions per D-25.
- `course-site/docs/module-12-triggers/exploratory/PROJECTS.mdx` — Optional Phase 8 additions (Discord adapter, GitLab webhook, etc.) per D-Claude's discretion.

### Phase 6 Scenarios (TRIG-01 reuses)
- `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` — Phase 6 baked CrashLoopBackOff manifest. TRIG-01 alert fires on this. **Do NOT modify** — TRIG-01 references it as-is.
- `infrastructure/scenarios/k8s/02-crashloop-backoff.md` — Phase 6 sibling doc. Read for context.

### Phase 1 Infrastructure (Phase 8 modifies)
- `infrastructure/helm/prometheus-lab-values.yaml` — Currently `alertmanager.enabled: false`. **Phase 8 sets to true** and adds AlertManager configuration block.
- `infrastructure/kind/cluster-config.yaml` — Existing KIND cluster. **Phase 8 may need to add port 8644 to extraPortMappings** for Hermes webhook gateway access (researcher confirms whether host.docker.internal works without explicit port mapping).

### Phase 7 Wrapper Enforcement (Phase 8 inherits)
- `infrastructure/wrappers/mock-kubectl` — Phase 7 wrapper with HERMES_LAB_GOVERNANCE pre-flight. Triggered agents inherit this enforcement when they invoke kubectl.
- `infrastructure/wrappers/mock-aws` — Same.
- `infrastructure/wrappers/mock-psql` — Same.
- `governance/governance-L*.yaml` — Phase 7 populated wrapper_allowlist files. Triggered agents read from these per the env var.

### Hermes Source (researcher reads)
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/cron.py` (or similar) — Hermes internal cron implementation. Researcher verifies current `hermes cron` command set still matches Module 12 Steps 2-4.
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/webhook.py` — Hermes webhook subscription implementation. Researcher verifies `hermes webhook subscribe`, `hermes webhook test`, gateway routing.
- `/Users/gshah/work/agentic/devops/hermes-agent/gateway/` — Webhook gateway code. Researcher confirms HMAC handling, env var propagation to spawned agent runs, port configuration.
- `/Users/gshah/work/agentic/devops/hermes-agent/adapters/telegram/` (if exists) — Telegram bot adapter. Researcher confirms whether this exists or needs to be built.
- `/Users/gshah/work/agentic/devops/hermes-agent/adapters/slack/` (if exists) — Slack adapter for production reference docs.
- `/Users/gshah/work/agentic/devops/hermes-agent/Dockerfile` — Researcher checks whether Hermes publishes a container image or if Phase 8 needs to ship one.

### External Services (researcher verifies)
- **smee.io** — https://smee.io/ — Probot's free public webhook proxy. Researcher confirms it's still alive (no recent shutdown announcements) and the smee-client package install path.
- **Telegram BotFather** — https://core.telegram.org/bots/features#botfather — Bot creation flow. Researcher confirms current UX (in case the API has changed) and that bot tokens are still free and unrate-limited for personal use.
- **GitHub PAT (classic)** — https://github.com/settings/tokens — PAT creation flow. Researcher confirms current scopes for `repo` and any new fine-grained PAT considerations.
- **Prometheus Operator PrometheusRule** — https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.PrometheusRule — Reference for the rule manifest format.
- **AlertManager webhook receiver** — https://prometheus.io/docs/alerting/latest/configuration/#webhook_config — Reference for receiver YAML.

### Course Project & Requirements
- `.planning/PROJECT.md` — v1.1 Active requirements, Key Decisions
- `.planning/REQUIREMENTS.md` §Agent Triggers — TRIG-01 through TRIG-04
- `.planning/ROADMAP.md` Phase 8 — 4 success criteria
- `.planning/phases/06-k8s-skills-agents/06-CONTEXT.md` — Phase 6 baked manifests pattern (reused for TRIG-01)
- `.planning/phases/07-guardrails-governance/07-CONTEXT.md` — Phase 7 wrapper enforcement (inherited by triggered agents)
- `CLAUDE.md` — Course conventions

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Module 12 lab Steps 1-8** — Already cover Hermes cron + simulated webhook gateway. Phase 8 reuses this as the foundational walkthrough and adds new steps for the 4 real trigger types after Step 8.
- **Hermes webhook gateway** — `hermes gateway setup`, `hermes webhook subscribe`, `hermes webhook list`, `hermes webhook test` already exist (Module 12 references them). Phase 8 reuses for AlertManager and GitHub real-webhook flows.
- **Hermes cron infrastructure** — `hermes cron create/list/trigger/pause/resume/status` already exists. Phase 8 reframes Steps 2-4 as "production scheduled agents" without rewriting.
- **Phase 6 crashloop2 scenario** — Already produces a real CrashLoopBackOff pod on KIND. Phase 8 alert rule fires on this scenario, no new broken-pod manifest needed.
- **Phase 7 wrapper enforcement** — Already enforces governance for kubectl/aws/psql. Triggered agents inherit this automatically when they invoke these commands.
- **Phase 4 Solo Learner callout pattern** — Reused for Phase 8 trigger steps that need a fallback when external infra (smee.io, Telegram) isn't available.

### Established Patterns
- **Lab extension over rewrite** — Phase 5/6/7 all extended existing modules rather than rewriting them. Phase 8 follows the same pattern.
- **Per-track variants in callouts** — Module 12's existing Step 2 has Track A/B/C variants of the cron create command. Phase 8's slash commands and K8s CronJob manifest follow the same per-track pattern.
- **Two-mirror sync** — Course content lives in both `course-site/docs/...mdx` (Docusaurus) and `modules/...md` (source-of-truth). Both must be updated.
- **Solo Learner callouts** — `:::info Solo Learner` block in MDX, blockquote in MD. Phase 4 established the pattern; Phase 6/7 reused it.
- **HERMES_LAB_* env var convention** — All lab-control env vars use this prefix. Phase 8 adds GITHUB_TOKEN, TELEGRAM_BOT_TOKEN, SMEE_URL which are NOT HERMES_LAB_* prefixed because they're external service credentials, not lab control.
- **Demo-only section pattern** — Module 12 Step 8 already uses `:::note Demo-only section` for Slack content the participant doesn't run. Phase 8 reuses this for the Slack-as-production-reference content in TRIG-04.

### Integration Points
- **Hermes webhook gateway port (8644)** — Used by both AlertManager (TRIG-01) and GitHub (TRIG-03) and Telegram (TRIG-04 if Telegram uses webhook mode rather than long polling). KIND cluster-config.yaml may need port 8644 added to extraPortMappings (researcher confirms).
- **AlertManager → host.docker.internal:8644** — In-cluster AlertManager reaches host gateway via Docker Desktop's host.docker.internal DNS.
- **smee.io → localhost:8644** — smee-client running on the host forwards smee.io traffic to localhost:8644.
- **Telegram bot token storage** — Hermes config (`~/.hermes/telegram.yaml` or env var `TELEGRAM_BOT_TOKEN`). Researcher confirms current Hermes Telegram adapter config path.
- **Per-trigger governance** — All 4 trigger paths read HERMES_LAB_GOVERNANCE the same way Phase 7 wrappers do. K8s CronJob sets it via container env spec; webhook/cron/bot agents inherit from gateway env.

</code_context>

<specifics>
## Specific Ideas

- **Hermes cron is the pragmatic answer for most agent work.** The user's instinct was right — most DevOps teams building agents will reach for Hermes cron because the gateway holds the agent state (loaded skills, audit trail, conversation context). K8s CronJob is the right answer for stateless one-shot diagnostics and GitOps-managed deployments. Phase 8 teaches both with explicit "use this when…" guidance. The diff between the two patterns IS the teaching moment (mirroring Phase 7's three-layer defense framing).

- **Real infrastructure where feasible, simulated fallback for Udemy.** Phase 6 established this pattern: live KIND primary, mock fallback documented. Phase 8 extends it: real AlertManager primary, real GitHub webhook primary, real Telegram bot primary, with `hermes webhook test` and similar simulators in Solo Learner callouts. Authentic production flow for workshop participants; accessible alternative for self-paced learners.

- **Phase 7 governance inheritance is the safety story for autonomous triggers.** A scheduled agent that runs without human present is more dangerous than an interactive one. Phase 8's commitment to inherit Phase 7's wrapper governance means triggered agents respect the same allowlist/blocklist. K8s CronJob env vars, webhook gateway propagation, bot config inheritance — three different mechanisms, one consistent governance model.

- **External service tokens are the new lab dependency.** GitHub PAT, Telegram bot token, smee.io channel URL — three new external pieces participants need to acquire. Lab setup steps walk through each carefully. Solo Learner callouts explicitly say "this step requires X token; here's how to get it" with the time estimate (Telegram: 2 min, GitHub PAT: 3 min, smee.io: 30 sec).

- **AlertManager fires on the Phase 6 crashloop2 scenario.** This is a beautiful reuse — Phase 6 built the broken pod, Phase 8 builds the alert that observes it. End-to-end flow: kubectl apply broken-pod → kube-state-metrics scrapes → alert rule fires → AlertManager dispatches → webhook receiver hits Hermes → agent diagnoses with full context. This is the kind of integration that makes the course feel real.

- **Telegram is the right primary chat platform for Udemy accessibility.** Free, no admin approval, 2-minute setup via @BotFather, works for every learner globally. Slack is enterprise-relevant but blocks any participant who lacks workspace admin. Phase 8 documents Slack as production reference (config snippets, OAuth scopes) but keeps the hands-on path on Telegram. Same pattern Phase 1 used for Claude Code primary + Crush fallback.

</specifics>

<deferred>
## Deferred Ideas

### Phase 9 territory (do not preempt)
- **Multi-agent orchestration via triggers** — End-to-end alert→triage→diagnose→propose→approve→apply chain (FLEET-01). Phase 8 ships the trigger infrastructure; Phase 9 wires multiple agents together.
- **Fleet coordinator (Morgan) wiring** — Morgan orchestrating specialist agents triggered by AlertManager. Phase 9 / FLEET-02 territory.
- **K8s Agent Sandbox** — Running triggered agents inside the K8s Agent Sandbox CRDs. Phase 9 / PROD-01 territory.
- **Productionization patterns** — Packaging, deployment, monitoring, scaling. Phase 9 / PROD-02 territory.

### v1.2 candidates
- **Discord adapter** — Same UX as Telegram but on Discord. Mentioned in PROJECTS.mdx as exploratory work, not a v1.1 lab.
- **GitLab webhook** — Same pattern as GitHub but for GitLab repos. Optional exploratory entry.
- **Mattermost / Rocket.Chat adapters** — Open-source chat platforms. Exploratory.
- **Webhook signature verification deep-dive** — HMAC, JWT, OIDC token verification beyond Hermes's built-in HMAC. Future content.
- **Trigger composition patterns** — Webhook fans out to multiple agents, cron job triggers webhook chain, etc. Advanced composition is Phase 9 + v1.2 territory.
- **Telegram bot deployed as K8s Pod** — Running the chat bot in-cluster (combines TRIG-02 K8s pattern with TRIG-04 chat). Could be a Phase 9 PROD-01 example.
- **AlertManager grouping/inhibition tuning** — Real production AlertManager has rich routing. Phase 8 ships a minimal receiver; v1.2 could expand.

</deferred>

---

*Phase: 08-agent-triggers*
*Context gathered: 2026-04-07*
