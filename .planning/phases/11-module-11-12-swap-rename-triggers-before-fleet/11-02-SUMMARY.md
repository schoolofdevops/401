---
phase: 11-module-11-12-swap-rename-triggers-before-fleet
plan: 02
subsystem: content
tags: [cross-references, module-swap, renumbering, docusaurus]

# Dependency graph
requires:
  - phase: 11-module-11-12-swap-rename-triggers-before-fleet
    provides: "Plan 01 renamed directories and updated internal content for module-11-triggers and module-12-fleet"
provides:
  - "All cross-module references updated: Module 11 = Triggers, Module 12 = Fleet across entire codebase"
  - "CLAUDE.md tool split table reflects correct module order"
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns: []

key-files:
  created: []
  modified:
    - course-site/docs/intro.mdx
    - course-site/docs/module-01-foundations/reading/reference.mdx
    - course-site/docs/module-04-impact/reading/reference.mdx
    - course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx
    - course-site/docs/module-10-domain-agent/README.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
    - course-site/docs/module-10-domain-agent/exploratory/PROJECTS.mdx
    - course-site/docs/module-14-capstone/README.mdx
    - course-site/docs/module-14-capstone/exploratory/PROJECTS.mdx
    - course-site/docs/resources/skills.mdx
    - course-site/docs/resources/agent-profiles.mdx
    - CLAUDE.md

key-decisions:
  - "No two-pass temp-marker needed: each reference was context-specific (Module 11 fleet -> Module 12, Module 12 triggers -> Module 11) so direct targeted edits avoided collision"

patterns-established: []

requirements-completed: [SWAP-02]

# Metrics
duration: 2min
completed: 2026-04-09
---

# Phase 11 Plan 02: Cross-Reference Updates Summary

**All cross-module references (13 .mdx files + CLAUDE.md) updated to reflect Module 11 = Triggers, Module 12 = Fleet swap**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-09T17:04:32Z
- **Completed:** 2026-04-09T17:07:12Z
- **Tasks:** 2
- **Files modified:** 14

## Accomplishments
- Updated 13 external .mdx files across modules 1, 4, 8, 10, 14, and resources to use correct post-swap numbering
- Fixed a pre-existing broken link in Module 10 README (module-11-fleet-workflows -> module-12-fleet)
- Updated CLAUDE.md tool split table from "Fleet/Triggers/Gov" to "Triggers/Fleet/Gov"

## Task Commits

Each task was committed atomically:

1. **Task 1: Update cross-references in all external module files** - `4d69d1b` (chore)
2. **Task 2: Update CLAUDE.md tool split table** - `7ad508b` (chore)

## Files Created/Modified
- `course-site/docs/intro.mdx` - Module 11/12 rows swapped: Triggers first, Fleet second
- `course-site/docs/module-01-foundations/reading/reference.mdx` - Squad reference -> Module 12
- `course-site/docs/module-04-impact/reading/reference.mdx` - Agent Fleet/Event Triggers rows swapped
- `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` - Fleet system -> Module 12
- `course-site/docs/module-10-domain-agent/README.mdx` - Track C skip link -> Module 12 fleet
- `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` - Next -> Module 12 fleet
- `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx` - Next -> Module 12 fleet
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` - Next -> Module 12 fleet
- `course-site/docs/module-10-domain-agent/exploratory/PROJECTS.mdx` - Fleet orchestration -> Module 12
- `course-site/docs/module-14-capstone/README.mdx` - Triggers prereq -> Module 11
- `course-site/docs/module-14-capstone/exploratory/PROJECTS.mdx` - Fleet architecture -> Module 12
- `course-site/docs/resources/skills.mdx` - sre-k8s-pod-health fleet lab -> Module 12, deployment-safety trigger -> Module 11
- `course-site/docs/resources/agent-profiles.mdx` - Morgan fleet management -> Module 12
- `CLAUDE.md` - Tool split parenthetical: Triggers/Fleet/Gov

## Decisions Made
- No two-pass temp-marker strategy needed: each reference was individually identifiable by surrounding context (fleet vs triggers semantics), so direct targeted edits were safe without collision risk

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed pre-existing broken link in Module 10 README**
- **Found during:** Task 1 (cross-reference updates)
- **Issue:** Module 10 README linked to `../module-11-fleet-workflows/README.mdx` which was already incorrect (directory was never named `module-11-fleet-workflows`)
- **Fix:** Updated to `../module-12-fleet/README.mdx` (correct post-swap directory name)
- **Files modified:** course-site/docs/module-10-domain-agent/README.mdx
- **Verification:** rg confirms no stale `module-11-fleet-workflows` references remain
- **Committed in:** 4d69d1b (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** Pre-existing broken link fixed alongside planned update. No scope creep.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 11 (Module 11/12 swap) is complete with both plans executed
- All cross-references verified: zero stale module-11-fleet or module-12-triggers paths in external files
- Ready for any subsequent content work

---
*Phase: 11-module-11-12-swap-rename-triggers-before-fleet*
*Completed: 2026-04-09*
