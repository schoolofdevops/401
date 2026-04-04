# Platform AI Assessment — Your Environment

Use this template during and after Module 2 to document what AWS platform AI features are available to you, what they can do, and — critically — where they fall short.

## Services Evaluated

| AWS AI Feature | Available in Your Account? | Free Tier? | Capability | Gap (What It Can't Do) |
|---------------|---------------------------|-----------|------------|----------------------|
| CloudWatch Basic Metrics | Yes / No / N/A | Yes (always free) | Monitor resource utilization, set threshold alarms | Can't correlate with deployments, no runbook integration |
| CloudWatch Anomaly Detection | Yes / No / N/A | No ($0.30/alarm beyond 10 free) | Learns baselines, detects metric deviations automatically | Can't correlate with deployments or follow runbooks |
| Cost Explorer | Yes / No / N/A | Yes (web UI) | Cost trends, service breakdown, forecasting | Can't recommend specific optimizations for YOUR architecture |
| Q Developer | Yes / No / N/A | Yes (Builder ID, 50 req/month) | Code explanation, security suggestions, IaC review | Limited to code context — can't analyze live infrastructure state |
| DevOps Guru | Yes / No / N/A | 3-month free trial (expires) | Multi-service anomaly detection across CloudWatch/Config/CloudTrail | Can't execute remediation, limited to AWS services only |

## Your Observations (Fill In)

### CloudWatch

**What I saw in the alarm data:**
- Alarms in ALARM state: _____
- Metric that triggered it: _____
- Information I needed that wasn't there: _____

### Cost Explorer

**Top 3 cost drivers in my account (or mock data):**
1. _____ ($___/month)
2. _____ ($___/month)
3. _____ ($___/month)

**The spike I can't explain without more context:** _____

**Context I'd need to give an AI agent to investigate this:**
1. _____
2. _____

### Q Developer

**Task I gave it:** _____

**What it got right:** _____

**What it didn't know that I know:** _____

---

## Key Gaps Identified

List the 3 most significant gaps you found between what platform AI offers and what you actually need:

1. _______________ (e.g., "CloudWatch can't correlate CPU spikes with our deployment pipeline")
2. _______________
3. _______________

---

## What a Custom Agent Could Add

For each gap above, describe what a custom agent (with tools and domain context) could do:

1. _______________ (e.g., "Agent reads alarm, checks git log for recent deployments, cross-references with runbook, creates Jira ticket with root cause hypothesis")
2. _______________
3. _______________

---

## Your Platform AI Readiness Score

Rate your organization's current platform AI usage (1=not using it, 5=using all available features):

| Feature | Current Use (1-5) | Automation Potential (1-5) |
|---------|-------------------|---------------------------|
| CloudWatch monitoring | | |
| Cost visibility | | |
| Code assistance (Q/Copilot/etc.) | | |

**Overall:** The gaps you identified above are your custom agent opportunity list. You'll build a solution for one of them on Day 3.
