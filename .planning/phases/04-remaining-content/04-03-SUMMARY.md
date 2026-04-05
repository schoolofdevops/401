---
phase: 04-remaining-content
plan: 03
subsystem: course-site/instructor
tags: [instructor-guides, udemy, solo-fallbacks, vocabulary-audit, lab-format, facilitation]

requires:
  - phase: 04-remaining-content
    plan: 02
    provides: Modules 7-13 content and gap-fills for Modules 1-5a; Module 11 solo learner callout

provides:
  - instructor/day-1-guide.md: Day 1 facilitator guide (Modules 1-4) with timing, transitions, debrief prompts, Q&A
  - instructor/day-2-guide.md: Day 2 facilitator guide (Modules 5a/5b/6) with track selection, stall points
  - instructor/day-3-guide.md: Day 3 facilitator guide (Modules 7-14) with agent build facilitation, capstone presentation
  - instructor/udemy-outline.md: 14 modules mapped to 15 Udemy sections with content types and time estimates
  - Module 4 README.mdx: Solo Learner callout added (solo-completable scoring exercise)
  - Module 3 LAB.mdx: Deliverable statement added at top (FMT-05 compliance)
  - Vocabulary audit: confirmed zero positive "prompt engineering" uses in Modules 7-14

affects: [course-delivery, udemy-production, instructor-prep]

tech-stack:
  added: []
  patterns:
    - "Instructor guides at project root instructor/ directory, not inside Docusaurus docs/ — per D-57"
    - "Plain markdown (not MDX) for instructor-facing content — trainer tools, not participant content"
    - "Solo Learner :::info callout pattern applied to Module 4 README (matching Module 11 and 14 pattern)"
    - "Deliverable: bold line immediately after title/duration in LAB.mdx files"

key-files:
  created:
    - instructor/day-1-guide.md
    - instructor/day-2-guide.md
    - instructor/day-3-guide.md
    - instructor/udemy-outline.md
  modified:
    - course-site/docs/module-04-impact/README.mdx
    - course-site/docs/module-03-bridge/lab/LAB.mdx

key-decisions:
  - "Instructor guides placed at project root instructor/ (not inside Docusaurus) — clean separation from participant content, not accidentally published"
  - "Module 7 prompt engineering instances (contrast/negation + wrong quiz answer) are pedagogically intentional — zero positive uses, vocabulary audit passes"
  - "Module 1 LAB.mdx uses equivalent expected result language (What you'll see/What changes) per layer — counts as FMT-04 compliant"
  - "Solo Learner callout added to Module 4 README matching the established :::info pattern from Modules 11 and 14"
  - "Udemy section 15 maps capstone — 15 Udemy sections cover all 14 course modules with Section 6 separating Module 5b"

patterns-established:
  - "Instructor guide structure: Pre-day checklist → timed facilitator flow → common Q&A per module → facilitation notes"
  - "Udemy section format: content types checklist + estimated video length + downloadable resources + solo-completion note"
  - "Vocabulary audit disposition: Module 1 = allowed (introduction), Modules 2-6 = contrast references allowed, Modules 7-14 = zero positive uses required"

requirements-completed: [CONTENT-06, FMT-01, FMT-02, FMT-03, FMT-04, FMT-05]

duration: 10min
completed: 2026-04-05
---

# Phase 4 Plan 3: Instructor Guides, Udemy Outline, and Final Audits Summary

**Three instructor facilitator guides (Day 1-3), Udemy 15-section course outline, solo fallbacks verified for all team exercises, lab format audit with deliverable and expected result coverage confirmed, and vocabulary audit passing with zero "prompt engineering" positive uses in Modules 7-14**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-04-05T06:54:30Z
- **Completed:** 2026-04-05T07:04:30Z
- **Tasks:** 2
- **Files modified:** 6 (4 created + 2 modified)

## Accomplishments

- Three instructor guides covering all 14 modules: Day 1 (Modules 1-4), Day 2 (Modules 5a/5b/6), Day 3 (Modules 7-14) — each with timed facilitator flow, setup checklists, common Q&A, and facilitation notes
- Udemy section outline mapping all 14 modules to 15 sections with content types (video/reading/quiz/downloadable), estimated recording lengths, and solo-completion notes per section
- Solo fallback verified for all three team exercises: Module 4 (solo-completable callout added), Module 11 (existing callout confirmed), Module 14 (existing callout confirmed)
- Lab format audit: 9 of 9 lab files have deliverable statements at top (Module 3 fixed); all labs have equivalent expected result validation language
- Vocabulary audit: zero "prompt engineering" positive uses in Modules 7-14; Module 7 contrast/negation uses are pedagogically intentional; Modules 2-6 contrast references documented as acceptable educational scaffolding

## Task Commits

Each task was committed atomically:

1. **Task 1: Instructor facilitator guides and Udemy section outline** - `89eb01b` (feat)
2. **Task 2: Solo fallbacks, lab format audit, and vocabulary audit** - `c7cea32` (feat)

**Plan metadata:** [pending final commit]

## Files Created/Modified

- `instructor/day-1-guide.md` — Modules 1-4 facilitator guide: icebreaker, Module 1 Layer demo sequence, Module 2 dual-path setup, Module 3 Hermes live demo, Module 4 Automation Quadrant exercise (1318 lines total across all 4 guides)
- `instructor/day-2-guide.md` — Modules 5a/5b/6 facilitator guide: Step 0 gate enforcement, track selection, GSD workflow live demo, ArgoCD memory patch stall point
- `instructor/day-3-guide.md` — Modules 7-14 facilitator guide: SKILL.md peer review, blocked command live demo, Module 9 pattern vote, Module 10 capstone build, Module 14 rubric-facilitated presentations
- `instructor/udemy-outline.md` — 15 Udemy sections with content type checklists, estimated video lengths, downloadable resources, solo-completion notes, and total course time estimate (~25 hours)
- `course-site/docs/module-04-impact/README.mdx` — Added :::info Solo Learner callout (solo-completable scoring exercise for Udemy learners)
- `course-site/docs/module-03-bridge/lab/LAB.mdx` — Added **Deliverable:** statement at top (FMT-05 compliance; was the only lab missing one)

## Decisions Made

- Instructor guides at project root `instructor/` (not inside Docusaurus) — clean separation, not accidentally published to the course site
- Module 7 contrast/negation uses of "prompt engineering" are acceptable: "This is NOT prompt engineering" (README.mdx) and wrong-answer option D in QUIZ.mdx are pedagogically intentional
- Module 1 LAB.mdx equivalent validation language ("What you'll see", "What changes") counts as FMT-04 compliant — the per-layer comparison is the validation mechanism
- Udemy split: Module 5a and 5b become two separate Udemy sections (5 and 6) despite being in one course module — this is the natural split for self-paced pacing

## Vocabulary Audit Results

| Location | Count | Disposition |
|----------|-------|-------------|
| Module 1 (intro + quiz + reference) | Multiple | ALLOWED — introduction and contrast framing |
| Module 3 reference.mdx | 1 | ALLOWED — explicit contrast ("context engineering matters MORE than prompt engineering") |
| Module 5b quiz/concepts | Multiple | ALLOWED — explicit contrast framing (Module 1 scaffolding reference) |
| Module 1 exploratory PROJECTS.mdx | 1 | ALLOWED — "prompt engineering → context engineering" evolution reference |
| Module 7 README.mdx | 1 | ALLOWED — negation ("This is NOT prompt engineering") |
| Module 7 QUIZ.mdx | 1 | ALLOWED — wrong answer option D (pedagogical) |
| Modules 8-14 | 0 | PASS — zero instances |

**Audit result: PASS** — Zero positive uses across all content. All instances are either Module 1 foundational, explicit contrast references, or pedagogical wrong-answer options.

## Lab Format Audit Results

| Lab File | Deliverable at Top | Expected Result Blocks |
|----------|-------------------|----------------------|
| module-01: LAB.mdx | Yes ("Deliverable:" line 12) | Equivalent ("What you'll see", "What changes" per layer) |
| module-02: LAB.mdx | Yes | 10 blocks |
| module-03: LAB.mdx | **Added** (Deliverable line) | 6 blocks |
| module-04: LAB.mdx | Yes | 5 blocks |
| module-05a: LAB-track-a-helm.mdx | Yes | 9 blocks |
| module-05a: LAB-track-b-cicd.mdx | Yes | 9 blocks |
| module-05b: LAB.mdx | Yes | 18 blocks |
| module-06: LAB-track-a-terraform.mdx | Yes | Equivalent (9 expected patterns) |
| module-06: LAB-track-b-gitops.mdx | Yes | Equivalent (9 expected patterns) |

**Audit result: PASS** — All 9 lab files have deliverable statements. All have adequate expected result coverage.

## Deviations from Plan

None — plan executed exactly as written.

Task 2 required verifying pre-existing solo fallbacks in Modules 11 and 14 (both confirmed present from Plans 01 and 02). Only Module 4 needed a solo callout added. Module 3 LAB.mdx was the only lab file missing a Deliverable statement.

## Known Stubs

None — all instructor guides, Udemy outline, and audit results are substantive. No placeholder content.

## Next Phase Readiness

This is the FINAL plan of the FINAL phase. Course content is complete:
- All 14 modules have full content (README, concepts, reference, QUIZ, PROJECTS, lab)
- Instructor facilitator guides exist for all 3 days
- Udemy section outline maps the complete course structure
- Solo fallbacks documented for all team exercises
- Vocabulary audit passes with zero violations in Modules 7-14
- Lab format audit passes with deliverables and expected results across all labs

## Self-Check: PASSED

- FOUND: instructor/day-1-guide.md
- FOUND: instructor/day-2-guide.md
- FOUND: instructor/day-3-guide.md
- FOUND: instructor/udemy-outline.md
- FOUND: course-site/docs/module-04-impact/README.mdx (with Solo Learner callout)
- FOUND: course-site/docs/module-03-bridge/lab/LAB.mdx (with Deliverable statement)
- COMMIT 89eb01b: confirmed — feat(04-03): instructor facilitator guides (Day 1-3) and Udemy section outline
- COMMIT c7cea32: confirmed — feat(04-03): solo fallbacks, lab format audit, and vocabulary audit

---
*Phase: 04-remaining-content*
*Completed: 2026-04-05*
