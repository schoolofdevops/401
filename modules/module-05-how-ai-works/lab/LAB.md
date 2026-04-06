# Module 05: How AI Actually Works — The Engine Under the Hood (Lab)

**Estimated time:** 30 minutes
**Difficulty:** Beginner
**Prerequisites:** Module 04 complete (MCP servers running, cross-platform queries working). An AI coding agent (Claude Code or Crush) active and ready.
**Deliverable:** Completed "AI Processing Observation Sheet" with measurements, timings, and observations from 5 hands-on exercises

---

## What You're Building

This is not a traditional code lab. Instead, you're becoming a **mechanic**—popping the hood on how AI actually processes your requests and generating outputs.

In Module 04, you were the **passenger**: you asked questions across multiple tools and got integrated answers. You experienced *what* AI can do.

Now we're asking *how*. By running five timed experiments and observing real behavior, you'll understand:

1. **TTFT (Time to First Token)** — why some queries pause longer than others
2. **Tokenization** — how text becomes the atomic units the model reads
3. **Temperature** — why the same question produces different outputs
4. **Agent pipelines** — why cross-tool queries are slower than single-tool queries
5. **Context window management** — why adding more info sometimes slows you down

**Why this matters for DevOps:** You'll make better decisions about:
- What context to encode in SKILL.md files (Module 07)
- How to structure agent interactions for speed (Module 10)
- When to use agents vs. simpler queries (throughout Pillar 2)

---

## Prerequisites

**Required tools:**
- **AI coding agent:** Claude Code (via Claude Pro/Team) OR Crush (with Groq or Gemini 2.5 Flash configured)
- **Stop watch:** Your phone's timer app, or the `time` command
- **Web browser** (for one optional tokenizer)

**Verify your setup:**

```bash
# If using Claude Code: just confirm it's open and ready
# If using Crush: verify your provider is configured
crush models
# Output: should list available models from your configured providers
# e.g., "gemini/gemini-2.5-flash" or "groq/llama-3.1-8b-instant"
```

**Optional reference app infrastructure** (from Module 01):
- KIND cluster running (for Exercise 4)
- PostgreSQL and Prometheus data available

If you don't have the cluster running, Exercise 4 includes a fallback using a pre-recorded MCP query.

---

## Your Observation Sheet

Before you start: **Download or copy this template to your working directory:**

```bash
cp modules/module-05-how-ai-works/lab/starter/observation-template.md ./my-observations.md
```

You'll fill in your measurements as you go. This becomes your deliverable.

---

## Exercise 1: Measure TTFT — Time to First Token (8 minutes)

### What You're Observing

**TTFT** = the pause between when you press Enter and when the first word of the response appears.

According to Module 05's explainer:
- TTFT is driven by the **Prefill phase** — the model reading your entire input
- More input tokens → longer Prefill → longer TTFT
- Output length does NOT affect TTFT (that's the Decode phase)

**Your hypothesis:** A query with 10x more context will have a measurably longer TTFT.

### Step 1.1: Prepare Two Versions of the Same Question

You'll ask the same question twice: once with minimal context, once with rich context.

**Question:** `How would you diagnose a CPU spike on the catalog service?`

**Version A (Minimal Context — ~50 input tokens):**

```
How would you diagnose a CPU spike on the catalog service?
```

**Version B (Rich Context — ~500 input tokens):**

```
You are a DevOps SRE managing the reference-app microservices platform on Kubernetes (KIND cluster).

Infrastructure:
- Services: api-gateway, catalog, worker, dashboard — deployed in the "app" namespace
- Database: PostgreSQL in the "db" namespace (refapp database, tables: items, events)
- Monitoring: Prometheus + Grafana in the "monitoring" namespace
- The worker service writes heartbeat events to the events table every 60 seconds
- The catalog service reads from the items table (5 items, one marked "degraded")
- Each service exposes /health/live and /health/ready endpoints

Typical behavior:
- Worker heartbeat is steady (one event per 60s)
- Catalog CPU is low (read-only workload)
- A CPU spike on catalog usually means: excessive database queries, missing readiness probe, or a code regression

When investigating:
- Check pod events with kubectl describe
- Check pg_stat_activity for active connections
- Check recent events in the events table for anomalies
- Compare against normal heartbeat patterns

Now, a query: How would you diagnose a CPU spike on the catalog service?
```

### Step 1.2: Time TTFT for Version A

Open your AI agent and be ready to measure:

```bash
# Start your timer NOW (before you press Enter)
# Paste Version A into your agent
# Record the time from "Enter pressed" to "first character appears"
# This is TTFT-A

# Timing tip: use `date +%s%N` before and after for nanosecond precision, or just count seconds
```

**Example measurement:**

```
TTFT-A: 0.8 seconds
(Time from pressing Enter to first character: "Diagnosing" appeared after ~0.8 sec)
```

### Step 1.3: Time TTFT for Version B

Wait for Version A's response to finish streaming completely.

Now paste Version B and measure TTFT:

```bash
# Start timer NOW
# Paste Version B into your agent
# Record the time from "Enter pressed" to "first character appears"
# This is TTFT-B
```

**Example measurement:**

```
TTFT-B: 2.1 seconds
(Time from pressing Enter to first character: "To" appeared after ~2.1 sec)
```

### Step 1.4: Record and Observe

In your `observation-template.md`, fill in the **Exercise 1** section:

```markdown
### Exercise 1: TTFT Measurement

**Version A (minimal, ~50 tokens):**
- TTFT-A: _________ seconds

**Version B (rich context, ~500 tokens):**
- TTFT-B: _________ seconds

**Ratio (TTFT-B / TTFT-A):**
- Expected: 8-10x (proportional to token count)
- Actual: _________x

**Observation:**
_________________________________________________________________________

**Why this matters:**
```

### What You're Looking For

- **TTFT-B should be noticeably longer** (expect 2-4x to 10x difference)
- **The pause before the first token is noticeable to the human eye** — this is the Prefill phase at work
- **This directly impacts agent design** — if you stuff an agent with tons of SKILL.md context, every query will have this pause

---

## Exercise 2: Tokenization Patterns — How Text Becomes Atomic Units (6 minutes)

### What You're Observing

Tokens are how the AI model sees text. One token ≈ 4 characters in English, but **DevOps terms often tokenize differently**.

**Your hypothesis:** DevOps terms (Kubernetes, Terraform, PostgreSQL) might tokenize inefficiently compared to common English words.

### Step 2.1: Use an Online Tokenizer

Open one of these (both use BPE tokenization similar to Claude):

- **Tiktokenizer (recommended):** https://tiktokenizer.vercel.app/ — select `cl100k_base` to approximate Claude tokenization
- **OpenAI tokenizer (fallback):** https://platform.openai.com/tokenizer — uses GPT-4 tokenization (close enough for comparison purposes)

Paste these phrases one by one and count tokens:

**Set A — Common English:**

```
The database is slow today and needs optimization.
```

Expected: ~12 tokens

**Set B — DevOps Terms:**

```
PostgreSQL query on Kubernetes cluster using Terraform.
```

Expected: ~10-15 tokens (likely less efficient per character)

**Set C — Infrastructure Specification:**

```
RDS PostgreSQL db.t3.medium with 100 max connections running on us-east-1a
```

Expected: ~18-22 tokens

### Step 2.2: Count Tokens Directly in Your Agent

Use Claude Code or Crush to get token counts:

**If using Claude Code:**

Most Claude models show token counts in the interface. Check:
- Your prompt token count (shown in the UI after you submit)
- Compare two versions of the same query

Alternatively, paste this into your agent:

```
Count tokens in this phrase: "PostgreSQL query optimization on Kubernetes"

(Note: I can't give you an exact token count without API access, but I can explain that this phrase likely uses 10-12 tokens.)
```

**If using Crush:**

```bash
# Crush can't directly count tokens, but you can observe the output
crush run "How many tokens is the phrase: Kubernetes PostgreSQL Terraform Ansible"
```

### Step 2.3: Record Observations

In your `observation-template.md`, fill in **Exercise 2**:

```markdown
### Exercise 2: Tokenization Patterns

**Common English phrase:**
- Phrase: ____________________________
- Token count: _________

**DevOps terms phrase:**
- Phrase: ____________________________
- Token count: _________

**Observation:**
Does the DevOps phrase use more or fewer tokens per character than the English phrase?
_________________________________________________________________________

**Why this matters:**
```

### What You're Looking For

- **DevOps terms sometimes pack inefficiently** — "Kubernetes" might be 1-2 tokens, "PostgreSQL" might be 2 tokens
- **Specialist vocabulary adds token overhead** — important for SKILL.md design (Module 07)
- **This affects context window usage** — if your SKILL.md is full of un-compressible specialized terms, you use tokens faster

---

## Exercise 3: Temperature — Why the Same Question Has Different Answers (5 minutes)

### What You're Observing

**Temperature** controls randomness in token generation. Lower temperature = more deterministic (same answer each time). Higher temperature = more creative/random (different answer each time).

**Your hypothesis:** The same question at temperature 0.0 (deterministic) vs. 1.0 (creative) will produce noticeably different answers.

### Step 3.1: Ask an Ambiguous Infrastructure Question at Two Temperatures

Question: `What's the most important thing to monitor on a Kubernetes cluster?`

This is intentionally open-ended. Different temperatures should produce different answers.

**If using Claude Code:**

Claude Code may not expose temperature controls directly in the UI. If available, look for "settings" or "parameters." If not visible, document this limitation and skip to Step 3.3.

**If using Crush:**

Crush's CLI (`crush run`) doesn't expose a temperature flag. Temperature is set globally in your provider configuration. For this exercise, note that temperature isn't user-controllable in the interactive UI — **document this limitation in your observations.**

### Step 3.2: Run Two Queries

Most agent UIs (Claude Code, Crush) don't expose a temperature slider. If yours does:

```bash
# Claude Code API / curl: pass temperature in the API call
# Crush run: no --temp flag exists; temperature is provider-side
crush run "What's the most important thing to monitor on a Kubernetes cluster?"
# Run it twice and compare — if temperature > 0, outputs will vary slightly
```

If your agent doesn't support temperature control, that's fine — **document this in your observations.**

### Step 3.3: Compare the Answers

Record in your `observation-template.md`:

```markdown
### Exercise 3: Temperature Experiment

**Temperature 0.0 (deterministic) response:**
_________________________________________________________________________

**Temperature 1.0 (creative) response:**
_________________________________________________________________________

**Differences observed:**
- Same core idea, different emphasis? (yes/no)
- Different examples? (yes/no)
- Noticeably different tone? (yes/no)

**Why this matters:**
```

### What You're Looking For

- **Lower temperature (0.0):** Same answer if you repeat the question (boring but predictable)
- **Higher temperature (1.0):** Different creative takes on the same question (more variety but less consistent)
- **DevOps implication:** For operational runbooks (SKILL.md), you want LOW temperature (deterministic). For brainstorming, HIGH temperature is useful.

---

## Exercise 4: Agent Pipeline Observation — Single Tool vs. Multi-Tool Queries (7 minutes)

### What You're Observing

In Module 04, you wired multiple MCP servers (Kubernetes, PostgreSQL, GitHub, Prometheus). When your agent queries across multiple tools, it goes through a **pipeline**:

1. **User question** → Agent receives it
2. **Tool decision** → Agent decides which tools to call
3. **Tool execution** → Each MCP server responds
4. **Integration** → Agent synthesizes answers from multiple tools
5. **Response** → Agent returns integrated answer

This is slower than a single-tool query because of the round-trip overhead.

**Your hypothesis:** A three-tool cross-platform query will take noticeably longer than a single-tool query.

### Step 4.1: Prepare Two Queries

**Query A (Single Tool — Kubernetes only):**

```
List all pods in the "app" namespace and their current status in the KIND cluster.
(This should query Kubernetes MCP only)
```

**Query B (Three Tools — Kubernetes + PostgreSQL + GitHub):**

```
Show me:
1. All pods in the "app" namespace with their restart counts and status (from Kubernetes)
2. The most recent 10 rows from the "events" table in the refapp database (from PostgreSQL)
3. The last 3 commits to this repository (from GitHub)

Correlate: are there any pod restarts that coincide with gaps in the worker heartbeat events?
```

### Step 4.2: Time Query A (Single Tool)

**If you have the KIND cluster and MCP servers running from Module 04:**

```bash
# Start timer
# Paste Query A into your agent
# Record total time from submission to final response
```

**If you don't have the cluster running:**

Use this pre-recorded scenario:

```
Imagine you asked your agent: "What's the current CPU usage?"
The agent queried Kubernetes MCP and got back a single response.
Time elapsed: ~2-3 seconds (tool call + response)
```

### Step 4.3: Time Query B (Multi-Tool)

```bash
# Start timer
# Paste Query B into your agent
# Record total time from submission to final response
# (This includes: tool decision logic + 3 tool calls + integration time)
```

**If using the pre-recorded scenario:**

```
The same agent was asked a three-tool query (Kubernetes + PostgreSQL + GitHub).
The agent had to:
1. Decide to call 3 tools
2. Call each one (sequentially or in parallel, depending on agent design)
3. Wait for all responses
4. Synthesize and respond

Time elapsed: ~5-8 seconds (tool setup + 3 calls + integration)
```

### Step 4.4: Record Observations

In your `observation-template.md`:

```markdown
### Exercise 4: Agent Pipeline Observation

**Single-tool query (Kubernetes only):**
- Total time: _________ seconds
- Agent actions: 1 tool call

**Multi-tool query (Kubernetes + PostgreSQL + GitHub):**
- Total time: _________ seconds
- Agent actions: 3 tool calls + integration

**Slowdown ratio:**
- Expected: 2-4x slower (due to additional tool calls and synthesis)
- Actual: _________x

**Observation:**
Where was the time spent? (tool setup, waiting for responses, synthesis, etc.)
_________________________________________________________________________

**Why this matters:**
```

### What You're Looking For

- **Multi-tool queries are noticeably slower** — expect 2-4x increase in latency
- **The agent has to manage multiple responses** — this adds complexity and time
- **Design implication:** Don't wire ALL possible tools into every agent. Be selective. (This becomes critical in Modules 10-12.)

---

## Exercise 5: Document Your Findings (4 minutes)

### Review and Synthesize

Go back through your observations and answer these synthesis questions. Add them to your `observation-template.md`:

```markdown
### Exercise 5: Synthesis & Insights

**Question 1: Which exercise surprised you most?**
(TTFT growth / tokenization inefficiency / temperature variation / pipeline slowdown)

_________________________________________________________________________

**Question 2: If you were designing a SKILL.md file (Module 07), what would you optimize for based on what you learned?**
(Minimize tokens? Use deterministic temperature? Keep tool calls minimal? Something else?)

_________________________________________________________________________

**Question 3: Look back at Module 04's cross-platform queries. Given what you've learned about agent pipelines, what could slow them down?**

_________________________________________________________________________

**Question 4: How would you explain TTFT to a colleague who's skeptical about using AI in production?**

_________________________________________________________________________
```

---

## Deliverable Checklist

By the end of this lab, your `my-observations.md` should have:

- [ ] Exercise 1: TTFT measurements and ratio calculated
- [ ] Exercise 2: Tokenization counts and observations
- [ ] Exercise 3: Temperature experiment results (or note: not supported by your agent)
- [ ] Exercise 4: Agent pipeline timings and slowdown ratio
- [ ] Exercise 5: Synthesis questions answered
- [ ] Overall reflection: One paragraph summarizing the most important thing you learned

---

## Troubleshooting

**"My TTFT measurements look random / inconsistent"**

TTFT can vary by ±0.3-0.5 seconds due to network latency and server load. Run each measurement 2-3 times and average them. Record the range in your observations.

**"My tokenizer shows different counts than I expected"**

Different tokenizers have slightly different algorithms. Use the same tokenizer for both versions (A and B) so your comparison is valid.

**"I don't have a KIND cluster running for Exercise 4"**

Use the pre-recorded scenario provided in Step 4.2. You still learn the principle — multi-tool queries are slower than single-tool queries.

**"Temperature control isn't available in my agent"**

Document this as a limitation of your tool and explain why temperature matters conceptually. You still pass the exercise — you're learning, not testing the tool.

---

## What Comes Next

You now understand the **mechanics** under the hood. In Module 06, you'll use this knowledge to make smarter decisions about **what context to encode** in your SKILL.md files. In Modules 10-13, you'll design agents that optimize for speed and efficiency using these principles.

For now: submit your completed `my-observations.md` as your deliverable.
