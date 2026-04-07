# Phase 9: Multi-Agent Workflows & Production - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Wire the end-to-end automated incident response chain (AlertManager → Morgan triage → specialist diagnoses → propose fix → Telegram approval → specialist applies fix), rebuild Module 11 lab as live-primary using Phase 6/7/8 real infrastructure, and add K8s Agent Sandbox + productionization content. **This is the final v1.1 phase.** Covers FLEET-01, FLEET-02, PROD-01, PROD-02.

Phase 9 ships:

1. **FLEET-01:** End-to-end live chain on KIND — AlertManager fires on Phase 6 crashloop2 scenario → Phase 8 webhook gateway → Morgan triages and delegates → Track C specialist diagnoses with sre-k8s-pod-health → Morgan synthesizes + proposes fix → Telegram approval (Phase 8 admin allowlist) → specialist applies under L4 governance
2. **FLEET-01 dual apply paths:** Path A (direct kubectl apply at L4 governance, primary) AND Path B (GitOps PR-based via Phase 8 GitHub integration, "production upgrade" section). Path B uses ArgoCD if available OR a course-provided helm upgrade fallback script
3. **FLEET-02:** Module 11 lab rewritten as live-primary with Solo Learner mock callouts. Existing 7-step mock-only walkthrough replaced. Morgan SOUL.md gets a light edit (3 small additions)
4. **PROD-01:** K8s Agent Sandbox as exploratory PROJECTS.mdx entry in module-11-fleet/exploratory/ (NOT a required GUIDED step — alpha CRDs are too volatile per STATE.md blocker). Pinned install version mitigates alpha risk
5. **PROD-02:** New productionization reference section in Module 11 reading covering packaging, deployment, monitoring, scaling — with concrete Hermes config examples and Phase 6/7/8 cross-references
6. Module 11 reading + quiz updates to cover the new live flow + production patterns
7. **Milestone v1.1 close** — Phase 9 is the last phase; on completion, the milestone is ready for /gsd:complete-milestone

Phase 9 does NOT touch:
- Phase 6 K8s skills (sre-k8s-*) — read-only reference
- Phase 7 wrapper enforcement source code — Phase 9 RELIES on it for the apply step
- Phase 8 AlertManager / GitHub / Telegram infrastructure — Phase 9 RELIES on it for trigger + approval
- Module 1-7 content (out of scope)
- Module 12 / 13 lab content (already shipped in Phases 7 + 8)

</domain>

<decisions>
## Implementation Decisions

### FLEET-01 Chain Architecture

- **D-01:** **Morgan IS the triage step.** No separate triage agent. AlertManager → Hermes webhook gateway → Morgan invocation with alert payload → Morgan triages (which domains) → Morgan delegates to relevant specialists → specialists return findings → Morgan synthesizes + proposes fix → human approves → specialist re-delegated for apply. The "triage agent" wording in FLEET-01 is just clarifying language for Morgan's first responsibility. No new agent profiles needed for triage.

- **D-02:** **Human approval via Telegram bot from Phase 8.** After Morgan synthesizes findings and proposes a fix, the proposal is posted to the configured Telegram channel as a structured markdown message including: incident summary, proposed action (kubectl command or PR link), risk assessment, governance level required. Admin user replies with `/approve <incident-id>` or `/reject <incident-id>`. Approval triggers the apply step. Reuses Phase 8 admin allowlist mechanism (D-19 in Phase 8 CONTEXT). Bidirectional ChatOps closes the loop.

- **D-03:** **Specialist applies under L4 governance.** After human approval, Morgan re-delegates to the same specialist that diagnosed the issue (e.g., Track C for K8s scenarios). The re-delegation sets `HERMES_LAB_GOVERNANCE=L4` + `HERMES_LAB_TRACK=track-c` in the spawned agent's environment. The specialist runs the approved command. Phase 7 wrapper enforces L4 allowlist; the action passes if it's in the L4 allowlist (e.g., `kubectl apply` for Track C, `aws ec2 create-tags` for Track B). Audit trail captures the L4 escalation. Single-agent applier reuses existing infrastructure — no new applier agent.

- **D-04:** **Demo scenario — Phase 6 crashloop2 + Phase 8 alert.** AlertManager fires on the existing Phase 6 baked CrashLoopBackOff manifest at `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml`. Track C specialist diagnoses OOMKilled root cause via sre-k8s-pod-health. Morgan proposes a kubectl patch increasing memory limit from 64Mi to 256Mi (or generates a YAML overlay for Path B). Human approves. Specialist applies. Pod restarts successfully. Reuses ALL existing Phase 6+7+8 infrastructure — no new scenario authoring.

### FLEET-01 Apply Paths (Dual Pattern)

- **D-05:** **Two apply paths, both shipped in Phase 9.** Path A is the primary (accessible to all participants), Path B is the "production upgrade" section showing the GitOps pattern. The diff between A and B IS the teaching moment, mirroring Phase 8's Hermes-cron-vs-K8s-CronJob teaching structure.

- **D-06:** **Path A — Direct kubectl apply at L4 governance (PRIMARY).** Specialist agent runs `kubectl apply` (or `kubectl patch`) directly after Telegram approval. Phase 7 wrapper enforces L4 allowlist + audit. Works on any KIND cluster + Hermes — no Module 6 Track B prerequisites. Lab walks this path end-to-end as the GUIDED PHASE main flow. Solo Learner callouts use mock-kubectl wrapper for participants without live KIND.

- **D-07:** **Path B — GitOps PR-based apply ("production upgrade" section).** Research-corrected: ArgoCD installation infrastructure does NOT exist in the course repo (Phase 1/3 reference was documentation-only). Sub-path B1 (ArgoCD sync) cannot be a guided step in v1.1. Path B uses the helm upgrade fallback (Sub-path B2) as the ONLY sync mechanism.

  After Path A completes, a new GUIDED PHASE section walks Path B for participants who want to see the production-grade pattern:
  1. Specialist agent generates the YAML patch as a file (not directly applies)
  2. Agent commits to a feature branch in a course-provided GitOps repo (or local repo for Solo Learners)
  3. **Agent opens PR via specialist's terminal toolset calling `gh pr create` directly** (research-corrected: Hermes has `_deliver_github_comment` for posting to existing PRs but NO `_deliver_github_pr` for opening new ones. The specialist must call `gh pr create` from its terminal toolset.)
  4. Human reviews the diff in GitHub UI (richer than Telegram message)
  5. Human merges the PR
  6. **Sync mechanism:** `infrastructure/scenarios/k8s/gitops/apply.sh` script wraps `helm upgrade --install reference-app reference-app/helm/ --values <merged-patch>`. Self-contained, no ArgoCD prerequisite.
  7. Confirmation posted back to Telegram via webhook
  Lab text mentions ArgoCD as a v1.2 alternative with explicit "ArgoCD-based sync would replace this script in production deployments" callout, but the GUIDED step uses the helm upgrade script.

- **D-08:** **Why two paths instead of GitOps-only:** Not every workshop participant or Udemy learner will have completed Module 6 Track B (ArgoCD on KIND). Requiring ArgoCD for FLEET-01 creates a hard prerequisite that excludes learners. Path A (direct apply) works for everyone; Path B (GitOps) is for those who want the production teaching. User decision per discussion log.

- **D-09:** **Helm upgrade fallback script lives at `infrastructure/scenarios/k8s/gitops/apply.sh`.** New `infrastructure/scenarios/k8s/gitops/` directory holds Phase 9 GitOps artifacts: apply.sh, README.md explaining the merged-patch overlay structure, sample patch YAML (memory limit increase). Self-contained, doesn't require ArgoCD, runs after PR merge. Participants who DO have ArgoCD can skip the script and let ArgoCD sync. Reuses the existing reference-app Helm chart from Phase 1.

- **D-10:** **GitOps repo location.** For Path B, the GitOps repo can be: (a) the participant's fork of a course-provided sample repo, (b) a local-only git repo on their machine (no GitHub push), or (c) a personal GitHub repo they own. Lab walks through option (a) as the primary, with Solo Learner callout for option (b). Researcher confirms whether the course-provided sample repo exists or needs to be created.

### FLEET-02 Module 11 Lab Rewrite

- **D-11:** **Module 11 lab rewritten as live-primary.** Existing 7 GUIDED steps (mock-only) are REPLACED, NOT extended. The new live-primary lab walks: (1) prerequisites (KIND running, Phase 6 scenarios applied, Phase 7 governance configured, Phase 8 AlertManager + Telegram available), (2) install Morgan, (3) read Morgan SOUL.md, (4) understand the cross-domain scenario, (5) trigger AlertManager fire (Phase 6 crashloop2), (6) observe Morgan triage + delegation, (7) observe specialist diagnoses, (8) observe Morgan synthesis + Telegram proposal, (9) approve via Telegram, (10) observe Path A apply, (11) Production upgrade section: Path B GitOps walkthrough. Approximately 11 GUIDED steps + Free Explore section.

- **D-12:** **Solo Learner callouts inside live lab.** Each major step gets a `:::info Solo Learner` callout showing the mock-mode equivalent (set `HERMES_LAB_MODE=mock` + appropriate scenario, the wrapper produces expected outputs without real KIND/Telegram). Mirrors Phase 6 pattern. Udemy participants stay supported.

- **D-13:** **Light edit to Morgan SOUL.md + REQUIRED config.yaml toolset update (research-corrected).** Hermes delegation INTERSECTS child toolsets with the parent's `enabled_toolsets` per `delegate_tool.py` lines 178-184. Morgan must have `terminal` in her toolset for delegated specialists to inherit it and run kubectl. The original D-13 stance ("Morgan stays at `cli: [web, skills]`") was mechanically incompatible with delegated apply.

  **config.yaml change (REQUIRED):**
  - `cli: [web, skills]` → `cli: [terminal, web, skills]`
  - Comment block above the line explains: "Morgan needs `terminal` in her toolset because Hermes delegation intersects child toolsets with parent. Specialists Morgan delegates to can only use tools Morgan has. Behavioral prohibition against Morgan calling terminal directly is enforced by the new NEVER rule below + existing 4 NEVER rules."

  **SOUL.md additions (4 total — was 3):**
  1. Behavior Rules: add "After human approval, re-delegate to the diagnosing specialist with L4 governance escalation"
  2. Behavior Rules: add "Generate fix proposals as kubectl patch commands OR YAML diff overlays (for GitOps path)"
  3. Behavior Rules: add **NEW NEVER rule**: "NEVER call terminal tools directly — your role is delegation, not execution. If you need a kubectl/aws/psql command run, delegate it to the appropriate specialist. The terminal toolset exists in your config so children can inherit it, NOT for your direct use."
  4. Escalation Policy: add "Await human approval via Telegram before re-delegating apply"

  Belt + suspenders: mechanical capability for delegation (config), behavioral prohibition against direct execution (SOUL.md). Approximately 12-15 line addition total. Identity intact, anti-loop and sequential rules unchanged.

- **D-14:** **cross-domain.md scenario fixture stays usable.** The existing scenario fixture is reused for the live lab. Researcher verifies whether it needs updates to reflect Phase 6 K8s skills + Phase 7 governance vocabulary, or whether the existing version is still accurate.

### PROD-01 K8s Agent Sandbox

- **D-15:** **Exploratory PROJECTS.mdx entry only.** K8s Agent Sandbox lives as a single project entry in `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx`. Includes:
  1. What the Sandbox provides (CRD-based agent isolation, namespace boundaries, resource quotas, lifecycle management)
  2. Install command pinned to a specific release tag (mitigates STATE.md alpha v0.2.1 blocker — researcher confirms current pinned version)
  3. Deploy-an-agent walkthrough using one of the Phase 6 Track C agents (Kiran with sre-k8s-pod-health)
  4. Verification commands showing agent cannot access resources outside its namespace
  5. Clean-up steps
  NOT a required GUIDED lab step. Self-paced for participants who finish early. Honors the "exploratory only" STATE.md note while still delivering teachable content.

- **D-16:** **Module 11 fleet exploratory is the home.** Sandbox is about running agents at scale on Kubernetes. Module 11 is the "fleet at scale" module. Phase 9 already extends Module 11 lab and reading, so the exploratory entry stays in the same module for cohesion.

- **D-17:** **No infrastructure file commitments beyond install commands.** Phase 9 does NOT ship Sandbox CRD manifests or install scripts (alpha CRDs change too fast). The exploratory entry includes the install commands as code blocks for participants to copy, but no `infrastructure/scenarios/k8s/sandbox/` directory. If alpha v0.2.1 is broken at workshop delivery time, the exploratory entry can be updated quickly without invalidating any committed lab infrastructure.

### PROD-02 Productionization Content

- **D-18:** **New productionization reference section in Module 11 reading.** Add to `course-site/docs/module-11-fleet/reading/reference.mdx` (or concepts.mdx, whichever currently has more reference content — researcher confirms). The new section covers four topics:
  1. **Packaging:** container images, version pinning, dependency management, hermes-agent install patterns
  2. **Deployment:** K8s manifests, Helm charts, GitOps as the prod pattern (cross-reference Phase 9 Path B)
  3. **Monitoring:** agent metrics, audit logs, governance event stream (cross-reference Phase 7 wrapper logs), Prometheus integration (cross-reference Phase 8 AlertManager)
  4. **Scaling:** horizontal scaling considerations, queue-based vs trigger-based, multi-tenant isolation, K8s Agent Sandbox link (cross-reference D-15)

- **D-19:** **Reference doc depth — ~500-800 lines structured content.** Each topic gets a section with: real Hermes config examples (NOT generic cloud theory), Phase 6/7/8 cross-references showing how course components map to production patterns, recommended tooling, common pitfalls, and "when to use this vs that" decision tables. Mirrors the depth of Module 13 reference.mdx Phase 7 just shipped.

- **D-20:** **Quiz updates.** Add 2-3 new Module 11 quiz questions covering: (1) the dual apply path tradeoff (direct vs GitOps), (2) the multi-agent re-delegation pattern with governance escalation, (3) productionization decision (one of the "use this when" scenarios from PROD-02 reading). Existing quiz questions stay intact.

- **D-21:** **Both Module 11 lab mirrors updated** if both exist. Researcher confirms whether `modules/module-11-fleet/LAB.md` source-of-truth mirror exists alongside `course-site/docs/module-11-fleet/lab/LAB.mdx`. Same dual-mirror pattern as Module 12 (Phase 8) and Module 13 (Phase 7).

### Cross-Cutting

- **D-22:** **Phase 9 NEW env vars.** Phase 9 adds these env vars to the lab export block (extending Phase 7 + Phase 8 sets):

  | Env Var | Values | Source | Purpose |
  |---|---|---|---|
  | `HERMES_LAB_MODE` | mock \| live | Phase 1 | Existing |
  | `HERMES_LAB_SCENARIO` | crashloop2 \| cross-domain | Phase 1+6 | Existing |
  | `HERMES_LAB_GOVERNANCE` | L1 \| L2 \| L3 \| L4 | Phase 7 | Existing — escalates to L4 for the apply step |
  | `HERMES_LAB_TRACK` | track-a \| track-b \| track-c | Phase 7 | Existing |
  | `MOCK_DATA_DIR` | path | Phase 1 | Existing |
  | `PATH` additions | `infrastructure/wrappers:$PATH` | Phase 1 | Existing |
  | `GITHUB_TOKEN` | PAT with `repo` scope | Phase 8 | Used in Path B for PR creation |
  | `TELEGRAM_BOT_TOKEN` | bot token | Phase 8 | Used for approval messages |
  | `TELEGRAM_ALLOWED_USERS` | comma-separated user_ids | Phase 8 | Admin allowlist for `/approve` |
  | `GITOPS_REPO_URL` | git URL | **Phase 9 NEW** (D-10) | Path B PR target repo |
  | `GITOPS_BRANCH_PREFIX` | string | **Phase 9 NEW** (D-07) | Branch naming for fix PRs (e.g., `hermes-fix-`) |

  Lab steps that exercise Path B require `GITHUB_TOKEN` + `GITOPS_REPO_URL`. Per Phase 7 D-05, every Phase 9 lab step shows the complete export block.

- **D-23:** **Milestone v1.1 close criteria.** Phase 9 is the last v1.1 phase. After Phase 9 ships:
  1. All 4 Phase 9 must-haves verified (FLEET-01, FLEET-02, PROD-01, PROD-02)
  2. PROJECT.md evolved to reflect "v1.1 complete"
  3. Outstanding UAT items (Phase 6, 7, 8 if any) flagged for manual close-out
  4. Run `/gsd:audit-uat` for cross-phase verification debt review
  5. Run `/gsd:complete-milestone` to archive v1.1 and prepare for v1.2

### Claude's Discretion

- Exact YAML patch generation pattern (jq-style overlay vs full manifest replacement)
- The GitOps repo branch naming convention details
- Specific Sandbox CRD release version pin (researcher recommends; planner finalizes)
- Whether the Module 11 lab rewrite uses a single LAB.mdx file or splits into LAB-mock.mdx + LAB-live.mdx (planner decides based on length)
- Exact wording of the "Production upgrade: GitOps PR-based apply" section
- Quiz question phrasing and rationale depth
- Whether to add a Phase 9 PROJECTS.mdx exploratory entry beyond Sandbox (e.g., "Build a triage agent separate from Morgan")
- Order and structure of PROD-02 reference content sections

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing Module 11 Content (Phase 9 rewrites/extends)
- `course-site/docs/module-11-fleet/lab/LAB.mdx` — Existing 7-step mock-only lab. **Phase 9 REPLACES this with live-primary version per D-11.** The 7 existing steps become reference for what changed.
- `modules/module-11-fleet/LAB.md` — Source-of-truth mirror (researcher confirms it exists).
- `course-site/docs/module-11-fleet/reading/reference.mdx` — Reading reference. **Phase 9 ADDS new productionization section per D-18.**
- `course-site/docs/module-11-fleet/reading/concepts.mdx` — Concepts reading. Light touch only if PROD-02 needs cross-references.
- `course-site/docs/module-11-fleet/quiz/QUIZ.mdx` — **Phase 9 ADDS 2-3 new questions per D-20.**
- `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx` — **Phase 9 ADDS K8s Agent Sandbox project entry per D-15.**

### Fleet Coordinator (Morgan) — Light Edit
- `agents/fleet-coordinator/SOUL.md` — Existing identity (delegate, never execute, anti-loop, sequential). **Phase 9 light-edits per D-13** (3 small additions).
- `agents/fleet-coordinator/config.yaml` — `cli: [web, skills]` (no terminal), `delegation:` block. **Phase 9 leaves UNCHANGED** — Morgan still doesn't execute.

### Phase 6 Reuse (read-only references)
- `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` — Phase 6 baked CrashLoopBackOff manifest. Phase 9 FLEET-01 demo scenario reuses this AS-IS.
- `infrastructure/scenarios/k8s/02-crashloop-backoff.md` — Phase 6 sibling doc.
- `skills/sre-k8s-pod-health/SKILL.md` — Phase 6 K8s diagnostic skill. Track C specialist uses this for diagnosis step.
- `agents/track-c-kubernetes/SOUL.md` and skills — Phase 6 Track C agent profile. Phase 9 invokes this as the diagnostic specialist.

### Phase 7 Reuse (apply step depends on this)
- `infrastructure/wrappers/mock-kubectl` — Phase 7 wrapper with HERMES_LAB_GOVERNANCE pre-flight. The L4 apply step in Phase 9 relies on this enforcement.
- `governance/governance-L4-track-c.yaml` — Phase 7 L4 allowlist for Track C. `kubectl apply` is in this allowlist (verify per planner).
- `agents/track-c-kubernetes/config.yaml` — Phase 7 populated with L2 baseline allowlist. Phase 9 spawned agent overrides via env var to L4.

### Phase 8 Reuse (trigger + approval depends on this)
- `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml` — Phase 8 PrometheusRule firing on crashloop2. Phase 9 reuses for the alert trigger.
- `infrastructure/scenarios/k8s/alertmanager/alertmanager-config.yaml` — Phase 8 AlertManager receiver config to host.docker.internal:8644. Phase 9 reuses.
- `infrastructure/scenarios/k8s/telegram-bot/bot-config.example.yaml` — Phase 8 Telegram bot config. Phase 9 lab walks through using this for approval messages.
- `infrastructure/scenarios/k8s/telegram-bot/admin-allowlist.example.yaml` — Phase 8 admin allowlist for `/approve` commands.
- `infrastructure/scenarios/k8s/github-webhook/` — Phase 8 GitHub webhook setup. Phase 9 Path B reuses for PR creation.
- `course-site/docs/module-12-triggers/lab/LAB.mdx` Steps 9-16 — Phase 8 lab demonstrating each trigger type. Phase 9 lab references these for setup prerequisites.

### Phase 1/3 Reuse (Path B GitOps)
- `reference-app/helm/` — Existing reference-app Helm chart. Phase 9 Path B helm upgrade fallback uses this as the deployment target.
- `course-site/docs/module-06-ai-iac/lab/` (or similar Phase 3 path) — Module 6 Track B ArgoCD content. Researcher confirms current Module 6 structure (renamed/restructured in Phase 5).
- ArgoCD installation script if it exists in `infrastructure/` — Researcher locates.

### Course Project & Requirements
- `.planning/PROJECT.md` — v1.1 Active requirements, Key Decisions, current state
- `.planning/REQUIREMENTS.md` §Multi-Agent Workflows + §Agent Productionization — FLEET-01, FLEET-02, PROD-01, PROD-02
- `.planning/ROADMAP.md` Phase 9 — 4 success criteria
- `.planning/phases/06-k8s-skills-agents/06-CONTEXT.md` — Phase 6 prior context
- `.planning/phases/07-guardrails-governance/07-CONTEXT.md` — Phase 7 prior context (governance enforcement)
- `.planning/phases/08-agent-triggers/08-CONTEXT.md` — Phase 8 prior context (trigger sources)
- `.planning/phases/08-agent-triggers/08-RESEARCH.md` — Phase 8 research (Telegram adapter exists, github_comment built-in, Hermes Dockerfile, smee.io status)
- `CLAUDE.md` — Course conventions

### External References (researcher verifies)
- **K8s Agent Sandbox** — https://github.com/kubernetes-sigs/agent-sandbox — Researcher confirms current release tag, install command, KIND v0.31 compatibility
- **ArgoCD on KIND** — Existing course content from Phase 1/3, researcher locates the install path
- **Hermes inter-agent delegation mechanism** — `/Users/gshah/work/agentic/devops/hermes-agent/gateway/` — Researcher confirms how Morgan spawns specialist agents and propagates env vars to them

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Morgan agent profile** — `agents/fleet-coordinator/SOUL.md` and `config.yaml` already exist with the right identity (delegate, never execute, anti-loop, sequential delegation). Phase 9 light-edits SOUL.md only.
- **cross-domain.md scenario fixture** — Existing fixture for Module 11 mock-mode lab. Phase 9 may update or reuse depending on researcher findings.
- **Phase 6 broken-pod scenarios** — All 6 scenario manifests in `infrastructure/scenarios/k8s/0[1-6]-*.yaml` are reusable. Phase 9 FLEET-01 demo specifically uses 02-crashloop-backoff.yaml.
- **Phase 7 wrapper enforcement** — `mock-kubectl`, `mock-aws`, `mock-psql` already enforce HERMES_LAB_GOVERNANCE per-tool allowlists. Phase 9 apply step inherits this enforcement universally (D-03).
- **Phase 8 AlertManager + Telegram + GitHub infrastructure** — All Phase 8 trigger infrastructure is reusable as the trigger + approval surface for FLEET-01.
- **reference-app Helm chart** — Phase 1 shipped this. Phase 9 Path B uses it as the deployment target for helm upgrade fallback.
- **Phase 4/6/7/8 Solo Learner callout pattern** — Reused for Module 11 lab rewrite to support Udemy learners.
- **Phase 7 D-05 export block pattern** — Every Phase 9 lab step shows the complete env var export block.

### Established Patterns
- **Lab extension over rewrite** — Phase 5/6/7/8 all extended existing modules. Phase 9 BREAKS this pattern for Module 11 because the existing mock-only lab needs to become live-primary (D-11). This is justified because the user explicitly chose "Replace mock with live entirely" — Morgan + specialist behavior fundamentally changes between mock and live mode.
- **Two-pattern teaching with diff** — Phase 7 (allowlist + DANGEROUS_PATTERNS), Phase 8 (Hermes cron vs K8s CronJob) both teach via comparison. Phase 9 follows the same pattern with Path A (direct apply) vs Path B (GitOps PR).
- **Per-track variants** — Phase 8 established per-track variants for slash commands and CronJob manifests. Phase 9 FLEET-01 demo focuses on Track C (since Phase 6 K8s scenarios are the trigger), but reading content references all three tracks.
- **HERMES_LAB_* env var convention** — Phase 9 adds GITOPS_REPO_URL and GITOPS_BRANCH_PREFIX (NOT HERMES_LAB_* prefixed because they're external service config like GITHUB_TOKEN, not lab control).
- **Two-mirror sync (course-site MDX + modules MD)** — Phase 7/8 pattern. Phase 9 follows for Module 11 if both mirrors exist.

### Integration Points
- **AlertManager → Hermes webhook gateway** — Phase 8 wired this. Phase 9 reuses without modification.
- **Hermes webhook gateway → Morgan invocation** — How exactly does Hermes spawn an agent run when a webhook fires? Researcher confirms whether `hermes webhook subscribe ... --profile fleet` works, or whether the webhook payload needs to be passed via env vars to a spawned subprocess.
- **Morgan → specialist delegation env var propagation** — Researcher verifies Hermes inter-agent delegation properly propagates HERMES_LAB_GOVERNANCE to spawned specialist agents. This is the load-bearing assumption for D-03.
- **Specialist apply → Phase 7 wrapper enforcement** — When the specialist runs `kubectl apply`, the wrapper checks HERMES_LAB_GOVERNANCE=L4 and the L4-track-c allowlist. If kubectl apply isn't in L4 allowlist, Phase 9 needs to add it (verify in Phase 7 governance/governance-L4-track-c.yaml).
- **Module 11 lab → Phase 6/7/8 prerequisites** — New live lab requires KIND running, Phase 6 scenarios applied, Phase 7 governance configured, Phase 8 AlertManager + Telegram operational. Lab Step 1 prerequisites checklist is critical.

</code_context>

<specifics>
## Specific Ideas

- **Morgan stays the centerpiece, not a new triage agent.** The "triage agent" wording in FLEET-01 was clarifying language for Morgan's first responsibility (triage → delegate → synthesize). Building a separate triage agent would add a 5th profile to maintain and complicate the lab. Morgan's existing identity already covers the triage step.

- **Telegram approval is the production-grade ChatOps pattern.** Real DevOps teams already use Slack/Teams approval workflows for high-risk actions. Phase 9 reuses Phase 8's Telegram bot infrastructure to demonstrate this in the lab. The /approve and /reject slash commands fit the same pattern as Phase 8's /diagnose, /status, /help.

- **Two apply paths is the right answer because not everyone runs ArgoCD.** Path A (direct kubectl apply at L4) works for any participant who can run KIND + Hermes. Path B (GitOps via PR) requires either Module 6 Track B completion (ArgoCD on KIND) OR the helm upgrade fallback script. Lab teaches BOTH so participants can choose based on their setup. The diff between A and B is the production teaching moment.

- **GitOps fallback via helm upgrade is a real production pattern too.** Not every team runs ArgoCD. Many run `helm upgrade` from a CI pipeline triggered on PR merge. Phase 9's apply.sh fallback honors this reality. Path B Sub-path B2 is not "the worse alternative" — it's "the lighter-weight production pattern".

- **K8s Agent Sandbox stays exploratory because alpha CRDs are too volatile for required content.** STATE.md flagged this. Phase 9 ships exploratory PROJECTS.mdx entry only — no required infrastructure files. If alpha v0.2.1 breaks before delivery, the exploratory entry can be updated quickly without invalidating committed lab content. This honors "deliver PROD-01" without committing to fragile infrastructure.

- **PROD-02 reading content goes in Module 11 because fleet IS the production-scale moment.** Module 11 is where participants see agents running at scale. Productionization is the natural answer to "how do I run this in production" — and Module 11 is where participants ask that question. Module 13 (governance) and Module 14 (capstone) are wrong homes because they're about different angles (safety, planning).

- **Module 11 lab REPLACE not extend is justified.** Phase 5/6/7/8 all extended their target modules. Phase 9 breaks the pattern for Module 11 because Morgan + specialist behavior fundamentally changes between mock-only and live mode — the existing 7-step mock walkthrough doesn't compose with the new live flow. User explicitly chose this. Solo Learner callouts inside the new live-primary lab preserve Udemy accessibility.

- **Phase 9 is the milestone close.** After Phase 9 ships and verifies, run /gsd:audit-uat for cross-phase verification debt, evolve PROJECT.md to "v1.1 complete", then run /gsd:complete-milestone. Phases 5-9 form the complete v1.1 cycle.

</specifics>

<deferred>
## Deferred Ideas

### v1.2 candidates
- **Separate triage agent** — Building a dedicated lightweight triage agent (faster classifier than Morgan, single-domain routing) is a v1.2 architectural exploration. Phase 9 keeps Morgan as the entry point.
- **GitOps-only apply (no direct path)** — If v1.2 deepens Module 6 Track B requirements, Phase 9's Path A (direct apply) could be deprecated in favor of GitOps-only. Currently both paths shipped because direct apply has accessibility advantages.
- **Real production K8s Agent Sandbox lab** — Once Sandbox CRDs reach beta/stable, Phase 9's exploratory entry can be promoted to a required GUIDED step. v1.2+ candidate.
- **Multi-cluster fleet coordination** — Morgan currently delegates to specialists in the same cluster. Multi-cluster federation (one Morgan, specialists in different clusters) is a v1.2 exploration.
- **Approval state machine with timeout/retry** — Currently Telegram approval is fire-and-forget (Morgan posts proposal, waits indefinitely). v1.2 could add an approval state machine with timeouts, escalation, retry policies.
- **Audit log export to SIEM** — Phase 7 governance audit logs + Phase 9 fleet workflow logs could export to a SIEM-compatible format. v1.2 production deepening.
- **Morgan delegation parallelism** — Currently sequential per SOUL.md. Phase 9 keeps sequential. v1.2 could explore parallel delegation patterns with conflict resolution.
- **Cross-domain incident replay** — Recording an incident chain and replaying it for training/regression. v1.2 feature.
- **Agent Sandbox + Module 11 fleet integration** — Running Morgan + specialists inside Sandbox CRDs as production deployment. Combines D-15 with FLEET-01. v1.2 if Sandbox stabilizes.

### Out of scope for v1.1 entirely
- **Advanced GitOps patterns** — Multi-environment (dev/staging/prod), promotion workflows, drift detection. Module 6 Track B touched on basics, Phase 9 Path B uses ArgoCD/helm minimally. Deeper GitOps is its own course.
- **Slack chat ops as bidirectional approval surface** — Phase 8 documented Slack as production-reference only (admin barrier). Phase 9 inherits this; Slack stays demo-only, Telegram is the hands-on path.
- **K8s native operators for agent management** — Building a custom K8s operator for Hermes agent lifecycle. Sandbox covers this conceptually; building one is beyond v1.1.

</deferred>

---

*Phase: 09-multi-agent-workflows-production*
*Context gathered: 2026-04-07*
