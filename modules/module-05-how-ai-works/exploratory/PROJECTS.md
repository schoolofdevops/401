# Module 05 — Exploratory Projects

> These are optional stretch exercises for participants who finish the lab early
> or want to go deeper. Each is self-contained and can be done independently.

---

## Project 1: Token Budget Calculator — Build Your Cost Estimator

**Goal:** Build a spreadsheet or simple script that calculates token costs for different agent scenarios.

**Estimated time:** 40 minutes

**Why this matters:**

Token budgets are how DevOps engineers think about agent cost — similar to how you think about pod resource limits or API rate limits. A quick calculator helps you estimate whether an agent design is economical before building it. This becomes your team's tool for "Can we afford this agent?"

**Hints:**

- Start with a spreadsheet (Google Sheets, Excel, or CSV + Python pandas)
- Use real model pricing from Anthropic docs (as of April 2026)
- Build separate sections for system prompt, context injection, conversation history, and output
- Add a "number of turns" slider to see how cost compounds

**Instructions:**

1. **Create a token cost calculator** with these inputs:
   - **System prompt:** Size in tokens (e.g., 800)
   - **Injected context:** Size in tokens (e.g., runbooks, documentation)
   - **Average input per turn:** Tokens per user query (e.g., 200)
   - **Average output per turn:** Tokens per agent response (e.g., 500)
   - **Number of turns:** How many back-and-forths? (e.g., 5)
   - **Model choice:** Haiku, Sonnet, or Opus (different pricing)

2. **Calculate:**
   ```
   Per-turn cost = (system_prompt + context + avg_input + avg_output) tokens
   Total cost = per_turn_cost × num_turns × (price per 1M tokens)
   ```

3. **Add scenarios:**
   - Incident investigation (5 turns, 50K context)
   - Quick diagnostic (2 turns, 5K context)
   - Long-running agent (20 turns, growing context)

4. **Compare trade-offs:**
   - What if I compress context by 50%? → Cost drops by _?_
   - What if I use Haiku instead of Sonnet? → Cost drops by _?_
   - What if I batch queries to reduce turns from 5 to 2? → Cost drops by _?_

**Success criteria:**

- Calculator produces estimates that match module 05 formulas
- You've modeled 3+ realistic scenarios from your infrastructure
- Scenarios show how compression, model choice, and turn count impact cost
- Another team member can use it without explanation

**Reflection:**

*Design trade-off:* "Which matters more for your team — speed (TTFT) or cost? If you had to choose one optimization, what would it be?"

---

## Project 2: TTFT Benchmark Across Models and Providers

**Goal:** Systematically measure Time-to-First-Token (TTFT) across different models and LLM providers to understand what affects latency.

**Estimated time:** 50 minutes

**Why this matters:**

TTFT determines how quickly your agent feels responsive. Benchmarking across models and context sizes teaches you where the bottleneck is (Prefill or network). This data informs whether to use Haiku for speed or Sonnet for quality, and whether your context is bloated.

**Hints:**

- Use a simple test: send a context of known size + a simple question + measure time to first token
- Test at 3 context sizes: small (5K), medium (50K), large (100K+)
- Use the Anthropic API directly (curl or Python) to measure raw latency, not UI delays
- Capture: model name, context size, provider, TTFT (seconds), tokens/second in Decode phase

**Instructions:**

1. **Set up testing infrastructure:**
   - Create a test script in Python or Bash that sends requests to multiple providers
   - Log: timestamp, model, context size, TTFT, tokens/second, total tokens
   - Test against: Claude Sonnet, Claude Haiku (different tiers)
   - Optional: Google Gemini free tier (for multi-provider comparison)

2. **Design your context payloads:**
   - **Small context:** 5K tokens (system prompt + brief runbook)
   - **Medium context:** 50K tokens (system prompt + detailed runbook + conversation history)
   - **Large context:** 100K+ tokens (comprehensive documentation + logs + conversation)

3. **Run benchmarks:**
   - Make 5 requests at each context size and model combination
   - Measure TTFT for each (time from request sent to first token received)
   - Calculate average and standard deviation
   - Record any errors or timeouts

4. **Create a comparison table:**
   ```markdown
   | Model | Context Size | Avg TTFT (ms) | Std Dev | Tokens/sec | Notes |
   |-------|--------------|--------------|---------|-----------|-------|
   | Sonnet | 5K | 1200 | 180 | 35 | Consistent, fast |
   | Sonnet | 50K | 1800 | 250 | 32 | Linear scaling |
   | Sonnet | 100K | 2600 | 400 | 30 | Starting to slow |
   | Haiku | 5K | 800 | 150 | 40 | Fastest for small context |
   | ... | ... | ... | ... | ... | ... |
   ```

5. **Analyze:**
   - Does TTFT scale linearly with context size? (If yes, Prefill is the bottleneck)
   - Is there a "breaking point" where TTFT jumps? (e.g., >80K context)
   - Do different models scale differently? (Haiku faster for small, Sonnet better for large?)
   - What's the optimal context size for your typical queries?

**Success criteria:**

- You've tested at least 3 context sizes × 2 models = 6 scenarios
- Data shows clear TTFT trends
- You can explain why one model/context combo is faster than another
- Results could inform your team's agent design decisions

**Reflection:**

*Design trade-off:* "Based on these benchmarks, what's your 'TTFT budget' for incident response? If you need to respond in <2 seconds, what context size can you afford?"

---

## Project 3: Context Window Utilization Experiment — Lost in the Middle

**Goal:** Test how model behavior degrades when context approaches the window limit, and explore the "lost in the middle" effect where information buried in the middle of context is harder to retrieve.

**Estimated time:** 45 minutes

**Why this matters:**

AI models don't weight all context equally. Information at the beginning and end of context is retrieved reliably; information in the middle is often "lost." This affects how you structure context for agents — it matters WHERE you put critical information. This project reveals the pattern and teaches you how to design better context.

**Hints:**

- Create a simple test: embed a specific fact (like a rule or config detail) at different positions in the context (10%, 50%, 90%)
- Ask the model to retrieve that fact in a follow-up question
- Measure: accuracy of retrieval at each position
- Hypothesis: retrieval accuracy drops at 50% vs. 10% and 90%

**Instructions:**

1. **Design your test context:**
   - Create a "runbook" document with a critical rule buried at different positions
   - Example rule: "If memory > 85%, do NOT restart the pod; scale horizontally instead"
   - Create 3 versions of the runbook:
     - **Version A:** Rule at 10% into the document (early)
     - **Version B:** Rule at 50% into the document (middle)
     - **Version C:** Rule at 90% into the document (late)

2. **Pad context to near-limit:**
   - Fill each version with realistic supporting content (other rules, examples, caveats)
   - Aim for 150K-180K tokens total (close to window limit, but safe)
   - Ensure all three versions are exactly the same length

3. **Run the experiment:**
   - For each version, ask a follow-up question: "If a pod is at 85% memory, what should I do?"
   - Model should cite the buried rule in its response
   - Run 5 times per version to check consistency
   - Record: Did it find the rule? Verbatim or paraphrased? Confident or uncertain?

4. **Measure context utilization:**
   - At what % of context window does performance degrade?
   - Test at 50%, 75%, 90%, 95% utilization
   - Chart: utilization % vs. accuracy of fact retrieval

5. **Analyze the "lost in the middle" effect:**
   - Graph your results showing accuracy at different positions (10%, 50%, 90%)
   - Note: if accuracy drops at 50%, you have the "lost in the middle" effect
   - This affects agent design: put critical facts at the START of context, not middle

**Success criteria:**

- You've tested 3 positions × 5 runs = 15 queries
- You can show a clear pattern (if one exists)
- You understand WHERE to place critical information in your agent's context
- Results explain why "context order matters"

**Reflection:**

*Design trade-off:* "If you have 3 critical pieces of context (system rules, recent logs, deployment history), in what order should you present them to the model? Why?"

---

## Project 4: Agent Pipeline Optimizer — Design for Efficiency

**Goal:** Take a multi-turn agent interaction from Module 04 (or your own scenario) and redesign it to minimize agent turns and context growth.

**Estimated time:** 45 minutes

**Why this matters:**

Agent cost and latency compound with each turn. An agent that needs 10 turns costs 2-3x as much as one that does the same task in 3 turns. This project teaches you to recognize inefficient agent patterns and redesign for efficiency — a core skill in agentic DevOps.

**Hints:**

- Pick a real scenario from Lab 04 or your incident response process
- Trace through a typical agent interaction: How many turns does it take? What context is repeated?
- Look for: questions the agent asks that could be preempted, context injected late that should be early, follow-up clarifications
- Redesign the prompt to gather more information per turn

**Instructions:**

1. **Choose a scenario** (from Module 04 lab or your own):
   - Example: "Agent investigates a pod memory spike. Currently 8 turns."
   - Example: "Agent generates Terraform config. Currently 6 turns."
   - Or use a real incident from your team

2. **Map the current agent flow:**
   ```markdown
   Turn 1: User asks the question
   Turn 2: Agent responds, asks clarifying question A
   Turn 3: User answers A; agent asks question B
   Turn 4: User answers B; agent asks question C
   ... (repeat until done)
   Turn 8: Agent provides final answer

   Total: 8 turns, ~32K tokens (4K per turn × 8)
   ```

3. **Identify inefficiencies:**
   - [ ] Does the agent ask questions you could preempt in the initial prompt?
   - [ ] Is context injected too late (should be in system prompt)?
   - [ ] Are there follow-up questions that could be batched into one turn?
   - [ ] Is the model response too verbose (could it be more concise)?

4. **Redesign the prompt:**
   - Inject preemptive context (runbook, team constraints, typical failure modes)
   - Ask a broader initial question that gathers multiple pieces of info at once
   - Example: Instead of "What's the issue?", ask "Describe the issue, what changed recently, and what's the SLA?"

5. **Estimate the new flow:**
   ```markdown
   Turn 1: User provides comprehensive initial context
   Turn 2: Agent responds with analysis and asks one targeted follow-up
   Turn 3: User answers; agent provides final recommendation

   Total: 3 turns, ~12K tokens (4K per turn × 3)

   Savings: 8 → 3 turns (62% reduction), 32K → 12K tokens (63% cost reduction)
   ```

6. **Document the redesign:**
   - Before: agent flow, turn count, token cost, TTFT
   - After: redesigned agent flow, turn count, token cost, TTFT
   - Why each change reduces turns (preemptive context, batched questions, etc.)

**Success criteria:**

- You've reduced the original agent's turn count by at least 30%
- Redesigned prompt is specific and actionable (not just "gather more info")
- Cost and TTFT estimates show concrete improvements
- Another engineer could implement your redesign without help

**Reflection:**

*Design trade-off:* "There's a trade-off between brevity and clarity. Your redesigned prompt bundles more info into one turn, but does the model actually answer better? Would you use this redesign, or stick with the slower version for safety?"

---

## Hints for All Projects

- **Use real data:** Base calculations on actual model pricing and benchmarks from Anthropic docs
- **Document assumptions:** "I assumed Sonnet costs $X/1M tokens" so others can adjust
- **Iterate:** Start simple (one scenario), then add complexity
- **Share:** Bring your results to the team; they often spot patterns you missed

---

## Reflection Questions for All Projects

After completing your project, consider:

1. **What surprised you most about token costs / TTFT / context behavior?**
2. **How would you apply this learning to your current agent projects?**
3. **What's one decision (model choice, context size, turn count) you'd make differently?**
