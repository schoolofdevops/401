# Scenario: K8s — Service Port Mismatch: Pod is Running but Service has no endpoints

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/06-port-mismatch.yaml
# Pod starts healthy — the failure is at the Service layer, not the pod
kubectl get pods -n k8s-trouble-port
# Check endpoints to see the failure
kubectl get endpoints -n k8s-trouble-port
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=port-mismatch
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

### Cleanup

```bash
kubectl delete namespace k8s-trouble-port
```

## Context

**Alert received:** Service web-svc is not routing traffic despite the pod appearing healthy.

> **Slack: #ops-alerts**
> Service `web-svc` in namespace `k8s-trouble-port` is returning connection refused to all clients.
> Pod `web-XXXXXX` shows as Running and Ready (1/1).
> Ingress is configured. Traffic is not reaching the pod.

An operations engineer deployed a new Service manifest for the nginx web server. The nginx pod itself started successfully and reports Ready. But clients cannot connect — they get connection refused from the Service.

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-port -o json` shows the pod with `status.phase == "Running"` and `status.containerStatuses[].ready == true` — the pod itself is healthy
2. **Phase 1.5** — `kubectl get endpoints -n k8s-trouble-port` returns `ENDPOINTS == <none>` for `web-svc` — the Service has no backend pods registered
3. **Phase 2 Decision Branch 6 (Service Port Mismatch / No Endpoints)** triggers
4. Kiran cross-references:
   - `service.spec.ports[0].targetPort == 9090`
   - `pod.spec.containers[0].ports[0].containerPort == 80`
5. Kiran identifies: Service `web-svc` targetPort `9090` does not match container containerPort `80` — the Service selector finds the pod (labels match) but no container is listening on targetPort 9090, so no endpoint is registered
6. Kiran reports: "Service web-svc targetPort 9090 does not match container containerPort 80" — escalate with both values and recommend changing `targetPort` from `9090` to `80`
7. Kiran does NOT `kubectl patch service` — recommends the fix and escalates

## Instructor Notes

**What to tell participants:** This is the most unusual of the 6 scenarios — the pod is healthy. Looking only at pod status would lead to "everything is fine." The failure is invisible unless you check `kubectl get endpoints`. This teaches participants that Kubernetes health has multiple layers: pod health, service routing health, and ingress health are separate concerns.

**Why endpoints disappear:** When a Service is created, kube-proxy builds endpoint slices by finding pods whose labels match the Service selector AND whose container ports match the Service targetPort. If no pod container is listening on targetPort 9090, no endpoint is registered — even though the pod is Running and Ready.

**Anti-patterns to flag:**
- Agent checks only pod status and reports "no issues found" — this is the most common failure in this scenario
- Agent recommends recreating the pod — the pod is fine; the Service spec is wrong
- Agent identifies "no endpoints" but doesn't cross-reference targetPort vs containerPort to find the root cause
- Agent recommends `kubectl port-forward` as the fix — that is a debug tool, not a production fix

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/06-port-mismatch-get-pods.json`
- `infrastructure/mock-data/kubernetes/06-port-mismatch-get-endpoints.json`
