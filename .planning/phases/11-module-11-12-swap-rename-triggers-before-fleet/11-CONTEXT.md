# Phase 11: Module 11↔12 Swap — Context

**Gathered:** 2026-04-09
**Status:** Ready for planning

<domain>

## Phase Boundary

Rename current Module 12 (Triggers & Scheduling) to Module 11, and current Module 11 (Fleet Orchestration) to Module 12. This fixes a circular dependency where Module 11 (Fleet) required infrastructure set up in Module 12 (Triggers).

**After the swap:**
- Module 11 = Triggers, Scheduling, and Interfaces (was Module 12)
- Module 12 = Fleet Orchestration (was Module 11)

**Scope:** Directory renames, sidebar positions, all cross-references in course-site content, CLAUDE.md updates. NO content changes — just renumbering.

</domain>

<decisions>

## Implementation Decisions

### Rename Strategy: Atomic Swap via Temp Directory
- Rename `module-11-fleet` → `module-12-fleet` and `module-12-triggers` → `module-11-triggers`
- Use a temp name to avoid collision: `module-11-fleet` → `module-tmp-fleet` → `module-12-fleet`
- Then `module-12-triggers` → `module-11-triggers`

### Content Updates: Numbers Only, Not Substance
- Change "Module 11" to "Module 12" in fleet content
- Change "Module 12" to "Module 11" in triggers content
- Update all cross-references in OTHER modules (7, 8, 9, 10, 13, 14, setup)
- Do NOT rewrite lab content — just fix module numbers

### Sidebar Positions
- `_category_.json` in each module dir controls Docusaurus sidebar order
- Triggers gets `position: 11`, Fleet gets `position: 12`

### Prerequisites Updates
- New Module 12 (Fleet) prerequisites: "Module 11 (Triggers) complete" (was "Module 10")
- New Module 11 (Triggers) prerequisites: "Module 10 complete" (was "Modules 10-11")

### CLAUDE.md Tool Split Table
- Update the module-to-tool mapping table in project CLAUDE.md

</decisions>

<canonical_refs>

## Canonical References

### Directories to Rename
- `course-site/docs/module-11-fleet/` → `course-site/docs/module-12-fleet/`
- `course-site/docs/module-12-triggers/` → `course-site/docs/module-11-triggers/`

### Files With Cross-References to Update
- `course-site/docs/module-07-agent-skills/README.mdx` — may reference Module 11/12
- `course-site/docs/module-08-tool-integration/README.mdx` — may reference Module 11/12
- `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` — may reference Module 10/11
- `course-site/docs/module-09-design-patterns/README.mdx` — may reference Module 11
- `course-site/docs/module-10-domain-agent/README.mdx` — references Module 11
- `course-site/docs/module-13-governance/README.mdx` — references Module 11/12
- `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` — references Module 11/12
- `course-site/docs/module-14-capstone/README.mdx` — may reference Module 11/12
- `course-site/docs/setup.mdx` — may reference Module 11/12
- `CLAUDE.md` — Tool Split table references Module numbers

### Internal Files in Renamed Modules
- All `.mdx` files within module-11-fleet/ and module-12-triggers/ need internal ID and title updates
- `_category_.json` files need position updates
- Lab files need frontmatter `id:` field updates (e.g., `module-11-lab` → `module-12-lab`)

</canonical_refs>

<specifics>

## Specific Implementation Details

### Frontmatter ID Pattern
Current pattern: `id: module-11-*` in fleet files, `id: module-12-*` in triggers files
After swap: `id: module-12-*` in fleet files, `id: module-11-*` in triggers files

### _category_.json Updates
Fleet (currently module-11): `{"position": 11, "label": "11. Fleet Orchestration"}`
→ After: `{"position": 12, "label": "12. Fleet Orchestration"}`

Triggers (currently module-12): `{"position": 12, "label": "12. Triggers & Scheduling"}`
→ After: `{"position": 11, "label": "11. Triggers & Scheduling"}`

### Day 3 Session Numbering
- Module 11 (Triggers) becomes Day 3, Session 5
- Module 12 (Fleet) becomes Day 3, Session 6
- Update "Day" and "Session" references in both READMEs

</specifics>

<deferred>

## Deferred Ideas

None — this is a clean rename operation.

</deferred>

---

*Phase: 11*
*Context gathered: 2026-04-09*
