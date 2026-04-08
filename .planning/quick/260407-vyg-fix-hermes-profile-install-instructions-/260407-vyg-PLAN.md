---
phase: 260407-vyg-fix-hermes-profile-install-instructions
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
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
autonomous: true
requirements:
  - UAT-FIX-PROFILE-INSTALL

must_haves:
  truths:
    - "Every install instruction in participant-facing content uses `hermes profile create` followed by explicit cp commands for config.yaml, SOUL.md, and the agent's specific skills directory"
    - "Zero occurrences of the broken `cp -r course/agents/<agent>/ ~/.hermes/profiles/<name>/` one-liner remain in production content (agent configs, Module 10 labs, Module 11 lab, reading guides, Module 8 mirror configs)"
    - "Each agent's install snippet references the correct skill directory name (track-a → dba-rds-slow-query, track-b → devops-deployment-safety-check, track-c → sre-k8s-pod-health, fleet → no skills)"
    - "Course-site (mdx) and modules/ (md) mirrors stay in sync — same fix applied to both copies"
  artifacts:
    - path: "agents/track-c-kubernetes/config.yaml"
      provides: "Updated install comment using 4-step sequence"
      contains: "hermes profile create track-c"
    - path: "modules/module-11-fleet/LAB.md"
      provides: "Step 2 install instructions for fleet + track-c using profile create"
      contains: "hermes profile create fleet"
    - path: "reading/profile-guide.md"
      provides: "The Install Pattern section teaches the correct 4-step sequence"
      contains: "hermes profile create"
  key_links:
    - from: "agent config.yaml install comments"
      to: "Module 10 LAB step 2 install commands"
      via: "matching command sequence"
      pattern: "hermes profile create track-[abc]"
    - from: "modules/ md files"
      to: "course-site/docs/ mdx mirrors"
      via: "identical install snippets in both locations"
      pattern: "hermes profile create"
---

<objective>
Fix the broken `cp -r` Hermes profile install instructions across all agent configs, lab files, and reading guides. The current one-liner (`cp -r course/agents/<agent>/ ~/.hermes/profiles/<name>/`) fails at runtime — `hermes -p <name> chat` reports "Profile '<name>' does not exist" because Hermes requires `hermes profile create <name>` to register the profile before files are copied in.

Purpose: Unblock live UAT and prevent every Module 10/11 lab participant from hitting the same install failure.
Output: All participant-facing install instructions replaced with the correct 4-step sequence (hermes profile create + cp config.yaml + cp SOUL.md + cp -r skills/<skill-name>). Fleet coordinator gets a 3-step sequence (no skills directory).
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/STATE.md
@CLAUDE.md

# Background — the broken pattern came from Phase 6 install conventions and propagated to every Module 10/11 mirror.
# Live UAT (April 2026) caught it because `hermes -p track-c chat` returns "Profile 'track-c' does not exist".
# Root cause: `cp -r` creates the profile directory on disk but does NOT register it in Hermes's profile index;
# `hermes profile create <name>` is the registration step. After registration, individual file copies populate it.

<canonical-replacement>
The correct install sequence per agent — use these exact commands.

Track A (database — Aria):
```bash
hermes profile create track-a
cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/
```

Track B (finops — Finley):
```bash
hermes profile create track-b
cp agents/track-b-finops/config.yaml ~/.hermes/profiles/track-b/
cp agents/track-b-finops/SOUL.md ~/.hermes/profiles/track-b/
cp -r agents/track-b-finops/skills/devops-deployment-safety-check ~/.hermes/profiles/track-b/skills/
```

Track C (kubernetes — Kiran):
```bash
hermes profile create track-c
cp agents/track-c-kubernetes/config.yaml ~/.hermes/profiles/track-c/
cp agents/track-c-kubernetes/SOUL.md ~/.hermes/profiles/track-c/
cp -r agents/track-c-kubernetes/skills/sre-k8s-pod-health ~/.hermes/profiles/track-c/skills/
```

Fleet (coordinator — Morgan, no skills directory):
```bash
hermes profile create fleet
cp agents/fleet-coordinator/config.yaml ~/.hermes/profiles/fleet/
cp agents/fleet-coordinator/SOUL.md ~/.hermes/profiles/fleet/
```

Notes:
- The skill directory names were verified by `ls agents/<agent>/skills/`:
  - track-a-database/skills/ → dba-rds-slow-query (only)
  - track-b-finops/skills/ → devops-deployment-safety-check (only)
  - track-c-kubernetes/skills/ → sre-k8s-pod-health (only)
  - fleet-coordinator/ → no skills/ directory at all
- `hermes profile create <name>` creates `~/.hermes/profiles/<name>/skills/` automatically, so the
  `cp -r ... skills/<skill-name>` lands inside an existing directory.
- Use repo-relative paths (`agents/...`) NOT `course/agents/...`. The course repo IS named `course/`
  in some download contexts but the install instructions assume the user's CWD is the repo root.
  The modules/module-11-fleet/LAB.md already uses `agents/...` — keep that style consistent everywhere.
</canonical-replacement>

<file-inventory>
Live participant-facing files that MUST be updated.

Agent source-of-truth configs (4):
- agents/track-a-database/config.yaml — line 3 `# Install:` comment
- agents/track-b-finops/config.yaml — line 3 `# Install:` comment
- agents/track-c-kubernetes/config.yaml — line 3 `# Install:` comment
- agents/fleet-coordinator/config.yaml — line 3 `# Install:` comment

Module 10 lab files — modules mirror (3):
- modules/module-10-agents/LAB-track-a-database.md — line ~55 (Step 2 code block)
- modules/module-10-agents/LAB-track-b-finops.md — line ~49 (Step 2 code block)
- modules/module-10-agents/LAB-track-c-kubernetes.md — line ~92 (Step 2 code block)

Module 10 lab files — course-site mdx mirror (3):
- course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx — line ~66
- course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx — line ~57
- course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx — line ~103

Module 10 solution config mirrors (3):
- modules/module-10-agents/solution/track-a/config.yaml — line 3 `# Install:` comment
- modules/module-10-agents/solution/track-b/config.yaml — line 3 `# Install:` comment
- modules/module-10-agents/solution/track-c/config.yaml — line 3 `# Install:` comment

Module 11 fleet lab (2 — md + mdx, three install snippets each):
- modules/module-11-fleet/LAB.md — Step 2 install for fleet (line ~113), repeat fleet copy after toolset check (~128), and track-c copy (~135)
- course-site/docs/module-11-fleet/lab/LAB.mdx — same three install snippets at lines ~126, ~141, ~148

Reading guides — Install Pattern teaching content (3):
- reading/profile-guide.md — line ~57 (inline mention), line ~290 (### The Install Pattern code block), line ~421 (Aria walkthrough Install and launch)
- course-site/docs/reading/profile-guide.mdx — mirrors of lines 39, 53, 295
- course-site/docs/module-10-domain-agent/reading/reference.mdx — lines 36 and 42

Module 8 solution config mirrors (2 — Module 8 lab teaches the share-back direction with a placeholder, those `<your-track>` references stay as-is; only the solution config comments need fixing):
- modules/module-08-tools/solution/config-solution.yaml — line 4 `# Install:` comment
- course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml — line 4 `# Install:` comment

Files explicitly NOT in scope (planning/historical):
- .planning/phases/v11-live-UAT.md (UAT log — historical record of the bug)
- .planning/phases/06-k8s-skills-agents/06-RESEARCH.md (research history)
- .planning/phases/09-multi-agent-workflows-production/09-02-PLAN.md (executed plan)
- modules/module-08-tools/LAB.md and mdx mirror — `cp -r ~/.hermes/profiles/<your-track>/ course/agents/<your-track>/` is the SHARE-BACK direction (agent → repo), which is fine. The brief reverse mention `cp -r course/agents/<your-track>/ ~/.hermes/profiles/<your-track>/` uses generic `<your-track>` placeholder for the conceptual lesson; out of scope for this fix because it does not name a specific agent.
</file-inventory>

<verification-strategy>
After all edits, run a single grep to confirm zero remaining occurrences of the broken pattern in production paths:
```bash
rg 'cp -r .*agents/(track-[abc]|fleet)[^/]*/ ~/.hermes/profiles' \
  agents/ modules/ course-site/ reading/ \
  -n
```
Expected: zero matches.

Then spot-check that the new sequence is present in at least one file per group:
```bash
rg 'hermes profile create track-c' agents/track-c-kubernetes/config.yaml modules/module-10-agents/LAB-track-c-kubernetes.md course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx -n
```
Expected: one match per file.
</verification-strategy>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Fix install instructions in agent source-of-truth configs and Module 10/11 lab files</name>
  <files>
    agents/track-a-database/config.yaml,
    agents/track-b-finops/config.yaml,
    agents/track-c-kubernetes/config.yaml,
    agents/fleet-coordinator/config.yaml,
    modules/module-10-agents/LAB-track-a-database.md,
    modules/module-10-agents/LAB-track-b-finops.md,
    modules/module-10-agents/LAB-track-c-kubernetes.md,
    modules/module-10-agents/solution/track-a/config.yaml,
    modules/module-10-agents/solution/track-b/config.yaml,
    modules/module-10-agents/solution/track-c/config.yaml,
    course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx,
    course-site/docs/module-10-domain-agent/lab/LAB-track-b-finops.mdx,
    course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx,
    modules/module-11-fleet/LAB.md,
    course-site/docs/module-11-fleet/lab/LAB.mdx
  </files>
  <action>
Replace the broken `cp -r course/agents/<agent>/ ~/.hermes/profiles/<name>/` install instruction everywhere it appears in the listed files. Use the EXACT replacement sequences from the `<canonical-replacement>` block in this plan's context — do not paraphrase, do not invent variant commands, do not change skill directory names.

For agent config.yaml `# Install:` comments (single-line comment header), replace the one-liner with a multi-line comment block. Example for agents/track-c-kubernetes/config.yaml:

OLD (line 3):
```
# Install: cp -r course/agents/track-c-kubernetes/ ~/.hermes/profiles/track-c/
```

NEW (replace line 3 with these 5 comment lines):
```
# Install:
#   hermes profile create track-c
#   cp agents/track-c-kubernetes/config.yaml ~/.hermes/profiles/track-c/
#   cp agents/track-c-kubernetes/SOUL.md ~/.hermes/profiles/track-c/
#   cp -r agents/track-c-kubernetes/skills/sre-k8s-pod-health ~/.hermes/profiles/track-c/skills/
```

Apply the same multi-line comment treatment to:
- agents/track-a-database/config.yaml (use track-a sequence)
- agents/track-b-finops/config.yaml (use track-b sequence with skill devops-deployment-safety-check)
- agents/fleet-coordinator/config.yaml (use fleet 3-step sequence — NO skills line)
- modules/module-10-agents/solution/track-a/config.yaml
- modules/module-10-agents/solution/track-b/config.yaml
- modules/module-10-agents/solution/track-c/config.yaml

For Module 10 lab files (md and mdx), find the Step 2 bash code block containing `cp -r course/agents/<agent>/ ~/.hermes/profiles/<name>/` and replace ONLY that one line with the 4-line replacement (hermes profile create + 3 cp commands). Preserve the surrounding `# Verify the profile structure` and `ls ~/.hermes/profiles/...` lines that follow — those are still useful sanity checks. The expected `Expected: SOUL.md  config.yaml  skills/` line remains valid for tracks A/B/C; for fleet (Module 11) the expected output should be `SOUL.md  config.yaml` (no skills/).

For modules/module-11-fleet/LAB.md (and the mdx mirror at course-site/docs/module-11-fleet/lab/LAB.mdx), there are THREE install commands to fix:
1. First fleet install (line ~113 in md, ~126 in mdx): replace with the fleet 4-step sequence (no skills).
2. Second fleet install after the toolset re-check (line ~128 / ~141): same fleet sequence. NOTE — keep the second occurrence intact in spirit (it is teaching "re-copy to pick up the Phase 9 fix"); replace it with the same 4-step sequence so re-running the install still works. The instructional message above the block ("Copy again to pick up the Phase 9 fix") still reads correctly because `hermes profile create` is idempotent — Hermes will report the profile already exists and continue. Add a brief inline note: `# Re-running 'hermes profile create fleet' is safe — it is idempotent.`
3. Track-c install (line ~135 / ~148): replace with the track-c 4-step sequence.

Critical correctness rules — verify each before saving:
- track-a → skill `dba-rds-slow-query` (NOT sre-dba-rds-slow-query, NOT rds-slow-query)
- track-b → skill `devops-deployment-safety-check` (NOT sre-ec2-health-check — that name was a hint in the planning brief but the actual on-disk skill in agents/track-b-finops/skills/ is devops-deployment-safety-check)
- track-c → skill `sre-k8s-pod-health`
- fleet → NO skills line (fleet-coordinator has no skills/ directory; do not copy a non-existent path)
- All paths use `agents/...` NOT `course/agents/...` (modules/module-11-fleet/LAB.md already uses this style; match it)
- Profile names: track-a, track-b, track-c, fleet (NOT track-a-database, track-b-finops, etc.)

Do NOT modify any file outside the <files> list above. Do NOT modify .planning/ historical records.
  </action>
  <verify>
    <automated>cd /Users/gshah/work/agentic/devops/course && rg 'cp -r .*agents/(track-[abc]|fleet)[^/]*/ ~/\.hermes/profiles' agents/ modules/module-10-agents/ modules/module-11-fleet/ course-site/docs/module-10-domain-agent/ course-site/docs/module-11-fleet/ -n; echo "EXPECT_EXIT_NONZERO_OR_ZERO_MATCHES"; rg -c 'hermes profile create track-c' agents/track-c-kubernetes/config.yaml modules/module-10-agents/LAB-track-c-kubernetes.md course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx; rg -c 'hermes profile create fleet' modules/module-11-fleet/LAB.md course-site/docs/module-11-fleet/lab/LAB.mdx agents/fleet-coordinator/config.yaml</automated>
  </verify>
  <done>
- Zero matches for the broken `cp -r .../agents/<agent>/ ~/.hermes/profiles/...` pattern in agents/, modules/module-10-agents/, modules/module-11-fleet/, course-site/docs/module-10-domain-agent/, course-site/docs/module-11-fleet/.
- `hermes profile create track-c` appears at least once in each of the three Track C files (agent config, modules lab, course-site mdx lab).
- `hermes profile create fleet` appears at least twice in modules/module-11-fleet/LAB.md and at least twice in course-site mdx mirror (first install + re-copy step), and at least once in agents/fleet-coordinator/config.yaml.
- track-b install snippets reference `devops-deployment-safety-check`, NOT `sre-ec2-health-check`.
- track-a install snippets reference `dba-rds-slow-query`.
- Fleet install snippets do NOT contain a `skills/` cp line.
- All install commands use `agents/...` repo-relative paths, not `course/agents/...`.
  </done>
</task>

<task type="auto">
  <name>Task 2: Fix install instructions in reading guides and Module 8 solution mirrors</name>
  <files>
    reading/profile-guide.md,
    course-site/docs/reading/profile-guide.mdx,
    course-site/docs/module-10-domain-agent/reading/reference.mdx,
    modules/module-08-tools/solution/config-solution.yaml,
    course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml
  </files>
  <action>
Replace the remaining broken `cp -r course/agents/<agent>/ ~/.hermes/profiles/<name>/` references in conceptual reading content and Module 8 solution config mirrors. Use the same canonical replacements from the plan context.

For reading/profile-guide.md:

1. Line ~57 (inline narrative sentence in the four-points list): the current sentence reads
   `Profile-based agents transfer across environments: Install a profile with cp -r course/agents/track-a-database/ ~/.hermes/profiles/track-a/ and run immediately.`
   Replace with:
   `Profile-based agents transfer across environments: Run hermes profile create track-a, copy config.yaml, SOUL.md, and the skills directory into ~/.hermes/profiles/track-a/, then run immediately.`
   Keep the rest of the sentence ("No build step, no environment-specific compilation.") intact.

2. Line ~290 (### The Install Pattern code block): replace the code block contents with the full track-a 4-step sequence followed by the existing launch lines:
   ```bash
   # Register the profile, then copy the agent files in
   hermes profile create track-a
   cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
   cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
   cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/

   # Launch the agent
   hermes -p track-a chat

   # Or specify a model override
   hermes -p track-a --model anthropic/claude-3-5-sonnet-20241022 chat
   ```
   Update the prose after the code block — the existing line "No build step. No restart required. Hermes discovers profiles by scanning ~/.hermes/profiles/ for directories containing config.yaml. The profile is immediately available after the cp." needs a small correction. Replace it with: "No build step. No restart required. `hermes profile create` registers the profile in Hermes's index and creates the directory; the `cp` commands populate it with the agent files. The profile is immediately available after the copies finish."

3. Line ~421 (Aria walkthrough "Install and launch" code block): replace with the track-a 4-step sequence followed by `hermes -p track-a chat`.

For course-site/docs/reading/profile-guide.mdx — apply the SAME three changes at the mirror line numbers (lines ~39, ~53, ~295). The mdx content matches the md content.

For course-site/docs/module-10-domain-agent/reading/reference.mdx:
- Line ~36 (inline narrative): same sentence-level fix as reading/profile-guide.md line 57 — rewrite to mention `hermes profile create` + per-file copies, no inline `cp -r` one-liner.
- Line ~42 (code block in walkthrough): replace with the track-a 4-step sequence.

For modules/module-08-tools/solution/config-solution.yaml and course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml:
- Line 4 has `# Install: cp -r course/agents/track-a-database/ ~/.hermes/profiles/track-a/`
- Replace with the same multi-line comment block used in Task 1 for track-a:
  ```
  # Install:
  #   hermes profile create track-a
  #   cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
  #   cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
  #   cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/
  ```

Out of scope (do not edit):
- modules/module-08-tools/LAB.md and course-site/docs/module-08-tool-integration/lab/LAB.mdx — these contain `cp -r ~/.hermes/profiles/<your-track>/ course/agents/<your-track>/` (share-back direction, agent → repo) and a brief reverse mention with the generic `<your-track>` placeholder. Both are conceptual idiom teaching, not concrete install instructions, and use placeholders rather than real agent names. Leave them alone in this task.
- All .planning/ files (historical records).
  </action>
  <verify>
    <automated>cd /Users/gshah/work/agentic/devops/course && rg 'cp -r course/agents/(track-[abc]|fleet)' reading/ course-site/docs/reading/ course-site/docs/module-10-domain-agent/reading/ modules/module-08-tools/solution/ course-site/docs/module-08-tool-integration/lab/solution/ -n; echo "EXPECT_ZERO_MATCHES_ABOVE"; rg -c 'hermes profile create track-a' reading/profile-guide.md course-site/docs/reading/profile-guide.mdx course-site/docs/module-10-domain-agent/reading/reference.mdx modules/module-08-tools/solution/config-solution.yaml course-site/docs/module-08-tool-integration/lab/solution/config-solution.yaml</automated>
  </verify>
  <done>
- Zero matches for `cp -r course/agents/(track-[abc]|fleet)` in reading/, course-site/docs/reading/, course-site/docs/module-10-domain-agent/reading/, modules/module-08-tools/solution/, course-site/docs/module-08-tool-integration/lab/solution/.
- `hermes profile create track-a` appears at least once in each of the five files listed in the verify command (reading/profile-guide.md may have it more than once due to multiple Install Pattern code blocks).
- The narrative inline sentences in the reading guides no longer contain a `cp -r` one-liner; they describe the registration step verbally.
- No edits to modules/module-08-tools/LAB.md, course-site/docs/module-08-tool-integration/lab/LAB.mdx, or any .planning/ files.
  </done>
</task>

</tasks>

<verification>
Phase-level final check after both tasks complete — run a comprehensive grep across all production directories to confirm zero broken patterns remain:

```bash
cd /Users/gshah/work/agentic/devops/course
rg 'cp -r .*agents/(track-[abc]|fleet)[^/]*/ ~/\.hermes/profiles' \
  agents/ modules/ course-site/docs/ reading/ -n
```
Expected: zero matches (or only matches inside `.planning/` paths, which are excluded above).

Then sanity-check the new pattern shows up in every directory group:
```bash
rg -l 'hermes profile create' agents/ modules/module-10-agents/ modules/module-11-fleet/ modules/module-08-tools/solution/ course-site/docs/ reading/
```
Expected file groups represented: agents/ (4 configs), modules/module-10-agents/ (6 — 3 lab + 3 solution), modules/module-11-fleet/ (1), modules/module-08-tools/solution/ (1), course-site/docs/ (multiple), reading/ (1).

Manual cross-check: open `modules/module-11-fleet/LAB.md` Step 2 and confirm the install sequence reads in this order:
1. `hermes profile create fleet` then 2 cp commands (no skills)
2. (toolset verify block — unchanged)
3. Re-copy block — same fleet 4-step sequence with idempotency note
4. Track-c install block with `hermes profile create track-c` + 3 cp commands
</verification>

<success_criteria>
- Live UAT blocker resolved: `hermes -p track-c chat` (and -p track-a, -p track-b, -p fleet) succeeds when participants follow the new install instructions.
- Zero broken `cp -r` one-liners remain in production content (agent configs, Module 10 labs + solutions, Module 11 fleet lab, reading guides, Module 8 solution config mirrors).
- Both modules/ md and course-site/docs/ mdx mirrors stay in sync — every fix applied to a md file is mirrored in its mdx counterpart and vice versa.
- Each agent's install snippet uses its correct on-disk skill name (dba-rds-slow-query, devops-deployment-safety-check, sre-k8s-pod-health) and fleet has no skills line.
- All install paths use `agents/...` not `course/agents/...`.
- Planning/historical files (.planning/**, including v11-live-UAT.md, 06-RESEARCH.md, 09-02-PLAN.md) are NOT modified.
</success_criteria>

<output>
After completion, create `.planning/quick/260407-vyg-fix-hermes-profile-install-instructions-/260407-vyg-SUMMARY.md` with:
- Files modified count and list (grouped by Task 1 / Task 2)
- Verification grep output showing zero broken patterns remain
- Note any files that were intentionally left as-is and why (Module 8 LAB.md placeholders, .planning/ historical records)
- Suggested follow-up: roll the same fix into any future agent config the course adds, and update any onboarding scripts that templatize the install command
</output>
