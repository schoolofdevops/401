---
phase: 05-module-consolidation
plan: 02
subsystem: content
tags: [helm, terraform, superpowers, tdd, iac, lab-authoring, mdx]

# Dependency graph
requires:
  - "05-01: module-05-superpowers-iac/ directory scaffold with lab/ subdirectory and Terraform solution files"
provides:
  - "Track A: 90-minute Helm chart Superpowers lab (LAB-track-a-helm.mdx)"
  - "Track B: 90-minute Terraform Superpowers lab (LAB-track-b-terraform.mdx)"
affects:
  - "05-03 (module-05 README and reading content depend on lab structure established here)"

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "6-phase Superpowers lab structure: Phase 0 (Setup+Context), Phase 1 (Brainstorm), Phase 2 (TDD-RED), Phase 3 (Implement-GREEN), Phase 4 (Debug), Phase 5 (Verify+Review)"
    - "Context-first starter: CLAUDE.md with system state, gaps, constraints — no pre-written code"
    - "Helm TDD toolchain: helm lint + helm template | kubectl apply --dry-run=client"
    - "Terraform TDD toolchain: terraform test with mock_provider (offline, no AWS credentials)"
    - "CLAUDE.md encodes operational vocabulary (exact AWS attribute names) to pre-correct AI generation errors"

key-files:
  created:
    - "course-site/docs/module-05-superpowers-iac/lab/LAB-track-a-helm.mdx"
    - "course-site/docs/module-05-superpowers-iac/lab/LAB-track-b-terraform.mdx"
  modified: []

key-decisions:
  - "Context-first approach: CLAUDE.md as the starter eliminates need for pre-written code stubs — system state + gaps + constraints is sufficient context for AI to generate working IaC"
  - "Helm TDD uses existing toolchain (helm lint + kubectl dry-run) — no additional test frameworks required, reduces setup friction"
  - "Terraform TDD test file (unit.tftest.hcl) created before main.tf — enforces Iron Law of TDD, resource names in tests become the contract for code generation"
  - "CLAUDE.md Architecture section includes exact AWS attribute names to pre-correct AI generation errors at context stage"
  - "Track B resource names match test file names (aws_instance.app, not aws_instance.this) — deliberate mismatch from reference solution to demonstrate the AI contract concept"

# Metrics
duration: 4min
completed: 2026-04-07
---

# Phase 05 Plan 02: Lab Track Authoring Summary

**Authored two 90-minute Superpowers IaC labs: Track A applies the full brainstorm/TDD/implement/debug/verify+review cycle to Helm chart hardening (HPA, PDB, ServiceMonitor, resource limits, NOTES.txt); Track B applies the same cycle to building a Terraform EC2+CloudWatch+SNS module offline using mock_provider.**

## Performance

- **Duration:** 4 min
- **Started:** 2026-04-07T02:09:53Z
- **Completed:** 2026-04-07T02:14:28Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

### Task 1: Track A — Helm Chart Superpowers Lab

- Created `course-site/docs/module-05-superpowers-iac/lab/LAB-track-a-helm.mdx`
- 6-phase continuous walkthrough applying full Superpowers cycle to Helm chart production-hardening
- Phase 0: Tool verification + CLAUDE.md creation (system state, gaps, constraints)
- Phase 1: Brainstorm — AI produces gap analysis ranked by severity; teaching point: context quality drives output quality
- Phase 2: TDD-RED — `verify-chart.sh` executable script defines success criteria; MUST FAIL before any code
- Phase 3: Implement-GREEN — AI generates hpa.yaml, pdb.yaml, servicemonitor.yaml, NOTES.txt plus values.yaml updates
- Phase 4: Debug — systematic methodology for real AI generation errors (wrong apiVersions, label mismatches)
- Phase 5: Verify+Code Review — three-command verification suite + AI 5-dimension code review
- Word count: 2987 (within 2000-5000 range)
- All 23 acceptance criteria passed

### Task 2: Track B — Terraform Superpowers Lab

- Created `course-site/docs/module-05-superpowers-iac/lab/LAB-track-b-terraform.mdx`
- 6-phase continuous walkthrough applying full Superpowers cycle to Terraform module from scratch
- Phase 0: Version check (:::danger for 1.7+ requirement) + CLAUDE.md with exact AWS attribute names
- Phase 1: Brainstorm — resource inventory validation including data source requirement
- Phase 2: TDD-RED — unit.tftest.hcl created BEFORE main.tf (Iron Law); tests MUST FAIL
- Phase 3: Implement-GREEN — AI generates main.tf, variables.tf, outputs.tf matching test contracts
- Phase 4: Debug — systematic methodology for real Terraform AI errors (wrong metric names, resource name mismatches)
- Phase 5: Verify+Code Review — terraform validate + terraform test + diff against reference solution
- Word count: 2776 (within 2000-5000 range)
- All 21 acceptance criteria passed

## Task Commits

1. **Task 1: Track A Helm Superpowers Lab** — `24af01d` (feat)
2. **Task 2: Track B Terraform Superpowers Lab** — `2073070` (feat)

## Files Created/Modified

- `course-site/docs/module-05-superpowers-iac/lab/LAB-track-a-helm.mdx` — Track A: Helm chart hardening lab (90 min)
- `course-site/docs/module-05-superpowers-iac/lab/LAB-track-b-terraform.mdx` — Track B: Terraform EC2+CloudWatch+SNS lab (90 min)

## Decisions Made

- **Context-first starter pattern confirmed:** CLAUDE.md with system state, gaps, and constraints is the correct "starter" for Superpowers IaC labs. No pre-written code skeletons needed. This is more authentic to real DevOps workflows where you start from requirements, not from templates.

- **CLAUDE.md vocabulary encoding:** Track B's CLAUDE.md includes exact AWS attribute names in the Architecture section (`GreaterThanThreshold`, `CPUUtilization`, `evaluation_periods = 2`). This pre-corrects the most common AI Terraform generation errors at the context stage — before the AI writes a single line of code.

- **Test file contracts:** In Track B, the test file names (`aws_instance.app`, not `aws_instance.this`) become the contract for code generation. The resource names in the test are intentionally different from the reference solution to demonstrate that naming is a deliberate choice, not an accident.

- **Helm TDD uses existing toolchain:** `helm lint` + `helm template | kubectl apply --dry-run=client` requires no additional test frameworks. This minimizes setup friction and uses tools participants already know.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Known Stubs

None — both labs are complete and reference working tooling. No placeholder content.

## Self-Check: PASSED

All key files verified present:
- `course-site/docs/module-05-superpowers-iac/lab/LAB-track-a-helm.mdx` — FOUND
- `course-site/docs/module-05-superpowers-iac/lab/LAB-track-b-terraform.mdx` — FOUND

All commits verified:
- `24af01d` — Track A lab (feat(05-02))
- `2073070` — Track B lab (feat(05-02))

Plan verification:
- Both files exist in correct location
- Each has exactly 6 phases
- Track A: helm lint (11 occurrences), helm template (9 occurrences)
- Track B: mock_provider (13 occurrences), terraform test (13 occurrences)
- Neither lab references starter/ directory
- Both labs create CLAUDE.md as the context starter

---
*Phase: 05-module-consolidation*
*Completed: 2026-04-07*
