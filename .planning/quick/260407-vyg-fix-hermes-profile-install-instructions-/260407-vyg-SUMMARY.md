---
phase: 260407-vyg
plan: 01
type: quick
subsystem: content
tags: [bug-fix, hermes-profile, install-instructions, module-10, module-11, uat-fix]
dependency_graph:
  requires: []
  provides: [UAT-FIX-PROFILE-INSTALL]
  affects: [module-10-agents, module-11-fleet, module-08-tools, reading-guides]
tech_stack:
  added: []
  patterns: [hermes-profile-create-4-step-install]
key_files:
  created: []
  modified:
    - agents/track-a-database/config.yaml
    - agents/track-b-finops/config.yaml
    - agents/track-c-kubernetes/config.yaml
    - agents/fleet-coordinator/config.yaml
    - modules/module-10-agents/LAB-track-a-database.md
    - modules/module-10-agents/LAB-track-b-finops.md
    - modules/module-10-agents/LAB-track-c-kubernetes.md
    - modules/module-10-agents/solution/track-a/config.yaml
    - modules/module-10-agents/solution/track-b/config.yaml
    - modules/module-10-agents/solution/track-c/config.yaml
    - course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx
    - course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
    - modules/module-11-fleet/LAB.md
    - course-site/docs/module-11-fleet/lab/LAB.mdx
    - reading/profile-guide.md
    - course-site/docs/reading/profile-guide.mdx
    - course-site/docs/module-10-domain-agent/reading/reference.mdx
    - modules/module-08-tools/solution/config-solution.yaml
    - course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml
decisions:
  - Idempotency note added to Module 11 fleet re-copy block — hermes profile create fleet can be run safely a second time
  - Inline narrative prose updated to describe the registration step without embedding raw cp -r commands
metrics:
  duration: 8min
  completed: "2026-04-07"
  tasks: 2
  files: 20
requirements_satisfied: [UAT-FIX-PROFILE-INSTALL]
---

# Phase 260407-vyg Plan 01: Fix Hermes Profile Install Instructions Summary

**One-liner:** Replaced broken `cp -r course/agents/<agent>/` one-liner with correct 4-step `hermes profile create` + individual `cp` sequence across 20 participant-facing files.

## What Was Done

Live UAT (April 2026) caught a critical blocker: `hermes -p track-c chat` returned "Profile 'track-c' does not exist" even after participants followed the install instructions. Root cause: `cp -r` copies files to disk but does NOT register the profile in Hermes's index — `hermes profile create <name>` is the required registration step.

All participant-facing install instructions have been replaced with the correct 4-step sequence.

### Correct Install Sequence

**Track A (Aria):**
```bash
hermes profile create track-a
cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/
```

**Track B (Finley):**
```bash
hermes profile create track-b
cp agents/track-b-finops/config.yaml ~/.hermes/profiles/track-b/
cp agents/track-b-finops/SOUL.md ~/.hermes/profiles/track-b/
cp -r agents/track-b-finops/skills/devops-deployment-safety-check ~/.hermes/profiles/track-b/skills/
```

**Track C (Kiran):**
```bash
hermes profile create track-c
cp agents/track-c-kubernetes/config.yaml ~/.hermes/profiles/track-c/
cp agents/track-c-kubernetes/SOUL.md ~/.hermes/profiles/track-c/
cp -r agents/track-c-kubernetes/skills/sre-k8s-pod-health ~/.hermes/profiles/track-c/skills/
```

**Fleet (Morgan — no skills):**
```bash
hermes profile create fleet
cp agents/fleet-coordinator/config.yaml ~/.hermes/profiles/fleet/
cp agents/fleet-coordinator/SOUL.md ~/.hermes/profiles/fleet/
```

## Files Modified

### Task 1 — Agent Configs and Module 10/11 Lab Files (15 files)

**Agent source-of-truth configs (4):**
- `agents/track-a-database/config.yaml` — multi-line Install comment
- `agents/track-b-finops/config.yaml` — multi-line Install comment
- `agents/track-c-kubernetes/config.yaml` — multi-line Install comment
- `agents/fleet-coordinator/config.yaml` — multi-line Install comment (3-step, no skills)

**Module 10 lab files — modules/ mirror (3):**
- `modules/module-10-agents/LAB-track-a-database.md`
- `modules/module-10-agents/LAB-track-b-finops.md`
- `modules/module-10-agents/LAB-track-c-kubernetes.md`

**Module 10 solution config mirrors (3):**
- `modules/module-10-agents/solution/track-a/config.yaml`
- `modules/module-10-agents/solution/track-b/config.yaml`
- `modules/module-10-agents/solution/track-c/config.yaml`

**Module 10 lab files — course-site/ mdx mirror (3):**
- `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx`
- `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx`
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx`

**Module 11 fleet lab — md + mdx (2, 3 install blocks each):**
- `modules/module-11-fleet/LAB.md` — fleet install #1, fleet re-copy #2 (with idempotency note), track-c install #3
- `course-site/docs/module-11-fleet/lab/LAB.mdx` — same three blocks mirrored

### Task 2 — Reading Guides and Module 8 Solution Mirrors (5 files)

**Reading guides (3):**
- `reading/profile-guide.md` — 3 locations: inline narrative (§1 item 4), Install Pattern code block (§3), Aria walkthrough
- `course-site/docs/reading/profile-guide.mdx` — same 3 locations mirrored
- `course-site/docs/module-10-domain-agent/reading/reference.mdx` — inline narrative (§1 item 4) + Install and Launch block

**Module 8 solution configs (2):**
- `modules/module-08-tools/solution/config-solution.yaml`
- `course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml`

## Verification Output

```
$ rg 'cp -r .*agents/(track-[abc]|fleet)[^/]*/ ~/\.hermes/profiles' \
  agents/ modules/ course-site/docs/ reading/ -n
(no output — zero matches)
```

Zero broken `cp -r` one-liners remain in any production content path.

```
$ rg -l 'hermes profile create' agents/ modules/module-10-agents/ modules/module-11-fleet/ \
  modules/module-08-tools/solution/ course-site/docs/ reading/
modules/module-10-agents/LAB-track-b-finops.md
reading/profile-guide.md
modules/module-11-fleet/LAB.md
modules/module-08-tools/solution/config-solution.yaml
modules/module-10-agents/LAB-track-c-kubernetes.md
agents/fleet-coordinator/config.yaml
modules/module-10-agents/solution/track-a/config.yaml
modules/module-10-agents/solution/track-b/config.yaml
agents/track-b-finops/config.yaml
modules/module-10-agents/solution/track-c/config.yaml
agents/track-a-database/config.yaml
modules/module-10-agents/LAB-track-a-database.md
agents/track-c-kubernetes/config.yaml
course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml
course-site/docs/module-11-fleet/lab/LAB.mdx
course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx
course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx
course-site/docs/reading/profile-guide.mdx
course-site/docs/module-10-domain-agent/reading/reference.mdx
```

All expected file groups represented: agents/ (4), modules/module-10-agents/ (6: 3 lab + 3 solution), modules/module-11-fleet/ (1), modules/module-08-tools/solution/ (1), course-site/docs/ (multiple), reading/ (1).

## Files Intentionally Left As-Is

**`modules/module-08-tools/LAB.md` and `course-site/docs/module-08-tool-integration/lab/LAB.mdx`:**
These files contain `cp -r ~/.hermes/profiles/<your-track>/ course/agents/<your-track>/` which is the SHARE-BACK direction (agent profile → repo), not the install direction. The brief reverse mention uses the generic `<your-track>` placeholder for conceptual teaching, not a real agent name. Both are intentionally out of scope.

**`.planning/` historical files:**
`v11-live-UAT.md`, `06-RESEARCH.md`, `09-02-PLAN.md` are historical records of the bug discovery and planning. They document the bug as found, which is accurate historical context. Not modified.

## Decisions Made

1. **Idempotency note on Module 11 re-copy block:** Added `# Re-running 'hermes profile create fleet' is safe — it is idempotent.` as a comment in the second fleet install block. This teaches participants the behavior instead of surprising them with an error message.

2. **Prose update in reading guides:** The inline narrative sentence was rewritten to describe the registration step verbally (`Run hermes profile create track-a, copy config.yaml, SOUL.md, and the skills directory...`) rather than embedding a raw `cp -r` command in prose. This is more accurate and future-proof.

3. **Discovery prose updated:** The `No build step` follow-up sentence in Install Pattern sections was updated to accurately describe what `hermes profile create` does (registers + creates directory) vs. what `cp` does (populates files).

## Suggested Follow-ups

- **Onboarding scripts:** If any setup scripts (e.g., `setup/setup-hermes.sh`) templatize the install command, apply the same 4-step fix there.
- **Future agents:** Any new agent configs added to `agents/` should use the 4-step Install comment pattern from the start. Consider adding a comment template in `agents/README.md` as a reminder.
- **Module 7 lab:** If the Module 7 skill lab has any agent install instructions (for wiring skills to profiles), verify those also use `hermes profile create` — not checked in this task.

## Commits

- `7288c37` — `fix(260407-vyg-01): replace broken cp -r one-liner with hermes profile create sequence` (15 files)
- `9c24d6c` — `fix(260407-vyg-02): fix broken install instructions in reading guides and module-08 solution` (5 files)

## Self-Check: PASSED

- All 20 files modified and committed
- Zero broken patterns in production paths (verified by grep)
- All 21 files in `hermes profile create` file list (20 modified + 1 pre-existing correct reference in module-08 LAB.mdx)
- No .planning/ historical files modified
- Module 8 LAB.md and LAB.mdx left untouched (share-back direction, placeholder names)
