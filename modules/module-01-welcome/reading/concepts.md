# Module 01 — Core Concepts

> Standalone reading material for "Welcome + AgenticOps Trinity Framework + Environment Setup."
> Read time: ~15 minutes.

---

## The Four Eras of Operations

Infrastructure management has gone through four distinct eras. If you've been in DevOps for a few years, you've lived through at least three of them.

**Manual (~2000s).** SSH into servers. Run commands by hand. Open a ticket, wait for someone to make the change. Every action was human-initiated, human-executed, and human-verified. Slow, error-prone, but you understood every step.

**Scripted (~2010s).** Bash scripts. Cron jobs. Early configuration management with Puppet and Chef. The big win: repeatability. The limitation: every edge case needed a new `if` statement. Scripts were brittle — they broke on unexpected input and couldn't adapt.

**Automated (~2015s).** Terraform, Ansible, CI/CD pipelines, GitOps. You declare desired state; tooling converges toward it. This is where most teams are today. Massive improvements in reliability and velocity. But every workflow still needs to be pre-designed by a human.

**Agentic (2025+).** AI agents that reason about goals, use tools, adapt to new situations, and take action. This isn't just better automation — it's a fundamentally new capability. An agent doesn't follow predefined steps. It looks at the situation, decides what to do, uses the tools available, and explains its reasoning.

The key insight: each era absorbed the previous one. Your Terraform pipelines don't disappear in the agentic era — agents use them as tools. Your scripts become skills. Your CI/CD pipelines become triggers. Everything you've built is still valuable; it just gains a reasoning layer on top.

---

## The AgenticOps Trinity Framework

The course is structured around three pillars, each building on the previous one.

### Pillar 1: Augmented DevOps — "Use what's already there"

AI features are already baked into tools you use daily. AWS Q Developer suggests fixes for your CloudFormation. Grafana Sift correlates metrics. GitHub Copilot completes your code. Cost Anomaly Detection catches spending spikes.

This pillar is about turning on what exists. No model training. No API keys. No infrastructure changes. The ROI is immediate.

The tools in this pillar include platform AI features (built into AWS, Datadog, Grafana), AI coding agents (Claude Code, Crush), and MCP bridges that connect AI to your existing infrastructure.

### Pillar 2: Agentic Engineering — "Understand the machinery"

Before you build agents, you need to understand how they work. This is where context engineering becomes your core skill.

Context engineering is the discipline of structuring the right context — domain knowledge, system state, constraints — so that AI produces expert-level results. It's not about writing clever prompts. It's about giving the AI the same information you'd give a senior engineer joining your team: what the system looks like, what the constraints are, what "good" means in your environment.

This pillar covers how LLMs actually work (through a DevOps lens), how to write SKILL.md files that encode operational knowledge, how to wire MCP tools, how to use memory and RAG, and how to build structured workflows.

Think of context engineering as the agentic equivalent of Infrastructure-as-Code. Just as Terraform made infrastructure reproducible and reviewable, context engineering makes AI interactions reproducible and predictable.

### Pillar 3: Agentic DevOps — "Build agents that work for you"

This is where everything comes together. You build domain agents — SRE agents, DBA agents, FinOps agents — that encode YOUR team's operational expertise. They inherit your vocabulary, your runbooks, your judgment.

You deploy these agents in fleets with a coordinator pattern. You add governance (approval gates, audit trails, policy enforcement). You set up triggers so agents respond to alerts, schedules, git events, and chat commands.

The deliverable: working agents that run 24/7, handling the investigative and operational toil that currently burns your team's time.

---

## The Driving Analogy

A mental model for the three pillars:

**The Passenger (Pillar 1).** You get in the car. Someone else is driving. You benefit from the ride — AI features get you where you need to go — but you don't understand how they work. You can't fix them when they break. You can't customize the route. Most DevOps teams are passengers right now.

**The Mechanic (Pillar 2).** You open the hood. You learn how the engine works — the LLM, the context window, the tools, the skills. You can tune it, repair it, customize it. You understand WHY things work the way they do. You write your first SKILL.md, wire your first MCP tool, design your first context template.

**The Driver (Pillar 3).** You're behind the wheel. You decide where to go, how fast, and which route. The car (AI) amplifies your driving skill — adaptive cruise control, lane assist, collision avoidance — but YOU are in control. You build agents, deploy fleets, set governance policies.

This course takes you from passenger to driver.

---

## Domain Expertise Is Your Superpower

This is the recurring theme of the entire course.

The chain: **Domain Expertise → Better Vocabulary → Better Context → Better Results.**

Your years of DevOps experience give you a vocabulary that generic users don't have. When you say "HPA with PDB and liveness/readiness probes," you're using precise terminology that maps directly to specific Kubernetes resources with specific configurations. A generalist saying "deploy my app" gets a generic template. You get a production-grade manifest.

Same AI. Same model. Same cost. The difference is vocabulary from expertise. And vocabulary translates directly into context — the structured information that makes AI output useful rather than generic.

This is why context engineering matters more than prompt tricks. A clever prompt doesn't help if you don't have the domain vocabulary to describe what you actually need. Your five years of operational experience is what makes AI ten times more useful for you than for someone without that background.

AI amplifies expertise. It doesn't substitute for it.

---

## Human-in-the-Loop

Agents don't replace humans. They replace toil.

**What agents are good at:** Repetitive investigation work. Log correlation across 15 services at 3am. First-pass triage on alerts. Boilerplate IaC generation. The important-but-soul-crushing work that burns your team's time.

**What stays human:** Judgment on production changes. Architecture decisions. The incident commander role during an outage. Compliance sign-offs. Anything that requires accountability.

The trust spectrum defines how much autonomy each agent gets:

- **Observe** — Agent can look at metrics and logs. Read-only.
- **Recommend** — Agent investigates and suggests actions. You decide.
- **Act with approval** — Agent proposes a change. You approve. It executes.
- **Act and report** — Agent handles routine tasks autonomously. You review after.

Every agent starts at "Observe" and earns trust over time — just like a new team member. You decide where each agent sits on this spectrum. That's governance.

---

## What Is MCP?

MCP (Model Context Protocol) is an open standard that lets AI agents connect to external tools and data sources. Think of it as a USB port for AI — a universal interface that any agent can use to plug into any tool.

Without MCP, your AI agent is a chatbot. It can only generate text based on what it knows. With MCP, your agent can run kubectl commands, query databases, read GitHub repos, and interact with APIs — all through a structured protocol that provides type safety and consistent behavior.

In this course, you'll connect three MCP servers:

- **Kubernetes MCP** — gives your agent access to `kubectl` operations
- **PostgreSQL MCP** — gives your agent access to database queries
- **GitHub MCP** — gives your agent access to repository operations

When all three are connected, your agent can do things like: "Check if the pods in the app namespace are healthy, query the database for recent error counts, and correlate with the last commit on the main branch." That's cross-platform reasoning powered by MCP.

---

## Context Engineering vs. Prompt Engineering

You'll notice this course never uses the phrase "prompt engineering." That's deliberate.

"Prompt engineering" implies the skill is in crafting a clever sentence — finding the right magic words to make the AI do what you want. That's a misconception. The real skill is context engineering: structuring the right information so the AI has what it needs to produce expert results.

The difference:

- **Prompt engineering mindset:** "How do I phrase this question to get a better answer?"
- **Context engineering mindset:** "What information does the AI need to give me an expert-level answer?"

Context engineering includes writing SKILL.md files that encode operational knowledge, structuring system state data before sending it to the AI, choosing the right vocabulary (domain-specific terms vs. generic descriptions), designing tool connections so the AI can gather information itself, and managing what fits in the context window.

It's a discipline, not a trick. And it's what separates agents that produce generic output from agents that produce production-grade results.

---

## Key Vocabulary

| Term | Definition |
|------|-----------|
| **AgenticOps** | The practice of building AI agents that encode operational expertise for infrastructure automation |
| **Context engineering** | Structuring the right context (domain knowledge, system state, constraints) so AI produces expert results |
| **MCP** | Model Context Protocol — open standard for connecting AI agents to external tools |
| **SKILL.md** | A structured knowledge file that encodes operational expertise for AI agents |
| **SOUL.md** | An identity file that defines an agent's personality, constraints, and behavioral context |
| **KIND** | Kubernetes IN Docker — runs local K8s clusters as Docker containers |
| **Claude Code** | Anthropic's terminal-based AI coding agent (uses Claude Pro/Team subscription) |
| **Crush** | Open-source terminal AI agent by Charm (formerly OpenCode). Works with free LLM providers. |
| **Hermes** | Open-source agent framework by Nous Research, used for building domain agents in this course |
| **Domain agent** | An AI agent specialized for a specific operational role (SRE, DBA, FinOps, K8s specialist) |
| **Agent fleet** | Multiple domain agents working together under a coordinator pattern |
| **Governance** | Approval gates, audit trails, and policy enforcement for agent actions |
