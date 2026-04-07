---
phase: 09-multi-agent-workflows-production
plan: "02"
subsystem: module-11-fleet-content
tags:
  - fleet-coordinator
  - module-11
  - lab-replacement
  - productionization
  - k8s-agent-sandbox
  - quiz
dependency_graph:
  requires:
    - Phase 9 Plan 01 (Morgan profile update + GitOps Path B + fleet-webhook-subscribe.sh)
    - Phase 6 K8s skills (sre-k8s-pod-health, crashloop2 scenario — read-only)
    - Phase 7 governance (governance-L4-track-c.yaml, mock-kubectl — read-only)
    - Phase 8 alerts + triggers (prometheus-rules.yaml, alertmanager-config.yaml, Telegram — read-only)
  provides:
    - Module 11 live-primary FLEET-01 lab (11-step, replaces 7-step mock-only)
    - PROD-02 productionization reference section (4 topics, ~560 lines)
    - K8s Agent Sandbox exploratory project entry (v0.2.1 pinned)
    - 3 new Module 11 quiz questions (dual paths, re-delegation, productionizing)
  affects:
    - Milestone v1.1 (FLEET-01, FLEET-02, PROD-01, PROD-02 all fulfilled — milestone ready to close)
tech_stack:
  added: []
  patterns:
    - "REPLACE not EXTEND: live-primary lab replaces mock-only (justified by fundamental flow difference)"
    - "Solo Learner callout pattern at every major step for Udemy accessibility"
    - "Belt + suspenders: Morgan config (terminal capability) + SOUL.md (NEVER rule)"
    - "Path A vs Path B teaching: direct apply vs GitOps PR as the production teaching moment"
    - "No fictional Hermes flags: gh pr create via terminal toolset, no --deliver github_pr"
key_files:
  created:
    - .planning/phases/09-multi-agent-workflows-production/09-02-SUMMARY.md
  modified:
    - course-site/docs/module-11-fleet/lab/LAB.mdx
    - modules/module-11-fleet/LAB.md
    - course-site/docs/module-11-fleet/reading/reference.mdx
    - course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx
    - course-site/docs/module-11-fleet/quiz/QUIZ.mdx
decisions:
  - "D-11 honored: Module 11 lab REPLACED not extended — mock flow and live flow fundamentally differ"
  - "D-12 honored: Solo Learner callouts at every major step with mock-mode equivalents"
  - "D-22 honored: All Phase 9 env vars in export block including GITOPS_REPO_URL and GITOPS_BRANCH_PREFIX"
  - "D-15 honored: Sandbox as exploratory PROJECTS.mdx entry only — no infrastructure file commitments"
  - "D-18 honored: PROD-02 productionization reference section added to reference.mdx"
  - "D-20 honored: 3 new quiz questions on dual apply paths, re-delegation pattern, productionization"
  - "BLOCKER-01 handled: gh pr create used directly (no fictional --deliver github_pr); noted in lab text"
  - "BLOCKER-02 handled: ArgoCD mentioned as v1.2 alternative only — apply.sh is the guided Sub-path B2"
metrics:
  duration: "~12 minutes"
  completed_date: "2026-04-07"
  tasks_completed: 3
  files_created: 1
  files_modified: 5
---

# Phase 09 Plan 02: Module 11 Content Replacement — Live FLEET-01 Lab + PROD-02 + Sandbox + Quiz

**One-liner:** Module 11 lab replaced with live FLEET-01 11-step walkthrough (AlertManager → Morgan → Track C → Telegram approval → L4 apply + Path B GitOps PR), PROD-02 productionization reference section added (~560 lines, 4 topics), K8s Agent Sandbox exploratory entry with v0.2.1 pinned install, and 3 new quiz questions — completing the final v1.1 content deliverable.

## Tasks Completed

| Task | Description | Commit | Files |
|------|-------------|--------|-------|
| 1 | REPLACE Module 11 lab (both mirrors) with 11-step live-primary FLEET-01 walkthrough | 9759b0b | 2 replaced |
| 2 | Add PROD-02 productionization reference section (~560 lines) to Module 11 reading | 2ee4176 | 1 modified |
| 3 | Add K8s Agent Sandbox project entry to PROJECTS.mdx + 3 new quiz questions to QUIZ.mdx | dad0948 | 2 modified |

## Task 1: Module 11 Lab Replacement

### What changed

The existing 7-step mock-only lab (HERMES_LAB_SCENARIO=messy, fictional "memory-hog analytics
service," no real delegation/alerting) was completely replaced with an 11-step live-primary
walkthrough. The new lab uses:

- `HERMES_LAB_SCENARIO=crashloop2` (real Phase 6 scenario)
- `HERMES_LAB_MODE=live` primarily, with Solo Learner callouts at every step
- Real AlertManager + real Telegram bot + real KIND cluster (or mock fallback at every step)
- 11 GUIDED steps + Free Explore section (~90 min guided + 45 min explore)

### Lab structure

| Step | Content | Time |
|------|---------|------|
| 1 | Prerequisites + full export block (all 11 env vars) | 10 min |
| 2 | Install Morgan + verify cli: [terminal, web, skills] | 8 min |
| 3 | Read Morgan SOUL.md — 4 Phase 9 additions | 7 min |
| 4 | Start gateway + fleet-webhook-subscribe.sh | 10 min |
| 5 | Trigger AlertManager alert (live + Solo Learner fallback) | 10 min |
| 6 | Observe Morgan triage + delegation to Track C | 10 min |
| 7 | Observe Track C sre-k8s-pod-health diagnosis | 10 min |
| 8 | Observe Morgan synthesis + Telegram proposal | 10 min |
| 9 | /approve + Path A L4 kubectl apply | 10 min |
| 10 | Path B GitOps: init repo + Track C gh pr create | 10 min |
| 11 | Merge PR + apply.sh sync | 8 min |
| Free Explore | 5 challenges | 45 min |

### Key content decisions

- **Milestone close note:** Lab outro explicitly states this is the final v1.1 lab and points to
  `/gsd:audit-uat` and `/gsd:complete-milestone` as next steps (D-23)
- **No fictional Hermes flags:** Step 10 documents that Track C calls `gh pr create` directly from
  its terminal toolset — no `--deliver github_pr` method exists in Hermes (BLOCKER-01)
- **ArgoCD as v1.2 only:** Step 11 and the Path A/B comparison table note ArgoCD as a v1.2
  alternative; `apply.sh` is the guided Sub-path B2 (BLOCKER-02)
- **Solo Learner callouts:** 7+ per file (grep confirmed), every major interactive step covered
- **Complete export block:** All 11 env vars: HERMES_LAB_MODE, HERMES_LAB_SCENARIO,
  MOCK_DATA_DIR, PATH, HERMES_LAB_GOVERNANCE, HERMES_LAB_TRACK, TELEGRAM_BOT_TOKEN,
  TELEGRAM_ALLOWED_USERS, GITHUB_TOKEN, GITOPS_REPO_URL, GITOPS_BRANCH_PREFIX

### File statistics

| File | Lines before | Lines after | Change |
|------|-------------|-------------|--------|
| `course-site/docs/module-11-fleet/lab/LAB.mdx` | 652 | 924 | REPLACED (+272 net, full content rewrite) |
| `modules/module-11-fleet/LAB.md` | 626 | 869 | REPLACED (+243 net, full content rewrite) |

## Task 2: PROD-02 Productionization Reference Section

### New section 7 structure

Section 7 "Productionizing Hermes Agents" was appended to `reference.mdx` (sections 1-6
preserved verbatim).

**7.1 Packaging:** Dockerfile with 4 layers (Hermes runtime, agent profile, skills library,
governance configs). Version pinning table for all 4 artifact types. External CLI dependency
management (`kubectl`, `gh` shipped in container). Profile naming pitfall.

**7.2 Deployment:** Pattern A (K8s Deployment with HPA manifest), Pattern B (K8s CronJob with
production settings), Pattern C (GitOps PR → `apply.sh` sync, ArgoCD as v1.2 alternative).
GitOps repo structure recommendation with `patches/` and `applied/` subdirectories.

**7.3 Monitoring:** Prometheus scrape config, metrics table with alert conditions, governance
audit log JSON example (`mock-kubectl` output format), PromQL aggregations for governance
dashboard, Phase 8 AlertManager self-monitoring PrometheusRules example (with required
`release: kube-prometheus` label), structured JSON logging for delegation trace reconstruction.

**7.4 Scaling:** HPA manifest with custom Hermes metric, queue vs trigger decision table
(15 alerts/min = trigger-based, not queue), multi-tenant isolation Model 1 vs Model 2,
NetworkPolicy manifest for agent isolation, K8s Agent Sandbox CRD isolation (alpha v0.2.1
cross-reference to PROJECTS.mdx Project 3), scaling decision checklist.

**7.5 Production decision table:** 6 scenarios (small team, regulated, multi-team, high-volume
scheduled, experimental, ArgoCD production).

**7.6 Cross-references:** 8 course artifacts mapped to the relevant section.

### File statistics

| File | Lines before | Lines after | Change |
|------|-------------|-------------|--------|
| `course-site/docs/module-11-fleet/reading/reference.mdx` | 212 | 773 | +561 lines |

## Task 3: Sandbox Project Entry + Quiz Questions

### PROJECTS.mdx

New Project 3: K8s Agent Sandbox with:
- Alpha warning admonition (v0.2.1, CRDs under `agents.x-k8s.io/v1alpha1`)
- Pinned install URL: `releases/download/v0.2.1/manifest.yaml`
- All 4 CRD types: Sandbox, SandboxTemplate, SandboxClaim, SandboxWarmPool
- 5 steps: install, create SandboxTemplate, instantiate Sandbox, verify isolation (3 tests), clean up
- Zero infrastructure file commitments (D-17) — only code blocks
- Cross-reference to reference.mdx §7.4 Scaling

### QUIZ.mdx

3 new questions (Q6, Q7, Q8):

| Question | Topic | Correct Answer | Key teaching |
|----------|-------|----------------|--------------|
| Q6 | Dual Apply Path Tradeoff | C | Neither path universally better; context determines choice |
| Q7 | Re-delegation with Governance Escalation | C | Both SOUL.md NEVER rule AND context retention (belt + suspenders) |
| Q8 | Productionizing Decision | C | SOC 2 compliance → Deployment-per-team (regulated environment) |

All questions follow the existing 4-option (A-D) pattern with collapsible `<details>` rationale.

### File statistics

| File | Lines before | Lines after | Change |
|------|-------------|-------------|--------|
| `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx` | 106 | 301 | +195 lines |
| `course-site/docs/module-11-fleet/quiz/QUIZ.mdx` | 165 | 313 | +148 lines |

## Deviations from Plan

None — plan executed exactly as written.

RESEARCH BLOCKERs were pre-accounted for in the plan:
- BLOCKER-01 (`_deliver_github_pr` doesn't exist): Documented in Step 10 lab text with explicit
  note that Track C uses `gh pr create` from terminal toolset directly
- BLOCKER-02 (no ArgoCD install infrastructure): ArgoCD mentioned as v1.2 alternative only;
  `apply.sh` is the guided Path B Sub-path B2

## Known Stubs

None. All file paths referenced in the lab point to real files committed in Phase 9 Plan 01:
- `infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh` — EXISTS (f086223)
- `infrastructure/scenarios/k8s/gitops/apply.sh` — EXISTS (f2f2e35)
- `infrastructure/scenarios/k8s/gitops/memory-patch.yaml` — EXISTS (f2f2e35)
- `infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md` — EXISTS (f2f2e35)
- `agents/fleet-coordinator/SOUL.md` — EXISTS with 4 Phase 9 additions (a408b76)
- `agents/fleet-coordinator/config.yaml` — EXISTS with `cli: [terminal, web, skills]` (a408b76)

## Milestone Status

This is the **final v1.1 plan**. With Plan 09-02 complete:

- FLEET-01: Live incident response chain fully documented in Module 11 lab (11-step walkthrough)
- FLEET-02: Module 11 lab rewritten as live-primary with Solo Learner callouts
- PROD-01: K8s Agent Sandbox in PROJECTS.mdx as exploratory entry (v0.2.1 pinned)
- PROD-02: Productionization reference section in Module 11 reading (~560 lines)

v1.1 milestone ("Realistic Agents & Production Workflows") is ready for:
1. `/gsd:audit-uat` — cross-phase verification debt review
2. `/gsd:complete-milestone` — archive v1.1 and prepare for v1.2

## Self-Check: PASSED

All required files exist with correct content:
- `course-site/docs/module-11-fleet/lab/LAB.mdx` — FOUND, 924 lines, contains AlertManager, fleet-webhook-subscribe.sh, gitops/apply.sh, gh pr create, GITOPS_REPO_URL, 7 Solo Learner callouts
- `modules/module-11-fleet/LAB.md` — FOUND, 869 lines, contains same key content
- `course-site/docs/module-11-fleet/reading/reference.mdx` — FOUND, 773 lines, Section 7 Productionizing Hermes Agents present
- `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx` — FOUND, 301 lines, Project 3 K8s Agent Sandbox with v0.2.1
- `course-site/docs/module-11-fleet/quiz/QUIZ.mdx` — FOUND, 313 lines, 8 questions (was 5)

All commits exist:
- 9759b0b: feat(09-02): replace Module 11 lab with 11-step live-primary FLEET-01 walkthrough
- 2ee4176: feat(09-02): add PROD-02 productionization reference section to Module 11 reading
- dad0948: feat(09-02): add K8s Agent Sandbox project entry and 3 new quiz questions
