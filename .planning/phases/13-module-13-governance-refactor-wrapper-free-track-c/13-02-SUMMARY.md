---
phase: 13-module-13-governance-refactor-wrapper-free-track-c
plan: 02
subsystem: content
tags: [governance, soul-md, dangerous-patterns, two-layer, module-13, reading-materials]

# Dependency graph
requires:
  - phase: 13-module-13-governance-refactor-wrapper-free-track-c
    provides: "Plan 01 updated Track C lab to wrapper-free SOUL.md governance"
provides:
  - "Reading materials (concepts.mdx, reference.mdx) aligned with two-layer governance model"
  - "README.mdx prerequisites updated to Module 8 + KIND cluster"
  - "Historical note documenting wrapper removal for future reference"
affects: [module-13-governance, module-08, module-10]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Two-layer governance: DANGEROUS_PATTERNS (mechanical) + SOUL.md NEVER rules (behavioral)"
    - "Historical note pattern for deprecated mechanisms"

key-files:
  created: []
  modified:
    - "course-site/docs/module-13-governance/reading/reference.mdx"
    - "course-site/docs/module-13-governance/README.mdx"

key-decisions:
  - "concepts.mdx already correct -- zero edits needed (two-layer model was already in place)"
  - "Kept single historical note in reference.mdx Section 1.5 documenting wrapper removal -- provides context for anyone who sees old governance YAML files"
  - "Replaced three-layer defense table with two-layer table showing DANGEROUS_PATTERNS + SOUL.md only"

patterns-established:
  - "Two-layer defense model table: Layer 1 (DANGEROUS_PATTERNS, mechanical) + Layer 2 (SOUL.md NEVER rules, behavioral)"
  - "Historical deprecation notes use :::note admonition blocks"

requirements-completed: [GOVR-01, GOVR-02]

# Metrics
duration: 6min
completed: 2026-04-09
---

# Phase 13 Plan 02: Update Reading Materials and README Summary

**Removed 192 lines of wrapper_allowlist config examples and wrapper enforcement docs from reference.mdx; replaced three-layer defense model with two-layer (DANGEROUS_PATTERNS + SOUL.md); updated README prerequisites to Module 8**

## Performance

- **Duration:** 6 min
- **Started:** 2026-04-09T17:40:27Z
- **Completed:** 2026-04-09T17:46:35Z
- **Tasks:** 2 (1 no-op verification, 1 substantive edit)
- **Files modified:** 2

## Accomplishments
- Removed all wrapper_allowlist blocks from L2, L3, L4-Track-A, L4-Track-B, and L4-Track-C config examples in reference.mdx
- Replaced Section 1.5 (Course-Local Wrapper Enforcement) with a concise two-layer defense model table and a historical deprecation note
- Updated diff commands section to reflect simpler config diffs (no wrapper blocks)
- Updated README.mdx prerequisites from Module 10 to Module 8, lab location from "Hermes repo" to "per-track in this course site"
- Verified concepts.mdx was already aligned with two-layer model -- no changes needed

## Task Commits

Each task was committed atomically:

1. **Task 1: Update concepts.mdx -- two-layer model for Track C** - No commit (file already correct, zero changes needed)
2. **Task 2: Update reference.mdx + README.mdx** - `9759782` (chore)

## Files Created/Modified
- `course-site/docs/module-13-governance/reading/reference.mdx` - Removed 192 lines of wrapper_allowlist configs and wrapper enforcement docs; replaced with two-layer defense model
- `course-site/docs/module-13-governance/README.mdx` - Prerequisites updated to Module 8; lab location updated to per-track

## Decisions Made
- concepts.mdx required zero edits -- the two-layer governance model was already correctly documented there, confirming the original author's intent matched the wrapper-free approach
- Kept a single historical note in reference.mdx documenting that wrapper_allowlist existed and was removed -- this provides archaeological context for anyone who encounters old governance YAML files in git history
- Track B L4 comment block preserved the "SOUL.md is load-bearing" narrative while removing the wrapper_allowlist config block and Phase 7 references

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Updated lab row in README module contents table**
- **Found during:** Task 2 (README.mdx update)
- **Issue:** Module contents table row for Lab still said "(Hermes repo)" after info callout was updated
- **Fix:** Changed Lab row to "(per-track)" for consistency with the updated info callout
- **Files modified:** course-site/docs/module-13-governance/README.mdx
- **Verification:** Visual inspection of README.mdx confirms consistency
- **Committed in:** 9759782 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 missing critical)
**Impact on plan:** Minor consistency fix within planned scope. No scope creep.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Module 13 reading materials and README now fully aligned with wrapper-free Track C governance model
- concepts.mdx, reference.mdx, and README.mdx all teach two-layer model consistently
- Ready for verification/audit of the complete Module 13 refactor (Plans 01 + 02)

## Self-Check: PASSED

- All files exist: reference.mdx, README.mdx, concepts.mdx, SUMMARY.md
- Commit 9759782 verified in git log

---
*Phase: 13-module-13-governance-refactor-wrapper-free-track-c*
*Completed: 2026-04-09*
