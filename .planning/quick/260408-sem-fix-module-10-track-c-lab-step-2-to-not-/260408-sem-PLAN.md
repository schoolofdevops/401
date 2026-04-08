---
phase: quick
plan: 260408-sem
type: execute
wave: 1
depends_on: []
files_modified:
  - course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx
  - course-site/docs/module-07-agent-skills/lab/LAB.mdx
  - course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx
  - course-site/docs/module-08-tool-integration/lab/LAB.mdx
  - course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
autonomous: false
requirements:
  - QUICK-260408-sem
must_haves:
  truths:
    - "A dedicated Module 7 Track C lab exists at course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx"
    - "A dedicated Module 8 Track C lab exists at course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx"
    - "Module 8 Track C lab has learners examine the reference SOUL.md and copy it (not write from scratch)"
    - "Module 10 Track C Step 2 no longer overwrites the Module 8 SOUL.md or config.yaml"
    - "Module 10 Track C Step 2 only upgrades the attached skill to the full reference sre-k8s-pod-health"
    - "The unified Module 7 and 8 LAB.mdx files display a prominent note pointing Track C learners to the dedicated labs"
  artifacts:
    - path: "course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx"
      provides: "Module 7 Track C-specific lab (SKILL.md authoring for pod health)"
    - path: "course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx"
      provides: "Module 8 Track C-specific lab (examine + copy SOUL.md and config.yaml, attach skill)"
    - path: "course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx"
      provides: "Module 10 Track C lab with non-destructive Step 2"
  key_links:
    - from: "Module 8 Track C Step 3 (SOUL.md)"
      to: "agents/track-c-kubernetes/SOUL.md"
      via: "examine then cp"
    - from: "Module 10 Track C Step 2"
      to: "Module 8 Track C profile (~/.hermes/profiles/track-c/)"
      via: "preservation (skill upgrade only)"
---

<objective>
Create Track C-specific labs for Modules 7 and 8 so a Track C learner follows a
linear, Track-C-only path from Module 7 onwards. Fix the Module 10 Track C Step 2
so it preserves what the learner built in Module 8. Keep Modules 7 and 8's
existing unified LAB.mdx in place for Tracks A/B with a pointer at the top
directing Track C learners to the dedicated labs.

Approach shift: use "examine + copy" for SOUL.md and config.yaml in Module 8 Track C
(user quote: "I don't expect people to write everything from scratch. So we can
have them examine everything and have it copy over from the source").

Scope guard: ONLY modify course-site/docs/ files. Do not touch modules/ source
files — user confirmed they only reference course-site/.
</objective>

<execution_context>
Direct execution by the current conversation (Opus 4.6, 1M context). Do not spawn
subagents. Content is learner-facing and requires tight quality control.
</execution_context>

<tasks>

<task type="auto">
  <name>Task 1: Create Module 7 Track C lab (new file)</name>
  <files>course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx</files>
  <action>
Create a new Track C-specific lab file that covers the same 7-step SKILL.md
authoring flow as the unified Module 7 LAB.mdx, but with only Track C content:
- Concrete track name "track-c" everywhere (not `<your-track>`)
- Kubernetes-only examples (kubectl, pods, OOMKilled, CrashLoopBackOff)
- References to the 6 mock K8s scenarios (image-pull, crashloop2, oom, liveness,
  missing-secret, port-mismatch)
- Links to the Track C starter and solution files
- Keep the "authoring" philosophy for SKILL.md (learners still write their own skill
  guided by the starter comments — Module 7's learning value is in understanding
  how skills are structured, not in copying). The "examine + copy" shift applies
  to Module 8, not Module 7.

Frontmatter: sidebar_position: 2 (after the generic LAB.mdx at position 1).
  </action>
  <done>
- New file exists at course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx
- All 7 steps from the unified lab are present with Track C-only content
- Next Steps section points to Module 8 Track C lab
  </done>
</task>

<task type="auto">
  <name>Task 2: Create Module 8 Track C lab (new file, examine + copy approach)</name>
  <files>course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx</files>
  <action>
Create a new Track C-specific Module 8 lab. Key differences from the unified LAB.mdx:

1. **Step 3 (SOUL.md)** — "Examine + Copy" workflow:
   - `cat agents/track-c-kubernetes/SOUL.md` to read the reference
   - Walk through each section (Identity, Behavior Rules, Escalation Policy) — brief explanation
   - `cp agents/track-c-kubernetes/SOUL.md ~/.hermes/profiles/track-c/SOUL.md`
   - Optional customization note (rename the agent if you want)
   - Quality gate remains: `grep -c '\[' ...` returns 0

2. **Step 4 (config.yaml)** — "Examine + Copy" workflow:
   - `cat agents/track-c-kubernetes/config.yaml` to read the reference
   - Walk through the key sections (model, approvals, wrapper_allowlist)
   - `cp agents/track-c-kubernetes/config.yaml ~/.hermes/profiles/track-c/config.yaml`
   - Provider setup: Anthropic via `claude setup-token` (primary path per Module 10 migration)
   - .env setup: `ANTHROPIC_API_KEY` in ~/.hermes/profiles/track-c/.env

3. **Step 5 (Run Agent, No Skills Yet)** — Track C-specific mock mode setup with
   HERMES_LAB_MODE, HERMES_LAB_SCENARIO, mock-kubectl wrapper. Test prompt:
   "Who are you?" — expect Kiran response.

4. **Step 6 (Attach Module 7 Skill)** — Copy their Track C skill from Module 7 into
   the skills/ subdirectory. Concrete paths throughout.

5. **Step 7 (Restart + Verify)** — kubectl-based trigger test.

6. **Step 8 (Safety Boundary)** — Track C-specific test: `rm -rf /tmp/test-dir`
   triggers Hermes DANGEROUS_PATTERNS (kubectl delete is blocked by SOUL.md NEVER
   rules, not DANGEROUS_PATTERNS).

Frontmatter: sidebar_position: 2 (after generic LAB.mdx at position 1).
Add a prominent note at the top of Step 3 explaining the philosophy shift:
"You're not authoring SOUL.md from a blank page. You're examining a production-grade
reference, understanding each section, then copying it to your profile. Module 8's
learning value is in understanding what lives in a SOUL.md, not in word-smithing it."
  </action>
  <done>
- New file exists at course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx
- Step 3 uses examine + copy (no SOUL-starter.md reference, no [placeholder] fill-in)
- Step 4 uses examine + copy for config.yaml
- Provider setup uses Anthropic via claude setup-token
- All Track C paths are concrete (track-c, not <your-track>)
- Next Steps points to Module 10 Track C lab
  </done>
</task>

<task type="auto">
  <name>Task 3: Fix Module 10 Track C Step 2 (preserve Module 8 profile)</name>
  <files>course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx</files>
  <action>
Rewrite Step 2 "Install the Reference Agent" to:
- Rename heading to "Step 2: Upgrade Your Module 8 Agent with the Full Reference Skill"
- Verify Module 8 profile exists (guard check)
- ONLY copy the reference sre-k8s-pod-health skill (no SOUL.md or config.yaml copy)
- Soften the Anthropic API key block: "if you didn't add this in Module 8..."
- Update verification block to expect existing SOUL.md + config.yaml from Module 8
- Add a `:::note Skipped Module 8?` fallback that installs the reference profile

Also update line 12 prerequisite to point to Module 8 Track C lab.
  </action>
  <done>
- Step 2 no longer copies SOUL.md or config.yaml in the default path
- Step 2 verifies Module 8 profile exists before proceeding
- Fallback :::note block is the only place the reference SOUL.md/config.yaml are copied
- rg "cp agents/track-c-kubernetes/(SOUL\.md|config\.yaml)" shows matches only inside the fallback block
  </done>
</task>

<task type="auto">
  <name>Task 4: Add Track C pointer notes to unified LAB.mdx files</name>
  <files>course-site/docs/module-07-agent-skills/lab/LAB.mdx, course-site/docs/module-08-tool-integration/lab/LAB.mdx</files>
  <action>
At the top of each unified LAB.mdx (right after the H1 or duration line, before
the first `## Prerequisites` section), add a Docusaurus :::tip admonition:

```
:::tip Track C learners — use the dedicated lab
There's a Track C-specific version of this lab at [Lab — Track C: Kubernetes](./LAB-track-c-kubernetes.mdx).
It has concrete commands, no placeholders, and a linear Track C path. Use it instead of this unified version.
:::
```
  </action>
  <done>
- Both LAB.mdx files have the admonition near the top
- Admonition links render as valid Docusaurus relative paths
  </done>
</task>

<task type="auto">
  <name>Task 5: Write SUMMARY.md and update STATE.md</name>
  <files>.planning/quick/260408-sem-fix-module-10-track-c-lab-step-2-to-not-/260408-sem-SUMMARY.md, .planning/STATE.md</files>
  <action>
Write a concise SUMMARY.md covering files changed, key decisions, and verification
results. Update STATE.md's Quick Tasks Completed table with a new row for 260408-sem.
  </action>
  <done>
- SUMMARY.md exists with files changed and key decisions
- STATE.md has a new row in the Quick Tasks Completed table
  </done>
</task>

</tasks>

<verification>
- Docusaurus build succeeds for course-site/ (optional manual check)
- rg verification commands from each task pass
- Module 10 Track C Step 2 has no default-path cp of SOUL.md or config.yaml
- Module 8 Track C lab exists and uses examine + copy for SOUL.md
- Module 7 Track C lab exists with Track C-only content
</verification>

<success_criteria>
- Track C learner can follow a linear path: Module 7 Track C lab → Module 8 Track C lab → Module 10 Track C lab
- No SOUL.md or config.yaml is ever overwritten once built in Module 8
- Module 7/8 unified LAB.mdx files still work for Tracks A/B with a pointer for Track C
- All changes are in course-site/docs/ only (modules/ untouched)
</success_criteria>
