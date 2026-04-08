---
phase: quick
plan: 260408-sem
type: summary
status: complete
---

# Quick Task 260408-sem: Summary

## Goal

Make Track C a linear, self-contained path through Modules 7 → 8 → 10 so a learner
who chose Track C can follow dedicated labs without inline branching, and stop
Module 10 from overwriting the agent that was built in Module 8.

## Files Changed

| File | Change |
|---|---|
| `course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx` | **NEW** — Track C-specific Module 7 lab (7 steps, K8s-only content, `sidebar_position: 2`) |
| `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` | **NEW** — Track C-specific Module 8 lab using examine-and-copy for SOUL.md and config.yaml (`sidebar_position: 2`) |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` | Step 2 rewritten to preserve the Module 8 profile — only upgrades the attached skill to the full reference `sre-k8s-pod-health`. SOUL.md and config.yaml copies moved into a "Skipped Module 8?" fallback `:::note` block. Prerequisite line updated. |
| `course-site/docs/module-07-agent-skills/lab/LAB.mdx` | Added `:::tip` admonition at top pointing Track C learners to the dedicated lab |
| `course-site/docs/module-08-tool-integration/lab/LAB.mdx` | Added `:::tip` admonition at top pointing Track C learners to the dedicated lab |

## Key Decisions

1. **Option 2 (Track C first, A/B later):** Don't split Modules 7/8 into three track-specific labs right now. Only create Track C variants. Tracks A and B continue to use the unified `LAB.mdx` files. Rationale: user is personally on Track C and wants continuity now; the full split can follow later.

2. **"Examine + Copy" philosophy for Module 8 only:** Module 7 retains its "author your own SKILL.md" flow (learning value is in understanding SKILL structure). Module 8 switches to examining the reference `agents/track-c-kubernetes/SOUL.md` and `config.yaml` and copying them. User quote: *"I don't expect people to write everything from scratch. So we can have them examine everything and have it copy over from the source."*

3. **Module 10 Step 2 preserves Module 8 work:** Previously Step 2 was a destructive "install the reference agent" that overwrote SOUL.md, config.yaml, and the attached skill. Now it's an additive "upgrade the attached skill" — only the `sre-k8s-pod-health` reference skill is copied into the existing profile. A guarded fallback `:::note` handles learners who skipped Module 8.

4. **Scope limited to `course-site/`:** Per user instruction, no changes to `modules/` source files. The `modules/module-08-tools/starter/SOUL-starter.md` is untouched.

5. **Provider default is Anthropic Claude Haiku 4.5:** Matches the existing Module 10 migration (commit 7e07a90). `claude setup-token` workflow for the `ANTHROPIC_API_KEY`.

## Verification

```bash
# Module 10 default path has no SOUL.md/config.yaml cp (fallback note is fine)
rg -n "cp agents/track-c-kubernetes/(SOUL\.md|config\.yaml)" \
   course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
# Result: lines 156-157 only (inside the :::note Skipped Module 8? fallback) ✓

# Module 8 Track C lab has the examine + copy commands in Step 3b and 4b
rg -n "cp agents/track-c-kubernetes/(SOUL\.md|config\.yaml)" \
   course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx
# Result: lines 166, 226 — intended ✓

# Both unified labs have the Track C pointer tip
rg -l "Track C learners — use the dedicated lab" \
   course-site/docs/module-07-agent-skills/lab/LAB.mdx \
   course-site/docs/module-08-tool-integration/lab/LAB.mdx
# Result: both files ✓
```

## Next Steps for the Learner

A Track C learner now follows:

1. **Module 7 Track C Lab** → author `my-track-c-skill.md`
2. **Module 8 Track C Lab** → create `~/.hermes/profiles/track-c/`, examine and copy
   `agents/track-c-kubernetes/SOUL.md` and `config.yaml`, attach their Module 7 skill,
   run their agent with `claude-haiku-4-5` via Anthropic
3. **Module 10 Track C Lab** → upgrade the attached skill to the full reference
   `sre-k8s-pod-health`, run Kiran against all 6 mock scenarios (and optionally a live
   KIND cluster)

Nothing is ever overwritten after Module 8 — the profile carries forward.

## Deferred Work

- Create `LAB-track-a-database.mdx` and `LAB-track-b-finops.mdx` for Modules 7 and 8 (symmetric split). Current Tracks A/B learners still use the unified `LAB.mdx`.
- Consider whether Modules 11/13 (Fleet and Governance) also need track-specific variants — currently they're unified.
