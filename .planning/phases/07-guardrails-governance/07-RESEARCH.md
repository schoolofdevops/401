# Phase 7: Guardrails & Governance - Research

**Researched:** 2026-04-07
**Domain:** Hermes governance config, bash wrapper extension, DANGEROUS_PATTERNS system
**Confidence:** HIGH (primary findings from direct source inspection)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Enforcement Mechanism**
- D-01: Researcher investigates Hermes custom DANGEROUS_PATTERNS first — this document answers D-01.
- D-02: Fallback mechanism (if D-01 finds no native extension): extend `infrastructure/wrappers/mock-kubectl` with allowlist enforcement. Same mechanism applied to `mock-aws` and `mock-psql`. Phase 7 wraps all three.
- D-03: Rejection UX — loud `╓ GOVERNANCE REJECTED ╖` banner + exit 1. Mirrors existing MOCK MODE banner.
- D-04: Governance level source — `HERMES_LAB_GOVERNANCE` env var (L1|L2|L3|L4). Default to L2 if unset.
- D-05: Every lab step shows the complete `export` block (HERMES_LAB_MODE, HERMES_LAB_SCENARIO, HERMES_LAB_GOVERNANCE, MOCK_DATA_DIR, PATH).

**Per-Track Allowlist Content**
- D-06: All 3 tracks populated symmetrically at L2+.
- D-07: Track C (Kubernetes) — L2: get/describe/logs/top; L3 adds: rollout history/status/diff/explain; L4 adds: apply/rollout undo (smart-approval); always blocked: delete/drain/exec/cordon/uncordon/taint.
- D-08: Track A (Database) — L2: SELECT/EXPLAIN/SHOW/psql meta-commands; L3 adds: DELETE...WHERE...LIMIT/UPDATE...WHERE...LIMIT/EXPLAIN ANALYZE; L4 adds: INSERT...SELECT for archival (smart-approval); always blocked: DROP/TRUNCATE/DELETE without WHERE/ALTER TABLE/all DDL.
- D-09: Track B (FinOps) — L2: sts get-caller-identity/ec2 describe-*/rds describe-*/cloudwatch get-metric-*/ce get-*; L3 adds: logs describe-*/logs get-log-events/iam get-*; L4 adds: ec2 create-tags; always blocked: terminate-instances/delete-db-instance/rds modify-*/any terminate or delete verb.
- D-10: Fleet coordinator governance deferred to researcher — researcher confirms current state.

**Agent Profile Config Updates**
- D-11: Agent profile configs get populated allowlists (L2 baseline). Phase 6 D-17 deferred this.
- D-12: Module 10 cascade update — lab MDX and source LAB.md files updated to show populated allowlists.

**Progression Story (L1 to L4)**
- D-13: Progressive read-to-write unlock — L1 empty/no-terminal, L2 read-only, L3 rollout/diff/investigation, L4 targeted mutations with human-approval gate.
- D-14: Two-gate model at L4 — allowlist + DANGEROUS_PATTERNS gate + SOUL.md NEVER rules = three-layer defense.

**Module 13 Lab Extension**
- D-15: Extend existing lab with Steps 9-12 (GUIDED phase). Do NOT rewrite existing steps.
- D-16: Update diff output blocks in Steps 4, 6.
- D-17: Update reference.mdx §1 to show populated yamls; add section documenting HERMES_LAB_GOVERNANCE and three-layer defense.

### Claude's Discretion

- Exact allowlist format inside YAML (simple list of strings vs structured objects with descriptions)
- Wrapper YAML parsing approach in bash (grep-based vs yq vs bash regex)
- Exact audit log schema for rejection events
- Whether to ship a new mock-aws extension or extend existing (Track B needs aws wrapper coverage)
- Whether mock-psql exists or needs to be created for Track A
- Exact GOVERNANCE REJECTED banner ASCII art
- Whether to add quiz question about three-layer defense model
- Exact wording of Module 10 cascade text updates
- Whether fleet coordinator (Morgan) gets its own governance config
- Exact PROJECTS.mdx exploratory entry structure for populated allowlists

### Deferred Ideas (OUT OF SCOPE)

- Agent trigger governance (Phase 8, TRIG-01..04)
- Fleet coordinator full governance story (Phase 9, FLEET-01, FLEET-02)
- K8s Agent Sandbox governance (Phase 9, PROD-01)
- Hermes upstream contribution
- Smart-approval auxiliary LLM configuration
- Audit log export format
- Governance level per-command override
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| GOV-01 | Hermes command allowlist/blocklist configuration — kubectl get/describe/logs allowed, kubectl delete/drain/exec blocked | PATH B wrapper enforcement is the mechanism; governance yamls define the lists; wrapper reads HERMES_LAB_GOVERNANCE and enforces |
| GOV-02 | Per-track governance configs with domain-specific allowlists (K8s, Database, FinOps) | 6 governance/*.yaml + 3 agents/track-*/config.yaml files exist and are confirmed empty — Phase 7 populates all 9 |
| GOV-03 | Progressive governance walkthrough L1 to L4 with allowlist differentiation showing trust escalation | Module 13 lab exists (13 steps) with guided phase L1-L3 (Steps 1-10) and free explore (Steps 11-13); Phase 7 inserts L4 steps into the GUIDED phase |
</phase_requirements>

---

## Summary

Phase 7 research resolves the critical D-01 fork decision (see Section 3 below) and provides complete inventory of every file that must be created or modified.

The Hermes `DANGEROUS_PATTERNS` list in `tools/approval.py` is hardcoded as a Python list literal (lines 68-106). There is no configuration loading hook, no plugin mechanism, no CLI flag, and no environment variable that adds patterns to detection. The `command_allowlist` field in `config.yaml` bypasses the approval prompt for commands that already trigger a pattern — it does NOT add new detection patterns. The verdict is **PATH B: wrapper extension is the only course-local option** for enforcing kubectl, aws, and psql blocklists mechanically.

The three wrapper scripts (`mock-kubectl`, `mock-aws`, `mock-psql`) all exist and follow identical patterns. All three already read `HERMES_LAB_MODE` and `HERMES_LAB_SCENARIO`. Phase 7 adds a pre-flight allowlist check at the top of each script that reads `HERMES_LAB_GOVERNANCE`, resolves the active governance yaml file, and either passes through (allowed) or prints the GOVERNANCE REJECTED banner and exits 1 (blocked). The implementation is approximately 25-40 lines of bash per wrapper — grep-based or yq-based YAML parsing both work since `yq` v3.4.3 is confirmed available.

The Module 13 lab is confirmed to have 13 steps: Steps 1-10 in the GUIDED PHASE (the walkthrough referenced in CONTEXT.md as "existing 10-step lab"), Steps 11-13 in the FREE EXPLORE PHASE (challenges). Phase 7 inserts Steps 9-12 for L4 content by renumbering existing Steps 9-10 to Steps 13-14 and repurposing the FREE EXPLORE challenges (which shift up). The existing diff output blocks in Steps 4 and 6 must be updated to show populated allowlists once the governance yamls are populated.

**Primary recommendation:** Execute PATH B. Add a 25-40 line pre-flight block to each of the three existing wrapper scripts. Populate all 9 YAML files (6 governance/ + 3 agents/track-*/config.yaml). Update Module 13 lab and reading reference. Cascade Module 10 lab files.

---

## D-01 FORK DECISION ANSWER

### VERDICT: PATH B — Wrapper Extension

**Hermes does NOT support loading custom DANGEROUS_PATTERNS from config.yaml, a plugin file, or any extension mechanism without forking Hermes source code.**

Evidence, by source file:

**`/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` lines 68-106:**
```python
DANGEROUS_PATTERNS = [
    (r'\brm\s+(-[^\s]*\s+)*/', "delete in root path"),
    (r'\brm\s+-[^\s]*r', "recursive delete"),
    # ... 35 more hardcoded tuples ...
    (r'\bsed\s+--in-place\b.*\s/etc/', "in-place edit of system config (long flag)"),
]
```
This is a Python list literal assigned at module import time. It is not read from any file. Nothing in the module loads additional patterns from config.

**`/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` lines 154-165 (`detect_dangerous_command`):**
```python
def detect_dangerous_command(command: str) -> tuple:
    command_lower = _normalize_command_for_detection(command).lower()
    for pattern, description in DANGEROUS_PATTERNS:
        if re.search(pattern, command_lower, re.IGNORECASE | re.DOTALL):
            pattern_key = description
            return (True, pattern_key, description)
    return (False, None, None)
```
The function iterates exactly `DANGEROUS_PATTERNS` — no extension point, no supplementary list from config.

**`/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` lines 332-346 (`load_permanent_allowlist`):**
```python
def load_permanent_allowlist() -> set:
    from hermes_cli.config import load_config
    config = load_config()
    patterns = set(config.get("command_allowlist", []) or [])
    if patterns:
        load_permanent(patterns)
    return patterns
```
`command_allowlist` in `config.yaml` loads _bypass keys_ (description strings of patterns that already fired). It tells the approval system "skip the prompt for these already-detected patterns." It does NOT add patterns to `DANGEROUS_PATTERNS`. A kubectl delete command will never fire a DANGEROUS_PATTERNS match regardless of what `command_allowlist` contains — because `kubectl delete` is not in `DANGEROUS_PATTERNS`.

**`/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/config.py` (DEFAULT_CONFIG, lines 494-504):**
```python
"approvals": {
    "mode": "manual",
    "timeout": 60,
},
"command_allowlist": [],
```
The config schema shows two governance-related keys: `approvals.mode` (manual/smart/off) and `command_allowlist` (bypass list). No key for custom patterns.

**Exhaustive grep search confirms:** Zero occurrences of `dangerous_patterns`, `custom_patterns`, `additional_patterns`, `plugin_patterns`, `load_patterns` in any `.py` or `.yaml` file across the Hermes repo. Zero `--patterns` flag in `hermes_cli/main.py`.

**What `command_allowlist` in config.yaml DOES do (critical distinction):**
- Entries are description-key strings from DANGEROUS_PATTERNS (e.g., `"SQL DROP"`)
- When a command fires DANGEROUS_PATTERNS detection AND the matched description is in `command_allowlist`, the approval prompt is skipped — the command executes without confirmation
- This is used in the Module 13 lab Step 12 challenge to demonstrate permanent pre-approval
- It is NOT a mechanism for adding new detection patterns

**Implication for Track B and Track C:** `aws ec2 terminate-instances` and `kubectl delete` are not in `DANGEROUS_PATTERNS`. No `command_allowlist` entry can make them trigger a gate. The SOUL.md NEVER rules are the only Hermes-native protection for these commands. The wrapper extension (PATH B) is the only way to add mechanical enforcement without modifying Hermes source.

---

## Standard Stack

### Core Files Requiring Changes

| File | Current State | Phase 7 Action |
|------|--------------|----------------|
| `governance/governance-L1.yaml` | `command_allowlist: []`, no terminal | KEEP AS-IS (L1 has no allowlist by design) |
| `governance/governance-L2.yaml` | `command_allowlist: []` | POPULATE with per-track read commands (planner decision: all-tracks or track-specific at L2?) |
| `governance/governance-L3.yaml` | `command_allowlist: []` | POPULATE with L2 + L3 additions |
| `governance/governance-L4-track-a.yaml` | `command_allowlist: []` | POPULATE with Track A L4 content |
| `governance/governance-L4-track-b.yaml` | `command_allowlist: []` | POPULATE with Track B L4 content |
| `governance/governance-L4-track-c.yaml` | `command_allowlist: []` | POPULATE with Track C L4 content |
| `agents/track-a-database/config.yaml` | `command_allowlist: []` | POPULATE with L2 baseline |
| `agents/track-b-finops/config.yaml` | `command_allowlist: []` | POPULATE with L2 baseline |
| `agents/track-c-kubernetes/config.yaml` | `command_allowlist: []` | POPULATE with L2 baseline |
| `infrastructure/wrappers/mock-kubectl` | No governance logic | EXTEND with HERMES_LAB_GOVERNANCE pre-flight check |
| `infrastructure/wrappers/mock-aws` | No governance logic | EXTEND with HERMES_LAB_GOVERNANCE pre-flight check |
| `infrastructure/wrappers/mock-psql` | No governance logic | EXTEND with HERMES_LAB_GOVERNANCE pre-flight check |

### Supporting Tools Available

| Tool | Version | Availability | Purpose |
|------|---------|-------------|---------|
| `yq` | 3.4.3 | `which yq` = `/opt/homebrew/bin/yq` | Parse governance YAML inside bash wrappers |
| `bash` | system | Universal | Wrapper scripting language |
| `grep` | system | Universal | Simple YAML parsing fallback |

**yq v3 syntax note:** yq v3.4.3 uses legacy syntax: `yq r file.yaml 'command_allowlist[*]'` (not v4's `yq '.command_allowlist[]' file.yaml`). Recommend grep-based parsing to avoid version-pinning the wrapper on a specific yq API.

---

## Architecture Patterns

### Recommended Project Structure (Phase 7 additions)

```
governance/
├── governance-L1.yaml        # Unchanged (no allowlist at L1 by design)
├── governance-L2.yaml        # Populated: read-only commands per track
├── governance-L3.yaml        # Populated: L2 + investigation commands
├── governance-L4-track-a.yaml  # Populated: Track A L4 (archival INSERT)
├── governance-L4-track-b.yaml  # Populated: Track B L4 (create-tags)
└── governance-L4-track-c.yaml  # Populated: Track C L4 (apply + rollout undo)

agents/
├── track-a-database/config.yaml   # Populated: L2 baseline allowlist
├── track-b-finops/config.yaml     # Populated: L2 baseline allowlist
├── track-c-kubernetes/config.yaml # Populated: L2 baseline allowlist
└── fleet-coordinator/config.yaml  # NO CHANGE (see Fleet Coordinator finding)

infrastructure/wrappers/
├── mock-kubectl    # EXTENDED with pre-flight governance check
├── mock-aws        # EXTENDED with pre-flight governance check
└── mock-psql       # EXTENDED with pre-flight governance check
```

### Pattern 1: HERMES_LAB_GOVERNANCE allowlist format in YAML

**What:** Allowlists stored as simple lists of command prefix strings in governance/*.yaml files. These are NOT Hermes `command_allowlist` description-key strings — they are course-local strings matched by the wrapper, not by Hermes internals.

**Why simple strings:** The governance yamls already use plain YAML lists for `command_allowlist: []`. Extending to plain strings maintains readability and diff-teachability.

**Example populated governance-L2.yaml:**
```yaml
# governance-L2.yaml — Advisory
platform_toolsets:
  cli: [terminal, file, web, skills]

approvals:
  mode: manual
  timeout: 300

command_allowlist: []  # Hermes native: nothing bypasses the DANGEROUS_PATTERNS prompt

# Course-local wrapper enforcement (not a Hermes config key):
wrapper_allowlist:
  kubectl:
    - "get pods"
    - "get pod "
    - "describe pod "
    - "logs "
    - "get nodes"
    - "top pods"
  aws:
    - "sts get-caller-identity"
    - "ec2 describe-"
    - "rds describe-"
    - "cloudwatch get-metric-"
    - "ce get-"
  psql:
    - "SELECT "
    - "EXPLAIN "
    - "SHOW "
    - "\\d"
    - "\\dt"
    - "\\l"
```

**ALTERNATIVE (simpler, recommended):** Keep the course-local allowlist as a separate top-level key OR keep separate files. The planner should decide the exact YAML structure. Both approaches produce the same participant diff experience.

### Pattern 2: Wrapper Pre-Flight Check (PATH B implementation)

**What:** Each wrapper script reads `HERMES_LAB_GOVERNANCE`, resolves the governance yaml path, and performs an allowlist check before any mock routing.

**When to use:** All three wrappers (mock-kubectl, mock-aws, mock-psql) when `HERMES_LAB_GOVERNANCE` is set.

**Example extension to mock-kubectl (pre-flight block, insert before banner):**

```bash
#!/usr/bin/env bash
# ... existing header ...
set -euo pipefail

MOCK_DATA_DIR="${MOCK_DATA_DIR:-$(dirname "$0")/../mock-data}"
LAB_MODE="${HERMES_LAB_MODE:-live}"
SCENARIO="${HERMES_LAB_SCENARIO:-clean}"
GOVERNANCE="${HERMES_LAB_GOVERNANCE:-}"   # NEW: L1|L2|L3|L4

if [[ "$LAB_MODE" != "mock" ]]; then
  exec "$(command -v kubectl)" "$@"
fi

# ── GOVERNANCE PRE-FLIGHT ────────────────────────────────────────────────
if [[ -n "$GOVERNANCE" ]]; then
  COURSE_DIR="$(dirname "$0")/../.."
  GOVERNANCE_FILE="$COURSE_DIR/governance/governance-${GOVERNANCE}.yaml"

  # Track-specific L4 file
  # (Requires HERMES_LAB_TRACK=track-a|track-b|track-c for L4)
  # ... resolve track-specific file for L4 ...

  CMD_KEY="${1:-} ${2:-}"

  # Check if command prefix is in wrapper allowlist
  # (parsed from yaml via grep or yq)
  ALLOWED=0
  while IFS= read -r allowed_prefix; do
    if [[ "$CMD_KEY" == "$allowed_prefix"* ]]; then
      ALLOWED=1
      break
    fi
  done < <(grep -A99 "wrapper_allowlist:" "$GOVERNANCE_FILE" | grep "kubectl:" -A99 | grep "^    - " | sed 's/    - "//;s/"$//')

  if [[ "$ALLOWED" == "0" ]]; then
    printf '\n' >&2
    printf '╓──────────────────────────────────────────────────╖\n' >&2
    printf '║         ╔ GOVERNANCE REJECTED ╗                  ║\n' >&2
    printf '╠──────────────────────────────────────────────────╣\n' >&2
    printf '║ Command:     kubectl %s\n' "$*" >&2
    printf '║ Governance:  %s\n' "$GOVERNANCE" >&2
    printf '║ Block reason: Not in %s wrapper_allowlist\n' "$GOVERNANCE" >&2
    printf '║ SOUL.md rule: Check NEVER rules in your SOUL.md  ║\n' >&2
    printf '╙──────────────────────────────────────────────────╜\n' >&2
    printf '\n' >&2
    exit 1
  fi
fi
# ────────────────────────────────────────────────────────────────────────
```

**Note on parsing complexity:** The wrapper_allowlist YAML structure requires grep-based parsing because yq v3 syntax differs from v4. Recommend the planner evaluate whether a simpler YAML structure (flat lists with a prefix comment like `# kubectl:`) or companion `.txt` files would reduce parsing complexity. The exact approach is Claude's discretion per CONTEXT.md.

### Pattern 3: Track-Specific L4 File Resolution

**What:** L4 has three track-specific files (`governance-L4-track-a.yaml`, etc.) while L1-L3 are shared. The wrapper needs to know which track file to load.

**Recommended:** Add `HERMES_LAB_TRACK=track-a|track-b|track-c` env var (new, Phase 7). OR: always require HERMES_LAB_GOVERNANCE=L4-track-a (compound value). OR: the wrapper reads a `HERMES_LAB_TRACK` already established.

**CONTEXT.md does not lock this** — it is Claude's discretion. Simplest approach: the governance file name is always `governance-${HERMES_LAB_GOVERNANCE}.yaml`, so at L4 participants export `HERMES_LAB_GOVERNANCE=L4-track-a` rather than just `L4`. The D-04 lock says values are `L1|L2|L3|L4` — but the three L4 track files cannot be resolved from just `L4` without a second env var. The planner must resolve this.

**Recommendation:** Add `HERMES_LAB_TRACK` env var to the D-05 env var table, defaulting to the participant's track. Wrapper resolves `governance-L4-track-${HERMES_LAB_TRACK}.yaml` when `HERMES_LAB_GOVERNANCE=L4`. L1-L3 use shared files regardless of track.

### Anti-Patterns to Avoid

- **Modifying Hermes source to add patterns:** PATH A is not available. Do not create a `hermes-patterns.py` that monkey-patches `approval.DANGEROUS_PATTERNS` — it requires a Hermes code change and re-install.
- **Using `command_allowlist` in config.yaml for kubectl/aws blocklist:** These Hermes-native allowlist entries are description-key strings from DANGEROUS_PATTERNS. kubectl delete is not in DANGEROUS_PATTERNS so it cannot be "pre-approved" — the allowlist has no effect on commands that never trigger the gate.
- **yq v4 syntax in wrapper:** System yq is v3.4.3 — v4 syntax (`yq '.command_allowlist[]'`) will fail.
- **exit 1 in MOCK MODE before mock routing:** The governance pre-flight must fire BEFORE the MOCK MODE banner but AFTER the live pass-through check. Structure: live passthrough → governance check → mock banner → mock routing.
- **Rewriting Module 13 lab:** D-15 is explicit. Steps 1-10 (GUIDED PHASE) are preserved. Phase 7 adds new steps inside the GUIDED PHASE only, renumbering the existing final guided steps and challenges.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Hermes custom DANGEROUS_PATTERNS | Python monkey-patch, config hook | Wrapper pre-flight check | Hermes DANGEROUS_PATTERNS is hardcoded; course-local wrapper is simpler and teaches the concept cleanly |
| YAML key extraction in bash | Custom bash YAML parser | `grep`-based prefix matching OR `yq` (available) | Governance yaml is simple; prefix matching on known key names avoids full YAML parser |
| Per-command blocklist logic | Complex permission matrix | Simple string prefix matching in bash | kubectl delete/drain/exec are distinguishable by `$1 $2` prefix; no regex needed |

**Key insight:** The wrapper enforcement is not "security for a production system" — it is "teaching material for demonstrating governance concepts." The implementation should be as readable as possible, not as robust as possible. Participants read this code in the lab.

---

## Runtime State Inventory

Not applicable — Phase 7 is content authoring (YAML files, bash scripts, markdown). No rename/refactor/migration. No runtime state contains the strings being added.

---

## Common Pitfalls

### Pitfall 1: L4 Allowlist Governance YAML Structure Ambiguity

**What goes wrong:** CONTEXT.md D-11 says profile configs get "L2 baseline" allowlist. But L2-L3 governance yamls are track-agnostic (shared). If the governance yamls list commands for all three tracks, a FinOps agent's wrapper would also have kubectl commands in its resolved allowlist — undermining GOV-02 (per-track isolation).

**Why it happens:** The governance yaml files (L1-L3) are shared, but domain separation requires Track B agents to not have kubectl in their allowlist and Track C agents to not have psql in their allowlist.

**How to avoid:** Use track-specific files for ALL four levels (L1-L3 can still be shared for the non-allowlist keys, but the allowlist section is track-specific), OR embed the allowlist in the `agents/track-*/config.yaml` profile config only (not in shared L1-L3 governance yamls), OR structure the governance yaml with per-tool allowlist sections and each wrapper reads only its own tool's section.

**Research recommendation:** Keep L1-L3 governance yamls as shared (current structure) but add a `wrapper_allowlist` key that each wrapper reads selectively (kubectl wrapper reads `wrapper_allowlist.kubectl`, aws wrapper reads `wrapper_allowlist.aws`, psql wrapper reads `wrapper_allowlist.psql`). This preserves the diff-teachability of shared L1-L3 yamls while enabling per-track enforcement.

### Pitfall 2: Module 13 Lab Step Count Discrepancy

**What goes wrong:** CONTEXT.md says the lab has "10 steps." The actual lab has 13 steps (Steps 1-13). Steps 1-10 are the GUIDED PHASE, Steps 11-13 are FREE EXPLORE challenges.

**Why it happens:** CONTEXT.md was written based on the "guided phase" step count, not including the challenge steps.

**How to avoid:** Phase 7 extends the GUIDED PHASE by inserting Steps 9-12 before the current Step 9 (DANGEROUS_PATTERNS review), renumbering existing Steps 9-10 to Steps 13-14, and either renumbering or rewriting the FREE EXPLORE challenges (currently Steps 11-13) as Steps 15-17. Alternatively, insert the L4 steps at the END of the GUIDED PHASE (after Step 10, before the FREE EXPLORE boundary), making them Steps 11-14 and renaming the current FREE EXPLORE Steps 11-13 as Steps 15-17. The planner must choose the insertion point.

**Recommended insertion:** Insert L4 as Steps 11-14 between the "Restore" step and the FREE EXPLORE section. Renumber existing FREE EXPLORE steps from 11-13 to 15-17. This preserves the logical flow (GUIDED ends with L4 demo, FREE EXPLORE is open-ended challenges).

### Pitfall 3: L4 Track File Resolution Without HERMES_LAB_TRACK

**What goes wrong:** D-04 says `HERMES_LAB_GOVERNANCE=L4` (just `L4`). But there are three L4 files. The wrapper cannot resolve `governance-L4.yaml` (it doesn't exist) — it needs to resolve `governance-L4-track-a.yaml`.

**Why it happens:** D-04 was locked before the file naming convention was interrogated.

**How to avoid:** Either add `HERMES_LAB_TRACK` env var to the D-05 table (planner choice), or adopt compound governance value `L4-track-a` for the env var. Recommend adding `HERMES_LAB_TRACK` as a new env var — it makes the convention self-documenting and avoids encoding track identity in the governance value.

### Pitfall 4: CONTEXT.md D-02 References Non-Existent mock-psql

**What goes wrong:** D-02 says "extend mock-psql extension (Track A) if they exist or are created." The CONTEXT.md had uncertainty about whether mock-psql exists.

**Finding:** `infrastructure/wrappers/mock-psql` EXISTS (3.6K, confirmed). It follows identical patterns to mock-kubectl and mock-aws: MOCK MODE banner, HERMES_LAB_MODE/HERMES_LAB_SCENARIO reading, case-based routing. Phase 7 extends it identically to the other two wrappers.

### Pitfall 5: Governance YAML comment_allowlist vs wrapper_allowlist Confusion

**What goes wrong:** The Hermes-native `command_allowlist` in `config.yaml` has a specific technical meaning (bypass DANGEROUS_PATTERNS prompt for pre-approved description-key strings). If Phase 7 uses the same key name in governance yamls for the wrapper blocklist, participants will confuse the two mechanisms.

**Why it happens:** Both mechanisms are "allowlists" but they work at different layers.

**How to avoid:** Use a different key name for the wrapper enforcement list. Options: `wrapper_allowlist`, `lab_allowlist`, `permitted_commands`. Never reuse `command_allowlist` for the course-local wrapper mechanism. The reference.mdx update must explain this distinction explicitly.

### Pitfall 6: Mock-AWS Banner Writes to Stderr, Mock-Kubectl Writes to Stdout

**What goes wrong:** The GOVERNANCE REJECTED banner must be consistently placed. In `mock-aws`, the MOCK MODE banner writes to stderr (`>&2`). In `mock-kubectl` and `mock-psql`, the MOCK MODE banner writes to stdout.

**Finding:**
- `mock-kubectl`: `printf '╔...' \n` (no `>&2`) — stdout
- `mock-aws`: `printf '╔...' \n >&2` — stderr
- `mock-psql`: `printf '╔...' \n` (no `>&2`) — stdout

**How to avoid:** GOVERNANCE REJECTED banner should consistently write to stderr across all three wrappers so it does not contaminate JSON output that mock-aws returns on stdout. Recommend the planner standardize the REJECTED banner to stderr for all three wrappers (even if the MOCK MODE banner is inconsistent).

---

## Existing Infrastructure Inventory

### Wrapper Status

| File | Exists | Size | HERMES_LAB_MODE | HERMES_LAB_SCENARIO | HERMES_LAB_GOVERNANCE | Banner stdout/stderr |
|------|--------|------|-----------------|---------------------|----------------------|---------------------|
| `infrastructure/wrappers/mock-kubectl` | YES | 5.7K | YES | YES | NOT YET | stdout |
| `infrastructure/wrappers/mock-aws` | YES | 3.8K | YES | YES | NOT YET | stderr |
| `infrastructure/wrappers/mock-psql` | YES | 3.6K | YES | YES | NOT YET | stdout |

### Governance YAML Status

| File | Exists | Current command_allowlist | Phase 7 Action |
|------|--------|--------------------------|----------------|
| `governance/governance-L1.yaml` | YES | `[]` | Keep empty (L1 = no terminal, no allowlist) |
| `governance/governance-L2.yaml` | YES | `[]` | Populate with read-only commands for all tracks |
| `governance/governance-L3.yaml` | YES | `[]` | Populate with L2 + investigation commands |
| `governance/governance-L4-track-a.yaml` | YES | `[]` | Populate with Track A L4 (archival INSERT) |
| `governance/governance-L4-track-b.yaml` | YES | `[]` | Populate with Track B L4 (create-tags) |
| `governance/governance-L4-track-c.yaml` | YES | `[]` | Populate with Track C L4 (apply + rollout undo) |

### Agent Profile Config Status

| File | Exists | Current command_allowlist | Phase 7 Action |
|------|--------|--------------------------|----------------|
| `agents/track-a-database/config.yaml` | YES | `[]` comment says "L4 would add SELECT/EXPLAIN/SHOW" | Populate with L2 baseline |
| `agents/track-b-finops/config.yaml` | YES | `[]` | Populate with L2 baseline |
| `agents/track-c-kubernetes/config.yaml` | YES | `[]` | Populate with L2 baseline |
| `agents/fleet-coordinator/config.yaml` | YES | **NO command_allowlist key** | Keep as-is (see Fleet Coordinator finding) |

### Fleet Coordinator Current State (D-10 research answer)

The fleet coordinator `config.yaml` exists and contains:
- `platform_toolsets: cli: [web, skills]` — no terminal (already L1-equivalent governance)
- `delegation` block for specialist handoff
- `approvals: mode: manual` + `timeout: 300`
- **No `command_allowlist` key at all** (not even empty)

Decision for Phase 7: The fleet coordinator already has no terminal — it cannot execute domain commands. Adding `command_allowlist: []` would be purely cosmetic. Keeping it unchanged is correct. Phase 9 owns the fleet governance story per D-10.

### Module 13 Lab Current State

**File:** `course-site/docs/module-13-governance/lab/LAB.mdx`
**Size:** 22.9K

**Actual step count:** 13 steps total
- Steps 1-10: GUIDED PHASE (60 min)
- Steps 11-13: FREE EXPLORE PHASE (30 min — challenges)

**Existing GUIDED PHASE structure:**
| Step | Title | Relevant to Phase 7 |
|------|-------|---------------------|
| 1 | Prerequisites (5 min) | No change |
| 2 | View All Governance Levels (5 min) | No change |
| 3 | Apply L1 — No Terminal (10 min) | No change |
| 4 | Diff L1 to L2 — Terminal Added (5 min) | **UPDATE diff output** (shows empty allowlist diff, needs populated) |
| 5 | Apply L2 — Manual Approval Gate (10 min) | No change (no blocking command in Step 5) |
| 6 | Diff L2 to L3 — Smart Approval (5 min) | **UPDATE diff output** (shows only mode change — may need allowlist diff too) |
| 7 | Apply L3 — Smart Approval (10 min) | No change |
| 8 | Read Your Session Audit Trail (10 min) | No change |
| 9 | Review DANGEROUS_PATTERNS (5 min) | **RENUMBER to 13** — shifts to FREE EXPLORE or becomes higher step |
| 10 | Restore Agent to Working Config (5 min) | **RENUMBER to 14** — after new L4 steps |

**Phase 7 inserts (4 new steps in GUIDED PHASE after current Step 8):**
| New Step | Content |
|----------|---------|
| 9 | Apply L4 — copy populated governance-L4-track-{a,b,c}.yaml, export HERMES_LAB_GOVERNANCE=L4, show diff from L3 |
| 10 | Attempt blocked command — observe GOVERNANCE REJECTED banner (Track A: DROP TABLE; Track B: aws ec2 terminate; Track C: kubectl delete) |
| 11 | Attempt allowed command — observe pass-through (Track A: SELECT; Track B: aws ec2 describe; Track C: kubectl get pods) |
| 12 | Query audit trail for rejection event — hermes sessions + sqlite3 |

**Existing diff blocks that need updating:**
- **Step 4 diff block (L1 vs L2):** Currently shows only `platform_toolsets` change. After governance yamls are populated with `wrapper_allowlist`, the diff will show allowlist additions at L2. The Step 4 diff block must be updated.
- **Step 6 diff block (L2 vs L3):** Currently shows only `approvals.mode` change. If L2 and L3 have different `wrapper_allowlist` sections (L3 adds investigation commands), the diff block must reflect this.

**Source-of-truth file:** `modules/module-13-governance/LAB.md` (22.9K) mirrors the Docusaurus MDX. Both files must be updated in sync.

### Module 13 Reading Reference Current State

**File:** `course-site/docs/module-13-governance/reading/reference.mdx`

**§1 (Governance Config per Maturity Level)** shows full config.yaml YAML blocks for L1, L2, L3, L4-track-a, L4-track-b, L4-track-c. All six blocks show `command_allowlist: []`. Phase 7 must update these blocks to show populated `wrapper_allowlist` sections.

**Current L4 Track B and Track C YAML blocks in reference.mdx** contain comments saying these tracks rely on SOUL.md NEVER rules because `aws ec2 terminate-instances` and `kubectl delete` are NOT in DANGEROUS_PATTERNS. This is correct and must be PRESERVED — Phase 7 adds wrapper enforcement as a third teaching layer, it does not replace the SOUL.md safety explanation.

**§2 (Diff commands)** shows three diff commands. After Phase 7 populates the yamls, the diff commands will produce different output than shown inline. The reference.mdx §2 diff examples will need updating.

### Module 10 Cascade Targets

| File | Relevant Passage | Phase 7 Change |
|------|-----------------|----------------|
| `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` | Lines ~369-376: `command_allowlist` reference, shows `command_allowlist: ["EXPLAIN"]` as exercise | Update: show populated L2 baseline |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx` | Line 322: "Add read-only AWS command patterns to `command_allowlist`" | Update: show populated content |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` | Not yet verified — grep returned no hits in Track C mdx | Confirm if any `command_allowlist` references exist |
| `modules/module-10-agents/LAB-track-a-database.md` | Line 345-352: same content | Mirror update |
| `modules/module-10-agents/LAB-track-b-finops.md` | Line 310 | Mirror update |
| `modules/module-10-agents/solution/track-a/config.yaml` | Line 17: `command_allowlist: []  # L2: nothing pre-approved; L4 would add "SELECT", "EXPLAIN", "SHOW"` | Update |
| `modules/module-10-agents/solution/track-b/config.yaml` | Line 20: `command_allowlist: []` | Update |
| `modules/module-10-agents/solution/track-c/config.yaml` | Line 20: `command_allowlist: []` | Update |
| `modules/module-10-agents/starter/track-a/config-starter.yaml` | Line 29: `command_allowlist: []` with comment | Update comment at minimum |
| `modules/module-10-agents/starter/track-b/config-starter.yaml` | Line 34: `command_allowlist: []` | Update |
| `modules/module-10-agents/starter/track-c/config-starter.yaml` | Line 33: `command_allowlist: []` | Update |

**Module 10 reference.mdx:** Contains `command_allowlist: []` in multiple YAML blocks (lines 201, 240, 262) and a table row stating "Empty at course level" (line 166). These descriptions need updating to reflect the now-populated state.

---

## DANGEROUS_PATTERNS Full List

From `tools/approval.py` lines 68-106. Complete list with description keys:

| Description Key | Regex Trigger | Track A | Track B | Track C |
|-----------------|---------------|---------|---------|---------|
| `delete in root path` | `rm` + root path | all | all | all |
| `recursive delete` | `rm -r` | all | all | all |
| `recursive delete (long flag)` | `rm --recursive` | all | all | all |
| `world/other-writable permissions` | `chmod 777/666/o+w/a+w` | all | all | all |
| `recursive world/other-writable (long flag)` | `chmod --recursive ... 777...` | all | all | all |
| `recursive chown to root` | `chown -R root` | all | all | all |
| `recursive chown to root (long flag)` | `chown --recursive ... root` | all | all | all |
| `format filesystem` | `mkfs` | all | all | all |
| `disk copy` | `dd if=` | all | all | all |
| `write to block device` | `> /dev/sd` | all | all | all |
| **`SQL DROP`** | `DROP TABLE/DATABASE` | **YES — Track A** | no | no |
| **`SQL DELETE without WHERE`** | `DELETE FROM` without `WHERE` | **YES — Track A** | no | no |
| **`SQL TRUNCATE`** | `TRUNCATE TABLE` | **YES — Track A** | no | no |
| `overwrite system config` | `> /etc/` | all | all | all |
| `stop/disable system service` | `systemctl stop/disable/mask` | low | low | **possible** |
| `kill all processes` | `kill -9 -1` | low | low | **possible** |
| `force kill processes` | `pkill -9` | all | all | all |
| `fork bomb` | `:() { :|: & }; :` | all | all | all |
| `shell command via -c flag` | `bash/sh -c` | all | all | all |
| `script execution via -e/-c flag` | `python/perl/ruby -c/-e` | all | all | all |
| `pipe remote content to shell` | `curl|wget ... \| bash` | all | all | all |
| `execute remote script via process substitution` | `bash <(curl ...)` | all | all | all |
| `overwrite system file via tee` | `tee ... ~/.ssh or /etc/` | all | all | all |
| `overwrite system file via redirection` | `>> ~/.ssh or /etc/` | all | all | all |
| `xargs with rm` | `xargs ... rm` | all | all | all |
| `find -exec rm` | `find ... -exec rm` | all | all | all |
| `find -delete` | `find ... -delete` | all | all | all |
| `start gateway outside systemd` | `gateway run ... &` | internal | internal | internal |
| `kill hermes/gateway process` | `pkill hermes` | internal | internal | internal |
| `copy/move file into /etc/` | `cp/mv/install ... /etc/` | all | all | all |
| `in-place edit of system config` | `sed -i ... /etc/` | all | all | all |
| `in-place edit of system config (long flag)` | `sed --in-place ... /etc/` | all | all | all |

**Key findings for three-layer defense teaching:**

- **Track A (Database):** SQL DROP, SQL DELETE without WHERE, SQL TRUNCATE are in DANGEROUS_PATTERNS. These commands receive both Layer 1 (wrapper allowlist) and Layer 2 (Hermes DANGEROUS_PATTERNS gate). Layer 3 (SOUL.md NEVER rules) adds behavioral refusal. Three layers fire simultaneously — Track A is the ideal teaching example for the three-layer defense model.

- **Track B (FinOps):** `aws ec2 terminate-instances`, `aws rds delete-db-instance`, `aws rds modify-*` are NOT in DANGEROUS_PATTERNS. Only Layer 1 (wrapper) and Layer 3 (SOUL.md) apply. Track B demonstrates why two of three layers matter — and why SOUL.md is load-bearing.

- **Track C (Kubernetes):** `kubectl delete`, `kubectl drain`, `kubectl exec`, `kubectl cordon` are NOT in DANGEROUS_PATTERNS. Same as Track B: Layer 1 (wrapper) and Layer 3 (SOUL.md) only. Track C demonstrates the same gap.

---

## Mock Wrapper YAML Parsing Approach

**Recommendation: grep-based prefix matching (no yq dependency)**

The governance yamls have predictable structure. The wrapper needs to check whether `"$1 $2"` (the command prefix) matches any allowed prefix in the yaml allowlist. This can be done with grep without a full YAML parser:

```bash
# Given governance yaml with:
# wrapper_allowlist:
#   kubectl:
#     - "get pods"
#     - "describe pod "
#     - "logs "

# Parse kubectl allowlist lines
ALLOWED_PREFIXES=$(grep -A999 "^  kubectl:" "$GOVERNANCE_FILE" 2>/dev/null \
  | grep "^    - " \
  | sed 's/^    - "//; s/"$//')

# Check if current command matches any prefix
CMD_ARGS="${1:-} ${2:-} ${3:-}"
ALLOWED=0
while IFS= read -r prefix; do
  [[ -z "$prefix" ]] && continue
  if [[ "$CMD_ARGS" == "$prefix"* ]]; then
    ALLOWED=1
    break
  fi
done <<< "$ALLOWED_PREFIXES"
```

**Why grep over yq:** yq v3.4.3 (installed) and potential yq v4 (may also be present) have incompatible syntax. The grep approach is yq-version-agnostic, requires no external tool beyond what ships with macOS/Linux, and is readable by participants who may not know yq.

**Edge case:** The grep `grep -A999` approach breaks if another yaml section follows `kubectl:` — use a stop condition or parse to the next non-indented line. A robust version:

```bash
ALLOWED_PREFIXES=$(awk '/^  kubectl:/{found=1; next} found && /^    - /{gsub(/^    - "|"$/, ""); print} found && /^  [a-z]/{exit}' "$GOVERNANCE_FILE" 2>/dev/null)
```

This `awk` approach is slightly more robust and still requires no external dependencies.

---

## GOVERNANCE REJECTED Banner Design

Based on the existing `[ MOCK MODE ]` banner in `mock-kubectl` (lines 21-27):

```
╔══════════════════════════════════════════╗
║            [ MOCK MODE ]                 ║
║   Data source: pre-baked JSON files      ║
║   Set HERMES_LAB_MODE=live for real K8s  ║
╚══════════════════════════════════════════╝
```

The CONTEXT.md D-03 illustrative banner uses a different box style (`╓/╙` with `╠/╣`). Either is acceptable. The recommended banner uses the same `╔/╚` style as MOCK MODE for visual consistency:

```
╔══════════════════════════════════════════════════╗
║              [ GOVERNANCE REJECTED ]             ║
╠══════════════════════════════════════════════════╣
║  Command:      kubectl delete pod api-deploy     ║
║  Governance:   L2 (Advisory)                     ║
║  Block reason: Not in L2 wrapper_allowlist        ║
║  To override:  Upgrade to higher governance level ║
╚══════════════════════════════════════════════════╝
```

**Banner output:** Write to stderr (`>&2`) across ALL THREE wrappers (see Pitfall 6 above — mock-aws already does stderr, mock-kubectl/mock-psql need to shift the banner to stderr to avoid contaminating stdout JSON).

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| bash | All wrappers | YES (system) | 3.2+ | None needed |
| yq | Optional YAML parsing | YES | 3.4.3 | Use grep/awk |
| awk | YAML parsing fallback | YES (system) | system | None needed |
| sqlite3 | Module 13 audit trail (existing) | YES (system macOS) | system | None needed |
| kubectl (KIND) | Track C live mode | Depends on participant setup | — | Wrapper provides mock |
| psql | Track A live mode | Depends on participant setup | — | Wrapper provides mock |
| aws CLI | Track B live mode | Depends on participant setup | — | Wrapper provides mock |

**Missing dependencies with no fallback:** None — all Phase 7 work is code authoring + content editing. No new external runtime dependencies are added.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Empty `command_allowlist: []` with comment "would add X" | Populated allowlists at each governance level | Phase 7 | Participants see real populated configs, not aspirational comments |
| SOUL.md NEVER rules as sole mechanical protection for Track B/C | Wrapper pre-flight check (Layer 1) + SOUL.md NEVER (Layer 3) | Phase 7 | Track B/C now have two enforcement layers instead of one |
| `command_allowlist` in config.yaml taught as "the allowlist mechanism" | Two distinct allowlist mechanisms: Hermes `command_allowlist` (approval bypass for known patterns) vs course `wrapper_allowlist` (course-local command prefix filter) | Phase 7 | Participants learn to distinguish platform-native vs course-local enforcement |

---

## Open Questions

1. **L4 governance file resolution with single env var**
   - What we know: D-04 specifies `HERMES_LAB_GOVERNANCE=L4` but three L4 files exist
   - What's unclear: Whether to use `HERMES_LAB_TRACK` (new var) or compound value `L4-track-a` in `HERMES_LAB_GOVERNANCE`
   - Recommendation: Add `HERMES_LAB_TRACK=track-a|track-b|track-c` to D-05 env var table; L4 resolution uses `governance-L4-${HERMES_LAB_TRACK}.yaml`. Planner should decide and document.

2. **YAML structure for wrapper_allowlist in governance files**
   - What we know: CONTEXT.md specifies `command_allowlist` as the governance yaml key (for Hermes-native allowlist). Phase 7 needs a SEPARATE key for the course-local wrapper blocklist.
   - What's unclear: Should the wrapper enforcement list live in governance yamls (`wrapper_allowlist`) or in a separate companion file (e.g., `governance/wrapper-blocklist-L2.txt`)? Or embedded only in agent profile configs?
   - Recommendation: Add `wrapper_allowlist` section to governance yamls (per-tool subsections). Keeps the "diff IS the governance decision" teaching intact. Planner decides exact key name.

3. **Module 13 lab step renumbering — insertion point**
   - What we know: Lab has 13 steps (GUIDED: 1-10, FREE EXPLORE: 11-13). Phase 7 adds 4 new GUIDED steps.
   - What's unclear: Insert after Step 8 (making L4 Steps 9-12, shifting DANGEROUS_PATTERNS review to 13, Restore to 14, challenges to 15-17)? Or after Step 10 (making L4 Steps 11-14, challenges stay 15-17)?
   - Recommendation: Insert after Step 10 (Restore) so the GUIDED phase ends at Step 14 with L4 content as the capstone. Steps 9-10 (DANGEROUS_PATTERNS review + Restore) are currently logical bookends of the guided phase — insert L4 between them, making Restore step the final reset after L4 demo.

4. **L2/L3 governance yamls: shared vs per-track allowlists**
   - What we know: L2/L3 are shared files (no track suffix). GOV-02 requires per-track isolation.
   - What's unclear: If L2 yaml has `wrapper_allowlist.kubectl: [get pods, ...]`, Track B agents with `mock-aws` wrapper will only check `wrapper_allowlist.aws` — so per-tool sections in the shared file achieve per-track isolation through wrapper selection.
   - Recommendation: Use per-tool sections in L2/L3 yamls (kubectl/aws/psql subsections). Each wrapper reads only its own section. Track B `mock-aws` reads `wrapper_allowlist.aws` and never sees kubectl commands. Track isolation achieved without per-track L2/L3 files.

---

## Code Examples

Verified patterns from source inspection:

### Existing MOCK MODE Banner (reference for GOVERNANCE REJECTED design)
```bash
# Source: infrastructure/wrappers/mock-kubectl lines 21-27
printf '\n'
printf '╔══════════════════════════════════════════╗\n'
printf '║            [ MOCK MODE ]                 ║\n'
printf '║   Data source: pre-baked JSON files      ║\n'
printf '║   Set HERMES_LAB_MODE=live for real K8s  ║\n'
printf '╚══════════════════════════════════════════╝\n'
printf '\n'
```

### Existing Wrapper Env Var Pattern (reference for HERMES_LAB_GOVERNANCE addition)
```bash
# Source: infrastructure/wrappers/mock-kubectl lines 12-18
MOCK_DATA_DIR="${MOCK_DATA_DIR:-$(dirname "$0")/../mock-data}"
LAB_MODE="${HERMES_LAB_MODE:-live}"
SCENARIO="${HERMES_LAB_SCENARIO:-clean}"
# Phase 7 adds:
GOVERNANCE="${HERMES_LAB_GOVERNANCE:-}"

if [[ "$LAB_MODE" != "mock" ]]; then
  exec "$(command -v kubectl)" "$@"
fi
# Phase 7 inserts pre-flight block HERE (before MOCK MODE banner)
```

### Hermes command_allowlist Loading (reference — shows what it does and doesn't do)
```python
# Source: tools/approval.py lines 332-346
def load_permanent_allowlist() -> set:
    from hermes_cli.config import load_config
    config = load_config()
    patterns = set(config.get("command_allowlist", []) or [])  # loads bypass keys only
    if patterns:
        load_permanent(patterns)
    return patterns
```

### DANGEROUS_PATTERNS Detection (reference — no extension point)
```python
# Source: tools/approval.py lines 154-165
def detect_dangerous_command(command: str) -> tuple:
    command_lower = _normalize_command_for_detection(command).lower()
    for pattern, description in DANGEROUS_PATTERNS:  # hardcoded list only
        if re.search(pattern, command_lower, re.IGNORECASE | re.DOTALL):
            return (True, description, description)
    return (False, None, None)
```

### Agent Profile Config Structure (reference — what Phase 7 populates)
```yaml
# Source: agents/track-c-kubernetes/config.yaml (current state)
command_allowlist: []    # Phase 7: replace [] with L2 baseline list

# Source: agents/fleet-coordinator/config.yaml (current state)
# NO command_allowlist key — fleet coordinator has no terminal
platform_toolsets:
  cli: [web, skills]    # already L1-equivalent by design
```

---

## Sources

### Primary (HIGH confidence)
- `/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` — DANGEROUS_PATTERNS source, full module inspected, confirmed no extension point
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/config.py` — DEFAULT_CONFIG inspected (lines 494-534), confirmed `command_allowlist` is bypass mechanism only
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/main.py` — grep confirmed no `--patterns` flag
- All 6 `governance/*.yaml` files — read in full, confirmed empty allowlists and current structure
- All 4 `agents/*/config.yaml` files — read in full, confirmed current state
- All 3 `infrastructure/wrappers/*` files — read in full, confirmed identical patterns and no governance logic
- `course-site/docs/module-13-governance/lab/LAB.mdx` — read in full, confirmed 13 steps (not 10)
- `course-site/docs/module-13-governance/reading/reference.mdx` — read in full, confirmed sections and YAML blocks

### Secondary (MEDIUM confidence)
- Grep searches for `DANGEROUS_PATTERNS`, `dangerous_patterns`, `custom_patterns`, `command_allowlist` across Hermes `.py` and `.yaml` files — confirmed no extension mechanism exists
- Module 10 lab files inspected for `command_allowlist` references — cascade targets identified

---

## Metadata

**Confidence breakdown:**
- D-01 fork decision: HIGH — DANGEROUS_PATTERNS is hardcoded, confirmed by source inspection + exhaustive grep
- Standard stack: HIGH — all wrapper and governance files read directly
- Architecture (PATH B): HIGH — wrapper pattern well-established, same mechanism used for MOCK MODE
- Pitfalls: HIGH (1, 2, 4, 5, 6) to MEDIUM (3) — all from direct code/file inspection
- Module 13 lab step count: HIGH — read file directly, confirmed 13 steps

**Research date:** 2026-04-07
**Valid until:** Stable (config files and Hermes source are not fast-moving for this phase)
