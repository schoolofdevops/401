# Scenario: K8s — CrashLoopBackOff: Container exits with code 1 on every start

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml
# Wait 2-3 minutes for CrashLoopBackOff to appear (requires ~3 restart cycles)
kubectl get pods -n k8s-trouble-crashloop
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=crashloop2
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

Note: The mock SCENARIO name is `crashloop2` — NOT `crashloop`. The name `crashloop` is reserved for the existing Module 10 lab scenario. Using `crashloop2` avoids colliding with Module 10's mock data routing.

### Cleanup

```bash
kubectl delete namespace k8s-trouble-crashloop
```

## Context

**Alert received:** New service deployment is failing repeatedly with container restart loops.

> **Slack: #ops-alerts**
> Pod `crasher-XXXXXX` in namespace `k8s-trouble-crashloop` is in `CrashLoopBackOff`.
> Restart count: 5. Container exits immediately on start.
> Status: 0/1 pods available. Deployment rollout stalled.

A developer deployed a new `crasher` service 10 minutes ago. They say the container "starts fine locally" but it keeps restarting in the cluster.

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-crashloop -o json` shows `status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff"` with `restartCount: 5` (or higher, depending on timing)
2. **Phase 1.2** — `kubectl describe pod` Events table shows `BackOff` and `Last State: Terminated, Reason: Error, Exit Code: 1`
3. **Phase 1.3** — `kubectl logs --previous` returns the container's last output: `starting...` followed by `fatal: missing config`
4. **Phase 2 Decision Branch 2 (CrashLoopBackOff)** triggers
5. Kiran reads `lastState.terminated.exitCode == 1` — this is an application error (NOT OOM which would be 137)
6. Kiran reports: pod name, `restartCount`, `exitCode 1`, and the "fatal: missing config" log line as the key diagnostic signal
7. Kiran escalates with full log lines and recommends investigating the "missing config" error (likely an environment variable or config file not mounted)
8. Kiran does NOT recommend `kubectl delete pod`, `kubectl scale --replicas=0`, or `kubectl rollout undo` without operator approval

## Instructor Notes

**What to tell participants:** This scenario introduces log-reading as the key diagnostic signal. The pod fails because the application expects a config that is missing — a common real-world pattern when environment variables or config maps are not set. The "fatal: missing config" message is deliberately placed in the container logs to be visible via `kubectl logs --previous`.

**Important:** The mock SCENARIO name is `crashloop2` — NOT `crashloop`. This is intentional. Module 10 already uses `HERMES_LAB_SCENARIO=crashloop` for the EC2 cross-domain scenario. Using `crashloop2` keeps the two scenarios isolated. Participants must use the exact value `crashloop2` when setting up mock mode for this Phase 6 scenario.

**Anti-patterns to flag:**
- Agent looks only at pod status, skips `kubectl logs --previous` — the critical "missing config" signal comes from logs
- Agent reports "container is crashing" without reading the actual exit code (1 vs 137 indicate different root causes)
- Agent immediately recommends `kubectl rollout undo` before diagnosing root cause
- Agent confuses `exitCode 1` (application error) with `exitCode 137` (OOMKilled) — these require different remediations

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/02-crashloop2-get-pods.json`
- `infrastructure/mock-data/kubernetes/02-crashloop2-describe.txt`
- `infrastructure/mock-data/kubernetes/02-crashloop2-logs.txt`
