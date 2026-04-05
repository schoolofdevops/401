---
phase: 03-day-2-modules
plan: "05"
subsystem: module-06-ai-iac
tags: [module-6, reading, quiz, exploratory, IaC, terraform, argocd, context-engineering]
dependency_graph:
  requires:
    - 03-04 (Module 6 labs — Track A Terraform + Track B ArgoCD)
  provides:
    - Module 6 reading materials (concepts + reference)
    - Module 6 quiz (7 questions)
    - Module 6 exploratory stretch projects (3 projects)
  affects:
    - Module 6 complete (all subdirectories present)
tech_stack:
  added: []
  patterns:
    - Labs-first strategy — reading and quiz derived from lab content
    - Collapsible details blocks for quiz answers
    - CLAUDE.md templates as reference content
key_files:
  created:
    - course-site/docs/module-06-ai-iac/reading/_category_.json
    - course-site/docs/module-06-ai-iac/reading/concepts.mdx
    - course-site/docs/module-06-ai-iac/reading/reference.mdx
    - course-site/docs/module-06-ai-iac/quiz/_category_.json
    - course-site/docs/module-06-ai-iac/quiz/QUIZ.mdx
    - course-site/docs/module-06-ai-iac/exploratory/_category_.json
    - course-site/docs/module-06-ai-iac/exploratory/PROJECTS.mdx
  modified: []
decisions:
  - Context Engineering vs. Prompt Engineering heading renamed to avoid "prompt engineering" occurrence per plan acceptance criteria
metrics:
  duration: ~15min
  completed: 2026-04-04
  tasks_completed: 2
  files_created: 7
  files_modified: 0
requirements:
  - MOD6-05
  - MOD6-06
---

# Phase 03 Plan 05: Module 6 Reading, Quiz, and Exploratory Projects Summary

**One-liner:** Module 6 reading/quiz/exploratory covering AI failure modes in IaC (schema drift, hallucinated attributes, version mismatch), validation hierarchy, and 3 stretch projects extending both Terraform and ArgoCD tracks.

---

## What Was Built

Module 6 now has complete reading, quiz, and exploratory subdirectories, filling out the full module structure alongside the labs from Plan 04.

### Task 1: Module 6 Reading Materials

**concepts.mdx** — 5 sections derived from lab experience:
1. AI Failure Modes in IaC Generation (schema drift, hallucinated attributes, version mismatch, missing dependencies) with the "junior admin who memorized docs two years ago" DevOps analogy
2. Why AI Errors in IaC Are Especially Dangerous — blast radius, `terraform plan` as safety net, GitOps amplification of errors (auto-scaling on misconfigured health check analogy)
3. Context Engineering for IaC Quality — CLAUDE.md as the system context layer, guided generation pattern, why generic requests produce dangerous output
4. Validation as a Non-Negotiable Step — validation hierarchy (syntax → schema → behavior → integration), CI pipeline analogy, when to use mock vs real
5. Real vs Mock — when each path is appropriate, with comparison table

**reference.mdx** — Quick-reference tables and templates:
- Terraform validation cheat sheet (8 commands with when-to-run guidance)
- Kubernetes and Helm validation cheat sheet (8 commands + ArgoCD sync status meanings)
- Common AI errors table (6 error types with example, detection, and fix strategy)
- CLAUDE.md template for Terraform projects
- CLAUDE.md template for GitOps projects
- Full validation workflow reference for both tracks

### Task 2: Module 6 Quiz and Exploratory Projects

**QUIZ.mdx** — 7 concept-focused questions:
1. AI failure modes (schema drift, hallucinated attributes, version mismatch)
2. `terraform validate` — syntax/schema check without API calls
3. `terraform plan` before apply — blast radius and safety net discipline
4. ArgoCD `selfHeal: true` — revert manual cluster changes to match Git
5. CLAUDE.md purpose — system context for versions, constraints, vocabulary
6. ArgoCD Git URL requirement — cluster cannot reach localhost filesystem; Git is source of truth
7. `mock_provider` vs real AWS plan — unit-test vs integration-test analogy

**PROJECTS.mdx** — 3 stretch projects (clearly marked exploratory/not required):
1. Multi-Environment Terraform (30 min, Track A) — dev/staging/prod tfvars with environment-specific thresholds
2. ArgoCD App-of-Apps (30 min, Track B) — parent Application CRD managing child applications
3. Cross-Track Integration (45 min, both tracks) — Terraform provisions infra, ArgoCD deploys app with coordination script

---

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Renamed section heading to avoid "prompt engineering" occurrence**
- **Found during:** Task 1 verification
- **Issue:** Section heading "Context Engineering vs. Prompt Engineering" contained the prohibited phrase "prompt engineering" per plan acceptance criteria
- **Fix:** Renamed to "Why Context Engineering Produces Better IaC Than Generic Requests" — preserves the contrast concept without the prohibited phrase
- **Files modified:** course-site/docs/module-06-ai-iac/reading/concepts.mdx
- **Commit:** f3481c8 (included in task commit)

No other deviations — plan executed closely as written.

---

## Known Stubs

None. All 7 files contain substantive content with no placeholder text or empty data. Quiz questions reference lab steps that exist (Track A and Track B labs from Plan 04). Exploratory projects reference starter/solution files that exist in the lab directory.

---

## Self-Check

Checking created files exist and commits are present.

| Check | Result |
|-------|--------|
| reading/_category_.json | FOUND |
| reading/concepts.mdx | FOUND |
| reading/reference.mdx | FOUND |
| quiz/_category_.json | FOUND |
| quiz/QUIZ.mdx | FOUND |
| exploratory/_category_.json | FOUND |
| exploratory/PROJECTS.mdx | FOUND |
| commit f3481c8 (reading materials) | FOUND |
| commit 92b873c (quiz + exploratory) | FOUND |

## Self-Check: PASSED
