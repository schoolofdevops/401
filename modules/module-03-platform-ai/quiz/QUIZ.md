# Module 03 Quiz — Platform AI: Features Already in Your Stack

**Estimated time:** 10 minutes
**Format:** 8 questions, multiple choice
**Passing score:** 75% (6/8 correct)

---

### Question 1

**CloudWatch Anomaly Detection learns your metric's normal pattern over 2 weeks. When your metric breaks out of the normal band, it fires an alarm. What happens next?**

A) The agent automatically executes your runbook steps based on the alert type

B) CloudWatch correlates the anomaly with recent deployments and suggests a fix

C) The alarm fires, sending an SNS notification — but investigation and remediation are still manual

D) CloudWatch queries your team's Slack history to find the root cause context

<details>
<summary>Answer</summary>

**C) The alarm fires, sending an SNS notification — but investigation and remediation are still manual**

CloudWatch Anomaly Detection handles detection only. It identifies that something is unusual and sends the alert. Everything beyond the alert — cross-referencing with deployments, investigating root cause, deciding on remediation, and executing fixes — remains manual work. This is the core of the "Platform AI Gap" that custom agents are designed to fill.

</details>

---

### Question 2

**You're reviewing the Capabilities Matrix from the module. Which statement is TRUE?**

A) All platform AI features (CloudWatch, Cost Explorer, Q Developer, DevOps Guru) excel at investigation and can suggest remediation

B) CloudWatch Anomaly Detection detects problems, DevOps Guru partially investigates through metric correlation, but none of these tools take action or know your operational context

C) Q Developer can test suggested IaC changes against your live infrastructure environment before recommending them

D) Grafana Sift can follow your custom runbooks and automatically execute remediation based on alert type

<details>
<summary>Answer</summary>

**B) CloudWatch Anomaly Detection detects problems, DevOps Guru partially investigates through metric correlation, but none of these tools take action or know your operational context**

The Capabilities Matrix shows a clear pattern: platform AI excels at detection. Some tools (like DevOps Guru) partially handle investigation through metric correlation. But none take action, and none know your specific context — your architecture, SLAs, runbooks, naming conventions, or team constraints. Custom agents are built to fill this gap by combining detection capability with investigation, action, and context.

</details>

---

### Question 3

**According to the module, what is the Platform AI Gap?**

A) The difference in cost between using free-tier tools and paying for enterprise observability platforms

B) The space between what platform AI can do (detect, partially investigate) and what you need at 3am (investigation, action, context)

C) The latency delay between when CloudWatch collects a metric and when an anomaly alert is triggered

D) The missing features that you can only fix by switching to a different cloud provider

<details>
<summary>Answer</summary>

**B) The space between what platform AI can do (detect, partially investigate) and what you need at 3am (investigation, action, remediation, context)**

The Platform AI Gap is the core concept of this module. Platform AI (CloudWatch, Cost Explorer, Q Developer, etc.) lives on the "detection" floor. But at 3am, you need investigation (why did this happen?), action (what do we do?), and context (how does this fit our architecture and constraints?). Custom agents — built in later modules — bridge this gap by combining detection with investigation, action, and your operational context encoded in SKILL.md files.

</details>

---

### Question 4

**Q Developer can review your Terraform and spot missing encryption settings. But it can't do several things. Which is NOT a limitation of Q Developer as a platform AI tool?**

A) It doesn't know your organization's approved AMI list or naming conventions

B) It can't query your live AWS infrastructure to check current state

C) It analyzes code and spot generic security issues in IAM policies

D) It can't test the generated IaC against your specific environment before you deploy

<details>
<summary>Answer</summary>

**C) It analyzes code and spot generic security issues in IAM policies**

This is what Q Developer can do — it's one of its strengths. The other three (A, B, D) are all real limitations. Q Developer can't know your specific conventions, can't access live infrastructure state, and can't test against your environment. These limitations exist because Q Developer operates without your operational context. When you combine Q Developer with context engineering (providing your architecture, constraints, and conventions), you extend its effectiveness. This is the bridge from platform AI to custom agents.

</details>

---

### Question 5

**According to the module, platform AI features fall into four categories. Which description correctly matches the category to its ceiling?**

A) Cost Intelligence tools can explain why your spending changed month-over-month, even when deployment timings don't align with cost changes

B) Cross-Service Correlation tools (like DevOps Guru) can find relationships between service anomalies but can't execute remediation or access non-cloud data

C) Anomaly Detection tools learn baselines and alert when deviations occur, and they can automatically follow your runbooks to diagnose issues

D) Code Assistance tools can deploy your generated IaC and test it against your environment without manual review

<details>
<summary>Answer</summary>

**B) Cross-Service Correlation tools (like DevOps Guru) can find relationships between service anomalies but can't execute remediation or access non-cloud data**

This correctly identifies both the capability and the ceiling. DevOps Guru is the most sophisticated platform AI feature — it can correlate metrics across services (e.g., "Lambda errors correlate with DynamoDB throttling"). That's genuinely useful. But it stops there. It can't execute a fix, and it's limited to data within its single platform. The other options incorrectly claim that platform AI features can do things they cannot (explanations beyond their data, runbook following, live testing).

</details>

---

### Question 6

**You're designing a custom agent to handle cost anomalies. The agent needs to bridge the gap that Cost Explorer leaves open. What context should you encode in the agent's SKILL.md file so it can actually explain spending changes?**

A) Only the cost threshold above which to alert, since Cost Explorer already provides month-over-month trends

B) Historical baselines for each environment, deployment timing patterns, and which services typically spike on certain days (e.g., staging runs 9-5)

C) The exact AWS API calls needed to fetch Cost Explorer data, so the agent can make its own queries

D) A hardcoded list of all possible cost drivers, so the agent can pattern-match against them

<details>
<summary>Answer</summary>

**B) Historical baselines for each environment, deployment timing patterns, and which services typically spike on certain days (e.g., staging runs 9-5)**

This is the core principle of context engineering applied to a custom agent. Cost Explorer shows you trends, but it can't explain them without operational context. By encoding baselines, deployment schedules, and environment-specific patterns in SKILL.md, you give the agent the domain knowledge to explain changes. This is what transforms a platform AI tool (which shows numbers) into a custom agent (which explains what those numbers mean in YOUR context).

</details>

---

### Question 7

**The module illustrates three approaches to handling a production incident (CPU spike): manual response (45 min), platform AI (15 min), and custom agent (3 min). What is the primary difference that makes the custom agent so much faster?**

A) The custom agent has faster network access to your infrastructure than manual engineers

B) The custom agent's context is encoded in SKILL.md and runbooks, so it follows a structured decision tree instead of relying on human memory

C) The custom agent uses different monitoring tools that have lower latency than CloudWatch

D) Custom agents can execute fixes without any safety guardrails, so they don't need verification steps

<details>
<summary>Answer</summary>

**B) The custom agent's context is encoded in SKILL.md and runbooks, so it follows a structured decision tree instead of relying on human memory**

Speed comes from automation and context. The manual engineer has all the context in their head (which metrics to check, which deployments might be relevant, what the runbook says) — that takes time to recall and cross-reference. Platform AI handles detection but the engineer still has to do investigation manually. The custom agent is fast because the context isn't in anyone's head — it's encoded in SKILL.md, runbooks, and tool integrations. The agent follows a structured decision tree every time, consistently and quickly. This is why context engineering (Module 06) and SKILL.md (Module 12) are so foundational.

</details>

---

### Question 8

**The module connects platform AI to a multi-pillar course structure. Platform AI is Pillar 1 (Augmented DevOps). What is Pillar 2's role in the journey toward custom agents?**

A) Pillar 2 replaces platform AI features entirely, so you don't need to understand what you're replacing

B) Pillar 2 (Agentic Engineering) teaches context engineering, harnesses, IaC, skills, and tools — the foundational techniques that make custom agents effective in Pillar 3

C) Pillar 2 is optional for teams that already have platform AI features enabled

D) Pillar 2 teaches you to use open-source alternatives to avoid cloud vendor lock-in

<details>
<summary>Answer</summary>

**B) Pillar 2 (Agentic Engineering) teaches context engineering, harnesses, IaC, skills, and tools — the foundational techniques that make custom agents effective in Pillar 3**

Pillar 2 is the bridge. It's where you learn to structure information for AI (context engineering), build workflows (harnesses), apply AI to infrastructure (IaC), and encode expertise (SKILL.md and tools). None of this is optional — every technique in Pillar 2 makes the agents you build in Pillar 3 more powerful. The gap analysis you complete in Module 03 (what platform AI can't do) becomes your requirements list for what you'll build using Pillar 2 techniques in Pillar 3. Platform AI isn't being replaced — it's being extended and integrated with custom agents.

</details>

---

## Answer Key Summary

| Question | Correct Answer | Concept Area |
|----------|---|---|
| 1 | C | Platform AI ceiling: detection only |
| 2 | B | Capabilities Matrix (detect vs investigate vs act) |
| 3 | B | Platform AI Gap definition |
| 4 | C | Q Developer capabilities and limitations |
| 5 | B | Platform AI by category (ceiling for each) |
| 6 | B | Context engineering connection to custom agents |
| 7 | B | Why custom agents are faster: encoded context and decision trees |
| 8 | B | Three-pillar structure: P1 (platform), P2 (engineering), P3 (agents) |

---

## Scoring Guide

- **7-8 correct:** Excellent understanding of platform AI capabilities, gaps, and the path forward
- **6 correct:** Solid grasp of core concepts; consider reviewing the Capabilities Matrix and Platform AI Gap sections
- **5 or fewer:** Review the explainer (especially diagrams 5, 7, and 11-12) before moving to Module 04
