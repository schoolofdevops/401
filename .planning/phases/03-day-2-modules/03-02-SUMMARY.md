---
phase: 03-day-2-modules
plan: "02"
subsystem: course-content
tags: [docusaurus, gsd, prometheus, grafana, context-engineering, claude-mem, mcp-memory, tdd, helm]

# Dependency graph
requires:
  - phase: 03-day-2-modules
    provides: Module 5a structured coding content (position 5 in Docusaurus nav)
  - phase: 02-day-1-modules
    provides: Docusaurus site structure, module MDX pattern, context engineering vocabulary
  - phase: 01-foundation
    provides: Reference app (api-gateway, catalog, worker), Prometheus prometheus-lab-values.yaml

provides:
  - Module 5b directory at course-site/docs/module-05b-ai-workflows/ (position 6)
  - Composite LAB.mdx with 4 sections (GSD workflow 30min, context engineering 20min, memory 15min, plan modes 10min)
  - 18 Expected result blocks throughout the lab
  - PrometheusRule CRD examples for 3 alerting rules (ApiGatewayDegraded, CatalogServiceDown, WorkerHeartbeatMissing)
  - Grafana dashboard JSON structure for 3-panel reference app dashboard
  - CLAUDE.md template for system context engineering practical
  - Parallel claude-mem and Crush/MCP memory paths
  - Superpowers exploratory PROJECTS.mdx with 3 stretch projects

affects: [03-day-2-modules, 04-reading-quizzes, module-06-iac]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Composite lab pattern: multiple timed sections in a single LAB.mdx file"
    - "Parallel tool paths: Claude Code (claude-mem) and Crush (MCP memory) in same lab"
    - "GSD workflow as the primary pedagogical arc: new-project → discuss → plan → execute → verify"
    - "Expected result blocks present after every actionable step"
    - "Collapsible details blocks for long expected outputs (YAML, JSON)"

key-files:
  created:
    - course-site/docs/module-05b-ai-workflows/_category_.json
    - course-site/docs/module-05b-ai-workflows/README.mdx
    - course-site/docs/module-05b-ai-workflows/lab/_category_.json
    - course-site/docs/module-05b-ai-workflows/lab/LAB.mdx
    - course-site/docs/module-05b-ai-workflows/exploratory/_category_.json
    - course-site/docs/module-05b-ai-workflows/exploratory/PROJECTS.mdx
  modified: []

key-decisions:
  - "Module 5b position 6 in Docusaurus nav (after Module 5a at position 5)"
  - "Single composite LAB.mdx chosen over separate files — 4 sections flow as one 75-minute experience"
  - "GSD workflow lab is Section 1 (30 min) — most detail, most guided, the centerpiece"
  - "WorkerHeartbeatMissing alert documented as requiring postgres-exporter stretch exercise (not immediately functional)"
  - "claude-mem and Crush paths are parallel paths in Section 3 — participants follow one based on their tool choice"
  - "Superpowers in exploratory only (not required) per D-40 decision"

patterns-established:
  - "Composite lab: timed sections with clear deliverables at section header level"
  - "Before/After comparison pattern for context engineering teaching"
  - "Parallel paths pattern: same concept, two tool implementations side-by-side"
  - "Decision rule pattern: explicit 'when to use X vs Y' table for tool choices"

requirements-completed: [MOD5-03, MOD5-04, MOD5-05, MOD5-06, MOD5-07]

# Metrics
duration: 20min
completed: 2026-04-04
---

# Phase 3 Plan 02: Module 5b AI Workflow Tools Summary

**Module 5b composite lab: GSD full-cycle workflow building Prometheus alerting rules + Grafana dashboard, CLAUDE.md context engineering practical with before/after comparison, parallel claude-mem/MCP memory paths, and plan mode decision framework**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-04-04T20:00:25Z
- **Completed:** 2026-04-04T20:16:10Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments

- Module 5b directory with proper Docusaurus scaffolding at position 6 (after Module 5a at position 5)
- Composite LAB.mdx covering the full meta-skills arc: GSD workflow (centerpiece, 30 min) → context engineering practical (20 min) → memory systems (15 min) → plan modes (10 min)
- 18 Expected result blocks throughout the lab — every actionable step has a verifiable outcome
- Superpowers exploratory PROJECTS.mdx with 3 stretch projects (TDD, systematic debugging, structured code review)

## Task Commits

Each task was committed atomically:

1. **Task 1: Module 5b scaffolding + composite lab** - `0b9ba8a` (feat)
2. **Task 2: Superpowers exploratory content** - `c90c0a5` (feat)

## Files Created/Modified

- `course-site/docs/module-05b-ai-workflows/_category_.json` — Docusaurus nav entry at position 6, links to module-05b-readme
- `course-site/docs/module-05b-ai-workflows/README.mdx` — Module overview with 5 learning objectives, 90-minute duration
- `course-site/docs/module-05b-ai-workflows/lab/_category_.json` — Lab subdirectory at position 1
- `course-site/docs/module-05b-ai-workflows/lab/LAB.mdx` — Composite 75-minute lab with 4 sections, 18 Expected result blocks, PrometheusRule and Grafana JSON in details blocks
- `course-site/docs/module-05b-ai-workflows/exploratory/_category_.json` — Exploratory subdirectory at position 3
- `course-site/docs/module-05b-ai-workflows/exploratory/PROJECTS.mdx` — 3 stretch projects: TDD (30min), systematic debugging (20min), code review (15min)

## Decisions Made

- Composite LAB.mdx (4 sections, single file) chosen over separate per-section files — participants experience the sections as a continuous arc; the GSD workflow from Section 1 is referenced explicitly in Section 4 to reinforce the connection
- WorkerHeartbeatMissing alert documented as requiring postgres-exporter (not immediately functional with the base kube-prometheus-stack install) — honest about scope, teaches the pattern, provides a stretch path
- Parallel tool paths (claude-mem / Crush MCP) use identical structure to make tool-switching easy for participants who change tools mid-course

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None. Acceptance criteria for PROJECTS.mdx required at least 6 occurrences of "Project" — resolved by prefixing deliverable lines with "Project 1 Deliverable:", "Project 2 Deliverable:", "Project 3 Deliverable:" which is cleaner than the original generic "Deliverable:".

## Known Stubs

- **`grafana-dashboard.json` "Request Latency" panel** — documented in the details block as a placeholder requiring axum-prometheus middleware. The panel exists in the expected JSON but will show no data until /metrics endpoints are added to reference-app services. This is intentional (participants understand the limitation) and does not prevent the plan's goal (teaching the GSD workflow).

## User Setup Required

None — no external service configuration required beyond the KIND cluster setup already documented in Module 5a.

## Next Phase Readiness

- Module 5b is complete and ready for delivery
- Module 6 content (03-03) can proceed — it builds on the same KIND cluster with ArgoCD (Track B) or Terraform (Track A)
- The monitoring stack from Section 1 (alerting-rules.yaml + grafana-dashboard.json) is the target system for Module 6's IaC tracks

## Self-Check: PASSED

All 6 created files confirmed present on disk. Both task commits (0b9ba8a, c90c0a5) confirmed in git log. SUMMARY.md confirmed.

---
*Phase: 03-day-2-modules*
*Completed: 2026-04-04*
