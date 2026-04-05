# Agentic DevOps — 5-Day Corporate Workshop Master Plan

> **This is the single source of truth** for expanding the existing 3-day/14-module course
> into a 5-day/20-module corporate workshop + Udemy bestseller course.
>
> Each module will be built in its own conversation session. This document provides
> the shared context every session needs to stay aligned.

**Version:** 2026 Edition (5-Day Corporate)
**Trainer:** Gourav Shah (Initcron)
**Duration:** 5 Full Days (6 hours/day, ~30 hours total)
**Level:** Intermediate to Advanced
**Delivery:** Conceptual Explainers → Live Demos → Guided Hands-On Labs
**Also converts to:** Udemy Bestseller Course
**Base repo:** This repo (`course/`) — all 3-day content already built and merged

---

## The AI Trinity Framework

Three pillars. Three stages. One progression: **Passenger → Mechanic → Driver.**

```
PILLAR 1                  PILLAR 2                  PILLAR 3
┌──────────────┐          ┌──────────────┐          ┌──────────────┐
│ AI-Augmented │          │   Agentic    │          │   Agentic    │
│    DevOps    │   ──►    │ Engineering  │   ──►    │    DevOps    │
└──────────────┘          └──────────────┘          └──────────────┘
Use what's already        Understand how             Build agents that
there                     it all works               work for you

Days 1–2                  Days 2–3                   Days 4–5
Platform AI, MCP,         How AI works, Context      Agent patterns,
Harnesses, Coding         Eng, Memory, RAG,          Hermes, Triggers,
Agents                    Tools, Skills              Fleet, Governance
```

---

## Core Philosophy: Domain Expertise IS Your Superpower

**Recurring theme (not a one-off module).** Introduced Day 1, reinforced in every lab.

```
Domain Expertise → Better Vocabulary → Better Context → Better Results
```

A DevOps engineer who says "create a K8s deployment with HPA, PDB, resource limits, and
liveness/readiness probes" gets a precise artifact. A generalist who says "deploy my app
to Kubernetes" gets a generic template. Same AI, wildly different results — because of
VOCABULARY. Your 5 years of experience is what makes AI 10x useful.

This addresses the "AI will replace me" fear head-on. AI amplifies expertise; it doesn't
substitute for it.

---

## Decisions (Locked)

These are resolved and should not be revisited without explicit discussion.

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Reference app | **Keep existing Rust app** | Already built with Helm, monitoring, mock data. All 7+ labs designed around it. 30+ files would need rebuilding if switched. |
| Pillar 2 name | **Agentic Engineering** | MLOps/LLMOps would be misleading (broader discipline). "Engineering" signals hands-on discipline. |
| Impact Assessment | **Folded into M16** (Domain Agents) | Automation Quadrant becomes the intro to "which agent should you build?" on Day 4. Saves a module slot. |
| Primary coding agent | **Claude Code** | Most participants have Claude Pro/Team. Sub-agents built in. |
| Fallback coding agent | **Goose** (Block, open source) | Desktop app, zero install, works with free Gemini. Mention Crush as another option. |
| Agent building platform | **Hermes** (Nous Research) | Open source, auto-installs Python, works with free Gemini/OpenRouter/Groq. |
| LLM fallback | **Google Gemini free tier** | 1M tokens/month free. Universal fallback for participants without Claude subscription. |
| Mock infrastructure | **Keep dual-mode (mock/live)** | `HERMES_LAB_MODE=mock` for offline, `live` for real infra. Least barrier to entry. |
| Master plan location | **This file in course/ repo** | Co-located with content. Module-building sessions reference it directly. |
| Context eng > prompts | **Locked from 3-day version** | "Context engineering" throughout. Zero "prompt engineering" violations. |
| Haiku as default model | **Locked from 3-day version** | All labs designed for cheapest model. Sonnet only for complex reasoning. |

---

## Target Audience

Technology professionals from companies like Adobe, Walmart, Cisco, Visa, Accenture, startups.

**Roles:** Software Developers, DevOps Engineers, SREs, DBAs, Platform Engineers

**What they know:** Software development workflows, CI/CD (GitHub Actions), Docker, Kubernetes basics, at least one IaC tool (Terraform/Ansible), git, CLI tools.

**What's new:** AI coding agents, MCP, context engineering, agentic workflows, agent building.

---

## Least-Barrier-to-Entry Strategy

| Purpose | Primary | Fallback | Free Path |
|---------|---------|----------|-----------|
| AI Coding | Claude Code (Claude sub) | Goose (open source) | Goose + Gemini free tier |
| Agent Building | Hermes (open source) | Claude Code sub-agents | Hermes + Gemini free tier |
| LLM Provider | Claude (subscription) | Google Gemini | 1M tokens/month free |
| Cloud Infra | AWS Free Tier | Mock mode | `HERMES_LAB_MODE=mock` — no cloud needed |
| Kubernetes | KIND (local) | — | Zero cost, runs on laptop |
| Monitoring | Prometheus + Grafana (local) | — | Bundled with reference app |
| Chat Interface | Telegram (free) | Discord (free) | Hermes has built-in gateways |
| Observability AI | Demo only (trainer screen) | — | Datadog/Grafana Sift shown, not required |

**Corporate install constraints:** Claude Code = npm (standard). Goose = desktop app (no deps). Hermes = git clone + auto-installer (provisions own Python). KIND = single binary. All low-friction.

---

## 5-Day Structure

```
DAY 1: Foundations + AI-Augmented DevOps          (Pillar 1 begins)
       "See what AI can already do for you"
       ├── M01  Welcome + AI Trinity Framework + Environment Setup
       ├── M02  AI Foundations for DevOps Teams
       ├── M03  Platform AI — Features Already in Your Stack
       └── M04  Connecting to Everything with MCP

DAY 2: Harnesses + Agentic Engineering            (Pillar 1→2)
       "From using AI to understanding AI"
       ├── M05  Claude Code & Agentic Harnesses (Superpowers / GSD)
       ├── M06  How AI Actually Works — The Engine Under the Hood
       ├── M07  Context Engineering — Beyond Prompts
       └── M08  Agent Memory & Knowledge (Memory, RAG, Vectors)

DAY 3: Tool Wiring + AgentDev                     (Pillar 2 contd.)
       "From understanding AI to building with AI"
       ├── M09  Wiring Tools to Agents (CLI, Wrappers, MCP)
       ├── M10  Agentic Skills — Teaching Agents Your Runbooks
       ├── M11  AgentDev — AI-Assisted Infrastructure as Code
       └── M12  AgentDev — Multi-File Projects with GSD + Sub-Agents

DAY 4: Building Agents                            (Pillar 3 begins)
       "From building with AI to building AI agents"
       ├── M13  Agent Design Patterns & Autonomy Levels
       ├── M14  Building Your First Agent with Hermes
       ├── M15  Triggers, Scheduling & Chat Interfaces
       └── M16  Domain Agents — Real-World Use Cases

DAY 5: Enterprise + Capstone                      (Pillar 3 contd.)
       "From single agents to production agent systems"
       ├── M17  Multi-Agent Systems & Sub-Agents
       ├── M18  Governance — Making Agents Enterprise-Safe
       ├── M19  Capstone — Build Your Agentic DevOps System
       └── M20  30-Day Deployment Roadmap + What's Next
```

---

## Module Details + Content Status

### Legend

| Tag | Meaning |
|-----|---------|
| **REUSE** | Existing content maps directly. Minor edits (renumbering, framing). |
| **ADAPT** | Existing content partially covers this. Needs expansion or restructuring. |
| **NEW** | Content doesn't exist. Needs to be created from scratch. |

---

### DAY 1: Foundations + AI-Augmented DevOps

#### M01 — Welcome + AI Trinity Framework + Environment Setup
**Duration:** 75 min (30 concept + 45 setup lab)
**Status:** ADAPT
**Existing content:** `setup/SETUP.md`, `setup/verify.sh`, `reference-app/Makefile`
**New content needed:**
- AI Trinity Framework explainer (concept + Excalidraw diagrams)
- Evolution timeline: Manual → Scripted → Automated → Agentic
- Human-in-the-loop philosophy explainer
- Setup lab expanded: deploy reference app + connect MCP servers
**Explainer diagrams (3):**
1. The Evolution (Manual → Scripted → Automated → Agentic)
2. The AI Trinity Framework (three pillars)
3. The 5-Day Journey Map

**Lab deliverable:** Working environment — cloud infra + K8s app + AI agent connected

---

#### M02 — AI Foundations for DevOps Teams
**Duration:** 60 min (40 concept + 20 lab)
**Status:** ADAPT
**Existing content:** `course-site/docs/module-01-foundations/` (lab, reading, quiz)
**New content needed:**
- Domain Expertise → Vocabulary → Context → Results framework (NEW explainer)
- AI Spectrum: Chat → Copilot → Agent → Squad (expand existing)
- Agent anatomy with DevOps examples (expand from `reading/agent-anatomy.md`)
- Before/after vocabulary comparison exercise in lab
**Explainer diagrams (4):**
1. The AI Spectrum (Chat → Copilot → Agent → Squad)
2. Agent Anatomy (Brain + Skills + Tools + Guardrails)
3. Domain Expertise Chain (with before/after examples)
4. Context Window as War Room Whiteboard

**Lab deliverable:** Optimized prompt template + proof that vocabulary matters

---

#### M03 — Platform AI — Features Already in Your Stack
**Duration:** 75 min (25 concept + 50 lab)
**Status:** REUSE
**Existing content:** `course-site/docs/module-02-platform-ai/` (lab, reading, quiz)
**Changes:** Renumber from M2→M03. Add Excalidraw diagrams. Minor framing updates.
**Explainer diagrams (3):**
1. Platform AI Landscape (AWS, Datadog, Grafana features)
2. The Platform AI Gap (covers vs. missing)
3. Before/After: Manual vs. Platform AI

**Lab deliverable:** Written assessment of platform AI capabilities and gaps

---

#### M04 — Connecting to Everything with MCP
**Duration:** 75 min (25 concept + 50 lab)
**Status:** ADAPT
**Existing content:** `course-site/docs/module-03-bridge/` (demo, reading, quiz)
**New content needed:**
- Full MCP explainer (USB-C analogy, architecture, ecosystem)
- Hands-on MCP wiring lab (not just demo observation)
- Cross-platform query exercises against reference app
- Goose + MCP alternative path
**Explainer diagrams (3):**
1. MCP as USB-C (universal connector analogy)
2. MCP Architecture (Client → Server → Tool/Resource)
3. Before/After: 5 separate tools vs. one agent with MCP

**Lab deliverable:** Claude Code connected to 4+ MCP servers, cross-platform queries working

---

### DAY 2: Harnesses + Agentic Engineering

#### M05 — Claude Code & Agentic Harnesses
**Duration:** 90 min (25 concept + 65 lab)
**Status:** NEW
**Existing content:** Was listed as gap in COMPLETED-HANDOFF.md (Module 5 lab not built)
**New content needed (all):**
- Superpowers workflow explainer (Brainstorm → Design → Blueprint → Implement → Validate)
- GSD workflow explainer (spec-driven for multi-file)
- Lab: Superpowers workflow → Ansible playbook for reference app EC2 hardening
- Before/after comparison: unstructured prompt vs. Superpowers
- Goose/Crush fallback instructions
**Explainer diagrams (3):**
1. Superpowers Workflow (5-phase pipeline)
2. GSD Workflow (spec → implement → validate)
3. Harness Comparison (unstructured vs. Superpowers vs. GSD)

**Lab deliverable:** Validated Ansible playbook created through structured workflow

---

#### M06 — How AI Actually Works — The Engine Under the Hood
**Duration:** 60 min (45 concept + 15 interactive)
**Status:** NEW
**Existing content:** Some foundation in M01 reading (`concepts.mdx` covers tokenization, inference)
**New content needed:**
- Prefill and Decode phases with timing
- TTFT and token generation speed
- Context window mechanics (why more isn't always better)
- Temperature/top-p with DevOps sweet spot
- Interactive exercise: measure TTFT with different context sizes
**Explainer diagrams (3):**
1. AI Processing Pipeline (Input → Prefill → Decode → Output)
2. Context Window as RAM (what fills it, what gets pushed out)
3. Temperature Dial (Creative ↔ Consistent) with DevOps sweet spot

**Lab deliverable:** Mental model of AI processing (no code deliverable — interactive exercise)

---

#### M07 — Context Engineering — Beyond Prompts
**Duration:** 75 min (30 concept + 45 lab)
**Status:** ADAPT
**Existing content:** M01 reading has context engineering content, CLAUDE.md philosophy section
**New content needed:**
- Full Context Stack explainer (system prompt → CLAUDE.md → skills → memory → tools → conversation)
- Context budgeting concept (signal-to-noise, what to include vs. exclude)
- Domain Expertise reinforced: your knowledge IS the context
- Lab: build CLAUDE.md for reference app project
- Comparison exercise: same question with minimal vs. rich context
**Explainer diagrams (4):**
1. Prompt vs. Context Engineering (iceberg analogy)
2. The Context Stack (layers)
3. Context Budget (priority order)
4. Domain Expertise in Action (same question, different vocabulary, different results)

**Lab deliverable:** CLAUDE.md + system prompt template for the reference app

---

#### M08 — Agent Memory & Knowledge
**Duration:** 75 min (35 concept + 40 lab)
**Status:** NEW
**Existing content:** None
**New content needed (all):**
- Memory types: short-term, long-term, shared
- Vectorization and embeddings (GPS coordinates analogy)
- Semantic search vs. keyword search
- RAG pipeline: Query → Vectorize → Search → Retrieve → Augment → Generate
- Agentic RAGs: agents that decide what/when to look up
- Decision tree: Memory vs. RAG vs. Context Engineering
- Lab: set up memory + basic RAG with reference app docs
**Explainer diagrams (5):**
1. The Memory Problem (stateless vs. memory-equipped agent)
2. Embeddings & Vectorization (GPS analogy)
3. Semantic Search vs. Keyword Search
4. RAG Pipeline (6-step flow)
5. Decision Tree: Memory vs. RAG vs. Context

**Lab deliverable:** Working memory setup + basic RAG pipeline

---

### DAY 3: Tool Wiring + AgentDev

#### M09 — Wiring Tools to Agents
**Duration:** 60 min (20 concept + 40 lab)
**Status:** REUSE
**Existing content:** `modules/module-08-tools/LAB.md` (~350 lines, starter + solution)
**Also:** `reading/tool-patterns.md` (611 lines)
**Changes:** Renumber from M8→M09. Add Excalidraw diagrams. Minor framing.
**Explainer diagrams (3):**
1. Three Tool Patterns (CLI → Wrapper → MCP)
2. Safety Layer Architecture (Agent → Wrapper → Infrastructure)
3. Decision Matrix: which pattern for which use case

**Lab deliverable:** Working safe tool wrappers with safety configuration

---

#### M10 — Agentic Skills — Teaching Agents Your Runbooks
**Duration:** 90 min (30 concept + 60 lab)
**Status:** REUSE
**Existing content:** `modules/module-07-skills/LAB.md` (~400 lines), 4 SKILL.md files, SKILL-TEMPLATE.md, RUBRIC.md
**Also:** `reading/skills-guide.md` (618 lines)
**Changes:** Renumber from M7→M10. Add Excalidraw diagrams. Frame as "Domain Expertise made tangible."
**Explainer diagrams (3):**
1. From Runbook to Skill (before/after)
2. Anatomy of a SKILL.md
3. Skill Lifecycle (Design → Validate → Version → Deploy → Improve)

**Lab deliverable:** Complete SKILL.md with peer review

---

#### M11 — AgentDev: AI-Assisted Infrastructure as Code
**Duration:** 90 min (20 concept + 70 lab)
**Status:** NEW
**Existing content:** Was listed as gap in COMPLETED-HANDOFF.md (Module 6 lab not built)
**New content needed (all):**
- Superpowers workflow applied to IaC
- Common AI failure modes in IaC (missing security groups, hardcoded values, etc.)
- Human review checkpoint concept
- Lab: 3 tracks generating IaC for the reference app
  - Track A (Terraform): RDS module + CloudWatch alarms
  - Track B (Ansible): PostgreSQL setup + monitoring agents
  - Track C (Kubernetes): Deployment with HPA, PDB, probes
**Explainer diagrams (3):**
1. IaC Generation Pipeline (5-phase with Superpowers)
2. Common AI IaC Failures (and the safety net)
3. Human-AI IaC Workflow (review checkpoints)

**Lab deliverable:** Production-quality IaC artifact, validated

---

#### M12 — AgentDev: Multi-File Projects with GSD + Sub-Agents
**Duration:** 75 min (20 concept + 55 lab)
**Status:** NEW
**Existing content:** None (GSD mentioned in concepts but no lab)
**New content needed (all):**
- GSD workflow for multi-file projects
- Sub-agents in Claude Code (coordinator → specialists)
- CICD pipeline as multi-file example
- Lab: Write GSD spec → Claude Code generates full CICD pipeline for reference app
  - GitHub Actions workflow
  - Dockerfile improvements
  - K8s manifests for staging/production
  - Sub-agent demonstration
**Explainer diagrams (3):**
1. GSD Workflow (Spec → Implement → Review → Iterate)
2. Sub-Agents (coordinator → specialists)
3. Multi-File Project Output

**Lab deliverable:** Complete CICD pipeline project via GSD

---

### DAY 4: Building Agents

#### M13 — Agent Design Patterns & Autonomy Levels
**Duration:** 60 min (40 concept + 20 workshop exercise)
**Status:** ADAPT
**Existing content:** `reading/agent-anatomy.md` (511 lines), `reading/profile-guide.md` (583 lines)
**New content needed:**
- Single-agent patterns explainer (Advisor → Investigator → Proposal → Guardian)
- Multi-agent patterns (Sequential, Parallel, Hierarchical)
- Autonomy Spectrum (L1-L4) — exists in governance YAML but needs conceptual explainer
- Workshop exercise: map 3 tasks to patterns, assign autonomy levels
**Explainer diagrams (4):**
1. Single-Agent Patterns (4 patterns)
2. Autonomy Spectrum (L1→L4 progression)
3. Multi-Agent Patterns (3 modes)
4. Agent Architect Role (you become the orchestrator)

**Lab deliverable:** Agent architecture sketch for top automation candidate

---

#### M14 — Building Your First Agent with Hermes
**Duration:** 90 min (25 concept + 65 lab)
**Status:** REUSE
**Existing content:** `modules/module-10-agents/` (3 track labs, ~500 lines each, starter + solution)
**Also:** 4 agent profiles in `agents/`, setup in `setup/install-hermes.md`
**Changes:** Renumber from M10→M14. Add Excalidraw diagrams. Frame with Hermes architecture.
**Explainer diagrams (3):**
1. Agent Definition Anatomy (model + instructions + tools + skills + safety)
2. Hermes Architecture (agent core + tools + gateways + memory)
3. From Definition to Running Agent

**Lab deliverable:** Working Hermes agent against reference app infrastructure

---

#### M15 — Triggers, Scheduling & Chat Interfaces
**Duration:** 75 min (25 concept + 50 lab)
**Status:** REUSE
**Existing content:** `modules/module-12-triggers/LAB.md` (657 lines) + cron starter YAML
**Changes:** Renumber from M12→M15. Add Excalidraw diagrams. Add Telegram setup instructions.
**Explainer diagrams (4):**
1. Five Trigger Patterns (schedule, chat, webhook, code event, ticket)
2. Webhook Flow (alarm → SNS → agent → Slack/Telegram)
3. Chat Interface Pattern (Telegram/Slack as command center)
4. Mission Control Dashboard concept

**Lab deliverable:** Agent with cron + chat command + webhook trigger

---

#### M16 — Domain Agents — Real-World Use Cases
**Duration:** 75 min (20 concept + 55 lab)
**Status:** ADAPT
**Existing content:** Module 10 track labs cover domain agents. Module 4 Impact Assessment content.
**New content needed:**
- Automation Quadrant explainer (folded in from old M4)
- Domain agent gallery (DB, Cost, K8s, RCA, Deployment Safety)
- Scoring exercise: which tasks should become agents?
- Lab continues the Day 4 agent project — adds domain specialization
**Explainer diagrams (3):**
1. Domain Agent Gallery (5 agents with responsibilities)
2. Automation Quadrant (frequency × complexity)
3. Agent Specialization (base agent + domain skill)

**Lab deliverable:** Domain agent with skills, tools, and at least one trigger

---

### DAY 5: Enterprise + Capstone

#### M17 — Multi-Agent Systems & Sub-Agents
**Duration:** 75 min (30 concept + 45 lab)
**Status:** REUSE
**Existing content:** `modules/module-11-fleet/LAB.md` (626 lines)
**Changes:** Renumber from M11→M17. Add Excalidraw diagrams. Add Claude Code sub-agent demo.
**Explainer diagrams (4):**
1. Single vs. Multi-Agent (when you need more than one)
2. Sub-Agent Pattern in Claude Code
3. Fleet Coordination Modes
4. Cross-Domain Incident Resolution

**Lab deliverable:** Multi-agent config coordinating 3 domain agents

---

#### M18 — Governance — Making Agents Enterprise-Safe
**Duration:** 75 min (30 concept + 45 lab)
**Status:** REUSE
**Existing content:** `modules/module-13-governance/LAB.md` (720 lines), 6 governance YAMLs
**Also:** `reading/governance-ref.md` (513 lines)
**Changes:** Renumber from M13→M18. Add Excalidraw diagrams.
**Explainer diagrams (4):**
1. Governance Triad (CAN do × APPROVAL × LOGGED)
2. Maturity Progression (L1→L4 with promotion criteria)
3. Enterprise Safety Architecture
4. Approval Workflow

**Lab deliverable:** Governance config passing enterprise security standards

---

#### M19 — Capstone: Build Your Agentic DevOps System
**Duration:** 120 min (80 build + 40 presentations)
**Status:** ADAPT
**Existing content:** Module 14 partial structure
**New content needed:**
- Presentation template
- Evaluation rubric
- Build phase checklist
- Presentation format and timing guide
**No diagrams — this is a build + present module.**

**Lab deliverable:** Complete agent system — config, skills, triggers, governance

---

#### M20 — 30-Day Deployment Roadmap + What's Next
**Duration:** 45 min (30 guided + 15 reflection)
**Status:** ADAPT
**Existing content:** Module 14 had 30-day plan concept
**New content needed:**
- 30-day plan template (Week 1-4 with specific milestones)
- "What's Next" content (landscape, community, advanced topics)
- Reflection exercise
**No diagrams — guided exercise module.**

**Lab deliverable:** Written 30-day deployment plan

---

## Content Scorecard

| Status | Modules | Count |
|--------|---------|-------|
| REUSE | M03, M09, M10, M14, M15, M17, M18 | 7 |
| ADAPT | M01, M02, M04, M07, M13, M16, M19, M20 | 8 |
| NEW | M05, M06, M08, M11, M12 | 5 |
| **Total** | | **20** |

**Estimated diagrams:** ~62 across all modules (none exist yet)
**Estimated new lab content:** ~5 complete labs to write
**Estimated adaptation work:** ~8 modules to restructure/expand

---

## Build Sequence (Priority Order)

Each module gets its own conversation session. This sequence ensures dependencies flow correctly and we front-load the hardest new content.

### Phase 1: Fill Critical Lab Gaps (NEW labs)
Build the 5 modules that don't exist yet. These are the hardest and most important.

| Order | Module | Dependency | Estimated Effort |
|-------|--------|------------|-----------------|
| 1 | M05 | None (standalone workflow) | Medium — Ansible lab |
| 2 | M06 | None (conceptual only) | Light — no lab, diagrams + reading |
| 3 | M08 | M06 concepts | Heavy — RAG pipeline lab |
| 4 | M11 | M05 harness patterns | Heavy — 3-track IaC lab |
| 5 | M12 | M11 + M05 GSD | Medium — CICD pipeline lab |

### Phase 2: Adapt Existing Modules (expand + restructure)
These have existing content that needs framing updates for the 5-day flow.

| Order | Module | Main Change |
|-------|--------|-------------|
| 6 | M01 | Add Trinity Framework explainer, expand setup lab |
| 7 | M02 | Add Domain Expertise framework, vocabulary exercise |
| 8 | M04 | Expand from bridge demo to full MCP hands-on lab |
| 9 | M07 | Expand M01 context eng content into full module |
| 10 | M13 | Add design patterns explainers (was noted gap) |
| 11 | M16 | Merge Impact Assessment + domain agent framing |
| 12 | M19 | Create capstone templates, rubric |
| 13 | M20 | Create 30-day plan template, "what's next" content |

### Phase 3: Add Diagrams to REUSE Modules
These modules are content-complete but need Excalidraw visuals.

| Order | Module | Diagrams Needed |
|-------|--------|----------------|
| 14 | M03 | 3 diagrams |
| 15 | M09 | 3 diagrams |
| 16 | M10 | 3 diagrams |
| 17 | M14 | 3 diagrams |
| 18 | M15 | 4 diagrams |
| 19 | M17 | 4 diagrams |
| 20 | M18 | 4 diagrams |

### Phase 4: Video Transcripts (Udemy)
Generate voiceover transcripts for all 20 modules using the voiceover-video skill.

### Phase 5: Instructor Guides
Update Day 1-3 guides + create Day 4-5 guides for the expanded workshop.

---

## Module-Building SOP

Each module gets built in its own conversation session. Here's the process:

### Starting a Module Session

Every session should begin by reading:
1. This file (`WORKSHOP-5DAY.md`) — for overall context and the specific module brief
2. `CLAUDE.md` — for repo conventions and constraints
3. `COMPLETED-HANDOFF.md` — for understanding what's already built
4. Any existing content referenced in the module's "Existing content" field above

### What Each Session Produces

For **NEW** modules:
```
modules/module-NN-name/
├── README.md              # Module overview, objectives, prerequisites
├── explainer/
│   ├── EXPLAINER.md       # Concept notes for each explainer diagram
│   └── diagrams/          # Excalidraw PNG exports (generated via skill)
├── reading/
│   ├── concepts.md        # Core concepts (standalone readable text)
│   └── reference.md       # Quick-reference material
├── lab/
│   ├── LAB.md             # Step-by-step lab instructions
│   ├── starter/           # Starting files for participants
│   └── solution/          # Complete reference solutions
├── quiz/
│   └── QUIZ.md            # 5-7 questions + answers
└── exploratory/
    └── PROJECTS.md        # Optional stretch projects
```

For **ADAPT** modules:
- Update existing content in place
- Add new sections (e.g., Domain Expertise framework)
- Create any missing components (diagrams, expanded lab sections)

For **REUSE** modules:
- Add Excalidraw diagrams only
- Minor renumbering and framing edits

### Quality Checks

Every module session should verify:
- [ ] Lab uses ONLY components deployed in previous modules (check dependency chain)
- [ ] Lab works in mock mode (`HERMES_LAB_MODE=mock`) for offline participants
- [ ] Lab has both starter/ and solution/ files where applicable
- [ ] No "prompt engineering" terminology — use "context engineering"
- [ ] Domain Expertise theme reinforced where natural
- [ ] Free-tier path documented (Goose + Gemini fallback)
- [ ] Completable solo (no team-exercise dependencies for Udemy)
- [ ] Estimated timing fits within module duration
- [ ] References correct module numbers (new 5-day numbering)

---

## Infrastructure Dependency Chain

Each module ONLY uses infrastructure available from earlier modules. This chain must be respected.

```
M01 (setup) deploys:
├── KIND cluster with reference app (Helm)
├── PostgreSQL (via Helm in KIND)
├── Prometheus + Grafana (via Helm in KIND)
├── AWS free tier (EC2 t2.micro, optional RDS db.t3.micro)
├── MCP servers connected (kubectl, aws, github, postgres)
└── Mock data available (HERMES_LAB_MODE=mock as default)

M01 → everything depends on this
M05 → needs EC2 from M01 (Ansible target)
M08 → needs reference app docs (already in repo)
M09 → needs kubectl + aws cli from M01
M10 → needs reference app + Claude Code from M01
M11 → needs all M01 infra + M05 harness knowledge
M12 → needs M11 IaC + M05 GSD knowledge
M14 → needs all M01 infra + M10 skills + Hermes install
M15 → needs M14 agent + Telegram (free, instant setup)
M16 → continues M14 agent
M17 → needs M16 agents (team exercise combines tracks)
M18 → needs M16 agent
M19 → needs everything
```

---

## Coordination Between Sessions

Since each module is built in a separate conversation, coordination happens through files:

1. **This document** (`WORKSHOP-5DAY.md`) — overall plan, read at session start
2. **Module README.md** — each module's README documents what it covers and its dependencies
3. **Lab files** — each LAB.md explicitly lists prerequisites
4. **`COMPLETED-HANDOFF.md`** — update after each module is complete
5. **Git commits** — each session should commit its work with clear messages

After completing a module, update `COMPLETED-HANDOFF.md` with:
- What was built
- Any deviations from this plan
- Dependencies verified
- Known issues or testing needed

---

## Custom Skills to Consider Building

As we develop content, these production skills could speed up the work:

| Skill | Purpose | When to Build |
|-------|---------|---------------|
| `module-builder` | Scaffolds a new module directory with all required files | Before Phase 1 |
| `lab-writer` | Writes step-by-step lab guides following our conventions | Before Phase 1 |
| `quiz-generator` | Generates quiz questions from lab + reading content | Before Phase 2 |
| `diagram-planner` | Plans Excalidraw diagrams from module concepts | Before Phase 3 |
| `udemy-transcript` | Generates voiceover transcripts in trainer's voice | Before Phase 4 |

The `excalidraw-bw` and `voiceover-video` skills already exist. We may need to tune them after testing.

---

## What Participants Take Home (Day 5)

1. The AI Trinity Framework as their adoption roadmap
2. Working AI coding agent setup (Claude Code or Goose) with MCP connections
3. Understanding of how AI works (prefill/decode, context, memory, RAG)
4. Domain-specific agentic skills (SKILL.md files)
5. Production-quality IaC generated by AI
6. A complete CICD pipeline generated through GSD workflow
7. A working Hermes agent with triggers (cron, chat, webhook) and governance
8. A 30-day deployment plan for their organization
