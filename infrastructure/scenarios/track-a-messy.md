# Scenario: Track A — Messy: 5 Simultaneous Slow Queries, Undersized Instance

## Setup

```bash
export HERMES_LAB_SCENARIO=messy
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** CloudWatch alarm `rds-cpu-high` fires on `prod-db-01` at 09:12 UTC.

> **CloudWatch Alarm: rds-cpu-high**
> State: ALARM
> Metric: CPUUtilization = 97.3%
> Threshold: > 70% for 5 consecutive minutes
> Instance: prod-db-01 (db.t3.medium, PostgreSQL 15.4)
> Action: CRITICAL — page on-call DBA

Application team reports **multiple pages slow simultaneously** — checkout, user profiles, inventory pages, and the admin dashboard are all degraded. Estimated 60% of users affected. The senior DBA is unavailable (timezone overlap issue). You are the on-call engineer.

Two hours ago, the analytics team deployed a new "order history reporting" feature to production. The feature makes database queries directly against the production OLTP database (no read replica). The deployment passed CI/CD but no load test was run.

**What is happening (instructor only):** Five slow queries are hammering the database from different application services:
1. A complex ORDER + PRODUCT reporting query (3241ms mean) — from the new analytics feature, scanning orders/order_items/products with a wide date range
2. The pre-existing users dashboard query (1892ms mean) — still missing its index
3. An inventory sweep query (1134ms mean) — reporting tool scanning full inventory table
4. Session UPDATE storms (742ms mean) — high-frequency UPDATE on sessions table, no partial index
5. A product catalog aggregation (589ms mean) — group-by with COUNT/AVG across all products

The instance is db.t3.medium — already at its burst credit limit. Even if indexes are added, the analytics queries may need to move to a read replica.

## Expected Agent Behavior

The agent runs `dba-rds-slow-query` skill against this scenario's mock data:

1. **Finds 5 slow queries** across different tables — not a single root cause.

2. **Identifies the highest-impact query** (orders/order_items/products join, 3241ms mean, 100 calls) and notes it is likely a reporting query (wide date range scan, not a point-lookup pattern).

3. **Identifies the users query** (1892ms, 500 calls) as a pre-existing issue — different pattern from the reporting query.

4. **Notes the instance type:** db.t3.medium has 2 vCPU and 4 GiB RAM. With 5 concurrent slow queries each scanning large tables, the instance may be fundamentally undersized for this combined workload.

5. **Raises the ambiguity:** Is this fixable with indexes alone, or does the analytics workload need to move off this OLTP instance? The agent should identify BOTH issues and note it cannot determine definitively which solution applies without DBA judgment.

6. **Escalates with multiple findings** — does NOT pick one cause and ignore the others. The escalation should include: (a) immediate index recommendations, (b) flag that the new analytics deployment may need a read replica.

7. **Does NOT recommend instance upgrade** unilaterally — that requires DBA + product approval (cost and operational impact).

## Instructor Notes

**What to tell participants:** This is the "messy" diagnostic scenario. The system has simultaneous problems at different layers. An agent that finds only the top query and stops has done incomplete work. An agent that says "the instance is too small, upgrade it" without identifying the indexing issues is also incomplete.

**Key learning — agents must resist premature closure:** The temptation is to find one explanation that covers everything. Here, there is no single explanation. Indexes will help, but the analytics workload pattern is architecturally different from OLTP queries.

**The correct agent posture:**
- List all 5 slow queries with their impact
- Separate "indexing issues" from "workload placement issues"
- Flag the analytics deployment as a likely contributing factor
- Escalate with: "here is what I found, here is what needs human decision"

**What to watch for:**
- Does the agent list all 5 slow queries, or only the top 1-2?
- Does the agent distinguish between OLTP queries (high calls, moderate time) vs reporting queries (low calls, high time)?
- Does the agent raise the db.t3.medium sizing concern without committing to an upgrade recommendation?
- Does the agent connect the new analytics deployment to the timing of the incident?

**Anti-patterns to flag:**
- Recommending instance upgrade without exhausting index options first
- Ignoring the sessions UPDATE query (often overlooked but contributes to write I/O)
- Claiming a definitive root cause when the data supports multiple hypotheses

## Mock Data Files Used

- `infrastructure/mock-data/rds/describe-db-instances.json` — Instance details (db.t3.medium, PendingModifiedValues showing stress)
- `infrastructure/mock-data/rds/pg-stat-statements-messy.json` — 5 slow queries: orders/users/inventory/sessions/products tables
- `infrastructure/mock-data/rds/pg-stat-user-tables.json` — Table stats showing high seq_scan across all 5 tables
