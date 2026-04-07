# Phase 7: Guardrails & Governance - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-07
**Phase:** 07-guardrails-governance
**Areas discussed:** Enforcement mechanism, Per-track content, Module 13 lab scope, L1→L4 progression

---

## Enforcement mechanism

### Q1: How should Phase 7 actually block kubectl/aws commands that are NOT in Hermes DANGEROUS_PATTERNS?

| Option | Description | Selected |
|--------|-------------|----------|
| Extend mock-kubectl wrapper | Add allowlist enforcement to existing wrapper. Reads HERMES_LAB_GOVERNANCE env var. Works for mock AND live. Zero upstream changes. | |
| Research Hermes custom patterns | Investigate whether Hermes supports loading custom DANGEROUS_PATTERNS from config.yaml or plugins. If yes, use them. If no, fall back to wrapper. | ✓ |
| Write standalone governance-guard.sh | New dedicated wrapper script. Cleaner separation but duplicates routing logic. | |
| Populated-where-mechanical + honest-documentation | Only Track A (SQL DROP is in DANGEROUS_PATTERNS). Track B/C stay empty with SOUL.md-only documentation. | |

**User's choice:** Research Hermes custom patterns
**Notes:** Fork decision — researcher must answer first. All downstream implementation depends on whether Hermes supports custom patterns from config.

---

### Q2: If researcher finds Hermes does NOT support custom DANGEROUS_PATTERNS, what's the fallback mechanism?

| Option | Description | Selected |
|--------|-------------|----------|
| Extend mock-kubectl wrapper | Wrapper enforces allowlist based on HERMES_LAB_GOVERNANCE env var. Reuses existing routing logic. | ✓ |
| Standalone governance-guard.sh | New dedicated wrapper script. Cleaner separation but more setup. | |
| Populated-where-mechanical + documented elsewhere | Partial delivery on workshop feedback. | |
| Contribute custom patterns upstream | Fork Hermes, add kubectl/aws patterns, open upstream PR. Doesn't block Phase 7. | |

**User's choice:** Extend mock-kubectl wrapper (Recommended)
**Notes:** Fallback is clear — extend the existing wrapper. Works in both mock and live mode since wrapper is already in PATH.

---

### Q3: How should the governance rejection look when a participant attempts a blocked command?

| Option | Description | Selected |
|--------|-------------|----------|
| Loud banner + exit code 1 | Prominent GOVERNANCE REJECTED banner with command, governance level, allowlist, SOUL.md rule. Mirrors [ MOCK MODE ] pattern. | ✓ |
| Silent exit 1 with stderr message | Short 'governance-rejected: ...' message + exit 1. Cleaner for CI but less visible. | |
| Interactive prompt | Mirror Hermes approval gate format. More complex to implement in bash. | |

**User's choice:** Loud banner + exit code 1 (Recommended)
**Notes:** Participants cannot miss it. Consistent with MOCK MODE banner from Phase 1.

---

### Q4: Should the governance level be read from yaml config or env var?

| Option | Description | Selected |
|--------|-------------|----------|
| HERMES_LAB_GOVERNANCE env var | Consistent with existing HERMES_LAB_MODE/SCENARIO pattern from Phase 1 + 6. Easy to switch. | ✓ |
| Read from active config.yaml | More realistic but requires knowing which profile is active. Fragile. | |
| Symlink-based (active-governance.yaml) | Explicit but adds filesystem state to lab setup. | |

**User's choice:** HERMES_LAB_GOVERNANCE env var (Recommended)
**Notes:** Env var pattern is established, consistent with other lab env vars.

---

## Per-track content

### Q1: How should allowlist content differ across the 3 tracks?

| Option | Description | Selected |
|--------|-------------|----------|
| All 3 tracks populated symmetrically | Each track gets populated allowlist at L2+. Wrapper enforcement makes them mechanically real. Pedagogical symmetry. | ✓ |
| Populate only where DANGEROUS_PATTERNS fires | Track A populated (real Hermes gate). B/C wrapper-enforced but Hermes ignores. Honest but asymmetric. | |
| K8s-first (Track C) centerpiece | Focus primarily on Track C. Ships faster but leaves A/B partial. | |
| Track-B-minimal (defer to v1.2) | A + C full, B partial. | |

**User's choice:** All 3 tracks populated symmetrically (Recommended)
**Notes:** Workshop feedback demands concrete populated allowlists for all tracks. Wrapper makes them real regardless of DANGEROUS_PATTERNS gap.

---

### Q2: For Track C (Kubernetes), what goes in the allowlist vs blocklist?

| Option | Description | Selected |
|--------|-------------|----------|
| REQUIREMENTS.md spec verbatim | Allowed: kubectl get/describe/logs/top. Blocked: kubectl delete/drain/exec. L3 adds rollout. L4 adds apply + rollout undo with approval. | ✓ |
| Broader read-only set | Allow all non-mutating verbs. More inclusive. | |
| Strict minimal | Only get/describe at L2. L3 adds logs/top. More conservative. | |

**User's choice:** REQUIREMENTS.md spec verbatim (Recommended)
**Notes:** Matches GOV-01 requirement text verbatim. Mirrors K8s failure modes from Phase 6.

---

### Q3: For Track A (Database), what goes in the allowlist?

| Option | Description | Selected |
|--------|-------------|----------|
| Read-only SQL + EXPLAIN | L2: SELECT/EXPLAIN/SHOW/DESCRIBE/psql meta. L3 adds scoped DELETE/UPDATE. L4 adds INSERT...SELECT. | ✓ |
| Read-only + session analytics | Add pg_stat_*, pg_locks. More useful but blurs read-only line. | |
| Minimal SELECT only | Most conservative. | |

**User's choice:** Read-only SQL + EXPLAIN (Recommended)
**Notes:** Track A's SQL DROP/DELETE/TRUNCATE already fires native Hermes gate — allowlist makes progression concrete and demonstrates three-layer defense.

---

### Q4: For Track B (FinOps), what goes in the allowlist?

| Option | Description | Selected |
|--------|-------------|----------|
| AWS read-only describe/get | L2: sts/ec2/rds describe, cloudwatch get, cost-explorer get. L3 adds logs/iam read-only. L4 adds create-tags. | ✓ |
| Cost commands only | Scope Finley tighter to cost tools. | |
| Broad read-only with explicit deny list | Allow all describe/get, deny all mutation verbs. | |

**User's choice:** AWS read-only describe/get commands (Recommended)
**Notes:** Clear describe/get vs mutation distinction. Matches AWS CLI verb conventions.

---

### Q5: Should Phase 7 update agent profile configs in addition to governance/ reference files?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — update both | Phase 6 D-17 deferred this. Agent profiles get L2 baseline. Reference files get all 4 levels. | ✓ |
| No — only update governance/ | Keep profiles empty. Cleaner separation but leaves Phase 6 D-17 incomplete. | |
| Yes — but profile configs default to L1 | Safest onboarding but breaks Module 10 lab. | |

**User's choice:** Yes — update both reference and profile configs (Recommended)
**Notes:** Resolves Phase 6 D-17. L2 is current Module 10 default, so profile configs match.

---

## Module 13 lab scope

### Q1: How much of Module 13's existing lab should Phase 7 rewrite?

| Option | Description | Selected |
|--------|-------------|----------|
| Extend with L4 steps + populate callouts | Keep Steps 1-8 intact. Add Steps 9-12 for L4 walkthrough. Update diff blocks in existing Steps 4-7. | ✓ |
| Full lab rewrite | 4-level walkthrough from scratch. More cohesive but disrupts existing progress. | |
| Keep lab + add exploratory project | Lowest disruption but weakest GOV-03 delivery. | |
| Minimal lab update + reading overhaul | Light touch on lab. Reading carries teaching load. | |

**User's choice:** Extend with L4 steps + populate allowlist callouts (Recommended)
**Notes:** Minimal disruption. L4 becomes the climax. Existing 10-step lab is solid.

---

### Q2: What should the new L4 steps walk through concretely?

| Option | Description | Selected |
|--------|-------------|----------|
| Attempt blocked + override + audit | Step 9: Apply L4. Step 10: Blocked command → banner. Step 11: Allowed command → passes. Step 12: Audit trail inspection. | ✓ |
| Attempt blocked + attempt allowed only | Skip audit (stays in existing Step 8). Shorter. | |
| Full L4 + override ritual + audit diff | Adds temporary override with justification. More steps. | |

**User's choice:** Attempt blocked + override + audit (Recommended)
**Notes:** Demonstrates both sides of the governance gate plus the audit record.

---

### Q3: Should Phase 7 also update Module 10 lab text?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — update Module 10 expected config output | Config.yaml blocks updated to show populated allowlist. Text-only cascade. | ✓ |
| No — Module 13 owns governance | Module 10 stays generic. Creates inconsistency with actual profile configs. | |
| Yes + add governance preview callout | Most explicit but verbose. | |

**User's choice:** Yes — update Module 10 expected config output (Recommended)
**Notes:** Consistent with Phase 6 cascade pattern. Prevents drift between docs and actual configs.

---

## L1→L4 progression

### Q1: How should allowlist content grow from L1 to L4?

| Option | Description | Selected |
|--------|-------------|----------|
| Progressive read-to-write unlock | L1 empty. L2 read-only. L3 adds rollout/diff/history. L4 adds targeted mutations with approval gate. | ✓ |
| L1-L3 empty, L4 populated | L4 is the turning point. Simpler but loses per-level teaching. | |
| L2 everything, L3-L4 narrow | Front-loaded. Faster to productivity but less dramatic diffs. | |
| Track-divergent progression | Each track has different progression shape. More complex to teach. | |

**User's choice:** Progressive read-to-write unlock (Recommended)
**Notes:** Each level's diff shows concrete new lines. Mirrors real operational trust escalation.

---

### Q2: How should L4's approval gate be demonstrated?

| Option | Description | Selected |
|--------|-------------|----------|
| Two-gate model | L4 commands in allowlist BUT approvals.mode=smart still evaluates. Three-layer defense: allowlist → DANGEROUS_PATTERNS → SOUL.md. | ✓ |
| Allowlist-only at L4 | No approval prompt. Simpler but loses second-layer teaching. | |
| Manual approval required for L4 writes | Even allowlist items need approval. Explicit but frustrating. | |

**User's choice:** Two-gate model (Recommended)
**Notes:** Three-layer defense (allowlist + DANGEROUS_PATTERNS + SOUL.md) is the differentiating teaching moment.

---

## User Special Request: Env Var Documentation

Mid-discussion, the user explicitly requested: "document which env vars need to be set by users/learners properly"

**Captured in CONTEXT.md D-05:** Every lab step must show the complete `export` block with all active env vars:
- `HERMES_LAB_MODE` (mock | live)
- `HERMES_LAB_SCENARIO` (clean | messy | crashloop | image-pull | crashloop2 | oom | liveness | missing-secret | port-mismatch)
- `HERMES_LAB_GOVERNANCE` (L1 | L2 | L3 | L4) — NEW in Phase 7
- `MOCK_DATA_DIR`
- PATH additions

Solo Learner callouts remind Udemy participants to maintain the block across shell sessions.

## Claude's Discretion

These are intentionally left to Claude during research, planning, and execution:

- Exact allowlist format inside yaml (list of strings vs structured objects)
- Wrapper YAML parsing approach in bash
- Exact audit log schema for rejection events
- Whether to ship new `mock-aws` or extend existing
- Whether `mock-psql` exists or needs to be created
- Exact GOVERNANCE REJECTED banner ASCII art
- Quiz question about three-layer defense model
- Exact Module 10 cascade text wording
- Fleet coordinator (Morgan) governance (researcher confirms current state)
- PROJECTS.mdx exploratory entry structure

## Deferred Ideas

- **Phase 8 territory:** Agent trigger governance inheritance
- **Phase 9 territory:** Fleet coordinator governance; K8s Agent Sandbox governance
- **v1.2:** Hermes upstream contribution of custom patterns
- **v1.2:** Smart-approval auxiliary LLM configuration
- **v1.2:** Structured audit log export (SIEM/CSV)
- **v1.2:** Per-command override with logged justification
