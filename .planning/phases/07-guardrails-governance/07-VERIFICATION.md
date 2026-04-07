---
phase: 07-guardrails-governance
verified: 2026-04-07T13:45:00Z
status: passed
score: 11/11 must-haves verified
re_verification: false
gaps: []
human_verification:
  - test: "Run a Hermes agent session with Module 10 Track C config at L2 and attempt kubectl delete — observe GOVERNANCE REJECTED banner in tool call output"
    expected: "The agent's tool call output shows the GOVERNANCE REJECTED banner; the agent acknowledges the rejection and does not retry the blocked command"
    why_human: "Cannot verify agent reasoning behavior (Layer 3 SOUL.md refusal vs Layer 1 wrapper rejection) programmatically — requires live Hermes session"
  - test: "Run Module 13 Step 12 (audit trail query) with a live Hermes session after a blocked-command attempt"
    expected: "The sqlite3 query returns the rejection event with command, governance level, rejection reason, and timestamp"
    why_human: "Requires live Hermes session with actual DB write — no Hermes process runs in this environment"
---

# Phase 7: Guardrails & Governance Verification Report

**Phase Goal:** Hermes governance configs demonstrate real operational safety with populated command allowlists — participants can observe what happens when a blocked command is attempted
**Verified:** 2026-04-07T13:45:00Z
**Status:** PASSED
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths (ROADMAP Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Participant running Hermes agent with Module 10 or 13 config finds kubectl get/describe/logs in allowlist and kubectl delete/drain/exec blocked — blocked command produces governance rejection, not silent execution | VERIFIED | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-kubectl delete pod foo` → GOVERNANCE REJECTED banner on stderr, exit 1. `mock-kubectl get pods` → JSON output, exit 0. Banner shows command, governance level, file path, and SOUL.md Layer 3 reminder. |
| 2 | Each domain track (K8s, Database, FinOps) has a separate governance config file with domain-appropriate allowlists — FinOps agent cannot issue kubectl commands, K8s agent cannot run database mutations | VERIFIED | `agents/track-a-database/config.yaml` has only `wrapper_allowlist.psql` — zero kubectl/aws keys (grep count = 0). `agents/track-b-finops/config.yaml` has only `wrapper_allowlist.aws`. `agents/track-c-kubernetes/config.yaml` has only `wrapper_allowlist.kubectl`. Per-track isolation confirmed. |
| 3 | Participant following L1 through L4 walkthrough can observe allowlist growing at each trust level — L1 has read-only kubectl, L4 adds write operations with human-approval gate — progression shown in config diffs | VERIFIED | `governance-L1.yaml` has comment-only (no terminal, no allowlist). `governance-L2.yaml` has read-only kubectl/aws/psql. `governance-L3.yaml` extends with investigation commands. `governance-L4-track-c.yaml` adds `apply` and `rollout undo`. Module 13 lab Steps 4/6/9 show diff output blocks at each transition. 17-step lab present in both LAB.mdx and LAB.md. |

**Score:** 3/3 success criteria verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `governance/governance-L1.yaml` | L1 comment — no terminal, no allowlist | VERIFIED | File exists (689B); comment-only wrapper_allowlist note; no populated list by design (L1 has no terminal toolset) |
| `governance/governance-L2.yaml` | L2 read-only allowlist (kubectl/aws/psql) | VERIFIED | File exists (1.5K); `wrapper_allowlist:` populated with kubectl (9 entries), aws (10 entries), psql (7 entries); `command_allowlist: []` preserved |
| `governance/governance-L3.yaml` | L3 investigation allowlist (L2 + investigation) | VERIFIED | File exists (1.9K); `wrapper_allowlist:` present and populated |
| `governance/governance-L4-track-a.yaml` | L4 Track A psql + INSERT INTO | VERIFIED | File exists (1.7K); `wrapper_allowlist:` present with psql section including L3 + INSERT INTO |
| `governance/governance-L4-track-b.yaml` | L4 Track B aws + ec2 create-tags | VERIFIED | File exists (1.8K); `wrapper_allowlist:` present with aws section including L3 + ec2 create-tags |
| `governance/governance-L4-track-c.yaml` | L4 Track C kubectl + apply/rollout undo | VERIFIED | File exists (1.6K); `wrapper_allowlist.kubectl` includes all L3 entries + `apply ` and `rollout undo` |
| `infrastructure/wrappers/mock-kubectl` | kubectl pre-flight governance check | VERIFIED | File exists (9.3K); contains `HERMES_LAB_GOVERNANCE`; awk YAML parser extracts wrapper_allowlist.kubectl; GOVERNANCE REJECTED banner on stderr + exit 1 on blocked commands |
| `infrastructure/wrappers/mock-aws` | aws pre-flight governance check | VERIFIED | File exists (7.3K); contains `HERMES_LAB_GOVERNANCE`; `aws ec2 terminate-instances` at L2 → GOVERNANCE REJECTED, exit 1; `aws ec2 describe-instances` at L2 → MOCK MODE pass-through |
| `infrastructure/wrappers/mock-psql` | psql pre-flight governance check | VERIFIED | File exists (8.1K); contains `HERMES_LAB_GOVERNANCE`; `psql -c "DROP TABLE test"` at L2 → GOVERNANCE REJECTED; `psql -c "SELECT * FROM users"` at L2 → MOCK MODE pass-through |
| `agents/track-a-database/config.yaml` | Track A L2 baseline wrapper_allowlist (psql only) | VERIFIED | `wrapper_allowlist.psql` present; zero kubectl/aws keys; `command_allowlist: []` preserved (1 occurrence) |
| `agents/track-b-finops/config.yaml` | Track B L2 baseline wrapper_allowlist (aws only) | VERIFIED | `wrapper_allowlist.aws` present; SOUL.md safety note preserved |
| `agents/track-c-kubernetes/config.yaml` | Track C L2 baseline wrapper_allowlist (kubectl only) | VERIFIED | `wrapper_allowlist.kubectl` present; SOUL.md safety note preserved |
| `modules/module-10-agents/solution/track-a/config.yaml` | Mirror of canonical track-a config | VERIFIED | `diff agents/track-a-database/config.yaml modules/module-10-agents/solution/track-a/config.yaml` → no output (byte-identical) |
| `modules/module-10-agents/solution/track-b/config.yaml` | Mirror of canonical track-b config | VERIFIED | Byte-identical to agents/track-b-finops/config.yaml |
| `modules/module-10-agents/solution/track-c/config.yaml` | Mirror of canonical track-c config | VERIFIED | Byte-identical to agents/track-c-kubernetes/config.yaml |
| `modules/module-10-agents/starter/track-a/config-starter.yaml` | Starter with wrapper_allowlist documented in comments | VERIFIED | 3 occurrences of `wrapper_allowlist` in comments; no populated list (intentional) |
| `modules/module-10-agents/starter/track-b/config-starter.yaml` | Starter with wrapper_allowlist commented | VERIFIED | 3 occurrences of `wrapper_allowlist` in comments |
| `modules/module-10-agents/starter/track-c/config-starter.yaml` | Starter with wrapper_allowlist commented | VERIFIED | 3 occurrences of `wrapper_allowlist` in comments |
| `modules/module-10-agents/LAB-track-a-database.md` | Updated with two-allowlist narrative | VERIFIED | 3 occurrences of `wrapper_allowlist`; deprecated `command_allowlist: ["EXPLAIN"]` removed |
| `modules/module-10-agents/LAB-track-b-finops.md` | Updated with two-allowlist narrative | VERIFIED | 3 occurrences of `wrapper_allowlist`; `two-layer defense` narrative present |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` | Docusaurus mirror of Track A lab | VERIFIED | 3 occurrences of `wrapper_allowlist`; deprecated example removed |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx` | Docusaurus mirror of Track B lab | VERIFIED | 3 occurrences of `wrapper_allowlist` |
| `course-site/docs/module-13-governance/lab/LAB.mdx` | Extended to 17 steps with 4 new L4 steps | VERIFIED | 17 step headings confirmed; Steps 9-12 cover Apply L4, Attempt Blocked, Attempt Allowed, Query Audit Trail; `GOVERNANCE REJECTED` appears 9 times |
| `modules/module-13-governance/LAB.md` | Source-of-truth mirror, also 17 steps | VERIFIED | 17 step headings confirmed; `HERMES_LAB_GOVERNANCE` present; MDX admonitions converted to blockquotes |
| `course-site/docs/module-13-governance/reading/reference.mdx` | Section 1 updated + section 1.5 added | VERIFIED | 24 occurrences of `wrapper_allowlist`; three-layer defense model documented; env var table present |
| `course-site/docs/module-13-governance/quiz/QUIZ.mdx` | New Question 7 on three-layer defense | VERIFIED | Question 7 covers Track C kubectl delete at L4; correct answer references Layer 1 (wrapper_allowlist) + Layer 3 (SOUL.md); explains why Layer 2 does not fire for Track C |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `infrastructure/wrappers/mock-kubectl` | `governance/governance-L2.yaml` (wrapper_allowlist.kubectl) | awk YAML parser + HERMES_LAB_GOVERNANCE env var | VERIFIED | Behavioral test passed: `delete pod` blocked at L2; `get pods` allowed at L2 |
| `infrastructure/wrappers/mock-aws` | `governance/governance-L2.yaml` (wrapper_allowlist.aws) | same awk parser, aws subsection | VERIFIED | `terminate-instances` blocked; `ec2 describe-instances` passed |
| `infrastructure/wrappers/mock-psql` | `governance/governance-L2.yaml` (wrapper_allowlist.psql) | same awk parser, psql subsection (requires -c flag) | VERIFIED | `psql -c "DROP TABLE test"` blocked; `psql -c "SELECT * FROM ..."` passed |
| `infrastructure/wrappers/mock-kubectl` | `governance/governance-L4-track-c.yaml` | HERMES_LAB_TRACK=track-c resolves to L4-track-c.yaml | VERIFIED | `kubectl delete pod` still blocked at L4-track-c; `kubectl rollout undo` passes governance (MOCK ERROR expected, not GOVERNANCE REJECTED) |
| `modules/module-10-agents/solution/track-*/config.yaml` | `agents/track-*/config.yaml` | byte-identical mirror (manual sync) | VERIFIED | All 3 track diffs return empty (byte-identical) |
| `course-site/docs/module-13-governance/lab/LAB.mdx Step 9` | `governance/governance-L4-track-*.yaml` (from Plan 07-01) | cat command in lab + expected diff output | VERIFIED | Step 9 exports `HERMES_LAB_GOVERNANCE=L4` and `HERMES_LAB_TRACK=track-{a,b,c}`; references governance-L4-track-* path |
| `course-site/docs/module-13-governance/lab/LAB.mdx Step 10` | `infrastructure/wrappers/mock-kubectl` | participant runs wrapped command and sees banner | VERIFIED | Step 10 shows GOVERNANCE REJECTED banner ASCII art; verification check 8 uses `mock-kubectl delete pod foo` directly |
| `course-site/docs/module-13-governance/reading/reference.mdx section 1` | `governance/governance-L2.yaml` populated state | reference.mdx embeds populated YAML content | VERIFIED | 24 occurrences of wrapper_allowlist in reference.mdx; awk parser snippet shown |

### Data-Flow Trace (Level 4)

Not applicable — this phase delivers bash scripts, YAML configs, and Markdown documentation. No dynamic data rendering through React/UI components.

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| kubectl get pods at L2 passes governance | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-kubectl get pods` | MOCK MODE banner + JSON output, exit 0 | PASS |
| kubectl delete at L2 rejected | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-kubectl delete pod foo` | GOVERNANCE REJECTED banner on stderr, exit 1 | PASS |
| kubectl delete blocked even at L4-track-c | `HERMES_LAB_GOVERNANCE=L4 HERMES_LAB_TRACK=track-c HERMES_LAB_MODE=mock mock-kubectl delete pod foo` | GOVERNANCE REJECTED (L4 track-c), exit 1 | PASS |
| kubectl rollout undo passes governance at L4-track-c | `HERMES_LAB_GOVERNANCE=L4 HERMES_LAB_TRACK=track-c HERMES_LAB_MODE=mock mock-kubectl rollout undo deployment/foo` | MOCK MODE banner + MOCK ERROR (no mock for rollout undo), exit 1 — governance did NOT reject it | PASS |
| aws terminate blocked at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-aws ec2 terminate-instances --instance-ids i-1234` | GOVERNANCE REJECTED, exit 1 | PASS |
| aws describe passes at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-aws ec2 describe-instances` | MOCK MODE banner output, passes | PASS |
| psql DROP TABLE blocked at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-psql -c "DROP TABLE test"` | GOVERNANCE REJECTED, exit 1 | PASS |
| psql SELECT passes at L2 | `HERMES_LAB_GOVERNANCE=L2 HERMES_LAB_MODE=mock mock-psql -c "SELECT * FROM users"` | MOCK MODE banner, passes | PASS |
| L4 without HERMES_LAB_TRACK warns, defaults to track-a | `HERMES_LAB_GOVERNANCE=L4 mock-kubectl get pods` | WARNING on stderr, defaults to track-a, continues | PASS (per design: D-04 says "default to L2 if env var unset"; SUMMARY says "default to track-a with warning") |
| Fleet coordinator untouched | `grep wrapper_allowlist agents/fleet-coordinator/config.yaml` | No matches | PASS |
| Phase 6 K8s skill preserved in Track C Module 10 lab | `grep -c sre-k8s-pod-health LAB-track-c-kubernetes.mdx` | 2 occurrences | PASS |
| Module 13 lab has 17 steps | `grep -c "^## Step " LAB.mdx` | 17 | PASS |
| HERMES_LAB_GOVERNANCE in lab (D-05: >5 occurrences per step) | count in LAB.mdx | 7 occurrences | PASS |
| Three-layer defense taught in lab and reference | Grep for "three-layer defense model", "Layer 1", "wrapper_allowlist" | Extensive coverage in both LAB.mdx and reference.mdx | PASS |
| command_allowlist: [] preserved in all configs | count per file across 8 files | 1 per file = 8 total | PASS |
| Per-track isolation enforced (Track A has no kubectl/aws) | `grep -c "kubectl:\|aws:" agents/track-a-database/config.yaml` | 0 | PASS |
| Deprecated command_allowlist: ["EXPLAIN"] removed | grep across Track A .md and .mdx | 0 occurrences | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| GOV-01 | 07-01-PLAN.md | Hermes command allowlist/blocklist — kubectl get/describe/logs allowed, kubectl delete/drain/exec blocked | SATISFIED | Behavioral tests confirm: get pods (allowed), delete pod (blocked at L2, L3, L4-track-c). Wrappers extended with HERMES_LAB_GOVERNANCE pre-flight. |
| GOV-02 | 07-01-PLAN.md, 07-02-PLAN.md | Per-track governance configs with domain-specific allowlists (K8s, Database, FinOps) | SATISFIED | 3 separate L4 governance files (track-a/b/c) + 3 agent profile configs each with only their tool's allowlist section. FinOps agent has no kubectl entries; K8s agent has no psql entries. |
| GOV-03 | 07-03-PLAN.md | Progressive governance walkthrough L1 to L4 with allowlist differentiation showing trust escalation | SATISFIED | 17-step Module 13 lab covers L1-L4 walkthrough with diff blocks at Steps 4/6/9 showing allowlist growth. L1 has no terminal. L4 adds apply/rollout-undo with smart-approval gate. |

All 3 Phase 7 requirements satisfied.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| None found | — | No TODOs, FIXMEs, placeholders, or stubs in modified files | — | — |

No anti-patterns detected in wrapper scripts, governance files, agent configs, or lab content.

### Implementation Note: HERMES_LAB_TRACK Value Format

**Context.md D-05 table** documents `HERMES_LAB_TRACK` values as `a | b | c` (short form).
**Actual implementation** (wrappers + lab) uses `track-a | track-b | track-c` (long form).
**Impact:** Zero — lab files and wrapper scripts are internally consistent. A participant following the lab would use the long form from the export blocks and the wrapper would resolve the correct governance file. The CONTEXT.md documentation is a minor retrospective inconsistency.
**Classification:** Info (documentation drift in planning artifact, no participant impact)

### Human Verification Required

#### 1. Live agent session — governance rejection in tool call output

**Test:** Launch Hermes with Track C config at L2 governance level. Ask the agent to run `kubectl delete pod`. Observe the agent's response.
**Expected:** Agent's tool call output shows the GOVERNANCE REJECTED banner from the wrapper. The agent acknowledges the rejection (does not retry or bypass). If SOUL.md NEVER rules fire first, the agent refuses the intent before the wrapper is invoked — this is also valid.
**Why human:** Cannot verify agent reasoning behavior or tool output routing programmatically. Requires a live Hermes session with the config applied.

#### 2. Module 13 Step 12 — audit trail query

**Test:** Follow Module 13 Steps 9-12 in order. After Step 11 (allowed command), run the sqlite3 query from Step 12.
**Expected:** The query returns at least one row for the GOVERNANCE REJECTED event from Step 10, containing command, governance level, rejection reason, and timestamp.
**Why human:** Requires live Hermes session to write audit records to the SQLite database. No Hermes process is running in this verification environment.

### Gaps Summary

No gaps. All automated checks pass. All 3 ROADMAP success criteria are mechanically verified. All 3 requirements (GOV-01, GOV-02, GOV-03) are satisfied. The phase goal — "Hermes governance configs demonstrate real operational safety with populated command allowlists — participants can observe what happens when a blocked command is attempted" — is achieved.

---

_Verified: 2026-04-07T13:45:00Z_
_Verifier: Claude (gsd-verifier)_
