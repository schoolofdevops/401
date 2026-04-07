# Phase 7: Guardrails & Governance - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Populate Hermes governance configs with real operational safety — the 6 reference files in `governance/` (L1, L2, L3, L4-track-a, L4-track-b, L4-track-c) AND the 3 agent profile configs (`agents/track-*/config.yaml`) get populated allowlists for all 3 tracks. Module 13 lab is extended with Steps 9-12 walking through L4 with attempted blocked commands, attempted allowed commands, and audit trail inspection.

Phase 7 ships:
1. Populated allowlists in all 6 `governance/*.yaml` reference files and 3 `agents/track-*/config.yaml` profile configs (symmetric across tracks)
2. New `HERMES_LAB_GOVERNANCE` env var (L1 | L2 | L3 | L4) for the mock-kubectl wrapper — OR custom Hermes DANGEROUS_PATTERNS if research proves feasible (see D-01)
3. Enforcement mechanism (wrapper extension OR custom patterns per research outcome) that produces a **loud `╓ GOVERNANCE REJECTED ╖` banner with exit 1** when a blocked command is attempted
4. Module 13 lab extension: Steps 9-12 applying L4, attempting blocked commands, attempting allowed commands, and querying `hermes sessions` audit
5. Module 13 reading/reference.mdx updated to reflect populated allowlists and the new env var
6. Module 10 lab cascade: expected `config.yaml` output blocks updated to show populated allowlists

Phase 7 does NOT touch:
- Agent triggers (Phase 8 / TRIG-01..04)
- Multi-agent fleet workflows or K8s Agent Sandbox (Phase 9 / FLEET-01..02, PROD-01..02)
- Module 11 fleet lab (Phase 9 territory)
- Module 1-6 content (out of scope)
- Upstream Hermes contributions (may happen in parallel but does not block Phase 7 execution)

</domain>

<decisions>
## Implementation Decisions

### Enforcement Mechanism

- **D-01:** **Researcher investigates Hermes custom DANGEROUS_PATTERNS first.** Phase 7 researcher spawned before planning must answer: "Does Hermes support loading custom DANGEROUS_PATTERNS from config.yaml, a plugin file, or any other extension mechanism without forking the codebase?" Researcher reads Hermes source at `/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` and related files, documents the answer with file/line citations. **This is a fork decision** — all downstream implementation depends on the answer.

- **D-02:** **Fallback mechanism (if D-01 finds no native extension support):** Extend `infrastructure/wrappers/mock-kubectl` with allowlist enforcement. The wrapper reads `HERMES_LAB_GOVERNANCE` env var, loads the corresponding allowlist from the active governance yaml, intercepts the kubectl command, and either passes through to real kubectl (or mock JSON routing) if allowed or prints the GOVERNANCE REJECTED banner and exits 1 if blocked. Same mechanism applied to `infrastructure/wrappers/mock-aws` (Track B) and a new `infrastructure/wrappers/mock-psql` extension (Track A) if they exist or are created. Phase 7 wraps all three command families.

- **D-03:** **Rejection UX — loud banner + exit 1.** Mirrors the existing `[ MOCK MODE ]` banner pattern from mock-kubectl. Example output:
  ```
  ╓──────────────────────────────────────────────────╖
  ║         ╔ GOVERNANCE REJECTED ╗                  ║
  ╠──────────────────────────────────────────────────╣
  ║ Command:         kubectl delete pod api-deploy   ║
  ║ Governance:      L3 (Proposal)                   ║
  ║ Block reason:    Not in L3 allowlist             ║
  ║ SOUL.md rule:    "NEVER execute kubectl delete"  ║
  ║ To override:     Upgrade to L4 + justify         ║
  ╙──────────────────────────────────────────────────╜
  ```
  Wrapper exits with status 1. Visible enough that participants cannot miss it.

- **D-04:** **Governance level source — `HERMES_LAB_GOVERNANCE` env var.** Participants `export HERMES_LAB_GOVERNANCE=L2` (or L1/L3/L4) before each lab step. Consistent with the existing `HERMES_LAB_MODE` and `HERMES_LAB_SCENARIO` pattern from Phases 1 and 6. If env var is unset, default to L2 (current Module 10 starting level).

### Environment Variables (MANDATORY documentation in Module 13 lab)

- **D-05:** **Every lab step must show the complete `export` block** so learners always know exactly which env vars are active. The full Phase 7 env var set:

  | Env Var | Values | Source | Purpose |
  |---|---|---|---|
  | `HERMES_LAB_MODE` | `mock` \| `live` | Phase 1 | Route kubectl/aws/psql to mock JSON fixtures or real infra |
  | `HERMES_LAB_SCENARIO` | `clean` \| `messy` \| `crashloop` \| `image-pull` \| `crashloop2` \| `oom` \| `liveness` \| `missing-secret` \| `port-mismatch` | Phase 1 + Phase 6 | Select scenario fixture for mock mode |
  | `HERMES_LAB_GOVERNANCE` | `L1` \| `L2` \| `L3` \| `L4` | **Phase 7 NEW** | Select active governance level for wrapper enforcement |
  | `MOCK_DATA_DIR` | path | Phase 1 | Point to mock fixtures directory |
  | `PATH` additions | `infrastructure/wrappers:$PATH` | Phase 1 | Make wrappers override system kubectl/aws/psql |

  Each lab step shows the full block, not just the env var that changed. Solo Learner callout reminds Udemy participants to keep the block in their shell history.

### Per-Track Allowlist Content (symmetric across all 3 tracks)

- **D-06:** **All 3 tracks populated symmetrically at L2+.** No track stays empty. Phase 7 produces real allowlist content for Track A (Database), Track B (FinOps), and Track C (Kubernetes). The wrapper enforcement (D-02) makes them mechanically real regardless of whether the native Hermes DANGEROUS_PATTERNS fires.

- **D-07:** **Track C (Kubernetes) allowlist — REQUIREMENTS.md verbatim:**
  - **L2 allowed:** `kubectl get`, `kubectl describe`, `kubectl logs`, `kubectl top`
  - **L3 adds:** `kubectl rollout history`, `kubectl rollout status`, `kubectl diff`, `kubectl explain`
  - **L4 adds:** `kubectl apply` (with smart-approval gate), `kubectl rollout undo` (with smart-approval gate)
  - **Always blocked:** `kubectl delete`, `kubectl drain`, `kubectl exec`, `kubectl cordon`, `kubectl uncordon`, `kubectl taint` (never in allowlist at any level)

- **D-08:** **Track A (Database) allowlist — read-only SQL + EXPLAIN:**
  - **L2 allowed:** `SELECT`, `EXPLAIN`, `SHOW`, `DESCRIBE`, psql meta-commands (`\d`, `\dt`, `\l`)
  - **L3 adds:** `DELETE ... WHERE ... LIMIT` (scoped), `UPDATE ... WHERE ... LIMIT` (scoped), `EXPLAIN ANALYZE`
  - **L4 adds:** `INSERT ... SELECT` for archival patterns (with smart-approval gate)
  - **Always blocked:** `DROP`, `TRUNCATE`, `DELETE without WHERE`, `ALTER TABLE`, all DDL
  - Note: `SQL DROP`, `DELETE without WHERE`, `TRUNCATE` are already in Hermes's native DANGEROUS_PATTERNS — the wrapper allowlist and the Hermes gate BOTH fire, producing a two-layer defense. This is the "two-gate model" (D-13).

- **D-09:** **Track B (FinOps) allowlist — AWS read-only describe/get commands:**
  - **L2 allowed:** `aws sts get-caller-identity`, `aws ec2 describe-*`, `aws rds describe-*`, `aws cloudwatch get-metric-*`, `aws cost-explorer get-*`, `aws ce get-*`
  - **L3 adds:** `aws logs describe-*`, `aws logs get-log-events`, `aws iam get-*` (read-only identity inspection)
  - **L4 adds:** `aws ec2 create-tags` (tagging only, never modifies resources)
  - **Always blocked:** `aws ec2 terminate-instances`, `aws ec2 modify-instance-attribute`, `aws rds delete-db-instance`, `aws rds modify-*`, any verb containing `terminate`/`delete`/`modify` except `create-tags` at L4

- **D-10:** **Fleet coordinator (Morgan) governance:** Phase 9 owns the fleet workflow rebuild. Phase 7 leaves `agents/fleet-coordinator/config.yaml` untouched if it exists, OR sets it to L1 (no terminal) since the fleet coordinator delegates to specialists rather than executing directly. Decision deferred to research — researcher confirms fleet coordinator's current config.

### Agent Profile Config Updates

- **D-11:** **Agent profile configs get populated allowlists by default.** Phase 6 D-17 deferred `command_allowlist: []` changes to Phase 7 — Phase 7 resolves this. Each `agents/track-*/config.yaml` is updated to include the L2 allowlist inline (since L2 is the default Module 10 installation level). The governance/*.yaml reference files cover all 4 levels; profile configs match L2 baseline.

- **D-12:** **Module 10 cascade update.** Module 10 lab MDX files show `cat config.yaml` output with `command_allowlist: []` — these blocks must be updated to show the populated L2 allowlist. Text-only cascade, consistent with Phase 6's cascade pattern. Also update any `grep -q 'command_allowlist: \[\]'` verification blocks that check for the empty allowlist.

### Progression Story (L1 → L4)

- **D-13:** **Progressive read-to-write unlock.** Allowlist grows at each level:
  - **L1:** Empty. Terminal toolset disabled. Agent cannot execute anything — proposes text only.
  - **L2:** Read-only diagnostic commands unlocked. Agent can run `kubectl get pods`, `aws ec2 describe-instances`, `SELECT * FROM users` without approval. Novel patterns still flag.
  - **L3:** Rollout/diff/investigation commands unlocked. `kubectl rollout history`, `EXPLAIN ANALYZE`, `aws cost-explorer get-cost-and-usage`. Smart-approval replaces manual for remaining flagged commands.
  - **L4:** Targeted mutations unlocked with human-approval override. `kubectl apply`, `aws ec2 create-tags`, `INSERT ... SELECT`. These are in the allowlist AND go through smart-approval AND fall under SOUL.md NEVER rules — three-layer defense.
  - Each level's `diff L{N}.yaml L{N+1}.yaml` output is shown in the lab as the teaching artifact. The diff IS the governance decision.

- **D-14:** **Two-gate model at L4.** L4 allowlist includes mutation commands BUT `approvals.mode: smart` still evaluates them via the auxiliary LLM. This creates a three-layer defense:
  1. **Layer 1 (allowlist):** Command must be in the active governance level's allowlist to be attempted
  2. **Layer 2 (DANGEROUS_PATTERNS gate):** If the command matches Hermes's native patterns, smart-approval evaluates it
  3. **Layer 3 (SOUL.md NEVER rules):** Identity-level prohibition that the agent refuses regardless of config
  Module 13 Step 10 demonstrates Layer 1 rejection. Step 11 demonstrates Layer 2 smart-approval pass for allowed commands. Step 12 demonstrates the audit trail showing both gates.

### Module 13 Lab Extension

- **D-15:** **Extend existing 10-step Module 13 lab with Steps 9-12.** Do NOT rewrite the lab. Steps 1-8 remain intact (L1 → L2 → L3 walkthrough). New steps:
  - **Step 9:** Apply L4 — copy populated `governance-L4-track-{a,b,c}.yaml` to profile, `export HERMES_LAB_GOVERNANCE=L4`, show the diff from L3
  - **Step 10:** Attempt a blocked command (Track A: `DROP TABLE test`; Track B: `aws ec2 terminate-instances ...`; Track C: `kubectl delete pod api-deployment`) — observe the loud `GOVERNANCE REJECTED` banner with rationale
  - **Step 11:** Attempt an allowed command (Track A: `SELECT * FROM ...`; Track B: `aws ec2 describe-instances`; Track C: `kubectl get pods`) — observe it passes
  - **Step 12:** Query `hermes sessions` audit trail for the rejection event — demonstrate the audit record contains command, governance level, rejection reason, timestamp

- **D-16:** **Update diff output blocks in Steps 4, 6.** The existing lab has `diff governance-L1.yaml governance-L2.yaml` blocks that show an empty diff for `command_allowlist`. These need to update to show the now-populated lines.

- **D-17:** **Reading reference.mdx updates.** Update `course-site/docs/module-13-governance/reading/reference.mdx` §1 (Governance Config per Maturity Level) to show populated yamls for all 4 levels. Add a new §1.5 (or similar) documenting `HERMES_LAB_GOVERNANCE` env var and the three-layer defense model. Do NOT delete the existing "SOUL.md is load-bearing for Track B/C" teaching — it remains TRUE for commands the wrapper passes through.

### Claude's Discretion

- Exact allowlist format inside the YAML (simple list of strings vs structured objects with descriptions)
- Wrapper's YAML parsing approach in bash (simple grep-based vs yq vs bash regex)
- Exact audit log schema for rejection events
- Whether to ship a new `mock-aws` or extend existing (Track B needs aws wrapper coverage)
- Whether `infrastructure/wrappers/mock-psql` exists or needs to be created for Track A
- Exact GOVERNANCE REJECTED banner ASCII art (the D-03 example is illustrative, not prescriptive)
- Whether to add a quiz question about the three-layer defense model
- Exact wording of Module 10 cascade text updates
- Whether fleet coordinator (Morgan) gets its own governance config (deferred to researcher)
- Exact PROJECTS.mdx exploratory entry structure for populated allowlists (if any)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing Governance Infrastructure (must read)
- `governance/governance-L1.yaml` — L1 Assistive template (no terminal, empty allowlist). Stays empty at L1 — agent cannot execute.
- `governance/governance-L2.yaml` — L2 Advisory template (terminal enabled, manual approval, empty allowlist). **Phase 7 populates the allowlist.**
- `governance/governance-L3.yaml` — L3 Proposal template (smart approval, empty allowlist). **Phase 7 populates.**
- `governance/governance-L4-track-a.yaml` — L4 Semi-autonomous for DBA track. **Phase 7 populates with Track A L4 content.**
- `governance/governance-L4-track-b.yaml` — L4 Semi-autonomous for FinOps track. **Phase 7 populates with Track B L4 content.**
- `governance/governance-L4-track-c.yaml` — L4 Semi-autonomous for Kubernetes track. **Phase 7 populates with Track C L4 content.**
- `agents/track-a-database/config.yaml` — Track A agent profile (currently `command_allowlist: []`). **Phase 7 populates with L2 baseline.**
- `agents/track-b-finops/config.yaml` — Track B agent profile. **Phase 7 populates with L2 baseline.**
- `agents/track-c-kubernetes/config.yaml` — Track C agent profile (Phase 6 D-17 deferred this work). **Phase 7 populates with L2 baseline.**
- `agents/fleet-coordinator/config.yaml` — Fleet coordinator profile (if exists). **Phase 7 researcher confirms current state and decides action.**

### Existing Lab Infrastructure (must read — Phase 7 extends, does NOT rewrite)
- `infrastructure/wrappers/mock-kubectl` — Existing kubectl wrapper (Phase 1 + Phase 6). **Phase 7 extends this** with `HERMES_LAB_GOVERNANCE` env var reading and allowlist enforcement if D-01 research finds no native Hermes extension mechanism.
- `infrastructure/wrappers/mock-aws` — Existing aws wrapper (Phase 1). **Phase 7 extends.**
- `infrastructure/wrappers/mock-psql` — May or may not exist; researcher confirms.
- `infrastructure/mock-data/` — Mock JSON fixtures used by the wrappers. Phase 7 does NOT modify these.

### Module 13 Content (Phase 7 extends)
- `course-site/docs/module-13-governance/lab/LAB.mdx` — Existing 10-step lab walking L1 → L2 → L3. **Phase 7 adds Steps 9-12.** Do NOT rewrite Steps 1-8. Update diff output blocks in existing Steps 4 and 6 to show populated allowlists.
- `course-site/docs/module-13-governance/reading/reference.mdx` — Existing governance reference documentation. **Phase 7 updates §1** (Governance Config per Maturity Level) to show populated yamls and adds new section for `HERMES_LAB_GOVERNANCE` env var.
- `course-site/docs/module-13-governance/reading/concepts.mdx` — Light touch, only if reading has conceptual updates from the populated-allowlist change.
- `course-site/docs/module-13-governance/quiz/QUIZ.mdx` — Optional: add a new question about three-layer defense model.

### Module 10 Cascade Targets (Phase 7 text-only updates)
- `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` — Update expected `cat config.yaml` output blocks
- `course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx` — Update expected `cat config.yaml` output blocks
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` — Update expected `cat config.yaml` output blocks (already touched by Phase 6 cascade)
- `modules/module-10-agents/LAB-track-*.md` — Source-of-truth LAB files that mirror the Docusaurus MDX

### Hermes Source (researcher reads for D-01)
- `/Users/gshah/work/agentic/devops/hermes-agent/tools/approval.py` — DANGEROUS_PATTERNS list source. Researcher must determine: does Hermes load additional patterns from config.yaml, plugin files, or env vars?
- `/Users/gshah/work/agentic/devops/hermes-agent/agent/` — Agent bootstrap and config loading code. Researcher inspects for extension hooks.
- `/Users/gshah/work/agentic/devops/hermes-agent/hermes_cli/` — CLI entry points. Researcher checks for `--patterns` flag or similar.
- `/Users/gshah/work/agentic/devops/hermes-agent/docs/` — Any documented extension mechanism.

### Course Project & Requirements
- `.planning/PROJECT.md` — v1.1 Active requirements, Key Decisions, current state
- `.planning/REQUIREMENTS.md` §Guardrails & Governance — GOV-01 through GOV-03 (phase deliverables)
- `.planning/ROADMAP.md` Phase 7 — 3 success criteria
- `.planning/phases/06-k8s-skills-agents/06-CONTEXT.md` — Phase 6 prior context. D-17 explicitly defers `command_allowlist: []` work to Phase 7.
- `CLAUDE.md` — Course conventions, dual format, free tier constraint

### Prior Phase CONTEXT files (decisions that may be relevant)
- `.planning/phases/04-remaining-content/04-CONTEXT.md` — Phase 4 set Solo Learner callout pattern for Module 11; reused for Module 13 extension
- `.planning/phases/05-module-consolidation/05-CONTEXT.md` — Phase 5 labs-first pattern reused
- `.planning/phases/06-k8s-skills-agents/06-CONTEXT.md` — Phase 6 cascade pattern reused; D-17 owes allowlist work to Phase 7

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **`infrastructure/wrappers/mock-kubectl`** — Already handles kubectl routing, already reads env vars (`HERMES_LAB_MODE`, `HERMES_LAB_SCENARIO`), already has case-statement dispatch. Adding a pre-flight allowlist check at the top of the script is ~20-40 lines of bash. Do not rewrite — extend.
- **`infrastructure/wrappers/mock-aws`** — Same pattern. Phase 7 extends it the same way.
- **6 `governance/*.yaml` files** — Already structured correctly with `platform_toolsets`, `approvals`, `command_allowlist` keys. Just need to populate the empty arrays.
- **3 `agents/track-*/config.yaml` files** — Same structure. Just need to populate `command_allowlist`.
- **Module 13 existing lab (10 steps)** — Solid walkthrough of L1 → L2 → L3. Steps 1-8 are reusable as-is. Add Steps 9-12.
- **Module 13 existing reading reference.mdx §1** — Comprehensive 4-level documentation, just needs populated yaml examples substituted in.
- **`[ MOCK MODE ]` banner pattern in mock-kubectl** — Reusable format for the new `GOVERNANCE REJECTED` banner.
- **Phase 6 cascade pattern** — Same playbook for Module 10 text updates (find expected `cat config.yaml` outputs, update to show populated allowlist).

### Established Patterns
- **Env var naming:** `HERMES_LAB_*` prefix for all lab-control env vars. `HERMES_LAB_GOVERNANCE` follows the convention.
- **Wrapper env var precedence:** Mode → scenario → (new) governance level. Wrapper reads all three in order at startup.
- **Banner format:** Box-drawing characters with title, content lines, bottom border. Mirrors existing MOCK MODE banner.
- **Configuration-as-teaching:** The diff between governance levels IS the teaching moment (from existing Module 13 lab Step 4/6/8). Phase 7 extends this philosophy — the diff between empty and populated allowlist IS the progression.
- **Dual format Solo Learner callouts:** Established in Phase 4 for Module 11 fleet lab. Reused for Module 13 Step 9-12 env var guidance.

### Integration Points
- **Lab step numbering:** Module 13 lab currently goes to Step 10 (audit trail). Phase 7 Steps 9-12 replace the existing Step 9 (audit — which becomes Step 12) and Step 10 (restore backup — which shifts to Step 13). Verify current numbering before planning — may need Step 9 to be "Apply L4" and push existing Steps 9-10 down.
- **Governance yaml file paths:** Module 13 lab references `course/governance/governance-L*.yaml` paths. Phase 7 changes file contents but not paths.
- **Config.yaml backup ritual:** Existing Step 1 has participants `cp config.yaml config.yaml.backup`. This backup step is critical with populated configs — participants need to restore the original state after the lab.

</code_context>

<specifics>
## Specific Ideas

- **Research-gated fork:** The enforcement mechanism (wrapper vs native Hermes patterns) depends on Phase 7 research findings. Researcher must answer D-01 BEFORE planner creates plans. Plans should have two paths: Path A (custom patterns work) → write course/hermes-patterns.py or similar, minimal wrapper changes; Path B (custom patterns don't work) → full mock-kubectl/mock-aws wrapper extension. Either path delivers the same participant experience (GOVERNANCE REJECTED banner on blocked command).

- **The env var story matters more than the mechanism.** Whichever mechanism ships, the participant experience is identical: export HERMES_LAB_GOVERNANCE=L2, attempt blocked command, see banner. The lab walks through this regardless of implementation. Documentation must be CRYSTAL CLEAR about every env var that needs to be set.

- **Two-layer defense is the real teaching moment.** The three-layer defense model (allowlist → DANGEROUS_PATTERNS → SOUL.md) is what differentiates course-grade governance understanding from "checkbox security". The lab must show a command hitting each layer concretely — e.g., for Track A, `DROP TABLE test` hits all three layers and fires rejections at each, which is a powerful teaching moment.

- **Populated allowlists are not aspirational.** The workshop feedback that drove Phase 7 was "empty arrays miss the teaching opportunity". The outcome must be REAL populated allowlists, not documentation saying "imagine this were populated". Every governance/*.yaml and agent profile config gets real content by end of Phase 7.

- **Track A mechanical alignment is a bonus.** Track A's SQL DROP/DELETE/TRUNCATE are already in Hermes DANGEROUS_PATTERNS, so even without the wrapper extension, Track A gets mechanical enforcement. Phase 7 teaches the three-layer model using Track A as the clearest example where all three layers fire simultaneously.

- **Module 13 extension, not rewrite.** Steps 1-8 of the existing lab are gold — they walk L1 → L2 → L3 beautifully. Phase 7 ADDs on top of them, does not restructure. Preserves student progress and reduces re-teaching overhead.

- **Env var documentation in every lab step.** Every Phase 7 lab step that uses wrappers must show the complete `export` block (HERMES_LAB_MODE, HERMES_LAB_SCENARIO, HERMES_LAB_GOVERNANCE, MOCK_DATA_DIR, PATH). Solo Learner callouts remind Udemy participants to keep the block in their shell history across steps.

</specifics>

<deferred>
## Deferred Ideas

### Phase 8 territory (do not preempt)
- **Agent trigger governance** — When a trigger fires an agent, what governance level does the triggered agent inherit? This is a Phase 8 concern (TRIG-01..04). Phase 7 establishes the governance infrastructure; Phase 8 wires it to triggers.

### Phase 9 territory (do not preempt)
- **Fleet coordinator (Morgan) governance** — If Morgan orchestrates specialist agents, does the fleet coordinator need its own governance config, or does it inherit from the specialists? Phase 7 researcher confirms current state but the full answer is Phase 9 (FLEET-01, FLEET-02).
- **K8s Agent Sandbox governance** — Sandbox CRDs have their own isolation primitives. How does that interact with Hermes governance? Phase 9 / PROD-01 territory.

### v1.2 candidates
- **Hermes upstream contribution** — Extending DANGEROUS_PATTERNS with kubectl/aws mutation commands as a PR to upstream Hermes. Does not block Phase 7 (wrapper extension works independently) but would eliminate the course-specific wrapper if accepted upstream.
- **Smart-approval auxiliary LLM configuration** — Making the smart-approval mode configurable (which model, which prompt template). Currently Hermes uses a fixed prompt. Would be a v1.2 config feature.
- **Audit log export format** — Structured export of audit trails (SIEM-friendly JSON, CSV). Out of scope for Phase 7 but desired for real production deployments.
- **Governance level per-command override** — Participant-specified override mechanism that logs justification. Discussed but deferred — adds complexity without clear teaching value.

</deferred>

---

*Phase: 07-guardrails-governance*
*Context gathered: 2026-04-07*
