# Agentic DevOps — 5-Day Corporate Workshop

**Building Agentic Skills for Infrastructure Automation**

Version: 2026 Edition (5-Day Corporate)
Trainer: Gourav Shah
Duration: 5 Full Days (6 hours/day, ~30 hours total)
Level: Intermediate to Advanced
Delivery: Conceptual Explainers + Live Demos + Guided Hands-On Labs
Also converts to: Udemy Bestseller Course

---

## The AI Trinity Framework

This workshop teaches DevOps and SRE teams to adopt AI through a progressive three-pillar framework. Think of it like learning to drive — first you ride as a passenger and observe (Augmented), then you understand how the engine works (Engineering), then you get behind the wheel and drive (Agentic).

```
┌─────────────────────────────────────────────────────────────────┐
│                    THE AI TRINITY FRAMEWORK                     │
│                                                                 │
│   PILLAR 1              PILLAR 2              PILLAR 3          │
│   ┌──────────┐          ┌──────────┐          ┌──────────┐     │
│   │AI-Augmented│         │ Agentic  │          │ Agentic  │     │
│   │  DevOps   │  ──►    │Engineering│  ──►    │  DevOps  │     │
│   └──────────┘          └──────────┘          └──────────┘     │
│                                                                 │
│   Use what's            Understand how         Build agents     │
│   already there         it all works           that work for you│
│                                                                 │
│   Days 1-2              Days 2-3               Days 4-5         │
│                                                                 │
│   Platform AI           Context Engineering    Agent Building   │
│   MCP Connectors        Memory & RAGs          Triggers         │
│   AI Coding Agents      Tool Wiring            Orchestration    │
│   Agentic Harnesses     Agentic Skills         Governance       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workshop Philosophy

**Agents don't replace DevOps engineers. They augment them.**

- Humans retain: Approval authority, Risk ownership, Execution control, Governance
- Agents augment: Detection, Analysis, Recommendation, Proposal drafting, Remediation

**Teaching approach:** Bite-size learning. You eat one bite at a time so you can digest it properly. Each module builds on the previous like a stack — foundation first, then one layer at a time.

**Module delivery pattern:**
1. Conceptual explainer (Excalidraw whiteboard diagrams)
2. Live demo by trainer
3. Guided hands-on lab (participants follow step-by-step)

---

## Target Audience

Technology professionals from companies like Adobe, Walmart, Cisco, Visa, Accenture, and tech startups:

- Software Developers
- DevOps Engineers / DevOps Practitioners
- Site Reliability Engineers (SREs)
- Database Administrators (DBAs)
- Platform Engineers

**What they already know:** Software development workflows, CI/CD (GitHub Actions), containers (Docker), Kubernetes basics, at least one IaC tool (Terraform/Ansible). Git and PR workflows.

**What's new to them:** AI coding agents (Claude Code, etc.), MCP, context engineering, agentic workflows, agent building.

---

## Prerequisites

- Working knowledge of DevOps practices and at least one IaC tool
- Familiarity with CLI tools (kubectl, terraform, aws cli)
- Git and pull request workflows
- Claude Code installed (with Claude Pro or Team subscription)
- AWS account (free tier sufficient) with EC2, RDS access
- Kubernetes cluster (KIND or managed)
- GitHub repository

---

## 5-Day Structure at a Glance

```
DAY 1: Foundations + AI-Augmented DevOps (Pillar 1 begins)
       "See what AI can already do for you"
       ├── M01: Welcome + The AI Trinity Framework
       ├── M02: AI Foundations for DevOps Teams
       ├── M03: Platform AI — Features Already in Your Stack
       └── M04: Connecting to Everything with MCP

DAY 2: AI-Augmented DevOps contd. + Agentic Engineering begins (Pillar 1→2)
       "From using AI to understanding AI"
       ├── M05: Claude Code & Agentic Harnesses (Superpowers/GSD)
       ├── M06: How AI Actually Works — The Engine Under the Hood
       ├── M07: Context Engineering — Beyond Prompts
       └── M08: Agent Memory & Knowledge (Memory, RAGs)

DAY 3: Agentic Engineering contd. + AgentDev (Pillar 2)
       "From understanding AI to building with AI"
       ├── M09: Wiring Tools to Agents (MCP, CLI, Custom)
       ├── M10: Agentic Skills — Teaching Agents Your Runbooks
       ├── M11: AgentDev — AI-Assisted Infrastructure as Code
       └── M12: AgentDev — Multi-file IaC Projects with GSD

DAY 4: Agentic DevOps (Pillar 3 begins)
       "From building with AI to building AI agents"
       ├── M13: Agent Design Patterns & Autonomy Levels
       ├── M14: Building Your First Agent (Hermes / Open Claude)
       ├── M15: Triggers, Scheduling & Interfaces
       └── M16: Domain Agents — DB, K8s, Cost, SRE

DAY 5: Enterprise Agentic DevOps + Capstone (Pillar 3 contd.)
       "From single agents to production agent systems"
       ├── M17: Multi-Agent Systems & Sub-Agents
       ├── M18: Governance — Making Agents Enterprise-Safe
       ├── M19: Capstone — Build Your Agentic DevOps System
       └── M20: 30-Day Deployment Roadmap + What's Next
```

---

## Detailed Module Breakdown

---

### DAY 1: Foundations + AI-Augmented DevOps
*"See what AI can already do for you"*

The first day is about removing the fear and building confidence. Participants discover that AI isn't some far-off thing — it's already embedded in tools they use daily. Then we show them how to connect and extend it.

---

#### Module 01 — Welcome + The AI Trinity Framework
**Duration:** 45 min (30 min concept + 15 min setup verification)
**Pillar:** Foundation

**Concept (Explainer):**
- Why Agentic DevOps matters in 2026 — the shift from manual → automated → agentic
- The AI Trinity Framework: three pillars, three stages of adoption
- Workshop roadmap: what we'll build by Day 5
- The driving analogy: Passenger → Mechanic → Driver
- What agents DON'T replace (the human-in-the-loop philosophy)

**Explainer Diagrams:**
1. The Evolution: Manual → Scripted → Automated → Agentic (timeline)
2. The AI Trinity Framework (three pillars with what fits where)
3. The 5-Day Journey Map (progressive build)

**Lab: Environment Verification**
- Verify Claude Code installation and subscription
- Verify AWS access, kubectl, terraform, ansible CLIs
- Clone workshop repository
- Run a "hello world" with Claude Code to confirm everything works
- Quick: Ask Claude Code to explain a Kubernetes YAML you already have

**Deliverable:** Working environment, first interaction with Claude Code

---

#### Module 02 — AI Foundations for DevOps Teams
**Duration:** 60 min (40 min concept + 20 min lab)
**Pillar:** Foundation / Bridge to all three pillars

**Concept (Explainer):**
- How LLMs work — explained through a DevOps lens
  - Analogy: LLM as a very experienced colleague who's read every Stack Overflow answer, every doc, every runbook — but needs clear instructions
- Tokens, context windows, temperature — through operational analogies
  - Context window = the whiteboard in your war room (limited space)
  - Tokens = the words on that whiteboard
  - Temperature = how creative vs. conservative the response
- The AI Spectrum: Chat → Copilot → Agent → Squad
  - Chat = asking a colleague a question
  - Copilot = pair programming with that colleague
  - Agent = delegating a task with guardrails
  - Squad = a team of specialists coordinated by a lead
- Agent anatomy: Brain (LLM) + Skills (runbooks) + Tools (CLI/MCP) + Guardrails (approvals)
- Why agents need structure — unstructured prompts produce inconsistent infrastructure

**Explainer Diagrams:**
1. The AI Spectrum (Chat → Copilot → Agent → Squad) with DevOps examples
2. Agent Anatomy (Brain + Skills + Tools + Guardrails)
3. Context Window as a War Room Whiteboard

**Lab: Your First AI Conversation**
- Use Claude Code to interact with an LLM using real operational data (e.g., a CloudWatch alarm JSON)
- Progressive prompt engineering exercise — compare output quality across different prompt structures
- Experience the difference between a vague prompt and a structured one

**Deliverable:** Optimized prompt template for operational diagnosis

---

#### Module 03 — Platform AI — Features Already in Your Stack
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 1:** AI-Augmented DevOps

**Concept (Explainer):**
- What platform AI is — AI features built into tools you already pay for
- AWS AI services: Q Developer, DevOps Guru, Predictive Scaling, Cost Anomaly Detection, RDS Performance Insights
- Observability AI: Datadog Watchdog, Grafana Sift, CloudWatch anomaly detection
- What platform AI does well and where it falls short
  - Good at: single-platform analysis, pattern detection within its data
  - Weak at: cross-tool correlation, custom workflows, organizational context
- The gap between platform AI and custom agents — this is what we'll fill

**Explainer Diagrams:**
1. Platform AI Landscape (map of AI features across AWS, Datadog, Grafana)
2. The Platform AI Gap (what it covers vs. what's missing)
3. Before/After: Manual investigation vs. Platform AI assist

**Lab: Discover Platform AI**
Participants enable and explore platform AI features on their own AWS infrastructure:
- RDS Performance Insights with load generation
- Cost Explorer analysis and anomaly detection
- CloudWatch anomaly detection setup
- Q Developer for query explanation
- Document: what each tool caught, what it missed

**Deliverable:** Written assessment of platform AI capabilities and gaps for their environment

---

#### Module 04 — Connecting to Everything with MCP
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 1:** AI-Augmented DevOps

**Concept (Explainer):**
- What is MCP (Model Context Protocol) — the USB-C of AI
  - Analogy: Before USB-C, every device had its own charger. MCP is the universal connector between AI agents and your tools
- MCP architecture: Client ↔ Server ↔ Tool/Resource
- MCP vs. direct CLI vs. API calls — when to use what
- The MCP ecosystem: available servers for AWS, Kubernetes, GitHub, Datadog, Grafana, Postgres, etc.
- Using Claude Code with MCP connectors
- Alternative: Goose (open source) with MCP

**Explainer Diagrams:**
1. MCP as USB-C (the universal connector analogy)
2. MCP Architecture (Client → Server → Tool/Resource)
3. Before/After: Manually switching between 5 tools vs. one agent with MCP connections

**Lab: Wire Up Your First MCP Connections**
- Install and configure MCP servers for: AWS, Kubernetes (kubectl), GitHub
- Connect Claude Code to these MCP servers
- Run cross-platform queries:
  - "Show me pods that restarted in the last hour AND the associated CloudWatch logs"
  - "List all PRs merged this week that touched Kubernetes manifests"
- Experience the power of a single AI interface connected to multiple systems
- Try the same with Goose (optional)

**Deliverable:** Claude Code connected to 3+ MCP servers, working cross-platform queries

---

### DAY 2: AI-Augmented DevOps contd. + Agentic Engineering
*"From using AI to understanding AI"*

Day 2 bridges the gap. Morning continues Pillar 1 with hands-on power tools (Claude Code harnesses). Afternoon pivots into Pillar 2 — understanding the engine under the hood so participants can make better decisions when building with AI.

---

#### Module 05 — Claude Code & Agentic Harnesses
**Duration:** 90 min (30 min concept + 60 min lab)
**Pillar 1→2 Bridge:** AI-Augmented DevOps → Agentic Engineering

**Concept (Explainer):**
- Claude Code deep dive — what it is, how it works, what makes it different
- The concept of Agentic Harnesses — structured workflows that wrap around AI
- The Superpowers workflow: Brainstorm → Design → Blueprint → Implement → Validate
  - Analogy: Like an architect designing a building — you don't just start pouring concrete
- The GSD (Get Shit Done) workflow for larger, multi-file projects
  - Spec-driven: write the spec first, then let the agent implement
- Provider-agnostic usage: works with any LLM (Claude, OpenAI, Gemini)
- OpenCode as the open-source alternative

**Explainer Diagrams:**
1. The Superpowers Workflow (5-phase pipeline)
2. GSD Workflow (spec → implement → validate cycle)
3. Harness Comparison: Unstructured prompt vs. Superpowers vs. GSD

**Lab: The Superpowers Workflow in Action**
- Use the Superpowers workflow to build a complete Ansible playbook for EC2 hardening
- Each phase is explicit: brainstorm approaches, design structure, blueprint specs, implement code, validate output
- Compare: same task with unstructured prompt vs. Superpowers
- See the dramatic difference in quality and consistency

**Deliverable:** A validated Ansible playbook created through the structured 5-step workflow

---

#### Module 06 — How AI Actually Works — The Engine Under the Hood
**Duration:** 60 min (45 min concept + 15 min interactive)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- What happens when you type something in ChatGPT or Claude — the full journey
- The two phases: Prefill and Decode
  - Prefill: AI reads and processes your entire input (like a person reading the whole email before responding)
  - Decode: AI generates the response token by token (like a person typing their reply one word at a time)
- Time to First Token (TTFT) — why there's a pause before you see output
- Token generation speed — why responses stream in word by word
- Why this matters for agents: longer context = longer prefill = slower first response
- Context windows: the working memory limit
  - Analogy: Like RAM in a computer — you can fit a lot, but there's a ceiling
  - 200K tokens ≈ a 500-page book, but more context isn't always better
- Temperature, top-p: creativity vs. consistency dial
  - For DevOps: you almost always want low temperature (consistent, predictable output)

**Explainer Diagrams:**
1. The AI Processing Pipeline (Input → Prefill → Decode → Output with timing)
2. Context Window as RAM (what fills it up, what gets pushed out)
3. The Temperature Dial (Creative ↔ Consistent) with DevOps sweet spot

**Interactive Exercise:**
- Experiment with different context sizes and measure TTFT
- See how response quality changes with temperature settings
- Visualize token usage for different types of prompts

**Deliverable:** Mental model of how AI processes requests and why it behaves the way it does

---

#### Module 07 — Context Engineering — Beyond Prompts
**Duration:** 75 min (35 min concept + 40 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- Prompt writing vs. Context Engineering — a critical distinction
  - Prompt = the question you ask
  - Context = the entire environment you set up BEFORE asking the question
  - Analogy: A prompt is like asking a new hire to fix a bug. Context engineering is like first giving them access to the codebase, the architecture docs, the runbook, and telling them which team owns what.
- The Context Stack: System prompt + CLAUDE.md + Skills + Memory + Tools + Conversation
- Why context engineering matters more than prompt engineering for agents
- Designing effective CLAUDE.md files — the project-level context
- How to structure system prompts for operational agents
- Context budgeting: what to put in vs. what to keep out
  - Not everything should be in context — too much is as bad as too little

**Explainer Diagrams:**
1. Prompt vs. Context Engineering (iceberg analogy — prompt is the tip)
2. The Context Stack (layers from system prompt to conversation)
3. Context Budget (what fills the context window and priority order)

**Lab: Build Your Context Stack**
- Create a CLAUDE.md file for a real infrastructure project
- Design a system prompt for an operational agent
- Experiment: same task with minimal context vs. rich context
- Measure the difference in output quality and accuracy
- Build a context template that the team can reuse

**Deliverable:** CLAUDE.md file + system prompt template for their operational domain

---

#### Module 08 — Agent Memory & Knowledge
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- The memory problem: AI agents are stateless — every conversation starts fresh
  - Analogy: Imagine a colleague with amnesia who forgets everything every morning
- Types of memory: Short-term (conversation), Long-term (persistent), Shared (team)
- Memory tools: Claude Memory (claude-mem), custom memory files, vector stores
- RAG (Retrieval-Augmented Generation):
  - What it is: giving the AI a library card instead of making it memorize everything
  - Analogy: Like an engineer who can look things up in the wiki vs. one who has to remember everything
- Agentic RAGs: agents that decide WHAT to look up and WHEN
  - The agent doesn't just answer — it searches, retrieves, reasons, then answers
- When to use memory vs. RAG vs. context engineering
  - Memory: personal preferences, past decisions, learned patterns
  - RAG: large knowledge bases, documentation, runbooks
  - Context: project-specific, session-specific information

**Explainer Diagrams:**
1. The Memory Problem (stateless agent vs. agent with memory)
2. Types of Memory (short-term, long-term, shared)
3. RAG Pipeline (Query → Retrieve → Augment → Generate)
4. Decision Tree: Memory vs. RAG vs. Context

**Lab: Give Your Agent Memory**
- Set up Claude Memory (claude-mem) for persistent memory
- Create a simple RAG setup with project documentation
- Test: ask the agent questions that require memory of previous interactions
- Test: ask questions that require looking up documentation (RAG)
- Compare outputs with and without memory/RAG

**Deliverable:** Working memory setup + basic RAG pipeline for their operational docs

---

### DAY 3: Agentic Engineering contd. + AgentDev
*"From understanding AI to building with AI"*

Day 3 is where theory meets practice. Morning completes the Agentic Engineering foundation with tool wiring and skills. Afternoon is pure building — using Claude Code with skills and harnesses to generate production-grade Infrastructure as Code.

---

#### Module 09 — Wiring Tools to Agents
**Duration:** 60 min (25 min concept + 35 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- Tools give agents the ability to ACT, not just THINK
- Three tool integration patterns:
  1. Direct CLI: agent runs shell commands (kubectl, terraform, aws cli)
  2. CLI Wrappers: shell scripts with safety checks that agents call
  3. MCP Servers: standardized protocol for tool access
- When to use which pattern:
  - CLI: quick, simple, ad-hoc tasks
  - Wrappers: repeated tasks that need safety guardrails
  - MCP: complex integrations, shared across agents
- Safety configuration: allowed commands, blocked commands, credential protection
- Writing custom tool wrappers — the safety layer between agent and infrastructure
- Tool configuration: shell, kubectl, aws, file, http, and MCP tools

**Explainer Diagrams:**
1. Three Tool Patterns (CLI → Wrapper → MCP) with trade-offs
2. Safety Layer Architecture (Agent → Wrapper → Infrastructure)
3. Decision Matrix: Which pattern for which use case

**Lab: Build Your Tool Kit**
- Create a CLI wrapper for kubectl with safety checks (e.g., prevent `kubectl delete namespace production`)
- Configure allowed and blocked command lists
- Build a custom MCP tool wrapper
- Test each pattern against live lab environment
- Document: which tools in your org should use which pattern

**Deliverable:** Working tool wrappers with safety configuration

---

#### Module 10 — Agentic Skills — Teaching Agents Your Runbooks
**Duration:** 90 min (30 min concept + 60 min lab)
**Pillar 2:** Agentic Engineering (Core Topic)

**Concept (Explainer):**
- What is an Agentic Skill — a structured, machine-readable runbook
  - Analogy: Like converting your team's tribal knowledge from Post-it notes into a proper SOP that both humans AND agents can follow
- The SKILL.md format: metadata, steps, commands, decision trees, escalation rules
- Skill lifecycle: Design → Validate → Version → Deploy → Improve
- How skills connect to agents and automation frameworks
- Skills as the bridge between Pillar 2 (understanding) and Pillar 3 (building)
- Converting existing SOPs and runbooks into agentic skills

**Explainer Diagrams:**
1. From Runbook to Skill (before/after — messy wiki page vs. structured SKILL.md)
2. Anatomy of a SKILL.md (sections and what goes where)
3. Skill Lifecycle (Design → Validate → Version → Deploy → Improve)

**Lab: Write Your Domain-Specific Skills**
Using Claude Code, participants write domain-specific SKILL.md files:
- Track A (SRE): EC2 health check skill
- Track B (DevOps): Deployment safety check skill
- Track C (DBA): RDS slow query investigation skill
- Track D (Observability): Alert noise analyzer skill

Each skill must define: required inputs, at least 5 CLI commands, a decision table, and escalation criteria.

Peer review: pairs exchange skills and test them against Claude Code.

**Deliverable:** Complete SKILL.md file with peer review feedback

---

#### Module 11 — AgentDev: AI-Assisted Infrastructure as Code
**Duration:** 90 min (25 min concept + 65 min lab)
**Pillar 2→3 Bridge:** Agentic Engineering → Agentic DevOps

**Concept (Explainer):**
- Using AI coding agents for production-quality IaC
- The Superpowers workflow applied to IaC:
  - Brainstorm: what infrastructure do we need?
  - Design: what's the architecture?
  - Blueprint: what are the specs (modules, variables, outputs)?
  - Implement: generate the code
  - Validate: lint, plan, review
- Common AI failure modes in infrastructure generation (and how to prevent them)
- Reviewing and validating AI-generated infrastructure — the human checkpoint
- Agentic Skills for IaC: Helm charts, Terraform modules, K8s manifests

**Explainer Diagrams:**
1. IaC Generation Pipeline (Brainstorm → Design → Blueprint → Implement → Validate)
2. Common AI IaC Failures (and the safety net)
3. Human-AI IaC Workflow (where human reviews happen)

**Lab: Generate Real Infrastructure as Code**
Participants pick one track and build real IaC for their lab environment:
- Track A (Terraform): RDS PostgreSQL module with CloudWatch alarms and SNS notifications
- Track B (Ansible): PostgreSQL client setup with monitoring agents and backup scripts
- Track C (Kubernetes): Application deployment with HPA, resource limits, and PodDisruptionBudget

Full Superpowers workflow for each track. AI generates, human validates.

**Deliverable:** Production-quality IaC artifact, validated and applicable to participant's environment

---

#### Module 12 — AgentDev: Multi-File IaC Projects with GSD
**Duration:** 75 min (20 min concept + 55 min lab)
**Pillar 2→3 Bridge:** Agentic Engineering → Agentic DevOps

**Concept (Explainer):**
- When Superpowers isn't enough: multi-file, multi-component projects
- The GSD (Get Shit Done) workflow for larger projects:
  - Write the spec first (what do we want, in detail)
  - Let the agent implement the full project
  - Review, iterate, validate
- Sub-agents in Claude Code — how modern multi-agent works
  - Instead of building separate agents, Claude Code spawns sub-agents for different tasks
  - One agent coordinates, specialists handle details
- CICD pipeline generation (GitHub Actions)
- Combining skills + harnesses for complex projects

**Explainer Diagrams:**
1. GSD Workflow (Spec → Implement → Review cycle)
2. Sub-Agents in Claude Code (coordinator → specialists)
3. Multi-File Project Structure (generated by agent)

**Lab: Build a Complete CICD Pipeline**
- Write a spec for a complete CICD pipeline using GSD workflow
- Claude Code generates: GitHub Actions workflow, Dockerfile, K8s manifests, Terraform for infrastructure
- Sub-agent demonstration: watch Claude Code spawn specialists for different tasks
- Review, iterate, and validate the entire pipeline
- Deploy and test against the lab environment

**Deliverable:** Complete CICD pipeline project generated through GSD workflow

---

### DAY 4: Agentic DevOps — Building Agents
*"From building with AI to building AI agents"*

Day 4 is the transformation. Participants shift from USING AI tools to BUILDING AI agents. This is where they become agent architects — designing, building, and wiring agents that can operate with varying degrees of autonomy.

---

#### Module 13 — Agent Design Patterns & Autonomy Levels
**Duration:** 60 min (40 min concept + 20 min workshop)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- The shift: from AI user to Agent Architect / Platform Engineer
- Single-agent patterns: Advisor → Investigator → Proposal → Guardian
  - Advisor: "Here's what I think about this alert"
  - Investigator: "Let me dig into this and report back"
  - Proposal: "Here's what I'd do, approve to proceed"
  - Guardian: "I'm watching and will flag issues"
- Multi-agent patterns: Sequential pipeline, Parallel investigation, Hierarchical (commander + specialists)
- The Autonomy Spectrum:
  - L1 Assistive: answers questions, reads data only
  - L2 Advisory: analyzes and recommends actions
  - L3 Proposal-driven: proposes changes, waits for approval
  - L4 Semi-autonomous: acts within boundaries, escalates exceptions
- How to choose the right level for each use case
- Mapping patterns to resource types: Agent, Fleet, Flow
- Reference architecture of a production multi-agent system

**Explainer Diagrams:**
1. Single-Agent Patterns (Advisor → Investigator → Proposal → Guardian)
2. The Autonomy Spectrum (L1 → L4 with trust progression)
3. Multi-Agent Patterns (Sequential, Parallel, Hierarchical)
4. Agent Architect Role (you become the orchestrator)

**Workshop Exercise:**
- Map 3 operational tasks from their work to agent patterns
- Assign autonomy levels based on risk and frequency
- Sketch the agent architecture for their top candidate
- Peer discussion: why did you choose this pattern?

**Deliverable:** Agent architecture sketch for their top automation candidate

---

#### Module 14 — Building Your First Agent
**Duration:** 90 min (25 min concept + 65 min lab)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Agent building platforms: Hermes, Open Claude, and the ecosystem
- Agent definition approaches: YAML-first, code-first, and hybrid
- The minimal agent definition: model, instructions, tools, safety rules
- Core resource types: Agent (single) → Fleet (team) → Flow (workflow)
- Connecting agents to the skills we built on Day 3
- Safety first: allowed commands, blocked commands, credential protection

**Explainer Diagrams:**
1. Agent Definition Anatomy (model + instructions + tools + skills + safety)
2. From Definition to Running Agent (the build process)
3. Agent → Fleet → Flow (progressive complexity)

**Lab: Build Your First Real Agent**
Participants build their first real agent connected to their infrastructure:
- Define agent YAML with model, instructions, and tool access
- Connect to the skills built in Module 10
- Configure allowed and blocked command lists
- Add credential protection
- Test agent against live lab environment
- Use cases:
  - SRE: EC2 health investigation agent
  - DevOps: Deployment readiness checker
  - DBA: Database performance analyzer
  - Observability: Alert triage agent

**Deliverable:** Working agent YAML with tools, safety rules, and custom skill. Agent runs successfully against participant's infrastructure.

---

#### Module 15 — Triggers, Scheduling & Interfaces
**Duration:** 75 min (25 min concept + 50 min lab)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Agents need triggers — CLI alone is not enough for production
- Five trigger patterns:
  1. Schedule (cron): daily health checks, weekly reports
  2. Manual interaction: Slack command, Telegram bot, Discord
  3. Event-driven: webhook from monitoring (PagerDuty, Datadog)
  4. Code events: PR created, commit pushed (GitHub)
  5. Ticket-driven: Jira ticket created, status changed
- Chat interfaces: Slack, Telegram, Discord as agent frontends
  - The "agent as team member" pattern
- Webhook architecture: monitoring alert → webhook → agent → action
- Mission Control: dashboard concept for managing deployed agents

**Explainer Diagrams:**
1. Five Trigger Patterns (with examples for each)
2. Webhook Architecture (Alert → Webhook → Agent → Action → Report)
3. Chat Interface Pattern (Slack/Telegram as agent frontend)
4. Mission Control Dashboard (managing multiple deployed agents)

**Lab: Wire Your Agent to Triggers**
Participants write trigger specifications for their Module 14 agent:
- Cron schedule for daily health checks
- Slack command for on-demand operations
- Webhook endpoint for alert-triggered workflows
- GitHub Action trigger for PR-based operations
- Test each trigger against the live agent

**Deliverable:** Trigger configuration with at least one cron schedule, one chat command, and one webhook

---

#### Module 16 — Domain Agents — Real-World Use Cases
**Duration:** 75 min (20 min concept + 55 min lab)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Domain-specific agent patterns for common DevOps roles:
  - Database Health & Tuning Agent
  - Cost Anomaly & FinOps Agent
  - Kubernetes Health & Self-Healing Agent
  - Incident RCA Agent
  - Deployment Safety Agent
- Each domain agent: what it monitors, what it proposes, what it needs approval for
- The impact assessment: what should be an agent? (The Automation Quadrant: frequency × complexity)

**Explainer Diagrams:**
1. Domain Agent Gallery (5 agents with their responsibilities)
2. The Automation Quadrant (frequency × complexity matrix)
3. Agent Impact Map (effort to build vs. value delivered)

**Lab: Build Your Domain Agent (Project Start)**
Three guided tracks (participants pick one):
- **Track A — Database Agent:** Connects to RDS PostgreSQL, analyzes performance, identifies tuning opportunities, proposes parameter changes with approval gates
- **Track B — Cost Agent:** Queries AWS Cost Explorer, detects unusual spending, generates daily reports with Slack notifications
- **Track C — Kubernetes Agent:** Monitors KIND cluster for pod issues, diagnoses root cause, proposes fixes with approval before any mutations

Build steps:
1. Design agent spec using Superpowers workflow
2. Write the Agent YAML with tools and skills
3. Write domain-specific skills
4. Test against live infrastructure
5. Add trigger (cron or webhook)

**Deliverable:** Domain agent with skills, tools, and at least one trigger — running against real infrastructure

---

### DAY 5: Enterprise Agentic DevOps + Capstone
*"From single agents to production agent systems"*

The final day elevates from individual agents to enterprise-grade systems. Multi-agent orchestration, governance, and the capstone project where teams present complete Agentic DevOps systems.

---

#### Module 17 — Multi-Agent Systems & Sub-Agents
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 3:** Agentic DevOps (Advanced)

**Concept (Explainer):**
- When single agents aren't enough — cross-domain incidents
  - Example: A slow application might need DB analysis + K8s pod inspection + cost check
- Multi-agent in 2026: Claude Code sub-agents (the practical approach)
  - Instead of building separate agent systems, Claude Code spawns specialized sub-agents
  - The coordinator pattern: one agent delegates to specialists
- Fleet coordination modes: round-robin, skill-based, hierarchical
- The manager pattern: coordinator delegates to specialists
- Shared memory and tool access across a fleet
- Fleet coordination in Hermes (if supported)

**Explainer Diagrams:**
1. Single Agent vs. Multi-Agent (when you need more than one)
2. The Sub-Agent Pattern in Claude Code (coordinator → specialists)
3. Fleet Coordination Modes (round-robin, skill-based, hierarchical)
4. Cross-Domain Incident Resolution (DB + K8s + Cost agents working together)

**Lab: Multi-Agent Incident Response**
- Teams of 3 combine their Module 16 domain agents into a coordinated fleet
- Simulate a cross-domain incident that requires database, infrastructure, and cost analysis
- Demonstrate sub-agent spawning in Claude Code
- Test the coordinated response
- Compare: one agent doing everything vs. specialized sub-agents

**Deliverable:** Fleet YAML / Sub-agent configuration coordinating 3 agents from different tracks

---

#### Module 18 — Governance — Making Agents Enterprise-Safe
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 3:** Agentic DevOps (Enterprise)

**Concept (Explainer):**
- The governance triad: what agents CAN do × what they need APPROVAL for × what gets LOGGED
- Agent maturity levels (progression model):
  - L1 Assistive: read-only, answers questions
  - L2 Advisory: analyzes, recommends, generates reports
  - L3 Proposal-driven: proposes changes, waits for human approval
  - L4 Semi-autonomous: acts within boundaries, escalates exceptions
- Promotion criteria: how agents earn more autonomy over time
  - Like a new employee: starts with supervision, earns trust, gets more responsibility
- Enterprise requirements: audit trails, RBAC, credential protection, rollback plans
- Approval workflows: channel routing, timeouts, escalation chains
- Credential scanning and redaction patterns

**Explainer Diagrams:**
1. The Governance Triad (CAN do × APPROVAL for × LOGGED)
2. Maturity Level Progression (L1 → L4 with promotion criteria)
3. Enterprise Safety Architecture (RBAC + Audit + Credential Protection + Rollback)
4. Approval Workflow (request → review → approve/deny → log)

**Lab: Add Governance to Your Agent**
Participants add a complete governance layer to their Day 4 domain agent:
- Maturity level assignment with promotion criteria
- Approval workflows with channel routing and timeouts
- Credential scanning and redaction patterns
- Audit logging configuration
- Rollback policies
- Test: attempt an action that requires approval, see the workflow in action

**Deliverable:** Governance configuration that passes enterprise security review standards

---

#### Module 19 — Capstone: Build Your Agentic DevOps System
**Duration:** 120 min (90 min build + 30 min presentations)
**All Pillars Combined**

Teams present their complete Agentic DevOps stack:

**Build Phase (90 min):**
- Finalize the domain agent from Day 4
- Add multi-agent coordination from Module 17
- Add governance layer from Module 18
- Add all triggers (schedule, chat, webhook)
- Run end-to-end test

**Presentation (30 min):**
Each team presents (5-7 min each):
- The operational problem being solved
- Agent architecture (YAML + skills + tools)
- Live demo against lab environment
- Trigger demonstration
- Governance spec with approval mode and maturity level

**Evaluation criteria:**
- Does the agent solve a real operational problem?
- Is it safe? (proper governance, approval flows)
- Is it connected? (triggers, interfaces)
- Would you deploy this in production?

**Deliverable:** Complete agent package — agent.yaml, skills, flow.yaml, governance.yaml

---

#### Module 20 — 30-Day Deployment Roadmap + What's Next
**Duration:** 45 min (30 min guided + 15 min reflection)
**Closing**

**Guided Roadmap Building:**
Each team drafts their 30-day deployment plan:
- Week 1: Deploy to staging in observe-only mode (L1)
- Week 2: Review logs, tune skills, fix false positives (L1 → L2)
- Week 3: Promote to advisory mode, enable Slack notifications (L2 → L3)
- Week 4: Review metrics, prepare promotion proposal (L3, evaluate for L4)

**What's Next:**
- Staying current: the agentic landscape is evolving fast
- Community and resources
- Advanced topics for self-study: fine-tuning for domain agents, vector databases for RAG, agent evaluation frameworks
- The future: where Agentic DevOps is heading

**Deliverable:** Written 30-day deployment plan

---

## Cross-Cutting: Excalidraw Diagrams Per Module

Every module includes 2-4 Excalidraw whiteboard diagrams following the B&W style:
- Black strokes on white background, hand-drawn/sketchy style
- Progressive reveal (build-up) for complex diagrams
- Title zone (top) → Main visual (middle) → Takeaway zone (bottom)
- 4:3 camera ratios, generous padding

Total estimated diagrams: ~55-65 across all 20 modules

---

## Cross-Cutting: Lab Environment

All labs run against real infrastructure:
- AWS account (free tier + small RDS, EC2 instances)
- KIND Kubernetes cluster (local) or managed EKS
- GitHub repository for code and CICD
- Claude Code (primary) with OpenCode as alternative
- MCP servers for AWS, K8s, GitHub, Postgres
- Hermes or equivalent for agent building (Day 4-5)

---

## Udemy Course Conversion Notes

The workshop naturally converts into a Udemy course with this structure:
- Each module becomes a Udemy section (20 sections)
- Explainer diagrams become the visual content
- Transcripts (from voiceover-video skill) serve as both narration and text lessons
- Labs become "follow along" coding sections
- Capstone becomes a "course project"
- Target: 20-25 hours of video content
- Each section: 4-8 lessons (intro, concepts, demo, lab walkthrough, summary)

---

## Summary: The 5-Day Journey

| Day | Theme | Pillar | Participants Go From → To |
|-----|-------|--------|---------------------------|
| 1 | Foundations + AI-Augmented DevOps | 1 | "AI is new to me" → "I can see AI features in my tools and connect them" |
| 2 | Harnesses + Agentic Engineering | 1→2 | "I can use AI tools" → "I understand how AI works and how to engineer context" |
| 3 | Tool Wiring + AgentDev | 2 | "I understand AI" → "I can build IaC and skills using AI" |
| 4 | Building Agents | 3 | "I can build with AI" → "I can build agents that work for me" |
| 5 | Enterprise + Capstone | 3 | "I have agents" → "I have a production-ready agentic system" |

**By the end of Day 5, every participant takes home:**
1. The AI Trinity Framework as their adoption roadmap
2. Working Claude Code setup with MCP connections
3. Domain-specific agentic skills (SKILL.md files)
4. At least one complete IaC project generated by AI
5. A working domain agent with triggers and governance
6. A 30-day deployment plan for their organization
