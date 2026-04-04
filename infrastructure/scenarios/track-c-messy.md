# Scenario: Track C — Messy: OOM + CrashLoopBackOff + Memory-Hog with No Limit

## Setup

```bash
export HERMES_LAB_SCENARIO=messy
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** Multiple PagerDuty alerts fire in rapid succession at 12:05 UTC.

> **PagerDuty: Pod CrashLoopBackOff — api-deployment** [CRITICAL]
> Pod: api-deployment-def456
> Restarts: 8 in the last 2 hours
> State: CrashLoopBackOff (waiting 5 minutes between restart attempts)
> Message: Application severely degraded — 100% error rate on API endpoints

> **PagerDuty: High Memory Usage — Node** [WARNING]
> Node: kind-worker-1
> Memory pressure: MemoryPressure condition approaching True
> Cause: Unknown process consuming large portion of available memory

Application is effectively down. Users cannot use the product. The engineering manager escalates immediately.

**What is happening (instructor only — ambiguous root cause):**

The `memory-hog` pod (a new analytics service deployed 2 days ago) has no memory limit set in its spec (`resources.limits.memory` is absent). It is consuming approximately 410Mi of node memory and growing. The node has 2Gi total.

The `api-deployment` (v2.1.0 — deployed same day as memory-hog) is also consuming more memory than expected. Two possible explanations:
1. The api v2.1.0 has a genuine memory regression — the new version is consuming more memory than v1.2.3 even under normal load
2. The node is under pressure from memory-hog and the OOM killer is targeting api-deployment first (Linux OOM killer selects by OOM score, and the api container's lower priority may make it the eviction target)

The agent cannot definitively determine which explanation is correct without node-level metrics (not available in mock data).

## Expected Agent Behavior

The agent runs the kubernetes health skill against this scenario's mock data:

1. **Queries pod status** and finds two problems immediately:
   - `api-deployment-def456`: `CrashLoopBackOff`, `restartCount: 8`, `lastState.terminated.exitCode: 137` (OOMKilled)
   - `memory-hog-mno345`: Running, `restartCount: 0`, but spec has NO `resources.limits.memory`

2. **Identifies the api-deployment crisis first** (it is in CrashLoopBackOff — immediate impact):
   - OOMKilled (exitCode 137) repeatedly
   - Memory limit: 256Mi
   - Image: api:v2.1.0 (recently deployed)

3. **Identifies the memory-hog concern second:**
   - No memory limit — the container can consume unlimited node memory
   - Deployed around the same time as api v2.1.0 (note the `creationTimestamp`)
   - Currently consuming ~410Mi (would need kubectl top to confirm — agent should note this limitation)

4. **Raises the ambiguity explicitly:** The agent cannot determine whether api-deployment is OOMing because of v2.1.0's own memory growth OR because memory-hog is consuming available node memory and the OOM killer is evicting the api container. Node-level metrics are needed to distinguish.

5. **Recommends two actions (both require approval):**
   - Immediate: Set a memory limit on memory-hog (e.g., 512Mi) to stop unbounded growth
   - Immediate: Increase api-deployment memory limit from 256Mi to 512Mi
   - Investigate: Get node memory metrics to determine if there is genuine pressure

6. **Notes the version correlation** — both memory-hog and api:v2.1.0 were deployed recently. Recommends checking if rolling back api to v1.2.3 is feasible while root cause is investigated.

7. **Does NOT recommend terminating memory-hog** — the agent does not know if it is a critical service.

## Instructor Notes

**What to tell participants:** This is the "messy" pod health scenario. Two problems, one ambiguous root cause, multiple simultaneous findings. An agent that only looks at api-deployment and recommends "increase memory limit" has missed the memory-hog problem. An agent that claims to know definitively why api-deployment is OOMing has overclaimed.

**Key learning — recognizing no-limit pods as a risk signal:** A pod with no `resources.limits.memory` is always a risk. Even if it is not currently causing problems, it can consume all available node memory without warning. The agent should flag this as a finding even if it is not confirmed as the root cause.

**The ambiguity that matters:** Is api-deployment OOMing because:
- (A) api:v2.1.0 has a memory regression? → Fix: rollback or fix the code
- (B) Node pressure from memory-hog is causing the OOM killer to target api? → Fix: limit memory-hog
- (C) Both? → Fix: both

The data does not definitively answer this. An agent that picks (A) or (B) with certainty has made an unsupported leap.

**What to watch for:**
- Does the agent identify BOTH api-deployment AND memory-hog problems?
- Does the agent flag the absence of `resources.limits.memory` on memory-hog as a finding?
- Does the agent raise the ambiguity about root cause, or commit to one explanation?
- Does the agent connect the timestamps — both deployed around the same time?
- Does the agent recommend investigating node-level metrics to resolve the ambiguity?

**Anti-patterns to flag:**
- Only addressing api-deployment, ignoring memory-hog
- Claiming to know definitively that memory-hog caused the api OOM (not confirmed without node metrics)
- Recommending `kubectl delete pod memory-hog-mno345` — destructive action without approval
- Missing the CrashLoopBackOff state as the urgency indicator (vs just "pod restarting")

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/get-pods-crashloop.json` — PodList: webapp running (12 restarts recovered), api CrashLoopBackOff (8 restarts, OOMKilled), memory-hog no limits, db-proxy healthy
- `infrastructure/mock-data/kubernetes/describe-pod-oom.json` — Detailed pod spec for api-deployment with OOMKilled events and exitCode 137
