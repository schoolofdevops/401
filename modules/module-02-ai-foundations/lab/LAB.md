# Module 02: AI Foundations for DevOps Teams — Hands-On Lab

**Duration:** 40 minutes
**Difficulty:** Beginner
**Prerequisites:** Module 01 complete (KIND cluster running, AI coding agent connected via MCP)
**Deliverable:** Completed 4-layer comparison table + context template for Cost Explorer anomaly

---

## Lab Objective

You will learn that **context engineering — not prompt engineering — is what makes AI outputs useful and trustworthy for operations.** By sending the same alarm data four times with progressively richer context, you will see how vocabulary, infrastructure topology, and runbook knowledge drive the quality of AI recommendations.

**Key insight:** The AI's intelligence never changes. Your context does. This principle scales to all operational domains and forms the foundation for SKILL.md files in Module 07.

---

## Part 1: Progressive Context Engineering (25 minutes)

### Overview

You will send a CloudWatch alarm JSON to your AI agent **four times**, each time adding one layer of operational context. You'll observe how the recommendations shift from generic to infrastructure-specific to actionable runbook-driven responses.

### Step 1.1: Prepare Your Alarm Data

The alarm data is already in `lab/starter/alarm-data.json`. Copy it to your working directory or reference it directly:

```bash
cp modules/module-02-ai-foundations/lab/starter/alarm-data.json alarm-data.json
```

The alarm contents for reference:

```json
{
  "AlarmName": "HighCPUUtilization-catalog-api",
  "AlarmDescription": "CPU utilization exceeded 90% threshold",
  "StateValue": "ALARM",
  "StateReason": "Threshold Crossed: 1 out of the last 1 datapoints [92.3] was greater than the threshold (90.0)",
  "MetricName": "CPUUtilization",
  "Namespace": "AWS/EC2",
  "Dimensions": [{"Name": "InstanceId", "Value": "i-0abc123def456001"}],
  "Period": 300,
  "EvaluationPeriods": 1,
  "Threshold": 90.0,
  "ComparisonOperator": "GreaterThanThreshold",
  "StateUpdatedTimestamp": "2026-04-05T03:47:00Z",
  "InsufficientDataActions": [],
  "OKActions": ["arn:aws:sns:us-east-1:123456789012:ops-alerts"],
  "AlarmActions": ["arn:aws:sns:us-east-1:123456789012:ops-critical"]
}
```

**What's in this alarm:** A production catalog-api instance suddenly jumped to 92.3% CPU (well above its 90% threshold). The alarm is routing to a critical SNS topic. This is a real-world scenario you'll need to act on.

### Step 1.2: Layer 1 — Bare Prompt (Baseline)

**Goal:** Establish a baseline. Send minimal context; observe generic advice.

**Your prompt to the AI agent:**

```
Analyze this CloudWatch alarm and recommend immediate actions.

[paste the alarm JSON here]
```

**What you're doing:** You've given the AI the alarm JSON and a generic ask. No context about your infrastructure, role, or SRE practices.

**Expected observation:** The response will be generic — "check CloudWatch Logs," "investigate the instance," "consider scaling." It has no leverage on your specific setup.

**Capture this:** In your comparison table (below), record:
- What severity does the AI assign?
- How specific is it to your infrastructure?
- Does it mention your 60-65% peak baseline?
- Would you trust this advice at 3am?

---

### Step 1.3: Layer 2 — SRE Role Context

**Goal:** Add operational identity. The AI now knows WHO is asking and WHAT framework to use.

**Prepend this context to the alarm JSON:**

```
You are an experienced Site Reliability Engineer (SRE) on a production e-commerce platform.

Your primary responsibilities:
- Diagnose CloudWatch alarms and recommend immediate mitigation steps
- Assess incident severity in terms of customer impact and Mean Time To Recovery (MTTR)
- Communicate decisions in SRE vocabulary (incident severity, blast radius, rollback criteria)
- Think in decision trees: "Is this a traffic spike, a bug, or a resource issue?"

When analyzing alarms, prioritize:
1. Customer impact (number of affected users, service degradation)
2. Time to fix (MTTR — what's the fastest safe resolution?)
3. Confidence level (do you have enough data to act?)

Now analyze this alarm:

[paste the alarm JSON here]
```

**What you're doing:** You've established identity (SRE), given decision-making vocabulary (severity, MTTR, blast radius), and primed the AI to think in terms of customer impact.

**Expected observation:** The response now uses SRE terminology. It asks questions about traffic patterns and considers MTTR. It's better framed, but it's still guessing at specifics about YOUR infrastructure.

**Capture this:** How does the response change compared to Layer 1?

---

### Step 1.4: Layer 3 — Infrastructure Topology

**Goal:** Add structural knowledge. The AI now knows YOUR infrastructure layout, baselines, and dependencies.

**Insert this after Layer 2 context:**

```
Your production infrastructure:

**Compute & Database:**
- i-0abc123def456001 = catalog-api EC2 instance (t3.large, 2 vCPU, 8GB RAM)
- db-catalog = RDS PostgreSQL (db.t3.medium, max 100 connections, typically 40-60% connection utilization)

**Traffic & Performance:**
- Upstream: ALB (Application Load Balancer) in us-east-1a,b,c — distributes traffic from CloudFront CDN
- Daily active users: ~50,000
- Peak traffic window: 09:00–21:00 UTC
- Baseline CPU during peak hours: 60–65% (healthy operating range)
- Baseline CPU during off-peak: 15–25%

**Caching & Optimization:**
- ElastiCache Redis cluster (cache.t3.medium, 2 nodes)
- Typical cache hit rate: 94% (catalog queries are highly cacheable)
- Cache miss below 85% = probable cache-miss storm or node failure

**Incident Routing:**
- SNS ops-alerts topic → PagerDuty → on-call rotation (5 min response SLA)
- SNS ops-critical topic → pages on-call engineer immediately (1 min response SLA)

**Observability:**
- CloudWatch: 1-minute granularity for CPU, request count, latency
- AWS X-Ray enabled: traces top 10% of requests
- CloudWatch Logs: application logs, deployment markers

Now re-analyze this alarm with your knowledge of this specific infrastructure:

[paste the alarm JSON here]
```

**What you're doing:** You've embedded structural knowledge — the instance's resources, typical baselines, caching architecture, and alert routing. The AI can now calculate deviation from normal and reason about specific systems.

**Expected observation:** **This is the biggest quality jump.** The response now:
- Compares 92.3% to your 60-65% peak baseline and identifies significant deviation
- Mentions specific systems (cache, RDS, ALB)
- Reasons about dependencies (if cache is degraded, what cascades?)
- Suggests infrastructure-specific diagnostic steps

This is no longer generic ops advice. It's contextualized to your actual system.

**Capture this:** How much more specific and actionable is Layer 3 compared to Layers 1 and 2?

---

### Step 1.5: Layer 4 — Runbook Context

**Goal:** Add procedural knowledge. The AI now has your decision logic and response playbook.

**Insert this after Layer 3 context:**

```
**SRE Runbook: HighCPUUtilization Response**

When you see a CPU spike, follow this decision tree:

**Diagnosis (first 2 minutes):**
1. **Traffic surge check:** Did ALB RequestCount spike? Compare current RequestCount to the last 2 hours of baseline.
   - If RequestCount is baseline or lower → skip to step 2 (not a traffic issue)
   - If RequestCount spiked → calculate: did we burst into a higher capacity tier? (allowed up to 1.5x baseline for ≤15 min)

2. **Runaway process check:** SSH into the instance and run:
   ```bash
   aws ssm send-command --instance-ids i-0abc123def456001 --document-name "AWS-RunShellScript" \
   --parameters 'commands=["top -bn1 | head -20"]'
   ```
   - Look for a single process consuming >50% CPU (typical runaway)
   - Look for swapping or OOM killer activity in dmesg

3. **Recent deployment check:** Did the 02:30 UTC deployment introduce a leak or inefficiency?
   ```bash
   aws deploy describe-deployments --region us-east-1 --query 'deployments[0:5]' \
   --filters "key=instanceIds,type=KEY_AND_VALUE,value=i-0abc123def456001"
   ```
   - If last deployment was <30 min ago AND no obvious runaway process → suspect code regression

4. **Cache health check:** Is ElastiCache degraded?
   ```bash
   aws elasticache describe-cache-clusters --cache-cluster-id catalog-cache-1 \
   --show-cache-node-info --query 'CacheClusters[0].CacheNodes[0].CacheNodeStatus'
   ```
   - If cache is degraded or nodes are rebooting → every query goes to database → CPU spike
   - Check Redis hit ratio: should be 94%, if < 85% → cache-miss storm

**Response actions (based on diagnosis):**
- **If traffic spike AND within headroom:** No immediate action. Monitor for next 15 min. If CPU stays >90% and traffic is normal, investigate code.
- **If runaway process identified:** Kill the process with caution (`kill -9 PID`). Alert dev team. Check if it recurs.
- **If recent deployment is the cause:** Rollback via CodeDeploy if CPU doesn't normalize within 10 min of process investigation.
- **If cache is degraded:** Restart the affected ElastiCache node. Verify hit rate recovery (should snap back to 94% within 2 min).
- **If no clear cause after diagnosis:** Page the secondary on-call engineer. Prepare for potential instance replacement.

**Escalation criteria:**
- CPU > 90% for > 15 minutes AND no identified root cause → escalate to dev team lead (not just on-call)
- Multiple simultaneous alarms (CPU + latency + DB connections) → declare minor incident, start bridge call
- Customer impact confirmed (customer tickets, increased error rates) → escalate to incident commander

**Documentation:**
- Record all diagnostic commands and outputs in the PagerDuty incident ticket
- Note timeline: when did CPU spike, when did you run each check, what did you find
- Before closing the alarm: update the runbook with what you learned (was it traffic, code, infra?)

**Decision threshold for this alarm:**
- StateValue=ALARM AND duration > 15 min AND no root cause identified → page on-call
- StateValue=ALARM AND duration < 5 min → monitor, likely transient spike

Now analyze this alarm with your full runbook context:

[paste the alarm JSON here]

What is your recommended immediate action? What diagnostic command do you run first?
```

**What you're doing:** You've given the AI your procedural knowledge — the decision tree, diagnostic commands, escalation rules, and documentation requirements. The AI is now operating inside your SRE framework, not its own.

**Expected observation:** The response now:
- Follows YOUR runbook structure (not a generic troubleshooting list)
- Suggests specific AWS CLI commands your team already knows
- Recommends the right diagnostic order (traffic → process → deployment → cache)
- Tells you when to escalate and to whom
- Includes documentation requirements
- Gives a clear immediate action: "Run this diagnostic, then decide"

This is indistinguishable from asking an experienced SRE who knows your infrastructure.

**Capture this:** This is the full picture. Notice that every layer added, the AI didn't get smarter — your context got richer.

---

### Step 1.6: Fill Your Comparison Table

Create a markdown table in your lab notes and fill it in as you progress through Layers 1–4. Here's the template:

```markdown
## Layer Comparison Table

| Aspect | Layer 1 (Bare) | Layer 2 (Role) | Layer 3 (Topology) | Layer 4 (Runbook) |
|--------|---------------|----------------|-------------------|-------------------|
| **Severity assessment** | | | | |
| **Specific to your infra?** | | | | |
| **Mentions 60-65% baseline?** | | | | |
| **Actionable next steps?** | | | | |
| **Mentions cache or database?** | | | | |
| **Correlation analysis?** | | | | |
| **Would you trust this at 3am?** | | | | |
```

**Fill this in with 2-4 words per cell.** For example:
- Layer 1 severity: "Generic concern"
- Layer 4 severity: "15-min decision window"

**Key observation to record:** Between which two layers did the output quality jump the most? (Typically Layer 2 → 3.)

---

## Part 2: Vocabulary Comparison Exercise (10 minutes)

### Overview

You will compare two prompts asking about the **same alarm** — one written like a junior ops engineer, one like an expert SRE. This proves that vocabulary and framing drive context, which drives results.

### Step 2.1: Prompt A — Generic IT Vocabulary

Send this to your AI agent:

```
Hey, one of our servers is showing high CPU. The alarm says 92%. What should I do?

Here's the alarm data:

[paste the alarm JSON here]
```

**Observe:** The response will be helpful but generic. It will ask questions like "What's normal CPU for that server?" and "Are you scaling it?"

### Step 2.2: Prompt B — Expert SRE Vocabulary

Send this to your AI agent:

```
p99 latency on catalog-api is likely impacted — CPU at 92.3% on i-0abc123def456001, 27 points above our 65% peak baseline. No corresponding ALB RequestCount spike visible in the last 2 hours. Suspect either a runaway process from the 02:30 UTC deployment or ElastiCache hit rate degradation causing a cache-miss storm on the RDS instance. Need to confirm root cause before deciding between process kill, deployment rollback, or cache node restart.

Here's the raw alarm for reference:

[paste the alarm JSON here]

What's my diagnostic priority? Should I check process first or cache first?
```

**Observe:** The response will assume competence, ask clarifying questions about YOUR specific systems, and suggest the next 2-3 steps in YOUR decision tree.

### Step 2.3: Compare the Two Outputs

**Record your observations:**
- Did Prompt A and Prompt B ask different follow-up questions?
- Did Prompt A explain more "how-to" concepts?
- Did Prompt B assume deeper knowledge?
- Which response would be faster to act on?
- Which response feels like it's in conversation with a peer vs. talking down to you?

**Key insight:** Same alarm JSON. Same AI. Completely different outputs based on vocabulary, context, and framing. This is context engineering.

---

## Part 3: Build Your Context Template (5 minutes)

### Overview

You will create a reusable 4-layer context template for a **different operational scenario:** analyzing a Cost Explorer anomaly (your daily bill is 3x the normal amount).

This template will follow the same structure you've learned:
- Layer 1: Raw data
- Layer 2: Role & decision vocabulary
- Layer 3: Organizational structure & baselines
- Layer 4: Investigation playbook & escalation rules

### Step 3.1: The Cost Anomaly Scenario

Imagine you received this CloudWatch alarm at 06:00 UTC:

```
Alarm: DailySpendAnomaly-prod
Description: Daily AWS spend exceeded 3x the 7-day rolling average
Current spend (today, 6am): $2,847
7-day average: $924
Deviation: +$1,923 (208% above average)
Services with highest spend today: EC2: $1,200 (baseline $320), RDS: $389 (baseline $180), NAT Gateway: $156 (baseline $45)
```

### Step 3.2: Create Your Template

Create a file called `my-cost-context-template.md` with this structure:

```markdown
# FinOps Context Template: Cost Explorer Anomaly

## Layer 1: Raw Data (No Context)

[Paste the cost anomaly here]

---

## Layer 2: FinOps Role & Vocabulary

You are a FinOps practitioner (cost optimization specialist) for our product engineering team.

Your responsibilities:
- Identify cost anomalies and root causes within 30 minutes
- Recommend immediate cost mitigation (stop, resize, or optimize)
- Classify spend as: expected (planned promotion), transient (traffic spike), waste (misconfiguration), or growth (new service)
- Think in terms of: blast radius (how many workloads affected?), MTCO (mean time to cost optimization), and ROI of the fix

Decision vocabulary:
- "Blast radius" = how many services/environments are affected?
- "Transient" = will it self-resolve in hours?
- "Waste" = misconfiguration or orphaned resource (easy fix)
- "MTCO" = how quickly can we reduce cost?

---

## Layer 3: Account Structure & Baselines

Our AWS account structure:
- **Prod** (account-id: 123456789012)
  - Region: us-east-1 (primary), us-west-2 (secondary)
  - Baseline daily spend: $650 ($500 EC2 + $150 RDS)
  - Peak daily spend (traffic surge): $850
  - Critical threshold: > $1,000/day = investigate

- **Staging** (account-id: 111111111111)
  - Region: us-east-1
  - Baseline: $150/day
  - Often has orphaned resources (previous load test infrastructure)

- **Dev** (account-id: 222222222222)
  - Region: us-east-1
  - Baseline: $50/day
  - High variability (engineers running ad-hoc resources)

Traffic patterns:
- Normal peak: 09:00–21:00 UTC (costs rise ~30%)
- Planned traffic event: Easter promotion (April 6–8, expected 2x traffic)
- EC2 spot instances: 40% of compute (savings plan balance: 67% used)

---

## Layer 4: Investigation Playbook

When you see a cost spike > 1.5x baseline:

**Step 1: Identify the blast radius (2 min)**
```bash
aws ce get-cost-and-usage --region us-east-1 \
  --time-period Start=2026-04-05,End=2026-04-06 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE
```
- Which service spiked? (EC2, RDS, NAT, Transfer, Lambda?)
- Is it a single service or multiple?

**Step 2: Check for known events (1 min)**
- Is today a traffic spike day? (check internal calendar or Slack #traffic-events)
- Was there a recent deployment? (check CodeDeploy history)
- Did someone run a load test? (check #devops-daily)

**Step 3: Investigate by service (5 min)**

**If EC2 spiked:**
```bash
aws ec2 describe-instances --region us-east-1 \
  --query 'Reservations[*].Instances[?LaunchTime>=`2026-04-05T00:00:00`].{InstanceId:InstanceId,InstanceType:InstanceType,LaunchTime:LaunchTime,State:State.Name}'
```
- Did someone launch new instances? (compare to expected launch schedule)
- Are instances in the right state? (stopped vs. running; running instances overnight = waste)
- Is spot pricing fluctuating? (check spot price history)

**If RDS spiked:**
```bash
aws rds describe-db-instances --region us-east-1 \
  --query 'DBInstances[*].{DBInstanceIdentifier:DBInstanceIdentifier,DBInstanceClass:DBInstanceClass,EngineVersion:EngineVersion,StorageIops:Iops}'
```
- Did we scale the instance? (class change, IOPS upgrade)
- Are backups running at unusual frequency? (check automated backup schedule)
- Are we replicating to an unexpected region?

**If NAT Gateway spiked:**
```bash
aws ec2 describe-nat-gateways --region us-east-1 \
  --query 'NatGateways[*].{NatGatewayId:NatGatewayId,State:State,CreateTime:CreateTime}'
```
- Did someone deploy to a new availability zone?
- Is there unexpected cross-AZ traffic? (NAT charges per GB transferred)
- Did a misconfigured service start logging to S3 via NAT?

**Step 4: Escalation & action (time-dependent)**

- **Transient (will pass in <12 hours):** Monitor. Set alert to resume in 24 hours if not resolved. Document in #finops Slack.
- **Waste (misconfiguration, orphaned resources):** Kill it immediately. Authorize via Slack. Cost savings: [estimated amount].
- **Planned (promotion, load test):** Expected cost spike. Verify it matches the plan. Monitor for overage beyond plan.
- **Unknown cause after 30 minutes:** Escalate to VP Engineering. Recommend immediate pause of non-critical workloads (load tests, batch jobs).

**Documentation:**
- Update the incident ticket with: root cause, blast radius, action taken, savings, and timeline
- If this is a new type of anomaly, update this playbook so future FinOps engineers know what to do

---

## End Your Template

This is YOUR context. You've given the AI your role, account structure, baselines, and playbook.
```

### Step 3.3: Test Your Template

Send your completed template + the cost anomaly to your AI agent. Ask:

```
Analyze this cost spike using the context I've provided.

[paste the template + anomaly]

What is the most likely root cause? What's my first diagnostic step?
```

**Observe:** The response should now be specific to YOUR account structure, mention concrete AWS CLI commands you'd recognize, and follow your escalation logic.

**Record:** Is this response as good as the Layer 4 alarm response from Part 1? Why or why not?

---

## Part 4: Wrap-Up (2 minutes)

### Key Takeaways

1. **Context engineering is the skill.** The AI didn't get smarter across Layers 1–4. Your context got richer. This scales to every operational domain.

2. **Vocabulary is load-bearing.** SRE terminology (MTTR, blast radius, escalation criteria) shapes how the AI reasons about decisions. Generic terms produce generic responses.

3. **Topology and baselines matter.** Knowing your infrastructure (60–65% baseline CPU, 94% cache hit rate) lets the AI calculate deviation and identify abnormalities.

4. **Runbooks are context encoding.** Layer 4 context is structured as a decision tree — this is exactly what SKILL.md files do in Module 07. You'll see the same pattern applied to agent behavior.

5. **Reusability.** The 4-layer template works for alarms, cost anomalies, log analysis, capacity planning, and incident response. Once you encode it, you reuse it.

### What's Next

- **Module 03:** You'll see what **platform AI** (AWS built-in features) can do WITHOUT this context engineering — and you'll see its ceiling.
- **Module 07:** You'll encode layers 2–4 into SKILL.md files that travel with your agents.
- **Module 10:** You'll build domain-specific agents that use this context engineering at scale.

### Checkpoint: Your Deliverables

Before you finish, verify you have:

- [ ] Completed comparison table (Layer 1–4) with observations
- [ ] Noted the biggest quality jump (typically Layer 2 → 3)
- [ ] Compared Prompt A (generic) and Prompt B (expert SRE)
- [ ] Created `my-cost-context-template.md` with all 4 layers filled in
- [ ] Tested your template against the cost anomaly
- [ ] Noted which layer is hardest to create (usually Layer 3 — infrastructure topology)

**Share these files with your instructor or save them for your portfolio. This is the foundation of everything that follows.**

---

## Appendix: Tool-Specific Instructions

### Path A: Claude Code

If you're using Claude Code as your AI agent:

1. Open Claude Code on your laptop
2. Create a new project folder: `module-02-lab`
3. Create files for each layer (layer-1-bare.md, layer-2-role.md, etc.)
4. In the chat, paste your prompt + context + alarm JSON
5. Claude Code will render outputs and allow you to edit the comparison table inline
6. Copy-paste the table results into your final notes

**Tip:** Use Claude Code's project memory — it will remember your alarm data and context across multiple prompts, so you don't have to re-paste the JSON each time.

### Path B: Crush (Charmbracelet)

If you're using Crush as your AI agent:

1. Install Crush: `brew install charmbracelet/tap/crush` (or see [github.com/charmbracelet/crush](https://github.com/charmbracelet/crush))
2. Connect to your preferred provider (run `/connect` inside Crush and choose Groq or Gemini)
3. Navigate to the lab directory:
   ```bash
   cd modules/module-02-ai-foundations/lab/starter
   ```
4. Launch Crush:
   ```bash
   crush
   ```
5. For each layer, paste the prompt from the corresponding `context-layer-N.md` file, then append the alarm JSON from `alarm-data.json`. Type or paste directly into the Crush terminal interface.
6. Record your observations in `comparison-table.md`

**Tip:** Crush is fast with Groq — if you're on a slow connection, use Groq's free tier (14,400 requests/day) rather than Gemini.

---

## Appendix: Starter Files

The `starter/` directory contains:
- `alarm-data.json` — the CloudWatch alarm used in Part 1
- `cost-anomaly-sample.json` — the Cost Explorer anomaly for Part 3
- `comparison-table.md` — a blank table ready to fill
- `context-layer-1.md` through `context-layer-4.md` — copy-paste prompts for each layer (saves typing)
- `vocabulary-comparison.md` — Prompt A and Prompt B for the vocabulary comparison exercise

Use these to speed up the lab if time is tight.

---

## Appendix: Common Pitfalls

**"I filled in Layer 1, but the AI's response is already very detailed."**
- Your baseline AI is good. That's fine. The quality *increase* across layers is what matters. Compare the *type* of advice, not the volume.

**"Layer 3 context is huge. How do I create it for my own infrastructure?"**
- Start with a Confluence doc or wiki page you already have about your infrastructure. Copy-paste it, then refine. You don't need perfect documentation — you need the key facts (instance types, baselines, cache hit rates, dependencies).

**"Layer 4 runbook is really long. Do I need to encode all of that in SKILL.md?"**
- Not all at once. Start with the decision tree (which check first?) and the escalation criteria. The detailed CLI commands can live in a separate ops-doc.md. SKILL.md encodes the meta-reasoning, not the full playbook.

**"Can I use this 4-layer approach for non-alarm scenarios?"**
- Yes, absolutely. Use it for log analysis, capacity planning, cost anomalies, deployment decisions, post-mortem analysis. Any scenario where you need consistent, context-aware AI reasoning.

