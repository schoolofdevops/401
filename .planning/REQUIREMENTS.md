# Requirements: Agentic DevOps Course v1.1

**Defined:** 2026-04-07
**Core Value:** DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering is THE skill that makes agents useful.

## v1.1 Requirements

Requirements for v1.1: Realistic Agents & Production Workflows. Each maps to roadmap phases.

### Module Consolidation

- [x] **CONS-01**: Module 5 rebuilt as "Superpowers for IaC" with brainstorm, TDD, verification, debugging, and code review workflows applied to Terraform/Helm/GitOps tracks
- [x] **CONS-02**: Module 6 renamed from "5b" to "AI Workflow Tools" — GSD + CLAUDE.md + claude-mem + plan modes (content preserved, numbering updated)
- [x] **CONS-03**: Old Module 6 (AI-Assisted IaC) content absorbed into new Module 5 as project context — Terraform/Helm/GitOps become the domain for Superpowers exercises
- [x] **CONS-04**: Reading materials and quizzes updated to match restructured Module 5 and 6 content

### K8s Skills & Agents

- [x] **K8S-01**: K8s diagnostic SKILL.md with real kubectl commands (get pods, describe pod, logs, top) replacing EC2 skill in Track C
- [x] **K8S-02**: kube-troublesim 6 broken pod scenarios integrated as lab exercises on KIND (ImagePullBackOff, CrashLoopBackOff, resource limits, liveness probe, missing secret, port mismatch)
- [x] **K8S-03**: Track C agent (Kiran) rebuilt with proper K8s skill attached, updated SOUL.md, and live KIND integration
- [x] **K8S-04**: Additional K8s skills: node health check, resource quota analysis, deployment rollback investigation
- [x] **K8S-05**: Module 7 Track C starter and solution files replaced with actual K8s diagnostic skill (not EC2)

### Agent Triggers

- [x] **TRIG-01**: AlertManager webhook triggers triage agent that diagnoses pod issues on KIND with Prometheus stack
- [x] **TRIG-02**: K8s CronJob scheduled agent runs periodic health checks and reports status
- [x] **TRIG-03**: GitHub webhook/command triggers PR review bot agent
- [x] **TRIG-04**: Chat bot interaction via Telegram or Slack — slash commands trigger agent workflows, results posted back

### Guardrails & Governance

- [x] **GOV-01**: Hermes command allowlist/blocklist configuration — kubectl get/describe/logs allowed, kubectl delete/drain/exec blocked
- [x] **GOV-02**: Per-track governance configs with domain-specific allowlists (K8s, Database, FinOps)
- [x] **GOV-03**: Progressive governance walkthrough L1 to L4 with allowlist differentiation showing trust escalation

### Agent Productionization

- [x] **PROD-01**: K8s Agent Sandbox exploratory lab — install CRDs on KIND, deploy agent in Sandbox, demonstrate isolation and lifecycle
- [x] **PROD-02**: Conceptual content on productionizing agents: packaging, deployment, monitoring, scaling patterns

### Multi-Agent Workflows

- [x] **FLEET-01**: End-to-end workflow: AlertManager alert triggers triage agent, diagnostic agent investigates, proposes fix, human approves, agent applies
- [x] **FLEET-02**: Fleet coordinator (Morgan) rebuilt with real cross-domain incident synthesis using working specialist agents

### Module Sequencing & Renaming

- [x] **SWAP-01**: Module 11 (Fleet) renamed to Module 12, Module 12 (Triggers) renamed to Module 11 — directories, sidebar positions, and all internal content updated
- [x] **SWAP-02**: All cross-references across Modules 7-14, setup docs, and CLAUDE.md updated to reflect new numbering

### Track C Triggers Lab

- [ ] **TRKC-01**: Dedicated Track C triggers lab for new Module 11 — Hermes cron, AlertManager on KIND, K8s CronJob, GitHub webhook, Telegram bot (no mock CloudWatch steps)
- [ ] **TRKC-02**: New Module 11 prerequisites updated: Module 8 Track C agent + running KIND cluster (not Module 10)

### Governance Refactor (Wrapper-Free)

- [ ] **GOVR-01**: Module 13 governance lab refactored for Track C without wrapper enforcement — SOUL.md behavioral refusal as primary mechanism, DANGEROUS_PATTERNS for shell commands
- [ ] **GOVR-02**: L1-L4 progression demonstrated via config changes + SOUL.md policy (not wrapper_allowlist expansion)

## v1.2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Video & Media

- **VID-01**: Video walkthroughs for structured AI workflow (5-phase cycle recording)
- **VID-02**: Udemy video production (concept explainers + lab walkthroughs)
- **VID-03**: Explainer slide notes and Excalidraw diagram sources

### Deferred Content

- **DEF-01**: Module 6 Lab Track C — Argo Workflows + GitHub Actions pipeline (deferred from v1.0)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Video recording/editing | Separate production step after content is written |
| Excalidraw diagram creation | Visual design — trainer creates from diagram descriptions |
| LMS/Udemy platform setup | Separate from content creation |
| Paid API integrations | All labs must work on free tiers only |
| K8s Agent Sandbox as required lab dependency | Alpha v0.2.1 — too early for required content; exploratory only |
| Modules 1-4 changes | Already validated in v1.0, no feedback warranting changes |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| CONS-01 | Phase 5 | Complete |
| CONS-02 | Phase 5 | Complete |
| CONS-03 | Phase 5 | Complete |
| CONS-04 | Phase 5 | Complete |
| K8S-01 | Phase 6 | Complete |
| K8S-02 | Phase 6 | Complete |
| K8S-03 | Phase 6 | Complete |
| K8S-04 | Phase 6 | Complete |
| K8S-05 | Phase 6 | Complete |
| TRIG-01 | Phase 8 | Complete |
| TRIG-02 | Phase 8 | Complete |
| TRIG-03 | Phase 8 | Complete |
| TRIG-04 | Phase 8 | Complete |
| GOV-01 | Phase 7 | Complete |
| GOV-02 | Phase 7 | Complete |
| GOV-03 | Phase 7 | Complete |
| PROD-01 | Phase 9 | Complete |
| PROD-02 | Phase 9 | Complete |
| FLEET-01 | Phase 9 | Complete |
| FLEET-02 | Phase 9 | Complete |
| LAB-01 | Phase 10 | Complete |
| LAB-02 | Phase 10 | Complete |
| LAB-03 | Phase 10 | Complete |
| LAB-04 | Phase 10 | Complete |
| LAB-05 | Phase 10 | Complete |
| SWAP-01 | Phase 11 | Planned |
| SWAP-02 | Phase 11 | Planned |
| TRKC-01 | Phase 12 | Planned |
| TRKC-02 | Phase 12 | Planned |
| GOVR-01 | Phase 13 | Planned |
| GOVR-02 | Phase 13 | Planned |

**Coverage:**
- v1.1 requirements: 31 total
- Mapped to phases: 31
- Unmapped: 0

---
*Requirements defined: 2026-04-07*
*Last updated: 2026-04-09 — added Phase 10 (LAB), Phase 11 (SWAP), Phase 12 (TRKC), Phase 13 (GOVR) requirements*
