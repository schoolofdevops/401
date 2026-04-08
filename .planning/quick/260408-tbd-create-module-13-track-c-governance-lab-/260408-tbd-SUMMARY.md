---
phase: quick
plan: 260408-tbd
type: summary
status: complete
---

# Quick Task 260408-tbd: Summary

## Goal

Create a Module 13 Track C governance lab that teaches the L1→L4 spectrum using Kiran
(Kubernetes agent) and kubectl commands, and leads with the mechanical-vs-behavioral safety
split that's clearest when you look at Track C (because `kubectl delete`, `drain`, `cordon`
are NOT in Hermes DANGEROUS_PATTERNS).

## Files Changed

| File | Change |
|---|---|
| `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` | **NEW** — 1257-line Track C governance lab (17 steps: 14 guided + 3 free explore + closing + verification checklist) |
| `course-site/docs/module-13-governance/lab/LAB.mdx` | Added `:::tip` admonition at top pointing Track C learners to the dedicated lab |

## Content Shape

- **88 Kiran mentions** — consistent Track C agent identity (vs. the unified lab's "Kepler" naming inconsistency)
- **109 kubectl mentions** — kubectl-first examples throughout
- **41 track-c profile references** — concrete paths (`~/.hermes/profiles/track-c/`), no `<your-track>` placeholders
- **0 inline Track A/B variants** — one DROP TABLE reference only in the Step 17 contrast question
- **sidebar_position: 2** (after unified LAB.mdx at position 1)

## Key Teaching Decisions

1. **Lead with the split safety model (Step 5):** Instead of burying the mechanical-vs-behavioral distinction in a callout, Step 5 is structured as two sub-steps:
   - **5a**: `kubectl delete` → Kiran refuses verbally (Layer 3 SOUL.md NEVER) with NO approval gate
   - **5b**: `rm -rf /tmp/test-logs` → Hermes approval gate fires (Layer 2 DANGEROUS_PATTERNS)

   The learner sees both safety mechanisms activated within five minutes of each other, and the teaching callout names exactly which pattern is in DANGEROUS_PATTERNS and which is not.

2. **Explicit Track C threat model:** The closing and multiple callouts hammer on the fact that Track C operates with Layers 1+3 (wrapper_allowlist + SOUL.md NEVER) for its destructive commands — Layer 2 is structurally absent. This asymmetry with Track A is the most important thing a governance reviewer needs to understand.

3. **Step 16 (command_allowlist) inverted into a negative lesson:** For Track A, adding `"SQL DROP"` to command_allowlist actually loosens a gate. For Track C, adding `"kubectl delete"` does NOTHING — the step walks through three independent reasons why.

4. **Kiran, not Kepler:** The unified lab line 41 says "Kepler for Track C" but the actual `agents/track-c-kubernetes/SOUL.md` identifies as "Kiran". The dedicated Track C lab uses the canonical SOUL.md name throughout. The unified lab's "Kepler" reference is not corrected here (scope discipline — one task at a time), but it's a flag for a later sweep.

## Verification

```bash
# Docusaurus build succeeded with new file
cd course-site && npm run build
# Result: [SUCCESS] Generated static files in "build".

# Sitemap contains the new Track C lab URL
grep module-13-lab-track-c course-site/build/sitemap.xml
# Result: /module-13-governance/lab/module-13-lab-track-c

# Sidebar entry is rendered in the lab.html index page
grep 'module-13-lab-track-c' course-site/build/module-13-governance/lab.html
# Result: <a class="menu__link" ... href="/401/module-13-governance/lab/module-13-lab-track-c">

# Content shape sanity
wc -l course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx
# Result: 1257 lines

grep -c "Kiran" course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx
# Result: 88

grep -c "kubectl" course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx
# Result: 109
```

## Next Steps for the Learner

Track C path is now continuous from Module 7 through Module 13:

1. Module 7 Track C → author `my-track-c-skill.md`
2. Module 8 Track C → build `track-c` profile with Kiran identity
3. Module 10 Track C → upgrade skill to `sre-k8s-pod-health`, exercise all 6 failure modes
4. **Module 13 Track C (new)** → walk Kiran from L1 to L4 governance, read the audit trail, understand the three-layer defense model

Module 14 capstone is track-agnostic and works as-is.

## Deferred Work

- **Module 11 (Fleet):** NO split needed — already Track C-centric by design (fleet coordinator + crashloop2 scenario).
- **Module 12 (Triggers):** NO split recommended yet — 13 `track-c` mentions vs. 1 each A/B; the primary path is already Track C with scattered A/B callouts that don't break flow.
- **Modules 7 and 8 LAB.mdx "Kepler" reference:** The unified Module 13 LAB.mdx calls the Track C agent "Kepler" at line 41 (`Aria for Track A, Finley for Track B, Kepler for Track C`). This contradicts the canonical `agents/track-c-kubernetes/SOUL.md` which names the agent "Kiran". The dedicated Track C lab uses Kiran; the unified lab was NOT corrected to maintain scope discipline. Flag for later sweep.
- **Track A and B splits for Modules 7, 8, 13:** The dedicated Track C labs work; Tracks A and B still use the unified LAB.mdx files with inline branching. Full symmetry (3 dedicated labs per module) is deferred.
