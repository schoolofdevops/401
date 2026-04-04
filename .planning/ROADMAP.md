# Roadmap: Agentic DevOps Course

## Overview

Build a complete dual-format course (3-day workshop + Udemy) teaching DevOps practitioners to build AI agents through context engineering. The reference microservices app and shared mock data go first as strict prerequisites, then Day 1 conceptual content (Modules 1-4), then Day 2 technical depth (Modules 5-6 with three IaC tracks each), then supporting modules (9, 14), cross-module content (all-module reading/quiz/explainer), and delivery format artifacts (instructor guides, Udemy outline).

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Foundation** - Reference app, shared mock data, setup guide, environment verification
- [ ] **Phase 2: Day 1 Modules** - Modules 1-4 labs, reading, quiz — context engineering mental model
- [ ] **Phase 3: Day 2 Modules** - Modules 5-6 labs with dual/triple tracks — structured coding and AI-assisted IaC
- [ ] **Phase 4: Remaining Content** - Modules 9 and 14, all-module reading/quiz/explainers, format overlays

## Phase Details

### Phase 1: Foundation
**Goal**: Every participant can run a working local environment against real infrastructure before any module begins
**Depends on**: Nothing (first phase)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, FOUND-06, FOUND-07, FOUND-08
**Success Criteria** (what must be TRUE):
  1. A participant running `bash setup/verify.sh` sees all prerequisites marked PASS with no manual intervention
  2. The reference microservices app (2-3 services + PostgreSQL) deploys to KIND with a single command and services respond to health checks
  3. Shared mock data files exist for CloudWatch, Cost Explorer, RDS Performance Insights, and kubectl output — each matching current AWS CLI output format with a source-and-date comment
  4. Multi-provider setup instructions cover Claude Code, Crush (Groq/Gemini backends), and OpenRouter — each with rate limits and the January 2026 Anthropic OAuth block documented
**Plans**: 4 plans

Plans:
- [ ] 01-01-PLAN.md — Rust backend services (api-gateway, catalog, worker) with Cargo workspace, Dockerfiles, PostgreSQL migrations
- [x] 01-02-PLAN.md — CloudWatch alarm mock data (clean + anomaly scenarios) and mock-aws wrapper update
- [ ] 01-03-PLAN.md — Svelte health dashboard, Helm chart, KIND config, Prometheus values, Makefile, GitHub Actions CI/CD
- [ ] 01-04-PLAN.md — Participant setup guide (SETUP.md), course verify.sh, LLM access docs (Claude Code + OpenCode)

### Phase 2: Day 1 Modules
**Goal**: A participant completing Day 1 can explain context engineering using infrastructure analogies, has hands-on experience with AWS platform AI features, understands the gap between platform AI and custom agents, and can score their own operational tasks for automation potential
**Depends on**: Phase 1
**Requirements**: MOD1-01, MOD1-02, MOD1-03, MOD1-04, MOD1-05, MOD1-06, MOD1-07, MOD2-01, MOD2-02, MOD2-03, MOD2-04, MOD3-01, MOD3-02, MOD3-03, MOD4-01, MOD4-02, MOD4-03, MOD4-04, MOD4-05
**Success Criteria** (what must be TRUE):
  1. Module 1 lab shows a side-by-side comparison of bare instruction vs. structured domain context against real CloudWatch-style alarm data — a participant can observe the quality difference without being told what to look for
  2. Module 2 lab connects to real AWS free-tier services (CloudWatch anomaly detection, Cost Explorer, Q Developer) with a clearly-labeled mock fallback path for participants without AWS accounts
  3. Module 3 demo script walks a facilitator through a live Hermes agent first-run in under 15 minutes with participant observation cues
  4. Module 4 automation quadrant template is completable solo (no team needed) and produces a ranked list of at least 10 operational tasks with scores
  5. Every module (1-4) has LAB.md, concepts.md, reference.md, QUIZ.md, and README.md in the standard directory structure
**Plans**: TBD

Plans:
- [ ] 02-01: Module 1 lab (progressive context engineering with CloudWatch data, token economics)
- [ ] 02-02: Module 1 reading materials and quiz (tokenization, context windows, AI spectrum, context engineering philosophy)
- [ ] 02-03: Modules 2-4 labs, reading, quiz (platform AI, bridge content, impact assessment)

### Phase 3: Day 2 Modules
**Goal**: A participant completing Day 2 has built real infrastructure artifacts (Helm chart or CI/CD pipeline) using a structured AI workflow and has working IaC in at least one track (Terraform, K8s+GitOps, or CI/CD with Argo Workflows)
**Depends on**: Phase 2
**Requirements**: MOD5-01, MOD5-02, MOD5-03, MOD5-04, MOD5-05, MOD5-06, MOD5-07, MOD5-08, MOD5-09, MOD5-10, MOD6-01, MOD6-02, MOD6-03, MOD6-04, MOD6-05, MOD6-06
**Success Criteria** (what must be TRUE):
  1. Module 5 Track A produces a working Helm chart for the reference app (deployable to KIND) via the GSD structured workflow — participant can trace every decision back to a workflow step
  2. Module 5 Track B produces a working GitHub Actions CI/CD pipeline for the reference app via the structured AI workflow
  3. Module 6 Track A Terraform lab connects to real AWS free-tier resources (EC2/RDS with CloudWatch alarms) with a documented mock fallback; starter and solution files exist
  4. Module 6 Track B K8s+Helm+ArgoCD lab deploys the reference app to KIND via GitOps — participant can push a change and watch ArgoCD sync it
  5. Module 6 Track C Argo Workflows + GitHub Actions lab runs a real CI/CD pipeline for the reference app
  6. Every Module 5 and 6 lab step includes an "Expected result:" block so participants know immediately if they succeeded
**Plans**: TBD
**UI hint**: no

Plans:
- [ ] 03-01: Module 5 labs (Track A Helm, Track B CI/CD, GSD workflow lab, context engineering, memory, plan modes, superpowers exploratory)
- [ ] 03-02: Module 5 reading materials and quiz
- [ ] 03-03: Module 6 labs — all three tracks (Terraform, K8s+GitOps, Argo Workflows), each with starter/solution/expected outputs

### Phase 4: Remaining Content
**Goal**: Every module in the course has complete reading material, quiz, and explainer; Modules 9 and 14 have their specific artifacts; instructors have facilitator guides; Udemy has a section outline
**Depends on**: Phase 2, Phase 3
**Requirements**: MOD9-01, MOD9-02, MOD9-03, MOD14-01, MOD14-02, MOD14-03, CONTENT-01, CONTENT-02, CONTENT-03, CONTENT-04, CONTENT-05, CONTENT-06, FMT-01, FMT-02, FMT-03, FMT-04, FMT-05
**Success Criteria** (what must be TRUE):
  1. Every module (1-14) has a concepts.md, reference.md, QUIZ.md (5-8 questions), PROJECTS.md, and README.md — a grep for missing files returns zero results
  2. Module 9 reading covers all four agent design patterns (advisor, investigator, proposal, guardian) and the L1-L4 autonomy spectrum with concrete Hermes-mapped examples
  3. Module 14 capstone templates (presentation template, 30-day roadmap template, rubric) are complete and a solo participant can use them without a facilitator
  4. Day 1, Day 2, and Day 3 instructor facilitator guides exist with timing, transitions, and debrief prompts
  5. A vocabulary grep across all content returns zero instances of "prompt engineering" after Module 1 — context engineering language is enforced throughout
**Plans**: TBD

Plans:
- [ ] 04-01: Modules 9 and 14 specific content (design patterns reading, capstone templates, rubric)
- [ ] 04-02: All-module content sweep (concepts.md, reference.md, QUIZ.md, PROJECTS.md, README.md for modules 1-14)
- [ ] 04-03: Format overlays (instructor facilitator guides Day 1/2/3, Udemy section outline, solo fallbacks, vocabulary audit)

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 1/4 | In Progress|  |
| 2. Day 1 Modules | 0/3 | Not started | - |
| 3. Day 2 Modules | 0/3 | Not started | - |
| 4. Remaining Content | 0/3 | Not started | - |
