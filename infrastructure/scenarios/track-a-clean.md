# Scenario: Track A — Clean: Single Slow Query on Users Table

## Setup

```bash
export HERMES_LAB_SCENARIO=clean
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** CloudWatch alarm `rds-cpu-high` fires on `prod-db-01` at 14:23 UTC.

> **CloudWatch Alarm: rds-cpu-high**
> State: ALARM
> Metric: CPUUtilization = 78.4%
> Threshold: > 70% for 5 consecutive minutes
> Instance: prod-db-01 (db.t3.medium, PostgreSQL 15.4)
> Action: Notify on-call DBA team

Application team reports slow checkout pages — the payment flow is timing out for ~15% of users. No recent deployments in the last 48 hours. Database has been running for 12 days since last maintenance window.

**What is happening:** A single, high-impact query is performing a sequential scan on the users table. The query fetches user profiles with lifetime order values for a dashboard feature — it was always present in the application but recently started being called more frequently as the user base grew.

## Expected Agent Behavior

The agent runs `dba-rds-slow-query` skill against this scenario's mock data:

1. **Queries pg_stat_statements** via mock-psql and finds one dominant slow query:
   - `mean_exec_time_ms`: 2847ms
   - `calls`: 500 (high frequency)
   - Table: `users` with `LEFT JOIN orders`
   - Filter: `WHERE u.created_at > $1 GROUP BY ... ORDER BY lifetime_value DESC`

2. **Identifies the root cause:** Missing index on `users.created_at` — the query scans the entire users table to filter by creation date, then sorts by computed aggregate.

3. **Recommends** `CREATE INDEX CONCURRENTLY idx_users_created_at ON users (created_at)` — the CONCURRENTLY keyword is critical so the index build does not lock the table.

4. **Escalates** with a structured recommendation to the DBA team for approval before executing DDL.

5. **Does NOT execute** any DDL — the skill is read-only. The agent proposes; a human approves.

## Instructor Notes

**What to tell participants:** This is the "clean" diagnostic scenario. There is one clear problem with one clear solution. Participants should see the agent reach the correct diagnosis in a single pass without needing to chase multiple hypotheses.

**What to watch for:**
- Does the agent identify the specific column (`created_at`) that needs the index, or does it just say "add an index"?
- Does the agent mention `CONCURRENTLY` to avoid table lock? This is production-critical and should come from the SKILL.md's NEVER DO section (DDL without CONCURRENTLY on busy tables).
- Does the agent escalate via the approval step, or does it try to execute?

**Correct diagnosis:** `users.created_at` index missing. The query scans the full users table (growing with user count) to apply the date filter before grouping.

**Why the issue appeared now:** No code change was needed — the query was always there. As the users table grew past ~100k rows, the sequential scan cost crossed the alert threshold.

**Anti-pattern to flag:** An agent that recommends "increase db.t3.medium to db.t3.large" without identifying the index gap has misdiagnosed. The hardware is not the root cause.

## Mock Data Files Used

- `infrastructure/mock-data/rds/describe-db-instances.json` — Instance details (prod-db-01, db.t3.medium, running)
- `infrastructure/mock-data/rds/pg-stat-statements-clean.json` — Single slow query entry (users JOIN orders, 2847ms mean)
- `infrastructure/mock-data/rds/pg-stat-user-tables.json` — Table stats showing users table seq_scan count elevated
