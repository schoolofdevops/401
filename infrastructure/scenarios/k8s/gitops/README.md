# Phase 9 GitOps Path B Sub-path B2 — Helm/kubectl Fallback

This directory ships the Phase 9 FLEET-01 Path B sync infrastructure. It models the
"production upgrade" section of the Module 11 fleet lab where the triage → diagnose →
propose → approve chain runs via a GitHub PR instead of a direct `kubectl apply`.

## Contents

| File | Purpose |
|---|---|
| `apply.sh` | Path B sync: runs `kubectl apply -f <patch> -n k8s-trouble-crashloop` |
| `memory-patch.yaml` | Sample overlay the Track C specialist agent generates during Path B |
| `gitops-repo-template/` | Template README for the participant-facing GitOps repo |

## Sub-path B1 vs Sub-path B2 (why this exists)

D-07 in 09-CONTEXT.md originally described two sub-paths for Path B:

- **Sub-path B1 — ArgoCD sync:** specialist opens PR → human merges → ArgoCD detects change → ArgoCD syncs deployment
- **Sub-path B2 — helm/kubectl fallback:** specialist opens PR → human merges → `apply.sh` runs `kubectl apply` from local

Research (2026-04-07) confirmed that **no ArgoCD install infrastructure exists in the course repo** — `setup-argocd.sh` is referenced in Module 5 exploratory content but was never committed. As a result, Sub-path B1 cannot be walked as a guided lab step in v1.1. **Sub-path B2 is the ONLY implementable Path B mechanism.**

Lab text in Module 11 will mention ArgoCD as a v1.2 alternative with explicit callout
("ArgoCD-based sync would replace this script in production deployments"), but the
GUIDED step uses `apply.sh`.

## When apply.sh runs

1. AlertManager fires on Phase 6 crashloop2 scenario
2. Morgan receives webhook, triages, delegates to Track C for diagnosis
3. Track C specialist returns findings
4. Morgan synthesizes, generates `memory-patch.yaml` (this file), proposes fix
5. Morgan posts proposal to Telegram with PR link (Path B) or kubectl command (Path A)
6. Human reviews PR diff in GitHub UI (Path B) or Telegram (Path A)
7. **Path B:** Human merges PR → `apply.sh` runs (this is step 7 for Path B)
8. **Path A:** Human sends `/approve` in Telegram → specialist re-delegated at L4 → `kubectl apply`

Path A and Path B both end with `kubectl apply` going through `infrastructure/wrappers/mock-kubectl`
with `HERMES_LAB_GOVERNANCE=L4` and `HERMES_LAB_TRACK=track-c`. The L4 wrapper_allowlist has
`"apply "` in its kubectl section (governance/governance-L4-track-c.yaml). No governance changes
needed for Phase 9.

## Phase 9 NEW env vars (D-22)

```bash
export GITOPS_REPO_URL="https://github.com/<user>/hermes-fleet-fixes"
export GITOPS_BRANCH_PREFIX="hermes-fix-"
```

`GITOPS_REPO_URL` points to the target GitOps repo (user's fork of the sample, a new repo they own,
or a local-only git repo). `GITOPS_BRANCH_PREFIX` controls how the specialist names fix branches
(example: `hermes-fix-1712534400`).

## Smoke test

```bash
bash infrastructure/scenarios/k8s/gitops/apply.sh
# Expected output:
#   [gitops/apply.sh] Phase 9 FLEET-01 Path B sync
#   [gitops/apply.sh] Patch file: infrastructure/scenarios/k8s/gitops/memory-patch.yaml
#   [gitops/apply.sh] Namespace:  k8s-trouble-crashloop
#   [gitops/apply.sh] Running: kubectl apply -f ...
#   deployment.apps/crasher configured
#   [gitops/apply.sh] Sync complete.
```

Requires the Phase 6 crashloop2 scenario to already be applied to your KIND cluster.

## Related

- `governance/governance-L4-track-c.yaml` — L4 wrapper_allowlist for kubectl apply
- `infrastructure/wrappers/mock-kubectl` — Phase 7 enforcement wrapper
- `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` — target deployment
- `infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh` — webhook wiring
