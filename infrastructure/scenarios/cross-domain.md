# Scenario: Cross-Domain — Memory Leak Causing DB Slowdown + Cost Spike + Pod OOM

> **Module 11 Scenario — Fleet Coordinator Exercise**
> This scenario requires all three specialist agents (Track A, B, C) coordinated by a fleet coordinator agent.
> Individual track agents should be run first to confirm their domain findings before fleet synthesis.

## Setup

Activate messy scenario on all three mock wrappers simultaneously:

```bash
export HERMES_LAB_SCENARIO=messy
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

No additional configuration needed — `HERMES_LAB_SCENARIO=messy` activates all three tracks' messy data simultaneously.

## Context

**Three alerts fire within 5 minutes at 08:47 UTC:**

> **[08:47 UTC] PagerDuty: Pod CrashLoopBackOff — api-deployment** [CRITICAL]
> Pod: api-deployment-def456 — OOMKilled, 8 restarts, CrashLoopBackOff
> Service: core API — 100% error rate

> **[08:51 UTC] CloudWatch: rds-cpu-high — prod-db-01** [CRITICAL]
> CPUUtilization: 97.3% — 5 consecutive 5-minute periods
> Multiple slow queries detected

> **[08:52 UTC] FinOps Alert: Cost Spike Detected** [HIGH]
> 2026-04-02 daily spend: $52.34 (4x normal)
> EC2 primary driver: $44.88 (5x normal)

The incident commander opens a bridge call. All three on-call engineers join. Initial hypothesis is three separate incidents. After 15 minutes of parallel investigation, a pattern emerges.

**Root cause narrative:**

Two days ago (2026-04-02), the analytics team deployed the `memory-hog` service — a new analytics pipeline designed to process order history data for reporting. This service has a memory leak: it allocates memory for each order batch it processes but does not release it between batches.

The memory leak has caused a cascade across all three domains:

**Track C (Kubernetes — direct impact):**
The `memory-hog` pod is consuming 410Mi of node memory with no memory limit set. As it grows, the Linux OOM killer is targeting other pods — specifically `api-deployment`, which has a 256Mi limit and is the lowest-priority pod on the node. Result: api-deployment repeatedly OOMKilled, CrashLoopBackOff, API unavailable.

**Track A (Database — secondary impact):**
The analytics service (memory-hog) is making excessive database queries against the production OLTP instance as part of its processing. Each batch of orders it loads generates 3+ slow SQL queries across the orders, order_items, and products tables. Because the service has a memory leak and never terminates batches cleanly, queries accumulate. Result: 5 simultaneous slow queries, RDS CPU at 97%.

**Track B (Cost — tertiary impact):**
To handle the analytics load the auto-scaler created, the team manually launched an m5.4xlarge EC2 instance on 2026-04-02 to run the analytics job at scale. This instance was not terminated after the test. Additionally, the analytics queries generate high cross-AZ data transfer between RDS and the EC2 instance. Result: 4x daily cost spike, still partially elevated on day 7.

**Timeline:**
- 2026-04-02 06:00 UTC: memory-hog deployed to production
- 2026-04-02 06:18 UTC: m5.4xlarge EC2 launched manually by analytics team
- 2026-04-02 08:30 UTC: RDS CPU starts climbing as memory-hog queries accumulate
- 2026-04-04 08:47 UTC: api-deployment enters CrashLoopBackOff as node memory pressure peaks
- 2026-04-04 08:51 UTC: RDS CPU alarm fires (it has been high for 2 days)
- 2026-04-04 08:52 UTC: FinOps alert fires (day-7 cost still elevated)

## Expected Agent Behavior

**Phase 1: Parallel specialist investigation**

The fleet coordinator dispatches three specialist agents simultaneously:

- **Track A agent:** Runs dba-rds-slow-query skill. Finds 5 slow queries including the orders/products reporting query from analytics service. Cannot identify the source service from SQL alone — escalates with findings.
- **Track B agent:** Runs cost anomaly skill. Finds m5.4xlarge launched 2026-04-02, data transfer elevated. Identifies analytics workload correlation but cannot confirm causation.
- **Track C agent:** Runs kubernetes health skill. Finds api CrashLoopBackOff + memory-hog with no limit. Flags memory-hog's absence of resource limits as a key finding.

**Phase 2: Fleet coordinator synthesis**

The fleet coordinator receives all three findings and performs cross-domain correlation:

1. **Timing correlation:** All three anomalies started 2026-04-02 — the date memory-hog was deployed. This is the common factor.

2. **Service correlation:** The Track A slow queries match the pattern of an analytics service (wide date range scans, batch-oriented query structure). The Track C memory-hog pod is the analytics service. The Track B EC2 launch was to support the analytics job.

3. **Root cause identification:** The fleet coordinator synthesizes: `memory-hog` (analytics service deployed 2026-04-02) is the common root cause. It has a memory leak causing:
   - Node memory pressure → api OOM (Track C)
   - Excessive DB queries → RDS CPU spike (Track A)
   - Manual EC2 scale-up + data transfer → cost spike (Track B)

4. **Unified escalation:** Fleet coordinator produces a single incident summary with:
   - Root cause: memory-hog service with memory leak
   - Immediate actions (all require approval): set memory limit on memory-hog, restart api-deployment, terminate m5.4xlarge
   - Investigation needed: confirm memory-hog is the source of Track A queries, get node metrics to confirm OOM pressure
   - Rollback option: consider rolling back or disabling memory-hog while fix is developed

## Instructor Notes

**What to tell participants:** This is the Module 11 fleet scenario. Individual agents each find valid domain-specific findings. The fleet coordinator's job is to find the common thread — the single change that explains all three alerts.

**Key learning — fleet synthesis vs. single-agent escalation:**
- A single agent running all three skills in sequence would eventually find the pattern, but takes longer and risks losing the timing correlation between alerts.
- A fleet coordinator dispatching specialists in parallel gets all three findings in the time it takes the slowest specialist to run.
- The coordinator's value is the synthesis step — humans can also correlate findings, but the coordinator can do it consistently and at 3 AM.

**The teaching moment for multi-agent patterns:**
The 5-minute window between alerts is the key signal. If all three alerts fire within 5 minutes of each other, the probability of three independent simultaneous incidents is very low. A fleet coordinator should detect this correlation window and prioritize synthesis over individual diagnosis.

**What to watch for:**
- Does the fleet coordinator detect the 5-minute correlation window and flag it explicitly?
- Does the coordinator identify 2026-04-02 (memory-hog deployment date) as the common factor across all three findings?
- Does the coordinator produce a unified root cause statement, or does it just concatenate the three specialist reports?
- Does the coordinator recommend a single corrective action (fix memory-hog) rather than three separate actions?

**Correct root cause statement:** "The memory-hog analytics service deployed 2026-04-02 has a memory leak. This single service is causing: (1) api-deployment OOM kills due to node memory pressure, (2) excessive database queries causing RDS CPU spike, and (3) cost spike from manual EC2 scale-up to support the analytics workload."

**References to individual track scenarios:**
- Track A messy findings: see `track-a-messy.md` — 5 slow queries including analytics-pattern queries
- Track B messy findings: see `track-b-messy.md` — EC2 spike, RDS increase, data transfer anomaly
- Track C messy findings: see `track-c-messy.md` — api CrashLoopBackOff, memory-hog no limits

## Mock Data Files Used

All three tracks' messy mock data — activated by `HERMES_LAB_SCENARIO=messy`:

- `infrastructure/mock-data/rds/pg-stat-statements-messy.json` — 5 slow queries from analytics + existing OLTP queries
- `infrastructure/mock-data/rds/describe-db-instances.json` — RDS instance at 97% CPU
- `infrastructure/mock-data/cost-explorer/anomaly-spike.json` — 7-day cost history with 2026-04-02 spike
- `infrastructure/mock-data/kubernetes/get-pods-crashloop.json` — api CrashLoopBackOff + memory-hog no limits
- `infrastructure/mock-data/kubernetes/describe-pod-oom.json` — api-deployment OOM detail
