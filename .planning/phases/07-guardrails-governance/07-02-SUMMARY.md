---
phase: 07-guardrails-governance
plan: 02
subsystem: governance
tags: [hermes, config-yaml, wrapper_allowlist, command_allowlist, module-10, track-a, track-b, track-c, psql, aws, kubectl]

# Dependency graph
requires:
  - phase: 06-k8s-skills-agents
    provides: agents/track-*/config.yaml files with command_allowlist deferred (D-17)

provides:
  - L2 baseline wrapper_allowlist in all 3 agents/track-*/config.yaml canonical configs
  - L2 baseline wrapper_allowlist in all 3 modules/module-10-agents/solution/track-*/config.yaml mirror configs
  - wrapper_allowlist comment-only documentation in all 3 starter config files
  - Two-allowlist narrative in Module 10 Track A and Track B lab files (4 files: 2 .md + 2 .mdx)
  - Track C Module 10 lab files confirmed no-op (zero command_allowlist/wrapper_allowlist refs)
  - Deprecated command_allowlist: ["EXPLAIN"] example removed from Track A lab

affects:
  - 07-03 (Module 13 reading/reference updates will reference this wrapper_allowlist narrative)
  - Module 10 course delivery (participants see populated configs from the start)
  - Module 13 lab (wrapper_allowlist baseline is the progression starting point)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "wrapper_allowlist YAML key: course-local enforcement below command_allowlist in all profile configs"
    - "Per-track isolation: Track A gets only psql, Track B gets only aws, Track C gets only kubectl — no cross-tool entries"
    - "Mirror pattern: canonical agents/track-*/config.yaml and modules/.../solution/track-*/config.yaml are byte-identical"
    - "Starter pattern: starter config-starter.yaml documents new key in comments only — participants populate during Module 13 lab"
    - "Two-allowlist narrative: command_allowlist (Hermes-native bypass) vs wrapper_allowlist (course-local enforcement) distinction"

key-files:
  created: []
  modified:
    - agents/track-a-database/config.yaml
    - agents/track-b-finops/config.yaml
    - agents/track-c-kubernetes/config.yaml
    - modules/module-10-agents/solution/track-a/config.yaml
    - modules/module-10-agents/solution/track-b/config.yaml
    - modules/module-10-agents/solution/track-c/config.yaml
    - modules/module-10-agents/starter/track-a/config-starter.yaml
    - modules/module-10-agents/starter/track-b/config-starter.yaml
    - modules/module-10-agents/starter/track-c/config-starter.yaml
    - modules/module-10-agents/LAB-track-a-database.md
    - modules/module-10-agents/LAB-track-b-finops.md
    - course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx

key-decisions:
  - "L2 baseline wrapper_allowlist added to each profile config immediately after command_allowlist line (not replacing it)"
  - "Track C Module 10 lab confirmed no-op: zero command_allowlist and wrapper_allowlist refs in both Track C lab files"
  - "Track A Challenge 3 restructured: two-allowlist section leads the challenge, then the L3 promotion instructions follow"
  - "Track B Challenge 3 restructured: inline wrapper_allowlist.aws L2 baseline YAML replaces the vague 'add read-only patterns' instruction"
  - "command_allowlist: [] preserved unchanged in all 9 configs per D-11 and Phase 6 D-17 protocol"

patterns-established:
  - "Two-allowlist distinction: command_allowlist (Hermes-native) is the bypass key for existing DANGEROUS_PATTERNS; wrapper_allowlist (course-local) is the enforcement key read by mock-* wrappers"
  - "GOVERNANCE REJECTED banner reference in Track A narrative sets participant expectation for Phase 7 enforcement demo in Module 13"

requirements-completed:
  - GOV-02

# Metrics
duration: 10min
completed: 2026-04-07
---

# Phase 7 Plan 02: Populate L2 Baseline wrapper_allowlist in Agent Profile Configs Summary

**L2 baseline wrapper_allowlist populated in 9 agent profile configs (3 canonical + 3 solution mirrors + 3 starters) and two-allowlist narrative cascaded into 4 Module 10 lab files, resolving Phase 6 D-17 deferral**

## Performance

- **Duration:** 10 min
- **Started:** 2026-04-07T09:42:17Z
- **Completed:** 2026-04-07T09:52:00Z
- **Tasks:** 2
- **Files modified:** 13

## Accomplishments

- Populated `wrapper_allowlist` in all 3 canonical `agents/track-*/config.yaml` files with per-track L2 baseline content (psql / aws / kubectl subsections, no cross-tool entries)
- Mirrored identical content into `modules/module-10-agents/solution/track-*/config.yaml` (verified byte-identical via diff)
- Updated all 3 `starter/track-*/config-starter.yaml` files with `wrapper_allowlist` documentation in comments (no populated list — participants populate during Module 13 lab)
- Replaced deprecated `command_allowlist: ["EXPLAIN"]` Track A lab example with correct two-allowlist narrative in all 4 lab files (2 .md source + 2 .mdx Docusaurus mirrors)
- Track C Module 10 lab files confirmed no-op: zero `command_allowlist` and `wrapper_allowlist` references exist in either file

## Task Commits

1. **Task 1: Populate agents/ configs and mirror to solution/ and starter/** - `2a4c7ca` (feat)
2. **Task 2: Cascade Module 10 lab text updates (Track A and Track B; Track C verified no-op)** - `510f51e` (feat)

## Files Created/Modified

- `agents/track-a-database/config.yaml` — Added `wrapper_allowlist.psql` L2 baseline (SELECT/EXPLAIN/SHOW/DESCRIBE/meta-commands); updated `command_allowlist` comment to note "Hermes-native bypass mechanism; unchanged"
- `agents/track-b-finops/config.yaml` — Added `wrapper_allowlist.aws` L2 baseline (sts/ec2/rds/cloudwatch/ce describe-get commands); preserved Track B SOUL.md safety note
- `agents/track-c-kubernetes/config.yaml` — Added `wrapper_allowlist.kubectl` L2 baseline (get/describe/logs/top commands); preserved Track C SOUL.md safety note
- `modules/module-10-agents/solution/track-a/config.yaml` — Byte-identical mirror of agents/track-a-database/config.yaml
- `modules/module-10-agents/solution/track-b/config.yaml` — Byte-identical mirror of agents/track-b-finops/config.yaml
- `modules/module-10-agents/solution/track-c/config.yaml` — Byte-identical mirror of agents/track-c-kubernetes/config.yaml
- `modules/module-10-agents/starter/track-a/config-starter.yaml` — Added `wrapper_allowlist` comment block with psql example; updated `command_allowlist` comment label
- `modules/module-10-agents/starter/track-b/config-starter.yaml` — Added `wrapper_allowlist` comment block with aws example; updated `command_allowlist` comment label
- `modules/module-10-agents/starter/track-c/config-starter.yaml` — Added `wrapper_allowlist` comment block with kubectl example; updated `command_allowlist` comment label
- `modules/module-10-agents/LAB-track-a-database.md` — Challenge 3 restructured with two-allowlist section; deprecated `command_allowlist: ["EXPLAIN"]` removed
- `modules/module-10-agents/LAB-track-b-finops.md` — Challenge 3 updated with two-allowlist explanation and L2 baseline YAML; two-layer defense narrative added
- `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` — Docusaurus mirror of Track A lab (same edits)
- `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx` — Docusaurus mirror of Track B lab (same edits)

## Decisions Made

- Track A Challenge 3 restructured so the two-allowlist explanation leads the section, then the L3 promotion instructions follow — this teaches the mechanism before showing the promotion action
- Track B Challenge 3 inline YAML now shows the L2 baseline `wrapper_allowlist.aws` content to make it concrete (not aspirational), matching the same populated list in the config.yaml
- `command_allowlist: []` preserved unchanged in all 9 configs per D-11 and Phase 6 D-17 protocol — Hermes-native key is not this plan's responsibility to populate

## Track C Verification Outcome (No-Op Confirmed)

Both Track C lab files confirmed clean:

```
grep -c 'command_allowlist' modules/module-10-agents/LAB-track-c-kubernetes.md  → 0
grep -c 'command_allowlist' course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx  → 0
```

No `wrapper_allowlist` references in either Track C lab file either. Phase 6 already performed the Track C cascade (cross-domain teaching moment removal and expected ls outputs). No Track C lab edits were required.

## Two-Allowlist Narrative Block (Reference for Plan 07-03)

The canonical two-allowlist narrative established in Track A Challenge 3 (for Plan 07-03 Module 13 reading reference):

```markdown
### Two allowlists, two purposes

Your L2 config has two allowlist keys:

- **`command_allowlist`** (Hermes-native) — A bypass list for Hermes's built-in DANGEROUS_PATTERNS approval gate. An entry is a description-key string (like "SQL DROP") that tells Hermes "skip the approval prompt for this already-detected pattern." For Track A Database at L2, leave this empty — you want the approval gate to fire on every dangerous SQL match.

- **`wrapper_allowlist`** (course-local) — A command-prefix allowlist read by the `mock-psql` wrapper. Lists the SQL keywords the agent may invoke when `HERMES_LAB_GOVERNANCE=L2`. A command whose first keyword does not match any listed prefix is rejected with a loud GOVERNANCE REJECTED banner.
```

## Deviations from Plan

None — plan executed exactly as written.

The plan's Track C verification expectation ("if both return 0, Track C cascade is a no-op") was confirmed correct: both grep commands returned 0, no edits were required.

## Issues Encountered

None.

## Known Stubs

None — all 9 config.yaml files have fully populated `wrapper_allowlist` content. The starter files intentionally use comment-only documentation (not stubs — this is the correct pedagogical state for Module 10 entry point).

## Next Phase Readiness

- Plan 07-01 (governance/*.yaml files) and Plan 07-02 (agent profile configs) together complete the GOV-02 deliverable
- Plan 07-03 (Module 13 lab extension and reading reference) can reference this two-allowlist narrative and the populated configs
- The `wrapper_allowlist` key is now present in all agent profile configs; Plan 07-04 wrapper enforcement scripts will read these keys when `HERMES_LAB_GOVERNANCE` is set

---
*Phase: 07-guardrails-governance*
*Completed: 2026-04-07*
