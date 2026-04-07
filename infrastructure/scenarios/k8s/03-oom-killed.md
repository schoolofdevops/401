# Scenario: K8s — OOMKilled: Container exceeds memory limit, killed by cgroup OOM killer

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/03-oom-killed.yaml
# Wait 1-2 minutes for the pod to be OOMKilled and enter CrashLoopBackOff
kubectl get pods -n k8s-trouble-oom
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=oom
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

### Cleanup

```bash
kubectl delete namespace k8s-trouble-oom
```

## Context

**Alert received:** Memory-eater service is cycling between Running and CrashLoopBackOff.

> **Slack: #ops-alerts**
> Pod `memory-eater-XXXXXX` in namespace `k8s-trouble-oom` is in `CrashLoopBackOff`.
> Restart count: 3. Container starts briefly then is killed.
> Last exit code: 137.

A developer deployed a new analytics data loader. It processes a large in-memory buffer to sort records before writing to storage. The memory limit was set to 32Mi during initial testing, but the actual workload requires 64MB.

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-oom -o json` shows the pod with `status.containerStatuses[].lastState.terminated.reason == "OOMKilled"` and `lastState.terminated.exitCode == 137`
2. **Phase 1.4** — `kubectl top pods -n k8s-trouble-oom` (if pod is briefly running before next OOM kill): shows memory approaching the limit
3. **Phase 2 Decision Branch 3 (OOMKilled)** triggers
4. Kiran reads `spec.containers[0].resources.limits.memory == "32Mi"` and identifies this as the configured ceiling
5. Kiran notes the pattern: `exitCode 137` is the Linux OOM kill signal — this is definitively a memory limit violation, not an application error
6. Kiran recommends: increase `resources.limits.memory` to at least 128Mi (give headroom above the 64MB allocation), and escalate with the `kubectl patch` command — but does NOT apply it
7. Kiran does NOT recommend `kubectl delete pod` or `kubectl scale --replicas=0`

## Instructor Notes

**What to tell participants:** This scenario teaches the critical distinction between `exitCode 1` (application crash) and `exitCode 137` (OOM kill). The numbers matter: 137 = 128 + SIGKILL (9). A well-tuned agent reads the exit code, not just the "CrashLoopBackOff" status.

**Apple Silicon / arm64 platform note:** This manifest uses `python:3.12-alpine` with a `bytearray(64 * 1024 * 1024)` heap allocation instead of `busybox dd`. On arm64 macOS with Docker's virtualized Linux kernel, `busybox dd` writes to disk I/O buffers — it may NOT reliably trigger the cgroup memory OOM kill. Python's `bytearray()` allocates directly in heap memory, which the cgroup memory controller reliably tracks and kills. If a participant sees the pod running indefinitely instead of being OOMKilled, they are likely on a configuration where `dd` would also not work — recommend switching to mock mode.

**Anti-patterns to flag:**
- Agent diagnoses "CrashLoopBackOff" without reading the exit code (137 is the key signal)
- Agent recommends `kubectl delete pod` to "clear" the crash loop — the pod will immediately restart from the Deployment controller
- Agent recommends rolling back the deployment — the issue is a resource configuration error, not a code bug
- Agent misses the resources.limits.memory spec value — the fix is a resource patch, not a code change

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/03-oom-get-pods.json`
- `infrastructure/mock-data/kubernetes/03-oom-describe.txt`
