# Roadmap: Agentic DevOps Course

## Milestones

- ✅ **v1.0 Course Launch** — 14 modules complete, 3-day workshop ready (shipped 2026-04-07)
  - [Details](milestones/v1.0-ROADMAP.md)
- 🚧 **v1.1 Realistic Agents & Production Workflows** — Phases 5-9 (in progress)

## Phases

<details>
<summary>✅ v1.0 Course Launch (Phases 1-4) — SHIPPED 2026-04-07</summary>

- [x] **Phase 1: Foundation** - Reference app, setup guides, deployment infrastructure (4/4 plans)
- [x] **Phase 2: Day 1 Modules** - AI Foundations, Platform AI, Bridge, Impact Assessment (3/3 plans)
- [x] **Phase 3: Day 2 Modules** - Structured Coding, AI-Assisted IaC (5/5 plans)
- [x] **Phase 4: Remaining Content** - Instructor guides, Udemy outline, all module content (3/3 plans)

**Key deliverables:** 14 modules with labs, reading, quizzes; reference Rust app with Svelte dashboard; instructor guides for 3-day delivery; Udemy section outline.

**Details:** See [milestones/v1.0-ROADMAP.md](milestones/v1.0-ROADMAP.md)

</details>

### 🚧 v1.1 Realistic Agents & Production Workflows (In Progress)

**Milestone Goal:** Rebuild modules 5-13 with working K8s-first agents, real skills, Superpowers integration, agent triggers, and production deployment patterns.

- [x] **Phase 5: Module Consolidation** - Restructure Modules 5 and 6 with Superpowers as centerpiece for IaC work (completed 2026-04-07)
- [x] **Phase 6: K8s Skills & Agents** - Build real K8s diagnostic skills and rebuild Track C agents for KIND (completed 2026-04-07)
- [x] **Phase 7: Guardrails & Governance** - Add command allowlists, per-track configs, and L1-L4 progression demo (completed 2026-04-07)
- [x] **Phase 8: Agent Triggers** - Implement AlertManager, CronJob, GitHub, and chat bot trigger patterns (completed 2026-04-07)
- [x] **Phase 9: Multi-Agent Workflows & Production** - End-to-end fleet workflows and K8s Agent Sandbox (completed 2026-04-07)

## Phase Details

### Phase 5: Module Consolidation
**Goal**: Modules 5 and 6 are restructured so participants experience Superpowers (TDD, debugging, verification, code review) applied directly to IaC domains — not as abstract exercises
**Depends on**: Phase 4 (v1.0 complete)
**Requirements**: CONS-01, CONS-02, CONS-03, CONS-04
**Success Criteria** (what must be TRUE):
  1. A participant opening Module 5 finds Superpowers workflows (brainstorm, TDD, verification, debugging, code review) applied to Terraform, Helm, and GitOps tracks — not generic coding exercises
  2. A participant opening Module 6 finds the AI Workflow Tools content (GSD, CLAUDE.md, claude-mem, plan modes) with updated naming and module numbering
  3. All IaC project material from the old Module 6 (Terraform, Helm, ArgoCD) is present in Module 5 as domain context for Superpowers exercises
  4. Reading materials and quizzes for Module 5 and 6 reference the restructured content — no stale references to old module names or old module 6 IaC-as-primary content
**Plans:** 3/3 plans complete
Plans:
- [x] 05-01-PLAN.md — Directory restructure: rename module-05b to module-06, scaffold new module-05, migrate solution files, delete old dirs, update all cross-references
- [x] 05-02-PLAN.md — Lab content authoring: Track A (Helm Superpowers 90 min) and Track B (Terraform Superpowers 90 min)
- [x] 05-03-PLAN.md — Supporting content: README, reading (concepts + reference), quiz (7 questions), exploratory projects (ArgoCD, CI/CD, second track)

### Phase 6: K8s Skills & Agents
**Goal**: The K8s diagnostic track has real, working skills and a properly configured agent (Kiran) connected to a live KIND cluster — EC2 skill references eliminated
**Depends on**: Phase 5
**Requirements**: K8S-01, K8S-02, K8S-03, K8S-04, K8S-05
**Success Criteria** (what must be TRUE):
  1. Participant opening Track C sees a K8s diagnostic SKILL.md with working kubectl commands (get pods, describe pod, logs, top) — zero EC2 commands in the skill file
  2. Participant running the kube-troublesim lab exercises on KIND encounters all 6 broken pod scenarios (ImagePullBackOff, CrashLoopBackOff, resource limits, liveness probe, missing secret, port mismatch) and can trigger agent diagnosis against each
  3. The Track C agent (Kiran) loads with the K8s diagnostic skill, connects to a live KIND cluster, and returns meaningful diagnosis output — not an EC2 health check
  4. Module 7 Track C starter and solution files contain K8s skill content — opening either file shows kubectl-based diagnostics, not EC2 health checks
  5. Additional K8s skills (node health check, resource quota analysis, deployment rollback investigation) are available as starter files for participant extension
**Plans:** 3/3 plans complete
**UI hint**: no
Plans:
- [x] 06-01-PLAN.md — Author primary sre-k8s-pod-health skill (full depth, 6 decision branches) + 3 starter scaffold addons (node-health, resource-quota, rollback-investigator)
- [x] 06-02-PLAN.md — Build infrastructure: 6 baked KIND scenario manifests, 6 sibling scenario docs, mock-kubectl extension for 6 new SCENARIOs, capture-mock-data.sh, 13 mock data parity files
- [x] 06-03-PLAN.md — Cascade: install K8s skill into Kiran profiles, light-edit SOUL.md, replace Module 7/10 solution files, update 6 cascade files (lab MDX, reading guides, resources, exploratory)

### Phase 7: Guardrails & Governance
**Goal**: Hermes governance configs demonstrate real operational safety with populated command allowlists — participants can observe what happens when a blocked command is attempted
**Depends on**: Phase 6
**Requirements**: GOV-01, GOV-02, GOV-03
**Success Criteria** (what must be TRUE):
  1. Participant running a Hermes agent with Module 10 or 13 config finds kubectl get, describe, and logs in the allowlist and kubectl delete, drain, and exec blocked — attempting a blocked command produces a governance rejection, not silent execution
  2. Each domain track (K8s, Database, FinOps) has a separate governance config file with domain-appropriate allowlists — a FinOps agent cannot issue kubectl commands, a K8s agent cannot run database mutations
  3. A participant following the L1 through L4 walkthrough can observe the allowlist growing at each trust level — L1 has read-only kubectl, L4 adds write operations with human-approval gate — the progression is shown in config diffs
**Plans:** 3/3 plans complete
Plans:
- [x] 07-01-PLAN.md — Wrapper extension + governance YAML population (3 wrappers + 6 governance files with wrapper_allowlist)
- [x] 07-02-PLAN.md — Agent profile config update + Module 10 cascade (3 profile configs + Module 10 lab text updates)
- [x] 07-03-PLAN.md — Module 13 lab extension + reading update (4 new L4 steps + reference.mdx + quiz)

### Phase 8: Agent Triggers
**Goal**: Participants can wire an agent to four external trigger sources and observe automated agent invocation — not just manual CLI execution
**Depends on**: Phase 6
**Requirements**: TRIG-01, TRIG-02, TRIG-03, TRIG-04
**Success Criteria** (what must be TRUE):
  1. Participant following the AlertManager lab fires a synthetic alert from Prometheus stack on KIND and observes the triage agent receiving the webhook and producing a diagnosis of the affected pod
  2. Participant applying the CronJob manifest to KIND observes the scheduled agent running on interval, completing a health check, and writing a status report — without any manual invocation
  3. Participant sending a GitHub webhook event (or using the PR review bot pattern) observes the agent receiving the event and producing a review comment or summary output
  4. Participant following the chat bot lab sends a slash command via Telegram or Slack and receives an agent response posted back to the channel — full round-trip without terminal interaction
**Plans:** 3/3 plans complete
Plans:
- [x] 08-01-PLAN.md — TRIG-01 + TRIG-02 KIND infrastructure: AlertManager helm/PrometheusRule/receiver, K8s CronJob Dockerfile + per-track manifests
- [x] 08-02-PLAN.md — TRIG-03 + TRIG-04 external services infrastructure: GitHub webhook (smee.io setup, sample payload, prompt template), Telegram bot (config, admin allowlist, slash command spec)
- [x] 08-03-PLAN.md — Module 12 lab extension (8 new GUIDED steps in both LAB.mdx + LAB.md mirrors), reading reference comparison table + Phase 8 env var docs, 3 new quiz questions

### Phase 9: Multi-Agent Workflows & Production
**Goal**: Participants witness an end-to-end automated incident response chain and can deploy an agent into a K8s sandbox — moving from demo to production-ready patterns
**Depends on**: Phase 7, Phase 8
**Requirements**: FLEET-01, FLEET-02, PROD-01, PROD-02
**Success Criteria** (what must be TRUE):
  1. Participant triggering a synthetic alert observes the full workflow chain: AlertManager fires, triage agent classifies, diagnostic agent investigates with K8s skills, proposal agent outputs a fix recommendation, participant approves, and the agent applies the fix — each agent handoff is visible in logs
  2. The fleet coordinator agent (Morgan) synthesizes inputs from two or more working specialist agents and produces a cross-domain incident summary — not a placeholder stub
  3. Participant following the K8s Agent Sandbox lab installs the Sandbox CRDs on KIND, deploys an agent in sandbox mode, and observes isolation — the agent cannot access resources outside its namespace boundary
  4. Conceptual reading on agent productionization covers packaging, deployment, monitoring, and scaling patterns with real Hermes config examples — not generic cloud theory
**Plans:** 2/2 plans complete
Plans:
- [x] 09-01-PLAN.md — FLEET-01 infrastructure: Morgan profile (config.yaml toolset fix + SOUL.md additions per D-13), GitOps Path B Sub-path B2 (apply.sh + memory-patch.yaml + README + repo template), fleet-webhook-subscribe.sh wiring AlertManager to Morgan
- [x] 09-02-PLAN.md — Module 11 lab REPLACE (both mirrors, 11-step live-primary FLEET-01 walkthrough), PROD-02 productionization reference section (~500-800 lines), K8s Agent Sandbox exploratory project (v0.2.1 pinned), 3 new quiz questions

### Phase 10: Labs 7-8 Real KIND Refactor & Consolidation
**Goal**: Remove mock-mode abstraction and infrastructure/wrappers complexity; consolidate Labs 8 & 10 into single BUILD-AND-TEST lab using real KIND cluster
**Depends on**: Phase 6 (K8s diagnostic skills)
**Requirements**: LAB-01, LAB-02, LAB-03, LAB-04, LAB-05
**Success Criteria** (what must be TRUE):
  1. Module 7 Track C lab author writes SKILL.md against real KIND cluster with no mock-kubectl wrapper — zero HERMES_LAB_MODE environment variable setup, zero ~/.bash_profile alias block requirement
  2. Module 8 Track C lab (consolidated with former Module 10) has single 90-min BUILD-AND-TEST structure: Phase 1 configure (20 min) → Phase 2 test-clean (15 min) → Phase 3 test-failures (30 min) → Phase 4 report (10 min) → Phase 5 safety (5 min)
  3. Lab failure scenarios are applied **during the lab** via `kubectl apply infrastructure/scenarios/k8s/0[1-6]-*.yaml` — learners create their own broken pods, not pre-baked fixtures
  4. Setup documentation (SETUP.md) removes all references to `HERMES_LAB_MODE`, `HERMES_LAB_SCENARIO`, wrapper env vars, and ~/.bash_profile alias block — just "verify KIND is running"
  5. infrastructure/wrappers/ and infrastructure/mock-data/ directories are archived (kept for reference) but removed from critical path; labs do not depend on them for Track C
**Plans:** 5/5 plans complete
Plans:
- [x] 10-01-PLAN.md — Module 7 Track C LAB.mdx refactor: remove mock env vars, add `kubectl apply scenario manifests` instructions, simplify prerequisites
- [x] 10-02-PLAN.md — Module 8 Track C lab consolidation: merge LAB.mdx + former LAB-track-c-kubernetes.mdx from Module 10, restructure into 5-phase BUILD-AND-TEST flow
- [x] 10-03-PLAN.md — Module 10 Track C decision: remove entirely (testing now in Module 8) OR reposition as optional "Advanced Optimization" exploratory project
- [x] 10-04-PLAN.md — SETUP.md refactor: remove mock-mode aliases, simplify to KIND-only prereq check, remove wrapper scripts from critical path
- [x] 10-05-PLAN.md — Infrastructure cleanup & documentation: archive mock-data/, wrappers/ with "deprecated but kept for reference" note; verify all course labs still work

### Phase 11: Module 11↔12 Swap — Rename Triggers Before Fleet
**Goal**: Rename current Module 12 (Triggers) to Module 11 and current Module 11 (Fleet) to Module 12 so learners set up trigger infrastructure before using it in fleet orchestration
**Depends on**: Phase 10
**Requirements**: SWAP-01, SWAP-02
**Success Criteria** (what must be TRUE):
  1. Directory `module-11-triggers` exists (formerly module-12-triggers), directory `module-12-fleet` exists (formerly module-11-fleet) — old directories removed
  2. All `_category_.json` sidebar positions updated: triggers=11, fleet=12
  3. All cross-references in Modules 7-14, setup.mdx, and CLAUDE.md use the new numbering — zero references to "Module 11" meaning fleet or "Module 12" meaning triggers
  4. Module 12 (Fleet) prerequisites updated to require Module 11 (Triggers) — not the old Module 10
  5. README.mdx titles, lab references, and reading materials reflect correct module numbers
**Plans:** 1/2 plans executed
Plans:
- [x] 11-01-PLAN.md — Directory swap (git mv via temp) + internal content updates (frontmatter IDs, titles, _category_.json, prerequisites, Day/Session numbers)
- [ ] 11-02-PLAN.md — Cross-reference updates in Modules 1, 4, 8, 10, 14, resources, intro.mdx, and CLAUDE.md tool split table

### Phase 12: New Module 11 Track C Triggers Lab
**Goal**: Create a dedicated Track C triggers lab for the renamed Module 11 (Triggers) that uses real KIND infrastructure — Hermes cron, AlertManager, K8s CronJob, GitHub webhook, Telegram
**Depends on**: Phase 11
**Requirements**: TRKC-01, TRKC-02
**Success Criteria** (what must be TRUE):
  1. `LAB-track-c-kubernetes.mdx` exists in module-11-triggers/lab/ with KIND-native trigger steps: Hermes cron for daily-k8s-check, AlertManager webhook from Prometheus on KIND, K8s CronJob with Docker build, GitHub webhook via smee.io, Telegram bot
  2. Track C lab has zero mock CloudWatch steps and zero HERMES_LAB_MODE references — all triggers use real infrastructure
  3. Module 11 README references the Track C lab and lists KIND cluster as prerequisite
  4. AlertManager + Prometheus setup is self-contained within the lab (not assumed from elsewhere)
**Plans:** 0/? plans (to be determined)

### Phase 13: Module 13 Governance Refactor — Wrapper-Free Track C
**Goal**: Refactor Module 13 governance lab so Track C demonstrates L1-L4 progression using SOUL.md behavioral enforcement as the primary mechanism — no dependency on mock-kubectl wrapper allowlists
**Depends on**: Phase 12
**Requirements**: GOVR-01, GOVR-02
**Success Criteria** (what must be TRUE):
  1. Module 13 Track C lab demonstrates L1 (no terminal), L2 (SOUL.md refuses kubectl delete), L3 (smart approval reduces friction), L4 (SOUL.md allows kubectl apply/rollout undo) — all without wrapper_allowlist enforcement
  2. Lab explicitly teaches: "SOUL.md is the production governance mechanism; wrapper allowlists are optional operational scaffolding"
  3. DANGEROUS_PATTERNS demo (rm -rf) still works and is shown alongside SOUL.md refusal for kubectl — two enforcement mechanisms, not one
  4. Zero references to HERMES_LAB_GOVERNANCE env var or wrapper_allowlist in the Track C lab path
**Plans:** 0/? plans (to be determined)

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Foundation | v1.0 | 4/4 | Complete | 2026-04-07 |
| 2. Day 1 Modules | v1.0 | 3/3 | Complete | 2026-04-07 |
| 3. Day 2 Modules | v1.0 | 5/5 | Complete | 2026-04-07 |
| 4. Remaining Content | v1.0 | 3/3 | Complete | 2026-04-07 |
| 5. Module Consolidation | v1.1 | 3/3 | Complete   | 2026-04-07 |
| 6. K8s Skills & Agents | v1.1 | 3/3 | Complete    | 2026-04-07 |
| 7. Guardrails & Governance | v1.1 | 3/3 | Complete    | 2026-04-07 |
| 8. Agent Triggers | v1.1 | 3/3 | Complete    | 2026-04-07 |
| 9. Multi-Agent Workflows & Production | v1.1 | 2/2 | Complete    | 2026-04-07 |
| 10. Labs 7-8 Real KIND Refactor | v1.1 | 5/5 | Complete   | 2026-04-09 |
| 11. Module 11↔12 Swap | v1.1 | 1/2 | In Progress|  |
| 12. Module 11 Track C Triggers Lab | v1.1 | 0/? | Planned | — |
| 13. Module 13 Governance Refactor | v1.1 | 0/? | Planned | — |

---

**For current project state**, see [PROJECT.md](PROJECT.md)

**For past requirements and decisions**, see [milestones/v1.0-REQUIREMENTS.md](milestones/v1.0-REQUIREMENTS.md)
