# Module 02 — Exploratory Projects

> These are optional stretch exercises for participants who finish the lab early
> or want to go deeper. Each is self-contained and can be done independently.

---

## Project 1: Context Engineering for a Different Data Source (~30 min)

**Goal:** Apply the 4-layer context engineering approach to a different infrastructure data source and observe the quality delta between Layer 1 and Layer 4.

**Instructions:**

1. Choose one of these data sources (or use one from your own environment):
   - **RDS Performance Insights:** Query a slow-query event (e.g., a query spending 80% of DB time on full table scans)
   - **VPC Flow Logs:** Analyze a spike in rejected connections (e.g., security group blocking legitimate traffic)
   - **Prometheus/KIND Cluster:** Alert on high memory usage in a workload namespace

2. Build a context template following the 4-layer model:
   - **Layer 1:** The raw alert/event alone (e.g., "High memory usage in default namespace")
   - **Layer 2:** Add metric history (last 24 hours of memory trend, recent spikes)
   - **Layer 3:** Add infrastructure context (which pods are affected, which services depend on them, recent deployments)
   - **Layer 4:** Add operational knowledge (normal baseline for this namespace, runbook steps, cost implications, related tickets)

3. Using Claude Code or Crush, send Layer 1 context to the model and ask it to diagnose the issue. Document the response quality and specificity.

4. Send the same issue with Layer 4 context and compare.

**Deliverable:**

A markdown document (`CONTEXT_ENGINEERING_[SOURCE].md`) containing:
- Structured context template for all 4 layers
- Layer 1 response (raw, generic diagnosis)
- Layer 4 response (specific, actionable)
- Your analysis: What information in Layers 2-4 unlocked the quality improvement? How would this change your team's incident response process?

---

## Project 2: Token Budget Calculator (~20 min)

**Goal:** Build a cost comparison tool to understand how context engineering affects monthly spend across different LLM providers.

**Instructions:**

1. Create a table or spreadsheet with these providers and models:
   - Claude 3.5 Sonnet ($3/M input, $15/M output)
   - Google Gemini 2.5 Flash ($0.075/M input, $0.30/M output)
   - Groq Llama 3.1 8B ($0 cost, or fixed hourly rate if applicable)

2. For each provider, estimate token costs at three context layers:
   - **Layer 1:** Alarm event only (~250 input tokens, ~150 output tokens per invocation)
   - **Layer 3:** Alarm + metric history + topology (~1,500 input tokens, ~200 output tokens)
   - **Layer 4:** Full context with runbooks, baselines, recent changes (~3,000 input tokens, ~250 output tokens)

3. Model a realistic scenario: **100 daily alarm invocations** across all three layers. Calculate:
   - Cost per invocation (input + output)
   - Cost per day
   - Cost per month (30 days)
   - Monthly cost at each quality tier

4. Document assumptions (e.g., "Layer 4 output is 67% longer because richer context prompts more detailed responses").

**Deliverable:**

A markdown table or linked spreadsheet (`TOKEN_BUDGET.md` or `TOKEN_BUDGET.xlsx`) showing:
- Per-provider, per-layer monthly costs
- A summary identifying the cheapest provider for each quality tier
- Your recommendation: Which provider-layer combination maximizes quality per dollar for DevOps incident triage?

---

## Project 3: Few-Shot Example Library (~25 min)

**Goal:** Build a reusable library of few-shot examples for alarm diagnosis and test it against a novel scenario.

**Instructions:**

1. Write 3-5 few-shot examples for incident diagnosis. Each example should follow this structure:

   ```
   ## Example N: [Scenario Title]

   **Situation:** [How the alarm was triggered, metric value, service context]

   **Evidence Reviewed:**
   - [Service dependency map]
   - [Metric history / baseline comparison]
   - [Recent deployments / config changes]

   **Initial Hypothesis:** [What the model might guess]

   **Supporting Evidence:** [What narrowed it down]

   **Recommended Action:** [Specific remediation step]

   **Escalation Decision:** [When/whether to page on-call]
   ```

2. Use examples from the Module 02 lab (e.g., the CPU spike scenario, the deployment-related issue, etc.) or craft realistic scenarios from your own experience.

3. Embed this few-shot library in a Layer 4 context template (as a "Recent Similar Incidents" section).

4. Test the library against a novel alarm scenario (one you didn't include in the examples):
   - Submit it WITHOUT few-shot examples (Layer 4 context only)
   - Submit it WITH few-shot examples included
   - Compare response format consistency, diagnostic reasoning, and specificity

**Deliverable:**

A markdown file (`FEW_SHOT_LIBRARY.md`) containing:
- The 3-5 few-shot examples, properly formatted
- A test case (novel alarm scenario)
- Response comparison: with vs without examples
- Your observation: How much did the few-shot examples improve consistency and reasoning quality?

---

## Project 4: Model Comparison (~20 min)

**Goal:** Compare response quality, specificity, and incident-triage fitness across two different LLM providers.

**Instructions:**

1. Pick two providers (e.g., Claude via Claude Code and Gemini 2.5 Flash via Crush, or two different open-source models via Groq and HuggingFace).

2. Use a Layer 4 context template and a realistic alarm scenario from the lab (or your own environment). Keep the context and prompt identical across both providers.

3. Submit the same request to both models. Document:
   - **Response time** (how long each took)
   - **Response length** (token count or word count)
   - **Diagnostic specificity** (does it name the root cause or stay generic?)
   - **Actionable recommendations** (can you directly follow the suggested steps?)
   - **Format consistency** (does it match your expected structure?)
   - **Reasoning clarity** (does it explain WHY it reached that diagnosis?)

4. Based on your comparison, assess which model is better suited for incident triage in a DevOps context and why.

**Deliverable:**

A markdown document (`MODEL_COMPARISON.md`) containing:
- The shared context and prompt
- Response A (Provider 1) in full
- Response B (Provider 2) in full
- A comparison table (Response Time, Specificity, Actionability, Format, Reasoning)
- Your assessment: Which model won, and for what types of incidents would you prefer each?

---

## Project 5: Context Architecture for Your Real Environment (~30 min)

**Goal:** Design a production-ready context template for one of your actual operational domains, ready to use on Day 1 back at work.

**Instructions:**

1. Choose one operational domain from your actual production environment:
   - Incident response and root-cause diagnosis
   - Deployment validation and canary analysis
   - Cost optimization and resource right-sizing
   - Capacity planning and forecasting
   - Security posture assessment or compliance checking

2. Build a 4-layer context template using real data:
   - **Layer 1:** The core signal (e.g., a real alert template, deployment log, or cost spike)
   - **Layer 2:** Your actual metric baselines, thresholds, and SLOs
   - **Layer 3:** Your real service topology (how services actually talk to each other), team ownership, oncall schedules
   - **Layer 4:** Your operational runbooks, escalation procedures, approved remediation steps, compliance constraints, cost budgets

3. Use real names, real baselines, real constraint language. This should be something you can literally paste into Claude Code or Crush on your first day back and start using.

4. Test Layer 1 vs Layer 4 against one real scenario (or a realistic simulation) and document the difference in output quality.

**Deliverable:**

A markdown or YAML file (`PROD_CONTEXT_TEMPLATE_[DOMAIN].md`) containing:
- Fully populated 4-layer context template
- One test case (real or realistic)
- Layer 1 response (generic, limited to public knowledge)
- Layer 4 response (specific to your environment)
- A brief action plan: How will you integrate this into your team's workflow? Who needs to review it before deployment?

---
