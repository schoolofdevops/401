# Module 02 — Explainer Notes

> **Delivery format:** 14 diagrams (10 Excalidraw + 4 Gemini illustrations), presented sequentially.
> Each diagram = one concept beat. Use for live whiteboard delivery or Udemy video segments.
>
> **Naming convention:** `01-title-card.excalidraw` through `14-token-economics.excalidraw`
> **Style:** Black & white, hand-drawn (Excalidraw sketchy), outlines only — no fills, no colors.
> **Gemini illustrations:** 4 visual metaphor illustrations generated via Gemini image generator, same B&W style.
> See `diagrams/GEMINI-BRIEFS.md` for generation prompts.
>
> **Tool split:**
> | Diagram | Tool | Why |
> |---------|------|-----|
> | 1, 2, 4, 6, 7, 9, 10, 11, 12, 13 | Excalidraw | Schematic flows, architectures, comparisons |
> | 3, 5, 8, 14 | Gemini illustration | Visual metaphors, scenes, whimsical sketches |

---

## Diagram 1: Title Card — AI Foundations for DevOps Teams

**File:** `diagrams/01-title-card.excalidraw`
**Tool:** Excalidraw
**Duration:** ~1 minute

**Narrator notes:**

Welcome to Module 02 — AI Foundations for DevOps Teams.

In Module 01, you set up your lab environment and learned the AgenticOps Trinity Framework. Now we're going to open the hood and understand how the AI engine actually works.

Here's the thing — you don't need a PhD in machine learning. You need the same level of understanding you have about how a container runtime works: enough to debug it when it misbehaves, enough to configure it properly, enough to know its limits.

By the end of this session, you'll have a mental model of how LLMs work — built entirely on analogies from your DevOps world. And you'll have proof that your operational expertise is the single biggest factor in getting useful AI output.

---

## Diagram 2: How LLMs Work — The 3-Stage Pipeline

**File:** `diagrams/02-how-llms-work.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Left: "What You Type" (CloudWatch alarm JSON)
- Center: Three processing stages vertically: Tokenize → Process (Attention) → Generate (Decode)
- Right: "What You Get" (analysis response)
- Cost box: Input $3/M (cheap) vs Output $15/M (expensive)
- Below each stage: DevOps analogy

**Narrator notes:**

Let's demystify how LLMs actually work. I'm going to explain this through three stages, each mapped to something you already know.

**Stage 1 — Tokenization:** When you send text to an LLM, it doesn't read words like you do. It breaks your input into tokens — small chunks, roughly 3-4 characters each. Think of it like log parsing. Your log aggregator doesn't process raw text — it parses it into structured fields first. Same idea. "Kubernetes" becomes ["Kubern", "etes"]. JSON is token-expensive because of all the syntax characters — curly braces, colons, quotes each consume tokens.

**Stage 2 — Processing (Attention):** The model looks at ALL your tokens simultaneously and figures out how they relate to each other. This is the "prefill" phase. Here's the key — it's parallel, like `terraform plan`. The model loads everything at once, evaluates all the relationships, and builds an internal representation. Processing 200 tokens takes almost the same time as processing 1,000 tokens because of this parallelism.

**Stage 3 — Generation (Decode):** Now the model produces output one token at a time, sequentially. Each new token depends on everything that came before it. This is like `terraform apply` — changes happen in dependency order, one at a time. You can't parallelize this phase.

The practical takeaway: INPUT is cheap (parallel processing), OUTPUT is expensive (sequential generation). This shapes how we design context — make your input rich, constrain your output format.

---

## Diagram 3: Tokenization — Log Parsing Analogy

**File:** `diagrams/03-tokenization-log-parsing.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- Raw JSON text flowing into a parser that chops it into labeled token chunks
- Token fragments shown: ["Kubern", "etes", "{", "Alarm", "Name"]
- Equation: "Kubernetes" = 2 tokens, 800 chars JSON ≈ 200 tokens
- Note: "~3-4 characters per token. JSON is expensive."

**Narrator notes:**

Let me zoom in on tokenization because it's the foundation of everything else.

When your log aggregator receives raw syslog output, the first thing it does is parse it — break it into structured fields. Timestamp, severity, source, message. The raw text becomes structured data.

An LLM does exactly the same thing. It takes your text and breaks it into tokens — subword chunks that the model can process. "Kubernetes" isn't one token — it's two: "Kubern" and "etes." Every curly brace in your JSON, every colon, every quote — each one consumes a token.

Here's the practical rule of thumb: one token is roughly 3-4 characters for English text, closer to 3 for JSON because of all the syntax characters. That CloudWatch alarm JSON you'll use in the lab? About 800 characters, which means roughly 200 tokens.

Why does this matter? Because everything about LLMs — cost, capacity, speed — is measured in tokens. When we talk about a 200,000 token context window, you now know exactly what that means in terms of how many alarms, runbooks, or log entries you can fit.

---

## Diagram 4: Context Window — Container Memory Analogy

**File:** `diagrams/04-context-window-container.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- A large container box labeled "Context Window — 200K tokens"
- Inside: stacked content blocks (System Prompt, Conversation History, Tool Results, Current Task, Space Remaining)
- Side panel: "Agent Context Math" showing per-alarm token breakdown totaling 3,650, × 100 = 365K (exceeds window)
- Bottom: model window sizes comparison

**Narrator notes:**

Here's an analogy that'll stick with you: the context window is like a container's memory limit.

Your container gets a fixed amount of memory — say 512MB. If your app tries to use more than that, it gets OOM-killed. The container can't "remember" data that doesn't fit.

An LLM's context window works the same way. Claude Sonnet 4.6 has a 200,000 token window — roughly 150,000 words. That sounds enormous, and it is. But here's where it gets real for agents:

Let's say your agent is doing alarm triage. Each alarm analysis needs: the alarm data itself — about 150 tokens. Then you call `describe-instances` — that's 400 tokens. Pull recent logs with `get-log-events` — 2,000 tokens. Check deployment history — 800 tokens. Generate a summary — 300 tokens.

That's about 3,650 tokens per alarm. At 100 alarms, you're at 365,000 tokens. You just blew past Claude's context window. Your agent is "OOM-killed" — it can't see everything.

This is why context engineering matters so much for agents. You have to be intentional about what goes INTO that window, just like you're intentional about what goes into a container's memory.

---

## Diagram 5: Context Window OOM — Agent Overload

**File:** `diagrams/05-context-window-oom.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- A container/jar labeled "200K tokens" overflowing with alarm data blocks
- Alarms 1-50 fit inside; Alarms 51-100 spill over the rim
- Container shows stress cracks
- Docker whale with "OOM Killed" parallels the overflow
- Caption: "Context management is survival"

**Narrator notes:**

This illustration drives home what happens when you don't manage context. Imagine pouring 100 alarm analyses into a container that can only hold about 55.

The first 50 alarms fit fine. But as you keep pouring — alarm 51, 52, 60, 80, 100 — they're falling over the edge. The container can't hold them. In Docker, this is an OOM kill. In LLM terms, the API simply rejects your request.

This isn't hypothetical. If you're building an agent that processes alarms in bulk — which we will in later modules — you HAVE to think about batching, prioritization, and context window management. You wouldn't deploy a container with 256MB for a workload that needs 512MB. Same principle.

The solution? Batch your alarms. Process 50 at a time. Or better yet — build a triage layer that filters to high-severity alarms first, then sends only the critical ones for deep analysis. Context management IS agent architecture.

---

## Diagram 6: The AI Spectrum — Chat to Squad

**File:** `diagrams/06-ai-spectrum.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Horizontal arrow: "Increasing Autonomy →"
- Four boxes: Chat → Copilot → Agent → Squad
- Below each: DevOps analogy (Manual Ops, Scripted Ops, Orchestrated Ops, Self-Healing Infra)
- Course module mapping below each
- Dashed line between Copilot and Agent: "The Agentic Leap"

**Narrator notes:**

This diagram maps the AI capability spectrum to operations modes you already know.

**Chat — like Manual Ops:** You SSH into a server, look around, ask questions. With AI chat, you describe a problem, the AI responds. One question, one answer. No tool access, no persistence. You're driving everything.

**Copilot — like Scripted Ops:** The AI assists while you work. It suggests code as you type, explains errors, drafts docs. Think of it like having a runbook open beside you — it helps, but you're still executing every step. GitHub Copilot, Claude Code in suggestion mode — that's this level.

**Agent — like Orchestrated Ops:** Now it gets interesting. You give the agent a GOAL — not steps. "Triage this alarm." The agent picks tools, makes decisions, takes actions, reports back. This is like Ansible — you declare the desired state, the tool figures out how to get there. Except the agent can reason about unexpected situations.

**Squad — like Self-Healing Infrastructure:** Multiple specialized agents coordinating. A coordinator receives an incident, delegates investigation to a metrics agent, log analysis to another, communicates status to a third. This is your PagerDuty multi-step auto-remediation — but with reasoning at each step.

Notice the dashed line between Copilot and Agent — that's "The Agentic Leap." It's where tool access, autonomy, and context engineering requirements all jump dramatically. More autonomy means more context engineering is required. An agent with bad context takes bad actions on real infrastructure.

---

## Diagram 7: Agent Anatomy — Brain, Skills, Tools, Guardrails

**File:** `diagrams/07-agent-anatomy.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Central ellipse: "Agent"
- Four surrounding boxes connected by arrows: Brain (LLM), Skills (SKILL.md), Tools (MCP/CLI), Guardrails (approvals)
- Below each: DevOps parallel (on-call brain, runbook wiki, SSH access, change management)
- Bottom insight box: "Brain = pre-built. Skills + Tools + Guardrails = YOU build."

**Narrator notes:**

Every agent you'll build in this course has four components. Let me map each one to something you already know.

**Brain — the LLM:** This is the reasoning engine. Claude, Gemini, Llama — doesn't matter which one. Think of it as the on-call engineer's brain: it can reason, analyze, make judgments. But just like a new team member, it only knows what you tell it. A brilliant person with zero context about your system is still going to ask "what does this alarm mean?"

**Skills — your runbooks:** We encode operational knowledge in SKILL.md files. These are structured documents that tell the agent what it knows about your domain. This is your runbook, your wiki page, your "tribal knowledge" — but in a format the agent can actually use. Module 7 is entirely about writing these.

**Tools — MCP and CLI:** These are the agent's hands. kubectl, AWS CLI, database queries — all connected via MCP. Without tools, an agent is just a chatbot that sounds smart but can't DO anything.

**Guardrails — approvals and limits:** The safety layer. What can the agent do autonomously? What needs human approval? What's off-limits? Think of it as your change management process.

The critical insight: the Brain is the only part you DON'T build. Everything else — Skills, Tools, Guardrails — that's YOUR domain expertise. That's what this course teaches.

---

## Diagram 8: The Context Window as War Room Whiteboard

**File:** `diagrams/08-war-room-whiteboard.png`
**Tool:** Gemini illustration
**Duration:** ~3 minutes

**Visual layout:**
- A war room scene with a large whiteboard in the center
- Whiteboard divided into sections: System Prompt, Conversation History, Tool Results, Current Task
- Stick figure (the LLM) looking ONLY at the whiteboard
- Crossed-out items around the room: Grafana dashboards, Slack history, Confluence wiki
- Caption: "The model can ONLY see the whiteboard. YOU decide what goes on it."

**Narrator notes:**

Here's the analogy that makes context windows click for DevOps people.

Imagine you're in an incident war room. There's a big whiteboard on the wall. Everything the team needs to know about the incident is on that whiteboard — the timeline, the metrics, the runbook steps, who's doing what.

Now imagine you can ONLY see the whiteboard. No laptops, no phones, no Slack history. Just the whiteboard. If something isn't written on it, it doesn't exist for you.

That's exactly how an LLM's context window works. Your system prompt — that's the standing info at the top. Conversation history — the left column. Tool results from kubectl and AWS CLI — the right column. Your current question — front and center.

Everything else — your monitoring dashboards, your git history, your Slack channels, your Confluence wiki — invisible. Unless YOU put that information on the whiteboard.

This is why context engineering is the core skill. You're the person deciding what goes on the whiteboard before the incident commander (the LLM) walks in.

---

## Diagram 9: Temperature — The Confidence Dial

**File:** `diagrams/09-temperature-dial.excalidraw`
**Tool:** Excalidraw
**Duration:** ~2 minutes

**Visual layout:**
- Horizontal bar with three marked positions: 0, 0.5, 1.0
- Three callout boxes below: Deterministic (incident triage), Balanced (analysis), Creative (brainstorming)
- Bottom rule: "For production agent skills → ALWAYS 0"

**Narrator notes:**

Temperature is a simple concept with big operational implications.

At temperature 0, the model always picks the most probable next token. It's deterministic — same input, same output. This is what you want for incident triage, runbook execution, IaC generation. Consistency matters when you're acting on production infrastructure.

At temperature 1.0, the model samples from the full range of possibilities. More creative, more varied, less predictable. Good for brainstorming, generating test scenarios, writing documentation.

The rule for this course: when we build agent skills in Modules 7 and beyond, we use temperature 0. Your SRE agent shouldn't give a "creative" diagnosis at 3am. It should give a consistent, reproducible one.

---

## Diagram 10: Prefill vs Decode — terraform plan / terraform apply

**File:** `diagrams/10-prefill-vs-decode.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Two side-by-side zones: "Phase 1: PREFILL" and "Phase 2: DECODE"
- PREFILL: tokens processed simultaneously (parallel boxes), "Like terraform plan", "$3/M — CHEAP"
- DECODE: tokens generated one-at-a-time in sequence (chained boxes with arrows), "Like terraform apply", "$15/M — 5x MORE"
- Bottom strategy: "Rich context in (cheap) + constrained output format (expensive)"

**Narrator notes:**

This is the diagram that changes how you think about cost. The LLM inference pipeline has two distinct phases, and understanding them is like understanding the difference between `terraform plan` and `terraform apply`.

**Prefill** is like `plan` — the model loads your entire input, processes ALL tokens simultaneously in parallel on the GPU. It's fast and efficient. Processing 200 tokens takes almost the same time as processing 1,000 tokens. This is why input is cheap — $3 per million tokens.

**Decode** is like `apply` — the model generates output one token at a time, sequentially. Each token depends on all previous tokens. You can't parallelize it. This is why output is expensive — $15 per million tokens, five times the input cost.

The design strategy that falls out of this: make your INPUT rich — layer on context, runbooks, topology. That's cheap. But constrain your OUTPUT — "Respond in JSON with these exact fields." That limits the expensive sequential generation.

When someone says "respond in JSON" to an LLM, that's not just a formatting preference. It's cost engineering.

---

## Diagram 11: Domain Expertise Chain — Your Superpower

**File:** `diagrams/11-domain-expertise-chain.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Horizontal chain: Expertise → Vocabulary → Context → Results
- Two parallel tracks below:
  - Generic IT: "Basic IT" → "server is slow" → "check performance" → "Generic: restart the service"
  - Expert SRE: "5yr SRE" → "p99 latency spike / connection pool exhaustion" → "RDS configs, pgbouncer, deployments" → "Expert: scale pool to 150, check v2.3.1 leak"
- Bottom: "Same AI. Same model. ONLY difference = context from domain expertise."

**Narrator notes:**

This is the single most important diagram in this module. Maybe in the entire course.

There's a chain reaction that happens when a domain expert uses AI: your Expertise gives you Vocabulary. Your Vocabulary shapes your Context. Your Context determines Results.

Let me make this concrete. Two people analyzing the same CloudWatch alarm — high CPU on an EC2 instance.

Person A has basic IT knowledge. They say "server is slow." Their context is "check performance." The AI responds with a generic answer: "Consider restarting the service or increasing resources."

Person B is an SRE with 5 years of experience. They say "p99 latency spike correlated with connection pool exhaustion on the catalog-api instance." Their context includes RDS max_connections settings, pgbouncer configuration, and recent deployment history. The AI responds with: "Scale the connection pool from 100 to 150, check for connection leak introduced in v2.3.1."

Same AI. Same model. Same temperature. The ONLY difference is the context that came from domain expertise. This is why your 5 years of DevOps experience isn't just useful — it's THE thing that makes AI 10x more effective.

---

## Diagram 12: Before/After — Same AI, Different Results

**File:** `diagrams/12-before-after.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Two columns: "Without Context" | "With Context Engineering"
- Left: simple prompt → generic AI output ("check metrics, consider scaling")
- Right: 4-layer context stack (Role + Topology + Runbook + Same Alarm) → specific, actionable AI output
- Center divider: "Same Model. Same Intelligence. Different Context."
- Bottom: "You'll prove this yourself in the lab."

**Narrator notes:**

Let's make this concrete with a preview of what you're about to do in the lab.

On the left — you take a CloudWatch alarm JSON and send it to the AI with no context. "Analyze this alarm." The AI responds with something like: "This appears to be a high CPU alarm. You should investigate the cause, check recent changes, and consider scaling." Technically not wrong — but completely useless at 3am.

On the right — same alarm, but you've added four layers of context. Role context: "You're an SRE on a production e-commerce platform." Infrastructure topology: "This instance serves the product catalog for 50K users, CPU normally runs 60-65%." Runbook: "Step 1: check traffic spike, Step 2: check runaway process, Step 3: check recent deployment."

Now the AI responds with: "CPU at 92% on catalog-api — 27 percentage points above the 65% peak baseline. No corresponding ALB traffic spike suggests this isn't load-driven. Check for runaway process via SSM. If no resolution in 10 minutes, follow runbook step 5: isolate and restart after snapshotting logs."

Same model. Same intelligence. Different context. You'll prove this to yourself in about 20 minutes when we start the lab.

---

## Diagram 13: The 4-Layer Context Pattern

**File:** `diagrams/13-four-layer-pattern.excalidraw`
**Tool:** Excalidraw
**Duration:** ~2 minutes

**Visual layout:**
- Four stacked layers (bottom to top):
  - Layer 1: "Raw Data — Alarm JSON only" → Quality: Generic
  - Layer 2: "Role Context — SRE identity, think in MTTR" → Quality: Focused
  - Layer 3: "Infrastructure Context — topology, baselines, dependencies" → Quality: Specific (BIGGEST JUMP)
  - Layer 4: "Procedural Context — runbook, decision tree, CLI commands" → Quality: Expert
- Right side: quality arrow from Generic to Expert
- Bottom: "This pattern works for every operational domain"

**Narrator notes:**

Here's what you're about to build in the lab — the 4-layer context pattern.

Layer 1: You start with just the raw data — a CloudWatch alarm JSON. No context at all. This is your baseline.

Layer 2: You add role context — telling the AI to think like an SRE, to consider MTTR, customer impact, severity. This focuses the analysis but it's still generic.

Layer 3: You add infrastructure context — your specific instance names, what they serve, normal baselines, dependencies. This is where generic advice turns into specific analysis. This is the BIGGEST quality jump.

Layer 4: You add procedural context — your runbook, your decision tree, your CLI commands. This is where the AI follows YOUR team's incident response process.

This 4-layer pattern is reusable across every domain: cost analysis, security review, deployment validation, capacity planning. It's the mental model you'll use for the rest of the course. And SKILL.md files — which you'll write in Module 7 — are just Layers 2, 3, and 4 encoded in a reusable format.

---

## Diagram 14: Token Economics — The Business Case

**File:** `diagrams/14-token-economics-balance.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- A balance scale: AI Agent ($1.50/day) vs Manual Triage ($3,000+/day)
- Side receipt: Input cost + Output cost = $5.25/day total, Free option = Gemini $0
- Caption: "Context engineering IS cost engineering"

**Narrator notes:**

Let's talk money — because this is what gets budget approval.

Your team gets 500 alarms a day. Today, someone triages each one manually — takes about 5 minutes each. That's 2,500 minutes. 41.7 hours. You need a team of 5+ people just for triage.

Now look at the AI agent approach. Each alarm with full Layer 4 context — runbook, topology, the works — costs about 1,000 input tokens plus 500 output tokens. At Claude's pricing: input is $1.50 per day, output is $3.75. Total: $5.25 per day. About $157 per month.

Or use Gemini's free tier — 500 requests per day at zero cost. All 500 alarms at Layer 4 quality. Completely free.

And remember the design principle from the prefill/decode diagram: make input rich (that's the cheap part) and constrain output format (that's the expensive part). Context engineering IS cost engineering. The same skills that make your AI output better also make it cheaper.

---

## Delivery Summary

### Diagram Sequence and Timing

| # | Title | Tool | Duration | Concept Beat |
|---|-------|------|----------|-------------|
| 1 | Title Card | Excalidraw | 1 min | Module framing |
| 2 | How LLMs Work — 3-Stage Pipeline | Excalidraw | 4 min | The inference pipeline |
| 3 | Tokenization — Log Parsing | Gemini | 2 min | How text becomes tokens |
| 4 | Context Window — Container Memory | Excalidraw | 4 min | Fixed capacity, math matters |
| 5 | Context Window OOM | Gemini | 2 min | What happens when you exceed it |
| 6 | AI Spectrum — Chat to Squad | Excalidraw | 4 min | Four levels of capability |
| 7 | Agent Anatomy — 4 Components | Excalidraw | 4 min | Brain + Skills + Tools + Guardrails |
| 8 | War Room Whiteboard | Gemini | 3 min | Context window as a visual space |
| 9 | Temperature — Confidence Dial | Excalidraw | 2 min | Deterministic vs creative |
| 10 | Prefill vs Decode | Excalidraw | 3 min | Why input is cheap, output is expensive |
| 11 | Domain Expertise Chain | Excalidraw | 4 min | The single most important insight |
| 12 | Before/After Comparison | Excalidraw | 3 min | Proof that context drives results |
| 13 | 4-Layer Context Pattern | Excalidraw | 2 min | The reusable framework |
| 14 | Token Economics | Gemini | 2 min | The business case |
| | **Total** | | **~40 min** | |

### Live Workshop Flow

1. Diagrams 1-5 (~13 min) — "How AI Works Under the Hood"
2. Diagrams 6-8 (~11 min) — "The AI Landscape and Agent Architecture"
3. Break (5 min)
4. Diagrams 9-10 (~5 min) — "Parameters and Economics"
5. Diagrams 11-14 (~11 min) — "Domain Expertise and the Lab Preview"
6. Lab (~40 min) — Progressive context engineering
7. Quiz (~15 min)

### Udemy Self-Paced Flow

1. Video: "How LLMs Work — An Operations Perspective" (diagrams 1-5, ~13 min)
2. Video: "The AI Spectrum and Agent Anatomy" (diagrams 6-8, ~11 min)
3. Video: "Temperature, Cost, and the Business Case" (diagrams 9-10, 14, ~7 min)
4. Video: "Domain Expertise — Your Superpower" (diagrams 11-13, ~9 min)
5. Lab walkthrough video (separate recording)
6. Quiz (Udemy native quiz)
