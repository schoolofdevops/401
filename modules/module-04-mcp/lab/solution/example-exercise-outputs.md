# Module 04 Lab — Example Exercise Outputs

**Purpose:** Reference outputs for facilitators and participants. Your outputs will vary based on actual cluster state.

---

## Exercise 4.1: Kubernetes-Only Query

### Agent Response (Example)

```
I've checked your Kubernetes cluster for pods with multiple restarts. Here are the findings:

Pods with 2+ Restarts (Last 24 Hours)
====================================

Namespace: app
Pod: reference-app-api-gateway-xyz123
├─ Restarts: 3
├─ Status: Running
└─ Last restart: 2 hours ago (CrashLoopBackOff recovered)

Namespace: app
Pod: reference-app-worker-deployment-abc456
├─ Restarts: 1
├─ Status: Running
└─ Last restart: 6 hours ago

Namespace: kube-system
Pod: coredns-xyz789
├─ Restarts: 0
├─ Status: Running
└─ Note: Core DNS stable

Summary:
- 2 pods have restarted in the last 24 hours
- The API gateway pod is the concerning one (3 restarts, most recent 2 hours ago)
- Worker pod restarted once but has been stable for 6+ hours
- Other system pods are healthy
```

### Expected Observations

- **API gateway pod:** 3 restarts in ~6 hours suggests a persistent issue (not a one-off)
- **Timing:** Most recent restart 2 hours ago means the problem might still be active
- **Worker pod:** Only 1 restart and 6 hours stable = less concerning

---

## Exercise 4.2: PostgreSQL-Only Query

### Agent Response (Example)

```
I've queried your refapp database. Here are the findings:

Database Overview
=================

Events Table:
├─ Total records: 1,247
└─ Schema: id, source, event_type, payload (jsonb), created_at

Items Table:
├─ Total records: 42
└─ Schema: id, name, description, status, created_at, updated_at

Time Range (events):
├─ Earliest event: 2026-04-05 10:23:15 UTC
└─ Latest event:   2026-04-05 14:47:02 UTC
└─ Duration: 4 hours 24 minutes

Event Distribution Over Time:
├─ 10:00–11:00 UTC: 150 events
├─ 11:00–12:00 UTC: 280 events
├─ 12:00–13:00 UTC: 420 events (peak)
├─ 13:00–14:00 UTC: 310 events
└─ 14:00–15:00 UTC: 87 events

Data Quality:
├─ Null values in type: 0
├─ Duplicate event IDs: 0
└─ Orphaned foreign keys: 0
```

### Expected Observations

- **Peak at noon:** 420 events between 12:00–13:00. Correlate with pod restarts (Exercise 4.3).
- **Recent drop:** Event volume fell from 420 to 87 in the last hour. Could coincide with API gateway pod issues.
- **Data integrity:** No nulls or duplicates = good data quality.

---

## Exercise 4.3: Cross-Platform Query — Kubernetes + PostgreSQL

### Agent Response (Example)

```
I've correlated Kubernetes pod activity with PostgreSQL connection and event patterns.

POD STATUS & RESTARTS
=====================

API Gateway Analysis (reference-app-api-gateway):
├─ Pod name: reference-app-api-gateway-xyz123
├─ Restarts: 3
├─ Current status: Running
├─ Memory usage: 512 MB (of 1 GB limit) — healthy
├─ CPU usage: 150m (of 500m limit) — moderate
├─ Restart timestamps:
│  ├─ 12:05 UTC (OOMKilled - memory pressure)
│  ├─ 12:30 UTC (Restarted cleanly)
│  └─ 14:15 UTC (Restarted, unknown reason)
└─ Last event: Pod is Running, no recent errors

Worker Pod Analysis (reference-app-worker):
├─ Pod name: reference-app-worker-abc456
├─ Restarts: 0
├─ Current status: Running
├─ Events: Stable for 24 hours
└─ Connects to database for event processing

DATABASE CONNECTION & EVENT ANALYSIS
=====================================

Current PostgreSQL Status:
├─ Active connections: 12 (of 100 max)
├─ Connection pool utilization: 12%
└─ Status: Healthy

Event Volume Timeline:
├─ 11:00–12:00 UTC: 280 events, 8 connections avg
├─ 12:00–12:30 UTC: 320 events, 20 connections avg ← SPIKE
├─ 12:30–13:00 UTC: 100 events, 6 connections avg ← DIP
│   (Coincides with API gateway restart #2)
├─ 13:00–14:00 UTC: 310 events, 12 connections avg
└─ 14:00–15:00 UTC: 87 events, 5 connections avg ← DIP (recent)

CORRELATION ANALYSIS
====================

Key Correlations:
1. API Gateway Restart #1 (12:05 UTC)
   └─ Cause: OOMKilled
   └─ Coinciding DB event: Connection spike to 20 (normally 8–12)
   └─ Hypothesis: Restart relieved memory pressure on pod

2. Event Volume Dips (12:30–13:00 & 14:00–15:00)
   └─ First dip: Right after API gateway restart #2
   └─ Second dip: Following restart #3
   └─ Hypothesis: API gateway restarts cause brief traffic loss

3. Most Recent Restart (14:15 UTC)
   └─ Currently showing 87 events/hour (lowest)
   └─ Only 30 min of data since restart
   └─ Likely cause: Ongoing issue, not yet resolved

ROOT CAUSE HYPOTHESIS:
The API gateway pod is experiencing repeated memory exhaustion under load.
- Connection spike to 20 causes memory to exceed the 1 GB limit
- Pod gets OOMKilled
- Connection pool drains
- Pod restarts and connections reset
- Volume recovers temporarily
- The cycle repeats every 1–2 hours

RECOMMENDATION:
1. Increase API gateway pod memory limit from 1 GB to 2 GB
2. Enable connection pooling on the database side (PgBouncer)
3. Check for memory leaks in the application code (Module 07 suggests Git-based investigation)
```

### Key Correlations to Note

- **12:05 UTC:** OOMKill (pod restart) correlates with connection spike
- **12:30 UTC:** Event volume drops sharply after restart #2
- **14:15 UTC:** Most recent restart; event volume is now lowest
- **Pattern:** Restarts happen every ~2 hours, always after connection/memory spikes

---

## Exercise 4.4: Cross-Platform Query — Kubernetes + PostgreSQL + GitHub

### Agent Response (Example)

```
I've integrated data from Kubernetes, PostgreSQL, and Git history to trace the root cause.

KUBERNETES EVENTS (Last 2 Hours)
================================

12:05 UTC — API Gateway Crash
├─ Event: OOMKilled (Out of Memory)
├─ Container: reference-app-api-gateway
├─ Memory limit: 1 GB
├─ Memory used at crash: 1.2 GB (exceeded limit)
└─ Action: Pod automatically restarted by kubelet

12:30 UTC — API Pod Restart
├─ Event: Container started
├─ Status: Running
├─ Uptime after restart: 1 hour 45 min (until next restart)
└─ No immediate errors logged

14:15 UTC — API Pod Restart (Most Recent)
├─ Event: Container started
├─ Status: Running
├─ Uptime: 30 minutes (current)
└─ No errors logged yet

POSTGRESQL ANOMALIES
====================

Data Quality Check:
├─ Null values in event_type: 0
├─ Duplicate event IDs: 0
├─ Orphaned foreign keys: 0
└─ Data integrity: CLEAN

Connection Pattern Anomalies:
├─ Normal baseline: 8–12 connections
├─ Before restart #1: 20 connections (spike)
├─ Before restart #2: 18 connections (spike)
├─ Current: 12 connections (settling)
└─ Pattern: Connection spikes precede memory exhaustion

Suspicious Activity:
├─ Vote batch inserts are larger than usual:
│  ├─ Typical batch: 50–100 votes
│  ├─ Recent batches: 500–1000 votes
│  ├─ Increased DB I/O load: Confirmed in connection counts
│  └─ Likely cause: Batch processing code changed

GITHUB RECENT COMMITS
====================

Commits touching voting or batch processing (last 48 hours):

1. Commit: 7d8e2c9 (3 hours ago)
   ├─ Author: Bob
   ├─ Message: "Increase vote batch size from 100 to 1000 for throughput"
   ├─ Files changed:
   │  ├─ voting/batch_processor.py
   │  ├─ voting/models.py
   │  └─ tests/test_batch.py
   ├─ Key lines:
   │  └─ BATCH_SIZE = 1000  # increased from 100
   └─ Timestamp: 2026-04-05 11:15 UTC

2. Commit: a3f2b1c (2 hours ago)
   ├─ Author: Alice
   ├─ Message: "Add vote deduplication logic to prevent duplicate votes"
   ├─ Files changed:
   │  ├─ voting/vote_handler.py
   │  └─ voting/models.py
   ├─ Key lines:
   │  └─ if vote_exists(session_id, option_id): return "duplicate"
   └─ Timestamp: 2026-04-05 12:05 UTC

3. Commit: f4g3d2e (1 day ago)
   ├─ Author: Charlie
   ├─ Message: "Refactor vote caching to in-memory store"
   ├─ Files changed:
   │  ├─ voting/cache.py
   │  └─ requirements.txt
   ├─ Key lines:
   │  └─ from cachetools import LRUCache
   │  └─ cache = LRUCache(maxsize=10000)  # unbounded cache growth
   └─ Timestamp: 2026-04-05 04:30 UTC

ROOT CAUSE ANALYSIS
===================

Timeline Correlation:

04:30 UTC ← Commit f4g3d2e (LRU Cache, maxsize=10000)
           Memory impact: Starts accumulating vote cache

11:15 UTC ← Commit 7d8e2c9 (Batch size 100 → 1000)
           Impact: 10× more votes per batch → 10× more cache entries per batch

12:05 UTC ← OOMKill #1
           Memory: Cache + 1000-vote batch = 1.2 GB > 1 GB limit
           Restart helps, but the root cause remains

12:05 UTC ← Commit a3f2b1c (Dedup logic deployed)
           Impact: Dedup runs on every vote, adding memory overhead
           Also adds DB query per vote in dedup check

14:15 UTC ← OOMKill #2
           Pattern repeats; problem unsolved

ROOT CAUSE: Triple Memory Pressure
===================================

1. LRU Cache (f4g3d2e):
   └─ Unbounded growth of vote cache in memory
   └─ No eviction policy (just maxsize, but fills instantly with 1000-vote batches)

2. Batch Size Increase (7d8e2c9):
   └─ 10× larger batches = 10× more cache pollution per operation
   └─ Single batch now exceeds 100 MB of memory

3. Dedup Logic (a3f2b1c):
   └─ Adds DB query per vote (synchronous, not batched)
   └─ Multiplied by 1000 votes per batch = 1000 extra DB queries
   └─ Increases memory for connection pool

SOLUTION RECOMMENDATIONS (In Order)
====================================

Immediate (next 30 min):
1. Rollback commit f4g3d2e (LRU Cache refactor)
   └─ Remove unbounded cache, restore database caching

2. Reduce batch size back to 100 (revert 7d8e2c9)
   └─ Trade throughput for stability
   └─ Can optimize later with proper caching

Short-term (next release):
3. Batch the dedup logic (a3f2b1c improvement)
   └─ Instead of N DB queries for N votes, do 1 query with WHERE IN
   └─ Reduce dedup DB load by 99%

4. Implement proper cache eviction
   └─ Use Redis instead of in-process LRU
   └─ Shared cache across pod replicas (bonus: better hit rate)

Long-term (next sprint):
5. Add memory monitoring to CI/CD
   └─ Load test with 1000-vote batches before merge
   └─ Set memory alerts at 75% and 90%

CONFIDENCE LEVEL: HIGH
Commit timeline perfectly aligns with restart timeline.
Three changes compounded: unbounded cache + larger batches + extra queries.
```

### Key Insights from This Integration

- **Commit f4g3d2e (4:30 UTC):** Introduced unbounded LRU cache
- **Commit 7d8e2c9 (11:15 UTC):** Made the cache filling 10× faster
- **Commit a3f2b1c (12:05 UTC):** Added dedup logic, multiplying DB load
- **Result:** OOMKill at 12:05 UTC, repeating every ~2 hours
- **Solution:** Revert all three, fix in next release with proper caching and batching

---

## Completed Comparison Template (Example)

### Manual Workflow

**Steps:**
1. Open terminal, run `kubectl get pods -A` to find API pod
2. Copy pod name, run `kubectl describe pod reference-app-api-gateway-xyz -n app` for restart count
3. Open new terminal, SSH to a node running the pod
4. Check pod logs: `kubectl logs reference-app-api-gateway-xyz -n app` and `--previous`
5. Open psql: `psql -h localhost -p 5433 -U refapp refapp`
6. Run query: `SELECT COUNT(*) FROM events WHERE created_at > NOW() - INTERVAL '1 hour'`
7. Run query: `SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active'`
8. Open GitHub web UI, search commits touching `voting/` or `batch_processor.py`
9. Read commit messages, examine changed files
10. Manually compare timestamps: pod restarts vs. vote volume dips vs. commits
11. Write findings in a text document

**Time estimate:** 12–15 minutes
**Context-switches:** 6+ (kubectl → logs → psql → GitHub web → text editor)
**Error surface:** High (command typos, miscopied timestamps, missed correlations)

---

### MCP Workflow

**Steps:**
1. Open Claude Code
2. Send one prompt asking for integration of pod restarts, database activity, and commit history
3. Read integrated answer

**Time estimate:** 1–2 minutes
**Context-switches:** 0 (single conversation)
**Error surface:** Low (agent handles command syntax)

---

### Time Comparison

| Metric | Manual | MCP | Improvement |
|--------|--------|-----|-------------|
| Total time | 12 min | 1.5 min | **8× faster** |
| Context switches | 6+ | 0 | **Eliminated** |
| Commands run | ~20 | 1 | **Fewer errors** |
| Insight quality | Good | Excellent (integrated) | **More actionable** |

---

## Lessons Encoded

**Lesson 1: Context Engineering Scale**

Manual workflow requires YOU to integrate. MCP requires YOU to define the context (tools, servers, resources). The agent integrates. This scales: adding a 4th tool adds 15 seconds to the integration, not 3 minutes.

**Lesson 2: Temporal Correlation**

The agent automatically noticed:
- Commit 7d8e2c9 at 11:15 UTC → Batch size increase
- OOMKill at 12:05 UTC → 50 minutes later
- Commit a3f2b1c at 12:05 UTC → Same time as OOMKill (deployment lag)

A human would miss these micro-timing correlations. An agent with calendar context doesn't.

**Lesson 3: Capabilities Gap Filled**

From Module 03, platform AI cannot:
- Query your database directly ✓ (PostgreSQL MCP server)
- Access your Kubernetes cluster ✓ (Kubernetes MCP server)
- Read your Git history ✓ (GitHub MCP server)
- Correlate across three systems ✓ (Agent context engineering)

MCP + context engineering = problem solved.

---

## Using This Reference in Your Course Delivery

### For Facilitators

1. **If a participant struggles with Exercise 4.4:** Show them this example output. Ask: "Where do you see the three commits in your cluster state? Look for similar timestamps."

2. **During debrief:** Ask "How many hours of investigation time did this integration save you?" Expected answer: "3–4 hours of manual correlation." That's the value proposition.

3. **Extension:** Ask "What if you had added a 4th server (Terraform, AWS, Slack)?" Expected insight: "Just another entry in `.mcp.json`, but the answer would be even richer."

### For Participants

1. **If your outputs don't match exactly:** That's expected. Your cluster has different pods, different votes, different commits. The pattern is what matters: one question → multiple tools → integrated answer.

2. **If you don't see clear correlations:** Check timestamps carefully. Database/pod activity may be offset by a few minutes due to logging delays. Small offsets are still significant correlations.

3. **If you finish early:** Try adding a 4th server (Prometheus) and ask "What was CPU/memory at the time of each restart?" That deepens the diagnosis.

---

