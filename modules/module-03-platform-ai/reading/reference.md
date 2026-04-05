# Module 03 — Quick Reference: Platform AI Features

**TL;DR:** Platform AI handles detection and basic analysis. Custom agents fill the gap: investigation, action, and your context. Understand what each platform AI feature does and doesn't do — that's your roadmap for building custom agents.

---

## Platform AI Categories at a Glance

| Category | What It Does | What It Doesn't Do | Examples |
|----------|---------|---------|----------|
| **Anomaly Detection** | Learns baselines, alerts on deviations | Diagnoses root cause, takes action | CloudWatch Anomaly, Datadog Watchdog, Grafana Sift |
| **Cost Intelligence** | Shows trends, forecasts, suggests optimizations | Correlates with deployments/architecture | AWS Cost Explorer, Azure Cost Management |
| **Cross-Service Correlation** | Finds relationships between service anomalies | Executes fixes, knows your runbooks | DevOps Guru, Datadog RCA |
| **Code Assistance** | Explains code, spots issues, generates templates | Knows your conventions & architecture | Q Developer, GitHub Copilot, Cursor |

---

## The Capabilities Matrix: Your One-Page Gap Analysis

| Feature | Detects? | Investigates? | Acts? | Knows Your Context? | Custom Agent Fills? |
|---------|---------|---------|---------|---------|---------|
| CloudWatch Anomaly Detection | ✓ Yes | ✗ No | ✗ No | ✗ No | Investigation, Action, Context |
| Cost Explorer | ✓ Yes | ~ Partial | ✗ No | ✗ No | Root cause analysis, Context |
| DevOps Guru | ✓ Yes | ~ Partial | ✗ No | ✗ No | Action, Context |
| Q Developer | ~ Partial | ~ Partial | ✗ No | ✗ No | Context (architecture, conventions) |
| Datadog Watchdog | ✓ Yes | ~ Partial | ✗ No | ✗ No | Investigation, Action, Context |
| Grafana Sift | ✓ Yes | ~ Partial | ✗ No | ✗ No | Full investigation, Action |
| **Custom Agent (you build it)** | ✓ Yes | ✓ Yes | ✓ Yes | ✓ Yes | — |

**Key insight:** Detection is solved. Everything to the right is where custom agents add value.

---

## AWS Platform AI Services: Free Tier vs Paid

### Always Free

| Service | What It Does | How to Access | Limitations |
|---------|---------|---------|---------|
| **CloudWatch Basic Metrics** | View metrics, create dashboards, set static alarms | AWS Console | 10 alarms free/month |
| **Cost Explorer (Web UI)** | Browse your costs by service, region, tag | AWS Console → Cost Management | Limited historical analysis |
| **Q Developer (via Builder ID)** | Code assistance, Terraform review, IaC suggestions | AWS Builder ID (no account needed) | 50 agentic requests/month |

### Free Trial / Paid

| Service | What It Does | Cost | Free Trial |
|---------|---------|---------|---------|
| **CloudWatch Anomaly Detection** | Automatic baseline learning, alerts on deviation | $0.30/alarm/month (beyond first 10 free) | Included in first 10 alarms |
| **DevOps Guru** | Cross-service correlation, anomaly detection | $0.50/resource/day ($15/month per EC2 instance) | 3-month trial |
| **AWS Application Auto Scaling** | Predictive scaling based on patterns | Included with EC2/RDS/Lambda | No separate charge |

### Not on AWS Free Tier (Demo Only in Course)

| Service | What It Does | Typical Cost |
|---------|---------|---------|
| **Datadog Watchdog** | Automatic anomaly detection & RCA | Included in Pro plan (~$15–30/month per host) |
| **Grafana Sift** | Metric correlation & investigation | Included in Cloud Pro plan (~$299/month) |
| **New Relic AI** | APM-based anomaly detection | Included in Pro subscription (~$500+/month) |

**For this course:** Use free AWS services for hands-on labs. Trainer demos the paid tools.

---

## Essential AWS CLI Commands for Platform AI Labs

### CloudWatch Anomaly Alarms

```bash
# List all CloudWatch alarms (free to explore)
aws cloudwatch describe-alarms \
  --region us-east-1 \
  --output json

# Get alarm history
aws cloudwatch describe-alarm-history \
  --alarm-name "my-cpu-alarm" \
  --max-records 10

# Get a single alarm's details
aws cloudwatch describe-alarms \
  --alarm-names "my-cpu-alarm" \
  --output json
```

### Metrics Exploration

```bash
# List available metrics for a service (e.g., EC2)
aws cloudwatch list-metrics \
  --namespace AWS/EC2 \
  --region us-east-1 \
  --max-items 20

# Get metric statistics (last 1 hour)
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average,Maximum \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0
```

### Cost Explorer (Limited via CLI)

```bash
# Cost Explorer API is limited in AWS CLI; use web console for full features
# But you can query cost & usage via Cost and Usage Report API:
aws ce list-cost-allocation-tags \
  --status Inactive
```

### Q Developer Setup (No AWS Account Needed)

```bash
# Q Developer is accessed via IDE plugins (VS Code, JetBrains, etc.)
# Create a Builder ID at: https://profile.aws.amazon.com
# No AWS account or credit card required
# 50 agentic requests per month, free
```

---

## Observability Platform AI Features: Quick Comparison

| Tool | Anomaly Detection | Root Cause Analysis | Cross-Service Correlation | Pricing |
|------|---------|---------|---------|---------|
| **CloudWatch Anomaly** | ✓ Excellent | ~ Partial | ✗ No | $0.30/alarm/month |
| **Datadog Watchdog** | ✓ Excellent | ✓ Good | ✓ Good | Included in Pro ($15–30/month) |
| **Grafana Sift** | ✓ Good | ✓ Good | ~ Partial | Cloud Pro ($299/month) |
| **New Relic AI** | ✓ Good | ✓ Good | ✓ Good | Included in Pro ($500+/month) |
| **Splunk AI** | ✓ Good | ✓ Good | ~ Partial | Included in Enterprise |

**For DevOps teams:** Start with CloudWatch (free, included with AWS). Pair with Datadog if you're already paying for it. CloudWatch + custom agents > expensive observability tool without custom agents.

---

## Code Assistance Platform AI: What's Available

| Tool | Free Tier | Models Supported | Best For |
|------|---------|---------|---------|
| **Q Developer (AWS)** | 50 req/month | Claude (via AWS) | AWS-specific IaC, free tier |
| **GitHub Copilot** | Free (basic); Pro ($10/month) | GPT-4, Claude (via GitHub) | General code, pair programming |
| **Cursor** | Free (local) | Claude, GPT-4, others | AI-first code editor |
| **Claude Code** | Claude Pro/Team subscription | Claude Sonnet | Infrastructure, Terraform, Kubernetes |

**For course labs:** Use Q Developer (free, no credit card). Use Claude Code if you have Claude subscription.

---

## Platform AI Capabilities Matrix: Detailed

### What Each Feature Can Do

```
Anomaly Detection (CloudWatch, Datadog, Grafana):
├─ DETECT: Identifies metric deviations from baseline ✓
├─ INVESTIGATE: Correlates with other metrics ~ (limited)
├─ ACT: Executes remediation ✗
└─ CONTEXT: Knows your runbooks, SLAs ✗

Cost Intelligence (Cost Explorer, Azure CM):
├─ DETECT: Identifies cost spikes ✓
├─ INVESTIGATE: Breaks down by service/region/tag ✓
├─ ACT: Stops unused resources automatically ✗ (only recommends)
└─ CONTEXT: Correlates with deployments/architecture ✗

Cross-Service Correlation (DevOps Guru, Datadog RCA):
├─ DETECT: Identifies anomalies ✓
├─ INVESTIGATE: Finds service relationships ✓
├─ ACT: Executes fixes ✗
└─ CONTEXT: Knows your operational decisions ✗

Code Assistance (Q Dev, Copilot, Cursor):
├─ DETECT: Identifies code issues ~ (linting only)
├─ INVESTIGATE: Explains code & configs ✓
├─ ACT: Applies fixes manually (you review) ~
└─ CONTEXT: Knows your conventions, approved patterns ✗
```

---

## Cost Scenarios: Platform AI vs Manual vs Custom Agents

### Scenario: 500 Alarms/Day on Production

**Manual Triage (Human Time)**
- Time per alarm: 5 minutes
- Labor cost per alarm: ~$0.25 (on-call engineer at $75/hr loaded cost)
- Daily cost: 500 × $0.25 = **$125/day** (~$45K/year)
- Time to resolution: 40–60 minutes

**Platform AI (CloudWatch Anomaly Only)**
- Detection automated: ✓
- Still requires manual investigation & action
- Cost: $0.30/alarm/month (after first 10 free) + human time
- Platform cost: ~500 alarms × $0.30 = **$150/month** (~$1,800/year)
- But: Still need 80% of manual investigation
- Effective cost: ~$36K/year (20% time saving)
- Time to resolution: 20–40 minutes (detection automated, investigation manual)

**Custom Agent (Investigation + Action Automated)**
- Detection: CloudWatch Anomaly (included)
- Investigation: Agent follows runbook, queries metrics, checks deployments
- Action: Agent proposes fix, creates ticket, escalates if needed
- Cost: Claude API (~$10K–15K/year for 500 daily alarms)
- Time to resolution: 3–10 minutes
- Effective time savings: ~$40K/year (90% automation)
- **Net benefit: ~$25K–30K/year**

**Key insight:** Platform AI is useful but incomplete. Custom agents that fill the investigation + action gap show ROI at scale.

---

## Platform AI Gap Analysis Checklist

**Use this to evaluate platform AI in your own environment:**

- [ ] **Anomaly Detection:** Are you using CloudWatch Anomaly, Datadog Watchdog, or Grafana Sift?
  - If yes: Does it reduce alert fatigue? Does it eliminate manual threshold tuning?
  - If no: You're probably using static thresholds. Time investment to enable could be worth it.

- [ ] **Cost Intelligence:** Are you using Cost Explorer, Azure Cost Management, or similar?
  - If yes: How often do you act on its recommendations? Can you correlate spikes with deployments?
  - If no: Cost management is ad-hoc. Enabling Cost Explorer is free; the insights are valuable.

- [ ] **Cross-Service Correlation:** Do you have DevOps Guru, Datadog RCA, or similar enabled?
  - If yes: How often does it save you investigation time? Can it execute fixes?
  - If no: You're correlating metrics manually. This tool could reduce MTTR.

- [ ] **Code Assistance:** Are you using Q Developer, Copilot, or Cursor?
  - If yes: How often do you use it? Does it know your conventions?
  - If no: Free tier options exist. Try Q Developer or Copilot free tier.

**For each "no," ask:** Would enabling this platform AI feature save time? Is the setup cost worth it?

**For each "yes," ask:** What's still manual after this tool runs? That gap is where custom agents live.

---

## Key Links (April 2026)

### AWS Services
- [CloudWatch Anomaly Detection docs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatch-Anomaly-Detection.html)
- [DevOps Guru documentation](https://docs.aws.amazon.com/devops-guru/)
- [AWS Q Developer (Builder ID signup)](https://profile.aws.amazon.com)
- [Cost Explorer UI](https://console.aws.amazon.com/cost-management/home)

### Observability Platform AI
- [Datadog Watchdog docs](https://docs.datadoghq.com/monitors/types/anomaly/)
- [Grafana Sift docs](https://grafana.com/grafana/plugins/grafana-sift-app/)
- [New Relic AI documentation](https://docs.newrelic.com/docs/alerts-applied-intelligence/applied-intelligence/)

### Code Assistance
- [Amazon Q Developer docs](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/what-is-qdeveloper.html)
- [GitHub Copilot docs](https://docs.github.com/en/copilot)
- [Cursor editor](https://cursor.sh/)
- [Claude Code](https://claude.com)

---

## Terminology: Platform AI vs Custom Agents

| Concept | Platform AI | Custom Agent |
|---------|---------|---------|
| **Who builds it?** | Vendor | You |
| **Detection** | Excellent | Good (uses platform AI + custom rules) |
| **Investigation** | Limited | Excellent (knows your runbooks) |
| **Action** | None | Excellent (with guardrails) |
| **Context** | Generic | Your specific environment |
| **Setup time** | Minutes to hours | Days to weeks |
| **Time to value** | Immediate | Delayed but high |
| **Cost** | $0–100s/month | $100–1000s/month in API spend |
| **Vendor lock-in risk** | High (tool-specific) | Lower (can mix tools) |

---

## Quick Lookup: Common Questions

**Q: Should we use platform AI or build a custom agent?**
A: Use platform AI for detection (it's excellent and quick). Build custom agents for investigation and action (it's where the gap is).

**Q: Is CloudWatch Anomaly Detection worth $0.30/alarm/month?**
A: Yes, if it eliminates static threshold tuning. No, if you're not addressing the investigation gap (investigation is still manual). Pair with a custom agent for ROI.

**Q: How much does it cost to run a custom agent?**
A: Depends on volume and model. ~$10–50K/year at 500+ incidents/day using Claude. Gemini 2.5 Flash free tier works for <500 incidents/day.

**Q: Can we start with platform AI and upgrade to custom agents later?**
A: Yes. Start with CloudWatch Anomaly Detection (detection). Document the gaps (investigation, action). Then build custom agents that leverage platform AI for detection while automating the rest.

**Q: Is platform AI vendor-locked?**
A: Yes. CloudWatch features only understand CloudWatch data. Datadog features only understand Datadog data. Custom agents can be designed to be vendor-agnostic.

**Q: What if we use multiple observability tools?**
A: Platform AI features don't cross tool boundaries. Custom agents (if designed well) can query multiple tools and correlate across them. That's a feature custom agents have that platform AI doesn't.

---

## One-Page Gap Analysis Template

**For your own infrastructure, fill this out:**

```
Platform AI Inventory (What We Have):
├─ Anomaly Detection: [CloudWatch / Datadog / Grafana / None]
├─ Cost Intelligence: [Enabled / Not enabled]
├─ Cross-Service Correlation: [DevOps Guru / None]
└─ Code Assistance: [Q Developer / Copilot / None]

Gap Analysis (What's Missing):
├─ Detection gaps: [List specific things platform AI misses]
├─ Investigation gaps: [List specific things we diagnose manually]
├─ Action gaps: [List specific things we execute manually]
└─ Context gaps: [List specific runbooks/SLAs/conventions not encoded]

Custom Agent Opportunity List (What We'll Build):
├─ Agent 1: [Name, what it investigates]
├─ Agent 2: [Name, what it investigates]
└─ Agent 3: [Name, what it investigates]
```

**This template becomes your requirements list for Pillar 2 and 3.**

---

## Key Takeaway

**Platform AI is your starting point.** It's excellent at detection. It's a solved problem.

Everything beyond detection — investigation, action, your specific context — is where custom agents live. The gap between "platform AI detects" and "incident resolved" is exactly what you'll engineer in the rest of this course.

Understand what platform AI does in your environment. Document what it can't do. That gap analysis drives the rest of your agentic DevOps journey.

---

**Next step:** Do the lab. Explore platform AI in your environment (or with mock data). Fill out the Gap Analysis template. That list becomes your custom agent design brief.
