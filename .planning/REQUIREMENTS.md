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

- [ ] **K8S-01**: K8s diagnostic SKILL.md with real kubectl commands (get pods, describe pod, logs, top) replacing EC2 skill in Track C
- [ ] **K8S-02**: kube-troublesim 6 broken pod scenarios integrated as lab exercises on KIND (ImagePullBackOff, CrashLoopBackOff, resource limits, liveness probe, missing secret, port mismatch)
- [ ] **K8S-03**: Track C agent (Kiran) rebuilt with proper K8s skill attached, updated SOUL.md, and live KIND integration
- [ ] **K8S-04**: Additional K8s skills: node health check, resource quota analysis, deployment rollback investigation
- [ ] **K8S-05**: Module 7 Track C starter and solution files replaced with actual K8s diagnostic skill (not EC2)

### Agent Triggers

- [ ] **TRIG-01**: AlertManager webhook triggers triage agent that diagnoses pod issues on KIND with Prometheus stack
- [ ] **TRIG-02**: K8s CronJob scheduled agent runs periodic health checks and reports status
- [ ] **TRIG-03**: GitHub webhook/command triggers PR review bot agent
- [ ] **TRIG-04**: Chat bot interaction via Telegram or Slack — slash commands trigger agent workflows, results posted back

### Guardrails & Governance

- [ ] **GOV-01**: Hermes command allowlist/blocklist configuration — kubectl get/describe/logs allowed, kubectl delete/drain/exec blocked
- [ ] **GOV-02**: Per-track governance configs with domain-specific allowlists (K8s, Database, FinOps)
- [ ] **GOV-03**: Progressive governance walkthrough L1 to L4 with allowlist differentiation showing trust escalation

### Agent Productionization

- [ ] **PROD-01**: K8s Agent Sandbox exploratory lab — install CRDs on KIND, deploy agent in Sandbox, demonstrate isolation and lifecycle
- [ ] **PROD-02**: Conceptual content on productionizing agents: packaging, deployment, monitoring, scaling patterns

### Multi-Agent Workflows

- [ ] **FLEET-01**: End-to-end workflow: AlertManager alert triggers triage agent, diagnostic agent investigates, proposes fix, human approves, agent applies
- [ ] **FLEET-02**: Fleet coordinator (Morgan) rebuilt with real cross-domain incident synthesis using working specialist agents

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
| K8S-01 | Phase 6 | Pending |
| K8S-02 | Phase 6 | Pending |
| K8S-03 | Phase 6 | Pending |
| K8S-04 | Phase 6 | Pending |
| K8S-05 | Phase 6 | Pending |
| TRIG-01 | Phase 8 | Pending |
| TRIG-02 | Phase 8 | Pending |
| TRIG-03 | Phase 8 | Pending |
| TRIG-04 | Phase 8 | Pending |
| GOV-01 | Phase 7 | Pending |
| GOV-02 | Phase 7 | Pending |
| GOV-03 | Phase 7 | Pending |
| PROD-01 | Phase 9 | Pending |
| PROD-02 | Phase 9 | Pending |
| FLEET-01 | Phase 9 | Pending |
| FLEET-02 | Phase 9 | Pending |

**Coverage:**
- v1.1 requirements: 20 total
- Mapped to phases: 20
- Unmapped: 0

---
*Requirements defined: 2026-04-07*
*Last updated: 2026-04-07 after v1.1 roadmap creation — all 20 requirements mapped to phases 5-9*
