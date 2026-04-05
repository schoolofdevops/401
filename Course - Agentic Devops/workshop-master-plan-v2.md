# Agentic DevOps — 5-Day Corporate Workshop (v2)

**Building Agentic Skills for Infrastructure Automation**

Version: 2026 Edition (5-Day Corporate)
Trainer: Gourav Shah (Initcron)
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
└─────────────────────────────────────────────────────────────────┘
```

---

## Core Philosophy: Your Domain Expertise IS Your Superpower

A recurring theme throughout this workshop: **AI doesn't make domain experts irrelevant — it makes them exponentially more powerful.**

The chain works like this:

```
Domain Expertise → Better Vocabulary → Better Context → Better Results
```

A DevOps engineer who understands stateful sets vs. deployments, pod security policies vs. network policies, and when to use a service mesh — that person can describe exactly what they need. They have the *vocabulary*. An AI agent is only as good as the context it receives, and your domain expertise IS that context.

Think of it this way: giving Claude Code to someone who doesn't understand Kubernetes is like giving a Formula 1 car to someone who can't drive. The car is incredible, but without the skill, it's useless (or dangerous). Your 5 years of K8s experience? That's the driving skill. AI is the car.

This theme is introduced in Module 02 (AI Foundations), reinforced in Module 07 (Context Engineering), and demonstrated in every hands-on lab where domain-specific vocabulary directly produces better output.

---

## On the Pillar 2 Name: "Agentic Engineering"

We considered adding MLOps/LLMOps references, but decided against it. Here's why:

**Agentic Engineering** is the right name because:
- MLOps/LLMOps is a broader discipline (data pipelines, model training, deployment, retraining) that goes well beyond what we cover
- What we teach is specifically about understanding and working WITH agents — context engineering, memory, tool wiring
- Adding "MLOps" would set wrong expectations and attract the wrong crowd
- "Engineering" signals this is a hands-on discipline, not theory

**However**, we acknowledge the connection: "What you learn in Agentic Engineering gives you the foundational mental model for LLMOps. If you later dive into MLOps or LLMOps, these concepts — context, memory, RAG, tool integration — are the building blocks."

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

**What's new to them:** AI coding agents, MCP, context engineering, agentic workflows, agent building.

---

## Least-Barrier-to-Entry Strategy

This is critical: corporate participants face real constraints. We design for the lowest friction path.

### Tool Stack (Primary + Fallback)

| Purpose | Primary Tool | Fallback Tool | Why Fallback Exists |
|---------|-------------|---------------|---------------------|
| AI Coding Agent | Claude Code (Claude subscription) | Goose by Block (open source, free) | Not everyone has Claude subscription. Goose works with free Gemini API or local Ollama |
| AI Coding Agent (alt) | — | OpenCode (open source, free) | Node.js option for teams with Python restrictions |
| Agent Building Platform | Hermes (open source, Python) | Claude Code sub-agents | Hermes auto-installs Python 3.11, works with free Gemini/OpenRouter |
| LLM Provider | Claude (subscription) | Google Gemini free tier (1M tokens/month) | Universal free fallback. Groq and OpenRouter also offer free tiers |
| Cloud Infrastructure | AWS Free Tier | — | EC2 t2.micro, RDS db.t3.micro, CloudWatch — all free tier eligible |
| Kubernetes | KIND (local) | — | Zero cost, runs on laptop, no cloud dependency |
| Chat Interface | Slack (if available) | Telegram or Discord (free) | Hermes has built-in gateways for all three |
| Observability | CloudWatch (AWS free tier) | — | Datadog/Grafana shown as demo only (trainer's screen) |

### Corporate Installation Constraints

| Tool | Install Method | Corporate Approval Needed? |
|------|---------------|---------------------------|
| Claude Code | npm install -g | Low — Node.js is standard |
| Goose | Desktop app or CLI binary | Very Low — no dependencies |
| Hermes | Git clone + auto-installer | Low — auto-provisions Python 3.11 |
| OpenCode | npm or binary | Very Low — Go binary or Node.js |
| KIND (Kubernetes) | Binary download | Low — single binary |
| kubectl, terraform | Standard CLI tools | Already approved in most orgs |

### LLM Provider Setup (Pre-Workshop)

Participants need at least ONE of these before Day 1:
1. **Claude subscription** (Pro or Team) — best experience, works with Claude Code natively
2. **Google AI Studio account** (free) — 1M tokens/month, works with Goose, Hermes, OpenCode
3. **OpenRouter account** (free tier available) — access to 200+ models
4. **Groq account** (free) — fastest inference, 14,400 requests/day

We communicate this in pre-workshop setup instructions. Participants who have Claude use Claude Code. Those who don't, use Goose + Gemini. Everyone succeeds.

---

## The Reference Application: Voting App

All labs use a common reference application that participants deploy on Day 1 and work with throughout the workshop. We use the **Docker Samples Voting App** (https://github.com/dockersamples/example-voting-app) — a well-known, multi-tier microservices application.

### Why This App?

- **Multi-tier architecture:** Frontend (Python/Node.js) → Redis → Worker (.NET) → PostgreSQL → Results (Node.js)
- **Real database:** PostgreSQL gives us real DB monitoring, slow queries, Performance Insights labs
- **Kubernetes-ready:** Official K8s manifests included, deploys to KIND
- **Docker-native:** Simple docker-compose for local testing
- **Well-documented:** Participants may already know it
- **Multi-language:** Shows that AI agents work across languages

### What the App Gives Us for Labs

| Lab Topic | What We Use |
|-----------|-------------|
| Platform AI (Module 03) | RDS Performance Insights on the PostgreSQL backend, CloudWatch metrics |
| MCP Connections (Module 04) | Query K8s pods, check PostgreSQL stats, view GitHub PRs — all via MCP |
| Claude Code (Module 05) | Generate Ansible playbook for the app's EC2 deployment |
| Context Engineering (Module 07) | Build CLAUDE.md describing the voting app's architecture |
| Agentic Skills (Module 10) | Write health check skills for the voting app's components |
| IaC Generation (Module 11-12) | Generate Terraform for RDS, K8s manifests for voting app |
| Domain Agents (Module 16) | DB agent monitors PostgreSQL, K8s agent monitors pods, Cost agent tracks spending |
| Triggers (Module 15) | Webhook fires when voting app health degrades |

### Lab Infrastructure Setup (Pre-Workshop + Day 1)

**Pre-Workshop Setup (communicated 1 week before):**
- AWS account created (free tier)
- CLI tools installed: aws cli, kubectl, terraform, ansible, docker, git
- AI coding agent installed: Claude Code OR Goose
- LLM provider account: Claude subscription OR Google AI Studio (free)
- KIND installed for local Kubernetes
- Workshop GitHub repo cloned

**Day 1 Lab Setup (part of Module 01):**
- Deploy the Voting App to KIND (kubectl apply)
- Deploy PostgreSQL on RDS (free tier db.t3.micro) — via provided Terraform
- Deploy a basic EC2 instance (free tier t2.micro) — via provided Terraform
- Configure CloudWatch basic monitoring
- Verify all connections: app running, DB accessible, monitoring active
- Connect Claude Code to MCP servers (kubectl, aws, github, postgres)

**What the trainer provides (pre-built):**
- Terraform modules for RDS + EC2 (free tier, minimal config)
- K8s manifests for voting app deployment to KIND
- CloudWatch alarm configurations
- MCP server configuration files
- Sample CloudWatch alarm JSON (for Module 02 prompt engineering exercise)
- Sample slow query logs (for DB-related labs)
- GitHub Actions workflow templates (for Module 12)

This setup ensures that by the time Module 02 starts, every participant has:
- A running multi-tier application
- Real cloud infrastructure generating real metrics
- AI coding agent connected to real systems
- Everything needed for every subsequent lab

---

## Pillar 1: AI-Augmented DevOps — What We Demo vs. What They Do

Some platform AI features require paid tiers. Here's how we handle it:

| Feature | Free Tier? | Approach |
|---------|-----------|----------|
| RDS Performance Insights | Yes (free tier: 7-day retention) | Participants do hands-on |
| CloudWatch Anomaly Detection | Yes (basic) | Participants do hands-on |
| AWS Cost Explorer | Yes | Participants do hands-on |
| Q Developer | Yes (limited) | Participants try it |
| DevOps Guru | No (paid) | Trainer demonstrates |
| Predictive Scaling | Requires data history | Trainer demonstrates |
| Datadog Watchdog AI | No (paid) | Trainer demonstrates |
| Grafana Sift | No (paid) | Trainer demonstrates |
| PagerDuty AI | No (paid) | Trainer demonstrates |

---

## 5-Day Structure at a Glance

```
DAY 1: Foundations + AI-Augmented DevOps (Pillar 1 begins)
       "See what AI can already do for you"
       ├── M01: Welcome + The AI Trinity Framework + Lab Environment Setup
       ├── M02: AI Foundations for DevOps Teams (incl. Domain Expertise = Superpower)
       ├── M03: Platform AI — Features Already in Your Stack
       └── M04: Connecting to Everything with MCP

DAY 2: AI-Augmented DevOps contd. + Agentic Engineering begins (Pillar 1→2)
       "From using AI to understanding AI"
       ├── M05: Claude Code & Agentic Harnesses (Superpowers/GSD)
       ├── M06: How AI Actually Works — The Engine Under the Hood
       ├── M07: Context Engineering — Beyond Prompts (Domain Expertise Reinforced)
       └── M08: Agent Memory & Knowledge (Memory, RAGs, Vectorization)

DAY 3: Agentic Engineering contd. + AgentDev (Pillar 2)
       "From understanding AI to building with AI"
       ├── M09: Wiring Tools to Agents (MCP, CLI, Custom)
       ├── M10: Agentic Skills — Teaching Agents Your Runbooks
       ├── M11: AgentDev — AI-Assisted Infrastructure as Code
       └── M12: AgentDev — Multi-File IaC Projects with GSD + Sub-Agents

DAY 4: Agentic DevOps (Pillar 3 begins)
       "From building with AI to building AI agents"
       ├── M13: Agent Design Patterns & Autonomy Levels
       ├── M14: Building Your First Agent with Hermes
       ├── M15: Triggers, Scheduling & Chat Interfaces
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

The first day removes the fear and builds confidence. Participants discover AI is already in their tools. They deploy a real application, connect AI to real systems, and get their first "wow" moment.

---

#### Module 01 — Welcome + The AI Trinity Framework + Environment Setup
**Duration:** 75 min (30 min concept + 45 min setup lab)
**Pillar:** Foundation

**Concept (Explainer):**
- Why Agentic DevOps matters in 2026 — the shift from manual → automated → agentic
- The AI Trinity Framework: three pillars, three stages of adoption
- The driving analogy: Passenger → Mechanic → Driver
- Workshop roadmap: what we'll build by Day 5
- What agents DON'T replace (the human-in-the-loop philosophy)
- YOUR domain expertise IS your superpower (first introduction of the theme)

**Explainer Diagrams:**
1. The Evolution: Manual → Scripted → Automated → Agentic (timeline)
2. The AI Trinity Framework (three pillars with what fits where)
3. The 5-Day Journey Map (progressive build)

**Lab: Deploy the Workshop Environment**
This is the most critical lab — everything else depends on it.

Step 1: Verify pre-installed tools
- Check: aws cli, kubectl, terraform, ansible, docker, git, kind
- Check: Claude Code (or Goose as fallback)
- Check: LLM provider access (Claude subscription or Gemini API key)

Step 2: Deploy cloud infrastructure (provided Terraform)
- RDS PostgreSQL (db.t3.micro, free tier)
- EC2 instance (t2.micro, free tier)
- Security groups, basic networking
- CloudWatch basic monitoring enabled

Step 3: Deploy the Voting App to KIND
- Create KIND cluster
- Apply K8s manifests for the voting app
- Verify: frontend accessible, votes registering, results updating

Step 4: Connect Claude Code to MCP servers
- kubectl MCP server → connected to KIND cluster
- AWS MCP server → connected to AWS account
- GitHub MCP server → connected to workshop repo
- PostgreSQL MCP server → connected to RDS instance

Step 5: Smoke test — ask Claude Code a cross-platform question
- "Show me the pods running in my cluster and the RDS instance status"
- Confirm everything works end-to-end

**Deliverable:** Full working environment — cloud infra + K8s app + AI agent connected to all systems

**Trainer note:** Have a pre-built AMI/snapshot as backup for participants with setup issues. The setup lab has a troubleshooting guide for common problems.

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
  - Copilot = pair programming
  - Agent = delegating a task with guardrails
  - Squad = coordinated team of specialists
- Agent anatomy: Brain (LLM) + Skills (runbooks) + Tools (CLI/MCP) + Guardrails (approvals)

**THE DOMAIN EXPERTISE FRAMEWORK (Key concept):**
- Why your experience matters MORE in the age of AI, not less
- The chain: Domain Expertise → Better Vocabulary → Better Context → Better Results
- Example: A DevOps engineer says "create a K8s deployment with HPA, PDB, resource limits, and liveness/readiness probes targeting the voting-app frontend"
- Compare: A non-DevOps person says "deploy my app to Kubernetes"
- Same AI, dramatically different results — because of VOCABULARY
- Your 5 years of experience isn't replaced by AI — it's what makes AI 10x more useful

**Explainer Diagrams:**
1. The AI Spectrum (Chat → Copilot → Agent → Squad) with DevOps examples
2. Agent Anatomy (Brain + Skills + Tools + Guardrails)
3. Domain Expertise Chain (Expertise → Vocabulary → Context → Results) with before/after examples
4. Context Window as a War Room Whiteboard

**Lab: Your First AI Conversation (with real data)**
- Use Claude Code with a real CloudWatch alarm JSON from the voting app's RDS
- Progressive prompt engineering: vague prompt → structured prompt → context-rich prompt
- See how domain vocabulary directly changes the quality of analysis
- Exercise: Same alarm, prompt written by "non-DevOps person" vs. "SRE with 5 years of experience"

**Deliverable:** Optimized prompt template for operational diagnosis + firsthand proof that vocabulary matters

---

#### Module 03 — Platform AI — Features Already in Your Stack
**Duration:** 75 min (25 min concept + 50 min lab)
**Pillar 1:** AI-Augmented DevOps

**Concept (Explainer):**
- What platform AI is — AI features built into tools you already pay for
- AWS AI services landscape: Q Developer, DevOps Guru, Cost Anomaly Detection, RDS Performance Insights, Predictive Scaling
- Observability AI: Datadog Watchdog, Grafana Sift, CloudWatch anomaly detection
- What platform AI does well and where it falls short
  - Good at: single-platform analysis, pattern detection within its data
  - Weak at: cross-tool correlation, custom workflows, organizational context
- The gap between platform AI and custom agents — this is what Pillars 2 and 3 fill

**Explainer Diagrams:**
1. Platform AI Landscape (map of AI features across AWS, Datadog, Grafana)
2. The Platform AI Gap (what it covers vs. what's missing)
3. Before/After: Manual investigation vs. Platform AI assist

**Lab: Discover Platform AI (hands-on + demo)**
Hands-on (free tier):
- Enable RDS Performance Insights on the voting app's PostgreSQL
- Generate load on the voting app → observe Performance Insights detecting patterns
- Set up CloudWatch Anomaly Detection on EC2/RDS metrics
- Use Cost Explorer to analyze their AWS spending patterns
- Try Q Developer to explain a complex IAM policy

Trainer Demo (paid features):
- DevOps Guru analyzing an AWS environment
- Datadog Watchdog detecting anomalies
- Grafana Sift correlating logs with metrics

**Deliverable:** Written assessment of platform AI capabilities and gaps for their environment

---

#### Module 04 — Connecting to Everything with MCP
**Duration:** 75 min (25 min concept + 50 min lab)
**Pillar 1:** AI-Augmented DevOps

**Concept (Explainer):**
- What is MCP (Model Context Protocol) — the USB-C of AI
  - Analogy: Before USB-C, every device had its own charger. MCP is the universal connector between AI agents and your tools
- MCP architecture: Client ↔ Server ↔ Tool/Resource
- MCP vs. direct CLI vs. API calls — when to use what
- The MCP ecosystem: available servers for AWS, Kubernetes, GitHub, Datadog, Grafana, Postgres
- Using Claude Code + MCP vs. Goose + MCP (both work)
- Claude Desktop with MCP (for those without Claude Code)

**Explainer Diagrams:**
1. MCP as USB-C (the universal connector analogy)
2. MCP Architecture (Client → Server → Tool/Resource)
3. Before/After: Manually switching between 5 tools vs. one agent with MCP connections

**Lab: Cross-Platform Intelligence**
Building on the MCP connections from Module 01 setup:
- Run cross-platform queries against the voting app:
  - "Which pods have restarted in the last hour and what were the CloudWatch metrics at that time?"
  - "Show me the RDS slow query log entries and correlate with K8s pod resource usage"
  - "List all PRs merged this week that touched the voting app's Kubernetes manifests"
- Add a new MCP server: PostgreSQL direct (query the voting app's database)
- Optional: Try the same queries using Goose with MCP (show tool-agnostic nature)

**Deliverable:** Claude Code connected to 4+ MCP servers, working cross-platform queries against real infrastructure

---

### DAY 2: AI-Augmented DevOps contd. + Agentic Engineering
*"From using AI to understanding AI"*

Day 2 bridges Pillar 1 to Pillar 2. Morning continues hands-on power tools. Afternoon dives into HOW AI works — the understanding that makes everything else possible.

---

#### Module 05 — Claude Code & Agentic Harnesses
**Duration:** 90 min (25 min concept + 65 min lab)
**Pillar 1→2 Bridge**

**Concept (Explainer):**
- Claude Code deep dive — what it is, how it works, what makes it different
- Fallback: Goose and OpenCode for those without Claude subscriptions
- The concept of Agentic Harnesses — structured workflows that wrap around AI
- The Superpowers workflow: Brainstorm → Design → Blueprint → Implement → Validate
  - Analogy: Like an architect designing a building — you don't just start pouring concrete
- The GSD (Get Shit Done) workflow for larger, multi-file projects
  - Spec-driven: write the spec first, then let the agent implement
- Provider-agnostic usage: harness patterns work regardless of the AI tool

**Explainer Diagrams:**
1. The Superpowers Workflow (5-phase pipeline)
2. GSD Workflow (spec → implement → validate cycle)
3. Harness Comparison: Unstructured prompt vs. Superpowers vs. GSD (quality difference)

**Lab: The Superpowers Workflow in Action**
- Use the Superpowers workflow to build an Ansible playbook for hardening the voting app's EC2 instance
- Each phase is explicit and visible:
  - Brainstorm: What security measures does this EC2 need?
  - Design: What's the playbook structure?
  - Blueprint: What are the specific tasks, variables, handlers?
  - Implement: Generate the playbook
  - Validate: Lint with ansible-lint, dry-run against EC2
- Compare: run the same task with an unstructured prompt first, then Superpowers
- See the dramatic difference in quality and completeness

**For Goose users:** Same exercise using Goose with identical harness patterns. Show that the methodology is tool-agnostic.

**Deliverable:** A validated Ansible playbook created through the 5-step workflow

---

#### Module 06 — How AI Actually Works — The Engine Under the Hood
**Duration:** 60 min (45 min concept + 15 min interactive)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- What happens when you type something in Claude or ChatGPT — the full journey
- The two phases: Prefill and Decode
  - Prefill: AI reads and processes your entire input (like reading the whole email before responding)
  - Decode: AI generates the response token by token (like typing the reply one word at a time)
- Time to First Token (TTFT) — why there's a pause before output appears
- Token generation speed — why responses stream word by word
- Why this matters for agents: longer context = longer prefill = slower first response
  - This is why we DON'T stuff everything into context — trade-offs matter
- Context windows: the working memory limit
  - Analogy: Like RAM in a computer — there's a ceiling
  - 200K tokens ≈ a 500-page book, but more isn't always better
- Temperature, top-p: the creativity vs. consistency dial
  - For DevOps: low temperature almost always (consistent, predictable output)
  - For brainstorming: higher temperature (exploring options)

**Explainer Diagrams:**
1. The AI Processing Pipeline (Input → Prefill → Decode → Output with timing)
2. Context Window as RAM (what fills it up, what gets pushed out)
3. The Temperature Dial (Creative ↔ Consistent) with DevOps sweet spot

**Interactive Exercise:**
- Experiment with different context sizes and observe TTFT differences
- See how response quality changes with temperature settings
- Visualize token usage for different types of prompts
- Quick exercise: estimate token count for a typical K8s manifest vs. a Terraform module

**Deliverable:** Mental model of how AI processes requests and why it behaves the way it does

---

#### Module 07 — Context Engineering — Beyond Prompts
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- Prompt writing vs. Context Engineering — a critical distinction
  - Prompt = the question you ask
  - Context = the entire environment you set up BEFORE asking the question
  - Analogy: A prompt is like asking a new hire to fix a bug. Context engineering is like first giving them the codebase, the architecture docs, the runbook, and telling them which team owns what.
- **Domain Expertise Reinforced:** Your domain knowledge IS the context
  - The engineer who writes "check if the voting-app PostgreSQL has long-running transactions blocking the worker's COPY operations" gets a precise diagnosis
  - The generalist who writes "check if the database is slow" gets a generic checklist
  - Same AI, wildly different results — your expertise is the context
- The Context Stack: System prompt + CLAUDE.md + Skills + Memory + Tools + Conversation
- Designing effective CLAUDE.md files — the project-level context
- Context budgeting: what to include vs. what to keep out
  - Too much context is as bad as too little — signal-to-noise ratio matters

**Explainer Diagrams:**
1. Prompt vs. Context Engineering (iceberg analogy — prompt is the visible tip)
2. The Context Stack (layers from system prompt to conversation)
3. Context Budget (what fills the window and priority order)
4. Domain Expertise in Action (same question, different vocabulary, different results)

**Lab: Build Your Context Stack**
- Create a CLAUDE.md file for the voting app project
  - Include: architecture overview, component relationships, known issues, team conventions
- Design a system prompt for an operational agent that monitors the voting app
- Experiment: same operational question with minimal context vs. rich context stack
- Measure the difference in diagnosis quality
- Build a reusable context template for participants' own projects

**Deliverable:** CLAUDE.md file + system prompt template for the voting app (transferable to any project)

---

#### Module 08 — Agent Memory & Knowledge
**Duration:** 75 min (35 min concept + 40 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- The memory problem: AI agents are stateless — every conversation starts fresh
  - Analogy: A colleague with amnesia who forgets everything every morning
- Types of memory: Short-term (conversation), Long-term (persistent), Shared (team)
- Memory tools and approaches: Claude Memory (claude-mem), custom memory files, .claude/memory patterns

**Vectorization & Semantic Search (foundational understanding):**
- What are embeddings? Converting text into numbers that capture MEANING
  - Analogy: Like converting a city into GPS coordinates. "Paris" becomes [48.86, 2.35]. Similar cities have nearby coordinates. "London" might be [51.51, -0.13]. The numbers capture the ESSENCE of each city.
- What is vectorization? Converting your documents, runbooks, logs into these numerical representations
- What is semantic search? Finding information by MEANING, not just keywords
  - Traditional search: "pod crash" only finds documents containing those exact words
  - Semantic search: "pod crash" also finds "container OOMKilled", "CrashLoopBackOff", "restart loop" — because the MEANING is similar
- Vector databases: where these embeddings live (Chroma, Pinecone, pgvector, FAISS)

**RAG (Retrieval-Augmented Generation):**
- What is RAG: giving the AI a library card instead of making it memorize everything
- RAG Pipeline: Query → Vectorize → Search → Retrieve relevant chunks → Augment the prompt → Generate answer
- Agentic RAGs: agents that decide WHAT to look up and WHEN
  - The agent doesn't just answer — it searches, reasons, retrieves more if needed, then answers

**When to use what:**
- Memory: personal preferences, past decisions, learned patterns
- RAG: large knowledge bases, documentation, runbooks, incident history
- Context engineering: project-specific, session-specific information

**Explainer Diagrams:**
1. The Memory Problem (stateless agent vs. agent with memory)
2. Embeddings & Vectorization (text → numbers → similarity, with the GPS analogy)
3. Semantic Search vs. Keyword Search (finding related concepts)
4. RAG Pipeline (Query → Vectorize → Search → Retrieve → Augment → Generate)
5. Decision Tree: Memory vs. RAG vs. Context

**Lab: Give Your Agent Memory + Simple RAG**
- Set up Claude Memory (persistent memory across sessions)
- Have a conversation about the voting app, close it, start a new one — see memory in action
- Build a simple RAG pipeline:
  - Vectorize the voting app's README and documentation
  - Use a local vector store (Chroma or pgvector on the existing RDS)
  - Ask questions that require looking up documentation
  - Compare: with RAG vs. without RAG
- Demonstrate: "What's the architecture of the voting app?" — answers from memory + docs, not hallucination

**Deliverable:** Working memory setup + basic RAG pipeline for the voting app documentation

---

### DAY 3: Agentic Engineering contd. + AgentDev
*"From understanding AI to building with AI"*

Day 3 is where theory meets practice. Morning completes Agentic Engineering with tool wiring and skills. Afternoon is pure building — generating production-grade IaC with AI.

---

#### Module 09 — Wiring Tools to Agents
**Duration:** 60 min (20 min concept + 40 min lab)
**Pillar 2:** Agentic Engineering

**Concept (Explainer):**
- Tools give agents the ability to ACT, not just THINK
- Three tool integration patterns:
  1. Direct CLI: agent runs shell commands (kubectl, terraform, aws cli)
  2. CLI Wrappers: shell scripts with safety checks that agents call
  3. MCP Servers: standardized protocol for tool access (already used since Day 1)
- When to use which pattern:
  - CLI: quick, ad-hoc, read-only tasks
  - Wrappers: repeated tasks needing safety guardrails (e.g., prevent deleting production)
  - MCP: complex integrations, shared across agents
- Safety configuration: allowed commands, blocked commands, credential protection
  - CRITICAL: never let an agent run `kubectl delete namespace production` or `terraform destroy` without approval

**Explainer Diagrams:**
1. Three Tool Patterns (CLI → Wrapper → MCP) with trade-offs
2. Safety Layer Architecture (Agent → Safety Check → Tool → Infrastructure)
3. Decision Matrix: Which pattern for which use case

**Lab: Build Safe Tool Wrappers**
- Create a kubectl wrapper that:
  - Allows: get, describe, logs, top
  - Blocks: delete namespace, delete deployment (in production context)
  - Requires approval: scale, rollout restart
- Create an aws cli wrapper with similar safety boundaries
- Test: try to make Claude Code run a blocked command — see the safety layer catch it
- Document: which tools in your org should use which pattern

**Deliverable:** Working safe tool wrappers for kubectl and aws cli

---

#### Module 10 — Agentic Skills — Teaching Agents Your Runbooks
**Duration:** 90 min (30 min concept + 60 min lab)
**Pillar 2:** Agentic Engineering (Core Topic)

**Concept (Explainer):**
- What is an Agentic Skill — a structured, machine-readable runbook
  - Analogy: Converting your team's tribal knowledge from Post-it notes into a proper SOP that BOTH humans AND agents can follow
- The SKILL.md format: metadata, steps, commands, decision trees, escalation rules
- Skill lifecycle: Design → Validate → Version → Deploy → Improve
- How skills connect to agents, Claude Code, and automation frameworks
- Converting existing SOPs and runbooks into agentic skills
- **This is where Domain Expertise becomes tangible** — your SRE knowledge becomes a machine-readable skill

**Explainer Diagrams:**
1. From Runbook to Skill (before/after — messy wiki page vs. structured SKILL.md)
2. Anatomy of a SKILL.md (sections and what goes where)
3. Skill Lifecycle (Design → Validate → Version → Deploy → Improve)

**Lab: Write Your Domain-Specific Skills**
Using Claude Code, participants write SKILL.md files for the voting app:
- Track A (SRE): Health check skill — check all voting app components, correlate errors, escalate
- Track B (DevOps): Deployment safety check — pre-deploy verification for the voting app
- Track C (DBA): Slow query investigation — analyze PostgreSQL performance on the voting app's DB
- Track D (Observability): Alert noise analyzer — filter real alerts from noise on CloudWatch

Each skill must define: required inputs, at least 5 CLI commands, a decision table, escalation criteria.

Peer review: pairs exchange skills and test them by feeding to Claude Code.

**Deliverable:** Complete SKILL.md file with peer review feedback

---

#### Module 11 — AgentDev: AI-Assisted Infrastructure as Code
**Duration:** 90 min (20 min concept + 70 min lab)
**Pillar 2→3 Bridge**

**Concept (Explainer):**
- Using AI coding agents for production-quality IaC
- The Superpowers workflow applied to IaC (building on Module 05)
- Common AI failure modes in IaC generation:
  - Missing security groups, overly permissive IAM, hardcoded values, no state locking
- The human review checkpoint — AI proposes, human validates
- Domain expertise in action: knowing WHAT to check in AI-generated Terraform

**Explainer Diagrams:**
1. IaC Generation Pipeline (Brainstorm → Design → Blueprint → Implement → Validate)
2. Common AI IaC Failures (and the safety net of domain expertise)
3. Human-AI IaC Workflow (where human reviews happen)

**Lab: Generate Real IaC for the Voting App**
Participants pick one track (using Superpowers workflow):
- **Track A (Terraform):** RDS PostgreSQL module for voting app — CloudWatch alarms, SNS notifications, parameter groups, automated backups
- **Track B (Ansible):** PostgreSQL client setup on EC2 — monitoring agent, backup scripts, log rotation
- **Track C (Kubernetes):** Voting app deployment with HPA, resource limits, PodDisruptionBudget, health probes

Each track:
1. Brainstorm requirements (what does the voting app need?)
2. Design architecture (how should it be structured?)
3. Blueprint specs (variables, outputs, modules)
4. Implement with Claude Code (generate the code)
5. Validate (lint, plan/dry-run, peer review)

**For Goose users:** Identical exercise using Goose with the same harness patterns.

**Deliverable:** Production-quality IaC artifact, validated and applicable to the voting app

---

#### Module 12 — AgentDev: Multi-File Projects with GSD + Sub-Agents
**Duration:** 75 min (20 min concept + 55 min lab)
**Pillar 2→3 Bridge**

**Concept (Explainer):**
- When Superpowers isn't enough: multi-file, multi-component projects
- The GSD workflow for larger projects: write the spec first, let the agent implement
- Sub-agents in Claude Code — how modern multi-agent development works in 2026
  - Instead of building separate agent systems, Claude Code spawns sub-agents for different tasks
  - One agent coordinates, specialists handle different file types
- CICD pipeline generation as a multi-file example

**Explainer Diagrams:**
1. GSD Workflow (Spec → Implement → Review → Iterate)
2. Sub-Agents in Claude Code (coordinator → Terraform specialist → K8s specialist → CICD specialist)
3. Multi-File Project Output (what gets generated)

**Lab: Build a Complete CICD Pipeline for the Voting App**
- Write a GSD spec for a complete CICD pipeline:
  - GitHub Actions workflow (build, test, deploy)
  - Dockerfile improvements
  - K8s manifests for staging and production
  - Terraform for infrastructure updates
- Claude Code generates the full project using sub-agents
- Watch: the coordinator delegates to specialists (Terraform, K8s, CICD)
- Review each file, iterate on issues
- Deploy and test: push to GitHub, watch Actions run

**Deliverable:** Complete multi-file CICD project generated through GSD workflow

---

### DAY 4: Agentic DevOps — Building Agents
*"From building with AI to building AI agents"*

Day 4 is the transformation. Participants shift from USING AI tools to BUILDING AI agents. They become agent architects — designing, building, and deploying agents using Hermes.

---

#### Module 13 — Agent Design Patterns & Autonomy Levels
**Duration:** 60 min (40 min concept + 20 min workshop exercise)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- The shift: from AI user to Agent Architect / Platform Engineer
  - You're now the person who MANAGES the AI, not just uses it
  - You become the orchestrator, the designer, the governor
- Single-agent patterns: Advisor → Investigator → Proposal → Guardian
  - Advisor: "Here's what I think about this alert"
  - Investigator: "Let me dig into this and report back"
  - Proposal: "Here's what I'd do, approve to proceed"
  - Guardian: "I'm watching and will flag issues proactively"
- Multi-agent patterns: Sequential pipeline, Parallel investigation, Hierarchical
- The Autonomy Spectrum:
  - L1 Assistive: answers questions, reads data only
  - L2 Advisory: analyzes and recommends
  - L3 Proposal-driven: proposes changes, waits for approval
  - L4 Semi-autonomous: acts within boundaries, escalates exceptions
- How to choose: risk × frequency × blast radius
- Reference architecture walkthrough of a production multi-agent system

**Explainer Diagrams:**
1. Single-Agent Patterns (Advisor → Investigator → Proposal → Guardian)
2. The Autonomy Spectrum (L1 → L4 with trust progression)
3. Multi-Agent Patterns (Sequential, Parallel, Hierarchical)
4. Agent Architect Role (you become the orchestrator/platform engineer)

**Workshop Exercise:**
- Map 3 operational tasks from their daily work to agent patterns
- Assign autonomy levels based on risk and frequency
- Sketch the agent architecture for their top candidate
- Peer discussion: why this pattern? What could go wrong?

**Deliverable:** Agent architecture sketch for their top automation candidate

---

#### Module 14 — Building Your First Agent with Hermes
**Duration:** 90 min (25 min concept + 65 min lab)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Hermes: open source, works with free Gemini/OpenRouter, auto-installs Python
- Why Hermes for agent building:
  - 40+ built-in tools, scheduling, chat gateways (Slack/Telegram/Discord)
  - Model switching with one command (use free Gemini, switch to Claude when needed)
  - Self-improving: learns from completed tasks
- Alternative: Claude Code sub-agents (for those already using Claude Code)
- Agent definition: model, instructions, tools, skills, safety rules
- Connecting Hermes to the skills we built on Day 3

**Explainer Diagrams:**
1. Agent Definition Anatomy (model + instructions + tools + skills + safety)
2. Hermes Architecture (agent core + tools + gateways + memory)
3. From Definition to Running Agent (the build-and-test cycle)

**Lab: Build Your First Hermes Agent**
Step 1: Install Hermes (auto-installer, ~2 min)
Step 2: Configure LLM provider (Gemini free tier or Claude)
Step 3: Build a health check agent for the voting app:
- Give it the SKILL.md from Module 10
- Wire kubectl and aws cli tools
- Configure safety boundaries (read-only to start)
- Test: "Check the health of the voting app" → agent investigates pods, DB, metrics
- Test: "What's causing the high response time?" → agent correlates across systems

Step 4: Iterate and improve
- Add more tools (PostgreSQL direct access)
- Expand the skill (add more investigation paths)
- Test edge cases

**For Claude Code users (alternative):** Build the same agent as a Claude Code custom sub-agent with skills and tool restrictions.

**Deliverable:** Working Hermes agent (or Claude Code sub-agent) that can investigate voting app health

---

#### Module 15 — Triggers, Scheduling & Chat Interfaces
**Duration:** 75 min (25 min concept + 50 min lab)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Agents running in CLI are useful for development — but production needs triggers
- Five trigger patterns:
  1. Schedule (cron): "Check health every morning at 9 AM"
  2. Chat command: "Hey agent, investigate this alert" via Slack/Telegram
  3. Webhook: monitoring alert → agent automatically investigates
  4. Code event: PR created → agent reviews infrastructure changes
  5. Ticket: Jira ticket created → agent gathers context and proposes solution
- Hermes built-in: cron scheduling + Telegram/Discord/Slack gateways
- Webhook integration: how to connect monitoring → agent
- Mission Control: tracking what your agents are doing

**Explainer Diagrams:**
1. Five Trigger Patterns (with voting app examples for each)
2. Webhook Flow: CloudWatch Alarm → SNS → Lambda → Hermes Agent → Slack Report
3. Chat Interface: Telegram/Slack as agent command center
4. Mission Control Dashboard (managing deployed agents)

**Lab: Wire Your Agent to the Real World**
Using the Module 14 agent:
- Set up cron schedule: daily health check at 9 AM (Hermes built-in scheduler)
- Set up Telegram bot (free, instant): send commands to your agent via Telegram
  - "/health" → agent checks all voting app components
  - "/investigate <issue>" → agent runs targeted investigation
- Set up webhook trigger:
  - Create a CloudWatch alarm on voting app metrics
  - Connect via SNS → simple Lambda → Hermes webhook
  - Trigger the alarm (spike load on voting app) → watch agent auto-investigate
- Test the full loop: alarm fires → agent investigates → report appears in Telegram

**Deliverable:** Agent with cron schedule + Telegram commands + at least one webhook trigger

---

#### Module 16 — Domain Agents — Real-World Use Cases
**Duration:** 75 min (20 min concept + 55 min project work)
**Pillar 3:** Agentic DevOps

**Concept (Explainer):**
- Domain-specific agent patterns for the voting app and beyond:
  - Database Health Agent: monitors PostgreSQL, identifies slow queries, proposes tuning
  - Cost Anomaly Agent: tracks AWS spending, flags anomalies, suggests optimizations
  - Kubernetes Health Agent: monitors pods, diagnoses CrashLoopBackOff, proposes fixes
  - Incident RCA Agent: correlates signals across DB + K8s + metrics for root cause
- The Automation Quadrant: frequency × complexity — not everything should be an agent
- Building on the base agent from Module 14: adding domain specialization

**Explainer Diagrams:**
1. Domain Agent Gallery (4 agents with their responsibilities and the voting app)
2. The Automation Quadrant (frequency × complexity matrix)
3. Agent Specialization (base agent + domain skill = domain agent)

**Lab: Build Your Domain Agent (Capstone Project Start)**
Three guided tracks:
- **Track A — Database Agent:** Connects to voting app's PostgreSQL. Monitors slow queries, connection count, replication lag. Proposes index creation, parameter tuning. Requires approval for any write operations.
- **Track B — Cost Agent:** Queries AWS Cost Explorer. Monitors voting app infrastructure costs. Flags when EC2/RDS spending exceeds threshold. Generates daily cost report to Telegram.
- **Track C — Kubernetes Agent:** Monitors voting app pods in KIND. Detects CrashLoopBackOff, ImagePullBackOff, resource pressure. Proposes scaling changes, restart recommendations. Requires approval before any mutations.

Build steps:
1. Design agent spec (from Module 13 workshop exercise)
2. Write the agent configuration with Hermes
3. Attach domain-specific skill (from Module 10)
4. Wire tools with safety boundaries (from Module 09)
5. Add trigger (cron or webhook)
6. Test against live voting app infrastructure

**Deliverable:** Domain agent with skills, tools, triggers — running against real infrastructure

---

### DAY 5: Enterprise Agentic DevOps + Capstone
*"From single agents to production agent systems"*

The final day elevates from individual agents to enterprise-grade systems. Multi-agent orchestration, governance, and the capstone project.

---

#### Module 17 — Multi-Agent Systems & Sub-Agents
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 3:** Agentic DevOps (Advanced)

**Concept (Explainer):**
- When single agents aren't enough — the voting app incident scenario:
  - App is slow. Is it the DB? The pods? A cost spike from runaway scaling? All three?
  - You need multiple specialists working together
- Multi-agent in 2026 — two practical approaches:
  1. Claude Code sub-agents: built-in, the coordinator spawns specialists
  2. Hermes with multiple agents: each agent has a domain, share memory
- Fleet coordination modes: round-robin, skill-based, hierarchical
- The manager pattern: coordinator delegates, specialists report back
- Shared memory and context across agents

**Explainer Diagrams:**
1. The Incident Scenario (single agent struggling vs. coordinated team)
2. Sub-Agent Pattern (coordinator → DB specialist → K8s specialist → Cost specialist)
3. Fleet Coordination Modes (when to use which)
4. Cross-Domain Resolution (how agents collaborate on a complex incident)

**Lab: Multi-Agent Incident Response**
- Teams of 3 combine their Module 16 domain agents
- Simulate a complex incident on the voting app:
  - Inject: slow queries + pod restarts + cost spike (all related)
  - Single agent tries to diagnose — struggles with cross-domain
  - Coordinated agents: DB agent + K8s agent + Cost agent work together
- Demonstrate Claude Code sub-agents for cross-domain investigation
- Compare: time to root cause with single vs. multi-agent

**Deliverable:** Multi-agent configuration coordinating 3 domain agents

---

#### Module 18 — Governance — Making Agents Enterprise-Safe
**Duration:** 75 min (30 min concept + 45 min lab)
**Pillar 3:** Agentic DevOps (Enterprise)

**Concept (Explainer):**
- The governance triad: what agents CAN do × what needs APPROVAL × what gets LOGGED
- Agent maturity levels (maps to the Autonomy Spectrum from Module 13):
  - L1 Assistive → L2 Advisory → L3 Proposal-driven → L4 Semi-autonomous
- Promotion criteria: how agents earn more autonomy over time
  - Like a new employee: starts with supervision, earns trust, gets more responsibility
  - Metrics-based: accuracy rate, false positive rate, time to resolution
- Enterprise requirements: audit trails, RBAC, credential protection, rollback plans
- Approval workflows: who approves what, timeout handling, escalation chains
- Credential scanning and redaction — agents must NEVER log secrets

**Explainer Diagrams:**
1. The Governance Triad (CAN do × APPROVAL for × LOGGED)
2. Maturity Level Progression (L1 → L4 with promotion criteria)
3. Enterprise Safety Architecture (RBAC + Audit + Credential Protection + Rollback)
4. Approval Workflow (request → review → approve/deny → log)

**Lab: Add Governance to Your Agent**
- Assign maturity level to your domain agent (most start at L2)
- Configure approval workflow:
  - L2 actions (recommendations): auto-approved, logged
  - L3 actions (proposed changes): require Telegram approval
  - L4 actions (automated fixes): blocked unless explicitly promoted
- Add credential scanning (redact any secrets from agent logs)
- Add audit logging (every agent action is recorded)
- Add rollback policy (how to undo an agent's action)
- Test: trigger an action that requires approval → approve via Telegram → see audit log

**Deliverable:** Governance configuration with maturity levels, approvals, and audit logging

---

#### Module 19 — Capstone: Build Your Agentic DevOps System
**Duration:** 120 min (80 min build + 40 min presentations)
**All Pillars Combined**

**Build Phase (80 min):**
Teams finalize their complete Agentic DevOps system for the voting app:
- Finalize domain agent(s) from Day 4
- Add multi-agent coordination from Module 17
- Add governance layer from Module 18
- Wire all triggers (schedule, chat, webhook)
- Run end-to-end test: simulate incident → agent detects → investigates → proposes fix → requests approval → logs everything

**Presentation Phase (40 min):**
Each team presents (7-8 min each):
- The operational problem being solved
- Agent architecture (which patterns, which autonomy level)
- Live demo against the voting app
- Trigger demonstration (trigger an incident, watch the agent respond)
- Governance: how it's enterprise-safe
- What they'd do differently with more time

**Evaluation criteria:**
- Does it solve a real operational problem?
- Is it safe? (governance, approvals)
- Is it connected? (triggers, chat interface)
- Could this run in production with the right promotion path?

**Deliverable:** Complete agent system — agent config, skills, triggers, governance, audit logs

---

#### Module 20 — 30-Day Deployment Roadmap + What's Next
**Duration:** 45 min (30 min guided + 15 min reflection)
**Closing**

**Guided Roadmap Building:**
Each participant drafts their personal 30-day plan:
- Week 1: Deploy agent to staging in observe-only mode (L1). Collect baseline data.
- Week 2: Review logs, tune skills, fix false positives. Promote to L2 (advisory).
- Week 3: Enable Slack/Telegram notifications. Share with team. Get feedback. Consider L3.
- Week 4: Review accuracy metrics. Prepare promotion proposal for leadership. Plan next agent.

**What's Next:**
- The landscape is evolving fast — how to stay current
- Advanced topics for self-study:
  - Fine-tuning for domain-specific agents
  - Advanced RAG with production vector databases
  - Agent evaluation and benchmarking frameworks
  - Enterprise agent platforms (beyond Hermes)
- Community: where to find help, share skills, learn from others
- The bigger picture: where Agentic DevOps fits in the future of platform engineering

**Deliverable:** Written 30-day deployment plan personalized to their organization

---

## Viability Checklist: Can We Actually Build All This?

This section verifies that every lab is realistic, buildable, and uses real infrastructure.

### Infrastructure Dependencies (All Free Tier)

| Component | Provider | Cost | Used Starting From |
|-----------|----------|------|-------------------|
| EC2 t2.micro | AWS Free Tier | $0 | Day 1, Module 01 |
| RDS db.t3.micro PostgreSQL | AWS Free Tier | $0 | Day 1, Module 01 |
| CloudWatch basic | AWS Free Tier | $0 | Day 1, Module 03 |
| KIND Kubernetes cluster | Local | $0 | Day 1, Module 01 |
| Docker Voting App | Open source | $0 | Day 1, Module 01 |
| GitHub repo | Free | $0 | Day 1, Module 01 |
| Claude Code or Goose | Sub or Free | $0-20/mo | Day 1, Module 01 |
| Gemini API (fallback) | Free tier | $0 | Day 1, Module 01 |
| Hermes | Open source | $0 | Day 4, Module 14 |
| Telegram Bot | Free | $0 | Day 4, Module 15 |
| SNS + Lambda (webhook) | AWS Free Tier | $0 | Day 4, Module 15 |

### Lab Build Sequence Verification

Each lab ONLY uses components that were set up in a previous module:

| Module | Lab Depends On | Verified Available? |
|--------|---------------|-------------------|
| M01 | Pre-workshop install + provided Terraform | Yes — we provide Terraform + K8s manifests |
| M02 | M01 environment + CloudWatch alarm JSON | Yes — alarm exists from M01 RDS setup |
| M03 | M01 RDS + EC2 + CloudWatch | Yes — deployed in M01 |
| M04 | M01 MCP connections | Yes — configured in M01 |
| M05 | M01 EC2 instance (for Ansible target) | Yes — deployed in M01 |
| M06 | Any LLM access | Yes — Claude or Gemini |
| M07 | M01 voting app + Claude Code | Yes |
| M08 | M01 voting app docs + Claude/Gemini | Yes — we provide docs to vectorize |
| M09 | M01 kubectl + aws cli | Yes |
| M10 | M01 voting app + Claude Code | Yes |
| M11 | M01 RDS/EC2/K8s + M05 harness knowledge | Yes |
| M12 | M01 environment + M11 IaC | Yes |
| M13 | Conceptual only (workshop exercise) | Yes — no infra needed |
| M14 | M01 environment + M10 skills + Hermes | Yes — Hermes installs in 2 min |
| M15 | M14 agent + Telegram (free) | Yes |
| M16 | M14 agent + M10 skills + M01 infra | Yes |
| M17 | M16 domain agents (team exercise) | Yes |
| M18 | M16 domain agent | Yes |
| M19 | All previous | Yes — capstone combines everything |
| M20 | Conceptual (roadmap exercise) | Yes — no infra needed |

### What the Trainer Must Pre-Build

These artifacts need to be created and included in the workshop GitHub repo:

1. **Terraform modules:** RDS + EC2 setup (free tier, idempotent, documented)
2. **K8s manifests:** Voting app deployment for KIND (adapted from official repo)
3. **MCP configuration files:** kubectl, aws, github, postgres server configs
4. **Sample data:** CloudWatch alarm JSON, sample slow query logs, cost report JSON
5. **Skill templates:** Starter SKILL.md files for each track (SRE, DevOps, DBA, Observability)
6. **Claude Code configuration:** .claude/settings, CLAUDE.md for the voting app project
7. **Hermes starter config:** Base configuration with Gemini free tier
8. **GitHub Actions templates:** Starter workflows for Module 12
9. **Troubleshooting guide:** Common setup issues and fixes
10. **Pre-built AMI/snapshot:** Backup for participants with persistent setup issues

---

## Udemy Course Conversion Notes

The workshop converts to a Udemy course:
- Each module → Udemy section (20 sections)
- Each section: 4-8 video lessons (title card + explainer diagrams + transcript)
- Total: ~100-120 video lessons, 20-25 hours of content
- Explainer diagrams → Excalidraw whiteboard videos (progressive reveal)
- Lab walkthroughs → screen recording with narration
- Capstone → "Course Project" section
- 30-day roadmap → "Next Steps" bonus section

---

## Summary: The 5-Day Journey

| Day | Theme | Pillar | Transformation |
|-----|-------|--------|----------------|
| 1 | Foundations + AI-Augmented DevOps | 1 | "AI is new to me" → "I can see and connect AI in my tools" |
| 2 | Harnesses + Agentic Engineering | 1→2 | "I use AI tools" → "I understand how AI works and engineer context" |
| 3 | Tool Wiring + AgentDev | 2 | "I understand AI" → "I build IaC and skills using AI" |
| 4 | Building Agents | 3 | "I build with AI" → "I build agents that work for me" |
| 5 | Enterprise + Capstone | 3 | "I have agents" → "I have a production-ready agentic system" |

**By the end of Day 5, every participant takes home:**
1. The AI Trinity Framework as their adoption roadmap
2. Working AI coding agent setup (Claude Code or Goose) with MCP connections
3. Understanding of how AI works (prefill/decode, context, memory, RAG, vectorization)
4. Domain-specific agentic skills (SKILL.md files)
5. Production-quality IaC generated by AI (Terraform, Ansible, or K8s)
6. A complete CICD pipeline generated through GSD workflow
7. A working Hermes agent with triggers (cron, Telegram, webhook) and governance
8. A 30-day deployment plan for their organization
