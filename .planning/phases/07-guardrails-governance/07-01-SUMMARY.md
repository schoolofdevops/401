---
phase: "07-guardrails-governance"
plan: "01"
subsystem: "enforcement-infrastructure"
tags: ["governance", "wrappers", "bash", "yaml", "allowlist", "enforcement"]
dependency_graph:
  requires: []
  provides:
    - "governance/governance-L1.yaml wrapper_allowlist comment"
    - "governance/governance-L2.yaml wrapper_allowlist (read-only)"
    - "governance/governance-L3.yaml wrapper_allowlist (investigation)"
    - "governance/governance-L4-track-a.yaml wrapper_allowlist (psql+INSERT)"
    - "governance/governance-L4-track-b.yaml wrapper_allowlist (aws+create-tags)"
    - "governance/governance-L4-track-c.yaml wrapper_allowlist (kubectl+apply/rollout-undo)"
    - "infrastructure/wrappers/mock-kubectl governance pre-flight"
    - "infrastructure/wrappers/mock-aws governance pre-flight"
    - "infrastructure/wrappers/mock-psql governance pre-flight"
  affects:
    - "Plan 07-02 (agent profiles, config.yaml allowlists)"
    - "Plan 07-03 (Module 13 lab walkthrough — teaching artifact)"
tech_stack:
  added: []
  patterns:
    - "awk-based YAML parser for wrapper_allowlist subsection extraction"
    - "HERMES_LAB_GOVERNANCE env var for governance level selection"
    - "HERMES_LAB_TRACK env var for L4 track-specific file resolution"
    - "GOVERNANCE REJECTED banner pattern (stderr, box-drawing chars)"
    - "Pre-flight check: after live passthrough, before MOCK MODE banner"
key_files:
  created: []
  modified:
    - "governance/governance-L1.yaml — comment added (no wrapper_allowlist at L1)"
    - "governance/governance-L2.yaml — wrapper_allowlist added (read-only: kubectl/aws/psql)"
    - "governance/governance-L3.yaml — wrapper_allowlist added (L2 + investigation commands)"
    - "governance/governance-L4-track-a.yaml — wrapper_allowlist added (psql + INSERT INTO)"
    - "governance/governance-L4-track-b.yaml — wrapper_allowlist added (aws + ec2 create-tags)"
    - "governance/governance-L4-track-c.yaml — wrapper_allowlist added (kubectl + apply/rollout undo)"
    - "infrastructure/wrappers/mock-kubectl — governance pre-flight block added"
    - "infrastructure/wrappers/mock-aws — governance pre-flight block added"
    - "infrastructure/wrappers/mock-psql — query extraction moved up, governance pre-flight block added"
decisions:
  - "PATH B wrapper extension confirmed (D-01): Hermes DANGEROUS_PATTERNS is hardcoded Python, no extension hook exists"
  - "wrapper_allowlist key is NEW (not command_allowlist): Hermes-native command_allowlist: [] preserved untouched in all 6 files"
  - "awk-based YAML parser chosen over yq: avoids yq v3/v4 version-pinning issues; wrapper is readable teaching material"
  - "YAML backslash escape fix: awk gsub(\\\\\\\\, \\\\) converts YAML double-backslash to single-backslash for psql meta-commands"
  - "L4 HERMES_LAB_TRACK defaults to track-a with warning (not hard error) when unset at L4"
  - "FIRST_TWO variable in psql wrapper handles EXPLAIN ANALYZE two-word prefix matching"
metrics:
  duration_minutes: 60
  completed_date: "2026-04-07"
  tasks_completed: 2
  files_modified: 9
---

# Phase 7 Plan 01: Governance Enforcement Infrastructure Summary

**One-liner:** Bash wrapper pre-flight check (awk YAML parser) + 6 populated governance/*.yaml files delivering three-layer defense enforcement for kubectl/aws/psql in Hermes DevOps labs.

## What Was Built

### Task 1: Governance YAML Population

Six governance YAML files updated with `wrapper_allowlist:` key per-tool subsections per CONTEXT.md D-07/D-08/D-09:

| File | Content | Design |
|------|---------|--------|
| `governance-L1.yaml` | Comment only — no allowlist | L1 has no terminal toolset; wrapper never invoked |
| `governance-L2.yaml` | kubectl (get/describe/logs/top) + aws (describe/get) + psql (SELECT/EXPLAIN/meta) | Read-only diagnostic baseline |
| `governance-L3.yaml` | L2 + rollout history/status/diff/explain + aws logs/iam + EXPLAIN ANALYZE + DELETE/UPDATE | Investigation commands unlocked |
| `governance-L4-track-a.yaml` | L3 psql + INSERT INTO (archival patterns) | Database track semi-autonomous |
| `governance-L4-track-b.yaml` | L3 aws + ec2 create-tags (metadata only) | FinOps track semi-autonomous |
| `governance-L4-track-c.yaml` | L3 kubectl + apply + rollout undo | K8s track semi-autonomous |

**Key invariants preserved:**
- `command_allowlist: []` Hermes-native key untouched in every file
- `kubectl delete/drain/exec/cordon/uncordon/taint` absent from all L4 allowlists
- `DROP/TRUNCATE/ALTER TABLE/terminate-instances` absent from all allowlists

### Task 2: Wrapper Extension

Three wrapper scripts extended with identical governance pre-flight pattern:

```
live passthrough check → GOVERNANCE PRE-FLIGHT → MOCK MODE banner → mock routing
```

**Pre-flight logic flow:**
1. Read `HERMES_LAB_GOVERNANCE` env var; skip entire block if unset (backward compat)
2. Resolve governance YAML path: L4 uses `governance-L4-${HERMES_LAB_TRACK}.yaml`, others use `governance-${GOVERNANCE}.yaml`
3. If L4 and `HERMES_LAB_TRACK` unset: warn and default to track-a
4. Parse `wrapper_allowlist.{tool}` subsection via awk (no yq dependency)
5. Check `CMD_CHECK` prefix against all allowed prefixes
6. On rejection: write GOVERNANCE REJECTED banner to stderr, exit 1
7. On pass: continue to MOCK MODE banner + routing

**Per-wrapper `CMD_CHECK` derivation:**
- `mock-kubectl`: `"${1:-} ${2:-}"` — first 2 args cover all kubectl subcommand patterns
- `mock-aws`: `"${1:-} ${2:-}"` — service + subcommand pattern
- `mock-psql`: uppercase first word + space (SQL); raw `$QUERY` for `\*` meta-commands; handles two-word `EXPLAIN ANALYZE` prefix

## Test Results

All 15 acceptance tests pass:

| Test | Result |
|------|--------|
| `bash -n` syntax check (all 3 wrappers) | PASS |
| `kubectl get pods` at L2 → JSON output | PASS |
| `kubectl delete pod` at L2 → GOVERNANCE REJECTED stderr, exit 1 | PASS |
| STDOUT clean on rejection | PASS |
| `aws ec2 describe-instances` at L2 → JSON | PASS |
| `aws ec2 terminate-instances` at L2 → GOVERNANCE REJECTED | PASS |
| `psql SELECT *` at L2 → CSV output | PASS |
| `psql DROP TABLE` at L2 → GOVERNANCE REJECTED | PASS |
| L4 track-c `kubectl apply` → passes governance (mock MOCK ERROR, not GOVERNANCE REJECTED) | PASS |
| L2 `kubectl apply` → GOVERNANCE REJECTED | PASS |
| Backward compat (no HERMES_LAB_GOVERNANCE) → works as before | PASS |
| L4 track-c `kubectl rollout undo` → passes governance | PASS |
| Three-layer: `DROP TABLE` blocked at L2, L3, AND L4-track-a | PASS |
| `kubectl delete` blocked at L2, L3, AND L4-track-c | PASS |
| `psql \dt` meta-command allowed at L2 (YAML backslash escape fix) | PASS |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] YAML backslash escape in awk gsub**
- **Found during:** Task 2 test phase — psql `\dt` meta-command blocked at L2 even though in allowlist
- **Issue:** YAML `"\\d"` stores as two-backslash + d in file bytes. The awk `gsub(/^    - "|"$/)` stripped quotes but left `\\d`. Shell `CMD_CHECK` was `\dt` (single backslash). No prefix match.
- **Fix:** Added second gsub to all 3 wrappers: `gsub(/\\\\/, "\\", line)` converts double-backslash to single-backslash after quote stripping, correctly decoding the YAML string escape
- **Files modified:** `infrastructure/wrappers/mock-kubectl`, `mock-aws`, `mock-psql`
- **Commit:** `20b6ced` (included in Task 2 commit)

## Known Stubs

None — all wrapper_allowlist entries are populated with real command prefixes. No placeholder text or empty arrays where populated content was required.

## Self-Check

Files exist check:
- `governance/governance-L2.yaml` — FOUND
- `governance/governance-L3.yaml` — FOUND
- `governance/governance-L4-track-a.yaml` — FOUND
- `governance/governance-L4-track-b.yaml` — FOUND
- `governance/governance-L4-track-c.yaml` — FOUND
- `infrastructure/wrappers/mock-kubectl` — FOUND
- `infrastructure/wrappers/mock-aws` — FOUND
- `infrastructure/wrappers/mock-psql` — FOUND

Commits exist check:
- `f835739` — Task 1 (governance YAML population)
- `20b6ced` — Task 2 (wrapper extension)

## Self-Check: PASSED
