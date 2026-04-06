# Module 05 — Explainer Notes

> **Delivery format:** 14 diagrams (10 Excalidraw + 4 Gemini illustrations), presented sequentially.
> Each diagram = one concept beat. Use for live whiteboard delivery or Udemy video segments.
>
> **Naming convention:** `01-title-card.excalidraw` through `14-what-you-now-know.excalidraw`
> **Style:** Black & white, hand-drawn (Excalidraw sketchy), outlines only — no fills, no colors.
> **Gemini illustrations:** 4 visual metaphor illustrations generated via Gemini image generator, same B&W style.
> See `diagrams/GEMINI-BRIEFS.md` for generation prompts.
>
> **Tool split:**
> | Diagram | Tool | Why |
> |---------|------|-----|
> | 1, 2, 5, 6, 8, 10, 11, 12, 13, 14 | Excalidraw | Pipeline flows, architectures, comparisons, timelines |
> | 3, 4, 7, 9 | Gemini illustration | Visual metaphors, scenes, whimsical sketches |

---

## Diagram 1: Title Card — How AI Actually Works: The Engine Under the Hood

**File:** `diagrams/01-title-card.excalidraw`
**Tool:** Excalidraw
**Duration:** ~2 minutes

**Visual layout:**
- Title: "How AI Actually Works"
- Subtitle: "The Engine Under the Hood"
- Below: Driving analogy visual — a simple car with the hood propped open, a mechanic figure peering inside
- Bottom annotation: "Pillar 2: Agentic Engineering — From Passenger to Mechanic"
- Small text: "Module 05 of 20"

**Narrator notes:**

Welcome to Module 05 — and welcome to Pillar 2.

In Pillar 1, you were the Passenger. You used AI tools — typed questions, got answers, connected MCP servers, ran cross-platform queries. You experienced what AI can do for you. And that's valuable! You now have a working lab, connected tools, and proof that your domain expertise makes the difference.

But here's the thing: a passenger doesn't know WHY the car slows down on a hill, or WHY the engine revs higher when you floor it. A mechanic does. And starting today, we're opening the hood.

This module answers the question every technical person eventually asks: "What actually happens when I type something into Claude or ChatGPT?" We're not going to get into the math — no linear algebra, no gradient descent. Instead, we'll trace the full journey of your input through the AI system, using analogies you already understand from infrastructure work.

By the end of this explainer, you'll understand why some queries take longer than others, why context matters so much, why agents can be slow, and — critically — how to make better decisions about what goes into your context and what stays out. This is the foundation for everything you build in Pillar 2.

---

## Diagram 2: The Full Journey — What Happens When You Press Enter

**File:** `diagrams/02-full-journey.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Title: "What Happens When You Press Enter"
- Horizontal pipeline flow, left to right:
  - Box 1: "Your Input" (question + context) with size annotation "~500 tokens"
  - Arrow →
  - Box 2: "Tokenizer" — breaks text into tokens
  - Arrow →
  - Box 3: "Prefill Phase" — reads ALL tokens at once (labeled "parallel, like batch processing")
  - Arrow →
  - Box 4: "Decode Phase" — generates tokens one at a time (labeled "sequential, like streaming")
  - Arrow →
  - Box 5: "Your Output" (the response)
- Below the pipeline: timeline bar showing durations
  - Tokenization: "~instant"
  - Prefill: "1-5 seconds (depends on input size)"
  - Decode: "5-60 seconds (depends on output length)"
- Annotation: "The pause before the first word? That's Prefill. The streaming after? That's Decode."

**Narrator notes:**

Here's the full journey. When you type a question in Claude or ChatGPT and hit enter, five things happen in sequence. Let's trace each one.

First, your input — the question you typed, plus any context (your CLAUDE.md, system prompt, conversation history) — gets packaged up. This might be 500 tokens for a simple question or 50,000 tokens if you've loaded a big context.

Next, the **Tokenizer** breaks your text into tokens. We covered this in Module 02 — tokens are the atomic units that the model works with. This happens almost instantly.

Then comes the **Prefill Phase**. This is where the model reads your ENTIRE input — every single token — in one parallel pass. Think of it as reading an entire email before replying. The model builds up its understanding of what you've asked. This is what causes the pause after you press Enter but before you see any output.

After Prefill, the **Decode Phase** begins. This is where the model generates its response, one token at a time. Each new token depends on every token that came before it — the input AND all previously generated output tokens. This is why you see the text streaming in word by word, not appearing all at once.

Here's the key insight for DevOps: the Prefill time scales with your INPUT size. More context = longer pause. The Decode time scales with the OUTPUT length. Longer response = longer streaming. This directly impacts how you design agent interactions — which we'll get to in the lab.

---

## Diagram 3: Reading the Email Before Replying

**File:** `diagrams/03-reading-email.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- Split scene:
  - Left: A stick figure sitting at a desk, reading a long email (email has visible text lines scrolling down). Caption: "Prefill: Reading the entire email"
  - Right: Same figure, now typing a reply. Caption: "Decode: Typing the response, word by word"
- Below: Clock showing time — "The longer the email, the longer to read it. But the reply speed doesn't change."
- Annotation: "That's why TTFT (Time to First Token) depends on input size, not output size."

**Narrator notes:**

Here's the analogy that makes Prefill and Decode click.

Imagine you get an email from a colleague. It's a detailed incident report — five paragraphs of context, log snippets, timeline, affected services. Before you can type a single word of reply, you need to READ the entire email. The longer the email, the longer it takes to read.

That's Prefill. The model is reading your entire input before generating any output. And just like reading, it's proportional to the length. A short question? Sub-second Prefill. A massive context with thousands of tokens? Could be several seconds.

Once you've read the email, you start typing your reply. Each word you type comes one after another — you can't type the conclusion before the introduction. But your typing speed is pretty constant regardless of how long the email was.

That's Decode. The model generates tokens one at a time, at a roughly constant speed, regardless of how big the input was.

This is why you experience that characteristic pause before the first word appears — that's TTFT, Time to First Token. It's the model finishing Prefill. Once that first token appears, the rest streams in at a steady pace. And now you know why loading a 100K-token context makes the initial response slower — you gave the model a longer email to read.

---

## Diagram 4: Terraform Plan/Apply — The DevOps Parallel

**File:** `diagrams/04-terraform-parallel.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- Two parallel pipelines stacked vertically:
  - Top: "Terraform Workflow" — `terraform plan` (reads all .tf files, builds dependency graph) → `terraform apply` (executes changes one by one)
  - Bottom: "AI Processing" — "Prefill" (reads all tokens, builds understanding) → "Decode" (generates response token by token)
- Arrows showing the parallel:
  - `terraform plan` ↔ "Prefill" — both read everything first, both are parallel, both get slower with more files/tokens
  - `terraform apply` ↔ "Decode" — both execute sequentially, both depend on what was planned/understood
- Caption: "Plan before apply. Read before write. Same pattern, different domain."

**Narrator notes:**

Let me map this to something you run every day.

`terraform plan` reads ALL your .tf files, resolves all variables, builds the dependency graph, and computes what changes need to be made. You can't skip Plan. You can't plan half the files. It reads everything before it tells you anything.

That's exactly what Prefill does. The model reads ALL your tokens, resolves all the relationships between words, builds its understanding, and computes its internal representation. You can't skip Prefill. You can't prefill half the context.

Then `terraform apply` executes the changes one resource at a time, in dependency order. Each resource depends on the ones before it. You can't create the EC2 instance before the VPC is ready.

That's Decode. Each token depends on all the tokens before it — both the input and the previously generated output. The model can't write the conclusion before the introduction.

Here's where this gets practical. When you load a massive CLAUDE.md plus 50 files into your context, you're giving Terraform a huge state file to plan against. The plan takes longer. Same thing — Prefill takes longer with more context. That's not a bug. That's the model doing its job: reading everything before writing anything.

The question for context engineering becomes: what SHOULD be in the plan? Just like you wouldn't dump your entire AWS account into one Terraform state file, you shouldn't dump everything into your AI context. We'll explore this balance in Module 06.

---

## Diagram 5: Prefill Deep Dive — Parallel Processing

**File:** `diagrams/05-prefill-deepdive.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Title: "Prefill Phase — Parallel Processing"
- Top: Input text shown as a sequence of token boxes: [The] [server] [is] [returning] [503] [errors] [after] [the] [latest] [deployment]
- Below: "Attention Mechanism" — visual showing every token connecting to every other token with lines (like a mesh network)
  - Specific highlighted connections: "503" ↔ "errors" (strong), "deployment" ↔ "server" (strong), "after" ↔ "latest" (medium)
- Key insight box: "All tokens processed simultaneously. Like a GPU rendering — all pixels at once."
- Below: Scaling chart:
  - 100 tokens: ~0.1s Prefill
  - 1,000 tokens: ~0.3s Prefill
  - 10,000 tokens: ~1.5s Prefill
  - 100,000 tokens: ~5-10s Prefill
- Annotation: "Prefill scales with input size. This is why context budgeting matters."

**Narrator notes:**

Let's go deeper into Prefill because this is where the performance implications live.

During Prefill, the model processes ALL your input tokens simultaneously. Not one by one — all at once, in parallel. This is possible because the input is already known — it's your text, sitting there waiting to be read.

The mechanism that makes this work is called Attention. Every token looks at every other token to understand relationships. "503" connects strongly to "errors." "Deployment" connects to "server." "After" connects to "latest." The model builds a web of relationships across your entire input.

Think of it like GPU rendering. When your GPU renders a frame, it computes all pixels in parallel. It doesn't start at the top-left corner and work its way across. Same idea — Prefill processes all tokens in parallel because they're all available at once.

Now, here's the performance chart that matters to you. 100 tokens? Prefill takes about a tenth of a second — you won't even notice. 1,000 tokens? A third of a second. Still fast. 10,000 tokens — that's a decent CLAUDE.md plus some conversation? About 1.5 seconds. 100,000 tokens — a massive context with documentation, code files, and conversation history? Could be 5 to 10 seconds. That's a noticeable pause.

This is why context budgeting — choosing what goes into your context and what stays out — is a real engineering discipline. Every token you add to your context makes Prefill slower. In Module 06, we'll learn to be deliberate about what earns a place in the context window.

---

## Diagram 6: Decode Deep Dive — Sequential Generation

**File:** `diagrams/06-decode-deepdive.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Title: "Decode Phase — Sequential Token Generation"
- Horizontal timeline showing tokens appearing one by one:
  - Step 1: [The] ← generated from input context
  - Step 2: [The] [pod] ← "pod" depends on "The" + all input tokens
  - Step 3: [The] [pod] [is] ← "is" depends on "The", "pod" + all input tokens
  - Step 4: [The] [pod] [is] [crash] [loop] [ing] ← each token depends on ALL previous
- Arrow showing dependency: "Each new token reads everything before it"
- Speed metric: "~50-100 tokens/second (varies by model and provider)"
- Side note: "This is why streaming exists — you see tokens as they're generated, not waiting for the full response"
- Bottom comparison: "Prefill = batch job (parallel) | Decode = streaming pipeline (sequential)"

**Narrator notes:**

Decode is where the response gets generated, and it works completely differently from Prefill.

Each token is generated one at a time, sequentially. To generate token 2, the model needs token 1. To generate token 3, it needs tokens 1 and 2. And so on. Each new token depends on the entire input PLUS all previously generated tokens. You can't parallelize this — it's inherently sequential.

The speed? Roughly 50 to 100 tokens per second for current models, depending on the provider and model size. That means a 500-token response takes about 5-10 seconds of decoding time.

This is why streaming exists. Instead of waiting for the entire response to be generated (which could take 30+ seconds for a long answer), the client shows you each token as it's generated. That's the typing effect you see in Claude and ChatGPT.

Here's the DevOps parallel: Prefill is a batch job. It takes a fixed input, processes it all at once, and produces a result. Decode is a streaming pipeline. Each stage depends on the previous stage's output. You can't skip ahead.

And here's the implication for agents: when an agent makes multiple tool calls in sequence — call kubectl, get result, call PostgreSQL, get result, generate analysis — each step involves a new Decode phase. The agent generates the tool call, waits for the result, then Prefills the result and Decodes the next step. Understanding this pipeline helps you design efficient agent workflows in later modules.

---

## Diagram 7: The Assembly Line — How Tokens Build Understanding

**File:** `diagrams/07-assembly-line.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- A factory assembly line scene:
  - Left: Raw materials (words) entering on a conveyor belt
  - Station 1: "Tokenizer" — worker at a chopping station breaking words into pieces
  - Station 2: "Embedding" — worker assigning numbers/coordinates to each piece
  - Station 3: "Attention Layers" (multiple workers at a long table, each connecting pieces to other pieces)
  - Station 4: "Output" — finished tokens coming off the line, one at a time
- Caption: "Each token passes through ~100 transformer layers. Like a 100-stage assembly line where each stage adds understanding."
- Small note: "You don't need to understand each stage. Just know: more stages = deeper understanding = bigger model."

**Narrator notes:**

Let me give you a visual mental model for what happens inside the model.

Picture a factory assembly line. Raw text comes in on the left. First station: the Tokenizer. Workers chop the text into token-sized pieces. "CrashLoopBackOff" might become three tokens: "Crash", "Loop", "Back", "Off" — each gets its own slot on the conveyor.

Second station: Embedding. Each token gets converted from text into numbers — a vector of coordinates that captures its meaning. "Server" and "instance" end up near each other in this number space because they mean similar things. "503" and "error" are nearby too. This is how the model understands that these concepts are related.

Third station — and this is the big one: Attention Layers. Imagine a long table with 100 workers. Token passes through each worker, and at every stage, each worker looks at ALL the other tokens to update its understanding. After 100 stages, a token that started as just the word "deployment" now carries rich context: it knows it's connected to "server", "503", "latest", and "after." It understands the RELATIONSHIP, not just the word.

Final station: the output token rolls off the assembly line, fully informed by everything that came before.

You don't need to remember the details of each station. The key insight is: more layers means deeper understanding, which means a bigger model. Claude Sonnet has fewer layers than Claude Opus. That's why Opus reasons more deeply — it has a longer assembly line.

---

## Diagram 8: TTFT — Why There's a Pause

**File:** `diagrams/08-ttft-explained.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Title: "TTFT — Time to First Token"
- Timeline visualization:
  - User presses Enter at t=0
  - Bracket: "Tokenization" (~instant, barely visible)
  - Bracket: "Prefill" (visible duration, labeled "1-5 seconds for typical agent context")
  - Marker: "TTFT — First token appears here" (bold marker on timeline)
  - Bracket: "Decode" (tokens streaming in, shown as dots appearing one by one)
  - End: "Complete response"
- Below: Two comparison scenarios:
  - Scenario A: "Short question (100 tokens)" — tiny Prefill bar, fast TTFT
  - Scenario B: "Agent with full context (50,000 tokens)" — large Prefill bar, slow TTFT
- Annotation: "Same model, same infrastructure. Different TTFT because of input size."
- Key takeaway: "When your agent feels slow, check your context size first."

**Narrator notes:**

Let's talk about that pause you've noticed. You ask your AI agent a question. There's a delay — maybe 1 second, maybe 5 seconds — before you see the first word. Then suddenly text starts streaming in at a steady rate.

That delay is TTFT: Time to First Token. It's the time from when you press Enter to when the first output token appears. And now you know exactly what's happening during that pause — Prefill. The model is reading your entire input before writing its first word.

Here's why this matters for agent design. Compare two scenarios. Scenario A: you ask a simple question with minimal context — maybe 100 tokens total. Prefill takes a fraction of a second. TTFT is nearly instant.

Scenario B: your agent has a loaded context — CLAUDE.md, system prompt, conversation history, tool results from MCP calls, maybe some code files. 50,000 tokens. Prefill might take 3-5 seconds. That's a noticeable wait before you see anything.

Same model. Same infrastructure. The difference is input size.

This is the first concrete lesson for context engineering: every token you add to your context increases TTFT. That doesn't mean "keep context small" — it means be intentional about what you include. In Module 06, we'll learn to budget context like you budget compute resources. But first, you need to understand why the budget matters. Now you do.

When your agent feels slow, the first thing to check isn't the model or the provider — it's how much context you're loading.

---

## Diagram 9: Context Window as RAM — There's a Ceiling

**File:** `diagrams/09-context-as-ram.png`
**Tool:** Gemini illustration
**Duration:** ~3 minutes

**Visual layout:**
- A server rack with a memory module prominently displayed
- The memory module is labeled "Context Window" with capacity markings:
  - 8K slot (small, labeled "GPT-3.5 era")
  - 32K slot (medium, labeled "Early 2024")
  - 128K-200K slot (large, labeled "Claude Sonnet / GPT-4o")
  - 1M slot (massive, labeled "Gemini 1.5 Pro")
- Below the rack: a container analogy
  - Container with memory limit: "If you exceed the limit, you get OOMKilled"
  - Context window: "If you exceed the limit, old tokens get dropped or the request fails"
- Side annotation: "More RAM ≠ better performance. More context ≠ better answers."
- Bottom: "The sweet spot: enough context for the task, not everything you have."

**Narrator notes:**

You set memory limits on your containers, right? 512MB, 1GB, 2GB — based on the workload. You don't set every container to the maximum just because you can. Because more memory means more resource consumption, slower garbage collection, and wasted capacity.

The context window works the same way. It's the total amount of text the model can process in a single interaction — input AND output combined. Claude Sonnet gives you 200,000 tokens. Gemini gives you up to a million. These are impressive numbers.

But here's the thing every DevOps engineer understands intuitively: more capacity doesn't mean better performance. Loading 200,000 tokens into the context window just because you CAN is like setting every container to 16GB of RAM just because you have the memory available. It's wasteful and it actually degrades performance.

Why? Two reasons. First, Prefill time scales with context size — we just covered that. More tokens = slower TTFT. Second, attention has limits. When the model looks at 200,000 tokens, important information can get diluted in the noise. Research shows that models pay less attention to information in the middle of very long contexts — they focus on the beginning and the end.

The sweet spot isn't "maximum context." It's "right-sized context." Enough to give the model what it needs for this specific task, and nothing more. Just like you'd right-size your container memory based on the workload.

In Module 06, we'll build a systematic approach to context budgeting. For now, just internalize the parallel: context window = RAM. More isn't always better. Right-sized is always better.

---

## Diagram 10: Temperature — The Creativity vs Consistency Dial

**File:** `diagrams/10-temperature-dial.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Title: "Temperature — Your Creativity/Consistency Dial"
- Center: A large dial/knob visualization:
  - Far left (0.0): "Deterministic" — same input → same output every time
  - Low (0.1-0.3): "Precise" — labeled "DevOps sweet spot: Terraform, configs, investigations"
  - Medium (0.5-0.7): "Balanced" — labeled "Documentation, explanations, analysis"
  - High (0.8-1.0): "Creative" — labeled "Brainstorming, marketing, fiction"
  - Far right (1.5+): "Chaotic" — labeled "Here be dragons"
- Below: Two example outputs for same prompt ("Generate a K8s deployment"):
  - Temperature 0.1: "Standard, predictable YAML — correct every time"
  - Temperature 1.0: "Creative variable names, unusual approaches — sometimes brilliant, sometimes broken"
- Annotation: "For infrastructure work, low temperature = reliable. For brainstorming, higher = diverse ideas."

**Narrator notes:**

Temperature is the setting most people misunderstand. Let me explain it through something you already know: randomness in infrastructure.

When you run `terraform plan`, you want deterministic results. Same input, same plan, every time. Zero randomness. That's temperature 0 — the model picks the most probable next token every single time.

When you're brainstorming architecture options, you WANT some variety. You don't want the same three suggestions every time. That's higher temperature — the model occasionally picks less probable tokens, leading to more diverse and creative outputs.

For DevOps work, your sweet spot is low temperature — 0.1 to 0.3. When you're generating Terraform configs, Kubernetes manifests, CI/CD pipelines, or incident analysis, you want reliable and predictable output. You don't want "creative" YAML.

Medium temperature — 0.5 to 0.7 — works well for documentation, explanations, and analysis. You want clarity and accuracy, but with natural-sounding language.

High temperature — 0.8 and above — is for brainstorming, creative writing, and exploring unusual ideas. Great for the "Brainstorm" phase of Superpowers (Module 07), risky for the "Blueprint" phase.

The practical takeaway: most AI coding agents default to a sensible temperature for code and infrastructure work. You usually don't need to adjust it. But when you're getting outputs that feel too repetitive, bump it up slightly. When you're getting outputs that feel unreliable, check if temperature is too high. It's a knob, not a switch.

---

## Diagram 11: Why Agents Are Slow — The Multi-Turn Pipeline

**File:** `diagrams/11-agent-pipeline.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Title: "Why Agents Are Slower Than Chat"
- Two pipelines compared:
  - **Simple Chat** (top):
    - [Your question] → Prefill → Decode → [Answer]
    - Total: 1 Prefill + 1 Decode cycle
  - **Agent with Tool Calls** (bottom):
    - [Your question] → Prefill → Decode → [Tool Call: kubectl]
    - → Wait for tool response → Prefill (input + tool result) → Decode → [Tool Call: psql]
    - → Wait for tool response → Prefill (input + ALL tool results) → Decode → [Final Analysis]
    - Total: 3 Prefill + 3 Decode cycles + 2 tool execution waits
- Time breakdown:
  - Chat: ~5 seconds total
  - Agent: ~20-40 seconds total (3× Prefill + 3× Decode + tool latency)
- Key insight: "Each tool call = new Prefill/Decode cycle. Context GROWS with each turn."
- Annotation: "Now you know why your cross-platform MCP query in M04 took longer than a simple question."

**Narrator notes:**

Remember in Module 04, when you ran that cross-platform query across kubectl and PostgreSQL? It took noticeably longer than a simple question. Now you know exactly why.

A simple chat interaction is one Prefill-Decode cycle. You ask, the model reads (Prefill), and the model responds (Decode). Maybe 5 seconds total.

An agent making tool calls is MULTIPLE Prefill-Decode cycles. Here's what happens under the hood: You ask your question. The model Prefills your input, then Decodes a tool call — "I need to check kubectl." It calls the tool, gets the result. Now it has to Prefill AGAIN — but this time the input is bigger because it includes the original question PLUS the tool result. Then it Decodes another tool call — "Now I need to check PostgreSQL." Tool executes, result comes back. Prefill AGAIN — now with the original question, the kubectl result, AND the PostgreSQL result. Then finally Decodes the analysis.

That's three Prefill-Decode cycles, plus the time waiting for tools to execute. And notice: each Prefill is LARGER than the last because the context is growing with each tool result.

This is why agents are slower than chat. It's not a bug — it's the fundamental cost of multi-step reasoning with tool use. And it's why context engineering matters even more for agents than for chat. Every unnecessary token in your context gets re-processed on every turn. If your CLAUDE.md has 5,000 tokens of boilerplate that isn't relevant to this query, that boilerplate gets Prefilled three times instead of once.

Understanding this pipeline is what separates someone who uses agents from someone who designs efficient agents. We'll apply this knowledge when building agent workflows in Modules 07 through 09.

---

## Diagram 12: Model Sizes — Choosing the Right Engine

**File:** `diagrams/12-model-sizes.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Title: "Choosing the Right Engine"
- Three vehicle comparison (horizontal):
  - **Haiku (Motorcycle):** Fast, cheap, lightweight
    - Best for: classification, simple extraction, high-volume tasks
    - Speed: ████████░░ (fast)
    - Quality: ████░░░░░░ (good enough)
    - Cost: ██░░░░░░░░ (cheap)
  - **Sonnet (Sedan):** Balanced, versatile, daily driver
    - Best for: code generation, analysis, agent workflows, most DevOps work
    - Speed: ██████░░░░ (moderate)
    - Quality: ████████░░ (high)
    - Cost: ████░░░░░░ (moderate)
  - **Opus (Truck):** Powerful, expensive, heavy lifting
    - Best for: complex reasoning, novel problems, architecture decisions
    - Speed: ████░░░░░░ (slower)
    - Quality: ██████████ (highest)
    - Cost: ████████░░ (expensive)
- Bottom: "The right model depends on the task, not the budget."
- DevOps parallel: "You don't deploy every service on the largest instance. Same principle."

**Narrator notes:**

Not every job needs the biggest engine. You already know this from infrastructure — you don't run every microservice on a c5.4xlarge. You right-size based on the workload.

AI models work the same way. The three tiers — let's use Claude's lineup as the example — are like three vehicles.

**Haiku** is the motorcycle. It's fast, lightweight, and cheap. Great for simple, high-volume tasks: classifying log entries, extracting structured data from text, answering straightforward questions. It won't write you a perfect Terraform module, but it'll parse 10,000 log lines in seconds.

**Sonnet** is the sedan. It's your daily driver. Balanced speed, quality, and cost. This is what you'll use for most agent workflows: code generation, incident analysis, infrastructure review, documentation. Claude Code defaults to Sonnet for a reason — it handles 90% of DevOps work at a good speed-to-quality ratio.

**Opus** is the truck. Slower and more expensive, but it handles heavy loads. Complex architectural decisions, novel problems the model hasn't seen patterns for, multi-step reasoning chains. When Sonnet's output isn't quite right and you need deeper thinking, you bring in Opus.

The practical rule: start with Sonnet. If the output quality isn't sufficient, try Opus. If you need speed and the task is simple, drop to Haiku. This is exactly the same decision framework you use for compute resources — right-size for the workload, scale up only when needed.

For our labs, we'll primarily use Sonnet via Claude Code. It's the sweet spot for hands-on infrastructure work.

---

## Diagram 13: The Implications — What This Means for Context Engineering

**File:** `diagrams/13-implications-context-eng.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Title: "What This Means for You"
- Four insight boxes arranged vertically:
  - Insight 1: "Context Size → TTFT" — bigger context = longer wait. "Budget your tokens."
  - Insight 2: "Each Agent Turn → Re-Prefill" — tool call results grow the context. "Keep tool outputs focused."
  - Insight 3: "Model Choice → Speed vs Quality" — right-size the model. "Sonnet for daily work, Opus for heavy lifting."
  - Insight 4: "Temperature → Reliability" — low for infra, medium for docs. "Match the knob to the task."
- Center: Arrow pointing to "Module 06: Context Engineering" — "This is where we turn understanding into practice."
- Bottom: "You now know HOW the engine works. Next: how to drive it efficiently."

**Narrator notes:**

Let's connect everything back to your day-to-day work. Four practical implications.

First: context size affects TTFT. Every token you add to your context makes the initial response slower. This isn't a reason to minimize context — it's a reason to be INTENTIONAL about it. Include what the model needs. Exclude what it doesn't. Budget your tokens like you budget compute.

Second: each agent turn re-Prefills everything. When your agent makes three tool calls, your context gets Prefilled three times — and it grows each time with tool results. This means verbose tool outputs cost you triple. When you're designing agent workflows, think about what tool results actually need to be in the context and what can be summarized.

Third: model choice is a speed-quality tradeoff. Don't default to the biggest model. Default to Sonnet for daily work. Escalate to Opus when the reasoning quality matters. Drop to Haiku for high-volume simple tasks. Right-size the model like you right-size instances.

Fourth: temperature controls reliability. For infrastructure work — configs, manifests, pipelines — keep it low. For brainstorming and exploration, bump it up. Match the knob to the task.

These four insights are the foundation for Module 06: Context Engineering. Now that you understand HOW the engine processes context, we can talk about WHAT context to feed it. The Mechanic understands the engine. The Driver uses that understanding to drive efficiently.

---

## Diagram 14: Pillar 2 Journey — What You Now Know

**File:** `diagrams/14-what-you-now-know.excalidraw`
**Tool:** Excalidraw
**Duration:** ~2 minutes

**Visual layout:**
- Title: "Module 05 Complete — The Engine Makes Sense"
- Left: Updated journey timeline:
  - M01: "Lab setup + Trinity" ✓
  - M02: "AI Foundations + domain expertise" ✓
  - M03: "Platform AI + capability gaps" ✓
  - M04: "MCP + cross-platform queries" ✓
  - M05: "How AI works — the engine" ✓ (highlighted, "YOU ARE HERE")
  - M06: "Context Engineering" → (preview, dashed)
  - M07: "Superpowers Workflow" → (preview, dashed)
- Right: "Your Mental Model" — simplified version of the full pipeline:
  - Input → Tokenize → Prefill (parallel, scales with input) → Decode (sequential, scales with output) → Response
  - With labels: "The pause = Prefill. The streaming = Decode. Context size = TTFT."
- Bottom: "Next → Module 06: Context Engineering — THE core skill of this course"
- Caption: "The Mechanic now understands the engine. Time to learn to DRIVE it."

**Narrator notes:**

Module 05 is complete. Let's see what you now carry forward.

You came into this module as a Passenger who'd used AI tools successfully. You leave as a Mechanic who understands the engine. You know that when you press Enter, your input gets tokenized, Prefilled in parallel, and then the response gets Decoded sequentially. You know why there's a pause before the first token. You know why agents are slower than chat. You know why context size matters.

This mental model is going to serve you for the rest of the course — and beyond. Every time you wonder "why is this agent slow?", you'll think: "How big is the context? How many tool calls is it making? Each call is another Prefill cycle." Every time you design an agent workflow, you'll think: "What's the minimum context this agent needs to do its job well?"

That's the Mechanic mindset. Understanding the machinery so you can use it effectively.

Next up: Module 06 — Context Engineering. This is THE core skill of the entire course. Now that you understand how the model processes context, we'll learn how to engineer the right context for the right task. You'll build a CLAUDE.md for your reference app, design system prompts, and see the dramatic quality difference between minimal and optimized context. Everything you build in Pillar 2 and Pillar 3 depends on what you learn in Module 06.

The engine makes sense. Time to learn to drive it.

---

## Diagram Sequence Summary

| # | File | Concept Beat | Duration | Udemy Segment |
|---|------|-------------|----------|---------------|
| 1 | 01-title-card | Pillar 2 intro, Passenger → Mechanic | ~2 min | Video 1: "Opening the Hood" (1+2 = ~6 min) |
| 2 | 02-full-journey | Full processing pipeline overview | ~4 min | |
| 3 | 03-reading-email | Prefill/Decode analogy (reading vs typing) | ~2 min | Video 2: "Prefill & Decode" (3+4 = ~4 min) |
| 4 | 04-terraform-parallel | terraform plan/apply parallel | ~2 min | |
| 5 | 05-prefill-deepdive | Parallel processing, attention, scaling | ~4 min | Video 3: "Inside Prefill" (5+6 = ~7 min) |
| 6 | 06-decode-deepdive | Sequential generation, streaming | ~3 min | |
| 7 | 07-assembly-line | Factory analogy for transformer layers | ~2 min | Video 4: "The Assembly Line" (7+8 = ~5 min) |
| 8 | 08-ttft-explained | TTFT, why context size → latency | ~3 min | |
| 9 | 09-context-as-ram | Context window = container memory | ~3 min | Video 5: "Context as RAM" (9+10 = ~6 min) |
| 10 | 10-temperature-dial | Temperature for DevOps work | ~3 min | |
| 11 | 11-agent-pipeline | Multi-turn agent pipeline, why agents are slow | ~4 min | Video 6: "Agent Pipeline" (11+12 = ~7 min) |
| 12 | 12-model-sizes | Haiku/Sonnet/Opus right-sizing | ~3 min | |
| 13 | 13-implications-context-eng | Four practical takeaways | ~3 min | Video 7: "Implications + Wrap-Up" (13+14 = ~5 min) |
| 14 | 14-what-you-now-know | Module summary, bridge to M06 | ~2 min | |

**Total explainer time:** ~40 minutes (7 Udemy videos, 4-7 min each)

---

## Usage Notes

### Live Workshop Delivery

1. Present diagrams 1-4 as opening sequence (~10 min) — set the Pillar 2 context, establish the pipeline metaphor
2. Break for questions after diagram 4 (the terraform plan/apply parallel usually generates good discussion)
3. Present diagrams 5-8 as the technical deep dive (~14 min) — Prefill, Decode, assembly line, TTFT
4. Quick show of hands: "Who's noticed the TTFT pause in their work?" (connects to M04 lab experience)
5. Present diagrams 9-12 as practical implications (~12 min) — RAM analogy, temperature, agent pipeline, model sizes
6. Present diagrams 13-14 as wrap-up and bridge (~5 min)
7. Transition to interactive exercise (lab)

### Udemy Self-Paced Flow

1. Videos 1-2: "Opening the Hood" + "Prefill & Decode" (~10 min)
2. Videos 3-4: "Inside Prefill" + "The Assembly Line" (~12 min)
3. Videos 5-6: "Context as RAM" + "Agent Pipeline" (~13 min)
4. Video 7: "Implications + Wrap-Up" (~5 min)
5. Reading: concepts.md for deeper standalone study
6. Interactive exercise (lab)
7. Quiz
