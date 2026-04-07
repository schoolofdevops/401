# Scenario: K8s — ImagePullBackOff: Deployment cannot pull image from nonexistent registry

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/01-image-pull-backoff.yaml
# Wait ~30 seconds for the pod to enter ImagePullBackOff
kubectl get pods -n k8s-trouble-image-pull
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=image-pull
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

### Cleanup

```bash
kubectl delete namespace k8s-trouble-image-pull
```

## Context

**Alert received:** New deployment to k8s-trouble-image-pull namespace fails to roll out.

> **Slack: #ops-alerts**
> Deployment `web` in namespace `k8s-trouble-image-pull` has 0/1 available replicas after 5 minutes.
> Pod `web-XXXXXX` is in `ImagePullBackOff`.

The deployment was just submitted by a developer who claims "the image works fine on my machine."

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-image-pull -o json` shows the pod with `status.containerStatuses[].state.waiting.reason == "ImagePullBackOff"` (or `ErrImagePull` during initial attempts)
2. **Phase 1.2** — `kubectl describe pod` Events table contains `Failed to pull image "nonexistent-registry.io/fake-app:v1.0.0"`
3. **Phase 2 Decision Branch 1 (ImagePullBackOff)** triggers
4. Kiran identifies: image references `nonexistent-registry.io` (a private/nonexistent registry), no `imagePullSecrets` present in pod spec
5. Kiran escalates with: image string `nonexistent-registry.io/fake-app:v1.0.0`, namespace, registry host, and the recommendation: "Verify image path; if private registry, attach an imagePullSecret"
6. Kiran does NOT attempt to `kubectl edit deployment` or `kubectl set image`

## Instructor Notes

**What to tell participants:** This is the simplest of the 6 scenarios — a clear, single-cause failure. It establishes the diagnostic baseline before the more ambiguous scenarios. Watch for: does the agent capture the exact image string in the escalation? Does it correctly identify there is no imagePullSecret rather than guessing about credentials?

**Anti-patterns to flag:**
- Agent recommends `kubectl create secret docker-registry` to "fix" the credentials — destructive without knowing the actual registry
- Agent says "the image is wrong" without quoting the exact image string from spec
- Agent runs `kubectl exec` to "check from inside the pod" (impossible — pod never started)

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/01-image-pull-get-pods.json`
- `infrastructure/mock-data/kubernetes/01-image-pull-describe.txt`
