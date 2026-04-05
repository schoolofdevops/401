# Lab 03 — Exploring Platform AI Features

**Estimated time:** 45 minutes
**Difficulty:** Beginner (guided exploration with mock data fallbacks)
**Deliverable:** Completed Platform AI Assessment documenting capabilities, gaps, and custom agent opportunity list

---

## What You're Building

This lab is a discovery exercise. You'll explore AI features that are already embedded in your cloud platform, observability tools, and code editors — and document exactly where they fall short.

By the end, you'll have:

1. A hands-on understanding of 4 AWS platform AI features
2. A completed Platform AI Assessment with gaps identified
3. A "build list" of what custom agents should handle — which drives the rest of the course

---

## Prerequisites

**Required:**

- Module 01 complete (working lab environment with KIND cluster)
- Module 02 complete (understand context engineering and the 4-layer pattern)
- AI coding agent connected and verified (Claude Code or Crush)

**Optional (enhances but not required):**

- AWS account with free tier — [Create one here](https://aws.amazon.com/free/)
- AWS Builder ID (free, no credit card) — [Create one here](https://profile.aws.amazon.com)

> **No AWS account? No problem.** Every exercise has a mock data fallback using JSON fixtures from the reference app. You'll get the same learning outcomes.

---

## Step 1: CloudWatch Metrics Exploration (10 min)

You're going to look at alarm data — either from your AWS account or from the mock data bundled with the course.

### If you have an AWS account:

```bash
# List all CloudWatch alarms in your account
aws cloudwatch describe-alarms \
  --state-value ALARM \
  --region us-east-1 \
  --output json | head -100
```

### If you're using mock data (recommended for consistency):

```bash
# Navigate to the course repo
cd ~/course

# Examine the mock alarm data
cat infrastructure/mock-data/cloudwatch/describe-alarms-clean.json | python3 -m json.tool | head -50
```

**If the mock data path doesn't exist**, use the starter file provided:

```bash
cat modules/module-03-platform-ai/lab/starter/mock-alarms.json | python3 -m json.tool
```

### What to observe:

Look at the alarm data and answer these questions in your assessment:

1. Which alarms are currently in `ALARM` state?
2. What metric triggered them — CPU? Memory? Request count?
3. For each alarm in ALARM state, what information is **missing** that you'd need to diagnose the issue?

**Expected observation:** You can identify alarms but you can't explain WHY they triggered. You don't know about recent deployments, traffic patterns, or related services. That's the gap.

---

## Step 2: CloudWatch Anomaly Detection (5 min — DEMO OBSERVATION)

CloudWatch Anomaly Detection learns what "normal" looks like for a metric over 2 weeks and alerts when it deviates. This is a **demo observation** because it costs $0.30/alarm/month beyond the free 10.

### What anomaly detection does:

- Eliminates static thresholds ("alert if CPU > 80%")
- Adapts to weekly/daily patterns automatically
- Works with any CloudWatch metric with 2+ weeks of history

### What anomaly detection CANNOT do:

- Cross-reference anomalies with your deployment timeline
- Check if this pattern matches a known failure mode
- Follow your runbook to investigate root cause
- Execute remediation steps
- Create a structured incident ticket

**Write in your assessment:** "CloudWatch Anomaly Detection detects that something is unusual. Everything from diagnosis to resolution is still manual."

---

## Step 3: Cost Explorer Analysis (10 min)

### If you have an AWS account (free web UI):

1. Navigate to **AWS Console > Cost Management > Cost Explorer**
2. Set date range: "Last 6 months"
3. Group by: "Service"
4. Identify services with increasing month-over-month cost

### If you're using mock data:

```bash
# View normal spending pattern
cat modules/module-03-platform-ai/lab/starter/mock-cost-normal.json | python3 -m json.tool

# View the anomaly spike
cat modules/module-03-platform-ai/lab/starter/mock-cost-spike.json | python3 -m json.tool
```

### Analysis exercise:

From either the console or mock data, identify:

1. **Top 3 services by total spend** (or in mock data, the top 3 cost categories)
2. **Which service has the steepest month-over-month increase**
3. **What would you need to know to explain that increase?**

### Connect to context engineering (from M02):

To give an AI agent useful cost analysis capability, you'd need to provide:

- **Historical baseline:** "Our normal EC2 spend is $X/month"
- **Architecture context:** "We have 3 environments — prod runs 24/7, staging spins up during business hours"
- **Change context:** "Deployments happen Tuesday/Thursday — cost spikes on those days are expected"

**Write in your assessment:** At least 2 context layers that would improve an AI cost analysis. This connects directly to the 4-Layer Context Pattern from Module 02.

---

## Step 4: Q Developer Exploration (10 min)

### Option A: If you have an AWS Builder ID (free)

1. Open VS Code (or JetBrains IDE)
2. Install the **AWS Toolkit** extension (includes Amazon Q)
3. Click **Connect to AWS** > Choose **"Use a personal email"** > Sign in with AWS Builder ID

Then ask Q Developer to analyze a file from your lab environment:

```
# Using Claude Code or Crush, open any Kubernetes manifest from the reference app
# Then copy it and paste into Q Developer's chat panel

# Ask:
Explain this Kubernetes configuration. What security improvements would you recommend?
```

Follow up with:

```
Based on this configuration, what alerts should I set up in CloudWatch for this infrastructure?
```

### Option B: If you don't have a Builder ID (use your AI coding agent)

Use Claude Code or Crush to simulate the same exercise. Open a Kubernetes manifest from your reference app:

```bash
# Using Claude Code
claude "Read the voting-app Helm chart values and tell me what security improvements you'd recommend. Then suggest what monitoring alerts we should set up."

# Using Crush
crush "Read the voting-app Helm chart values and tell me what security improvements you'd recommend. Then suggest what monitoring alerts we should set up."
```

### What to observe:

Compare the AI's recommendations to what YOU would recommend:

- **What it got right:** Generic best practices (resource limits, security contexts, probe configurations)
- **What it didn't know:** Your specific SLAs, error budgets, historical baselines, team's risk tolerance, naming conventions

**Write in your assessment:** The gap between the AI's generic recommendations and what an expert in YOUR environment would say. This gap = what SKILL.md files fill.

---

## Step 5: Local Grafana Exploration (5 min)

If your reference app is running on KIND with Prometheus and Grafana:

```bash
# Check if Grafana is accessible
kubectl port-forward svc/grafana 3000:3000 -n monitoring &

# Open in browser
echo "Open http://localhost:3000 (admin/admin)"
```

Explore the dashboards. Grafana's built-in AI features (Sift) require Grafana Cloud Pro+, but even the open-source version shows you how metric visualization alone doesn't answer "why."

**If Grafana isn't running**, skip this step — the observation stands from the mock data exercises.

---

## Step 6: Complete the Platform AI Assessment (5 min)

Open `starter/platform-ai-assessment.md` and fill it in based on Sections 1-5.

**The three most important sections:**

1. **Key Gaps Identified** — List 3 significant gaps between what platform AI offers and what you actually need
2. **What a Custom Agent Could Add** — For each gap, describe what a custom agent with tools and domain context could do
3. **Your Build List** — The gaps you can't fill with platform AI become your custom agent requirements

**This assessment is your personal roadmap for the rest of the course.** The gaps you identify today become the features you build in Modules 7-14.

---

## Wrap-Up

After completing this lab, you should be able to answer:

1. Which AI features are available in your stack right now at zero cost?
2. What is the "capability ceiling" of each — where does it stop?
3. What would you need a custom agent to do that platform AI cannot?
4. How does the 4-Layer Context Pattern from M02 apply to the gaps you found?

**What's next:** In Module 04 (MCP — Connecting to Everything), you'll learn how to give AI agents access to your tools. The gaps you identified here become the capabilities you wire up with MCP servers.
