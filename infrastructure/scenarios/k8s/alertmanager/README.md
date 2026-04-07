# AlertManager to Hermes Agent Webhook Flow

**Phase 8 / TRIG-01** — Real Prometheus + AlertManager stack on KIND firing on the Phase 6 `crashloop2` scenario.

## Flow Diagram

```
+----------------------+
| kubectl apply -f     |
| 02-crashloop-        |
| backoff.yaml         |
| (Phase 6)            |
+----------+-----------+
           | creates
           v
+----------------------+    scrapes    +----------------------+
| Pod crasher in       |<--------------| kube-state-metrics   |
| k8s-trouble-         |               | (in monitoring ns)   |
| crashloop ns         |               +----------+-----------+
| (restarts every ~5s) |                          | exposes
+----------------------+                          v
                                       +----------------------+
                                       | Prometheus           |
                                       | evaluates rule       |
                                       | PodCrashLooping      |
                                       +----------+-----------+
                                                  | fires after
                                                  | increase > 2
                                                  | for 30s
                                                  v
                                       +----------------------+
                                       | AlertManager         |
                                       | receiver             |
                                       | hermes-webhook       |
                                       +----------+-----------+
                                                  | POST
                                                  | host.docker.internal
                                                  | :8644/webhooks/
                                                  | alertmanager
                                                  v
                                       +----------------------+
                                       | Hermes gateway       |
                                       | webhook adapter      |
                                       | (subscription:       |
                                       |  alertmanager)       |
                                       +----------+-----------+
                                                  | spawns agent run
                                                  v
                                       +----------------------+
                                       | sre-k8s-pod-health   |
                                       | skill diagnoses pod  |
                                       | -> output to terminal|
                                       +----------------------+
```

## Files

- `prometheus-rules.yaml` — PrometheusRule CRD (one alert: `PodCrashLooping`)
- `alertmanager-config.yaml` — Reference copy of the AlertManager receiver config
- `README.md` — This file

The runtime AlertManager config lives in `infrastructure/helm/prometheus-lab-values.yaml`
under the `alertmanager.config` block. Edit that file to change production AM behavior.

## Apply

```bash
# 1. Ensure AlertManager is enabled in the helm release
helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f infrastructure/helm/prometheus-lab-values.yaml

# 2. Apply the PrometheusRule CRD
kubectl apply -f infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml

# 3. Start Hermes webhook gateway on host (another terminal)
hermes gateway run

# 4. Subscribe the alertmanager webhook (another terminal)
hermes webhook subscribe alertmanager \
  --events "alertmanager-alert" \
  --prompt "AlertManager PodCrashLooping alert fired. Details: {alerts}. Load the sre-k8s-pod-health skill and diagnose the affected pod in the namespace shown in the alert labels." \
  --skill "sre-k8s-pod-health" \
  --deliver local

# 5. Apply the Phase 6 crashloop2 scenario
kubectl apply -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml

# 6. Wait ~2 min — AlertManager fires -> Hermes receives -> agent runs
```

## IMPORTANT: Prompt template array syntax

Hermes `_render_prompt` does NOT support array index access. Use `{alerts}` (which
expands to the full JSON-serialized alerts array) and let the agent parse the array
itself. **Do NOT** use `{alerts[0].labels.pod}` — this will render as a literal string,
not the pod name.

The prompt above instructs the agent to "diagnose the affected pod in the namespace
shown in the alert labels" — the agent reads `{alerts}` and extracts the namespace
and pod name via its LLM reasoning.

## Cleanup

```bash
kubectl delete -f infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml
kubectl delete -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml
hermes webhook unsubscribe alertmanager
```

## Linux Docker Note

On Linux with native Docker (not Docker Desktop), `host.docker.internal` does not
resolve from inside KIND pods by default. Two options:

1. **Use the extraPortMapping** (already in `infrastructure/kind/cluster-config.yaml`) — port 8644
   is mapped from the KIND container to the host. Change the receiver URL to
   `http://172.17.0.1:8644/webhooks/alertmanager` (docker0 bridge gateway IP).
2. **Hardcode the docker0 bridge IP** — change the receiver URL to
   `http://172.17.0.1:8644/webhooks/alertmanager`.

macOS Docker Desktop resolves `host.docker.internal` natively — no change needed.
