# Scenario: K8s — Liveness Probe Failure: Probe port mismatch causes kubelet to restart container

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/04-liveness-probe.yaml
# Wait ~30 seconds for the probe to fail (initialDelaySeconds: 3, periodSeconds: 5, failureThreshold: 3)
# Then watch CrashLoopBackOff appear as kubelet restarts the container
kubectl get pods -n k8s-trouble-liveness
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=liveness
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

### Cleanup

```bash
kubectl delete namespace k8s-trouble-liveness
```

## Context

**Alert received:** nginx deployment is CrashLoopBackOff despite the application appearing to start.

> **Slack: #ops-alerts**
> Pod `app-XXXXXX` in namespace `k8s-trouble-liveness` is in `CrashLoopBackOff`.
> Restart count: 4. Container starts and nginx initializes, but kubelet keeps killing it.
> Events show probe failures.

A developer recently added health check probes to the nginx deployment per security requirements. The nginx container itself starts successfully (you can see it respond on port 80) but the pod keeps restarting.

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-liveness -o json` shows `status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff"` with `restartCount: 4`
2. **Phase 1.2** — `kubectl describe pod` Events table contains two key messages:
   - `Liveness probe failed: Get "http://10.0.1.X:9999/health": dial tcp 10.0.1.X:9999: connect: connection refused`
   - `Container app failed liveness probe, will be restarted`
3. **Phase 2 Decision Branch 4 (Liveness Probe Failure)** triggers
4. Kiran cross-references `spec.containers[0].livenessProbe.httpGet.port == 9999` against `spec.containers[0].ports[0].containerPort == 80`
5. Kiran identifies the port mismatch: the liveness probe checks port 9999 but nginx only listens on port 80
6. Kiran recommends: change `livenessProbe.httpGet.port` from `9999` to `80` and escalate with both values in the recommendation
7. Kiran does NOT `kubectl edit deployment` — recommends the fix but does not apply it

## Instructor Notes

**What to tell participants:** This scenario is subtler than it first appears. The container IS starting successfully — nginx initializes and binds to port 80. But kubelet's liveness probe keeps checking port 9999, which nothing is listening on, and kills the container when the probe fails. The agent must read both the probe configuration AND the container port to identify the mismatch.

**What makes this scenario interesting:** The pod status shows `CrashLoopBackOff` but the root cause is not an application bug — it is a Kubernetes configuration error. This is a common operational mistake when developers add probes without knowing which port the container actually uses.

**Anti-patterns to flag:**
- Agent diagnoses "application is crashing" and recommends investigating nginx — nginx is fine, the probe config is wrong
- Agent reads the Events table but does not extract the specific port number (9999) from the error message
- Agent recommends `kubectl set image` to try a different nginx version — the container itself is not broken
- Agent does not compare probe port to containerPort — this comparison is the key diagnostic step

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/04-liveness-get-pods.json`
- `infrastructure/mock-data/kubernetes/04-liveness-describe.txt`
