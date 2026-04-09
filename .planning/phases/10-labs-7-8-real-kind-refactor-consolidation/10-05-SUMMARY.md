---
phase: 10-labs-7-8-real-kind-refactor-consolidation
plan: 05
subsystem: infra
tags: [deprecation, mock-mode, kind, wrappers, mock-data, archival]

# Dependency graph
requires:
  - phase: 10-01
    provides: Module 7 Track C refactored to real KIND (zero mock references)
  - phase: 10-02
    provides: Module 8 Track C consolidated with Module 10 (zero mock references)
  - phase: 10-04
    provides: SETUP.mdx cleaned of mock-mode aliases and env vars
provides:
  - Deprecation notices in infrastructure/wrappers/ and infrastructure/mock-data/
  - Verified zero mock dependencies in refactored Track C labs
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Deprecation-not-deletion: archive unused infrastructure with README.md notices instead of removing"

key-files:
  created:
    - infrastructure/wrappers/README.md
    - infrastructure/mock-data/README.md
  modified: []

key-decisions:
  - "Track C HERMES_LAB_MODE negation reference kept (line 143 of LAB-track-c-kubernetes.mdx says 'No HERMES_LAB_MODE needed') -- pedagogically correct, not a dependency"
  - "Unified LAB.mdx files still reference mock mode for Tracks A/B/D -- intentional, those tracks still use mock mode"

patterns-established:
  - "Deprecation README pattern: Status header, Why Deprecated, Why Kept, Current Usage, Related sections"

requirements-completed: [LAB-05]

# Metrics
duration: 2min
completed: 2026-04-09
---

# Phase 10 Plan 05: Infrastructure Archival & Deprecation Summary

**Deprecation notices added to infrastructure/wrappers/ and mock-data/ directories with verified zero Track C lab dependencies on mock infrastructure**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-09T15:11:38Z
- **Completed:** 2026-04-09T15:13:59Z
- **Tasks:** 3
- **Files modified:** 2

## Accomplishments
- Created deprecation README.md in infrastructure/wrappers/ explaining mock wrapper scripts are archived (not used by current labs)
- Created deprecation README.md in infrastructure/mock-data/ explaining mock fixtures are archived (not used by current labs)
- Verified refactored Track C labs (Modules 7 and 8) have zero functional dependencies on wrappers/ or mock-data/ directories
- Confirmed infrastructure/scenarios/k8s/ failure manifests are properly integrated (7 references across Track C labs)

## Task Commits

Each task was committed atomically:

1. **Tasks 1-3: Deprecation notices + verification** - `c622b55` (chore)

**Plan metadata:** (pending final commit)

## Files Created/Modified
- `infrastructure/wrappers/README.md` - Deprecation notice: wrappers kept for reference, not used by course labs (34 lines)
- `infrastructure/mock-data/README.md` - Deprecation notice: mock data kept for reference, not used by course labs (34 lines)

## Decisions Made
- Track C lab files verified separately from unified LAB.mdx (which still serves Tracks A/B/D with mock mode)
- The single HERMES_LAB_MODE reference in Track C lab is a negation ("No HERMES_LAB_MODE needed") -- pedagogically correct, not a dependency
- Original wrapper scripts and mock data files preserved unchanged (deprecation-not-deletion per phase context decision)

## Deviations from Plan

None -- plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required

None -- no external service configuration required.

## Known Stubs

None -- deprecation notices are complete documents with no placeholder content.

## Verification Results

| Check | Expected | Actual | Result |
|-------|----------|--------|--------|
| infrastructure/wrappers/README.md exists | Yes | Yes | PASS |
| infrastructure/mock-data/README.md exists | Yes | Yes | PASS |
| Wrappers README contains "deprecated" | >= 1 | 3 | PASS |
| Mock-data README contains "deprecated" | >= 1 | 3 | PASS |
| Track C wrappers/ references | 0 | 0 | PASS |
| Track C mock-data/ references | 0 | 0 | PASS |
| Track C scenarios/k8s/ references | >= 1 | 7 | PASS |
| Original wrapper scripts preserved | 3 files | 3 files | PASS |

## Next Phase Readiness
- Phase 10 is complete: all 5 plans executed (Module 7 refactor, Module 8 consolidation, Module 10 Track C removal, SETUP.mdx cleanup, infrastructure archival)
- Mock infrastructure archived with deprecation notices
- All Track C labs verified to work without mock dependencies
- Ready for milestone completion audit

## Self-Check: PASSED

All files verified present, all commits verified in git log.

---
*Phase: 10-labs-7-8-real-kind-refactor-consolidation*
*Completed: 2026-04-09*
