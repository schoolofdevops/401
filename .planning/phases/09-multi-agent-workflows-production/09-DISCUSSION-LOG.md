# Phase 9: Multi-Agent Workflows & Production - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-07
**Phase:** 09-multi-agent-workflows-production
**Areas discussed:** FLEET-01 chain architecture, FLEET-02 lab mode, PROD-01 Sandbox depth, PROD-02 placement and scope

---

## FLEET-01 chain architecture

### Q1: Is the 'triage agent' separate from Morgan, or is Morgan the triage step?

| Option | Description | Selected |
|--------|-------------|----------|
| Morgan IS the triage step | AlertManager → webhook → Morgan triages → delegates → synthesizes → proposes → approval → applier path. No new triage agent. | ✓ |
| Separate triage agent + Morgan as orchestrator | New triage agent classifies, hands off to Morgan or directly to specialist. More cleanliness, more authoring. | |
| AlertManager directly to specialist | Pre-routed by alert label. Skips triage entirely. Loses cross-domain synthesis. | |

**User's choice:** Morgan IS the triage step (Recommended)
**Notes:** Reuses Morgan's existing identity. No new agent profiles needed.

---

### Q2: Where does human approval happen in the chain?

| Option | Description | Selected |
|--------|-------------|----------|
| Telegram bot from Phase 8 | Morgan posts proposal to Telegram, admin replies /approve or /reject, triggers apply. Reuses Phase 8 admin allowlist. | ✓ |
| Hermes CLI interactive prompt | Morgan pauses for [a]pprove [d]eny at terminal. Breaks "no terminal interaction" premise. | |
| AlertManager-style approval gate | Approval as separate webhook. More complex state machine. | |
| Both Telegram + CLI fallback | Most accessible, doubles authoring. | |

**User's choice:** Telegram bot from Phase 8 (Recommended)
**Notes:** Reuses Phase 8 Telegram infrastructure. Bidirectional ChatOps closes the loop.

---

### Q3: How does 'agent applies the fix' actually work?

| Option | Description | Selected |
|--------|-------------|----------|
| Diagnostic specialist applies under L4 governance | Morgan re-delegates to the specialist with HERMES_LAB_GOVERNANCE=L4 set. Specialist runs the approved kubectl command. Phase 7 wrapper enforces. | ✓ |
| New 'applier' agent profile | Dedicated apply agent. More separation, more profiles to maintain. | |
| Direct kubectl from Morgan post-approval | Would require Morgan terminal access. Violates Morgan's identity. | |
| Hermes CLI human runs the command | Doesn't satisfy "agent applies" success criterion. | |

**User's choice:** Diagnostic specialist applies under L4 governance (Recommended)
**Notes:** Single-agent applier reuses existing infrastructure.

---

### Q4: What's the demo scenario for FLEET-01?

| Option | Description | Selected |
|--------|-------------|----------|
| Phase 6 crashloop2 + Phase 8 alert | Reuse existing infrastructure. Memory limit increase as the fix. | ✓ |
| Custom new scenario | More work, doesn't reuse. | |
| Cross-domain (3 alerts) | Better fit for FLEET-02 (Module 11 lab) than FLEET-01. | |

**User's choice:** Phase 6 crashloop2 + Phase 8 alert (Recommended)
**Notes:** Reuses ALL existing Phase 6+7+8 infrastructure.

---

## User Note: GitOps as production-grade pattern

Mid-discussion, user raised: "While this scenario where agents are coming up with a patch and apply is good, we should also consider GitOps for safe apply and fixing... thats more prod grade"

Claude analyzed the GitOps angle:
- ArgoCD already exists in the course (Phase 1/3 / Module 6 Track B)
- Phase 8 GitHub webhook + `--deliver github_comment` is the natural PR-creation surface
- Reference-app Helm chart is the GitOps deployment target
- GitOps is more production-grade (PR review + audit trail + automated rollback via git revert)
- BUT not every learner will have completed Module 6 Track B (ArgoCD prerequisite)

Re-posed apply step decision with GitOps as a serious alternative.

### Q5 (re-asked): How should FLEET-01 demonstrate the apply step?

| Option | Description | Selected |
|--------|-------------|----------|
| GitOps primary + direct apply as comparison | Path B GitOps via PR is primary, Path A direct apply as urgent fast-path. Most production-realistic. | |
| GitOps only — no direct apply | Cleanest production stance, loses comparison teaching. | |
| Direct apply only (revert to original) | Original decision. Fastest, lowest realism. | |
| GitOps for FLEET-01, direct apply as v1.2 stretch | Most aggressive production stance. | |

**User's choice:** Two-path approach (free-text response: "While this is good, not everyone will setup GitOps/Argo as part of previous module. do we have a fallback where we need not rely on ArgoCD here? if not, lets keep it simple and use patch.fix for now, or have two different branches/options that users can choose from?")
**Notes:** User concerned about ArgoCD prerequisite. Suggested two options.

---

### Q6: How should the two-path apply approach be structured?

| Option | Description | Selected |
|--------|-------------|----------|
| Path A primary + Path B as 'production upgrade' section | GUIDED Path A walks direct apply end-to-end. New section walks Path B for production teaching. Both paths in same lab. | ✓ |
| Path A in main lab + Path B as Free Explore | Less prominent, lower scope. | |
| Branching lab with explicit fork | Per-participant choice, more complex authoring. | |
| Path A only — mention GitOps as v1.2 reference | Lowest scope, weakest production teaching. | |

**User's choice:** Path A primary + Path B as 'production upgrade' section (Recommended)
**Notes:** Mirrors Phase 8 Hermes-cron-vs-K8s-CronJob teaching pattern. Diff is the lesson.

---

### Q7: If Path B uses helm upgrade fallback (no ArgoCD), where does the script live?

| Option | Description | Selected |
|--------|-------------|----------|
| infrastructure/scenarios/k8s/gitops/apply.sh | New gitops/ subdirectory. Self-contained. | ✓ |
| Reuse existing reference-app deploy script | Cleanest reuse, requires existing script to support patches. | |
| Inline kubectl apply after manual diff merge | Simplest, loses helm chart abstraction. | |

**User's choice:** infrastructure/scenarios/k8s/gitops/apply.sh (Recommended)
**Notes:** Self-contained, runs after PR merge, ArgoCD-optional.

---

## FLEET-02 lab mode

### Q1: How should Module 11 lab evolve in Phase 9?

| Option | Description | Selected |
|--------|-------------|----------|
| Mock primary + new live Phase 9 section | Existing Steps 1-7 untouched, add new section after Step 7. Same extend pattern as Phase 5/6/7/8. | |
| Replace mock with live entirely | Rewrite Module 11 lab as live-only. Higher production realism. | ✓ |
| Update mock fixtures + add live as Free Explore | Less prominent live walkthrough. | |
| Two parallel tracks: mock and live | Maximum coverage, doubles authoring. | |

**User's choice:** Replace mock with live entirely
**Notes:** User chose to break the extend pattern for Module 11. Mock-only walkthrough doesn't compose with live flow.

---

### Q2: Does Morgan SOUL.md or config.yaml need updates?

| Option | Description | Selected |
|--------|-------------|----------|
| Light edit for FLEET-01 awareness | 3 small additions: skill reference, NEVER rule extension, escalation policy. | ✓ |
| Full Morgan rewrite | Higher cost, may diverge from existing tests. | |
| No Morgan changes | Lowest scope, behavior won't reflect new approval-gated re-delegation. | |

**User's choice:** Light edit for FLEET-01 awareness (Recommended)
**Notes:** Identity intact, anti-loop and sequential rules unchanged.

---

### Q3: Should the new live lab include Solo Learner callouts?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — Solo Learner callouts inside live lab | Live-primary with mock-mode equivalent in callouts. Mirrors Phase 6. | ✓ |
| No — truly live-only, Udemy learners skip | Strongest realism, accessibility regression. | |
| Live primary + mock as Free Explore challenge | Mid-ground. | |

**User's choice:** Yes — Solo Learner callouts inside live lab (Recommended)
**Notes:** Live-primary with mock fallback documented inline. Udemy participants stay supported.

---

## PROD-01 K8s Agent Sandbox depth

### Q1: How deep should Sandbox content go (alpha v0.2.1 risk)?

| Option | Description | Selected |
|--------|-------------|----------|
| Exploratory PROJECTS.mdx entry only | Single project entry. Pinned install version. Honors STATE.md "exploratory only" note. | ✓ |
| Full GUIDED lab steps in Module 11 | Higher risk because alpha CRDs may break. Stronger delivery but fragile. | |
| Documentation only — no infrastructure | Lowest scope, weakest delivery. | |
| Defer entirely to v1.2 | Cleanest if alpha is too volatile. | |

**User's choice:** Exploratory PROJECTS.mdx entry only (Recommended)
**Notes:** Self-paced, mitigates alpha risk, still teachable.

---

### Q2: Where does the Sandbox content live?

| Option | Description | Selected |
|--------|-------------|----------|
| Module 11 fleet exploratory | Natural fit — fleet is the "agents at scale" module. | ✓ |
| Module 13 governance exploratory | Fits because Sandbox provides isolation as a governance primitive. | |
| New Module 11 sub-section | More prominent but adds module structure complexity. | |

**User's choice:** Module 11 fleet exploratory (Recommended)
**Notes:** Phase 9 already extends Module 11 lab and reading, so the exploratory entry stays in the same module.

---

## PROD-02 placement and scope

### Q1: Where should productionization conceptual content live?

| Option | Description | Selected |
|--------|-------------|----------|
| New Module 11 reading section | Natural fit — Module 11 is the "fleet at scale" module. | ✓ |
| Module 13 governance reading | Fits because governance + production are related. Module 13 already dense. | |
| Module 14 capstone reading | Less discoverable mid-course. | |
| New module-11-fleet exploratory entries | Less cohesive. | |

**User's choice:** New Module 11 reading section (Recommended)
**Notes:** Module 11 is where participants ask "how do I run this in production?"

---

### Q2: How deep should PROD-02 content be?

| Option | Description | Selected |
|--------|-------------|----------|
| Reference doc with config examples | ~500-800 lines structured content. Real Hermes config examples. Cross-references to Phase 6/7/8. | ✓ |
| Short overview (200-300 lines) | Faster to author, weaker as reference. | |
| Comprehensive deep-dive (1000+ lines) | Maximum value, most authoring scope. May overlap Module 13. | |

**User's choice:** Reference doc with config examples (Recommended)
**Notes:** Mirrors depth of Module 13 reference.mdx Phase 7 just shipped.

---

## Claude's Discretion

These are intentionally left to Claude during research, planning, and execution:

- Exact YAML patch generation pattern
- GitOps repo branch naming convention
- Specific Sandbox CRD release version pin
- Whether Module 11 lab uses single or split LAB.mdx file
- "Production upgrade: GitOps" section wording
- Quiz question phrasing
- Phase 9 PROJECTS.mdx exploratory beyond Sandbox
- PROD-02 reference content section structure

## Deferred Ideas

- **v1.2:** Separate triage agent, GitOps-only apply, real Sandbox lab, multi-cluster fleet, approval state machine, audit SIEM export, Morgan parallelism, incident replay, Sandbox + fleet integration
- **Out of scope for v1.1:** Advanced GitOps (multi-env promotion), Slack bidirectional ChatOps, K8s operators for agent management
