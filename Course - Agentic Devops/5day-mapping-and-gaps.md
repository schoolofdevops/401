# 5-Day Workshop: Module Mapping & Gap Analysis

## What's Already Built (Impressive!)

The existing `course/` repo has substantial content for the original 3-day/14-module workshop:

**Complete labs (7):** Modules 7-13 (skills, tools, agents, fleet, triggers, governance)
**Partial content (4):** Modules 1-4 in Docusaurus course-site (readings, quizzes, labs)
**Agent profiles (4):** Aria (DBA), Finley (FinOps), Kiran (K8s), Morgan (Coordinator)
**Skills (4):** SRE EC2 health check, DevOps deployment safety, DBA slow query, Observability alert noise
**Governance (6):** L1-L4 YAML templates with track-specific variants
**Mock infrastructure:** 15+ JSON fixtures, shell wrappers, 7 scenarios, dual-mode (mock/live)
**Reference app:** Rust microservices (API Gateway, Catalog, Worker, Dashboard) + PostgreSQL + Helm charts + KIND + Prometheus/Grafana
**Reading materials (5):** Agent anatomy, skills guide, tool patterns, governance ref, profile guide
**Setup guides (4):** Hermes install, KIND setup, LLM access, verification script
**Instructor guides (3):** Day 1-3 + Udemy outline

---

## Key Discovery: Reference App

The existing reference app is a **Rust-based microservices application** (not the voting app). It has:
- API Gateway (Rust/Axum), Catalog service, Worker, Dashboard (SvelteKit)
- PostgreSQL (via Helm), Prometheus + Grafana monitoring
- One-command deploy: `make deploy` → cluster + DB + monitoring + app
- Dashboard at localhost:30080, Grafana at localhost:30090

**Decision needed:** Keep this reference app or switch to voting app?

**Recommendation: Keep the existing reference app.** It's already built, has Helm charts, monitoring stack, and all mock data is designed around it. Switching would mean rebuilding all fixtures, scenarios, wrappers, and labs. The existing app has everything we need: multi-tier architecture, real database, K8s deployment, monitoring.

---

## Tool Naming Clarification

The existing repo uses these names:
- **Claude Code** — primary AI coding agent
- **Crush** (formerly OpenCode, by Charm/charmbracelet) — fallback coding agent
- **Hermes** (by Nous Research) — agent building platform

Your verbal briefing mentioned **Goose** (by Block) as an alternative.

**Options:**
1. Keep Crush as documented (it's what the existing labs reference)
2. Switch to Goose (different tool, labs need updating)
3. Support both Goose and Crush as alternatives (mention both, lab instructions for one)

**Recommendation:** Mention both Goose and Crush as alternatives to Claude Code. Primary lab instructions use Claude Code. Fallback notes reference Crush (since labs already work with it). Goose mentioned as another open-source option participants can explore.

---

## Module Mapping: Old 14 → New 20

### Legend
- **REUSE** = Existing content maps directly, minor edits needed
- **ADAPT** = Existing content partially maps, needs expansion or restructuring
- **NEW** = Content doesn't exist yet, needs to be created from scratch

```
NEW 5-DAY STRUCTURE              OLD 3-DAY MODULE        STATUS
─────────────────────────────────────────────────────────────────

DAY 1: Foundations + AI-Augmented DevOps
├── M01: Welcome + AI Trinity     (NEW)                  NEW — framework intro,
│   + Environment Setup           Old M1 setup partial   ADAPT setup from existing
│
├── M02: AI Foundations           Old M1                 ADAPT — expand with Domain
│                                                        Expertise framework, has
│                                                        reading/quiz/lab in course-site
│
├── M03: Platform AI              Old M2                 REUSE — content exists in
│                                                        course-site, has lab/reading/quiz
│
└── M04: Connecting with MCP      Old M3 (partial)       ADAPT — old M3 was "bridge"
                                                         module. Expand MCP coverage,
                                                         add hands-on MCP wiring lab

DAY 2: Harnesses + Agentic Engineering
├── M05: Claude Code & Harnesses  Old M5 (planned,       NEW — lab was NOT built yet
│   (Superpowers/GSD)             not built)             (listed as gap in HANDOFF)
│
├── M06: How AI Works             (NEW)                  NEW — prefill/decode, TTFT,
│   (Engine Under the Hood)                              tokens, context windows
│
├── M07: Context Engineering      Old M1 (partial)       ADAPT — M1 reading has context
│                                                        engineering content. Needs
│                                                        expansion into full module
│
└── M08: Memory & Knowledge       (NEW)                  NEW — memory, vectorization,
    (Memory, RAGs, Vectors)                              semantic search, RAG pipeline

DAY 3: Tool Wiring + AgentDev
├── M09: Wiring Tools to Agents   Old M8                 REUSE — complete lab exists
│                                                        (modules/module-08-tools/LAB.md)
│
├── M10: Agentic Skills           Old M7                 REUSE — complete lab + 4 skills
│                                                        + template + rubric
│
├── M11: AgentDev: IaC            Old M6 (planned,       NEW — lab was NOT built yet
│   (AI-Assisted IaC)             not built)             (listed as gap in HANDOFF)
│
└── M12: AgentDev: Multi-File     Old M5b/6 (partial)    NEW — GSD for multi-file,
    (GSD + Sub-Agents)                                   sub-agents in Claude Code

DAY 4: Building Agents
├── M13: Agent Design Patterns    Old M9                 ADAPT — conceptual content
│                                                        was listed as "not built yet"
│                                                        in HANDOFF. Reading material
│                                                        partially exists.
│
├── M14: Building First Agent     Old M10                REUSE — 3 complete track labs
│   (Hermes)                                             exist (500 lines each!)
│
├── M15: Triggers & Scheduling    Old M12                REUSE — complete lab (657 lines)
│                                                        + cron starter YAML
│
└── M16: Domain Agents            Old M10 (continued)    REUSE — track labs cover this,
                                  + Old M4 (impact)      merge impact assessment here

DAY 5: Enterprise + Capstone
├── M17: Multi-Agent Systems      Old M11                REUSE — complete lab (626 lines)
│
├── M18: Governance               Old M13                REUSE — complete lab (720 lines)
│                                                        + 6 governance YAMLs
│
├── M19: Capstone                 Old M14 (partial)      ADAPT — templates needed
│                                                        (listed as gap in HANDOFF)
│
└── M20: 30-Day Roadmap           Old M14 (partial)      ADAPT — plan template needed
```

---

## Summary: Content Status

| Status | Count | Modules |
|--------|-------|---------|
| **REUSE** (minor edits) | 7 | M03, M09, M10, M14, M15, M17, M18 |
| **ADAPT** (expand/restructure) | 6 | M01, M02, M04, M07, M13, M19/M20 |
| **NEW** (create from scratch) | 5 | M05, M06, M08, M11, M12 |
| **TOTAL** | 20 | — |

**~65% of content exists.** The heaviest new work is in the Agentic Engineering pillar (Day 2 afternoon + Day 3 morning) — which makes sense, since that's the NEW pillar we're adding.

---

## What Needs to Be Created (Priority Order)

### Priority 1: NEW Modules (Labs + Explainers)

**M05 — Claude Code & Agentic Harnesses**
- Lab: Superpowers workflow for Ansible playbook (EC2 hardening)
- This was already identified as a gap in HANDOFF.md
- Explainer diagrams: Superpowers workflow, GSD workflow

**M06 — How AI Actually Works**
- Entirely new conceptual module
- No lab needed (interactive exercise only)
- Explainer diagrams: AI processing pipeline, context window, temperature dial

**M08 — Agent Memory & Knowledge**
- Entirely new module
- Lab: Set up memory + basic RAG with reference app docs
- Explainer diagrams: embeddings/vectorization, RAG pipeline, memory types

**M11 — AgentDev: AI-Assisted IaC**
- Lab: Generate IaC for the reference app (3 tracks)
- This was already identified as a gap in HANDOFF.md
- Explainer diagrams: IaC generation pipeline, common failures

**M12 — AgentDev: Multi-File IaC + Sub-Agents**
- New module combining GSD workflow with sub-agents
- Lab: Build complete CICD pipeline for reference app
- Explainer diagrams: GSD workflow, sub-agents, multi-file output

### Priority 2: ADAPT Existing Modules

**M01 — Welcome + Setup**
- Merge: existing setup guides + new AI Trinity Framework intro
- Add: reference app deployment as part of setup lab
- Existing: setup/SETUP.md, setup/verify.sh, reference-app/Makefile

**M02 — AI Foundations (expand)**
- Existing: course-site/docs/module-01-foundations/ (lab, reading, quiz)
- Add: Domain Expertise → Vocabulary → Context → Results framework
- Add: explicit before/after vocabulary comparison exercise

**M04 — Connecting with MCP (expand from bridge)**
- Existing: course-site/docs/module-03-bridge/ (demo script, reading)
- Expand: full MCP hands-on lab (not just demo)
- Add: cross-platform queries against reference app via MCP

**M07 — Context Engineering (expand from M1 content)**
- Existing: M1 reading has context engineering vs prompt engineering
- Expand: full module with CLAUDE.md building, context stack, context budget
- Add: hands-on lab building CLAUDE.md for reference app

**M13 — Agent Design Patterns (fill gap)**
- Existing: reading/agent-anatomy.md, reading/profile-guide.md
- Gap: conceptual explainers and diagrams not built (HANDOFF noted this)
- Add: workshop exercise (map tasks to patterns)

**M19/M20 — Capstone + Roadmap**
- Existing: partial capstone structure
- Add: presentation template, evaluation rubric, 30-day plan template

### Priority 3: Excalidraw Diagrams (ALL Modules)

55-65 diagrams needed across all 20 modules. None exist yet.
This is the biggest single deliverable for Udemy video content.

### Priority 4: Video Transcripts (ALL Modules)

Voiceover scripts for Udemy course. None exist yet.
Use voiceover-video skill to generate.

---

## Critical Infrastructure Notes

### Reference App vs. Voting App

**Keep the existing reference app.** Here's why:
- All mock data (15+ JSON fixtures) is built around it
- All shell wrappers (mock-aws, mock-kubectl, mock-psql) are designed for it
- All 7 scenarios (clean + messy) reference it
- All 4 agent skills are written for its components
- All 4 agent profiles reference its services
- Helm charts, Makefile, KIND config — all ready
- Prometheus + Grafana monitoring stack included
- Switching would require rebuilding 30+ files

The reference app has everything the voting app would provide (multi-tier, PostgreSQL, K8s, monitoring) and more (Grafana dashboards, Prometheus metrics).

### Mock Mode is a Superpower

The `HERMES_LAB_MODE=mock|live` dual-mode system is brilliant for corporate training:
- Participants without AWS accounts can still do ALL labs
- Mock data is deterministic → consistent experience for everyone
- Live mode for participants who want real infrastructure
- Same skills work against both modes — no code changes

### Naming: Crush vs. Goose vs. OpenCode

Current repo references:
- **Crush** (charmbracelet/crush) — successor to OpenCode after Sept 2025 archive
- The user mentioned **Goose** (block/goose) and **OpenCode** — these are different tools

Recommendation: In the 5-day workshop materials:
- Primary: **Claude Code**
- Alternative 1: **Goose** (open source, desktop app, works with free Gemini)
- Alternative 2: **Crush** (open source, terminal-based, works with free Groq/Gemini)
- Update lab fallback instructions to cover both
- Let participants pick whichever they can install

---

## Proposed Build Sequence

Build the 5-day workshop content in this order:

**Phase 1: Fill Critical Lab Gaps** (needed for delivery)
1. M05 lab (Superpowers/Ansible)
2. M11 lab (IaC generation, 3 tracks)
3. M12 lab (GSD + CICD pipeline)

**Phase 2: Build New Agentic Engineering Modules**
4. M06 conceptual content (How AI Works)
5. M07 expanded lab (Context Engineering)
6. M08 full module (Memory & RAG)

**Phase 3: Adapt Existing Modules for 5-Day Flow**
7. M01 (Trinity Framework + setup expansion)
8. M02 (Domain Expertise framework addition)
9. M04 (MCP expansion from bridge)
10. M13 (Design Patterns conceptual)
11. M19/M20 (Capstone + Roadmap templates)

**Phase 4: Excalidraw Diagrams** (all 20 modules)
12. Create 55-65 B&W whiteboard diagrams

**Phase 5: Video Transcripts** (for Udemy)
13. Generate voiceover transcripts for all modules

---

## Questions for Alignment

1. **Reference app:** Keep existing Rust app or switch to voting app?
2. **Tool naming:** Use Goose as primary alternative (your preference) or Crush (what's in the existing labs)?
3. **Impact Assessment module (old M4):** In the 5-day version, I folded this into M16 (Domain Agents). Should it be a standalone module? It was a useful team exercise.
4. **Day 1 setup timing:** The existing reference app takes ~5 min to deploy (make deploy). Is that acceptable for a 45-min setup lab, or do we need a faster path?
5. **Build approach:** Should we build in the existing `course/` repo structure, or create a parallel `workshop-5day/` structure?
