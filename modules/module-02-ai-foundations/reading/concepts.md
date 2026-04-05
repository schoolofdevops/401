# AI Foundations for DevOps: Core Concepts

Welcome to the conceptual foundation of the course. This section builds your mental model of how large language models work, how they fit into infrastructure automation, and why **context engineering** is the skill that makes agents actually useful.

If you've spent years building playbooks, monitoring systems, and responding to incidents, you already understand the core principle: the quality of automation depends on how well you've structured the operational knowledge that drives it. This course is about encoding that same expertise for AI systems.

## How LLMs Work — An Operations Perspective

Before you can build agents effectively, you need to understand how language models actually work. The good news: if you understand how Kubernetes schedules workloads, you can understand how models process text.

### Tokenization: Breaking Text into Pieces

Language models don't read text the way you do. They convert everything—code, logs, prose, JSON—into small numeric units called **tokens**. Each token represents roughly 3–4 characters of English text.

Think of tokenization like log parsing. When you feed a syslog line into a log aggregator, it breaks the line into structured fields: timestamp, hostname, service, message. Tokenization does something similar—it chunks text into units the model can process, but the boundaries don't always fall where you'd expect.

Here's a real example:

```
Text: "Kubernetes"
Tokens: ["Kubern", "etes"]  (2 tokens)

Text: "kubectl get nodes"
Tokens: ["k", "##ub", "ectl", " get", " nodes"]  (5 tokens)
```

Why does this matter? Because you pay by the token. And different content costs different amounts to process.

**Token budgeting rule of thumb:** One token ≈ 4 characters in English prose, but roughly 3–4 characters in structured data like JSON. JSON is token-expensive because special characters (`{`, `}`, `:`, `"`) each demand their own tokens. A 200-line CloudWatch alarm definition in JSON might consume 800–1000 tokens, while a plain-text runbook of the same length might use 300 tokens.

This is foundational to cost engineering in later modules.

### Context Window: The Model's Memory

Every language model has a **context window**—a fixed maximum number of tokens it can consider at once. Think of it like container memory limits. You set a ceiling in your pod spec; if the process exceeds it, the container gets killed. With models, if you exceed the context window, you either truncate input (losing information) or get an error.

Here are the current capacities as of early 2026:

| Model | Context Window | Typical Cost | Best For |
|-------|----------------|--------------|----------|
| Claude Sonnet 4.6 | 200K tokens | $3/$15 per M input/output | Rich context, long chains of reasoning |
| Gemini 2.5 Flash | 1M tokens | Free (500 requests/day limit) | Large systems documentation, multi-file analysis |
| GPT-4o | 128K tokens | ~$5/$15 per M | When Claude not available |
| Llama 3.1 (Groq) | 128K tokens | Free (14.4K requests/day) | Fast, open-source-preferred environments |

The larger your context window, the more system state you can feed the model in a single request. But here's the catch: you have to manage your **context budget** carefully. Let me show you why with a real example.

Imagine you're building an agent to triage CloudWatch alarms. For each alarm, you need to provide:

- Alarm definition and history: 150 tokens
- Relevant EC2 instance data (`describe-instances`): 400 tokens
- CloudWatch logs from the affected service: 2,000 tokens (the bulk of context)
- Recent deployment info: 800 tokens
- Agent instructions and decision tree: 300 tokens

**Per-alarm total:** 3,650 tokens

If you're processing 100 alarms simultaneously, you'd need 365,000 tokens—which **exceeds Claude Sonnet's 200K window** by 82%.

That's where context engineering comes in: you don't send raw logs. You send summaries, baselines, and metadata. You structure the information so the model gets the signal without the noise. More on that in Section 4.

### Inference Pipeline: Prefill and Decode

When you send a request to a language model, two things happen sequentially: **prefill** and **decode**.

**Prefill** is when the model processes all your input tokens in parallel. Imagine `terraform plan`—it analyzes your entire configuration before producing output. Fast.

**Decode** is when the model generates the response, one token at a time, in sequence. Like `terraform apply`—each resource is created (or destroyed, or modified) serially. Slower.

Why does this matter for DevOps?

1. **Input tokens are cheap.** During prefill, the model processes 1,000 context tokens almost as fast as 100. That's why rich context (structured logs, system state, decision trees) is economical.

2. **Output tokens are expensive.** Generation happens token-by-token, so longer responses cost more. A request that costs $0.03 for input (1,000 tokens prefilled) might cost $0.15 in output (5,000 tokens decoded at 5× the input rate).

3. **Strategy:** Load the context (cheap prefill), then constrain the output (expensive decode). Tell the model *how* to format its response narrowly. Instead of "Describe this alarm," ask for "Is this alarm CRITICAL, HIGH, or LOW? Reply with only the label and one sentence."

### Temperature, Top-P, and Top-K: Controlling Randomness

When the model generates a token, it doesn't pick randomly. It calculates a probability distribution and samples from it. You control *how* random that sampling is with hyperparameters.

**Temperature** is the main control dial:

- **Temperature = 0:** Deterministic. The model always picks the highest-probability token. Use this for incident triage, where you want repeatable decisions.
- **Temperature = 0.5:** Balanced. The model has some creativity but stays on-task. Good for code generation.
- **Temperature = 1.0:** Creative. Useful for brainstorming or creative writing. Never use this for infrastructure automation.

**Rule for agent skills:** Always set temperature to 0. You're encoding operational knowledge, not creative writing.

**Top-P and Top-K** are related but less important. Top-P (nucleus sampling) selects from the top tokens until cumulative probability reaches a threshold. Top-K limits to the K most-likely tokens. Most practitioners leave these at defaults and tune temperature instead.

## The AI Spectrum — Four Levels

As you progress through this course, you'll build systems at increasingly autonomous levels. Each level adds capability, requires more context engineering, and demands stricter guardrails.

| Level | Capability | What It Does | Operational Analogy | Course Modules |
|-------|-----------|--------------|---------------------|----------------|
| **Chat** | Manual reasoning | Answer questions, provide explanations, brainstorm | You ask a senior engineer a question; they think and respond | M01–02 |
| **Copilot** | Assisted automation | Generate code, infrastructure, or configurations under your review | IDE autocomplete or a junior writing code that you review before merging | M05–06 |
| **Agent** | Orchestrated autonomy | Execute multi-step workflows, integrate tools, handle branching logic | On-call engineer running a playbook, making decisions, integrating multiple systems | M10 |
| **Squad** | Self-healing systems | Multiple agents collaborating, self-monitoring, self-improving | Multiple on-call engineers, handoff protocols, escalation, continuous optimization | M11–13 |

The progression is intentional. Each level builds on the previous one. More autonomy means more tool access, more decision-making, and therefore more sophisticated context engineering.

## Agent Anatomy — Four Components

When you build an agent, you're assembling four parts. Only one of them is the LLM itself.

### 1. Brain: The LLM

The brain is the reasoning engine—Claude, Gemini, Llama, whatever. It's like the senior on-call engineer's actual brain: brilliant, capable of nuanced reasoning, but useless without context.

You don't build the brain. Anthropic built Claude. Google built Gemini. Your job is to feed it the right context.

### 2. Skills: Your Operational Knowledge (SKILL.md)

A **skill** is a structured runbook encoded for AI. It's how you transfer your operational expertise into something the model can execute reliably.

Instead of writing a 20-line bash script with implicit assumptions, you write a SKILL.md that includes:

- What the skill does (one sentence)
- When to use it (decision criteria)
- Step-by-step procedure
- Error handling and fallbacks
- Required context (system topology, baselines, constraints)
- Output format expectations

Think of it like a Terraform module. A good module doesn't just have code; it has variable documentation, sensible defaults, and explicit constraints. A skill is the same thing for AI.

Example: A skill called "Analyze Alarm" might look like this (conceptually):

```
Skill: Analyze Alarm
Purpose: Triage a CloudWatch alarm and recommend action

When to use:
  - Alarm has been firing for > 5 minutes
  - On-call engineer is in triage phase

Procedure:
  1. Fetch alarm metadata and recent history
  2. Identify affected resource (EC2, RDS, Lambda, etc.)
  3. Query relevant metrics (CPU, memory, disk, connections)
  4. Compare current state to baseline (alert threshold + 3-month history)
  5. If metric is > baseline + 3 std dev, classify as ANOMALY
  6. Cross-check with recent deployments, config changes
  7. Recommend action (auto-remediate, escalate, acknowledge)

Error handling:
  - If metrics not available: check agent-friendly alert logs instead
  - If no recent history: use service SLA as baseline
  - If ambiguous: escalate to human with confidence score

Output format (JSON):
  {
    "alarm_id": "...",
    "severity": "CRITICAL|HIGH|MEDIUM|LOW",
    "root_cause": "...",
    "recommended_action": "...",
    "confidence": 0.0-1.0
  }
```

You write the skill based on *your* knowledge of your systems. You encode the decision logic, the heuristics, the exceptions. The model executes it.

### 3. Tools: The Agent's Hands

Tools are how agents interact with your infrastructure. They might be:

- **CLI commands:** `kubectl get pods`, `aws ec2 describe-instances`, `terraform apply`
- **APIs:** CloudWatch, Prometheus, your custom internal APIs
- **Database queries:** RDS, DynamoDB, Elasticsearch
- **Webhooks:** Triggering PagerDuty, Slack, incident management systems

Tools are wired to agents via a protocol called **MCP** (Model Context Protocol). We'll dive deeper in later modules. For now, understand that tools are the boundary between what the agent *thinks* and what actually *happens* in your infrastructure.

### 4. Guardrails: Change Management

An agent without guardrails is like a junior engineer with root access and no code review—a disaster waiting to happen.

Guardrails are policies that constrain what an agent can do:

- **Pre-approved:** The agent can execute these actions without asking: reading metrics, describing resources, generating reports.
- **Needs review:** The agent can plan these actions but requires human approval before executing: stopping instances, scaling deployments, changing configuration.
- **Needs change advisory board (CAB):** High-risk actions that need formal approval: database schema changes, network policy changes, security group modifications.

You design guardrails based on your organization's risk tolerance and change management process.

## Context Engineering — The Core Skill

Now we reach the central idea of this course: **context engineering is how you make AI agents useful.**

Most people think about "prompt engineering"—how you phrase a question, what tone you use, whether you say "please." That's real, but it's a surface-level skill. **Context engineering** is about structuring the *information* the model sees.

Here's the difference:

| Aspect | Prompt Engineering | Context Engineering |
|--------|-------------------|----------------------|
| **Focus** | How do I phrase this? | What does the model need to know? |
| **Lever** | Wording, tone, framing | Domain knowledge, system state, constraints |
| **Skill** | Linguistic creativity | Operational expertise |
| **Leverage** | 10–20% difference in output quality | 100–1000% difference in reliability |

Prompt engineering is real, but it's weak. Context engineering is where the leverage is.

### You Already Do Context Engineering

You might not have called it that, but you've been doing context engineering for years in DevOps:

**Ansible playbook:** You don't write one-liners. You write roles that bundle procedural logic with environmental context (variables, defaults, conditional logic). You're structuring context for humans (and now, for automation).

**Terraform module:** A well-written module doesn't just have `.tf` files. It has sensible defaults, validation logic, and documentation that describes the system assumptions. You're encoding operational context.

**Runbook:** You don't write "Fix the thing." You write "If CPU > 80% for > 5 min, then: (1) Check for rogue process, (2) Scale deployment, (3) Escalate if neither works." You're layering decision context.

**Dockerfile:** You don't just list `RUN apt-get install`. You set environment variables, expose ports, define the runtime identity. You're encoding environment context.

**CI/CD pipeline:** You don't manually run tests. You define stages, approval gates, rollback conditions. You're structuring workflow context.

Everything you build in DevOps is an attempt to encode context so that the next person (or the next automation system) doesn't have to rediscover it.

Agents are the same. You're just being more explicit about it.

### The 4-Layer Context Pattern

Throughout this course, you'll use a reusable pattern for structuring context. It has four layers, each serving a purpose:

**Layer 1: Task Definition**

What are we trying to accomplish? Be specific. "Triage an alarm" is vague. "Determine if a CloudWatch alarm indicates an operational anomaly or a false positive, given metric history and recent infrastructure changes" is precise.

**Layer 2: Role and Expertise Context**

Who is doing this work, and what do they know? Are they an on-call engineer who knows the application? A junior SRE unfamiliar with the system? A cost analyst? The agent's "role" frames how it interprets information.

Example:

```
You are an on-call SRE for a Kubernetes platform team.
You have:
- 2 years of experience with our deployment pipeline
- Access to cluster metrics, logs, and git history
- Responsibility for keeping services up during business hours

You do NOT have:
- Permission to modify security policies
- Access to customer data
- Authority to change infrastructure without approval
```

**Layer 3: System Context**

What is the current state of the system? What are the baselines, constraints, and known issues?

```
Current cluster state (as of 2026-04-05 15:30 UTC):
- 3 worker nodes, all healthy
- 45 pods across 8 namespaces
- CPU utilization: 62% (alert threshold: 80%)
- Memory utilization: 71% (alert threshold: 90%)
- Recent change: Rolled out app v2.1.3 at 15:15 UTC

Known issues:
- Database connection pool occasional spikes (under investigation)
- Istio ingress controller has memory leak (ticket filed, low priority)

Baseline metrics (30-day normal range):
- CPU: 45–65%
- Memory: 50–75%
- Request latency p99: 120–180ms
```

**Layer 4: Procedural Context**

The decision tree, the runbook, the steps. This is where you encode "if this, then that."

```
Triage procedure:
1. If current CPU > baseline + 2 std dev AND recent change detected:
   → Investigate change first
2. If current CPU > 90% AND sustained > 5 min:
   → Trigger auto-scaling policy
3. If metric spike correlates with customer incident report:
   → Escalate to platform team, don't assume it's local
4. If metric is within normal range but alert triggered:
   → Check alert threshold configuration, might be miscalibrated
```

You'll see this pattern applied across domains: alarm triage, cost analysis, deployment validation, infrastructure-as-code generation.

## Token Economics

Let's talk money, because context engineering is also cost engineering.

Here's the pricing landscape as of early 2026:

| Provider | Model | Free/Cost | Key Limits |
|----------|-------|-----------|-----------|
| Anthropic | Claude Sonnet 4.6 | Claude Pro/Team subscription | $3 input / $15 output per M tokens |
| Google | Gemini 2.5 Flash | Free | 500 requests/day, ~15 RPM |
| Groq | Llama 3.1 8B (Instant) | Free | 14,400 requests/day, 6,000 TPM |
| OpenRouter | Various (free models) | Free credits (limited) | Models and limits change; use as fallback |

Let's ground this in a real scenario: **Alarm triage at scale.**

You have 500 alarms firing per day. Each alarm needs triaging. You decide to build an agent to handle it automatically.

**Per-alarm cost (using Claude Sonnet, Layer 4 context):**

- Alarm definition: 150 tokens
- Instance metadata: 400 tokens
- Service logs (30 min window, summarized): 2,000 tokens
- Deployment history (last 5 changes): 800 tokens
- Triage procedure (the Layer 4 context): 300 tokens
- Total input: 3,650 tokens

- Output (decision, recommendation, confidence score): 200 tokens
- Total output: 200 tokens

**Cost per alarm:**
- Input: 3,650 tokens × ($3 / 1M) = $0.01095
- Output: 200 tokens × ($15 / 1M) = $0.003
- **Total: $0.0139 per alarm**

**Daily cost for 500 alarms: $6.95**

**Annually: ~$2,540**

**Labor cost of manual triage: 500 alarms × 5 minutes = 2,500 minutes ≈ 41.7 hours per day**

At an on-call engineer's loaded cost of ~$75/hour: **$3,128 per day, or $1.14M annually.**

Even at just 30% of alarms triaged automatically, you save $342K per year.

And that's with *rich* context. If you engineer your context well—summarizing logs instead of sending raw lines, pre-computing baselines instead of asking the model to calculate them—you can reduce input tokens by 40–50% and save even more.

**Key insight: Context engineering is cost engineering. The better you structure what the model sees, the cheaper and faster your agents run.**

## Key Vocabulary

As you progress through the course, these terms will appear frequently. Here's a reference:

| Term | Definition |
|------|-----------|
| **Token** | A small unit of text (typically 3–4 characters), the atomic unit of cost and context for language models |
| **Context window** | The maximum number of tokens a model can process in a single request (e.g., Claude Sonnet: 200K) |
| **Inference** | The process of sending input to a model and receiving output; the runtime execution phase |
| **Prefill** | The parallel processing phase where the model reads all input tokens before generating output |
| **Decode** | The sequential generation phase where the model produces output one token at a time |
| **Temperature** | A hyperparameter controlling randomness in token selection (0 = deterministic, 1.0 = creative) |
| **Top-P** | A sampling method that selects from tokens until cumulative probability reaches a threshold |
| **Context engineering** | The practice of structuring information (domain knowledge, system state, constraints) so an AI system can reason effectively |
| **AI Spectrum** | The four levels of AI capability: Chat, Copilot, Agent, Squad |
| **Agent** | An autonomous system that reasons, plans, and executes multi-step workflows using tools and skills |
| **Skill (SKILL.md)** | A structured runbook that encodes operational knowledge for an agent to execute |
| **Tool/MCP** | The mechanism by which agents interact with external systems (CLI, API, database, etc.) |
| **Guardrail** | A policy that constrains what an agent can do (pre-approved, needs review, needs CAB) |
| **Few-shot example** | Input-output pairs provided in context to help a model understand the desired behavior |
| **Token budget** | The maximum number of tokens you allocate for a request, considering context window and cost |

---

## What's Next

You now have the mental model. In the lab, you'll apply these concepts by building a real Chat interface that incorporates rich context, then measuring how different context structures affect both output quality and cost.

Then we'll move into Platform AI (Module 3), where you'll explore what your cloud provider (AWS, in our case) already has available, and when it makes sense to use built-in services versus custom agents.
