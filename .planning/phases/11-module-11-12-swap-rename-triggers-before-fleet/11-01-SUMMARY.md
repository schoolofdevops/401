---
phase: 11-module-11-12-swap-rename-triggers-before-fleet
plan: 01
subsystem: content-structure
tags: [docusaurus, module-renumbering, directory-rename, sidebar]

# Dependency graph
requires:
  - phase: 04-remaining-content
    provides: "Original module-11-fleet and module-12-triggers content"
  - phase: 08-agent-triggers
    provides: "Trigger lab content (AlertManager, CronJob, webhooks) referenced in module-12/triggers"
  - phase: 09-multi-agent-workflows-production
    provides: "Fleet FLEET-01 lab content and productionization reference"
provides:
  - "module-11-triggers directory with all triggers content and module-11-* frontmatter IDs"
  - "module-12-fleet directory with all fleet content and module-12-* frontmatter IDs"
  - "Correct sidebar positions (triggers=12, fleet=13) and Day/Session numbering"
  - "Updated prerequisites: fleet now requires Module 11 (triggers)"
affects: [11-02-PLAN, cross-references-in-other-modules, CLAUDE.md-tool-split-table]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Three-step git mv swap via temp directory to avoid collision"
    - "Careful cross-reference handling during module renumbering (self-refs vs cross-refs)"

key-files:
  created: []
  modified:
    - "course-site/docs/module-11-triggers/_category_.json"
    - "course-site/docs/module-11-triggers/README.mdx"
    - "course-site/docs/module-11-triggers/lab/LAB.mdx"
    - "course-site/docs/module-11-triggers/quiz/QUIZ.mdx"
    - "course-site/docs/module-11-triggers/reading/concepts.mdx"
    - "course-site/docs/module-11-triggers/reading/reference.mdx"
    - "course-site/docs/module-11-triggers/exploratory/PROJECTS.mdx"
    - "course-site/docs/module-12-fleet/_category_.json"
    - "course-site/docs/module-12-fleet/README.mdx"
    - "course-site/docs/module-12-fleet/lab/LAB.mdx"
    - "course-site/docs/module-12-fleet/quiz/QUIZ.mdx"
    - "course-site/docs/module-12-fleet/reading/concepts.mdx"
    - "course-site/docs/module-12-fleet/reading/reference.mdx"
    - "course-site/docs/module-12-fleet/exploratory/PROJECTS.mdx"

key-decisions:
  - "Sidebar positions preserved: triggers position=12, fleet position=13 (module_number + 1 pattern)"
  - "Fleet prerequisites updated to require Module 11 (triggers) before Module 12 (fleet)"
  - "Cross-references in fleet files correctly point to Module 11 for triggers content"

patterns-established:
  - "Module swap via three-step git mv: source -> tmp -> final to avoid directory collision"

requirements-completed: [SWAP-01]

# Metrics
duration: 10min
completed: 2026-04-09
---

# Phase 11 Plan 01: Directory Swap module-11/12 + Internal Content Updates Summary

**Atomic directory swap of module-11-fleet and module-12-triggers via three-step git mv, with all 14 internal files updated: frontmatter IDs, _category_.json, titles, Day/Session, prerequisites, and cross-references**

## Performance

- **Duration:** 10 min
- **Started:** 2026-04-09T16:51:25Z
- **Completed:** 2026-04-09T17:01:31Z
- **Tasks:** 2
- **Files modified:** 14 content files + 23 directory renames

## Accomplishments
- Directory swap completed: module-11-triggers (was module-12-triggers) and module-12-fleet (was module-11-fleet) now exist with correct names
- All frontmatter IDs updated: module-11-* in triggers, module-12-* in fleet (7 IDs per module)
- _category_.json files updated with correct labels, positions, and Docusaurus link IDs
- Day/Session corrected: triggers = Day 3 Session 5, fleet = Day 3 Session 6
- Prerequisites updated: triggers requires Module 10, fleet requires Module 11 (triggers)
- Cross-references handled correctly: fleet files referencing triggers content now say "Module 11", self-references say "Module 12"

## Task Commits

Each task was committed atomically:

1. **Task 1: Directory swap via git mv with temp directory** - `5763fac` (chore)
2. **Task 2: Update all internal content in both renamed modules** - `dc89851` (chore)

## Files Created/Modified

### Renamed (Task 1 - 23 files)
- `course-site/docs/module-12-triggers/` -> `course-site/docs/module-11-triggers/` (all files)
- `course-site/docs/module-11-fleet/` -> `course-site/docs/module-12-fleet/` (all files)

### Modified (Task 2 - 14 files)
- `course-site/docs/module-11-triggers/_category_.json` - Label "Module 11", position 12, link to module-11-readme
- `course-site/docs/module-11-triggers/README.mdx` - ID, title, heading, Day 3 Session 5, prereqs Module 10
- `course-site/docs/module-11-triggers/lab/LAB.mdx` - ID, title, heading, starter file path updated
- `course-site/docs/module-11-triggers/quiz/QUIZ.mdx` - ID, description, step references (12->11)
- `course-site/docs/module-11-triggers/reading/concepts.mdx` - ID updated
- `course-site/docs/module-11-triggers/reading/reference.mdx` - ID, body references (12->11)
- `course-site/docs/module-11-triggers/exploratory/PROJECTS.mdx` - ID, description, body references
- `course-site/docs/module-12-fleet/_category_.json` - Label "Module 12", position 13, link to module-12-readme
- `course-site/docs/module-12-fleet/README.mdx` - ID, title, heading, Day 3 Session 6, prereqs Module 11
- `course-site/docs/module-12-fleet/lab/LAB.mdx` - ID, title, heading, prereq cross-ref to Module 11
- `course-site/docs/module-12-fleet/quiz/QUIZ.mdx` - ID, description, self-references (11->12)
- `course-site/docs/module-12-fleet/reading/concepts.mdx` - ID, body self-reference (11->12)
- `course-site/docs/module-12-fleet/reading/reference.mdx` - ID, self-refs (11->12), cross-refs to triggers (12->11), file paths
- `course-site/docs/module-12-fleet/exploratory/PROJECTS.mdx` - ID, description, body self-references (11->12)

## Decisions Made
- Sidebar positions preserved: triggers=12, fleet=13 (matching module_number + 1 pattern used throughout)
- Fleet README prerequisites expanded: added "Module 11 completed (you have trigger infrastructure)" as explicit prereq
- LAB.mdx starter file path in triggers updated to reflect new directory structure (`course-site/docs/module-11-triggers/lab/starter/`)

## Deviations from Plan
None - plan executed exactly as written.

## Known Stubs
None - this plan only renames and renumbers, no new content created.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Plan 11-02 can proceed: cross-references in OTHER modules (7, 8, 9, 10, 13, 14, setup) and CLAUDE.md tool split table still need updating
- The internal content within module-11-triggers and module-12-fleet is fully updated

---
*Phase: 11-module-11-12-swap-rename-triggers-before-fleet*
*Completed: 2026-04-09*
