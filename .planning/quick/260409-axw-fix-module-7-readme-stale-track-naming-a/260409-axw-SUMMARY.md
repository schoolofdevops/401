---
phase: quick
plan: 260409-axw
type: summary
status: complete
---

# Quick Task 260409-axw: Summary

## Bug

Module 7 README.mdx had stale content from an earlier version of the course:

1. **Wrong track naming** — used "SRE Track / DevOps Track / DBA Track / Observability Track" instead of the canonical "Track A/B/C/D" naming used across the rest of the course (Modules 8, 10, 11, 12, 13).
2. **Wrong lab location** — claimed the lab "lives in the Hermes repository" and to "open the Hermes lab guide". The lab actually lives in `course-site/docs/module-07-agent-skills/lab/` as a Docusaurus page.
3. **Wrong lab duration** — 50 min. The actual lab is 60 min per the lab frontmatter.
4. **Stale focus descriptions** — SRE was described as "EC2 health check" (that's Track B FinOps) and DevOps as "deployment safety" (that's not a canonical track at all).

## Fix

Updated `course-site/docs/module-07-agent-skills/README.mdx`:

- **Lab location admonition** rewritten to point at the local `./lab/LAB.mdx` and the Track C dedicated lab at `./lab/LAB-track-c-kubernetes.mdx`
- **Choose Your Track table** rewritten with the canonical 4 tracks:
  - Track A — Database Health (psql, pg_stat_statements, RDS slow query)
  - Track B — FinOps (aws ec2, Cost Explorer, cost anomalies)
  - Track C — Kubernetes Health (kubectl, 6 mock pod failure modes)
  - Track D — Observability (CloudWatch alarms, alert noise, dedup)
- **Note added** directing Track C learners to the dedicated Track C lab; Tracks A/B/D use the unified lab
- **Track commitment callout** added — the Module 7 skill carries forward to Modules 8, 10-13
- **Module Contents lab row** updated to link directly to LAB.mdx and LAB-track-c-kubernetes.mdx, and corrected duration from 50 min to 60 min

## Files Changed

| File | Change |
|---|---|
| `course-site/docs/module-07-agent-skills/README.mdx` | 3 edits: lab location admonition, Choose Your Track section, Module Contents table |

## Verification

- Docusaurus build: `[SUCCESS] Generated static files in "build".`
- Track naming now consistent with Modules 8/10/11/12/13 (canonical Track A/B/C/D)
- Lab location links resolve to real course-site pages (no broken links in build output)
