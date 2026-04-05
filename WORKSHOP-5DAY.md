# Agentic DevOps — Workshop Master Plan

> **Single source of truth** for the Agentic DevOps workshop and Udemy course.
> Organized as a sequential module catalog — adapt to 3-day, 4-day, or 5-day delivery
> by marking modules as core vs. optional.
>
> Each module gets built in its own conversation session. This document provides
> the shared context every session needs.

**Trainer:** Gourav Shah (Initcron)
**Level:** Intermediate to Advanced
**Delivery:** Conceptual Explainers → Live Demos → Guided Hands-On Labs
**Also:** Udemy Bestseller Course (self-paced)
**Base repo:** This repo (`course/`) — existing 3-day content already built and merged

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

Platform AI, MCP,         How AI works, Context      Agent patterns,
AI-assisted coding        Eng, Harnesses, Memory,    Hermes, Triggers,
                          RAG, Tools, Skills         Fleet, Governance
```

---

## Core Philosophy: Domain Expertise IS Your Superpower

Recurring theme, not a one-off module. Introduced in M02, reinforced in every lab.

```
Domain Expertise → Better Vocabulary → Better Context → Better Results
```

AI amplifies expertise; it doesn't substitute for it. The DevOps engineer who says
"create a K8s deployment with HPA, PDB, resource limits, and liveness/readiness probes"
gets a precise artifact. The generalist who says "deploy my app to Kubernetes" gets a
generic template. Same AI, wildly different results — because of VOCABULARY.

---

## Decisions (Locked)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Reference app | Keep existing Rust app | Built with Helm, monitoring, mock data. All labs designed around it. |
| Pillar 2 name | Agentic Engineering | MLOps would be misleading. "Engineering" signals discipline. |
| Impact Assessment | Folded into M16 | Automation Quadrant becomes intro to domain agents. |
| Primary coding agent | Claude Code | Most participants have Claude Pro/Team. Sub-agents built in. |
| Fallback coding agent | Crush (Charm, formerly OpenCode) | Open source, terminal-based, works with free Groq/Gemini via `/connect`. |
| Agent building | Hermes (Nous Research) | Open source, works with free Gemini/OpenRouter/Groq. |
| LLM fallback | Google Gemini free tier | 1M tokens/month free. Universal fallback. |
| Mock infra | Keep dual-mode (mock/live) | `HERMES_LAB_MODE=mock` for offline, `live` for real infra. |
| Context eng > prompts | Locked | Zero "prompt engineering" violations. |
| Infrastructure | Docker/local-first | ALL labs have a Docker/KIND/local path. Cloud (AWS) always optional. |

---

## Target Audience

Tech professionals from companies like Adobe, Walmart, Cisco, Visa, Accenture, startups.
Roles: Software Developers, DevOps Engineers, SREs, DBAs, Platform Engineers.

**Know:** Dev workflows, CI/CD, Docker, K8s basics, Terraform/Ansible, git, CLI tools.
**New to them:** AI coding agents, MCP, context engineering, agentic workflows, agent building.

---

## Least-Barrier-to-Entry Strategy

| Purpose | Primary | Fallback | Free Path |
|---------|---------|----------|-----------|
| AI Coding | Claude Code | Crush (open source) | Crush + Gemini free |
| Agent Building | Hermes | Claude Code sub-agents | Hermes + Gemini free |
| LLM Provider | Claude (subscription) | Google Gemini | 1M tokens/month free |
| Infrastructure | KIND + Docker (local) | Mock mode | `HERMES_LAB_MODE=mock` |
| Cloud (optional) | AWS Free Tier | Mock data | Static JSON fixtures |
| Kubernetes | KIND (local) | — | Zero cost |
| Monitoring | Prometheus + Grafana (local) | — | Bundled with ref app |
| Chat Interface | Telegram (free) | Discord (free) | Hermes built-in |

**Infrastructure philosophy:** Every lab runs locally with Docker + KIND. AWS is always
an optional enhancement, never a requirement. Participants without cloud access complete
100% of the course using mock data and local infrastructure.

---

## Module Catalog

20 modules in sequential order. Each module has a delivery tag:

| Tag | Meaning |
|-----|---------|
| **CORE** | Must include in any delivery format (3/4/5 day) |
| **RECOMMENDED** | Include in 4+ day delivery. Can condense or skip for 3-day. |
| **OPTIONAL** | Include in 5-day delivery. Skip or set as self-study for shorter formats. |

Content status tags:

| Tag | Meaning |
|-----|---------|
| **REUSE** | Existing content maps directly. Minor edits needed. |
| **ADAPT** | Existing content partially covers this. Needs expansion. |
| **NEW** | Needs to be created from scratch. |

---

### PILLAR 1: AI-Augmented DevOps
*"Use what's already there"*

---

#### M01 — Welcome + AI Trinity Framework + Environment Setup
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `setup/SETUP.md`, `setup/verify.sh`, `reference-app/Makefile`

**Concept (Explainer):**
- Why Agentic DevOps matters in 2026: Manual → Scripted → Automated → Agentic
- The AI Trinity Framework: three pillars, three stages
- Driving analogy: Passenger → Mechanic → Driver
- What agents DON'T replace (human-in-the-loop philosophy)
- Your domain expertise IS your superpower (first introduction)
- Workshop roadmap: what we build by the end

**New content needed:**
- AI Trinity Framework explainer + diagrams
- Evolution timeline explainer
- Setup lab expanded: deploy ref app + install AI tools

**Diagrams (3):**
1. Evolution: Manual → Scripted → Automated → Agentic
2. AI Trinity Framework (three pillars)
3. Workshop Journey Map

**Lab:** Deploy workshop environment (Docker/local-first)
- Verify tools: docker, kind, kubectl, helm, git, Claude Code or Crush
- Deploy reference app to KIND (`make deploy`)
- Connect MCP servers (kubectl, github, postgres)
- Smoke test: cross-platform query via Claude Code or Crush
- Optional: deploy AWS free-tier infra (provided Terraform)
- Optional: connect AWS MCP server

**Deliverable:** Working local environment — K8s app + monitoring + AI agent connected

---

#### M02 — AI Foundations for DevOps Teams
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `course-site/docs/module-01-foundations/` (lab, reading, quiz)

**Concept (Explainer):**
- How LLMs work — through a DevOps lens
  - LLM = experienced colleague who read every Stack Overflow answer but needs clear instructions
- Tokens, context windows, temperature — through operational analogies
  - Context window = war room whiteboard (limited space)
  - Temperature = creative vs. conservative dial
- The AI Spectrum: Chat → Copilot → Agent → Squad
- Agent anatomy: Brain (LLM) + Skills (runbooks) + Tools (CLI/MCP) + Guardrails (approvals)
- **Domain Expertise Framework:** Expertise → Vocabulary → Context → Results
  - Before/after example with K8s terminology
  - Your 5 years of experience is what makes AI 10x useful

**New content needed:**
- Domain Expertise framework explainer + diagram
- Vocabulary comparison exercise in lab
- Expand AI Spectrum section

**Diagrams (4):**
1. AI Spectrum (Chat → Copilot → Agent → Squad)
2. Agent Anatomy (Brain + Skills + Tools + Guardrails)
3. Domain Expertise Chain (Expertise → Vocabulary → Context → Results)
4. Context Window as War Room Whiteboard

**Lab:** First AI conversation with real operational data
- CloudWatch alarm JSON from reference app (local Prometheus alert data as alternative)
- Progressive exercise: vague → structured → context-rich
- Vocabulary comparison: "non-DevOps" vs. "SRE with 5 years" — same alarm

**Deliverable:** Optimized context template + proof that vocabulary matters

---

#### M03 — Platform AI — Features Already in Your Stack
**Delivery:** CORE · **Status:** REUSE

**Existing:** `course-site/docs/module-02-platform-ai/` (lab, reading, quiz)

**Concept (Explainer):**
- Platform AI = AI features built into tools you already pay for
- AWS: Q Developer, DevOps Guru, Cost Anomaly Detection, RDS Performance Insights
- Observability AI: Datadog Watchdog, Grafana Sift, CloudWatch anomaly detection
- What platform AI does well / where it falls short
- The gap between platform AI and custom agents

**Changes from existing:** Renumber M2→M03. Add Excalidraw diagrams.

**Diagrams (3):**
1. Platform AI Landscape (features across AWS, Datadog, Grafana)
2. The Platform AI Gap (covers vs. missing)
3. Before/After: Manual investigation vs. Platform AI

**Lab:** Discover platform AI (hands-on + trainer demo)
- Hands-on (free tier): RDS Performance Insights, CloudWatch Anomaly Detection, Cost Explorer, Q Developer
- Trainer demo (paid tools): DevOps Guru, Datadog Watchdog, Grafana Sift
- Local alternative: explore Grafana Sift on local Grafana (bundled with ref app)

**Deliverable:** Written assessment of platform AI capabilities and gaps

---

#### M04 — Connecting to Everything with MCP
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `course-site/docs/module-03-bridge/` (demo, reading, quiz)

**Concept (Explainer):**
- MCP = the USB-C of AI (universal connector analogy)
- MCP architecture: Client ↔ Server ↔ Tool/Resource
- MCP vs. direct CLI vs. API calls — when to use what
- MCP ecosystem: servers for AWS, K8s, GitHub, Postgres, Datadog, Grafana
- Claude Code + MCP vs. Crush + MCP (both work)

**New content needed:**
- Full MCP explainer (existing was a "bridge" demo, needs hands-on lab)
- Cross-platform query exercises against reference app

**Diagrams (3):**
1. MCP as USB-C (universal connector)
2. MCP Architecture (Client → Server → Tool/Resource)
3. Before/After: 5 separate tools vs. one agent with MCP

**Lab:** Cross-platform intelligence (local-first)
- Build on MCP connections from M01 setup
- Cross-platform queries: "Which pods restarted and what were the DB metrics?"
- Add PostgreSQL direct MCP server (connecting to KIND-hosted Postgres)
- Optional: same queries via Crush

**Deliverable:** 4+ MCP servers connected, cross-platform queries working

---

### PILLAR 2: Agentic Engineering
*"Understand how it all works"*

**Sequence rationale:** Context Engineering is THE foundational skill. You need to
understand how AI processes context BEFORE learning structured workflows (harnesses)
that leverage it. Then: apply harnesses to real IaC projects, extend agent knowledge
with memory/RAG, and finally build the components (tools, skills) that agents in
Pillar 3 will use.

```
How AI Works → Context Eng → Superpowers → IaC → GSD → Memory → Tools → Skills
(foundation)   (core skill)  (workflow)    (apply) (scale) (extend) (wire) (encode)
```

---

#### M05 — How AI Actually Works — The Engine Under the Hood
**Delivery:** RECOMMENDED · **Status:** NEW

**Existing:** Some foundation in M01 reading (tokenization, inference basics)

**Concept (Explainer):**
- Full journey: what happens when you type in Claude/ChatGPT
- Prefill phase: reads entire input (like reading the whole email before replying)
- Decode phase: generates token by token (like typing reply word by word)
- TTFT (Time to First Token): why there's a pause
- Why this matters for agents: longer context = longer prefill = slower
- Context windows as RAM (there's a ceiling, more isn't always better)
- Temperature: creativity vs. consistency dial (DevOps sweet spot = low)

**Diagrams (3):**
1. AI Processing Pipeline (Input → Prefill → Decode → Output with timing)
2. Context Window as RAM
3. Temperature Dial with DevOps sweet spot

**Interactive exercise:** Experiment with context sizes, measure TTFT, visualize tokens

**Deliverable:** Mental model of AI processing (no code — interactive exercise)

---

#### M06 — Context Engineering — Beyond Prompts
**Delivery:** CORE · **Status:** ADAPT

**Existing:** M01 reading has context engineering content, CLAUDE.md philosophy,
module-05b has CLAUDE.md creation lab

**Concept (Explainer):**
- Prompt = the question. Context = the environment you set up BEFORE asking.
  - Like giving a new hire the codebase, docs, and runbook before asking them to fix a bug
- The Context Stack: system prompt → CLAUDE.md → skills → memory → tools → conversation
- Context budgeting: signal-to-noise ratio, what to include vs. exclude
- Domain Expertise reinforced: your knowledge IS the context
  - "check voting-app PostgreSQL for long-running transactions blocking COPY" vs. "check if DB is slow"

**New content needed:** Expand M01 content into full module. CLAUDE.md building lab.

**Diagrams (4):**
1. Prompt vs. Context Engineering (iceberg — prompt is the visible tip)
2. The Context Stack (layers)
3. Context Budget (priority order)
4. Domain Expertise in Action (same question, different vocabulary, different results)

**Lab:** Build your context stack
- Create CLAUDE.md for reference app project
- Design system prompt for operational agent
- Experiment: minimal context vs. rich context → measure quality difference

**Deliverable:** CLAUDE.md + system prompt template

**Why this comes before harnesses:** Superpowers and GSD workflows are structured
approaches to APPLYING context engineering. You need the foundation first — otherwise
harnesses feel mechanical without understanding WHY they work.

---

#### M07 — Agentic Harnesses: The Superpowers Workflow
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `course-site/docs/module-05a-structured-coding/` (2 track labs with
starter/solution, reading, quiz)

**Concept (Explainer):**
- Agentic Harnesses = structured workflows wrapping AI coding agents
- Superpowers: Brainstorm → Design → Blueprint → Implement → Validate
  - Like an architect — you don't start pouring concrete without plans
- Each phase builds context for the next (context engineering in action!)
- Provider-agnostic: works with Claude Code, Crush, any coding agent
- Before/after: unstructured "just build it" vs. 5-phase structured approach

**Diagrams (3):**
1. Superpowers Workflow (5-phase pipeline with context flow)
2. Before/After: Unstructured vs. Superpowers quality comparison
3. Harness as Context Pipeline (each phase adds context)

**Lab:** Superpowers workflow in action (choose a track)
- Track A (K8s/Platform): Build production Helm chart with HPA, PDB, probes, ServiceMonitor
- Track B (DevOps/Release): Build GitHub Actions CI/CD pipeline with matrix testing, OIDC, staging/prod
- Track C (Infra): Build Ansible playbook for server hardening
- Each track: explicit 5-phase walkthrough, before/after quality comparison
- All tracks run locally (KIND for Track A, dry-run for Track B, localhost for Track C)

**Deliverable:** Production-quality artifact via structured 5-phase workflow

**Note:** M07 teaches the WORKFLOW (Superpowers as a pattern). M08 applies it to IaC
with domain-specific depth (failure modes, validation, drift). Different purpose.

---

#### M08 — AgentDev: AI-Assisted Infrastructure as Code
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `course-site/docs/module-06-ai-iac/` (2 track labs with starter/solution,
reading, quiz — Terraform Track A, GitOps Track B)

**Concept (Explainer):**
- Context engineering for IaC generation: what AI needs to know about your infra
- Common AI failure modes in IaC: generic names, missing security groups, hardcoded values,
  no state locking, wrong defaults
- Validation pipeline: generate → lint → plan → review → test → apply
- Starter-to-solution technique: give AI a skeleton, let it fill in the details
- Human review checkpoints: AI proposes, human validates

**Diagrams (3):**
1. IaC Generation Pipeline (with validation gates)
2. Common AI IaC Failures (gallery of pitfalls)
3. Human-AI IaC Workflow (review checkpoints)

**Lab:** Generate real IaC for reference app (choose a track)
- Track A (Terraform): EC2/CloudWatch/SNS module — uses Terraform mock provider for
  local validation, AWS free tier optional
- Track B (GitOps): ArgoCD-based deployment of reference app on KIND — fully local
- Both tracks: starter-to-solution technique, guided generation, validation pipeline

**Deliverable:** Production-quality IaC artifact, validated locally

**Why this isn't repetitive with M07:** M07 teaches the 5-phase workflow as a general
pattern (using Helm/CI/CD/Ansible as vehicles). M08 dives deep into IaC-specific
concerns: failure modes, drift, validation pipelines, state management. The focus
shifts from "how to structure your AI interaction" to "what domain knowledge IaC needs."

---

#### M09 — AgentDev: GSD + Multi-File Projects + Sub-Agents
**Delivery:** RECOMMENDED · **Status:** ADAPT

**Existing:** `course-site/docs/module-05b-ai-workflows/` (GSD lab, CLAUDE.md,
memory, plan modes)

**Concept (Explainer):**
- When Superpowers isn't enough: multi-file, multi-component projects
- GSD workflow: write spec first, let agent implement (spec-driven development)
- Sub-agents in Claude Code: coordinator spawns specialists
- Plan modes: Claude Code `/plan` vs. GSD `plan-phase`
- Cross-session memory: how to maintain context across conversations

**Diagrams (3):**
1. GSD Workflow (Spec → Implement → Review → Iterate)
2. Sub-Agents (coordinator → specialists)
3. Superpowers vs. GSD: When to Use Which

**Lab:** Build multi-file project via GSD
- Write a GSD spec for a monitoring stack extension for the reference app
- Watch sub-agent delegation in action
- Compare: Superpowers (single artifact) vs. GSD (multi-file output)

**Deliverable:** Multi-file project delivered via spec-driven workflow

---

#### M10 — Agent Memory & Knowledge
**Delivery:** RECOMMENDED · **Status:** NEW

**Existing:** Module 05b has memory systems basics

**Concept (Explainer):**
- Memory problem: agents are stateless (colleague with amnesia)
- Memory types: short-term (conversation), long-term (persistent), shared (team)
- **Vectorization & Embeddings:**
  - Embeddings = converting text to numbers capturing MEANING
  - GPS analogy: "Paris" → [48.86, 2.35]. Similar cities have nearby coordinates.
- **Semantic search:** finding by meaning, not keywords
  - "pod crash" also finds "CrashLoopBackOff", "OOMKilled", "restart loop"
- **RAG pipeline:** Query → Vectorize → Search → Retrieve → Augment → Generate
  - Like giving the AI a library card instead of making it memorize everything
- **Agentic RAGs:** agents that decide WHAT to look up and WHEN
- Decision tree: Memory vs. RAG vs. Context Engineering

**Diagrams (5):**
1. The Memory Problem (stateless vs. memory-equipped)
2. Embeddings & Vectorization (GPS analogy)
3. Semantic Search vs. Keyword Search
4. RAG Pipeline (6-step flow)
5. Decision Tree: Memory vs. RAG vs. Context

**Lab:** Memory + simple RAG (local-first)
- Set up persistent memory (Claude Memory or file-based)
- Build basic RAG: vectorize reference app docs → query → compare with/without RAG
- All processing local — no external vector DB required

**Deliverable:** Working memory setup + basic RAG pipeline

---

#### M11 — Wiring Tools to Agents
**Delivery:** CORE · **Status:** REUSE

**Existing:** `modules/module-08-tools/LAB.md` (~350 lines), `reading/tool-patterns.md` (611 lines)

**Concept (Explainer):**
- Tools let agents ACT, not just THINK
- Three patterns: Direct CLI, CLI Wrappers (with safety), MCP Servers
- When to use which: CLI for ad-hoc, wrappers for repeated+safe, MCP for complex
- Safety config: allowed/blocked commands, credential protection
- Never let agent run `kubectl delete namespace production` without approval

**Changes from existing:** Renumber M8→M11. Add diagrams.

**Diagrams (3):**
1. Three Tool Patterns (CLI → Wrapper → MCP)
2. Safety Layer Architecture
3. Decision Matrix: which pattern when

**Lab:** Build safe tool wrappers (existing lab, runs locally with KIND)

**Deliverable:** Working safe tool wrappers for kubectl and aws cli

---

#### M12 — Agentic Skills — Teaching Agents Your Runbooks
**Delivery:** CORE · **Status:** REUSE

**Existing:** `modules/module-07-skills/LAB.md` (~400 lines), 4 SKILL.md files, SKILL-TEMPLATE.md, RUBRIC.md, `reading/skills-guide.md` (618 lines)

**Concept (Explainer):**
- Agentic Skill = structured, machine-readable runbook
  - Converting tribal knowledge from Post-it notes into SOP for humans AND agents
- SKILL.md format: metadata, steps, commands, decision trees, escalation
- Skill lifecycle: Design → Validate → Version → Deploy → Improve
- Domain Expertise made tangible: your SRE knowledge becomes a machine-readable skill

**Changes from existing:** Renumber M7→M12. Add diagrams. Frame as "expertise made tangible."

**Diagrams (3):**
1. From Runbook to Skill (before/after)
2. Anatomy of a SKILL.md
3. Skill Lifecycle

**Lab:** Write domain-specific skills (existing lab, 4 tracks)
- Track A (SRE): EC2 health check
- Track B (DevOps): Deployment safety check
- Track C (DBA): RDS slow query investigation
- Track D (Observability): Alert noise analyzer

**Deliverable:** Complete SKILL.md with peer review

**Bridge to Pillar 3:** Skills and tools built here become the building blocks for
full agents in M14+. Pillar 2 encodes YOUR expertise; Pillar 3 gives it autonomy.

---

### PILLAR 3: Agentic DevOps
*"Build agents that work for you"*

---

#### M13 — Agent Design Patterns & Autonomy Levels
**Delivery:** CORE · **Status:** ADAPT

**Existing:** `reading/agent-anatomy.md` (511 lines), `reading/profile-guide.md` (583 lines)

**Concept (Explainer):**
- The shift: AI user → Agent Architect / Platform Engineer
- Single-agent patterns: Advisor → Investigator → Proposal → Guardian
- Multi-agent patterns: Sequential, Parallel, Hierarchical
- Autonomy Spectrum: L1 Assistive → L2 Advisory → L3 Proposal → L4 Semi-autonomous
- Choosing the right level: risk × frequency × blast radius

**New content needed:** Pattern explainers, workshop exercise

**Diagrams (4):**
1. Single-Agent Patterns (4 types)
2. Autonomy Spectrum (L1→L4)
3. Multi-Agent Patterns (3 modes)
4. Agent Architect Role

**Exercise:** Map 3 tasks to patterns, assign autonomy levels, sketch architecture

**Deliverable:** Agent architecture sketch for top automation candidate

---

#### M14 — Building Your First Agent with Hermes
**Delivery:** CORE · **Status:** REUSE

**Existing:** `modules/module-10-agents/` (3 track labs, ~500 lines each, starter + solution), 4 agent profiles, `setup/install-hermes.md`

**Concept (Explainer):**
- Hermes: open source, works with free Gemini, auto-installs Python
- Agent definition: model, instructions, tools, skills, safety rules
- Connecting to skills from M12
- Alternative: Claude Code sub-agents

**Changes from existing:** Renumber M10→M14. Add diagrams.

**Diagrams (3):**
1. Agent Definition Anatomy
2. Hermes Architecture
3. From Definition to Running Agent

**Lab:** Build health check agent for reference app (existing lab, 3 tracks)

**Deliverable:** Working Hermes agent against reference app (local KIND cluster)

---

#### M15 — Triggers, Scheduling & Chat Interfaces
**Delivery:** CORE · **Status:** REUSE

**Existing:** `modules/module-12-triggers/LAB.md` (657 lines) + cron starter

**Concept (Explainer):**
- Five trigger patterns: schedule, chat, webhook, code event, ticket
- Hermes built-in: cron + Telegram/Discord/Slack gateways
- Webhook architecture: monitoring → agent → report
- Mission Control concept

**Changes from existing:** Renumber M12→M15. Add diagrams.

**Diagrams (4):**
1. Five Trigger Patterns
2. Webhook Flow
3. Chat Interface Pattern
4. Mission Control Dashboard

**Lab:** Wire agent to triggers (existing lab)

**Deliverable:** Agent with cron + chat command + webhook

---

#### M16 — Domain Agents — Real-World Use Cases
**Delivery:** CORE · **Status:** ADAPT

**Existing:** Module 10 track labs, Module 4 impact assessment content

**Concept (Explainer):**
- Domain agent patterns: DB Health, Cost Anomaly, K8s Health, Incident RCA, Deploy Safety
- Automation Quadrant: frequency × complexity (folded from old M4)
- Agent specialization: base agent + domain skill

**New content needed:** Automation Quadrant explainer, domain agent gallery

**Diagrams (3):**
1. Domain Agent Gallery
2. Automation Quadrant (frequency × complexity)
3. Agent Specialization (base + domain skill)

**Lab:** Build domain agent (extends M14, 3 tracks)
- Track A (DB): PostgreSQL monitoring + slow query + tuning proposals
- Track B (Cost): Cost anomaly detection + reports (mock data or live)
- Track C (K8s): Pod monitoring + CrashLoopBackOff diagnosis + fix proposals

**Deliverable:** Domain agent with skills, tools, and trigger

---

#### M17 — Multi-Agent Systems & Sub-Agents
**Delivery:** RECOMMENDED · **Status:** REUSE

**Existing:** `modules/module-11-fleet/LAB.md` (626 lines)

**Concept (Explainer):**
- When single agents aren't enough: cross-domain incidents
- Two approaches: Claude Code sub-agents, Hermes fleet
- Fleet coordination: round-robin, skill-based, hierarchical
- Shared memory and context across agents

**Changes from existing:** Renumber M11→M17. Add diagrams. Add sub-agent demo.

**Diagrams (4):**
1. Single vs. Multi-Agent
2. Sub-Agent Pattern in Claude Code
3. Fleet Coordination Modes
4. Cross-Domain Incident Resolution

**Lab:** Multi-agent incident response (existing lab)

**Deliverable:** Multi-agent config coordinating 3 domain agents

---

#### M18 — Governance — Making Agents Enterprise-Safe
**Delivery:** CORE · **Status:** REUSE

**Existing:** `modules/module-13-governance/LAB.md` (720 lines), 6 governance YAMLs, `reading/governance-ref.md` (513 lines)

**Concept (Explainer):**
- Governance triad: CAN do × APPROVAL × LOGGED
- Maturity levels: L1 → L4 with promotion criteria
- Enterprise reqs: audit trails, RBAC, credential protection, rollback
- Approval workflows and escalation chains

**Changes from existing:** Renumber M13→M18. Add diagrams.

**Diagrams (4):**
1. Governance Triad
2. Maturity Progression (L1→L4)
3. Enterprise Safety Architecture
4. Approval Workflow

**Lab:** Add governance to agent (existing lab)

**Deliverable:** Governance config with maturity levels, approvals, audit

---

#### M19 — Capstone: Build Your Agentic DevOps System
**Delivery:** CORE · **Status:** ADAPT

**Existing:** Module 14 partial structure

**New content needed:** Presentation template, evaluation rubric, build checklist

**No diagrams — build + present module.**

**Lab:** Teams finalize complete system → present with live demo

**Deliverable:** Complete agent system with skills, triggers, governance

---

#### M20 — 30-Day Deployment Roadmap + What's Next
**Delivery:** OPTIONAL · **Status:** ADAPT

**Existing:** Module 14 had 30-day concept

**New content needed:** 30-day plan template, "what's next" content

**No diagrams — guided exercise.**

**Deliverable:** Written 30-day deployment plan

---

## Delivery Format Guide

### 5-Day Delivery (all 20 modules)
All modules in sequence. Full Agentic Engineering coverage.

### 4-Day Delivery (skip OPTIONAL, condense RECOMMENDED)
- Skip: M20 (fold roadmap into M19 capstone)
- Condense: M05 (give as pre-read), M09 (demo only), M10 (shorten lab to demo), M17 (demo only)
- Result: ~16 modules across 4 days

### 3-Day Delivery (CORE only)
- Skip: M05, M09, M10, M17, M20
- Condense: M04 (merge into M01 setup), M16 (merge into M14)
- Result: ~13 modules across 3 days (close to original 14-module format)

| Module | 5-Day | 4-Day | 3-Day |
|--------|-------|-------|-------|
| M01 Welcome + Setup | Full | Full | Full (absorb M04) |
| M02 AI Foundations | Full | Full | Full |
| M03 Platform AI | Full | Full | Full |
| M04 MCP | Full | Full | Merged into M01 |
| M05 How AI Works | Full | Pre-read | Skip |
| M06 Context Engineering | Full | Full | Full |
| M07 Superpowers Workflow | Full | Full | Full |
| M08 AgentDev IaC | Full | Full | Full |
| M09 GSD + Sub-Agents | Full | Demo only | Skip |
| M10 Memory & RAG | Full | Demo only | Skip |
| M11 Tool Wiring | Full | Full | Full |
| M12 Agentic Skills | Full | Full | Full |
| M13 Design Patterns | Full | Full | Full |
| M14 Build First Agent | Full | Full | Full (absorb M16) |
| M15 Triggers | Full | Full | Full |
| M16 Domain Agents | Full | Full | Merged into M14 |
| M17 Multi-Agent | Full | Demo only | Skip |
| M18 Governance | Full | Full | Full |
| M19 Capstone | Full | Full (+ roadmap) | Full (+ roadmap) |
| M20 Roadmap | Full | Merged into M19 | Merged into M19 |

---

## Content Scorecard

| Status | Modules | Count |
|--------|---------|-------|
| REUSE | M03, M11, M12, M14, M15, M17, M18 | 7 |
| ADAPT | M01, M02, M04, M06, M07, M08, M09, M13, M16, M19, M20 | 11 |
| NEW | M05, M10 | 2 |
| **Total** | | **20** |

Estimated diagrams: ~62 (none exist yet)

**Note:** Reclassified several modules from NEW to ADAPT because existing content in
`course-site/docs/` covers significant ground. M07 reuses module-05a, M08 reuses
module-06, M09 reuses module-05b.

---

## Build Sequence

### Phase 1: Adapt Existing Modules (highest leverage — most content exists)
1. M06 — Context Engineering (expand from M01 reading + module-05b CLAUDE.md lab)
2. M07 — Superpowers Workflow (adapt from module-05a, add Track C)
3. M08 — AgentDev IaC (adapt from module-06, add local-first paths)
4. M09 — GSD + Sub-Agents (adapt from module-05b, add sub-agent content)

### Phase 2: New Content
5. M05 — How AI Works (conceptual only, no lab infrastructure needed)
6. M10 — Memory & RAG (new lab)

### Phase 3: Adapt Remaining Modules
7. M01 — Trinity Framework + setup expansion (local-first)
8. M02 — Domain Expertise framework addition
9. M04 — MCP expansion from bridge module
10. M13 — Design Patterns explainers
11. M16 — Domain Agents + Automation Quadrant
12. M19/M20 — Capstone + Roadmap templates

### Phase 4: Diagrams for REUSE Modules
13-19. Add Excalidraw diagrams to M03, M11, M12, M14, M15, M17, M18

### Phase 5: Video Transcripts (Udemy)
### Phase 6: Instructor Guides (update for expanded format)

---

## How to Build a Module (Session Protocol)

### Starting a New Session

Open a new conversation and provide this context:

```
I'm building content for the Agentic DevOps workshop.

Read these files for context:
1. course/WORKSHOP-5DAY.md — the master plan (find the module I'm building)
2. course/CLAUDE.md — repo conventions
3. course/COMPLETED-HANDOFF.md — what's already built

I want to build Module [NN] — [Name].

[Any specific notes about what you want for this module]
```

If the module has **Existing content** listed, also tell the session to read those files.

### What Each Session Produces

```
modules/module-NN-name/
├── README.md              # Overview, objectives, prerequisites
├── explainer/
│   ├── EXPLAINER.md       # Concept notes (what to explain, analogies, key points)
│   └── diagrams/          # Excalidraw exports
├── reading/
│   ├── concepts.md        # Core concepts (standalone readable)
│   └── reference.md       # Quick-reference
├── lab/
│   ├── LAB.md             # Step-by-step instructions
│   ├── starter/           # Starting files
│   └── solution/          # Reference solutions
├── quiz/
│   └── QUIZ.md            # 5-7 questions + answers
└── exploratory/
    └── PROJECTS.md        # Optional stretch projects
```

### Quality Checklist

- [ ] Lab only uses infrastructure from earlier modules
- [ ] ALL labs have Docker/KIND/local-first path (AWS always optional)
- [ ] Lab works in mock mode (`HERMES_LAB_MODE=mock`)
- [ ] Has starter/ and solution/ where applicable
- [ ] No "prompt engineering" — use "context engineering"
- [ ] Domain Expertise theme reinforced where natural
- [ ] Free-tier path documented (Crush + Gemini fallback)
- [ ] Solo-completable (no team dependencies for Udemy)
- [ ] Correct module numbers (new numbering)

### After Completing a Module

Update `COMPLETED-HANDOFF.md` with what was built, any deviations, and known issues.

---

## Infrastructure Dependency Chain

```
M01 (setup) deploys → everything depends on this
├── Docker + KIND cluster (REQUIRED — local, free)
├── Reference app via Helm (on KIND)
├── PostgreSQL via Helm (on KIND)
├── Prometheus + Grafana via Helm (on KIND)
├── MCP servers: kubectl, github, postgres (local connections)
├── Mock data (HERMES_LAB_MODE=mock default)
└── AWS free tier (OPTIONAL — never required)

M06 → needs ref app from M01 (to build CLAUDE.md for)
M07 → needs M06 context eng knowledge, ref app from M01
M08 → needs M07 Superpowers workflow + ref app
M09 → needs M07 + M08 (builds on both workflows)
M10 → needs ref app docs (in repo)
M11 → needs kubectl + mock-aws from M01
M12 → needs ref app + Claude Code from M01
M14 → needs M12 skills + M11 tools + Hermes installed
M15 → needs M14 agent + Telegram (free)
M16 → continues M14
M17 → needs M16 agents (team combines tracks)
M18 → needs M16 agent
M19 → needs everything
```

---

## Custom Skills to Build

| Skill | Purpose | Build When |
|-------|---------|------------|
| `module-builder` | Scaffolds module directory with all files | Before Phase 1 |
| `lab-writer` | Writes step-by-step labs following conventions | Before Phase 1 |
| `quiz-generator` | Generates quiz from lab + reading | Before Phase 3 |
| `diagram-planner` | Plans Excalidraw diagrams from concepts | Before Phase 4 |

Existing skills: `excalidraw-bw`, `voiceover-video` (tune after testing)
