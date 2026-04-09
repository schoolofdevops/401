---
gsd_state_version: 1.0
milestone: v1.1
milestone_name: Realistic Agents & Production Workflows
status: Milestone complete
stopped_at: Completed 10-04-PLAN.md — SETUP.mdx refactor (remove mock-mode aliases and env vars)
last_updated: "2026-04-09T15:10:23.541Z"
progress:
  total_phases: 6
  completed_phases: 5
  total_plans: 19
  completed_plans: 18
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-07)

**Core value:** DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering is THE skill that makes agents useful.
**Current focus:** Phase 9 — multi-agent-workflows-production

## Current Position

Phase: 9
Plan: Not started

## Performance Metrics

**Velocity:**

- Total plans completed: 0
- Average duration: -
- Total execution time: 0.0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| - | - | - | - |

**Recent Trend:**

- Last 5 plans: none yet (v1.1)
- Trend: -

*Updated after each plan completion*
| Phase 01 P02 | 3 | 2 tasks | 5 files |
| Phase 01-foundation P01 | 11 | 2 tasks | 13 files |
| Phase 01-foundation P03 | 8min | 3 tasks | 30 files |
| Phase 01-foundation P04 | 6min | 3 tasks | 3 files |
| Phase 02-day-1-modules P01 | 12 | 2 tasks | 31 files |
| Phase 02-day-1-modules P02 | 7min | 2 tasks | 4 files |
| Phase 02-day-1-modules P03 | 13 | 3 tasks | 16 files |
| Phase 03-day-2-modules P02 | 20min | 2 tasks | 6 files |
| Phase 03-day-2-modules P01 | 20min | 2 tasks | 5 files |
| Phase 03-day-2-modules P04 | 17min | 2 tasks | 21 files |
| Phase 03-day-2-modules P05 | 15min | 2 tasks | 7 files |
| Phase 03-day-2-modules P03 | 20min | 2 tasks | 10 files |
| Phase 04-remaining-content P01 | 25 | 2 tasks | 22 files |
| Phase 04-remaining-content P02 | 60min | 2 tasks | 72 files |
| Phase 04-remaining-content P03 | 10 | 2 tasks | 6 files |
| Phase 05-module-consolidation P01 | 5 | 2 tasks | 60 files |
| Phase 05-module-consolidation P02 | 4 | 2 tasks | 2 files |
| Phase 05-module-consolidation P03 | 7 | 2 tasks | 5 files |
| Phase 06-k8s-skills-agents P01 | 5min | 2 tasks | 4 files |
| Phase 06-k8s-skills-agents P02 | 10 | 2 tasks | 28 files |
| Phase 06-k8s-skills-agents P03 | 15min | 2 tasks | 13 files |
| Phase 07-guardrails-governance P02 | 10min | 2 tasks | 13 files |
| Phase 07-guardrails-governance P01 | 60 | 2 tasks | 9 files |
| Phase 07-guardrails-governance P03 | 13 | 3 tasks | 4 files |
| Phase 08 P02 | 5 | 2 tasks | 8 files |
| Phase 08-agent-triggers P01 | 7min | 2 tasks | 8 files |
| Phase 08-agent-triggers P03 | 10min | 2 tasks | 4 files |
| Phase 09-multi-agent-workflows-production P01 | 4 | 3 tasks | 8 files |
| Phase 09-multi-agent-workflows-production P02 | 12 | 3 tasks | 5 files |
| Phase 10 P03 | 2min | 1 tasks | 1 files |
| Phase 10 P04 | 3min | 1 tasks | 1 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- [Roadmap]: Labs-first strategy confirmed — every module: LAB.md + starter/solution before reading or quiz
- [Roadmap]: FOUND-01 through FOUND-04 (reference app, Helm chart, CI/CD, ArgoCD) all land in Phase 1 because they are prerequisites for Module 5 and 6 labs
- [Roadmap]: OpenCode replaced by Crush (charmbracelet/crush) everywhere — OpenCode archived Sept 18, 2025
- [Roadmap]: LocalStack treated as optional stretch only — community edition EOL'd March 2026
- [Phase 01]: _metadata pattern established for mock JSON files: source, format_date, aws_cli_version, note fields required
- [Phase 01]: Banner output moved to stderr in mock-aws — diagnostic output belongs on stderr so stdout JSON is pipeable
- [Phase 01]: EC2 mock data given own ec2/ directory instead of cost-explorer/ for service-based organization
- [Phase 01-foundation]: Runtime sqlx::query (not macros) chosen to avoid DATABASE_URL at compile time — lower setup friction for course
- [Phase 01-foundation]: axum 0.8 path syntax is {id} not :id — updated in catalog route
- [Phase 01-foundation]: PgPool::connect_lazy for unit test fake pools — services testable without live database
- [Phase 01-foundation]: No ArgoCD in CI/CD — pipeline does direct helm upgrade; GitOps taught conceptually in later modules (D-06)
- [Phase 01-foundation]: Svelte 5 runes pattern: polling in $effect with cleanup, AbortSignal.timeout(3000) mandatory for health dashboard
- [Phase 01-foundation]: nginx proxy pattern: /api-gateway/*, /catalog/*, /worker/* map to K8s service DNS hostnames
- [Phase 01-foundation]: D-14 honored: Claude Code and OpenCode documented as two equal paths in SETUP.md, verify.sh, and llm-access.md
- [Phase 01-foundation]: D-15 honored: OpenCode refers to sst/opencode from opencode.ai, not archived opencode-ai/opencode
- [Phase 01-foundation]: D-08 honored: Datadog free tier documented as optional alternative observability in SETUP.md Step 7
- [Phase 01-foundation]: January 2026 Anthropic OAuth block documented in SETUP.md and llm-access.md per ROADMAP success criteria 4
- [Phase 02-01]: Used TypeScript config (.ts not .js) for Docusaurus — generated by create-docusaurus --typescript, functionally equivalent
- [Phase 02-01]: routeBasePath: '/' confirmed — docs served at site root, no /docs/ prefix for course website UX
- [Phase 02-01]: Autogenerated sidebar with _category_.json chosen over manual sidebars.ts for 14+ module maintainability
- [Phase 02-day-1-modules]: context engineering vocabulary enforced from Module 1 — 'prompt engineering' appears only in negation/contrast throughout reading and quiz content
- [Phase 02-day-1-modules]: 4-layer context pattern (Task/Role/System/Procedure) established as the course-wide reusable framework for all DevOps AI scenarios
- [Phase 02-day-1-modules]: MDX cross-links use document id (e.g., ./module-01-reference) not relative path — required to avoid Docusaurus broken link warnings
- [Phase 02-03]: MDX < character in .md starter files causes parse errors — use prose substitution (e.g., 'under 5min' not '<5min')
- [Phase 02-03]: Module 3 Hermes install URL uses NousResearch/hermes-agent — verify URL is live before Day 1 delivery
- [Phase 03-day-2-modules]: Module 5b composite lab: single LAB.mdx with 4 timed sections chosen over separate files — GSD workflow is the centerpiece (30 min Section 1)
- [Phase 03-day-2-modules]: WorkerHeartbeatMissing alert documented as postgres-exporter stretch — not functional in base install, teaches the pattern honestly
- [Phase 03-day-2-modules]: claude-mem and Crush MCP memory as parallel paths in Section 3 — participants follow one based on tool choice
- [Phase 03-day-2-modules]: Track A/B labs use gap analysis (Step 0) before AI — establishes baseline understanding before guided generation
- [Phase 03-day-2-modules]: 5-phase structured workflow pattern (Brainstorm/Design/Blueprint/Implement/Validate) established for all Module 5a IaC lab content
- [Phase 03-day-2-modules]: D-41 honored in Module 6: No Track C (Argo Workflows) content — descoped per plan, README.mdx names the descoping explicitly
- [Phase 03-day-2-modules]: mock_provider chosen over LocalStack for Track A fallback — LocalStack community EOL March 2026, mock_provider built into Terraform 1.7+
- [Phase 03-day-2-modules]: ArgoCD memory patches mandatory in setup-argocd.sh — pitfall 2 prevention: standard install requests 1.3GB total, causes OOM on laptop KIND clusters
- [Phase 03-day-2-modules]: Renamed 'Context Engineering vs Prompt Engineering' heading to avoid prohibited phrase while preserving contrast concept
- [Phase 03-day-2-modules]: Labs-first strategy executed: Module 5a/5b reading content derived directly from lab content — concepts explain why the lab worked
- [Phase 03-day-2-modules]: Quiz answers include explanation rationale for Udemy self-paced learners — the explanation block is the teaching moment without an instructor
- [Phase 04-remaining-content]: Module 9 position 10 / Module 14 position 15 — sequential sidebar positions for modules 7-14
- [Phase 04-remaining-content]: Capstone subdirectory in Module 14 at position 1 (primary content before reading) — capstone templates are the main deliverable
- [Phase 04-remaining-content]: Solo Learner callouts in four Module 14 files (README, PRESENTATION, ROADMAP, RUBRIC) for Udemy self-paced learners
- [Phase 04-remaining-content]: L5 fully autonomous excluded from course — governance reasoning: L4 alerting/intervention is a hard safety requirement for infra ops
- [Phase 04-remaining-content]: Module 11 solo learner callout added as :::info block — fleet lab adaptation for self-paced Udemy learners documented per STATE.md blocker
- [Phase 04-remaining-content]: All module reading content derived from HANDOFF.md Layer 3-5 concept tables as THE checklist — zero HANDOFF concepts omitted
- [Phase 04-remaining-content]: Zero 'prompt engineering' as positive term across all 7 new modules — context engineering used throughout
- [Phase 04-remaining-content]: Instructor guides at project root instructor/ (not inside Docusaurus) — trainer tools not accidentally published to participant site
- [Phase 04-remaining-content]: Module 7 contrast/negation uses of prompt engineering are pedagogically intentional — zero positive uses across all content is the requirement, and it is met
- [Phase 04-remaining-content]: Udemy uses 15 sections for 14 modules — Module 5a and 5b separate into sections 5 and 6 for self-paced pacing
- [v1.1 Roadmap]: Phase 5 (Module Consolidation) runs first — must restructure Modules 5/6 before K8s skill work, since CONS-03 moves IaC content into Module 5 as Superpowers domain context
- [v1.1 Roadmap]: GOV (Guardrails) placed in Phase 7 after K8s skills — allowlists reference K8s commands from K8S-01 through K8S-04, so skills must exist before governance demos work
- [v1.1 Roadmap]: TRIG depends on Phase 6 working agents — triggers invoke agents; agents must exist and work before trigger wiring makes sense
- [v1.1 Roadmap]: Phase 9 (Multi-Agent + Production) depends on both Phase 7 and Phase 8 — FLEET-01 end-to-end chain requires working guardrails and at least one trigger (AlertManager)
- [v1.1 Roadmap]: PROD-01 (K8s Agent Sandbox) marked exploratory in requirements — stays in Phase 9 as exploratory content, not required lab
- [Phase 05]: module-05-superpowers-iac scaffold only in Plan 01 — content authored in Plan 02; Terraform solution files from old module-06-ai-iac are Track B reference, migrated verbatim
- [Phase 05]: Docusaurus doc ID naming: module-06-ai-workflow-tools/module-06-readme (directory prefix + slug, no a/b suffixes)
- [Phase 05-module-consolidation]: Context-first starter pattern: CLAUDE.md with system state, gaps, constraints is the starter for Superpowers IaC labs — no pre-written code skeletons needed
- [Phase 05-module-consolidation]: CLAUDE.md vocabulary encoding: including exact AWS attribute names in Architecture section pre-corrects most common AI Terraform generation errors before code generation begins
- [Phase 05-module-consolidation]: Helm TDD uses existing toolchain (helm lint + kubectl dry-run) — no additional test frameworks, reduces setup friction for participants
- [Phase 05]: Reading content derived from labs (labs-first): concepts.mdx uses exact errors and tools from Track A/B labs
- [Phase 05]: Exploratory PROJECTS.mdx absorbs ArgoCD GitOps and CI/CD pipeline content from old modules as optional stretch work per D-03
- [Phase 05]: Quiz explanation rationale in <details> block is the teaching moment for Udemy self-paced learners — WHY correct and WHY alternatives are wrong
- [Phase 06-k8s-skills-agents]: sre-k8s-pod-health is 287 lines mirroring EC2 skill structure — 7 decision branches (6 K8S-02 failure modes + no-issue branch)
- [Phase 06-k8s-skills-agents]: Scaffold Phase 2 uses HTML comment blocks for PARTICIPANT EXTENSION POINT markers — grep-discoverable, not rendered in previews, consistent pattern for Module 7 lab
- [Phase 06-k8s-skills-agents]: OOM scenario uses python:3.12-alpine bytearray(64MB) not busybox dd — arm64/macOS Docker does not reliably trigger cgroup OOM kill with I/O-bound dd
- [Phase 06-k8s-skills-agents]: CrashLoop mock SCENARIO name is crashloop2 not crashloop — avoids collision with Module 10 existing lab (RESEARCH Pitfall 5)
- [Phase 06-k8s-skills-agents]: K8S-02 mock files hand-authored (KIND not in agent env) — capture-mock-data.sh is canonical re-capture workflow for course delivery prep
- [Phase 06-k8s-skills-agents]: SOUL.md light-edit (D-16): 3 changes only — skill reference paragraph, kubectl exec NEVER rule, expanded Escalation Policy with 6 K8S-02 failure modes. Result: 42 lines (was 31, max 80).
- [Phase 06-k8s-skills-agents]: command_allowlist: [] preserved in both config.yaml files (D-17 — Phase 7 territory).
- [Phase 06-k8s-skills-agents]: D-20 cascade verified: zero sre-ec2-health-check references in K8s/Kiran/Track C contexts. Canonical root EC2 skill preserved for Track B.
- [Phase 07-guardrails-governance]: Track A Challenge 3 restructured: two-allowlist section leads, then L3 promotion instructions follow — teaches mechanism before showing the action
- [Phase 07-guardrails-governance]: command_allowlist: [] preserved unchanged in all 9 configs (Hermes-native bypass key; Phase 7 adds wrapper_allowlist alongside it)
- [Phase 07-guardrails-governance]: Track C Module 10 lab confirmed no-op: zero command_allowlist/wrapper_allowlist refs in both Track C lab files
- [Phase 07-01]: PATH B wrapper extension confirmed (D-01): Hermes DANGEROUS_PATTERNS is hardcoded Python, no extension hook exists — wrapper pre-flight is the only course-local mechanism
- [Phase 07-01]: wrapper_allowlist is a NEW yaml key (not command_allowlist): Hermes-native command_allowlist: [] preserved untouched; wrapper reads only wrapper_allowlist
- [Phase 07-01]: awk-based YAML parser chosen for wrapper allowlist extraction: avoids yq v3/v4 version mismatch; wrapper code stays readable as teaching material
- [Phase 07-03]: Verification checklist check 8 uses mock-kubectl directly (wrapper named mock-kubectl not kubectl, no symlink in wrappers/)
- [Phase 07-03]: SOUL.md is load-bearing narrative preserved and extended for Track B/C: Phase 7 Layer 1 adds mechanical defense but SOUL.md remains the sole protection for novel commands
- [Phase 08]: smee-client pinned at v5.0.0 via npx for TRIG-03 (no global install required)
- [Phase 08]: Telegram long-polling confirmed as lab default (BLOCKER-01 resolved — adapter exists in gateway/platforms/telegram.py)
- [Phase 08-agent-triggers]: AlertManager receiver URL uses host.docker.internal:8644 — works on macOS Docker Desktop natively; Linux needs extraPortMapping (added to cluster-config.yaml)
- [Phase 08-agent-triggers]: PrometheusRule must have release: kube-prometheus label for kube-prometheus-stack ruleSelector auto-discovery
- [Phase 08-agent-triggers]: K8s CronJob image built from python:3.12-slim + hermes-agent[messaging,cron] from GitHub source (not official 2-3GB image)
- [Phase 08-agent-triggers]: Hermes prompt template uses {alerts} full array not array index — _render_prompt does not support {alerts[0]} notation
- [Phase 08-agent-triggers]: Steps 9-16 inserted before FREE EXPLORE per D-21; all 4 trigger types (AlertManager, K8s CronJob, GitHub webhook, Telegram bot) now have participant-facing guided walkthroughs
- [Phase 09-multi-agent-workflows-production]: D-13 toolset fix: terminal added to Morgan config.yaml for Hermes delegation inheritance (belt) + NEVER rule added to SOUL.md prohibiting direct terminal use (suspenders)
- [Phase 09-multi-agent-workflows-production]: D-07 Path B: Sub-path B2 (apply.sh) is the ONLY implementable Path B mechanism — ArgoCD install infrastructure does not exist in course repo
- [Phase 09-multi-agent-workflows-production]: D-11 honored: Module 11 lab REPLACED not extended — live-primary 11-step FLEET-01 walkthrough replaces 7-step mock-only flow
- [Phase 09-multi-agent-workflows-production]: BLOCKER-01 resolved: gh pr create used via terminal toolset directly — no fictional --deliver github_pr flag; documented in Step 10
- [Phase 09-multi-agent-workflows-production]: D-23: Phase 9 Plan 02 is the final v1.1 content deliverable — milestone ready for /gsd:audit-uat and /gsd:complete-milestone
- [Phase 10]: OPTION 1 chosen: Track C removed from Module 10 entirely (not repositioned as optional) for cleaner learner pathway
- [Phase 10]: SETUP.mdx mock-mode removal: 194 lines removed, replaced with 12-line KIND cluster check for Track C

### Pending Todos

None yet.

### Blockers/Concerns

- [Phase 6] kube-troublesim version and KIND compatibility — verify kube-troublesim works on KIND v0.31 before building lab content
- [Phase 8] Chat bot trigger (TRIG-04) requires Telegram or Slack API access — confirm which is feasible on free tier before designing the lab
- [Phase 9] K8s Agent Sandbox CRDs (PROD-01) are alpha v0.2.1 — may change; treat as exploratory and pin to a specific release

### Quick Tasks Completed

| # | Description | Date | Commit | Directory |
|---|-------------|------|--------|-----------|
| 260407-vyg | Fix Hermes profile install instructions across all agent configs and lab files | 2026-04-07 | 9c24d6c | [260407-vyg-fix-hermes-profile-install-instructions-](./quick/260407-vyg-fix-hermes-profile-install-instructions-/) |
| 260408-sem | Create Track C-specific labs for Modules 7 & 8; fix Module 10 Track C Step 2 to preserve Module 8 profile | 2026-04-08 | 7a61b4c | [260408-sem-fix-module-10-track-c-lab-step-2-to-not-](./quick/260408-sem-fix-module-10-track-c-lab-step-2-to-not-/) |
| 260408-tbd | Create Module 13 Track C governance lab (1257 lines) with kubectl-first examples and SOUL.md-NEVER teaching emphasis | 2026-04-08 | 6b1d59c | [260408-tbd-create-module-13-track-c-governance-lab-](./quick/260408-tbd-create-module-13-track-c-governance-lab-/) |
| 260408-ueh | Fix mock-kubectl/aws/psql wrappers not being invoked via PATH — add kubectl/aws/psql symlinks, fix live-mode passthrough to avoid infinite loop, update lab instructions across Modules 7/8/10/13 | 2026-04-08 | 00df613 | [260408-ueh-fix-mock-kubectl-wrapper-not-being-invok](./quick/260408-ueh-fix-mock-kubectl-wrapper-not-being-invok/) |
| 260408-v6c | Fix Hermes bash -lic PATH rewrite by adding kubectl/aws/psql aliases in ~/.bash_profile; add cross-platform (Mac/Linux/WSL2/Git Bash) setup docs; update Track C labs 7/8/10/13 to export HERMES_LAB_WRAPPERS | 2026-04-08 | f67787b | [260408-v6c-fix-hermes-tool-path-by-adding-kubectl-a](./quick/260408-v6c-fix-hermes-tool-path-by-adding-kubectl-a/) |
| 260408-x42 | Fix Module 12 `hermes cron create` flag-form syntax bug (schedule/prompt are positional, not flags) — rewrote 6 lab invocations + starter yaml + Module 14 ROADMAP template | 2026-04-08 | 6f6f1ee | [260408-x42-fix-module-12-hermes-cron-create-flag-sy](./quick/260408-x42-fix-module-12-hermes-cron-create-flag-sy/) |
| 260409-axw | Fix Module 7 README stale track naming (SRE/DevOps/DBA → Track A/B/C/D) and wrong lab location ("Hermes repo" → local course-site) | 2026-04-09 | 0e2a425 | [260409-axw-fix-module-7-readme-stale-track-naming-a](./quick/260409-axw-fix-module-7-readme-stale-track-naming-a/) |

## Session Continuity

Last session: 2026-04-09T15:10:23.538Z
Stopped at: Completed 10-04-PLAN.md — SETUP.mdx refactor (remove mock-mode aliases and env vars)
Resume file: None
