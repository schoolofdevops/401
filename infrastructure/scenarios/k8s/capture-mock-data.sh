#!/usr/bin/env bash
# capture-mock-data.sh — Capture real kubectl outputs from KIND into mock JSON parity files
#
# Usage:
#   1. Ensure KIND cluster is running: kind get clusters
#   2. Apply each scenario manifest, wait for it to reach the failure state, capture kubectl outputs
#   3. Repeat for all 6 scenarios
#
# Each scenario:
#   - Creates a dedicated namespace (k8s-trouble-*)
#   - Captures: get pods -o json, describe pod (text), and where applicable: logs --previous, get endpoints
#   - Writes to infrastructure/mock-data/kubernetes/<NN>-<scenario>-<command>.json|txt
#
# After successful capture: this script does NOT clean up — run the cleanup commands at the bottom
# manually so you can inspect the failures yourself.
#
# Prerequisites:
#   - kubectl connected to KIND cluster (kind create cluster --config infrastructure/kind/cluster-config.yaml)
#   - Sufficient cluster resources (1 control-plane + 2 workers, as in cluster-config.yaml)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SCENARIOS_DIR="${REPO_ROOT}/infrastructure/scenarios/k8s"
MOCK_DIR="${REPO_ROOT}/infrastructure/mock-data/kubernetes"

mkdir -p "$MOCK_DIR"

if ! command -v kubectl &> /dev/null; then
  echo "ERROR: kubectl not found in PATH" >&2
  exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
  echo "ERROR: kubectl cannot reach a cluster. Start KIND first:" >&2
  echo "  kind create cluster --config ${REPO_ROOT}/infrastructure/kind/cluster-config.yaml" >&2
  exit 1
fi

echo "Connected to cluster: $(kubectl cluster-info | head -1)"
echo "Saving mock files to: $MOCK_DIR"
echo ""

wait_for_state() {
  local ns="$1"
  local expected_status="$2"
  local timeout="${3:-120}"
  local elapsed=0
  echo "  Waiting for $ns to reach $expected_status (timeout ${timeout}s)..."
  while [ $elapsed -lt $timeout ]; do
    if kubectl get pods -n "$ns" 2>/dev/null | grep -qE "$expected_status"; then
      echo "  Reached $expected_status after ${elapsed}s"
      return 0
    fi
    sleep 5
    elapsed=$((elapsed + 5))
  done
  echo "  WARNING: Timed out waiting for $expected_status in $ns after ${timeout}s" >&2
  return 1
}

capture_scenario() {
  local manifest="$1"
  local ns="$2"
  local prefix="$3"
  local expected_status="$4"
  shift 4
  local extra_commands=("$@")

  echo "=== Capturing scenario: $prefix (namespace: $ns) ==="
  kubectl apply -f "${SCENARIOS_DIR}/${manifest}"
  wait_for_state "$ns" "$expected_status" 120 || true

  # Always capture pods JSON and describe text
  echo "  Capturing: kubectl get pods -n $ns -o json"
  kubectl get pods -n "$ns" -o json > "${MOCK_DIR}/${prefix}-get-pods.json"

  echo "  Capturing: kubectl describe pods -n $ns"
  # Try selector first, fall back to describe all pods in namespace
  local pod_name
  pod_name=$(kubectl get pods -n "$ns" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
  if [[ -n "$pod_name" ]]; then
    kubectl describe pod "$pod_name" -n "$ns" > "${MOCK_DIR}/${prefix}-describe.txt"
  else
    kubectl describe pods -n "$ns" > "${MOCK_DIR}/${prefix}-describe.txt"
  fi

  # Optional extra commands per scenario
  for cmd in "${extra_commands[@]-}"; do
    case "$cmd" in
      logs)
        local pod
        pod=$(kubectl get pods -n "$ns" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
        if [[ -n "$pod" ]]; then
          echo "  Capturing: kubectl logs -n $ns $pod --previous"
          kubectl logs -n "$ns" "$pod" --previous --tail=100 > "${MOCK_DIR}/${prefix}-logs.txt" 2>&1 || \
            echo "(no previous logs available)" > "${MOCK_DIR}/${prefix}-logs.txt"
        fi
        ;;
      endpoints)
        echo "  Capturing: kubectl get endpoints -n $ns -o json"
        kubectl get endpoints -n "$ns" -o json > "${MOCK_DIR}/${prefix}-get-endpoints.json"
        ;;
    esac
  done

  echo "  Captured $prefix files to $MOCK_DIR"
  echo ""
}

# Scenario 1: ImagePullBackOff
# Pod enters ErrImagePull first, then BackOff after ~30s, then ImagePullBackOff after ~2min
capture_scenario \
  01-image-pull-backoff.yaml \
  k8s-trouble-image-pull \
  01-image-pull \
  "ImagePullBackOff|ErrImagePull"

# Scenario 2: CrashLoopBackOff
# Note: prefix is 02-crashloop2 to avoid collision with existing get-pods-crashloop.json mock
# CrashLoopBackOff appears after ~3 restart cycles (~2-3 minutes)
capture_scenario \
  02-crashloop-backoff.yaml \
  k8s-trouble-crashloop \
  02-crashloop2 \
  "CrashLoopBackOff" \
  logs

# Scenario 3: OOMKilled
# python:3.12-alpine pulls first (~1 min), then allocates memory and OOMKills
# May show CrashLoopBackOff after first OOM kill
capture_scenario \
  03-oom-killed.yaml \
  k8s-trouble-oom \
  03-oom \
  "OOMKilled|CrashLoopBackOff"

# Scenario 4: Liveness probe failure
# nginx starts successfully (Running briefly), then probe fails after initialDelaySeconds + failureThreshold cycles
# (~3s + 3*5s = ~18s to first kill, then CrashLoopBackOff on retry)
capture_scenario \
  04-liveness-probe.yaml \
  k8s-trouble-liveness \
  04-liveness \
  "CrashLoopBackOff"

# Scenario 5: Missing secret (CreateContainerConfigError)
# Pod stays Pending almost immediately — no wait needed
capture_scenario \
  05-missing-secret.yaml \
  k8s-trouble-secret \
  05-missing-secret \
  "CreateContainerConfigError|ContainerCreating"

# Scenario 6: Port mismatch (pod runs healthy; failure surfaces via endpoints only)
# Pod reaches Running quickly; capture AFTER pod is Running
capture_scenario \
  06-port-mismatch.yaml \
  k8s-trouble-port \
  06-port-mismatch \
  "Running" \
  endpoints

echo "All scenario captures complete."
echo "Mock files saved to: $MOCK_DIR"
echo ""
echo "To verify mock files:"
echo "  ls -la ${MOCK_DIR}/0[1-6]-*"
echo ""
echo "To clean up the test namespaces:"
echo "  for ns in k8s-trouble-image-pull k8s-trouble-crashloop k8s-trouble-oom k8s-trouble-liveness k8s-trouble-secret k8s-trouble-port; do"
echo "    kubectl delete namespace \$ns --ignore-not-found"
echo "  done"
