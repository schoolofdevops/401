# Platform AI Assessment — Expected Solution

This is a completed example of what a good assessment looks like after working through Module 3 labs.

## Services Evaluated

| AWS AI Feature | Available in Your Account? | Free Tier? | Capability | Gap (What It Can't Do) |
|---------------|---------------------------|-----------|------------|----------------------|
| CloudWatch Basic Metrics | Yes | Yes (always free) | Monitor resource utilization, set threshold alarms | Can't correlate with deployments, no runbook integration |
| CloudWatch Anomaly Detection | Yes | No ($0.30/alarm beyond 10 free) | Learns baselines, detects metric deviations automatically | Can't correlate with deployments or follow runbooks |
| Cost Explorer | Yes | Yes (web UI) | Cost trends, service breakdown, forecasting | Can't recommend specific optimizations for YOUR architecture |
| Q Developer | Yes | Yes (Builder ID, 50 req/month) | Code explanation, security suggestions, IaC review | Limited to code context — can't analyze live infrastructure state |
| DevOps Guru | Yes | 3-month free trial (expires) | Multi-service anomaly detection across CloudWatch/Config/CloudTrail | Can't execute remediation, limited to AWS services only |
| Grafana | N/A | Yes (Community, self-hosted) | Visualization, cross-cloud metrics, alerting | Can't auto-remediate, no runbook automation |

## Your Observations (Completed Example)

### CloudWatch

**Alarms observed in the mock data:**
- Alarms in ALARM state: `api-server-high-cpu` (92.4% CPU), `api-gateway-request-latency-p99` (2847ms)
- Metrics that triggered them: CPUUtilization on EC2 instance i-0a4b2c9f3e1d5a8f2 exceeded 85% threshold; API Gateway p99 latency exceeded 2000ms
- How much context did you have to decide if this is a real problem? Very little — CPU and latency are spiking but no correlation data
- Information you needed that wasn't available:
  - Recent deployments that might explain CPU spike
  - Traffic patterns (concurrent user count, request rate)
  - Database query performance (is RDS slow too?)
  - Auto-scaling group size (can we add capacity?)
  - Whether this spike is genuinely abnormal or within expected SLA bounds

### Cost Explorer

**Top 3 cost drivers (in the mock data or your account):**
1. EC2 Compute ($1,087-$2,400/month depending on dataset)
2. RDS ($612-$667/month)
3. S3 ($287-$512/month)

**Did you spot the cost spike? Month/amount:** Yes — February 2026 ($3,956 total, up from ~$2,300 normal)

**Root cause you can see from the data:** EC2 costs jumped from $1,087 to $2,401 in Feb 2026

**Root cause that requires human judgment/context:**
- Could be legitimate: new application launch, seasonal traffic increase, migration test
- Could be waste: forgotten test instances, inefficient autoscaling, runaway batch job

**Context you'd need to give an AI agent to auto-investigate this:**
1. Tagging strategy — which cost center does each instance belong to?
2. Deployment timeline — when did changes ship to production?
3. Expected traffic patterns — is Feb traffic higher than Jan?
4. Approved infrastructure limits — are we within budget?
5. Instance lifecycle policy — test instances should be auto-terminated

### Q Developer

**Task you gave it:** "Review this Terraform config for security best practices"

**What it got right:**
- Identified missing encryption on S3 bucket
- Flagged overly-permissive IAM policy (Principal: *)
- Suggested security group tightening

**What it didn't know that you know about your infrastructure:**
- That this is a test environment where permissive policies are intentional
- That the S3 bucket contains only non-sensitive logs (encryption overkill)
- That your compliance requirements don't actually mandate EBS encryption

### Grafana (if applicable)

**Dashboards you reviewed:** Production cluster, RDS performance, API Gateway latency

**Alert patterns you noticed:**
- CPU and latency alerts fire together (suggests correlated issue)
- Most alerts fire during business hours (suggests traffic-driven, not infrastructure failure)

**What a tool would need to know to act on these alerts intelligently:**
- Escalation runbooks for each alert type
- PagerDuty integration (who owns this service?)
- Slack webhook (notify team immediately)
- Auto-remediation steps (scale up, drain connections, restart service)

---

## Key Gaps Identified

### 1. Gap: No Correlation Between Alarms, Deployments, and Context

**Why it matters:**
When CPU spikes, platform AI shows the spike but not the cause. Was it a bad deployment? Traffic surge? Misconfigured autoscaler? An agent with access to git log, build artifacts, and deployment timestamps could form hypotheses in seconds instead of your team investigating for 30 minutes.

### 2. Gap: Cost Exploration Requires Manual Drilling

**Why it matters:**
Cost Explorer shows "EC2 is expensive" but not "why" — is it unused test instances, oversized production instances, poor reservation strategy, or legitimate growth? An agent with access to EC2 metadata (launch dates, tags, CPU utilization) could auto-answer "what instances drove the spike?" and even terminate forgotten test instances.

### 3. Gap: Platform AI Can't Execute Fixes or Coordinate Runbooks

**Why it matters:**
CloudWatch and DevOps Guru tell you there's a problem but can't coordinate the response. An agent with tool access could (1) detect the alarm, (2) fetch the runbook from Confluence, (3) trigger an auto-remediation step (scale up, restart, drain connections), (4) update a ticket, (5) notify the team — all without human intervention for routine issues.

---

## What a Custom Agent Could Add

### 1. Against Gap 1 (Deployment Correlation)

**What a custom agent could do:**
When CloudWatch fires an ALARM, agent reads the alarm, looks up recent git commits to the service, checks build artifacts in S3/CodeBuild for size/performance changes, pulls deployment timestamp from deployment system (CodeDeploy/ArgoCD), and creates a Slack notification with hypothesis: "High CPU detected on api-server. Deployment #1234 shipped 15 minutes ago (+200MB binary). Suspected: memory leak or inefficient code path."

**Tools it would need:**
- CloudWatch DescribeAlarms API
- Git API / GitHub / GitLab
- CodeBuild / artifact storage API
- Deployment system API (CodeDeploy / ArgoCD)
- Slack webhook

**Context it would need:**
- Git repo URL and deployment branches
- Build artifact storage path
- Deployment system credentials/config
- Slack channel for alerts
- Known performance baselines (what's normal for this service?)

### 2. Against Gap 2 (Cost Investigation)

**What a custom agent could do:**
When Cost Explorer detects a service-level cost spike (e.g., EC2 up 150%), agent queries EC2 DescribeInstances with creation date filter "launched in last 30 days", checks tags (Environment: test/prod, Owner: team-name), cross-references with approved infrastructure list, and outputs: "Found 6 t3.large instances (test-instance-1 through test-instance-6) launched 2026-02-15 by john@example.com, not in approved list. Cost: $1,314/month. Terminating in 10 seconds unless approved."

**Tools it would need:**
- Cost Explorer API
- EC2 DescribeInstances, TerminateInstances
- CloudTrail (for audit trail)
- ServiceNow / Jira (update ticket with action taken)
- Slack webhook (notify owner)

**Context it would need:**
- Tagging standards (which tags identify test vs. production?)
- Approval workflow (how to escalate before terminating?)
- Cost thresholds (when is a spike "big enough" to alert?)
- Instance naming conventions (can you auto-identify test instances?)

### 3. Against Gap 3 (Automated Runbook Execution)

**What a custom agent could do:**
When latency alarm fires, agent fetches runbook from Confluence ("API Gateway Latency > 2s"), executes steps in sequence: (1) scale up ALB to 2x capacity, (2) check RDS slow query log, (3) post status to Slack, (4) if RDS is slow, trigger optimization runbook; if not, suspect application code. Agent tracks which steps succeeded, which failed, and creates an incident ticket with full remediation transcript.

**Tools it would need:**
- CloudWatch / SNS for alarm subscription
- Confluence / Wiki API (fetch runbook markdown)
- Auto Scaling / ECS / Kubernetes API (scale up)
- RDS DescribeDBClusterParameters, logs API
- Slack webhook (status updates)
- Jira API (create incident ticket)
- Markdown parser (parse runbook steps)

**Context it would need:**
- Runbook location and naming convention
- Escalation policy (who owns each service?)
- Scaling constraints (max capacity, rate limits?)
- Known performance baselines
- Alert severity rules (when is latency "critical" vs. "warning"?)

---

## Your Build List

What you'll build in Module 4-10 to address the gaps above. This example picks the two most impactful gaps:

| Gap | Severity | Skill You'd Build | First Tool It Needs | First Context It Needs |
|-----|----------|-------------------|-------------------|----------------------|
| Deployment Correlation | High | `cost-spike-investigator` | AWS CLI (EC2, Cost Explorer) | EC2 tags, instance naming patterns |
| Automated Runbook Execution | High | `latency-incident-responder` | CloudWatch SNS, Slack API | Runbook location, escalation policy |

---

## Your Platform AI Readiness Score

| Feature | Current Use (1-5) | Automation Potential (1-5) | Notes |
|---------|-------------------|---------------------------|-------|
| CloudWatch monitoring | 4 | 5 | Using alarms but not anomaly detection. Could auto-remediate with agent. |
| Cost visibility | 2 | 5 | Checking Cost Explorer monthly, but no proactive alerts or auto-optimization. |
| Code assistance (Q Developer/Copilot) | 3 | 4 | Using Q for code review but not infrastructure state analysis. |
| Infrastructure anomaly detection | 2 | 5 | Not using DevOps Guru. Full potential unlocked with custom agent access to live metrics. |

**Overall Readiness:** 2.75 / 5

**Why it's not higher:**
Your team has visibility tools in place (CloudWatch, Cost Explorer, Q Developer) but no automation or context correlation. Platform AI is working in isolation — each tool independently detects problems but can't coordinate response or access your operational context (deployment history, approved infrastructure, runbooks).

The gaps you identified above — deployment correlation, cost investigation, and runbook automation — are exactly where custom agents shine. You'll build and integrate agents to fill these gaps in Modules 4-10.
