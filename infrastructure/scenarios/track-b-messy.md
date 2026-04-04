# Scenario: Track B — Messy: Cost Spike + RDS Increase + Data Transfer Anomaly

## Setup

```bash
export HERMES_LAB_SCENARIO=messy
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** FinOps daily forecast alert fires at 07:00 UTC on 2026-04-03.

> **FinOps Alert: Monthly Forecast Exceeded Threshold**
> Monthly forecast: $1,247 (was $987 last month)
> Change: +26.1% month-over-month
> Trigger: Three cost components all elevated since 2026-04-02
> Action: CRITICAL — Notify FinOps lead and VP Engineering

The FinOps team escalates. Day 7 (2026-04-03) shows costs partially recovering but NOT returning to baseline:
- EC2: $18.23/day (was $8.11 baseline) — partially down from $44.88 peak but still elevated
- RDS: $4.46/day (was $3.43 baseline) — +30% above normal
- Data Transfer: $3.54/day (was $0.99 baseline) — 3.5x normal

**What is happening (instructor only — 3 independent root causes):**
1. **EC2 spike (m5.4xlarge):** Same instance as clean scenario — launched 2026-04-02, partially terminated (test workload stopped but instance is still allocated)
2. **RDS increase:** A MultiAZ failover drill ran on 2026-04-02 at 10:30 UTC. The failover caused RDS to provision a second instance for ~6 hours before failing back. This appears as extra RDS hours in Cost Explorer.
3. **Data Transfer increase:** The m5.4xlarge instance was running pgbench against the production read replica. pgbench generates high volumes of query result data flowing from RDS to EC2 — this is cross-AZ data transfer. Even with the test workload stopped, the RDS Multi-AZ replica sync generated inter-AZ data transfer during the failover window.

Day 7 is still elevated because the m5.4xlarge instance has not been fully terminated (it's in a stopped state, which still incurs EBS volume charges), and the data transfer has a lag in Cost Explorer reporting.

## Expected Agent Behavior

The agent runs the cost anomaly skill against this scenario's mock data:

1. **Queries Cost Explorer** and retrieves 7-day history with service breakdown.

2. **Identifies three elevated cost components** — does not treat this as a single-cause incident:
   - EC2: $44.88 on day 6 (2026-04-02), partially recovering to $18.23 on day 7
   - RDS: +$1.54 increase on 2026-04-02 vs baseline
   - Data Transfer: +$1.00 increase on 2026-04-02, further elevated to $3.54 on day 7

3. **Analyzes the EC2 component first** (highest impact) — identifies the m5.4xlarge instance.

4. **Flags the RDS increase** — notes it is smaller in absolute terms but anomalous. States it cannot definitively attribute this without CloudWatch alarm data (suggests checking for MultiAZ events).

5. **Flags the Data Transfer increase** — notes the timing correlates with the EC2 instance (pgbench would generate data transfer), but day-7 data transfer is higher than day-6, which is suspicious (data transfer usually decreases when the workload stops).

6. **Reports the day-7 ambiguity explicitly:** Day-7 costs are still elevated. The EC2 partially explains this (stopped instance with EBS charges), but data transfer increase on day 7 requires investigation — the agent should NOT claim the incident is resolved.

7. **Escalates with three separate findings**, each with a different confidence level:
   - EC2: HIGH confidence (specific instance identified)
   - RDS: MEDIUM confidence (timing matches failover, but CloudWatch confirmation needed)
   - Data Transfer: LOW confidence (correlated with EC2 workload, but day-7 behavior unexplained)

## Instructor Notes

**What to tell participants:** This is the "messy" scenario. Three cost components are elevated. An agent that only addresses the EC2 spike has done incomplete work. An agent that claims to have identified the root cause of all three has overclaimed.

**Key learning — confidence calibration:** The agent's job is to tell you what it knows and what it doesn't know. For the RDS increase, the agent can say "this looks like a failover event" but should recommend a human check CloudWatch for the MultiAZ failover log. For data transfer, the agent should flag it as an open question requiring further investigation.

**The correct agent posture:**
- Identify all three cost anomalies
- Quantify each one (absolute and percentage increase)
- Attribute with appropriate confidence (HIGH/MEDIUM/LOW)
- Flag that day-7 not returning to baseline means the incident is not resolved
- Recommend specific next steps for each

**What to watch for:**
- Does the agent address all three service components, or only EC2?
- Does the agent notice that day-7 costs are STILL elevated (not fully recovered)?
- Does the agent resist claiming a definitive root cause for the data transfer increase?
- Does the agent recommend different next steps for each component (terminate EC2, check CloudWatch for RDS, investigate data transfer separately)?

**Anti-patterns to flag:**
- "The incident is resolved" — day-7 costs are not at baseline
- Attributing the data transfer increase to the m5.4xlarge with HIGH confidence (it's correlated, not confirmed)
- Ignoring the RDS cost increase as "noise" (30% above baseline is anomalous)

## Mock Data Files Used

- `infrastructure/mock-data/cost-explorer/anomaly-spike.json` — 7-day history: EC2 spike 2026-04-02, RDS+transfer increases, partial day-7 recovery
- `infrastructure/mock-data/ec2/describe-instances.json` — EC2 inventory including m5.4xlarge and whether it is running/stopped
