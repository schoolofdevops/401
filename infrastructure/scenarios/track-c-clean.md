# Scenario: Track C — Clean: Single Pod OOM Kill, Clear Memory Limit

## Setup

```bash
export HERMES_LAB_SCENARIO=clean
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

## Context

**Alert received:** PagerDuty alert fires at 10:15 UTC.

> **PagerDuty: Pod Restarting — api-deployment**
> Severity: HIGH
> Namespace: default
> Pod: api-deployment-def456
> Restarts: 2 in the last 30 minutes
> Message: Application intermittently unavailable — 502 errors on health check

On-call engineer gets paged. The api-deployment handles the core REST API for the application. Two restarts in 30 minutes means users are seeing intermittent 502 errors during the restart window (typically 15-30 seconds each restart).

No recent deployments. The pod has been running this version for 3 days without issues.

**What is happening:** The api-deployment container has a memory limit of 256Mi set in its Kubernetes spec. The application's memory usage has grown gradually to exceed this limit (likely a slow memory growth pattern with no hard leak — just gradual accumulation). When memory hits the limit, the Kubernetes OOM killer terminates the container with exitCode 137 (`SIGKILL`). The pod restarts automatically due to `restartPolicy: Always`, recovers, and the cycle repeats.

This is a clean, single-cause scenario: one pod, one limit, one fix.

## Expected Agent Behavior

The agent runs the kubernetes health skill against this scenario's mock data:

1. **Queries pod status** via mock-kubectl and checks the default namespace.

2. **Identifies api-deployment-def456** as the problem pod — `restartCount: 2`, status `Ready: False`.

3. **Examines `lastState.terminated`** — finds `exitCode: 137` and `reason: OOMKilled`. This is the definitive OOM signature.

4. **Notes the memory configuration:**
   - `resources.requests.memory: 128Mi`
   - `resources.limits.memory: 256Mi`
   - Current restart pattern suggests actual usage is hitting or exceeding 256Mi

5. **Recommends** increasing `resources.limits.memory` to `512Mi` (doubling the limit gives headroom while keeping reasonable bounds). Notes the request may also need adjustment.

6. **Escalates** the recommendation for human approval before applying. The agent does not apply `kubectl patch` or edit the deployment.

7. **Does NOT restart the pod manually** — Kubernetes is already doing this via restartPolicy. Manual restart would add noise.

## Instructor Notes

**What to tell participants:** This is the "clean" pod health scenario. One pod with one clear OOM symptom. The exitCode 137 is the definitive signal — this is how OOMKilled pods always appear in Kubernetes.

**What to watch for:**
- Does the agent correctly read `lastState.terminated.exitCode: 137` as the OOM signal?
- Does the agent report the memory limit (256Mi) specifically, not just "the memory limit is too low"?
- Does the agent recommend doubling the limit (512Mi) or some other specific value, rather than a vague "increase it"?
- Does the agent avoid recommending a pod restart (Kubernetes handles this automatically)?

**Correct diagnosis:** api-deployment container hitting 256Mi memory limit, terminated with OOMKilled (exitCode 137). Fix: increase `resources.limits.memory` from 256Mi to 512Mi.

**Kubernetes teaching point:** ExitCode 137 = 128 + 9 (SIGKILL). Any pod with `reason: OOMKilled` in lastState was killed by the Linux OOM killer because the container hit its cgroup memory limit. This is distinct from application crashes (exitCode 1, 2, etc.) or liveness probe failures.

**Anti-patterns to flag:**
- Restarting the pod manually (redundant — Kubernetes already does this)
- Recommending deleting and re-creating the pod (same as restart but worse)
- Recommending "increase node memory" — the node is not the constraint, the pod limit is

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/get-pods-healthy.json` — PodList showing api-deployment with `restartCount: 2` and `lastState.terminated.reason: OOMKilled`
