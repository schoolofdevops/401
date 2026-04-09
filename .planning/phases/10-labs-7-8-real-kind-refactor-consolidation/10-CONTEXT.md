# Phase 10: Labs 7-8 Real KIND Refactor & Consolidation - Context

**Gathered:** 2026-04-09  
**Status:** Ready for planning  
**Source:** User direction + detailed analysis in .planning/analysis_labs_7_8_10_revision.md

---

<domain>

## Phase Boundary

**What this phase delivers:**
1. Remove all mock-mode infrastructure and complexity from Track C labs (Modules 7-8)
   - No HERMES_LAB_MODE environment variables
   - No mock-kubectl wrapper
   - No ~/.bash_profile alias setup requirement
   - No HERMES_LAB_SCENARIO, HERMES_LAB_TRACK, HERMES_LAB_WRAPPERS, MOCK_DATA_DIR

2. Consolidate Module 8 (75 min) + Module 10 (90 min) into a single BUILD-AND-TEST lab (90 min)
   - Phase 1: Configure (20 min) — write SOUL.md, config.yaml, attach skill
   - Phase 2: Test clean cluster (15 min) — verify agent runs against healthy cluster
   - Phase 3: Test failure scenarios (30 min) — apply failure manifests, test diagnostics
   - Phase 4: Structured report (10 min) — agent produces incident report
   - Phase 5: Safety (5 min) — verify agent refuses destructive commands

3. Update setup documentation to remove all mock-mode instructions
   - SETUP.md: remove alias block, wrapper env vars, mock data paths
   - Just: "verify KIND is running"

4. Archive mock infrastructure (kept for reference, not in critical path)
   - infrastructure/wrappers/ (deprecated)
   - infrastructure/mock-data/ (deprecated)
   - All course labs must work WITHOUT these directories

**Success means:** A learner can go from "I just finished Module 6" to "I wrote a SKILL.md and configured an agent on a real KIND cluster" in 60 min (Module 7) + 90 min (Module 8 consolidated) with zero environment variable confusion.

</domain>

<decisions>

## Implementation Decisions

### Architecture: Real KIND Only
- **Decision:** Use real KIND cluster as single source of truth for lab execution
- **Why:** Eliminates abstraction layer (mock vs live), teaches real Kubernetes behavior, removes cognitive burden of mode-switching
- **Scope:** Module 7 Track C + Module 8 Track C (consolidated from current Module 8 + 10)

### Failure Scenarios: Applied During Lab, Not Pre-Baked
- **Decision:** Learners apply failure manifests on demand via `kubectl apply infrastructure/scenarios/k8s/0[1-6]-*.yaml`
- **Why:** Teaches cluster manipulation, gives learners ownership of broken state, reflects real debugging workflow
- **Scope:** 6 existing manifests in infrastructure/scenarios/k8s/ (keep as-is, just add lab instructions to apply them)

### Module Structure: Merge 8 & 10
- **Decision:** Consolidate Module 8 (tool wiring) and Module 10 (testing) into single 90-min lab with 5 phases
- **Why:** Eliminate repeated environment setup, create immediate feedback loop (config → test → evaluate in one session)
- **Scope:** Keep Module 9 (Design Patterns) conceptual; Module 10 disappears from Track C path (or becomes optional "Advanced Optimization")

### Setup Documentation: Simplification
- **Decision:** SETUP.md now just requires `kubectl cluster-info --context kind-lab` — no wrappers, no aliases, no env vars
- **Why:** Reduces setup cognitive load from 5 env vars + 1 bash_profile block to a single `kind get clusters` check
- **Scope:** Affects Modules 7, 8, 9+ for Track C

### Infrastructure: Deprecation, Not Deletion
- **Decision:** Keep infrastructure/wrappers/ and infrastructure/mock-data/ in repo (for reference/history), just don't require them
- **Why:** May be useful for troubleshooting, reference, or future mock-focused variants; clean break allows rollback if needed
- **Scope:** All course code and docs remove dependency on these directories

</decisions>

<canonical_refs>

## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 10 Analysis
- `.planning/analysis_labs_7_8_10_revision.md` — Full analysis: current state, problems, proposed solution, consolidation details, risk mitigation

### Module 7 Track C Lab (Current)
- `course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx` — Currently uses mock-kubectl, needs refactor to real KIND
- `course-site/docs/module-07-agent-skills/lab/LAB.mdx` — Unified lab (shows mock mode references that need cleanup)

### Module 8 Track C Lab (Current)
- `course-site/docs/module-08-tool-integration/lab/LAB.mdx` — Main unified lab (will merge with Module 10)
- `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` — Track C-specific (will be consolidated/merged)

### Module 10 Track C Lab (Current, to be merged/removed)
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` — Testing lab (content to merge into consolidated Module 8)

### Module READMEs (Need updates)
- `course-site/docs/module-07-agent-skills/README.mdx` — Update duration, remove mock mode mentions
- `course-site/docs/module-08-tool-integration/README.mdx` — Update title, duration (now 90 min with testing), explain consolidation
- `course-site/docs/module-10-domain-agent/README.mdx` — Update status (testing moved to Module 8, this module optional/removed for Track C)

### Setup & Infrastructure
- `course-site/docs/setup.mdx` — Remove ~30 lines about ~/.bash_profile alias block and HERMES_LAB_MODE env vars
- `course-site/docs/setup.mdx` Step 5 (Lab Wrapper Aliases) — REMOVE ENTIRELY or mark deprecated
- `infrastructure/wrappers/` — All three (mock-kubectl, mock-aws, mock-psql) marked deprecated but kept
- `infrastructure/mock-data/` — All files marked deprecated but kept

### Failure Scenarios (Unchanged)
- `infrastructure/scenarios/k8s/0[1-6]-*.yaml` — 6 broken pod manifests (ImagePullBackOff, CrashLoopBackOff, OOMKilled, liveness probe, missing secret, port mismatch) — NO CHANGES, just add lab instructions to apply them

### Hermes Agent Profiles (Already Updated in Phase 6 & 7)
- `agents/track-c-kubernetes/SOUL.md` — Already correct (Phase 6/7)
- `agents/track-c-kubernetes/config.yaml` — Already correct (Phase 6/7)
- `agents/track-c-kubernetes/skills/sre-k8s-pod-health/` — Already correct (Phase 6/7)

</canonical_refs>

<specifics>

## Specific Implementation Details

### Module 7 Lab Refactor
**From:** 60 min lab with mock-kubectl wrapper setup + 6 baked HERMES_LAB_SCENARIO choices  
**To:** 60 min lab with real KIND cluster + learner-applied failure scenarios

**Changes:**
- Remove all Prerequisites sections mentioning HERMES_LAB_MODE, HERMES_LAB_SCENARIO, wrappers
- Add Step: "Apply a failure scenario to your KIND cluster"
  ```bash
  kubectl apply -f infrastructure/scenarios/k8s/01-image-pull.yaml
  kubectl get pods  # verify pod is in ImagePullBackOff
  # Now diagnose it with your SKILL.md
  ```
- Remove references to "mock data directory" and "wrapper scripts"
- Keep the SKILL.md writing flow and solution reference (unchanged)

### Module 8 Consolidated Lab Structure
**Duration:** 90 minutes (was: 75 min Lab 8 + 90 min Lab 10 with redundant setup)

**Phase 1: Configure (20 min)** [From current Module 8 Lab, Steps 1-6]
- Examine reference SOUL.md
- Copy/customize SOUL.md and config.yaml
- Attach Module 7 skill to profile
- Verify profile is installed

**Phase 2: Test — Clean Scenario (15 min)** [From current Module 10 Lab, Step 3-4]
- Run agent against healthy cluster
- Agent introduces itself, confirms connection to KIND cluster
- Verify basic functionality

**Phase 3: Test — Failure Scenarios (30 min)** [From current Module 10 Lab, Step 5 + 6 adapted]
- Apply failure manifests one at a time (ImagePullBackOff, CrashLoopBackOff, OOMKilled, etc.)
- Run agent against each
- Evaluation checklist: correct failure mode identification, appropriate kubectl commands, safety boundaries

**Phase 4: Structured Report (10 min)** [From current Module 10 Lab, Step 6]
- Agent produces incident report: alert summary, findings, ambiguity statement, recommended actions

**Phase 5: Safety (5 min)** [From current Module 10 Lab, Step 7]
- Ask agent to "Delete all CrashLoopBackOff pods"
- Verify agent refuses (cites SOUL.md NEVER rule)
- Find the specific NEVER rule in SOUL.md

### Setup Documentation Refactor
**Remove from SETUP.md:**
- Entire Step 5: "Lab Wrapper Aliases — one-time setup"
- All references to ~/.bash_profile alias block
- All HERMES_LAB_* environment variable exports (HERMES_LAB_MODE, HERMES_LAB_SCENARIO, HERMES_LAB_TRACK, HERMES_LAB_WRAPPERS, MOCK_DATA_DIR)

**Add to SETUP.md:**
- Simple KIND cluster check: `kubectl cluster-info --context kind-lab`
- Note: "You've already set up KIND in Module 6. Verify it's still running before starting Module 7."

### Module 10 Track C Decision
**Options:**
1. **Remove entirely** — Testing now happens in Module 8, no need for separate module for Track C
2. **Reposition as optional** — Become "Advanced Optimization & Debugging (exploratory)" at the end of Module 10's exploratory/PROJECTS.mdx

**Recommended:** Option 1 (remove) — cleaner, more time for other content

</specifics>

<deferred>

## Deferred Ideas

- **kube-troublesim integration:** Remains deferred to v1.2 (immature, 1 commit, no releases; baked manifests sufficient for now)
- **Mock data archival/export:** infrastructure/mock-data/ kept but not actively maintained; future versions can ignore or regenerate as needed
- **Wrapper deprecation period:** Keep wrappers in repo for 1-2 releases before hard delete; allows rollback if community feedback indicates mock mode is needed

</deferred>

---

**Phase:** 10  
**Context gathered:** 2026-04-09  
**Ready for:** Planning (gsd-planner agent)

