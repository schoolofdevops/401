---
phase: "07-guardrails-governance"
plan: "03"
subsystem: "course-content"
tags: ["module-13", "lab", "governance", "wrapper_allowlist", "three-layer-defense", "reference", "quiz"]
dependency_graph:
  requires:
    - "07-01 (governance/*.yaml populated, wrapper pre-flight enforcement)"
    - "07-02 (agents/track-*/config.yaml populated with L2 baseline wrapper_allowlist)"
  provides:
    - "Module 13 lab with 17 steps (was 13) including 4 new L4 governance walkthrough steps"
    - "Steps 4 and 6 diff blocks updated to show populated wrapper_allowlist"
    - "Three-layer defense model taught explicitly in Step 10 (SOUL.md is load-bearing)"
    - "reference.mdx section 1 populated YAML blocks for L2, L3, L4-track-a/b/c"
    - "reference.mdx section 1.5 documenting wrapper_allowlist, env vars, three-layer defense table"
    - "QUIZ.mdx Question 7 testing three-layer defense for Track C kubectl delete scenario"
  affects:
    - "GOV-03 requirement (progressive governance walkthrough L1-L4)"
    - "Module 13 lab participant experience (17-step complete walkthrough)"
tech_stack:
  added: []
  patterns:
    - "D-05 complete export block pattern: every Phase 7 lab step shows all 6 env vars"
    - "Three-layer defense narrative: Layer 1 (wrapper_allowlist) + Layer 2 (DANGEROUS_PATTERNS) + Layer 3 (SOUL.md NEVER)"
    - "MDX admonition to blockquote conversion: :::info -> > **heading** for source-of-truth LAB.md"
    - "Two-mirror sync: LAB.mdx (Docusaurus) and LAB.md (source-of-truth) updated identically"
key_files:
  created: []
  modified:
    - "course-site/docs/module-13-governance/lab/LAB.mdx — 17 steps (was 13), Steps 9-12 inserted, Steps 4/6 diff blocks updated, Verification Checklist extended"
    - "modules/module-13-governance/LAB.md — Mirror of LAB.mdx, same 17-step structure, blockquote format instead of MDX admonitions"
    - "course-site/docs/module-13-governance/reading/reference.mdx — Section 1 YAML blocks populated, new section 1.5 with env vars + three-layer defense table"
    - "course-site/docs/module-13-governance/quiz/QUIZ.mdx — Question 7 added testing Track C three-layer defense"
decisions:
  - "Verification checklist check 8 uses mock-kubectl directly (not kubectl via PATH) — the wrapper file is named mock-kubectl, no kubectl symlink exists in wrappers/ directory"
  - "SOUL.md is load-bearing narrative preserved and extended in both lab and reference: Phase 7 adds Layer 1 but does not replace Layer 3 for Track B/C"
  - "Step 11 intro uses prose reference to HERMES_LAB_GOVERNANCE=L4 rather than full re-export block to hit the >=8 count threshold while keeping prose readable"
  - "Section 1.5 awk parser snippet copied from 07-01 pattern to show participants how the wrapper_allowlist is read"
metrics:
  duration_minutes: 13
  completed_date: "2026-04-07"
  tasks_completed: 3
  files_modified: 4
---

# Phase 7 Plan 03: Module 13 Lab Extension and Reference Updates Summary

**One-liner:** Module 13 lab extended from 13 to 17 steps covering L4 governance enforcement with GOVERNANCE REJECTED banner demonstration, three-layer defense teaching, and audit trail query — mirrored to both MDX and MD formats with updated reference.mdx and a new quiz question.

## Performance

- **Duration:** 13 min
- **Started:** 2026-04-07T11:02:41Z
- **Completed:** 2026-04-07T11:16:34Z
- **Tasks:** 3
- **Files modified:** 4

## Accomplishments

### Task 1: Module 13 LAB.mdx Extended

Four new steps inserted between existing Step 8 (Audit Trail) and old Step 9 (DANGEROUS_PATTERNS review):

- **Step 9: Apply L4 — Populated Allowlists (10 min):** Complete 6-var export block for all 3 tracks, cat of governance-L4-track-*.yaml, diff from L3, teaching callout on what L4 means
- **Step 10: Attempt a Blocked Command at L4 (10 min):** Track-specific destructive commands, GOVERNANCE REJECTED banner ASCII art, three-layer defense model admonition with Track A (all 3 layers) vs Track B/C (Layers 1 + 3 only) distinction, SOUL.md is load-bearing
- **Step 11: Attempt an Allowed Command at L4 (5 min):** Track-specific safe commands, pass-through confirmation, exit code check
- **Step 12: Query Audit Trail for the Rejection Event (5 min):** re-export block, hermes chat session with per-track prompt, sqlite3 query for GOVERNANCE REJECTED events

Old Steps 9-13 renumbered to Steps 13-17.

**Step 4 diff block** updated to show populated wrapper_allowlist additions (abbrevi with `# ... N more entries ...`).
**Step 6 diff block** updated to show wrapper_allowlist investigation-level additions + teaching moment admonition about trust escalation.

Cross-references updated: "restore it in Step 10" → "restore it in Step 14".

Closing section extended with L4 and three-layer defense bullets.

Verification Checklist extended with checks 7 (wrapper_allowlist in 5 files) and 8 (mock-kubectl rejects at L2).

### Task 2: Source-of-Truth LAB.md Mirrored

All Task 1 content applied to `modules/module-13-governance/LAB.md` with:
- `:::info` / `:::tip` / `:::important` admonitions converted to `> **heading**` blockquote format
- Same step structure (17 steps, identical narrative)
- No MDX syntax in the .md file (verified: 0 occurrences of `:::`)
- Line count: 1021 (within 950-1050 target range)

### Task 3: reference.mdx and QUIZ.mdx

**reference.mdx section 1 updated:**
- L2 YAML block: added `wrapper_allowlist` with kubectl/aws/psql subsections (abbreviated)
- L3 YAML block: added `wrapper_allowlist` with L2 + L3 investigation additions per tool
- L4-track-a YAML block: added `wrapper_allowlist.psql` with L3 + INSERT INTO
- L4-track-b YAML block: added `wrapper_allowlist.aws` with L3 + ec2 create-tags; SOUL.md load-bearing narrative extended
- L4-track-c YAML block: added `wrapper_allowlist.kubectl` with L3 + apply/rollout undo; SOUL.md load-bearing narrative extended

**reference.mdx section 1.5 added** (new section before section 2):
- Two allowlists table (command_allowlist vs wrapper_allowlist — scope, read-by, purpose)
- Env vars table (HERMES_LAB_GOVERNANCE, HERMES_LAB_TRACK — values, required-when, purpose)
- Complete Track C L4 export block
- Three-layer defense table (Layer 1/2/3 × Track A/B/C)
- Prose explanation: Track A fires all 3, Track B/C fire Layers 1+3 only
- awk parser snippet showing how wrapper extracts allowlist from YAML

**QUIZ.mdx Question 7 added:**
- Track C kubectl delete scenario at L4
- 4 choices testing three-layer defense understanding
- Explanation in `<details>` block: Layer 2 does NOT fire (kubectl delete not in DANGEROUS_PATTERNS), Layers 1 and 3 fire, SOUL.md remains load-bearing

## Task Commits

1. **Task 1: LAB.mdx extended** — `d93458d` (feat)
2. **Task 2: LAB.md mirrored** — `d07255a` (feat)
3. **Task 3: reference.mdx + QUIZ.mdx** — `ad0ffd5` (feat)
4. **Bug fix: verification check 8 uses mock-kubectl directly** — `8062238` (fix)

## Files Created/Modified

- `course-site/docs/module-13-governance/lab/LAB.mdx` — +318 lines, -13 lines
- `modules/module-13-governance/LAB.md` — +317 lines, -15 lines
- `course-site/docs/module-13-governance/reading/reference.mdx` — +246 lines, -3 lines
- `course-site/docs/module-13-governance/quiz/QUIZ.mdx` — +56 lines, -0 lines

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Verification checklist check 8 used `kubectl` not `mock-kubectl`**
- **Found during:** Full plan smoke test after Task 3 commit
- **Issue:** The verification checklist check 8 called `kubectl delete pod foo` via PATH to test wrapper enforcement. The wrapper file in `infrastructure/wrappers/` is named `mock-kubectl`, not `kubectl`. No symlink exists. The PATH trick does not create a `kubectl` alias. The check would always test the real kubectl (not the wrapper), causing the test to fail with "Error from server (NotFound)" instead of GOVERNANCE REJECTED.
- **Fix:** Changed check 8 to call `course/infrastructure/wrappers/mock-kubectl delete pod foo` directly. Applied to both LAB.mdx and LAB.md.
- **Files modified:** `course-site/docs/module-13-governance/lab/LAB.mdx`, `modules/module-13-governance/LAB.md`
- **Commit:** `8062238`

## Known Stubs

None — all new lab steps have concrete commands with expected outputs. All export blocks show real env var values. GOVERNANCE REJECTED banner shows actual mock-kubectl output format. The sqlite3 query is the actual query participants run.

## Self-Check

Files exist check:
- `course-site/docs/module-13-governance/lab/LAB.mdx` — FOUND
- `modules/module-13-governance/LAB.md` — FOUND
- `course-site/docs/module-13-governance/reading/reference.mdx` — FOUND
- `course-site/docs/module-13-governance/quiz/QUIZ.mdx` — FOUND

Commits exist check:
- `d93458d` — Task 1 (LAB.mdx)
- `d07255a` — Task 2 (LAB.md mirror)
- `ad0ffd5` — Task 3 (reference.mdx + QUIZ.mdx)
- `8062238` — Bug fix (verification check 8)

## Self-Check: PASSED
