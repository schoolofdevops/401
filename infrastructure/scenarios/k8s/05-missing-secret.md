# Scenario: K8s — Missing Secret: Pod stays Pending because referenced Secret does not exist

## Setup

### Live mode (KIND)

```bash
kubectl apply -f infrastructure/scenarios/k8s/05-missing-secret.yaml
# Pod will stay in ContainerCreating / CreateContainerConfigError — check immediately
kubectl get pods -n k8s-trouble-secret
```

### Mock mode (no Docker / Udemy fallback)

:::info Solo Learner
If you do not have Docker or KIND available, use mock mode to simulate this scenario.
:::

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=missing-secret
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

### Cleanup

```bash
kubectl delete namespace k8s-trouble-secret
```

## Context

**Alert received:** New service deployment is stuck at 0/1 available — pod never starts.

> **Slack: #ops-alerts**
> Deployment `app` in namespace `k8s-trouble-secret` has 0/1 available replicas.
> Pod `app-XXXXXX` is in `Pending` / `ContainerCreating` state.
> No restart count increment — the container has never started.

A developer deployed a new `app` service that reads credentials from a mounted Secret. The Secret was supposed to be created by the platform team before the deployment, but the deployment was submitted before the Secret was ready.

## Expected Agent Behavior

Kiran loads `sre-k8s-pod-health` and runs the procedure:

1. **Phase 1.1** — `kubectl get pods -n k8s-trouble-secret -o json` shows `status.phase == "Pending"` and `status.containerStatuses[].state.waiting.reason == "CreateContainerConfigError"`
2. **Phase 1.2** — `kubectl describe pod` Events table contains: `MountVolume.SetUp failed for volume "app-secret": secret "app-credentials" not found`
3. **Phase 2 Decision Branch 5 (Missing Secret / CreateContainerConfigError)** triggers
4. Kiran extracts the missing Secret name `app-credentials` from the Events message
5. Kiran confirms with `kubectl get secret app-credentials -n k8s-trouble-secret` — returns `Error from server (NotFound): secrets "app-credentials" not found`
6. Kiran escalates with: namespace `k8s-trouble-secret`, pod name, missing Secret name `app-credentials`, volume mount path `/secrets`, and the recommendation: "Create the missing Secret OR fix the deployment manifest to remove the secretName reference"
7. Kiran does NOT `kubectl create secret` to "fix" it — creating the secret without knowing the correct value is worse than escalating

## Instructor Notes

**What to tell participants:** This scenario demonstrates the Pending state — unlike the other 5 scenarios, this pod never starts at all. `restartCount` stays at 0. The container has not run even once. The failure is at the container creation stage (kubelet cannot mount the secret volume), not at the container runtime stage.

**Key diagnostic signal:** `CreateContainerConfigError` in the waiting reason, combined with the Events message naming the missing secret. The agent must read the Events section to find the specific secret name — the waiting reason alone does not name what is missing.

**Anti-patterns to flag:**
- Agent runs `kubectl logs` — impossible, the container has never started
- Agent recommends `kubectl create secret generic app-credentials --from-literal=password=dummy` — destructive if the actual secret value is unknown; should escalate instead
- Agent identifies "Pod is Pending" but doesn't drill into WHY (misses the CreateContainerConfigError reason)
- Agent doesn't extract the exact secret name from the Events — reports "a secret is missing" without naming it

## Mock Data Files Used

- `infrastructure/mock-data/kubernetes/05-missing-secret-get-pods.json`
- `infrastructure/mock-data/kubernetes/05-missing-secret-describe.txt`
