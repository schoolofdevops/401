# Phase 4: Remaining Content - Context

**Gathered:** 2026-04-05
**Status:** Ready for planning

<domain>
## Phase Boundary

Fill all content gaps across all 14 modules: create reading/quiz/exploratory content for Modules 7-14 (labs are in Hermes repo for 7-8, 10-13), build Module 9 (design patterns) and Module 14 (capstone) specific artifacts, create instructor facilitator guides for Days 1-3, Udemy section outline, solo fallbacks for team exercises, and run vocabulary audit. All content in Docusaurus MDX format.

</domain>

<decisions>
## Implementation Decisions

### Modules 7-13 Content (Labs in Hermes Repo)
- **D-47:** For modules whose labs are in the Hermes repo (7, 8, 10, 11, 12, 13), we create concepts.mdx, reference.mdx, QUIZ.mdx, PROJECTS.mdx, and README.mdx in this repo's Docusaurus site.
- **D-48:** Content describes WHAT participants will learn/build without duplicating Hermes lab instructions. Reading materials provide conceptual foundation — participants read before doing the Hermes lab.
- **D-49:** Use HANDOFF.md Layer 3-5 concept tables as the reading material checklist for these modules.

### Module 9 — Design Patterns
- **D-50:** Pattern taxonomy: advisor, investigator, proposal, guardian — each mapped to Hermes capabilities with concrete examples.
- **D-51:** Autonomy spectrum L1 (Assistive) → L4 (Semi-autonomous) with DevOps analogies and concrete promotion criteria.
- **D-52:** No lab in this repo — reading/quiz only. Hermes repo has the examples.

### Module 14 — Capstone
- **D-53:** Presentation template: what teams/individuals should cover in their demo (problem statement, agent design, live demo, governance spec, 30-day plan).
- **D-54:** 30-day deployment roadmap template: post-workshop implementation plan with weekly milestones.
- **D-55:** Evaluation rubric: scored criteria for capstone assessment. Solo-completable for Udemy.

### Instructor Facilitator Guides
- **D-56:** Three guides: Day 1, Day 2, Day 3 — each with timing, module transitions, debrief prompts, common participant questions.
- **D-57:** Format: separate Docusaurus section (e.g., `instructor/`) not visible in the participant sidebar. Or a clearly-marked `_instructor/` directory.

### All-Module Content Sweep
- **D-58:** Fill gaps: every module (1-14) must have concepts.mdx, reference.mdx, QUIZ.mdx, PROJECTS.mdx, README.mdx. Modules 1-6 already have most — check for missing PROJECTS.mdx files.
- **D-59:** Update stale README.mdx overview tables (Phase 2 verifier flagged "coming soon" placeholders).

### Format Overlays
- **D-60:** Udemy section outline mapping modules to Udemy sections.
- **D-61:** Solo fallbacks documented for all team exercises (Module 4 scoring, Module 11 fleet, Module 14 capstone).
- **D-62:** Vocabulary audit: grep for "prompt engineering" across all content — zero positive instances after Module 1.

### Claude's Discretion
- Specific content depth for Modules 7-13 reading materials (constrained by HANDOFF.md concept tables)
- Instructor guide timing estimates per module
- Udemy section structure and naming
- PROJECTS.mdx stretch project ideas for each module
- Whether instructor guides go in Docusaurus sidebar or separate directory

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Content Checklists
- `HANDOFF.md` — Layer 1-5 concept tables (reading material checklist for ALL modules), module-by-module breakdown
- `.planning/REQUIREMENTS.md` — MOD9, MOD14, CONTENT, FMT requirements
- `.planning/ROADMAP.md` — Phase 4 success criteria

### Existing Content (gap-fill reference)
- `course-site/docs/` — All existing module content (Modules 1-6 complete)
- `course-site/docs/module-01-foundations/` — Pattern reference for complete module structure

### External References
- Hermes codebase at `/Users/gshah/work/agentic/devops/hermes-agent/` — Modules 7-13 lab context
- `.planning/research/FEATURES.md` — Feature landscape, table stakes, differentiators

</canonical_refs>

<code_context>
## Existing Code Insights

### What's Already Built (Modules 1-6)
- Module 1: LAB, concepts, reference, QUIZ — complete. Missing: PROJECTS.mdx
- Module 2: LAB, concepts, reference, QUIZ — complete. Missing: PROJECTS.mdx
- Module 3: LAB, concepts, reference, QUIZ — complete. Missing: PROJECTS.mdx
- Module 4: LAB, concepts, reference, QUIZ — complete. Missing: PROJECTS.mdx
- Module 5a: LAB (2 tracks), concepts, reference, QUIZ — complete. Missing: PROJECTS.mdx
- Module 5b: LAB, concepts, reference, QUIZ, PROJECTS — complete
- Module 6: LAB (2 tracks), concepts, reference, QUIZ, PROJECTS — complete

### What Needs Creating (Modules 7-14)
- Modules 7, 8, 10, 11, 12, 13: Full Docusaurus scaffold + concepts + reference + QUIZ + PROJECTS + README (labs are in Hermes)
- Module 9: Full scaffold + concepts + reference + QUIZ + PROJECTS + README (no lab in this repo)
- Module 14: Full scaffold + capstone templates + README

### Missing Across All
- PROJECTS.mdx for Modules 1-4 and 5a
- Updated README.mdx tables (stale "coming soon" placeholders)
- Instructor guides (Day 1/2/3)
- Udemy section outline

</code_context>

<specifics>
## Specific Ideas

- HANDOFF.md has detailed concept tables for every layer — use these as the authoritative checklist
- Module 9 design patterns should use real Hermes profile examples, not abstract descriptions
- Module 14 capstone must work for solo Udemy learners, not just workshop teams
- Vocabulary audit is the final quality gate — zero "prompt engineering" after Module 1

</specifics>

<deferred>
## Deferred Ideas

None — this is the final phase.

</deferred>

---

*Phase: 04-remaining-content*
*Context gathered: 2026-04-05*
