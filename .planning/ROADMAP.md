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

- [ ] **Phase 5: Module Consolidation** - Restructure Modules 5 and 6 with Superpowers as centerpiece for IaC work
- [ ] **Phase 6: K8s Skills & Agents** - Build real K8s diagnostic skills and rebuild Track C agents for KIND
- [ ] **Phase 7: Guardrails & Governance** - Add command allowlists, per-track configs, and L1-L4 progression demo
- [ ] **Phase 8: Agent Triggers** - Implement AlertManager, CronJob, GitHub, and chat bot trigger patterns
- [ ] **Phase 9: Multi-Agent Workflows & Production** - End-to-end fleet workflows and K8s Agent Sandbox

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
**Plans:** 3 plans
Plans:
- [ ] 05-01-PLAN.md — Directory restructure: rename module-05b to module-06, scaffold new module-05, migrate solution files, delete old dirs, update all cross-references
- [ ] 05-02-PLAN.md — Lab content authoring: Track A (Helm Superpowers 90 min) and Track B (Terraform Superpowers 90 min)
- [ ] 05-03-PLAN.md — Supporting content: README, reading (concepts + reference), quiz (7 questions), exploratory projects (ArgoCD, CI/CD, second track)

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
**Plans**: TBD
**UI hint**: no

### Phase 7: Guardrails & Governance
**Goal**: Hermes governance configs demonstrate real operational safety with populated command allowlists — participants can observe what happens when a blocked command is attempted
**Depends on**: Phase 6
**Requirements**: GOV-01, GOV-02, GOV-03
**Success Criteria** (what must be TRUE):
  1. Participant running a Hermes agent with Module 10 or 13 config finds kubectl get, describe, and logs in the allowlist and kubectl delete, drain, and exec blocked — attempting a blocked command produces a governance rejection, not silent execution
  2. Each domain track (K8s, Database, FinOps) has a separate governance config file with domain-appropriate allowlists — a FinOps agent cannot issue kubectl commands, a K8s agent cannot run database mutations
  3. A participant following the L1 through L4 walkthrough can observe the allowlist growing at each trust level — L1 has read-only kubectl, L4 adds write operations with human-approval gate — the progression is shown in config diffs
**Plans**: TBD

### Phase 8: Agent Triggers
**Goal**: Participants can wire an agent to four external trigger sources and observe automated agent invocation — not just manual CLI execution
**Depends on**: Phase 6
**Requirements**: TRIG-01, TRIG-02, TRIG-03, TRIG-04
**Success Criteria** (what must be TRUE):
  1. Participant following the AlertManager lab fires a synthetic alert from Prometheus stack on KIND and observes the triage agent receiving the webhook and producing a diagnosis of the affected pod
  2. Participant applying the CronJob manifest to KIND observes the scheduled agent running on interval, completing a health check, and writing a status report — without any manual invocation
  3. Participant sending a GitHub webhook event (or using the PR review bot pattern) observes the agent receiving the event and producing a review comment or summary output
  4. Participant following the chat bot lab sends a slash command via Telegram or Slack and receives an agent response posted back to the channel — full round-trip without terminal interaction
**Plans**: TBD

### Phase 9: Multi-Agent Workflows & Production
**Goal**: Participants witness an end-to-end automated incident response chain and can deploy an agent into a K8s sandbox — moving from demo to production-ready patterns
**Depends on**: Phase 7, Phase 8
**Requirements**: FLEET-01, FLEET-02, PROD-01, PROD-02
**Success Criteria** (what must be TRUE):
  1. Participant triggering a synthetic alert observes the full workflow chain: AlertManager fires, triage agent classifies, diagnostic agent investigates with K8s skills, proposal agent outputs a fix recommendation, participant approves, and the agent applies the fix — each agent handoff is visible in logs
  2. The fleet coordinator agent (Morgan) synthesizes inputs from two or more working specialist agents and produces a cross-domain incident summary — not a placeholder stub
  3. Participant following the K8s Agent Sandbox lab installs the Sandbox CRDs on KIND, deploys an agent in sandbox mode, and observes isolation — the agent cannot access resources outside its namespace boundary
  4. Conceptual reading on agent productionization covers packaging, deployment, monitoring, and scaling patterns with real Hermes config examples — not generic cloud theory
**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Foundation | v1.0 | 4/4 | Complete | 2026-04-07 |
| 2. Day 1 Modules | v1.0 | 3/3 | Complete | 2026-04-07 |
| 3. Day 2 Modules | v1.0 | 5/5 | Complete | 2026-04-07 |
| 4. Remaining Content | v1.0 | 3/3 | Complete | 2026-04-07 |
| 5. Module Consolidation | v1.1 | 0/3 | Planning complete | - |
| 6. K8s Skills & Agents | v1.1 | 0/? | Not started | - |
| 7. Guardrails & Governance | v1.1 | 0/? | Not started | - |
| 8. Agent Triggers | v1.1 | 0/? | Not started | - |
| 9. Multi-Agent Workflows & Production | v1.1 | 0/? | Not started | - |

---

**For current project state**, see [PROJECT.md](PROJECT.md)

**For past requirements and decisions**, see [milestones/v1.0-REQUIREMENTS.md](milestones/v1.0-REQUIREMENTS.md)
