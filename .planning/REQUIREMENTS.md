# Requirements: Agentic DevOps Course

**Defined:** 2026-04-04
**Core Value:** DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering is THE skill that makes agents useful.

## v1 Requirements

Requirements for initial release (due 2026-04-05, course starts 2026-04-06).

### Foundation Infrastructure

- [x] **FOUND-01**: Reference microservices application (2-3 services + PostgreSQL) deployable on KIND — serves as the course backbone for all labs
- [ ] **FOUND-02**: Helm chart packaging for the reference app (used in Module 5 lab and Module 6 Track B)
- [ ] **FOUND-03**: CI/CD pipeline (GitHub Actions) for the reference app — build, test, deploy to KIND
- [ ] **FOUND-04**: ArgoCD GitOps setup on KIND for the reference app — real GitOps, not simulated
- [ ] **FOUND-05**: Participant setup guide covering Claude Code install, Crush/OpenCode install, KIND + Docker, AWS CLI, multi-provider LLM config (Claude subscription, Gemini 2.5 Flash, OpenRouter, Grok, Groq)
- [ ] **FOUND-06**: Environment verification script (verify.sh) that validates all prerequisites
- [x] **FOUND-07**: Real AWS connections first (Cost Explorer, CloudWatch, RDS Performance Insights) when participants have AWS accounts. Mock data as clearly-labeled fallback only — realistic format matching current AWS CLI output, with instructions to swap in real credentials
- [ ] **FOUND-08**: Multi-provider LLM access documentation — setup instructions for each provider with rate limits and fallback guidance

### Module 1 — AI Foundations

- [ ] **MOD1-01**: Lab Part 1 — Progressive context engineering with real CloudWatch-style alarm data (raw dump → system prompt → structured output → few-shot)
- [ ] **MOD1-02**: Lab Part 2 — Context engineering deep-dive: same alarm with progressive context layers (alarm only → infrastructure topology → incident history → runbook context)
- [ ] **MOD1-03**: Lab Part 3 — Token economics: cost estimation, context size vs quality tradeoff, free tier management
- [ ] **MOD1-04**: Reading — Tokenization, context windows, inference pipeline (prefill/decode), temperature, Top-P/K — all with DevOps analogies
- [ ] **MOD1-05**: Reading — AI spectrum (Chat → Copilot → Agent → Squad) with operational maturity analogy
- [ ] **MOD1-06**: Reading — Context engineering philosophy: why context > prompts, domain expertise as context
- [ ] **MOD1-07**: Quiz (5-8 questions) covering LLM fundamentals, context engineering concepts

### Module 2 — Platform AI

- [ ] **MOD2-01**: Lab — Explore AWS AI features on free tier: CloudWatch anomaly detection setup, Cost Explorer analysis, Q Developer for query explanation
- [ ] **MOD2-02**: Reading — AWS AI services landscape and capabilities/limitations matrix
- [ ] **MOD2-03**: Assessment template — "Platform AI capabilities and gaps for your environment"
- [ ] **MOD2-04**: Quiz covering platform AI features, vendor lock-in concepts

### Module 3 — Bridge Content (Platform AI → Custom Agents)

- [ ] **MOD3-01**: Demo script — Hermes first-run agent walkthrough (minimal setup, live demo)
- [ ] **MOD3-02**: Reading — What custom agents add that platform AI can't, the gap analysis
- [ ] **MOD3-03**: Quiz covering platform vs custom agent tradeoffs

### Module 4 — Impact Assessment

- [ ] **MOD4-01**: Automation Quadrant template (frequency × complexity scoring matrix)
- [ ] **MOD4-02**: Scoring sheet for top 10 operational tasks with evaluation criteria (frequency, time, error risk, tool count)
- [ ] **MOD4-03**: Selection criteria for Day 3 capstone project
- [ ] **MOD4-04**: Solo-completable version (no team dependency for Udemy learners)
- [ ] **MOD4-05**: Quiz covering automation candidate evaluation

### Module 5 — Structured AI Coding + AI Workflows

- [ ] **MOD5-01**: Lab Track A — Build production Helm chart for reference app via structured AI workflow (Brainstorm → Design → Blueprint → Implement → Validate)
- [ ] **MOD5-02**: Lab Track B — Build CI/CD pipeline (GitHub Actions) for reference app via structured AI workflow
- [ ] **MOD5-03**: GSD Workflow lab — Full /gsd:new-project → discuss → plan → execute → verify cycle applied to a real IaC deliverable, demonstrating structured AI harness for multi-file infrastructure work
- [ ] **MOD5-04**: Context engineering practical — CLAUDE.md files, context window management, selective injection, managing what the LLM sees across sessions
- [ ] **MOD5-05**: Memory systems lab — Cross-session persistence: claude-mem for Claude Code, MCP-based memory for OpenCode/Crush. When to use memory vs context vs plans
- [ ] **MOD5-06**: Plan modes lab — Structured reasoning before execution: Claude Code plan mode, GSD plan-phase. When to plan vs when to just execute, reviewing and approving plans
- [ ] **MOD5-07**: Superpowers workflow (exploratory) — TDD, systematic debugging, code review, brainstorming skills as examples of extending Claude Code with disciplined workflows
- [ ] **MOD5-08**: Reading — Why unstructured prompting fails for production infrastructure
- [ ] **MOD5-09**: Reading — GSD workflow reference, plan modes, memory systems, context engineering techniques
- [ ] **MOD5-10**: Quiz covering structured coding concepts, context engineering, AI workflow patterns

### Module 6 — AI-Assisted IaC

- [ ] **MOD6-01**: Lab Track A — Terraform module for real AWS resources (free tier): EC2/RDS with CloudWatch alarms + SNS notifications. Mock fallback documented for non-AWS participants
- [ ] **MOD6-02**: Lab Track B — Kubernetes manifests + Helm charts + ArgoCD GitOps config for reference app on KIND — fully real, local
- [ ] **MOD6-03**: Lab Track C — CI/CD pipeline with Argo Workflows + GitHub Actions for reference app — fully real
- [ ] **MOD6-04**: Each track: starter files, solution files, expected outputs, validation steps
- [ ] **MOD6-05**: Reading — AI failure modes in infrastructure generation, common AI errors in IaC
- [ ] **MOD6-06**: Quiz covering IaC validation, AI error patterns in infrastructure code

### Module 9 — Agent Design Patterns (partial — this repo)

- [ ] **MOD9-01**: Reading — Pattern taxonomy: advisor, investigator, proposal, guardian — each mapped to Hermes capabilities
- [ ] **MOD9-02**: Reading — Autonomy spectrum L1 (Assistive) → L4 (Semi-autonomous) with concrete examples
- [ ] **MOD9-03**: Quiz covering design patterns, autonomy levels

### Module 14 — Capstone (partial — this repo)

- [ ] **MOD14-01**: Presentation template — what teams should cover in their demo
- [ ] **MOD14-02**: 30-day deployment roadmap template — post-workshop implementation plan
- [ ] **MOD14-03**: Evaluation rubric — problem statement, agent design quality, live demo, governance spec, plan realism

### All Modules — Reading & Assessment

- [ ] **CONTENT-01**: concepts.md for every module (1-14) — core concepts with DevOps analogies
- [ ] **CONTENT-02**: reference.md for every module (1-14) — command reference, configs, cheat sheets
- [ ] **CONTENT-03**: QUIZ.md for every module (1-14) — 5-8 questions, concept-focused not syntax trivia
- [ ] **CONTENT-04**: Exploratory projects (PROJECTS.md) per module — 2-3 stretch ideas for advanced participants
- [ ] **CONTENT-05**: Module README.md for every module — overview, 3-5 learning objectives, prerequisites
- [ ] **CONTENT-06**: Context engineering vocabulary enforced throughout — no "prompt engineering" language after Module 1, DevOps analogies for every AI concept

### Format & Delivery

- [ ] **FMT-01**: Instructor facilitator guides for Day 1, Day 2, Day 3 — timing, transitions, debrief prompts
- [ ] **FMT-02**: Udemy section outline mapping modules to Udemy sections
- [ ] **FMT-03**: Solo fallback for all team exercises (Module 4 scoring, Module 11 fleet, Module 14 capstone)
- [ ] **FMT-04**: Every lab step includes "Expected result:" validation so learners know if they succeeded
- [ ] **FMT-05**: Lab deliverable stated at top of every LAB.md

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Extended Content

- **V2-01**: Mission Control dashboard design and reference implementation
- **V2-02**: Additional domain agent tracks (security hardening agent, CI/CD health agent)
- **V2-03**: Certification / completion badge program
- **V2-04**: Post-course reference guide ("What to build in your first 30 days")
- **V2-05**: Video production (recorded walkthroughs, Udemy video lessons)
- **V2-06**: vLLM/MLOps integration labs (if demand warrants)
- **V2-07**: Advanced multi-model orchestration patterns

## Out of Scope

| Feature | Reason |
|---------|--------|
| Hermes-focused lab content (Modules 7, 8, 10-13) | Built in hermes-agent repo, not this repo |
| Video recording/editing | Separate production step after content is written |
| Excalidraw diagram visual creation | Trainer creates from diagram descriptions in explainer/ |
| LMS/Udemy platform configuration | Separate from content creation |
| Paid API integrations | All labs must work on free tiers only |
| Python-first or framework-specific content | Course is tool-agnostic, YAML-first, pattern-focused |
| Requiring paid AWS services | Labs work with free tier; participants with existing AWS accounts connect to real services |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUND-01 | Phase 1 | Complete |
| FOUND-02 | Phase 1 | Pending |
| FOUND-03 | Phase 1 | Pending |
| FOUND-04 | Phase 1 | Pending |
| FOUND-05 | Phase 1 | Pending |
| FOUND-06 | Phase 1 | Pending |
| FOUND-07 | Phase 1 | Complete |
| FOUND-08 | Phase 1 | Pending |
| MOD1-01 | Phase 2 | Pending |
| MOD1-02 | Phase 2 | Pending |
| MOD1-03 | Phase 2 | Pending |
| MOD1-04 | Phase 2 | Pending |
| MOD1-05 | Phase 2 | Pending |
| MOD1-06 | Phase 2 | Pending |
| MOD1-07 | Phase 2 | Pending |
| MOD2-01 | Phase 2 | Pending |
| MOD2-02 | Phase 2 | Pending |
| MOD2-03 | Phase 2 | Pending |
| MOD2-04 | Phase 2 | Pending |
| MOD3-01 | Phase 2 | Pending |
| MOD3-02 | Phase 2 | Pending |
| MOD3-03 | Phase 2 | Pending |
| MOD4-01 | Phase 2 | Pending |
| MOD4-02 | Phase 2 | Pending |
| MOD4-03 | Phase 2 | Pending |
| MOD4-04 | Phase 2 | Pending |
| MOD4-05 | Phase 2 | Pending |
| MOD5-01 | Phase 3 | Pending |
| MOD5-02 | Phase 3 | Pending |
| MOD5-03 | Phase 3 | Pending |
| MOD5-04 | Phase 3 | Pending |
| MOD5-05 | Phase 3 | Pending |
| MOD5-06 | Phase 3 | Pending |
| MOD5-07 | Phase 3 | Pending |
| MOD5-08 | Phase 3 | Pending |
| MOD5-09 | Phase 3 | Pending |
| MOD5-10 | Phase 3 | Pending |
| MOD6-01 | Phase 3 | Pending |
| MOD6-02 | Phase 3 | Pending |
| MOD6-03 | Phase 3 | Pending |
| MOD6-04 | Phase 3 | Pending |
| MOD6-05 | Phase 3 | Pending |
| MOD6-06 | Phase 3 | Pending |
| MOD9-01 | Phase 4 | Pending |
| MOD9-02 | Phase 4 | Pending |
| MOD9-03 | Phase 4 | Pending |
| MOD14-01 | Phase 4 | Pending |
| MOD14-02 | Phase 4 | Pending |
| MOD14-03 | Phase 4 | Pending |
| CONTENT-01 | Phase 4 | Pending |
| CONTENT-02 | Phase 4 | Pending |
| CONTENT-03 | Phase 4 | Pending |
| CONTENT-04 | Phase 4 | Pending |
| CONTENT-05 | Phase 4 | Pending |
| CONTENT-06 | Phase 4 | Pending |
| FMT-01 | Phase 4 | Pending |
| FMT-02 | Phase 4 | Pending |
| FMT-03 | Phase 4 | Pending |
| FMT-04 | Phase 4 | Pending |
| FMT-05 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 55 total
- Mapped to phases: 55
- Unmapped: 0

---
*Requirements defined: 2026-04-04*
*Last updated: 2026-04-04 — traceability filled in after roadmap creation*
