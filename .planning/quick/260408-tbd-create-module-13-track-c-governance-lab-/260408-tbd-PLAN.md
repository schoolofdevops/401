---
phase: quick
plan: 260408-tbd
type: execute
wave: 1
depends_on: []
files_modified:
  - course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx
  - course-site/docs/module-13-governance/lab/LAB.mdx
autonomous: false
requirements:
  - QUICK-260408-tbd
must_haves:
  truths:
    - "A dedicated Module 13 Track C lab exists at course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx"
    - "The Track C lab leads with kubectl examples and uses track-c profile throughout"
    - "The Track C lab emphasizes the SOUL.md-NEVER vs DANGEROUS_PATTERNS split as the core teaching moment (because kubectl delete / drain / cordon are NOT in DANGEROUS_PATTERNS)"
    - "Steps 1-14 guided phase + Steps 15-17 free explore phase, mirroring the unified lab structure"
    - "All L1, L2, L3, L4 governance walks are present with Track C-specific apply/diff commands"
    - "The unified LAB.mdx has a :::tip admonition pointing Track C learners to the dedicated lab"
  artifacts:
    - path: "course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx"
      provides: "Module 13 Track C-specific governance lab"
---

<objective>
Create a Track C-specific Module 13 governance lab that:
1. Uses track-c profile and kubectl examples throughout (no inline Track A/B branching)
2. Leads with the mechanical-vs-behavioral safety distinction (Layer 2 DANGEROUS_PATTERNS does NOT catch kubectl delete/drain/cordon — Layer 3 SOUL.md NEVER rules do)
3. Walks L1 → L2 → L3 → L4 using the existing governance/ fragments (governance-L1.yaml, governance-L2.yaml, governance-L3.yaml, governance-L4-track-c.yaml)
4. Shows the three-layer defense model from a Track C perspective: wrapper_allowlist.kubectl (Layer 1) + DANGEROUS_PATTERNS (Layer 2, mostly not Track C's concern) + SOUL.md NEVER rules (Layer 3, LOAD-BEARING for Track C)
5. Uses Kiran as the agent name (canonical Track C identity from agents/track-c-kubernetes/SOUL.md)

Also add a :::tip admonition to the unified LAB.mdx pointing Track C learners to the dedicated lab.

Scope guard: ONLY course-site/ files.
</objective>

<execution_context>
Direct execution by the current conversation (Opus 4.6, 1M context). Do not spawn subagents.
</execution_context>

<tasks>

<task type="auto">
  <name>Task 1: Create Module 13 Track C governance lab</name>
  <files>course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx</files>
  <action>
Create a new file that mirrors the structure of the unified Module 13 LAB.mdx but is entirely Track C-focused:

- frontmatter: id: module-13-lab-track-c, sidebar_position: 2, sidebar_label: "Lab — Track C: Kubernetes"
- Prerequisite: Module 10 Track C complete (track-c profile with Kiran + sre-k8s-pod-health)
- Agent name throughout: Kiran
- All `hermes -p track-a` → `hermes -p track-c`
- Config path: `~/.hermes/profiles/track-c/config.yaml`
- Backup step: back up track-c config, not track-a
- Step 1: Prerequisites (verify Kiran), back up config.yaml
- Step 2: View governance files — governance-L1.yaml, L2, L3, L4-track-c.yaml (relative paths, no `course/` prefix)
- Step 3: Apply L1 (no terminal) — test with "List all pods in CrashLoopBackOff state in the app namespace" → agent cannot execute
- Step 4: Diff L1→L2 — show wrapper_allowlist.kubectl baseline (get pods, describe pod, logs, etc.)
- Step 5: Apply L2 — CRITICAL STEP, lead with the split:
  - Ask Kiran to "delete pod api-deployment-def456" → agent REFUSES at Layer 3 (SOUL.md NEVER) — no approval gate
  - Then ask Kiran to "clean up /tmp/test-logs recursively" → approval gate FIRES (rm -r in DANGEROUS_PATTERNS) — user types 'd' to deny
  - Teaching callout: Track C's danger commands are ONLY protected by Layer 1 (wrapper_allowlist) + Layer 3 (SOUL.md) — Layer 2 (DANGEROUS_PATTERNS) only catches shell-level destructive commands, not kubectl-level mutations
- Step 6: Diff L2→L3 — wrapper_allowlist.kubectl additions (rollout history/status/diff/explain), approvals.mode manual→smart
- Step 7: Apply L3 — smart approval reduces friction for false positives
- Step 8: Read session audit trail (SQL queries against ~/.hermes/state.db) — Track C-specific queries (look for kubectl tool calls, GOVERNANCE REJECTED messages)
- Step 9: Apply L4 (Track C) — export HERMES_LAB_TRACK=track-c, view governance-L4-track-c.yaml, diff L3→L4-track-c showing `apply` and `rollout undo` additions
- Step 10: Attempt a blocked command at L4 — `kubectl delete pod api-deployment-def456` — expect GOVERNANCE REJECTED banner with L4 (track-c) tags
- Step 11: Attempt an allowed command at L4 — `kubectl get pods` or `kubectl apply -f infrastructure/scenarios/k8s/clean.yaml` → passthrough with MOCK MODE banner
- Step 12: Query audit trail for the rejection event (sqlite3 queries)
- Step 13: Review DANGEROUS_PATTERNS for Track C relevance — explicitly name the Track C patterns (rm -r, systemctl stop/disable, kill -9 -1) and note what's NOT in there (kubectl delete/drain/cordon)
- Step 14: Restore agent to working config (L3 recommended)
- Step 15 (Free Explore): Write promotion criteria for Kiran L2 → L3
- Step 16 (Free Explore): Add a command to command_allowlist — teach the limitation (command_allowlist cannot protect against kubectl delete because it's not in DANGEROUS_PATTERNS)
- Step 17 (Free Explore): Compare Track C L4 governance to another track — what's different about the defense model when the dangerous commands are NOT mechanically gated
- Closing: three-layer defense model summary from Track C perspective, audit trail observation
- Verification Checklist: Track C variant of the 8-item check

Teaching emphasis (this is the unique value of the Track C lab): the mechanical-vs-behavioral safety distinction is BEST taught from Track C because Track C's dangerous commands (kubectl delete) are NOT in DANGEROUS_PATTERNS. The unified lab buries this in a callout; the Track C lab leads with it.

Keep the lab comprehensive (~900-1000 lines). Do not skimp on teaching callouts.
  </action>
  <done>
- New file at course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx
- sidebar_position: 2 in frontmatter
- All 17 steps present (14 guided + 3 free explore)
- Closing + Verification Checklist present
- Uses Kiran, track-c profile, kubectl examples throughout
- No inline Track A/B variants (those live in the unified lab)
  </done>
</task>

<task type="auto">
  <name>Task 2: Add Track C pointer tip to unified Module 13 LAB.mdx</name>
  <files>course-site/docs/module-13-governance/lab/LAB.mdx</files>
  <action>
Add a Docusaurus :::tip admonition at the top of the unified Module 13 LAB.mdx (right after the opening :::tip "Governance is not about trust" block), matching the pattern used in Modules 7 and 8:

```
:::tip Track C learners — use the dedicated lab
There's a Track C-specific version of this lab at [Lab — Track C: Kubernetes](./LAB-track-c-kubernetes.mdx).
It leads with the kubectl delete / SOUL.md NEVER distinction (instead of Track A's DROP TABLE example)
and walks L1 → L4 using concrete track-c commands. Use it instead of this unified version.
:::
```
  </action>
  <done>
- The unified LAB.mdx has the Track C tip near the top
- The link is a valid Docusaurus relative path
  </done>
</task>

<task type="auto">
  <name>Task 3: Write SUMMARY.md and update STATE.md</name>
  <files>.planning/quick/260408-tbd-create-module-13-track-c-governance-lab-/260408-tbd-SUMMARY.md, .planning/STATE.md</files>
  <action>
Write a concise SUMMARY.md. Update STATE.md's Quick Tasks Completed table with a new row for 260408-tbd. Update the "Last session" / "Stopped at" lines.
  </action>
</task>

</tasks>

<verification>
- rg "hermes -p track-c" in the new file returns >5 matches
- rg "kubectl" in the new file returns >20 matches
- rg "DROP TABLE" in the new file returns 0 matches (or only in the closing callout as contrast)
- rg "Kiran" in the new file returns >3 matches
- Docusaurus build should still succeed (optional manual check)
</verification>

<success_criteria>
- A Track C learner can follow Module 13 end-to-end in one document without seeing Track A/B inline variants
- The three-layer defense model is taught from the Track C angle where it's clearest
- Kiran is the agent identity throughout (not Kepler, not generic)
</success_criteria>
