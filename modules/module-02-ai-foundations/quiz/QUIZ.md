# Module 02 — Quiz

**Duration:** ~15 minutes
**Format:** 7 questions — mix of multiple choice, short answer, and scenario-based

---

## Question 1: Tokenization Estimation

An alarm notification contains the following CloudWatch event (approximately 800 characters of JSON):

```json
{
  "AlarmName": "prod-api-cpu-high",
  "StateValue": "ALARM",
  "NewStateReason": "Threshold Crossed: 1 datapoint [89.2 (05/04/26 14:32:00 UTC)] was greater than the threshold (85.0).",
  "StateChangeTime": "2026-04-05T14:35:00Z",
  "Region": "us-east-1",
  "AlarmArn": "arn:aws:cloudwatch:us-east-1:123456789012:alarm:prod-api-cpu-high",
  "OldStateValue": "OK",
  "Trigger": {"MetricName": "CPUUtilization", "Namespace": "AWS/EC2", "Statistic": "Average"}
}
```

Based on the rule of thumb that JSON tokenizes at approximately 3-4 characters per token, how many tokens would you estimate this alarm requires?

a) ~50 tokens
b) ~150 tokens
c) ~200-250 tokens
d) ~500 tokens

<details>
<summary>Answer</summary>

**c) ~200-250 tokens**

JSON is structured text with many special characters (braces, colons, quotes, commas), which tokenize less efficiently than plain text. At 3-4 characters per token, an 800-character JSON payload requires roughly 200-270 tokens. This is the typical cost of a single alarm notification in Layer 1 context. Understanding token density is critical when estimating how many alarms fit in your context window before hitting capacity limits.

</details>

---

## Question 2: Context Window Overflow Scenario

You're building an incident diagnostic agent. It processes 100 CloudWatch alarms simultaneously, each approximately 3,650 tokens when formatted with their metric history and related logs. The agent uses Claude Sonnet 4.6, which has a 200,000 token context window.

What happens when you attempt to submit all 100 alarms in a single request?

a) The API automatically truncates alarms to fit the context window
b) The request succeeds but response quality degrades significantly
c) The request fails because 365,000 tokens exceeds the 200K context limit
d) The agent queues requests sequentially instead of in parallel

<details>
<summary>Answer</summary>

**c) The request fails because 365,000 tokens exceeds the 200K context limit**

100 alarms × 3,650 tokens = 365,000 tokens total, which far exceeds Claude's 200,000 token window. The API rejects the request with a context length error. This is why batching and streaming are essential patterns in agentic DevOps systems. You must either process alarms in smaller batches (e.g., 50 at a time) or implement a triage layer that filters to high-severity incidents before sending to the reasoning model.

</details>

---

## Question 3: Inference Cost Asymmetry

Why does the input (prefill) phase of an LLM typically cost 3-5 times less than the output (decode) phase, per token?

a) Larger batch sizes are possible during prefill
b) Prefill is highly parallelizable; decode is sequential—one token at a time
c) Output tokens require additional safety filtering, increasing compute
d) Input compression algorithms reduce input token count

<details>
<summary>Answer</summary>

**b) Prefill is highly parallelizable; decode is sequential—one token at a time**

During the prefill phase, the model processes all input tokens in parallel on GPU hardware. During decode, the model generates one output token at a time and must attend over the entire context—this is memory-bound and sequential. As a result, providers charge $3/M tokens for input and $15/M for output (5x difference). This cost structure incentivizes: concise input context, shorter expected outputs, and batching multiple requests to amortize parallelism gains.

</details>

---

## Question 4: Context Engineering vs Prompt Engineering

You are tasked with improving the quality of an AI system's incident response recommendations. You can either:

a) Write more detailed, creative prompts with better phrasing
b) Restructure the information provided—add topology, baselines, runbooks, recent deployments
c) Increase the model temperature setting for more creative responses
d) Use a larger, more expensive LLM model

Which change will have the biggest impact on recommendation quality?

<details>
<summary>Answer</summary>

**b) Restructure the information provided—add topology, baselines, runbooks, recent deployments**

Context engineering (what information the model sees and in what structure) drives quality far more than prompt engineering (how you phrase the request). A small model with rich, well-organized context outperforms a large model given vague context. Clever phrasing, temperature tuning, and model size are secondary. The foundational insight of this course is that operational expertise encoded as structured context beats prompt tricks every time.

</details>

---

## Question 5: Quality Jump in the 4-Layer Lab

In the 4-layer context engineering exercise from the lab, where is the biggest improvement in diagnostic quality?

Describe what changes between Layer 2 and Layer 3 that makes such a difference.

<details>
<summary>Answer</summary>

**Layer 2→3: Adding Infrastructure Topology and Service Dependency Map**

Layer 2 contains only the alarm itself (generic). Layer 3 adds the infrastructure topology—which services depend on the failing component, what runs upstream and downstream, and which services are likely impacted. This shift from "I see a high-CPU alarm" to "I see a high-CPU alarm on the API service, which is called by the web frontend and calls the database" is transformative. The model moves from abstract diagnosis to concrete, actionable insight rooted in your specific system. This is context engineering in action: the same model, same prompt, but vastly more useful output because it now understands YOUR infrastructure, not generic CPU issues.

</details>

---

## Question 6: Token Economics Calculation

Your team receives approximately 500 alarms per day. Each alarm, when formatted in Layer 4 context (infrastructure topology, recent deployments, runbook, full metric history), requires 1,000 input tokens. Using Claude 3.5 Sonnet pricing ($3 per million input tokens), calculate the approximate daily cost.

Show your work.

<details>
<summary>Answer</summary>

**Approximately $1.50 per day**

**Calculation:**
500 alarms/day × 1,000 input tokens/alarm = 500,000 tokens/day
500,000 tokens × ($3 / 1,000,000 tokens) = $1.50/day

At scale (500 alarms daily), an AI-assisted incident triage system costs roughly $1.50/day or ~$45/month. This makes the business case clear: a single prevented incident (MTTR reduction, avoided cascading failures) pays for months of AI assistance. Token budgeting is a practical DevOps skill—understanding these numbers helps you justify agentic investment and design systems that stay within cost targets.

</details>

---

## Question 7: AI Spectrum Classification

Which classification best describes a system that automatically detects a pod failure in Kubernetes, diagnoses the root cause (checking recent deployments, node resources, and image pull errors), queries the runbook for remediation steps, and restarts the pod if safe?

a) Chat—interactive question-answering
b) Copilot—suggesting actions for human approval
c) Agent—autonomous reasoning and action
d) Squad—multi-model ensemble system

<details>
<summary>Answer</summary>

**c) Agent—autonomous reasoning and action**

This system is an agent: it perceives state (pod failure), reasons about causes (diagnostics), selects actions (remediation), and executes autonomously (pod restart). It does not wait for human approval (ruling out Copilot) and is not just an interactive assistant (ruling out Chat). A Squad would be multiple specialized agents working together, not a single decision loop. Recognizing the AI spectrum helps you design systems at the right level—agents are appropriate for well-bounded operational tasks with clear success metrics and low blast radius.

</details>

---
