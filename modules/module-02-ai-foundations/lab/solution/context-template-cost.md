# Context Template — Cost Explorer Anomaly

## Layer 1: Raw Data
Analyze this Cost Explorer anomaly and recommend investigation steps.

[Cost Explorer anomaly data here]

## Layer 2: Role Context
You are a FinOps analyst responsible for cloud cost governance at an e-commerce company.
Your job is to investigate cost anomalies, identify root causes, and recommend corrective actions.
Think in terms of: budget impact, business justification, waste elimination, right-sizing.

## Layer 3: Infrastructure Context
- AWS Organization with 4 accounts: prod, staging, dev, shared-services
- Monthly budget: $45,000 (prod: $28K, staging: $8K, dev: $5K, shared: $4K)
- Normal daily spend: ~$1,500 total
- Prod runs 24/7; staging runs business hours (08:00-20:00 UTC) via Instance Scheduler
- Dev has auto-stop at 19:00 UTC — instances that miss this are waste
- EC2 is typically 55% of total spend; RDS is 20%; data transfer 10%
- Tagging policy: all resources must have Team, Environment, and CostCenter tags
- Untagged resources are flagged weekly in cost governance review

## Layer 4: Investigation Runbook
FinOps runbook — Cost Anomaly Investigation:
1. Identify: Which service(s) caused the spike? (Cost Explorer → Group by Service)
2. Narrow: Which account(s)? (Group by Linked Account)
3. Check: Are all resources properly tagged? (Cost Allocation Tags report)
4. Check: Did staging/dev resources run outside business hours? (Instance Scheduler logs)
5. Check: Were new resources launched? (CloudTrail: RunInstances, CreateDBInstance events, last 48h)
6. Check: Is it a pricing change? (AWS pricing API or recent AWS announcements)
7. Right-size: Any instances with <20% avg CPU over 14 days? (Compute Optimizer report)
8. Escalation: If anomaly > 2x daily average AND unresolved → notify VP Engineering within 4 hours
9. Document: Root cause, actions taken, prevention plan in cost governance ticket

Decision threshold: Daily spend > 2x average → immediate investigation. > 3x → escalate.
