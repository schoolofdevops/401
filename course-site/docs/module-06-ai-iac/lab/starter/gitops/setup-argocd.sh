#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing ArgoCD on KIND ==="

# Create namespace (idempotent)
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD from stable manifests (NOT core — we need the UI)
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "=== Patching resource limits for laptop constraints ==="

# Reduce memory for laptop (per pitfall 2 — standard install requests 1.3GB total)
kubectl patch deployment argocd-repo-server -n argocd --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"128Mi"},{"op":"add","path":"/spec/template/spec/containers/0/resources/limits","value":{"memory":"256Mi"}}]'

kubectl patch deployment argocd-server -n argocd --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"128Mi"},{"op":"add","path":"/spec/template/spec/containers/0/resources/limits","value":{"memory":"256Mi"}}]'

kubectl patch deployment argocd-application-controller -n argocd --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"256Mi"},{"op":"add","path":"/spec/template/spec/containers/0/resources/limits","value":{"memory":"512Mi"}}]'

echo "=== Waiting for ArgoCD pods ==="
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/part-of=argocd \
  -n argocd \
  --timeout=300s

echo "=== ArgoCD installed ==="
echo "Admin password:"
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d
echo ""
echo ""
echo "Port-forward: kubectl port-forward svc/argocd-server -n argocd 8443:443"
echo "Login: https://localhost:8443  (user: admin, password: above)"
