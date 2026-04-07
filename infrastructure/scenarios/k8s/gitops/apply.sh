#!/usr/bin/env bash
# infrastructure/scenarios/k8s/gitops/apply.sh
# Path B Sub-path B2: apply a merged YAML patch after PR merge
#
# Phase 9 FLEET-01 Path B (GitOps PR-based apply) uses this script as the sync mechanism.
# ArgoCD install infrastructure does not exist in the course repo (research-corrected D-07),
# so this script is the ONLY supported Path B sync mechanism for v1.1.
#
# In a real production deployment this is where ArgoCD sync would occur instead — the
# apply.sh script models the "post-merge CI pipeline" pattern used by teams who run
# helm/kubectl from CI on PR merge rather than running ArgoCD. Lab text labels this
# "GitOps manifest apply" (not "Helm upgrade") because we apply a raw K8s manifest patch
# to the existing crasher Deployment, not a Helm chart upgrade.
#
# Usage:
#   bash infrastructure/scenarios/k8s/gitops/apply.sh [PATCH_FILE]
#
# Defaults:
#   PATCH_FILE=infrastructure/scenarios/k8s/gitops/memory-patch.yaml
#   NAMESPACE=k8s-trouble-crashloop
#
# Env vars (Phase 9 NEW):
#   GITOPS_REPO_URL       — informational; this script does NOT clone. It assumes the
#                           merged patch file already exists on the local filesystem.
#   GITOPS_BRANCH_PREFIX  — informational; used by the specialist agent, not this script.
#
# To install ArgoCD instead (v1.2 alternative — NOT a guided Phase 9 step):
#   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#   (then configure an Application resource pointing at your GitOps repo)
set -euo pipefail

PATCH_FILE="${1:-infrastructure/scenarios/k8s/gitops/memory-patch.yaml}"
NAMESPACE="${NAMESPACE:-k8s-trouble-crashloop}"

echo "[gitops/apply.sh] Phase 9 FLEET-01 Path B sync"
echo "[gitops/apply.sh] Patch file: ${PATCH_FILE}"
echo "[gitops/apply.sh] Namespace:  ${NAMESPACE}"
echo ""

# Validate patch file exists (fail loud if the PR merge step was skipped)
if [[ ! -f "${PATCH_FILE}" ]]; then
  echo "ERROR: Patch file not found: ${PATCH_FILE}" >&2
  echo "       Did the PR merge step complete? The merged patch should exist locally." >&2
  exit 1
fi

# Apply the patch (goes through infrastructure/wrappers/mock-kubectl if on PATH,
# which enforces HERMES_LAB_GOVERNANCE=L4 wrapper_allowlist per Phase 7).
echo "[gitops/apply.sh] Running: kubectl apply -f ${PATCH_FILE} -n ${NAMESPACE}"
kubectl apply -f "${PATCH_FILE}" -n "${NAMESPACE}"

echo ""
echo "[gitops/apply.sh] Waiting for rollout to stabilize..."
kubectl rollout status deployment/crasher -n "${NAMESPACE}" --timeout=60s || {
  echo "[gitops/apply.sh] WARNING: Rollout did not stabilize within 60s." >&2
  echo "[gitops/apply.sh] Check: kubectl describe pod -n ${NAMESPACE} -l app=crasher" >&2
  exit 2
}

echo ""
echo "[gitops/apply.sh] Sync complete. Fleet-01 Path B demo successful."
