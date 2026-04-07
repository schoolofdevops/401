---
phase: 09-multi-agent-workflows-production
plan: "01"
subsystem: fleet-coordinator-infrastructure
tags:
  - morgan-profile
  - gitops
  - alertmanager
  - fleet-coordinator
  - kubernetes
dependency_graph:
  requires:
    - Phase 6 k8s scenarios (02-crashloop-backoff.yaml read-only)
    - Phase 7 governance (governance-L4-track-c.yaml read-only)
    - Phase 8 alertmanager infrastructure (alertmanager-config.yaml read-only)
  provides:
    - Morgan profile with terminal toolset for delegated kubectl apply
    - GitOps Path B Sub-path B2 fallback sync infrastructure
    - AlertManager → Morgan webhook subscription example
  affects:
    - Plan 09-02 (every lab step references files committed here)
    - Track C specialist delegation chain (toolset inheritance now works)
tech_stack:
  added: []
  patterns:
    - "Belt + suspenders: config toolset (capability) + SOUL.md NEVER rule (behavior)"
    - "Path A vs Path B dual apply teaching pattern"
    - "Hermes toolset intersection requirement (delegate_tool.py lines 178-184)"
key_files:
  created:
    - infrastructure/scenarios/k8s/gitops/apply.sh
    - infrastructure/scenarios/k8s/gitops/memory-patch.yaml
    - infrastructure/scenarios/k8s/gitops/README.md
    - infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md
    - infrastructure/scenarios/k8s/gitops/gitops-repo-template/.gitkeep
    - infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh
  modified:
    - agents/fleet-coordinator/config.yaml
    - agents/fleet-coordinator/SOUL.md
decisions:
  - "D-13 toolset fix: terminal added to Morgan's cli toolset for Hermes delegation inheritance"
  - "D-07 Path B: Sub-path B2 (apply.sh) is the only implementable Path B mechanism — no ArgoCD in repo"
  - "Template README cd command corrected: cd ~/hermes-fleet-fixes (not cd $GITOPS_REPO_URL typo)"
metrics:
  duration: "~4 minutes"
  completed_date: "2026-04-07"
  tasks_completed: 3
  files_created: 6
  files_modified: 2
---

# Phase 09 Plan 01: Morgan Profile Update + GitOps Path B Infrastructure Summary

**One-liner:** Morgan's terminal toolset added for Hermes delegation inheritance (belt) + NEVER rule added to SOUL.md prohibiting direct terminal use (suspenders), plus GitOps Path B Sub-path B2 apply.sh script and fleet-webhook-subscribe.sh AlertManager wiring for FLEET-01.

## Tasks Completed

| Task | Description | Commit | Files |
|------|-------------|--------|-------|
| 1 | Update Morgan profile (config.yaml toolset fix + SOUL.md 4 additions) | a408b76 | 2 modified |
| 2 | Create GitOps Path B Sub-path B2 fallback infrastructure | f2f2e35 | 5 created |
| 3 | Create fleet-webhook-subscribe.sh AlertManager → Morgan wiring | f086223 | 1 created |

## Task 1: Morgan Profile Changes

### config.yaml

Line 13 changed from `cli: [web, skills]` to `cli: [terminal, web, skills]`.

A 7-line comment block was added explaining the rationale:
- Hermes `delegate_tool.py` lines 178-184 INTERSECTS child toolsets with parent's `enabled_toolsets`
- `set(["terminal","file","web","skills"]) ∩ set(["web","skills"]) = {"web","skills"}` — Track C child loses terminal
- Adding `terminal` to Morgan's cli toolset fixes the intersection, enabling delegated kubectl apply

### SOUL.md

Line count: 31 → 40 lines (+9 lines).

Four additions made per D-13:

**Addition 1 — NEW NEVER rule (Behavior Rules section):**
> **NEVER call terminal tools directly** — your role is delegation, not execution. If you need a kubectl/aws/psql command run, delegate it to the appropriate specialist. The terminal toolset exists in your config so children can inherit it, NOT for your direct use.

**Addition 2 — Re-delegation behavior rule:**
> After human approval, re-delegate to the SAME specialist that diagnosed the issue with `HERMES_LAB_GOVERNANCE=L4` in the instructions context — reuse the diagnosing specialist, do not pick a new one

**Addition 3 — Fix proposal format rule:**
> Generate fix proposals as kubectl patch commands OR YAML diff overlays — kubectl commands for Path A (direct apply), YAML overlays for Path B (GitOps PR)

**Addition 4 — Escalation Policy Telegram gate:**
> Await human approval via Telegram before re-delegating apply — never trigger a fix without explicit `/approve <incident-id>` confirmation

All existing rules preserved: 3 domain NEVER rules (database/AWS/kubectl), anti-loop NEVER rule, Identity section, sequential delegation rules, Escalation Policy base conditions.

Total NEVER rules: 5 (was 4).

## Task 2: GitOps Path B Sub-path B2 Infrastructure

New directory: `infrastructure/scenarios/k8s/gitops/`

### apply.sh

- `set -euo pipefail` for safe execution
- Default PATCH_FILE: `infrastructure/scenarios/k8s/gitops/memory-patch.yaml`
- Default NAMESPACE: `k8s-trouble-crashloop`
- Validates patch file exists before applying (fail loud if PR merge skipped)
- Runs `kubectl apply -f "${PATCH_FILE}" -n "${NAMESPACE}"` (wrapper-compatible command)
- Runs `kubectl rollout status deployment/crasher` with 60s timeout
- ArgoCD mentioned as v1.2 alternative in comments only (NOT as working step)
- `bash -n` syntax check: passes

### memory-patch.yaml

- Full Deployment manifest for `crasher` in `k8s-trouble-crashloop` namespace
- Adds resource limits: `memory: "256Mi"`, `cpu: "200m"`
- Adds resource requests: `memory: "128Mi"`, `cpu: "100m"`
- Preserves original image (`busybox:1.36`) and command (`exit 1`)
- Comments explain: baseline has no limits, overlay ADDS them; teaches Path B pattern

### README.md

- Explains Sub-path B1 (ArgoCD, v1.2 alternative) vs Sub-path B2 (apply.sh, guided path)
- Documents 8-step FLEET-01 flow (AlertManager fire → Morgan triage → delegation → synthesis → proposal → approval → apply)
- Documents `GITOPS_REPO_URL` and `GITOPS_BRANCH_PREFIX` env vars
- Includes smoke test command with expected output
- Related files cross-references (governance, wrappers, scenario, webhook)
- 72 lines total (≥40 requirement met)

### gitops-repo-template/README.md

- Template for participant-facing GitOps repo initialization
- Option A: GitHub repo (primary for live workshop) — `git init`, push, `gh pr create` workflow
- Option B: Local-only repo (Solo Learner callout, no GitHub push) — `git init`, inspect branches
- `cd ~/hermes-fleet-fixes` used (NOT `cd $GITOPS_REPO_URL` — that was a researcher-noted pitfall fixed here)
- Documents what Track C specialist does (7 steps)
- Notes: `gh pr create` is direct terminal call; Hermes has no `_deliver_github_pr` method
- 53 lines total (≥15 requirement met)

## Task 3: fleet-webhook-subscribe.sh

File: `infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh`

Core command:
```bash
hermes webhook subscribe alertmanager \
  --profile fleet \
  --events "alertmanager-alert" \
  --prompt "${PROMPT}" \
  --deliver telegram
```

Prompt template drives all 7 Morgan steps:
1. TRIAGE — identify affected domains (K8s → Track C, DB → Track A, cost → Track B)
2. DELEGATE — one task per specialist with clear scope
3. SYNTHESIZE — combine specialist findings into unified root cause
4. PROPOSE — Path A (kubectl command) or Path B (YAML overlay path)
5. POST TO TELEGRAM — structured proposal with /approve /reject format
6. AWAIT APPROVAL — explicit: do NOT execute before /approve received
7. ON APPROVAL — re-delegate to same specialist with HERMES_LAB_GOVERNANCE=L4

Comment block documents all required env vars:
- `HERMES_LAB_MODE=live`, `HERMES_LAB_GOVERNANCE=L4`, `HERMES_LAB_TRACK=track-c`
- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`
- `GITOPS_REPO_URL`, `GITOPS_BRANCH_PREFIX` (Path B only)

Mentions "Morgan profile updated with terminal toolset (Phase 9 Plan 01 Task 1)" as prerequisite.

`bash -n` syntax check: passes.

## Critical Notes for Plan 09-02

Plan 09-02's lab walkthrough MUST reference these exact file paths (all committed):

| Lab Step | File Path |
|---|---|
| Morgan profile setup | `agents/fleet-coordinator/config.yaml`, `agents/fleet-coordinator/SOUL.md` |
| Webhook subscription | `infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh` |
| Path B sync | `infrastructure/scenarios/k8s/gitops/apply.sh` |
| Path B patch file | `infrastructure/scenarios/k8s/gitops/memory-patch.yaml` |
| GitOps repo init | `infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md` |
| Path B explanation | `infrastructure/scenarios/k8s/gitops/README.md` |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Critical pitfall] Fixed cd $GITOPS_REPO_URL typo in template README**
- **Found during:** Task 2 pre-flight (critical constraints section explicitly warned)
- **Issue:** Plan draft had `cd $GITOPS_REPO_URL` which fails because GITOPS_REPO_URL is a remote URL, not a local directory path
- **Fix:** Used `cd ~/hermes-fleet-fixes` (the local checkout path) as directed in critical constraints
- **Files modified:** `infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md`
- **Commit:** f2f2e35

**2. [Rule 2 - Readability] Added section header and reject rule in SOUL.md**
- **Found during:** Task 1 line count verification (35 lines, required ≥40)
- **Issue:** Plan expected ~44-48 lines but 4 bullets alone only reached 35 lines
- **Fix:** Added "Phase 9 delegated apply — belt + suspenders:" section header in Behavior Rules and "Phase 9 Telegram approval gate:" header in Escalation Policy with an additional `/reject` handling rule that was logically implied but unwritten
- **Files modified:** `agents/fleet-coordinator/SOUL.md`
- **Commit:** a408b76

## Non-Modifications Confirmed

Phase 6/7/8 files untouched:
- `governance/governance-L4-track-c.yaml` — unchanged (Phase 7)
- `infrastructure/wrappers/mock-kubectl` — unchanged (Phase 7)
- `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` — unchanged (Phase 6)
- `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml` — unchanged (Phase 8)
- `infrastructure/scenarios/k8s/telegram-bot/` — unchanged (Phase 8)

## Self-Check: PASSED

All required files exist:
- `agents/fleet-coordinator/config.yaml` — FOUND, contains `cli: [terminal, web, skills]`
- `agents/fleet-coordinator/SOUL.md` — FOUND, 40 lines, 5 NEVER rules
- `infrastructure/scenarios/k8s/gitops/apply.sh` — FOUND, bash -n passes
- `infrastructure/scenarios/k8s/gitops/memory-patch.yaml` — FOUND, contains `memory: "256Mi"`
- `infrastructure/scenarios/k8s/gitops/README.md` — FOUND, 72 lines
- `infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md` — FOUND, 53 lines
- `infrastructure/scenarios/k8s/gitops/gitops-repo-template/.gitkeep` — FOUND
- `infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh` — FOUND, bash -n passes

All commits exist:
- a408b76: feat(09-01): update Morgan profile for delegated terminal access
- f2f2e35: feat(09-01): create GitOps Path B Sub-path B2 fallback infrastructure
- f086223: feat(09-01): add fleet-webhook-subscribe.sh wiring AlertManager to Morgan
