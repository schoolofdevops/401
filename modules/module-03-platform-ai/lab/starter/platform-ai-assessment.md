# Platform AI Assessment — Your Environment

Use this template during and after Module 3 to document what AWS platform AI features are available to you, what they can do, and — critically — where they fall short.

## Services Evaluated

| AWS AI Feature | Available in Your Account? | Free Tier? | Capability | Gap (What It Can't Do) |
|---------------|---------------------------|-----------|------------|----------------------|
| CloudWatch Basic Metrics | Yes / No / N/A | Yes (always free) | Monitor resource utilization, set threshold alarms | Can't correlate with deployments, no runbook integration |
| CloudWatch Anomaly Detection | Yes / No / N/A | No ($0.30/alarm beyond 10 free) | Learns baselines, detects metric deviations automatically | Can't correlate with deployments or follow runbooks |
| Cost Explorer | Yes / No / N/A | Yes (web UI) | Cost trends, service breakdown, forecasting | Can't recommend specific optimizations for YOUR architecture |
| Q Developer | Yes / No / N/A | Yes (Builder ID, 50 req/month) | Code explanation, security suggestions, IaC review | Limited to code context — can't analyze live infrastructure state |
| DevOps Guru | Yes / No / N/A | 3-month free trial (expires) | Multi-service anomaly detection across CloudWatch/Config/CloudTrail | Can't execute remediation, limited to AWS services only |
| Grafana (if used) | Yes / No / N/A | Yes (Community, self-hosted) | Visualization, cross-cloud metrics, alerting | Can't auto-remediate, no runbook automation |

## Your Observations (Fill In)

### CloudWatch

**Alarms observed in the mock data:**
- Alarms in ALARM state: _____
- Metrics that triggered them: _____
- How much context did you have to decide if this is a real problem? _____
- Information you needed that wasn't available: _____

### Cost Explorer

**Top 3 cost drivers (in the mock data or your account):**
1. _____ ($___/month)
2. _____ ($___/month)
3. _____ ($___/month)

**Did you spot the cost spike? Month/amount:** _____

**Root cause you can see from the data:** _____

**Root cause that requires human judgment/context:** _____

**Context you'd need to give an AI agent to auto-investigate this:**
1. _____
2. _____
3. _____

### Q Developer

**Task you gave it:** _____

**What it got right:** _____

**What it didn't know that you know about your infrastructure:** _____

### Grafana (if applicable)

**Dashboards you reviewed:** _____

**Alert patterns you noticed:** _____

**What a tool would need to know to act on these alerts intelligently:** _____

---

## Key Gaps Identified

List the **3 most significant gaps** you found between what platform AI offers and what you actually need:

1. **Gap:** _____
   - **Why it matters:** _____

2. **Gap:** _____
   - **Why it matters:** _____

3. **Gap:** _____
   - **Why it matters:** _____

---

## What a Custom Agent Could Add

For each gap above, describe what a custom agent (with tools and domain context) could do differently:

1. **Against Gap 1:** _____
   - **Tools it would need:** _____
   - **Context it would need:** _____

2. **Against Gap 2:** _____
   - **Tools it would need:** _____
   - **Context it would need:** _____

3. **Against Gap 3:** _____
   - **Tools it would need:** _____
   - **Context it would need:** _____

---

## Your Build List

What you'll build in Module 4-10 to address the gaps above. Pick 1-2 gaps that matter most to your team:

| Gap | Severity | Skill You'd Build | First Tool It Needs | First Context It Needs |
|-----|----------|-------------------|-------------------|----------------------|
| _____ | High / Medium / Low | _____ | _____ | _____ |
| _____ | High / Medium / Low | _____ | _____ | _____ |

---

## Your Platform AI Readiness Score

Rate your organization's current platform AI usage (1=not using it, 5=using all available features):

| Feature | Current Use (1-5) | Automation Potential (1-5) | Notes |
|---------|-------------------|---------------------------|-------|
| CloudWatch monitoring | | | |
| Cost visibility | | | |
| Code assistance (Q Developer/Copilot) | | | |
| Infrastructure anomaly detection | | | |

**Overall Readiness:** _____ / 5

**Why it's not higher:** The gaps you identified above are your custom agent opportunity list. You'll build tools to address one of them in the hands-on labs ahead.
