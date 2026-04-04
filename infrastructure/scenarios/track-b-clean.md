# Scenario: Track B — Clean: Single EC2 Cost Spike from Oversized Instance

## Setup

```bash
export HERMES_LAB_SCENARIO=clean
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** FinOps daily forecast alert fires at 07:00 UTC on 2026-04-03.

> **FinOps Alert: Monthly Forecast Exceeded Threshold**
> Monthly forecast: $1,247 (was $987 last month)
> Change: +26.1% month-over-month
> Trigger: Single-day cost on 2026-04-02 was 4x normal daily spend
> Action: Notify FinOps and engineering managers

The FinOps team escalates to the on-call engineer. No scheduled infrastructure changes were planned for April 2nd. The engineering manager is unaware of any new services launching that day.

**What is happening:** A single m5.4xlarge EC2 instance was launched at 06:18 UTC on 2026-04-02. This instance type costs approximately $0.768/hour ($18.43/day). The normal daily EC2 spend is approximately $8.11/day. The new instance nearly doubled the EC2 cost for that day, and it is still running.

The instance was launched as part of a performance test by the database team — they needed a beefy machine to run pgbench load tests against the production read replica. The test was supposed to be temporary but the instance was not terminated.

## Expected Agent Behavior

The agent runs the cost anomaly skill against this scenario's mock data:

1. **Queries Cost Explorer** via mock-aws and retrieves 7 days of cost history.

2. **Identifies 2026-04-02 as the anomaly day** — total daily cost of $52.34 vs baseline of ~$13.07/day (4x normal).

3. **Breaks down the 2026-04-02 cost by service** — EC2 is $44.88 (vs ~$8.11 baseline), clearly the dominant driver.

4. **Cross-references EC2 instances** via `aws ec2 describe-instances` — identifies one m5.4xlarge instance launched on 2026-04-02 not present in previous days.

5. **Calculates impact:** ~$18.43/day ongoing cost if the instance remains running. Projects $388/month ongoing if not terminated.

6. **Recommends rightsizing review and approval** before any action — the agent cannot terminate an instance without explicit approval. Escalates with the instance ID and launch details.

7. **Does NOT terminate the instance** — any destructive action requires human authorization.

## Instructor Notes

**What to tell participants:** This is the "clean" cost anomaly scenario. One new resource, one clear cause, one clear recommendation. The agent should navigate from alert → cost data → EC2 inventory → recommendation without needing multiple hypotheses.

**What to watch for:**
- Does the agent identify the specific instance (m5.4xlarge) or just say "EC2 costs are high"?
- Does the agent cross-reference the instance launch date with the cost spike date?
- Does the agent calculate the ongoing daily/monthly cost projection?
- Does the agent escalate with the instance ID for human decision, rather than taking action?

**Correct diagnosis:** One oversized instance (m5.4xlarge) launched 2026-04-02 and still running. Normal baseline = ~$13/day; spike = $52/day. Instance is 20x the size needed for normal workloads.

**FinOps teaching point:** Cost alerts fire after-the-fact. By the time the alert fires, the cost has already occurred. The job of the agent is to (1) explain what happened, (2) stop the bleeding by flagging for immediate action, and (3) recommend preventive controls (instance launch notifications, budget alerts).

**Anti-pattern to flag:** An agent that jumps to "rightsizing recommendation across all EC2 instances" without first identifying the specific anomalous instance is doing unnecessary work and could alarm the team unnecessarily.

## Mock Data Files Used

- `infrastructure/mock-data/cost-explorer/normal-spend.json` — 5-day baseline history (~$13/day)
- `infrastructure/mock-data/cost-explorer/anomaly-spike.json` — 7-day history including 2026-04-02 spike ($52.34) and partial day-7 recovery ($26.79)
- `infrastructure/mock-data/ec2/describe-instances.json` — EC2 instance inventory showing m5.4xlarge launched 2026-04-02
