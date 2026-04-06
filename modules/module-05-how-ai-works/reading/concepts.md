# Module 05: How AI Actually Works — The Engine Under the Hood

## Introduction: Opening the Black Box

You've spent your career building systems where you understand the stack — from kernel scheduling to container resource limits to application latency. You debug by tracing system calls. You right-size infrastructure by measuring actual load. You don't just hope things work; you know *why* they work.

That instinct doesn't disappear when you move into AI systems. The problem is that LLMs feel mysterious. You ask a question, something happens inside a neural network, and out comes an answer. It's tempting to treat it like pure magic — you put input in, AI does its thing, you get output.

But it's not magic. It's a machine, just a different kind than you're used to. And like any machine, once you understand how it works, you can run it efficiently, predict its behavior, troubleshoot its quirks, and right-size it for your workload.

This reading pulls back the curtain on what actually happens when you press Enter on a query to Claude, Gemini, or any large language model. We'll build your mental model of the system from the ground up, using the DevOps patterns you already know.

---

## The Full Processing Pipeline: From Enter to Output

When you type a question into Claude and press Enter, there's a specific journey that text takes. It doesn't all happen at once. Understanding this journey is the key to everything else — cost, latency, performance, agent design decisions.

Here's the journey in four phases:

1. **Tokenization** — Your text becomes numbers (tokens)
2. **Prefill Phase** — The model reads all your input in parallel
3. **Decode Phase** — The model generates output, one token at a time
4. **Output** — You see the response

These phases are separate. They have different performance characteristics. They scale differently. They cost differently. Once you see the pipeline clearly, everything else makes sense.

Let's walk through each.

---

## Tokenization: Text Becomes Numbers

Before the model can think about your question, it converts your text into tokens. A token is roughly a word or a significant chunk of text — sometimes a word, sometimes a subword, sometimes even a punctuation mark. The exact mapping depends on the model's vocabulary.

Think of tokenization like how your container orchestrator converts a high-level Kubernetes manifest into API objects. You write `replicas: 3` in your YAML, but the API server breaks that down into discrete instructions it can execute. Tokenization works similarly: you write `Deploy a Kubernetes cluster`, and the tokenizer breaks it into discrete symbols.

Here's a concrete example. The phrase:

```
terraform apply -auto-approve
```

might tokenize as:

```
[ter] [raf] [orm] [apply] [-] [auto] [-] [approve]
```

Or it might be:

```
[terraform] [apply] [-auto-approve]
```

It depends on the model's vocabulary. Some tokens are whole words (if they're common). Some are subword pieces (if a word is rare). Some are individual characters (if it's a symbol the tokenizer hasn't seen).

### Why Tokenization Matters

Three reasons you should care:

**Cost.** You're charged per token, not per character. If a word tokenizes into three subword pieces instead of one, you're paying three times as much for the same concept. This is why DevOps terminology matters. A common term like "Kubernetes" might be one or two tokens. A vendor-specific acronym you made up might tokenize into six. When you're running agents that make dozens of requests, these small differences add up.

**Context Window.** Your total capacity is measured in tokens, not words. A typical 2,000-word document might be 3,000 tokens. That same document with lots of special characters, code blocks, and domain-specific terms might be 3,800 tokens. You need to know the token count to pack your context efficiently.

**Understanding.** Some terms tokenize poorly, which means the model has to "work harder" to understand them. A well-known term that's one or two tokens is more likely to trigger the right associations in the model than a rare term that tokenizes into eight pieces. This is why the Domain Expertise chain works: **Expertise → Vocabulary → Context → Results**. Using standard DevOps vocabulary means your terms tokenize cleanly and activate the model's understanding directly. Making up novel terms means the model has to infer what you mean from scattered subword pieces.

### Practical Implication

When you're building context for an agent, choose established terms over novel ones. "RDS instance" is one or two tokens. "Relational datastore engine instance" is five. Same meaning, different cost and clarity.

---

## The Prefill Phase: Reading Before Replying

Once your input is tokenized, the model enters the prefill phase. This is where it reads everything you've given it — your full query, your context, your examples, all of it — at once, in parallel.

Think of this like `terraform plan`. You give Terraform your full configuration, and it processes the entire thing in parallel to figure out what it's going to do. It doesn't apply resources one at a time while reading the config. It reads the whole config, understands the full desired state, then decides what to do.

The prefill phase is the same. The model reads your entire input in parallel, building what's called an "attention map" — a web of connections between all the tokens that helps it understand relationships and context.

### The Attention Mechanism (Simplified)

Here's the mental model. Imagine your query:

```
What are the causes of high CPU usage in my Kubernetes cluster?
```

During prefill, the model builds connections:

- "high" connects to "CPU" (they're related)
- "CPU" connects to "usage" (connected concept)
- "Kubernetes" connects to "cluster" (belongs-to relationship)
- "causes" connects to everything (it's asking for root causes)

These connections are called "attention weights." They're not explicit rules you write. The model learns them during training based on patterns in real data. When it read billions of DevOps documents, infrastructure configs, and troubleshooting conversations, it learned which concepts cluster together, which words modify each other, which ideas depend on context.

The elegant part: the model doesn't build these connections linearly, reading word one, then two, then three. It processes all tokens in parallel, building the full attention map at once.

### Why This Matters: It's the "Think" Phase

Prefill is where the model does most of its thinking. Reading your context, understanding the domain, connecting your specific situation to patterns it learned during training — all of that happens in prefill. The decode phase (which we'll cover next) is mostly just writing down what it already figured out.

This has two big implications:

**TTFT is driven by input size.** Time to First Token — the delay before you see the first word of the response — scales with how much you give the model to read. A short query might have TTFT of 100 milliseconds. A 10,000-token context dump might have TTFT of two seconds. We'll explore this more in the TTFT section.

**Better context = better thinking.** You can give the model a richer problem by feeding it more context. But the tradeoff is longer TTFT. This is a fundamental design decision in any agent system, and we'll spend all of Module 06 learning how to navigate it.

---

## The Decode Phase: One Token at a Time

Once the model has finished prefill and understands your context, it starts generating a response. This is the decode phase, and it's fundamentally different from prefill.

In decode, the model generates one token at a time, in sequence. It can't parallelize. It reads all the tokens it's generated so far (plus your original input, plus any context) and predicts the next single token. Then it reads everything again (including the new token) and predicts the token after that.

Think of this like `terraform apply`. During plan (prefill), Terraform processes everything in parallel. During apply (decode), it creates and modifies resources in sequence, because some resources depend on others. It can't provision resource B until resource A exists. It's inherently sequential.

Your response is the same. The model can't write:

```
Here's the complete answer to your question
```

all at once. It writes "Here's" (one token), then reads "Here's" and writes "the" (next token), then reads "Here's the" and writes "complete" (next token), and so on.

### Why This Matters: Latency

This sequential nature has direct consequences:

- A 100-token response requires roughly 100 sequential steps
- A 500-token response requires roughly 500 sequential steps
- A 2,000-token response takes noticeably longer

This is why streaming responses feel snappy — you start seeing tokens arrive immediately (TTFT is over), and they stream in at about 50-150 tokens per second on modern hardware. If the model had to buffer the entire response before showing you anything, you'd wait for the full decode to finish. Streaming is just a display trick, but it makes the experience feel much faster.

For agents, this matters more. An agent that generates a plan (prefill: fast, parallel), then generates code (decode: slower, sequential), then runs the code, then decides what to do next (another prefill/decode cycle) — that agent is much slower than a simple request-response pair.

---

## TTFT: Time to First Token

You've probably noticed the pause after you hit Enter on a Claude query before you see the first word. That pause is TTFT — Time to First Token. It's not network latency. It's not the model thinking about your answer. It's the prefill phase.

TTFT is determined by:

1. **Your input size** — How many tokens you gave the model to read
2. **Batch size** — How many other users are running queries at the same time
3. **Hardware** — The physical infrastructure the model runs on

For you as a course participant using Claude Code, #3 is handled by Anthropic. You can't control it. But #1 and #2 you can.

### Input Size Scaling

A short query (50 tokens):
- TTFT: ~100 milliseconds

A medium context (2,000 tokens):
- TTFT: ~200-400 milliseconds

A large context (10,000 tokens):
- TTFT: ~1-2 seconds

A very large context (100,000 tokens):
- TTFT: ~5-10 seconds

It's not linear, but it's directional. More input = longer TTFT. This is a real tradeoff you make when designing agent workflows.

### Practical Implications

When you're designing an agent that queries MCP servers (like we did in Module 04), each query includes:

- Your original question
- The schema of all available tools
- The results from previous tool calls
- System instructions and role context

If you give the agent five MCP servers with 50 tools each, and the schema for each tool is verbose, you could easily be at 15,000 tokens just for "static" context that repeats every turn. Then you add the conversation history. Then the code samples. Suddenly TTFT is measured in seconds.

This is why context engineering (Module 06) is about compression and selection, not just "give it more data."

---

## Context Window: Your Capacity Constraint

Every model has a context window — a maximum number of tokens it can read in a single request. It's like container memory limits. You can't allocate 16GB of RAM to a container that only has 8GB available.

### Context Window Sizes (as of 2026)

Claude:
- **Haiku:** 200K tokens (free tier), 1M tokens (if you have it)
- **Sonnet:** 200K tokens
- **Opus:** 200K tokens

Gemini (Google):
- **Flash:** 1M tokens free
- **Flash-Lite:** 1M tokens free

Other providers vary, but most modern models support 100K+ tokens.

### The Misunderstanding: Bigger Isn't Always Better

Many people think "the model with the biggest context window is the best." That's like saying "the server with the most RAM is the best." Not necessarily.

A large context window is valuable *if you use it well*. If you're packing in context randomly, dumping entire codebases or log files without selectivity, you're:

- Increasing TTFT for no reason
- Making prefill more expensive (you're charged per input token)
- Wasting attention on irrelevant information
- Potentially confusing the model with contradictory or low-signal data

The sweet spot is usually 20-40% of your available context window. That's enough to give the model rich context without padding it with noise.

### Right-Sizing Your Context

For a single query to Claude:
- Task description: 500 tokens
- Current system state (logs, config, status): 2,000-5,000 tokens
- Examples or precedent: 1,000-2,000 tokens
- Instructions: 500 tokens
- Total: 5,000-10,000 tokens

That leaves you 190,000+ tokens of headroom in a 200K window. That's intentional. You're not trying to max out the window. You're trying to be selective and efficient.

For an agent running in a loop:
- Static context (tools, instructions, role): 2,000-5,000 tokens
- Conversation history: grows with each turn
- Current task: 1,000-2,000 tokens

After 10 agent turns, you might be at 15,000 tokens. After 50 turns, you might hit 50,000. At that point, you either summarize the conversation history (compress it), or you start a new session.

---

## Attention and Understanding: The Assembly Line

Let's go deeper into how the model actually understands concepts. The prefill phase builds an attention map, but what does that really mean?

Imagine a factory assembly line. Each position on the line has a worker. Your tokens are the positions. During prefill, each worker reads the specifications for the product (the entire input), then they look around at every other position on the line to understand dependencies.

"I'm assembling the 'CPU' part. What does 'high' have to do with me?" (attention weight: high)
"I'm assembling the 'usage' part. What do I have to do with 'CPU'?" (attention weight: high)
"I'm assembling the 'causes' part. What do all the other parts depend on?" (attention weight: varies by token)

The model's "understanding" is built from these connections. When it later generates a response, it's traversing these attention paths, following the high-weight connections and ignoring the low-weight ones.

This is why context matters so much. If you give the model confusing context, you're setting up a tangled assembly line. If you give it clear, well-organized context, you're setting up an efficient one.

Example:

**Confusing context:**
```
The cluster is using 80% CPU. We deployed new code yesterday.
The network was patched. CPU usage is fine actually. We should
investigate the pods. The pods are running fine. Maybe it's the nodes.
```

The model has to trace through contradictions: "Wait, CPU usage is high? Or fine? What's the actual problem?" The attention map gets tangled.

**Clear context:**
```
Current situation: Cluster using 80% CPU as of 10:00 AM UTC.

Recent changes (last 24 hours):
- Code deploy at 09:00 AM (potential cause)
- Network patch at 08:30 AM (unrelated)

Pod status: All running, no errors.
Node status: CPU high across 3 of 5 nodes.
```

The attention map is clear. The model immediately identifies: new code is a suspect, pods are not the problem, nodes are affected. It can focus on the code deploy and system load.

This is the reason we emphasize clear, structured context engineering in Module 06. You're not being pedantic. You're making the model's job easier by organizing the assembly line.

---

## Temperature: The Creativity Dial

Every model has a parameter called temperature. It's a dial that controls how much the model varies its outputs.

**Low temperature (0.0-0.3):** The model picks the statistically most likely next token almost every time. Outputs are consistent, predictable, deterministic. The same input produces the same (or very similar) output every time.

**Medium temperature (0.5-0.7):** The model occasionally picks less likely tokens, introducing variation. Outputs are coherent but have some natural variation, like how you might word something slightly differently each time.

**High temperature (1.0+):** The model frequently picks less likely tokens, leading to more creative and varied outputs. Outputs can be surprising, novel, sometimes off-the-wall.

### Temperature and DevOps: Context Matters

Different tasks call for different temperatures:

**Low temperature (0.1-0.3):** Infrastructure code generation, bug fixes, documentation. You want consistent, repeatable results. If you ask Claude to generate a Terraform module, you want the same module every time, not variations.

**Medium temperature (0.5-0.7):** Creative documentation, brainstorming, architecture discussions. You want the model to explore the idea space a bit but stay coherent.

**High temperature (0.8+):** Brainstorming, creative problem-solving, ideation. You're explicitly looking for novelty.

When you're designing agents, temperature is a design decision. An agent that generates IaC code should run at low temperature. An agent that drafts runbook procedures can go higher. An agent that brainstorms solutions can go even higher.

### The Default: 1.0

If you don't specify temperature, most models default to 1.0. That's not "0 creativity." It's "medium-high creativity." For infrastructure work, that's often too high. You'll want to dial it down.

---

## Model Size Tiers: Motorcycle, Sedan, Truck

Anthropic (and other providers) offer models in different size tiers. The differences matter.

### Claude's Current Lineup (2026)

**Haiku** — The motorcycle
- Fastest inference
- Smallest context (unless you're on an extended plan)
- Lowest cost
- Best for: simple queries, high-volume batch work, latency-critical tasks
- DevOps use: quick troubleshooting, single-turn queries, high-volume analysis

**Sonnet** — The sedan
- Balanced speed and capability
- Large context window
- Medium cost
- Best for: most real work, most agent tasks, single or multi-turn queries
- DevOps use: code generation, architecture discussions, agent workflows

**Opus** — The truck
- Slowest inference
- Largest context window
- Highest cost
- Best for: hardest reasoning problems, most complex tasks, deep analysis
- DevOps use: complex design reviews, deep architectural analysis, research tasks

### Right-Sizing Your Model

The mistake most people make is defaulting to the biggest model. That's like using a truck to drive to the grocery store. You get the same groceries, but you've wasted fuel.

For 80% of DevOps queries: Sonnet is the right tool. It's fast enough that you don't notice latency. It's capable enough for any practical infrastructure task. It's cost-effective.

For high-volume batch work (analyzing 1,000 log files, generating 50 Terraform modules): Haiku might be right. Trade some capability for speed and cost.

For one-off hard problems (designing a disaster recovery architecture, reviewing a complex system proposal): Opus might be right. You're willing to wait 5 seconds longer for the best possible output.

In this course, we'll mostly use Sonnet for labs, with Haiku noted as a cost alternative and Opus for deep reasoning tasks.

---

## The Agent Processing Pipeline: Loops Within Loops

Now let's connect this to agents — the focus of Module 07 and beyond.

A simple agent request-response is:

1. You ask a question (your input is tokenized)
2. Prefill: model reads your question
3. Decode: model generates a response
4. Response appears

An agent with tools is different:

1. You ask a question
2. Prefill: model reads your question + tool descriptions
3. Decode: model generates a tool call
4. Agent runs the tool
5. Prefill: model reads original question + tool results
6. Decode: model generates a response or calls another tool
7. Repeat 4-6 until done

Every tool call creates a new prefill/decode cycle. And on each cycle, the context grows: original question + first tool result + second tool result + conversation history so far.

### Why Agents Are Slower

This is the key insight: agents are slower than single-shot queries because they run multiple prefill/decode cycles. Each cycle has TTFT. Each cycle's prefill reads all the previous results.

Example:

```
Turn 1 (2 turns total):
- Prefill: read question + tool schema (2,000 tokens) → TTFT 200ms
- Decode: generate tool call → 50 tokens
- Tool executes (100ms)

Turn 2:
- Prefill: read question + tool schema + tool result (5,000 tokens) → TTFT 400ms
- Decode: generate response → 200 tokens

Total: ~700ms (mostly latency, not compute)
```

Compare to a single-shot query where you ask the question and the model answers directly:

```
Single shot (1 turn):
- Prefill: read question + context (2,000 tokens) → TTFT 200ms
- Decode: generate full response → 200 tokens

Total: ~300ms
```

The agent is 2x slower because it makes two prefill passes. If you had an agent with 10 tool calls, it could be 10x slower.

### Context Grows with Each Turn

This is the second reason agents get slow. Look at the token counts:

- Turn 1 prefill: 2,000 tokens
- Turn 2 prefill: 5,000 tokens (original question + tool result)
- Turn 3 prefill: 8,000 tokens (original question + tool result 1 + tool result 2)
- Turn 4 prefill: 11,000 tokens
- ...

After 10 turns, you're at 35,000+ tokens of prefill on each request. TTFT has grown from 200ms to 1,000ms+.

This is why summarization and context compression are critical for long-running agents. After a few turns, you stop including the full tool results and start including "here's what we know so far" summaries.

---

## Practical Implications: The Four Takeaways

Let's synthesize everything into actionable principles for designing DevOps agents.

### 1. Context Budget: You're Buying Tokens, Not Words

Every token costs money (in the API) or counts against your rate limit (on free tiers). Every token of input increases TTFT. Treat your context as a budget.

If you have a 200K context window, don't use 150K. Use 15-20K and stay efficient. Every token you include should justify itself:

- Is this information necessary to answer the question?
- Is this the most compact way to express this information?
- Does this increase understanding or decrease it?

Module 06 is entirely about context engineering — learning to build rich context cheaply.

### 2. Agent Turn Costs: Multi-Turn Is Slower

Agents are powerful but slower. Each tool call is a prefill/decode cycle. Each cycle has latency. If you can answer a question in one shot, do it. If you need multiple tool calls:

- Batch them (one turn, multiple tools, if the model supports it)
- Summarize aggressively (compress old results)
- Limit tool availability (don't expose 100 tools if the agent only needs 5)

### 3. Model Right-Sizing: Match Capability to Task

Sonnet is your default. Haiku for high-volume, fast work. Opus for hard reasoning. Running Opus for every query is like using a truck for grocery shopping.

### 4. Temperature Matching: Control Variation

Low temperature for deterministic work (IaC, code generation). Medium for balanced tasks. High for brainstorming. The default of 1.0 is often too creative for infrastructure work.

---

## Looking Forward: Context Engineering (Module 06)

Everything we've covered here is the foundation for what you'll learn next. In Module 06, we'll learn to engineer context instead of engineering prompts.

The difference is this:

- **Just a prompt:** "Write me a Terraform module that deploys a Kubernetes cluster. It should have 3 nodes, use auto-scaling, and support 100 concurrent users."
- **Context engineering:** "Here's an identical Terraform module from our last deployment (600 tokens). Here's the system requirements doc (300 tokens). Here's the current failure modes we've experienced (400 tokens). Given this context, what would you change?"

The prompt is just the question. The context is everything the model needs to know to think like you. Module 06 teaches you to build context that transforms the model from a generic advice-giver into an expert who thinks like your best senior engineer.

You'll learn:

- How to compress information (keep 90% of the signal at 50% of the tokens)
- How to structure context for clarity (assembly line analogy)
- How to inject just-in-time examples (show, don't tell)
- How to build context that evolves as your agent learns

---

## Key Terminology

| Term | Definition | DevOps Parallel |
|------|-----------|-----------------|
| **Token** | Discrete unit of text (word, subword, or symbol) that the model processes | Atomic unit of work, like a process or transaction |
| **Tokenization** | Process of breaking text into tokens | Parsing a YAML manifest into API objects |
| **Prefill Phase** | Model reads all input in parallel, building understanding | `terraform plan` — understand full config before acting |
| **Decode Phase** | Model generates output one token at a time, sequentially | `terraform apply` — execute changes in sequence |
| **Attention Map** | Web of connections between tokens showing which relate to which | Call graph showing which functions call which |
| **Attention Weight** | Strength of connection between two tokens | Network latency or bandwidth between two services |
| **TTFT** | Time to First Token — delay before response starts appearing | Time to first result in a long-running query |
| **Context Window** | Maximum number of tokens in a single request | Container memory limit or available heap |
| **Prefill Latency** | Time to complete prefill phase (drives TTFT) | Time to plan a Terraform apply |
| **Decode Latency** | Time to complete decode phase (scales with output length) | Time to actually apply Terraform changes |
| **Temperature** | Parameter controlling output variation (0=deterministic, 1+=creative) | Runaway condition threshold or alert sensitivity dial |
| **Input Cost** | Tokens you provide to the model | Request bandwidth or input volume to an API |
| **Output Cost** | Tokens the model generates | Response bandwidth or output from a function |
| **Throughput** | Tokens generated per second during decode | Requests per second or operations per second |
| **Context Engineering** | Art of building rich, selective context for accurate reasoning | Infrastructure provisioning — right-sizing for the workload |

---

## Summary

You now understand what happens inside an LLM from input to output. You know why TTFT scales with input size, why agents are slower than single queries, why temperature matters for deterministic work, and how to right-size your context and model.

Most importantly, you've internalized a fundamental principle: **LLMs are deterministic machines with clear input-output characteristics, just different from the systems you've built before.**

You don't treat servers as magic boxes. You measure, profile, and optimize them. Apply the same discipline to LLMs. Measure your input tokens and output tokens. Profile your TTFT. Optimize your context for clarity and efficiency.

In Module 06, you'll learn context engineering — the skill that transforms generic AI into domain-specific expertise. You'll learn to build context that activates the model's understanding and chains your expertise into its reasoning.

Then in Module 07, we'll move from understanding the engine to building with it — creating the first real agents.
