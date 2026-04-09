---
phase: 13-module-13-governance-refactor-wrapper-free-track-c
plan: 01
subsystem: content
tags: [governance, soul-md, never-rules, kubernetes, track-c, module-13]

# Dependency graph
requires:
  - phase: 07-guardrails-governance
    provides: Original Track C governance lab with wrapper_allowlist enforcement
provides:
  - Rewritten Track C governance lab with SOUL.md-primary L1-L4 progression
  - Two-layer governance model (DANGEROUS_PATTERNS + SOUL.md NEVER) replacing three-layer model
affects: [module-13-reading, module-14-capstone]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "SOUL.md NEVER rules as primary governance mechanism for kubectl commands"
    - "Two-layer model: DANGEROUS_PATTERNS (mechanical/shell) + SOUL.md NEVER (behavioral/kubectl)"
    - "L1-L4 progression via SOUL.md NEVER rule editing (not wrapper_allowlist expansion)"

key-files:
  created: []
  modified:
    - course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx

key-decisions:
  - "SOUL.md NEVER rules are the primary governance mechanism for kubectl commands -- wrapper_allowlist removed entirely"
  - "Two-layer model replaces three-layer model: DANGEROUS_PATTERNS for shell + SOUL.md NEVER for kubectl"
  - "L3 and L4 progression implemented via SOUL.md editing (removing NEVER rules) rather than wrapper_allowlist expansion"
  - "SOUL.md backup instruction added since learners now edit SOUL.md during the lab"

patterns-established:
  - "SOUL.md-primary governance: kubectl verbs governed by behavioral NEVER rules, not mechanical wrapper patterns"
  - "SOUL.md backup required when labs edit NEVER rules"

requirements-completed: [GOVR-01, GOVR-02]

# Metrics
duration: 5min
completed: 2026-04-09
---

# Phase 13 Plan 01: Rewrite Track C Governance Lab Summary

**Track C governance lab rewritten with SOUL.md NEVER rules as primary L1-L4 enforcement -- zero wrapper_allowlist, zero HERMES_LAB_MODE, two-layer model throughout**

## Performance

- **Duration:** 5 min
- **Started:** 2026-04-09T17:41:03Z
- **Completed:** 2026-04-09T17:46:26Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Complete rewrite of LAB-track-c-kubernetes.mdx (1023 lines) with SOUL.md-primary governance
- L1-L4 progression uses SOUL.md NEVER rule editing as the trust escalation mechanism
- DANGEROUS_PATTERNS rm -rf demo preserved alongside SOUL.md refusal demo
- New Challenge 2: "Why SOUL.md Drift Is a Governance Incident" replaces old wrapper_allowlist challenge
- Zero references to HERMES_LAB_MODE, wrapper_allowlist, GOVERNANCE REJECTED, mock-kubectl, or any wrapper infrastructure

## Task Commits

Each task was committed atomically:

1. **Task 1: Rewrite LAB-track-c-kubernetes.mdx with SOUL.md-primary governance** - `021c729` (feat)

## Files Created/Modified
- `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` - Complete rewrite: 16-step Track C governance lab with SOUL.md NEVER rules as primary enforcement, two-layer model, SOUL.md backup instruction, L1-L4 NEVER rule progression table

## Decisions Made
- SOUL.md NEVER rules as primary governance: kubectl verbs are not in DANGEROUS_PATTERNS, so SOUL.md is the only protection. This was already the design; the lab now teaches it explicitly.
- Two-layer model terminology: Layer 1 = DANGEROUS_PATTERNS (mechanical, shell), Layer 2 = SOUL.md NEVER (behavioral, kubectl). Old Layer 1 (wrapper_allowlist) removed entirely.
- L3/L4 implement trust escalation by editing SOUL.md to remove NEVER rules (exec at L3; apply/patch at L4). Delete/drain/cordon are permanent NEVER at all levels.
- SOUL.md backup instruction added to Step 1 because learners now edit SOUL.md directly during the lab.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Known Stubs
None - all content is fully written.

## Next Phase Readiness
- Track C lab is complete and wrapper-free
- Ready for Plan 02 (supporting files: README, reading, reference updates)
- SOUL.md backup pattern established for any future labs that edit NEVER rules

## Self-Check: PASSED

- [x] `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` exists (1023 lines)
- [x] Commit `021c729` exists in git log
- [x] Zero wrapper references (HERMES_LAB_MODE, wrapper_allowlist, GOVERNANCE REJECTED, mock-kubectl, etc.)
- [x] Zero "three-layer" references
- [x] 35+ "SOUL.md NEVER" references (required >= 5)
- [x] 39+ DANGEROUS_PATTERNS references (required >= 3)
- [x] 8 rm -rf references (required >= 1)
- [x] 6 two-layer references (required >= 1)
- [x] 4 SOUL.md.backup references
- [x] Steps 1-16 present with L1-L4 in headers

---
*Phase: 13-module-13-governance-refactor-wrapper-free-track-c*
*Completed: 2026-04-09*
