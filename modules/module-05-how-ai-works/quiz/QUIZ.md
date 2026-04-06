# Module 05 Quiz — How AI Actually Works: The Engine Under the Hood

**Estimated time:** 12 minutes
**Format:** 8 questions, multiple choice
**Passing score:** 75% (6/8 correct)

---

### Question 1

**You send a 50,000-token prompt (system prompt + context + question) to Claude Sonnet. The model takes 3 seconds before streaming the first word of output, then streams 500 words in 8 seconds. Which phase accounts for most of the 3-second delay?**

A) Tokenization — the model is breaking your text into tokens

B) Prefill — the model is reading all 50,000 input tokens in parallel to understand the context

C) Decode — the model is still thinking about how to start the response

D) Network latency — the API server is slow

<details>
<summary>Answer</summary>

**B) Prefill — the model is reading all 50,000 input tokens in parallel to understand the context**

The Prefill phase reads your entire input and scales with input size. The 3-second delay before first output (TTFT) is almost entirely from Prefill. Tokenization is instant. Decode happens after you see the first word. Network latency is typically <200ms. This is why context engineering (keeping context small and relevant) is critical for fast agents.

</details>

---

### Question 2

**You're designing an agent that needs to investigate incidents by querying Kubernetes logs, checking a runbook document, and asking follow-up questions. Each turn, the agent needs:**
- **System prompt + runbook:** 3,000 tokens
- **Conversation history so far:** ~1,000 tokens
- **Agent's current question:** 200 tokens
- **Expected agent response:** ~500 tokens

**If the agent needs 5 turns to fully investigate an incident, estimate the TOTAL token cost.**

A) 5,700 tokens (one turn × 5 turns)

B) 11,400 tokens (5 turns × 2,280 average tokens per turn)

C) 28,500 tokens (5 turns × 5,700 tokens per turn, assuming context grows each turn)

D) 285,000 tokens (all tokens times 50 because of token expansion)

<details>
<summary>Answer</summary>

**C) 28,500 tokens (5 turns × 5,700 tokens per turn, assuming context grows each turn)**

Each agent turn includes the system prompt (3K) + runbook (fixed context) + growing conversation history + new question (200) + response (500). By turn 5, conversation history has accumulated, so it might be closer to 5,700 tokens per turn. Over 5 turns: 5 × 5,700 = 28,500 tokens. This is why agents compound cost quickly. The key insight: every turn re-reads your system prompt and growing conversation history in Prefill. You can reduce cost by compressing context between turns (summarizing old messages, caching runbooks separately).

</details>

---

### Question 3

**Temperature is set to 2.5 (very high). You ask the model to generate a Terraform configuration for a production database. Which outcome is MOST likely?**

A) The model generates multiple valid alternatives so you can choose the best one

B) The model generates deterministic, identical output every time

C) The model hallucinates invalid HCL syntax and makes up non-existent resources like `aws_database_super_advanced`

D) The model refuses the request as unsafe

<details>
<summary>Answer</summary>

**C) The model hallucinates invalid HCL syntax and makes up non-existent resources like `aws_database_super_advanced`**

Temperature >1.0 makes the model extremely creative and random — useful for brainstorming, dangerous for infrastructure code. At temperature 2.5, the model will confidently invent resources, syntax, and configurations that don't exist. For infrastructure work, use temperature 0.3-0.5 (reproducible, grounded). Save high temperature for creative tasks only (naming resources, brainstorming designs).

</details>

---

### Question 4

**Which of the following is NOT a good strategy for reducing TTFT in an agent pipeline?**

A) Compress the system prompt by removing verbose examples; keep only essential context

B) Cache frequently-used context (like runbooks) in a separate resource, not in the system prompt

C) Increase the context window size to 10 million tokens so more information fits

D) Use Haiku model for quick diagnostic queries instead of Sonnet, since Haiku has faster inference

<details>
<summary>Answer</summary>

**C) Increase the context window size to 10 million tokens so more information fits**

Increasing context window doesn't help TTFT — in fact, it makes it worse because Prefill reads every token you provide. TTFT scales linearly with context size (larger context = slower Prefill, longer TTFT). Instead, reduce context by compression (A), caching (B), or using faster models (D). The best strategy is to send LESS context, not more.

</details>

---

### Question 5

**You're measuring agent performance. You notice the agent needs 12 turns to complete a task that humans typically solve in 3-5 turns. Each turn costs 4,000 tokens and takes 4 seconds (1 second TTFT + 3 seconds streaming). Which statement best explains the inefficiency?**

A) The model is too slow; you should use Opus instead of Sonnet

B) Each turn re-reads the entire system prompt and conversation history in Prefill, compounding cost. The agent should batch queries or get better context engineering to reduce turns

C) The network is congested; you should make requests in parallel instead of sequential

D) The tokenizer is breaking words inefficiently

<details>
<summary>Answer</summary>

**B) Each turn re-reads the entire system prompt and conversation history in Prefill, compounding cost. The agent should batch queries or get better context engineering to reduce turns**

This is a classic agent pipeline problem. The 12 turns vs. expected 3-5 suggests the agent is inefficient. Every turn re-reads all previous context in Prefill, so more turns = exponentially higher cost. Solution: improve the prompt so the agent gathers more information per turn, ask broader questions upfront, or inject more operational context so the agent doesn't need clarifying questions. Cost-wise: 12 turns × 4K tokens = 48K tokens total. At 3-5 turns: 12-20K tokens. Reducing turns is the key lever.

</details>

---

### Question 6

**You have two agent designs. Both answer the same question, but:**

**Design A:** 3,000 input tokens (focused prompt + minimal context), 2 turns, 1 second TTFT, costs $0.01
**Design B:** 50,000 input tokens (comprehensive context + detailed runbook), 1 turn, 4 seconds TTFT, costs $0.015

**Which design is better for a production incident response agent that needs to act FAST?**

A) Design A, because fewer tokens mean faster TTFT and lower cost

B) Design B, because 1 turn is better than 2 turns (less back-and-forth)

C) They're equivalent; just pick the cheaper one

D) Design B, because more context means better accuracy and fewer errors

<details>
<summary>Answer</summary>

**A) Design A, because fewer tokens mean faster TTFT and lower cost**

In incident response, speed matters. Design A has 1 second TTFT vs. Design B's 4 seconds—a 4x difference. Even though Design A needs 2 turns, each turn is so fast that the total time is still faster than Design B's single slow turn. Plus Design A costs less. The trade-off: Design A's responses might be less comprehensive, so the follow-up turn might catch issues. But for fast incident triage, smaller + faster contexts beat comprehensive + slow contexts. Context engineering (focused design) beats exhaustive context.

</details>

---

### Question 7

**You're designing a system where agents frequently run the same query (e.g., "What does our production runbook say about database high-memory alerts?"). Which approach best reduces cumulative token cost over 100 query runs?**

A) Use temperature 0.0 so responses are deterministic and cacheable

B) Cache the runbook as a separate resource (MCP resource or external API) that the agent queries once, not in the system prompt

C) Use a faster model like Haiku to speed up inference

D) Compress the runbook text to remove whitespace

<details>
<summary>Answer</summary>

**B) Cache the runbook as a separate resource (MCP resource or external API) that the agent queries once, not in the system prompt**

Caching is the most powerful cost lever. If you embed the runbook in the system prompt, every one of 100 queries re-reads it in Prefill (100 × 1,000 tokens = 100K tokens wasted). If you make it a cached MCP resource or external tool, the agent queries it once when needed, then reuses the results. Over 100 runs, caching saves ~90K tokens. Temperature (A) doesn't affect token cost. Haiku (C) helps but pales compared to caching. Text compression (D) helps marginally. Caching is the structural win.

</details>

---

### Question 8

**According to the module explainer, the DevOps analogy for Prefill vs. Decode is:**

A) Prefill is like reading a dashboard; Decode is like executing a kubectl command

B) Prefill is like reading an entire email before replying; Decode is like typing the response word by word

C) Prefill is like compiling code; Decode is like running the executable

D) Prefill is like planning an incident response; Decode is like executing the runbook steps

<details>
<summary>Answer</summary>

**B) Prefill is like reading an entire email before replying; Decode is like typing the response word by word**

This metaphor directly parallels the model's behavior. Prefill reads all input tokens in one batch (like reading an email top-to-bottom). Decode generates output sequentially (like typing one word at a time). The email analogy is intentional because it highlights the asymmetry: reading time (Prefill) scales with input size; reply time (Decode) scales with output length. This is why large contexts cause TTFT delays but don't directly cause slow streaming.

</details>

---

## Answer Summary

| Question | Correct | Key Concept |
|----------|---------|------------|
| 1 | B | TTFT dominated by Prefill |
| 2 | C | Agent cost compounds with turns |
| 3 | C | High temperature → hallucinations |
| 4 | C | More context = slower Prefill |
| 5 | B | Too many turns signals poor context engineering |
| 6 | A | Speed and cost beat comprehensiveness |
| 7 | B | Caching is the best cost lever |
| 8 | B | Email analogy for Prefill/Decode |

---

## Reflection Questions (Optional)

After completing the quiz, consider:

1. **Which design decision surprised you?** (e.g., that caching beats exhaustive context)
2. **How would you apply token budgeting to your own agent projects?**
3. **What's one agent pipeline you've seen that could be optimized for faster TTFT?**
