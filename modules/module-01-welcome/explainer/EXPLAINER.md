# Module 01 — Explainer Notes

> **Delivery format:** 14 Excalidraw diagrams, presented sequentially.
> Each diagram = one concept beat. Use for live whiteboard delivery or Udemy video segments.
>
> **Naming convention:** `01-title-card.excalidraw` through `14-what-you-build-today.excalidraw`
> **Style:** Black & white, hand-drawn (Excalidraw sketchy), outlines only — no fills, no colors.

---

## Diagram 1: Title Card — Welcome to AgenticOps

**File:** `diagrams/01-title-card.excalidraw`
**Duration:** ~1 minute

**Narrator notes:**

Welcome to AgenticOps — Building Agentic Skills for Infrastructure Automation.

This is Module 01. By the end of today, you'll have a fully working lab environment with an AI coding agent connected to your Kubernetes cluster, your database, and your monitoring stack.

But before we set anything up, let's talk about WHY we're here and WHAT you're going to learn over the next five days.

You'll notice three boxes here — Augmented DevOps, Agentic Engineering, Agentic DevOps. This is the AgenticOps Trinity Framework, and it's the backbone of this entire course. We'll unpack each one shortly.

One important thing: this course is designed for people exactly like you — strong DevOps practitioners who are completely new to AI and agentic systems. Your infrastructure expertise is not just useful here — it's the thing that makes all of this work.

---

## Diagram 2: The Evolution of Operations

**File:** `diagrams/02-evolution-of-operations.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

Let's put this in context you already understand.

You've lived through three major transitions in operations:

**Manual (~2000s):** SSH into servers. Run commands by hand. Open a ticket, wait for someone to make the change. If you're old enough, you remember the days of walking over to a physical server rack.

**Scripted (~2010s):** We wrote bash scripts. Cron jobs. Early config management with CFEngine, then Puppet and Chef. A big improvement — but the scripts were brittle. They broke on unexpected input. Every edge case needed a new `if` statement.

**Automated (~2015s):** Terraform, Ansible, CI/CD pipelines, GitOps. This is where most teams are today. You declare the desired state, and tooling converges toward it. Massive improvement in reliability and repeatability.

**Agentic (2025+):** This is what's new. And it's NOT just "better automation." An agent doesn't follow predefined steps — it reasons about a goal, picks tools, adapts to what it finds, and takes action. Your Terraform pipeline still exists. The agent decides WHEN to run it, with WHAT parameters, and can explain WHY.

The key insight on this slide: each era absorbed the previous one. Agentic doesn't replace your Terraform — it makes it smarter.

---

## Diagram 3: What Makes Agentic Different?

**File:** `diagrams/03-what-makes-agentic-different.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

This is a side-by-side comparison that makes the shift concrete.

On the left — Automation, what you already know:
- It follows predefined steps (your pipeline YAML)
- It breaks on unexpected input (ever had a Terraform plan fail because of a new provider version?)
- One task, one script (each automation is purpose-built)
- You write every branch (every `if/else` in your runbook)

On the right — Agentic, what's new:
- It reasons about the goal (not just the steps)
- It adapts to new situations (even ones you didn't anticipate)
- It chains multiple tools together to solve a problem
- It uses YOUR expertise as context (this is huge — we'll come back to it)

Here's the analogy I like: Automation is GPS that follows a fixed route. Agentic is a co-pilot who reads traffic, suggests detours, and explains why.

The key insight at the bottom: an agent doesn't replace your Terraform pipeline. It reasons about WHEN to run it, with WHAT parameters, and WHY.

---

## Diagram 4: The AgenticOps Trinity Framework

**File:** `diagrams/04-agenticops-trinity-framework.excalidraw`
**Duration:** ~4 minutes

**Narrator notes:**

This is the big picture — the AgenticOps Trinity Framework. Three pillars, each building on the previous one.

**Pillar 1: Augmented DevOps — "Use what's already there."**
AI features are already baked into tools you're paying for. AWS Q Developer, Grafana Sift, GitHub Copilot. You don't need to build anything — just turn them on. This is the quick win. Immediate ROI.

**Pillar 2: Agentic Engineering — "Understand the machinery."**
Before you build agents, you need to understand how they think. How do LLMs actually work? What is context engineering? How do you write a SKILL.md file? How do you wire tools via MCP? This is the discipline layer — it's to AI what Infrastructure-as-Code is to infrastructure.

**Pillar 3: Agentic DevOps — "Build agents that work for you."**
This is where it all comes together. You build domain agents — SRE agents, DBA agents, FinOps agents — that encode YOUR team's operational expertise. You deploy them in fleets, add governance, set up triggers. By the end of Day 5, you'll have working agents.

The important thing: each pillar builds on the previous one. You can't build agents (P3) without understanding the machinery (P2), and you can't understand the machinery without first experiencing what's already available (P1).

---

## Diagram 5: Pillar 1 — Augmented DevOps

**File:** `diagrams/05-pillar-1-augmented-devops.excalidraw`
**Duration:** ~2 minutes

**Narrator notes:**

Let's zoom into Pillar 1. This is "The Passenger Seat" — you're riding along, benefiting from AI features that someone else built.

Three categories:

**Platform AI:** These are AI features built into your existing tools. AWS Q Developer can suggest fixes for your CloudFormation. DevOps Guru can detect anomalies. Cost Anomaly Detection catches spending spikes. Grafana Sift correlates metrics. You're probably already paying for most of this — you just haven't turned it on.

**AI Coding Agents:** Claude Code, Crush (the open-source alternative), GitHub Copilot. These help you write code faster, generate Terraform modules, debug issues. You talk to them in your terminal.

**MCP Bridges:** This is the glue. MCP (Model Context Protocol) lets your AI agent talk to kubectl, PostgreSQL, GitHub, and more. It turns your AI agent from a chatbot into something that can actually interact with your infrastructure.

The key insight: the ROI here is immediate. No model training, no API keys, no infrastructure changes. Just turn on what you're already paying for.

We cover this in Modules 02, 03, and 04.

---

## Diagram 6: Pillar 2 — Agentic Engineering

**File:** `diagrams/06-pillar-2-agentic-engineering.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

Pillar 2 is "The Mechanic's Workshop." You open the hood and learn how the engine works.

At the center of everything is **Context Engineering**. This is THE core skill of this entire course. It's not about writing clever prompts — it's about structuring the right context so the AI can do its best work.

Context engineering connects to everything:
- **How LLMs Work** — You need to understand tokens, context windows, inference to know why context matters
- **Skills (SKILL.md)** — These are structured knowledge files that encode your operational expertise
- **Tools (MCP)** — The connections that give agents the ability to interact with real systems
- **Memory + RAG** — How agents remember things and pull in relevant documentation
- **Harnesses + Workflows** — The structured patterns for complex multi-step operations

The analogy: Context engineering is to AI what IaC is to infrastructure. Just as Terraform made infrastructure reproducible and reviewable, context engineering makes AI interactions reproducible and predictable.

This pillar spans Modules 05 through 12 — it's the densest part of the course, and it's where your DevOps expertise becomes the most valuable.

---

## Diagram 7: Pillar 3 — Agentic DevOps

**File:** `diagrams/07-pillar-3-agentic-devops.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

Pillar 3 is "The Driver's Seat." You're in control now. You're building agents that encode YOUR operational expertise and work for your team 24/7.

What you build, in order:

**Domain Agents:** Specialized agents for specific roles — an SRE agent that knows your runbooks, a DBA agent that understands your database patterns, a FinOps agent that watches your cloud spending. Each one inherits YOUR vocabulary, YOUR runbooks, YOUR judgment.

**Agent Fleets:** Multiple agents working together. A coordinator pattern where one agent orchestrates specialists. Shared context between agents. Think of it as a team of junior engineers who never sleep and never forget the runbook.

**Governance:** Approval gates, audit trails, policy enforcement. Because an agent that can `kubectl delete` in production needs guardrails. This is what makes the difference between a toy and something your enterprise will actually deploy.

At the bottom — Triggers. Agents don't just wait for you to talk to them. They respond to alerts, schedules, git events, chat commands. A CloudWatch alarm fires at 3am, and your SRE agent is already investigating before you wake up.

By the end of this course, you'll have working agents that encode your team's operational expertise and respond to real infrastructure events. That's the deliverable.

---

## Diagram 8: The Driving Analogy

**File:** `diagrams/08-driving-analogy.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

This is the mental model that ties it all together. Think of your journey through this course like learning to drive.

**The Passenger (Pillar 1: Augmented DevOps):**
You get in the car. Someone else is driving. You benefit from the ride — the car gets you where you need to go — but you don't understand how it works. You can't fix it if it breaks. You can't take a different route.

That's where most DevOps teams are with AI right now. They use Copilot. They ask ChatGPT questions. They benefit from Platform AI features. But they're passengers.

**The Mechanic (Pillar 2: Agentic Engineering):**
Now you open the hood. You learn how the engine works — the LLM, the context window, the tools, the skills. You can tune it, repair it, customize it. You understand WHY things work the way they do.

This is where you write your first SKILL.md file, wire your first MCP tool, design your first context template. You're not just using AI — you understand it.

**The Driver (Pillar 3: Agentic DevOps):**
You're behind the wheel. You decide where to go, how fast, and which route. The car (AI) amplifies your driving skill — adaptive cruise control, lane assist, collision avoidance — but YOU are in control.

This is where you build agents, deploy fleets, set governance policies. The AI amplifies your expertise. You're not a passenger anymore.

Right now, most DevOps teams are passengers. This course takes you to the driver's seat.

---

## Diagram 9: Domain Expertise = Your Superpower

**File:** `diagrams/09-domain-expertise-superpower.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

This is the recurring theme of the entire course, and I want to plant it firmly right here at the start.

Here's the chain: **Domain Expertise → Better Vocabulary → Better Context → Better Results.**

Every link in this chain matters. Your years of DevOps experience give you a vocabulary that generic users don't have. That vocabulary translates directly into better context for AI. And better context produces dramatically better results.

Let me show you what I mean with a Kubernetes example.

A generalist says: "Deploy my app to Kubernetes."
What the AI generates: a basic Deployment manifest. No probes, no resource limits, no HPA, no PDB. Technically correct, operationally useless.

A DevOps engineer says: "Create a Deployment with HPA, PDB, resource limits, and liveness/readiness probes."
What the AI generates: a production-grade manifest with proper health checks, autoscaling, disruption budgets, and resource constraints.

Same AI. Same model. Same cost. The difference is VOCABULARY that comes from EXPERTISE.

This is why context engineering matters more than prompt tricks. Your expertise IS the context. And this is why AI amplifies expertise — it doesn't substitute for it.

We'll practice this hands-on in Module 02.

---

## Diagram 10: Before/After — Same AI, Different Results

**File:** `diagrams/10-before-after-same-ai.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

Let me make this even more concrete with a real operational scenario.

**Before — No domain vocabulary:**
Someone gets a CloudWatch alarm and pastes the JSON into their AI agent. They say: "I got an alarm from AWS. Here's the JSON. What's wrong?"

The AI responds with generic advice: "This alarm indicates high CPU usage. You should check your server. Consider scaling up." It's not wrong — it's just useless. It's the equivalent of a doctor saying "you seem unwell."

**After — Expert vocabulary plus structured context:**
An SRE gets the same alarm and says: "Analyze this CloudWatch alarm for our RDS PostgreSQL instance (db.r5.large, Multi-AZ). Check against our SLO of p99 latency under 200ms. Correlate with our deploy that went out 2 hours ago."

Now the AI has context. It identifies connection pool exhaustion as the root cause. It correlates the timing with the recent deploy. It confirms the SLO breach. It recommends a rollback and connection pool size increase. Specific, actionable, expert-level analysis.

The AI didn't get smarter between these two examples. The human gave it better context through better vocabulary. That's context engineering in action.

This is exactly the exercise you'll do in Module 02's lab — taking the same alarm data and progressively improving your context until the AI output is production-grade.

---

## Diagram 11: Human-in-the-Loop

**File:** `diagrams/11-human-in-the-loop.excalidraw`
**Duration:** ~3 minutes

**Narrator notes:**

Before we go further, let's address the elephant in the room. What about trust? What about safety? What about "are the robots going to break production?"

Two columns here.

**What agents REPLACE:** The toil. Repetitive investigation work that burns your team's time. Log correlation across 15 services at 3am. First-pass triage on alerts. Boilerplate IaC generation. The stuff that's important but soul-crushing.

**What agents DON'T replace:** Judgment on production changes. Architecture decisions. The incident commander role during an outage. Compliance sign-offs. The stuff that requires human accountability.

Now look at the Trust Spectrum at the bottom. This is how you think about each agent you build:

- **Observe:** Agent can look at metrics, read logs. Read-only.
- **Recommend:** Agent investigates and suggests actions. You decide.
- **Act with approval:** Agent proposes a change. You approve. It executes.
- **Act and report:** Agent handles routine tasks autonomously. You review after.

YOU decide where each agent sits on this spectrum. That's governance. A new agent starts at "Observe" and earns trust over time. Just like a new team member.

For the enterprise teams here — Adobe, Walmart, Cisco — this is the approach that gets past your security review. We cover governance in depth in Modules 17 and 18.

---

## Diagram 12: Workshop Journey Map

**File:** `diagrams/12-workshop-journey-map.excalidraw`
**Duration:** ~2 minutes

**Narrator notes:**

Here's your roadmap for the next five days. Each day ends with something tangible.

**Day 1 — Foundations (Pillar 1):**
Today. We set up the lab, learn AI fundamentals, explore Platform AI features, and connect MCP bridges. By end of day, you have a working environment with AI connected to your cluster.

**Day 2 — Engineering (Pillar 2 begins):**
Context engineering deep dive. How LLMs actually work (through a DevOps lens). The Superpowers workflow for structured coding. IaC generation with AI. You'll walk away with context templates you can use immediately.

**Day 3 — Skills + Tools (Pillar 2 continues):**
GSD workflow for getting stuff done with AI. Memory and RAG. Wiring MCP tools. Writing your first SKILL.md file — encoding your operational knowledge into a format agents can use.

**Day 4 — Agents (Pillar 3 begins):**
Agent design patterns. Building your first Hermes agent. Setting up triggers. Building domain agents — you'll choose a track: SRE, DBA, or K8s specialist.

**Day 5 — Fleet + Capstone (Pillar 3 complete):**
Multi-agent orchestration. Governance policies. Your capstone project — a working agent fleet. And a 30-day plan for taking this back to your team.

Notice each day builds on the previous one. And each day produces something you can take back to your team.

---

## Diagram 13: Your Lab Environment

**File:** `diagrams/13-lab-environment.excalidraw`
**Duration:** ~2 minutes

**Narrator notes:**

This is the architecture of what we're about to set up.

Everything runs on YOUR laptop. No cloud account needed. Docker Desktop provides the container runtime. Inside Docker, we run a KIND cluster — that's Kubernetes in Docker. It's a real Kubernetes cluster, running locally, for free.

Inside the KIND cluster, we have:
- **App namespace:** Three Rust microservices — an API gateway, a catalog service, and a worker. This is our reference application.
- **DB namespace:** PostgreSQL database with sample data.
- **Monitoring namespace:** Prometheus and Grafana, pre-configured with dashboards.
- **Dashboard:** A Svelte web UI that ties it all together.

Below the cluster, we have your AI coding agent — either Claude Code (if you have a Claude subscription) or Crush (free, open-source). Connected via MCP to kubectl, PostgreSQL, and GitHub.

Access points: Dashboard at port 30080, Grafana at 30090, Prometheus at 30091.

One command deploys all of this: `make deploy`. Takes about 5-10 minutes. That's what we're about to do in the lab.

---

## Diagram 14: What You'll Build Today

**File:** `diagrams/14-what-you-build-today.excalidraw`
**Duration:** ~1 minute

**Narrator notes:**

Here's the lab walkthrough for this module, broken into five steps:

**Step 1: Verify Tools.** We'll check that Docker, KIND, kubectl, Helm, Node.js, and your AI coding agent are all installed and working. There's a verification script that checks everything.

**Step 2: Deploy the Reference App.** One command — `make deploy`. This creates the KIND cluster, builds Docker images, installs PostgreSQL, Prometheus, Grafana, and deploys the application.

**Step 3: Connect MCP Servers.** This is the magic step. We wire kubectl, PostgreSQL, and GitHub MCP servers to your AI agent. After this, your AI agent can actually interact with your infrastructure.

**Step 4: Smoke Test.** We ask the AI agent a question about the cluster — something like "what pods are running and what's their health status?" — and verify it queries kubectl and postgres live.

**Step 5: Verify.** Run the verification script — 26 automated checks. When you see "Ready for labs!" you're done.

End result: your AI agent can talk to your Kubernetes cluster, your database, and your monitoring stack. This is the foundation for every lab in this course.

Estimated time: 30-45 minutes. Let's get started.

---

## Diagram Sequence Summary

| # | Diagram | Concept Beat | Udemy Video Duration |
|---|---------|-------------|---------------------|
| 1 | Title Card | Opening, course framing | ~1 min |
| 2 | Evolution of Operations | Why Agentic is the next era | ~3 min |
| 3 | What Makes Agentic Different | Automation vs. Agentic | ~3 min |
| 4 | AgenticOps Trinity Framework | Three pillars overview | ~4 min |
| 5 | Pillar 1: Augmented DevOps | Passenger seat — what exists | ~2 min |
| 6 | Pillar 2: Agentic Engineering | Mechanic's workshop — how it works | ~3 min |
| 7 | Pillar 3: Agentic DevOps | Driver's seat — what you build | ~3 min |
| 8 | The Driving Analogy | Mental model that ties it together | ~3 min |
| 9 | Domain Expertise = Superpower | The chain: Expertise → Results | ~3 min |
| 10 | Before/After: Same AI | Concrete vocabulary comparison | ~3 min |
| 11 | Human-in-the-Loop | Trust spectrum, governance intro | ~3 min |
| 12 | Workshop Journey Map | 5-day roadmap with deliverables | ~2 min |
| 13 | Your Lab Environment | Architecture of the lab setup | ~2 min |
| 14 | What You'll Build Today | Lab preview — 5 steps | ~1 min |

**Total explainer time:** ~36 minutes (before lab)

---

## Usage Notes

**For live workshop delivery:**
- Present diagrams 1-11 as a continuous concept session (~30 min)
- Take a break
- Present diagrams 12-14 as lab intro (~5 min)
- Begin lab

**For Udemy:**
- Diagrams 1-3 → Video: "Welcome to AgenticOps" (~7 min)
- Diagrams 4-7 → Video: "The AgenticOps Trinity Framework" (~12 min)
- Diagram 8 → Video: "The Driving Analogy" (~3 min)
- Diagrams 9-10 → Video: "Domain Expertise is Your Superpower" (~6 min)
- Diagram 11 → Video: "Human-in-the-Loop" (~3 min)
- Diagrams 12-14 → Video: "Workshop Overview + Lab Setup" (~5 min)
- Then: Lab walkthrough video (separate recording)
- Then: Quiz
