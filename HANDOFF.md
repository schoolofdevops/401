# Course Content Handoff — Agentic DevOps Workshop

**Purpose:** Maps every module in the course to what THIS project builds vs what needs to be built separately. Use this to parallelize content creation.

---

## Learner Profile

**Who:** DevOps practitioners / SREs. Strong SDLC, Terraform/Ansible/K8s, CI/CD, git, CLI tools.
**AI knowledge:** ZERO. Completely new to LLMs, agents, AI-assisted automation.

The course must build their AI mental model from scratch using operational analogies they already understand.

---

## Conceptual Curriculum — What Participants Must Learn

This is the knowledge foundation the course needs to teach. Each concept maps to specific modules and needs explainers (Excalidraw/slides), reading materials, and quiz questions.

### Layer 1 — How LLMs Work (Module 1)

| Concept | Operational Analogy | Explainer Needed | Reading Needed |
|---------|---------------------|:----------------:|:--------------:|
| **Tokenization** — text → numbers, subword units, cost implications | Like log parsing — text gets broken into structured units | Yes (visual) | Yes |
| **Context window** — fixed memory, the #1 constraint | Like container memory limits — exceed it and things break | Yes (visual) | Yes |
| **Inference pipeline** — Prefill (process all input) → Decode (generate one token at a time) | Like a 2-phase deploy — first load state, then process requests serially | Yes (diagram) | Yes |
| **Temperature** — randomness/creativity in output | Like a load balancer — low temp = always pick best server, high temp = random selection | Yes | Yes |
| **Top-P / Top-K** — vocabulary filtering during generation | Like admission control — Top-K = "only consider top N candidates", Top-P = "consider candidates until probability budget exhausted" | Yes | Yes |
| **Prompt engineering** — system prompts, few-shot, chain-of-thought | Like writing good runbooks — the more structured your input, the better the output | Yes + Lab | Yes |
| **Token economics** — input/output pricing, caching, batching | Like cloud billing — understand the meter before you run the workload | Yes | Yes |

### Layer 2 — From Chat to Agents (Module 1 → Module 3)

| Concept | Operational Analogy | Explainer Needed | Reading Needed |
|---------|---------------------|:----------------:|:--------------:|
| **The AI spectrum** — Chat → Copilot → Agent → Squad | Like automation maturity: manual → scripted → orchestrated → self-healing | Yes (visual) | Yes |
| **Tool calling / Function calling** — LLM invokes external tools via JSON schema | Like an API gateway — LLM decides which endpoint to call and with what params | Yes (diagram) | Yes |
| **The agent loop** — Observe → Think → Act → Observe (ReAct) | Like a monitoring feedback loop — detect, analyze, remediate, verify | Yes (diagram) | Yes |
| **Context engineering** — managing what the LLM sees (THE core agent-building skill) | Like Kubernetes resource management — what you put in the pod spec determines behavior | Yes (deep) | Yes (deep) |
| **Structured output** — getting parseable results (JSON mode, schemas) | Like API response contracts — define the schema, enforce the format | Yes | Yes |

### Layer 3 — Knowledge & Memory (Module 3 → Module 7)

| Concept | Operational Analogy | Explainer Needed | Reading Needed |
|---------|---------------------|:----------------:|:--------------:|
| **RAG** — Retrieval-Augmented Generation (retrieve → augment → generate) | Like incident response — first pull relevant logs/metrics, then analyze | Yes (diagram) | Yes |
| **Embeddings & semantic search** — text → vectors, similarity matching | Like container image layers — similar content has similar fingerprints | Yes (visual) | Yes |
| **Vector databases** — specialized storage for embedding vectors | Like a time-series DB but for meaning — optimized for "find similar" queries | Yes | Yes |
| **Agentic RAG** — agent decides WHEN and WHAT to retrieve | Like an SRE who knows which dashboards to check vs a static alert rule | Yes | Yes |
| **Graph RAG** — knowledge graphs + RAG for connected information | Like a service mesh map — understands relationships, not just individual nodes | Yes | Reading only |
| **Memory types** — short-term (conversation), long-term (cross-session), procedural (skills) | Like state management: in-memory cache, persistent DB, stored procedures | Yes | Yes |

### Layer 4 — Agentic Tools & Integration (Module 7 → Module 8)

| Concept | Operational Analogy | Explainer Needed | Reading Needed |
|---------|---------------------|:----------------:|:--------------:|
| **Tool types** — CLI (subprocess), API (HTTP), MCP (protocol) | Like infrastructure access patterns: SSH, REST API, service mesh sidecar | Yes | Yes + Lab |
| **MCP (Model Context Protocol)** — standard tool integration protocol | Like the Container Runtime Interface (CRI) — standardized interface so tools are swappable | Yes (diagram) | Yes + Lab |
| **Tool safety** — allowed/blocked lists, sandboxing, credential protection | Like RBAC + network policies — define what the agent CAN and CANNOT do | Yes | Yes + Lab |
| **Skills as procedural memory** — machine-readable runbooks for agents | Like Ansible playbooks — structured, versioned, testable instructions | Yes | Yes + Lab |

### Layer 5 — Multi-Agent & Production (Module 9 → Module 13)

| Concept | Operational Analogy | Explainer Needed | Reading Needed |
|---------|---------------------|:----------------:|:--------------:|
| **Agent design patterns** — advisor, investigator, proposal, guardian | Like team roles: on-call (advisor), root-cause analyst (investigator), change manager (proposal), security reviewer (guardian) | Yes (visual) | Yes |
| **Delegation / sub-agents** — agent spawns specialized child agents | Like microservices — coordinator delegates to specialists, aggregates results | Yes (diagram) | Yes + Lab |
| **Autonomy spectrum** — L1 Assistive → L2 Advisory → L3 Proposal → L4 Semi-autonomous | Like deployment strategies: manual → canary → blue-green → auto-scaling | Yes (visual) | Yes |
| **Human-in-the-loop** — approval gates, escalation, timeouts | Like change management — PR review before merge, approval before production deploy | Yes | Yes + Lab |
| **Governance triad** — DO × APPROVE × LOG | Like the security triad (CIA) — what it can do, what needs sign-off, what gets audited | Yes | Yes + Lab |
| **Production interfaces** — cron, webhooks, chat, dashboards | Like service exposure: cronjob, ingress webhook, Slack bot, Grafana dashboard | Yes | Yes + Lab |

### Cross-Cutting Concepts (Throughout)

| Concept | Where Used | Notes |
|---------|-----------|-------|
| **Prompt injection** — adversarial input that hijacks agent behavior | Module 8, 13 | Security-minded audience will appreciate this |
| **Hallucination** — LLM generating false information confidently | Module 1, 7 | Why skills need decision trees, not open-ended reasoning |
| **Cost optimization** — prompt caching, batching, model selection | Module 1, all labs | Especially important given no-paid-API constraint |
| **Determinism vs creativity** — when you want consistent output vs exploration | Module 1, 7 | Skills need low temperature; brainstorming needs high |
| **Evaluation** — how to measure if an agent is actually useful | Module 4, 13 | Ties to impact assessment and governance |

---

## Coverage Matrix

| Module | Title | Built Here (Hermes) | Built Separately | Content Types |
|--------|-------|:-------------------:|:----------------:|---------------|
| 1 | AI Foundations for Operations | -- | **Full** | Explainer, Reading, Lab, Quiz |
| 2 | Platform AI — Features in Your Stack | -- | **Full** | Explainer, Reading, Lab, Quiz |
| 3 | From Platform AI to Custom Agents | Partial | Partial | Explainer, Reading, Demo, Quiz |
| 4 | Impact Assessment | -- | **Full** | Explainer, Reading, Exercise, Quiz |
| 5 | Structured AI Coding with OpenCode | -- | **Full** | Explainer, Reading, Lab, Quiz |
| 6 | AI-Assisted Infrastructure as Code | -- | **Full** | Explainer, Reading, Lab, Quiz |
| 7 | Agent Skills — Teaching Agents Runbooks | **Full** | -- | Explainer, Reading, Lab, Quiz |
| 8 | Wiring Tools to Agents | **Full** | -- | Explainer, Reading, Lab, Quiz |
| 9 | Agent Design Patterns | Partial | Partial | Explainer, Reading, Quiz |
| 10 | Build Project — Your Domain Agent | **Full** | -- | Lab (3 tracks), Reference agents |
| 11 | Fleet Orchestration | **Full** | -- | Explainer, Reading, Lab, Quiz |
| 12 | Triggers, Scheduling, Interface | **Full** | -- | Explainer, Reading, Lab, Quiz |
| 13 | Governance — Enterprise-Safe | **Full** | -- | Explainer, Reading, Lab, Quiz |
| 14 | Capstone — Demo and 30-Day Plan | Template | Partial | Presentation template, Rubric |

---

## What THIS Project Builds (Hermes-Focused)

### Module 7 — Agent Skills (FULL)

**Lab: Write Domain-Specific SKILL.md**

4 track options, each participant picks one:
1. **SRE Track**: EC2 health check skill — inputs (instance-id, region), 5+ CLI commands (aws ec2 describe-instances, CloudWatch get-metric-data, etc.), decision tree, escalation rules
2. **DevOps Track**: Deployment safety check skill — pre-deploy validation, rollback criteria, canary checks
3. **DBA Track**: RDS slow query investigation — pg_stat_statements analysis, index recommendations, parameter tuning suggestions
4. **Observability Track**: Alert noise analyzer — dedup detection, correlation scoring, snooze recommendations

**Reading Material:**
- SKILL.md format reference with annotated examples
- Skill lifecycle: Design → Validate → Version → Deploy → Improve
- How skills connect to agents (prompt injection, conditional loading)
- Comparison: runbook wiki vs SKILL.md (why machine-readable matters)

**What's built:**
- 4 complete SKILL.md reference implementations
- Lab guide with step-by-step instructions
- Reading material (markdown)

---

### Module 8 — Wiring Tools to Agents (FULL)

**Lab: Connect Tools and Set Safety Boundaries**

Participants:
1. Create a Hermes profile for their agent
2. Write SOUL.md with agent identity and instructions
3. Configure toolsets in config.yaml (terminal, web, file)
4. Set up allowed/blocked command lists
5. Attach their Module 7 skill
6. Test agent against lab environment (or simulated infra)

**Reading Material:**
- Three tool integration patterns: Direct CLI, CLI wrappers with safety, MCP servers
- Safety configuration: allowed commands, blocked commands, credential protection
- When to use CLI vs MCP (decision framework)
- Writing custom tool wrappers (advanced)

**What's built:**
- Profile template configs for each track
- Safety config examples (allowed/blocked commands)
- MCP server example for Kubernetes (optional)
- Lab guide
- Reading material

---

### Module 10 — Build Project: Domain Agent (FULL — 3 Tracks)

**Track A: Database Health & Tuning Agent**
- Connects to RDS PostgreSQL (or simulated)
- Skills: slow query analysis, parameter tuning, connection pool monitoring
- Tools: terminal (psql, aws rds), web (docs lookup)
- Safety: read-only by default, parameter changes require approval
- Simulated mode: mock pg_stat_statements output, mock CloudWatch metrics

**Track B: Cost Anomaly & FinOps Agent**
- Queries AWS Cost Explorer (or simulated)
- Skills: cost trend analysis, resource right-sizing, unused resource detection
- Tools: terminal (aws ce, aws ec2), web (pricing lookups)
- Safety: read-only, no resource modifications without approval
- Simulated mode: mock Cost Explorer JSON, mock EC2 instance lists

**Track C: Kubernetes Health & Self-Healing Agent**
- Monitors KIND cluster for pod issues
- Skills: pod restart analysis, resource pressure detection, image pull troubleshooting
- Tools: terminal (kubectl), web (K8s docs)
- Safety: read-only diagnosis, mutations require approval
- Works fully with local KIND cluster (no cloud needed)

**What's built per track:**
- Complete agent profile (SOUL.md + config.yaml + skills/)
- 2-3 domain SKILL.md files
- Simulated infra data files (mock CLI responses)
- Step-by-step lab guide
- Reference implementation to compare against

---

### Module 11 — Fleet Orchestration (FULL)

**Lab: Combine Agents into Coordinated Fleet**

Teams of 3 combine their Module 10 agents:
1. Set up delegation between agents (subagent tool)
2. Test with a cross-domain incident scenario
3. Observe how coordinator delegates to specialists

**Reading Material:**
- When single agents are insufficient
- Fleet patterns: round-robin, skill-based, hierarchical
- The manager pattern in Hermes: coordinator delegates via `delegate_task`
- Shared memory and context across delegated agents

**What's built:**
- Coordinator agent profile (manager pattern)
- Cross-domain incident scenario (simulated)
- Lab guide showing team exercise
- Reading material

---

### Module 12 — Triggers, Scheduling, Interface (FULL)

**Lab: Write Trigger Specifications**

Participants configure:
1. Cron schedule for daily health checks (hermes cron)
2. Webhook subscription for alert-triggered workflows
3. Slack command integration (demo walkthrough, not hands-on)

**Reading Material:**
- Four interface patterns: CLI, Slack/Teams, Webhooks, Cron
- Hermes cron system: job definitions, scheduling, output routing
- Webhook subscriptions: setup, HMAC validation, payload templating
- Mission Control concept (future dashboard)

**What's built:**
- Cron job examples for each track
- Webhook subscription examples
- Slack integration demo config
- Lab guide
- Reading material

---

### Module 13 — Governance (FULL)

**Lab: Add Governance Layer**

Participants add to their Module 10 agent:
1. Maturity level assignment (L1 Assistive → L4 Semi-autonomous)
2. Approval workflows with escalation
3. Allowed/blocked command audit
4. Audit logging configuration (what agent did, when, with what approval)
5. Promotion criteria (how agent earns more autonomy)

**Reading Material:**
- The governance triad: DO × APPROVE × LOG
- Maturity levels L1-L4 with concrete examples
- Promotion criteria: how agents earn trust
- Enterprise requirements: RBAC, credential protection, rollback plans

**What's built:**
- Governance config templates (per maturity level)
- Approval workflow examples
- Audit log format specification
- Lab guide
- Reading material

---

### Module 9 — Agent Design Patterns (PARTIAL)

**What this project builds:**
- Reading material mapping Hermes capabilities to pattern names
- Examples of each pattern using Hermes profiles

**What needs separate work:**
- Excalidraw diagrams for each pattern (visual)
- The autonomy spectrum visual (L1-L4)
- Reference architecture diagram

---

### Module 3 — From Platform AI to Custom Agents (PARTIAL)

**What this project builds:**
- First-run agent demo script (minimal Hermes setup for live walkthrough)
- Reading material: what custom agents add that platform AI can't

**What needs separate work:**
- Excalidraw diagrams comparing platform AI vs custom agents
- Conceptual explainer content
- Assessment templates for platform AI gaps

---

### Module 14 — Capstone (TEMPLATE ONLY)

**What this project builds:**
- Presentation template (what teams should cover)
- 30-day deployment roadmap template
- Evaluation rubric

**What needs separate work:**
- Facilitation guide for the trainer

---

## What Needs to Be Built SEPARATELY

### Module 1 — AI Foundations for Operations Teams (FULL — Claude Code/OpenCode)

**Content needed:**
- **Explainer**: How LLMs work (tokens, context windows, temperature) — using operational analogies
- **Reading**: The spectrum from Chat → Copilot → Agent → Squad
- **Lab**: Progressive prompt engineering with CloudWatch alarm JSON
  - Tool: OpenCode or Claude Code
  - Data: Sample CloudWatch alarm JSON (we can provide this from hermes project too)
  - Deliverable: Optimized prompt template for operational diagnosis
- **Quiz**: LLM fundamentals, prompt engineering concepts

**Notes:** This lab uses raw LLM interaction, not Hermes. CloudWatch alarm JSON samples could be reused from our simulated infra data.

---

### Module 2 — Platform AI — Features in Your Stack (FULL — AWS Console)

**Content needed:**
- **Explainer**: AWS AI services landscape (Q Developer, DevOps Guru, etc.)
- **Reading**: Platform AI capabilities and limitations matrix
- **Lab**: Enable and explore platform AI on AWS free tier
  - RDS Performance Insights (if RDS provisioned)
  - Cost Explorer analysis
  - CloudWatch anomaly detection setup
  - Q Developer for query explanation
- **Deliverable**: Written assessment of platform AI capabilities and gaps
- **Quiz**: Platform AI features, vendor lock-in concepts

**Notes:** This is AWS console + CLI work. No Hermes involvement. Consider providing assessment templates.

---

### Module 4 — Impact Assessment (FULL — Team Exercise)

**Content needed:**
- **Explainer**: Automation Quadrant (frequency × complexity)
- **Reading**: How to scope an agent project, evaluation criteria
- **Exercise**: Team scoring exercise
  - List top 10 repetitive operational tasks
  - Score: frequency, time, error risk, tool count
  - Plot on Automation Quadrant
  - Select top candidate for Day 3
- **Quiz**: Automation candidate evaluation

**Notes:** Pure facilitation exercise. Provide scoring templates and quadrant diagram.

---

### Module 5 — Structured AI Coding with OpenCode (FULL — Claude Code/OpenCode)

**Content needed:**
- **Explainer**: Why unstructured prompting fails for infrastructure
- **Reading**: The Superpowers workflow: Brainstorm → Design → Blueprint → Implement → Validate
- **Lab**: Build Ansible playbook for EC2 hardening using structured workflow
  - Tool: Claude Code or OpenCode with Superpowers
  - Each phase explicit and documented
- **Deliverable**: Validated Ansible playbook
- **Quiz**: Structured coding concepts

**Notes:** This is Claude Code territory. If using OpenCode with Superpowers, the workflow is already documented.

---

### Module 6 — AI-Assisted Infrastructure as Code (FULL — Claude Code/OpenCode)

**Content needed:**
- **Explainer**: AI failure modes in infrastructure generation
- **Reading**: GSD workflow for multi-file IaC projects, review patterns
- **Lab** (pick one track):
  - Track A: Terraform RDS PostgreSQL module with CloudWatch alarms + SNS
  - Track B: Ansible PostgreSQL client setup with monitoring + backup
  - Track C: Kubernetes deployment with HPA, resource limits, PDB
- **Deliverable**: Production-quality IaC artifact
- **Quiz**: IaC validation, common AI errors in infrastructure

**Notes:** This is Claude Code / GSD workflow territory. The IaC produced here may feed into Module 10 agent environments.

---

## Cross-Module Content (Built Separately)

| Content Type | Description | Who Builds |
|---|---|---|
| Excalidraw diagrams | Agent anatomy, autonomy spectrum, design patterns, architecture | Trainer (visual) |
| Video lessons | Recorded walkthroughs of conceptual content | Trainer |
| Quizzes | Assessment questions per module | Derived from labs/reading |
| Course navigation | Module sequencing, prerequisites, learning paths | Trainer |
| Participant setup guide | Environment provisioning (AWS, KIND, Hermes install) | Shared — Hermes install part built here |

---

## Content Structure Per Module

Each module should follow this structure:

```
module-NN-name/
├── README.md              # Module overview, objectives, prerequisites
├── explainer/             # Conceptual content (Excalidraw sources, slide notes)
│   └── diagrams/          # PNG exports for reading materials
├── reading/               # Markdown reading materials for learners
│   ├── concepts.md        # Core concepts explained
│   └── reference.md       # Reference material (configs, commands, etc.)
├── lab/                   # Hands-on lab instructions
│   ├── LAB.md             # Step-by-step instructions
│   ├── starter/           # Starting files for participants
│   └── solution/          # Complete solution for reference
├── quiz/                  # Assessment questions
│   └── QUIZ.md            # Questions with answers (trainer version)
└── exploratory/           # Optional stretch projects
    └── PROJECTS.md        # Additional project ideas
```

---

## Dependency Chain

```
Module 1 (AI Foundations)
    ↓
Module 2 (Platform AI) ──→ Module 3 (Custom Agents intro)
    ↓                           ↓
Module 4 (Impact Assessment)    Module 5 (Structured Coding)
    ↓                           ↓
    ↓                      Module 6 (IaC Generation)
    ↓                           ↓
    └───────────────→ Module 7 (Agent Skills) ←── HERMES ENTERS
                           ↓
                      Module 8 (Tool Integration)
                           ↓
                      Module 9 (Design Patterns)
                           ↓
                      Module 10 (Domain Agent Build) ←── MAIN BUILD
                           ↓
                      Module 11 (Fleet Orchestration)
                           ↓
                      Module 12 (Triggers & Scheduling)
                           ↓
                      Module 13 (Governance)
                           ↓
                      Module 14 (Capstone)
```

---

## Simulated Infrastructure Strategy

For labs that need AWS/K8s but participants may not have live infra:

| Resource | Simulated Approach |
|---|---|
| RDS PostgreSQL | Mock pg_stat_statements JSON, mock CloudWatch metrics JSON |
| AWS Cost Explorer | Mock cost data JSON with realistic anomaly patterns |
| EC2 instances | Mock aws ec2 describe-instances output |
| CloudWatch alarms | Sample alarm JSON (reused from Module 1 lab) |
| KIND cluster | Actually runs locally (no simulation needed) |
| kubectl output | Real KIND cluster OR mock kubectl JSON responses |
| Slack API | Demo video + mock webhook responses |

Each mock data set should be realistic enough to demonstrate agent analysis and decision-making.

---

## LLM Access Strategy (No Paid API)

Participants must NOT pay for API keys. All Hermes labs must document these access paths:

| Access Path | Setup | Cost | Best For |
|---|---|---|---|
| Claude Code OAuth tokens | `hermes login --provider claude-code` (reads ~/.claude creds) | Free (uses existing Claude Pro/Team sub) | Participants with Claude subscription |
| Google AI Studio | Set `GOOGLE_AI_STUDIO_KEY`, configure Hermes with custom OpenAI-compatible endpoint | Free (generous quota) | Budget-conscious participants |
| Hugging Face Inference | Set `HF_TOKEN`, configure Hermes provider as `huggingface` | Free tier ($0.10/month) | Fallback option |
| OpenRouter free credits | Sign up at openrouter.ai, use free model tier | Free (limited) | Quick start |

**Lab design implications:**
- Keep prompts concise to minimize token usage
- Use simulated data where possible (avoids repeated trial-and-error with LLM)
- Provide expected output samples so participants can verify without re-running
- Skills should be self-contained (no multi-turn discovery conversations)

---

## Priority Order for Parallel Work

**Build first (this project — Hermes-focused):**
1. Module 7: Skills (foundation for everything after)
2. Module 8: Tool integration (builds on skills)
3. Module 10: Domain agents (main lab, uses skills + tools)
4. Module 12: Triggers (production deployment pattern)
5. Module 13: Governance (enterprise readiness)
6. Module 11: Fleet orchestration (team exercise)

**Build in parallel (separate — Claude Code-focused):**
1. Module 1: AI foundations lab (prompt engineering)
2. Module 5-6: Structured coding + IaC labs
3. Module 2: Platform AI exploration lab
4. Module 4: Impact assessment exercise
5. Module 9: Design patterns explainers

**Build last (depends on both streams):**
1. Module 3: Bridge content (platform AI → custom agents)
2. Module 14: Capstone templates
3. Cross-module quizzes
4. Participant setup guide (combines both tool chains)

---
*Handoff document created: 2026-04-04*
