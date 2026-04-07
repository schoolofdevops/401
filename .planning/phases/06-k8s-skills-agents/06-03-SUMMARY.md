---
phase: 06-k8s-skills-agents
plan: "03"
subsystem: skills
tags: [kubernetes, sre, k8s, cascade, soul-md, skill-authoring, track-c, kiran, module-7, module-10]

dependency_graph:
  requires:
    - phase: "06-01"
      provides: "skills/sre-k8s-pod-health/SKILL.md (the canonical source copied into 3 destinations)"
    - phase: "06-02"
      provides: "Infrastructure scenarios used in Lab MDX references"
  provides:
    - "agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md (profile install copy)"
    - "modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md (solution copy)"
    - "modules/module-07-skills/solution/track-c-kubernetes/SKILL.md (completed K8s skill, was EC2)"
    - "Light-edited agents/track-c-kubernetes/SOUL.md and mirror (42 lines, 3 targeted changes)"
    - "Zero sre-ec2-health-check references in K8s/Kiran/Track C contexts (D-20 verified)"
    - "kube-troublesim nascent tool mention in Module 7 exploratory PROJECTS.mdx"
  affects:
    - "Phase 7 (GOV): allowlist work — SOUL.md NEVER rules already block kubectl exec/patch/edit"
    - "Phase 9 (FLEET): fleet lab references Kiran; Kiran now has a real K8s skill attached"

tech-stack:
  added: []
  patterns:
    - "Profile skill install pattern: canonical at skills/<name>/SKILL.md, copies at agents/<track>/skills/ and modules/<module>/solution/<track>/skills/"
    - "D-16 light-edit pattern: SOUL.md grows from 31 to 42 lines — 3 targeted insertions, no rewrites"
    - "Cross-domain teaching moment removal: replace rationalizations with factual skill descriptions"

key-files:
  created:
    - agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md
    - modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md
  modified:
    - agents/track-c-kubernetes/SOUL.md
    - agents/track-c-kubernetes/skills/ (sre-ec2-health-check deleted)
    - modules/module-07-skills/solution/track-c-kubernetes/SKILL.md
    - modules/module-10-agents/solution/track-c/SOUL.md
    - modules/module-10-agents/solution/track-c/skills/ (sre-ec2-health-check deleted)
    - course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx
    - modules/module-10-agents/LAB-track-c-kubernetes.md
    - course-site/docs/reading/skills-guide.mdx
    - reading/skills-guide.md
    - course-site/docs/resources/skills.mdx
    - course-site/docs/module-07-agent-skills/exploratory/PROJECTS.mdx

key-decisions:
  - "SOUL.md light-edit (D-16): 3 changes only — skill reference paragraph, kubectl exec NEVER rule, expanded Escalation Policy with 6 K8S-02 failure modes. Result: 42 lines (was 31, max 80)."
  - "command_allowlist: [] preserved in both config.yaml files (D-17 — Phase 7 territory)."
  - "skills/sre-ec2-health-check/ canonical root preserved; only profile copies deleted (D-18)."
  - "Zero sre-ec2-health-check references in K8s/Kiran/Track C contexts (D-20 verified via grep)."
  - "kube-troublesim mentioned in PROJECTS.mdx as nascent tool (1 commit, no releases, watch this space) — not a required lab dependency."
  - "LAB-track-c-kubernetes MDX admonition changed from :::info to :::tip — matches new positive framing of real K8s skill."

patterns-established:
  - "Two-file cascade pattern: whenever agents/track-c-kubernetes/SOUL.md changes, modules/module-10-agents/solution/track-c/SOUL.md must mirror it identically (verified by checksum)."
  - "Reading guide light-touch update: Track C anatomy section swapped from EC2 to K8s vocabulary, all other guide content unchanged."

requirements-completed:
  - K8S-03
  - K8S-05

duration: 15min
completed: "2026-04-07"
---

# Phase 6 Plan 03: Cascade — K8s Skill into Agent Profiles and Cascade Files Summary

**K8s skill cascaded into Kiran agent profiles (live and Module 10 solution), SOUL.md light-edited with 3 targeted changes, EC2 skill removed from K8s contexts, Module 7 Track C solution replaced, and 6 cascade files updated — zero sre-ec2-health-check references remain in K8s/Kiran/Track C scope.**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-04-07
- **Completed:** 2026-04-07
- **Tasks:** 2
- **Files modified:** 13 (7 agent/module files + 6 cascade files)

## Accomplishments

- Deleted `sre-ec2-health-check` directory from both Track C agent profiles (live profile and Module 10 solution), installed byte-identical copies of `sre-k8s-pod-health` in both
- Light-edited `agents/track-c-kubernetes/SOUL.md` with exactly 3 targeted changes per D-16: (1) skill reference paragraph added to Identity section, (2) kubectl exec/edit/patch/apply NEVER rule added to Behavior Rules, (3) Escalation Policy expanded to enumerate all 6 K8S-02 failure modes by name — file grew from 31 to 42 lines (within 40-80 bound), mirrored exactly to `modules/module-10-agents/solution/track-c/SOUL.md`
- Replaced `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` (was EC2 content) with K8s skill content — now byte-identical to canonical
- Updated 6 cascade files: LAB-track-c-kubernetes.mdx (3 ls expected outputs + cross-domain rationalization replaced), LAB-track-c-kubernetes.md (same 4 edits, blockquote format), skills-guide.mdx (Track C anatomy section heading + body updated), skills-guide.md (heading, paragraph, Phase 1 commands, canonical file reference all updated), skills.mdx (4 new K8s skill entries added before EC2 entry), PROJECTS.mdx (Project 4 kube-troublesim section added)
- D-20 verified: zero `sre-ec2-health-check` references in `agents/track-c-kubernetes/`, `modules/module-07-skills/solution/track-c-kubernetes/`, `modules/module-10-agents/solution/track-c/`, `modules/module-10-agents/LAB-track-c-kubernetes.md`, `course-site/docs/module-10-domain-agent/`, `course-site/docs/reading/skills-guide.mdx`, `reading/skills-guide.md`

## Task Commits

Each task was committed atomically:

1. **Task 1: Update Track C agent profiles (delete EC2 skill copies, install K8s skill, light-edit SOUL.md files)** - `bd8b0f8` (feat)
2. **Task 2: Cascade text updates across 6 lab/reading/resource files** - `ce98964` (feat)

**Plan metadata:** (this SUMMARY commit, below)

## Files Created/Modified

- `agents/track-c-kubernetes/skills/sre-ec2-health-check/SKILL.md` — DELETED (EC2 mismatch removed from K8s profile)
- `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md` — CREATED (byte-identical copy of canonical, new install)
- `agents/track-c-kubernetes/SOUL.md` — MODIFIED (31 → 42 lines, 3 targeted changes per D-16)
- `modules/module-10-agents/solution/track-c/skills/sre-ec2-health-check/SKILL.md` — DELETED
- `modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md` — CREATED
- `modules/module-10-agents/solution/track-c/SOUL.md` — MODIFIED (mirrors agents/track-c-kubernetes/SOUL.md exactly)
- `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` — REPLACED (EC2 → K8s, now byte-identical to canonical)
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` — MODIFIED (4 edits: 3 ls outputs + teaching moment replaced)
- `modules/module-10-agents/LAB-track-c-kubernetes.md` — MODIFIED (same 4 edits, blockquote format)
- `course-site/docs/reading/skills-guide.mdx` — MODIFIED (Track C anatomy section updated)
- `reading/skills-guide.md` — MODIFIED (heading, paragraph, Phase 1 commands, canonical file reference)
- `course-site/docs/resources/skills.mdx` — MODIFIED (4 new K8s skill entries added, EC2 preserved)
- `course-site/docs/module-07-agent-skills/exploratory/PROJECTS.mdx` — MODIFIED (Project 4 kube-troublesim section added)

## Decisions Made

- SOUL.md light-edit kept to exactly 3 changes per D-16 constraint: no rewordings of existing NEVER rules (kubectl delete, kubectl drain, kubectl cordon, resource limits), no Identity rewrite, no new Behavior Rules beyond the one kubectl exec addition
- LAB admonition type changed from `:::info` to `:::tip` for the replacement block — info was used for the "teaching moment" rationalization, tip is more appropriate for positive factual information about the skill
- `reading/skills-guide.md` Track C section also updated Phase 1 commands list from EC2 aws commands to K8s kubectl commands, since the body text now describes the K8s skill
- kube-troublesim section placed at end of PROJECTS.mdx as Project 4, matching existing Project 1-3 numbering pattern

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 6 complete: all 3 plans executed (06-01: K8s skills authored, 06-02: scenario infrastructure, 06-03: cascade)
- K8S-03 satisfied: Kiran rebuilt with proper K8s skill (sre-k8s-pod-health in profile, SOUL.md updated with 6 failure modes)
- K8S-05 satisfied: Module 7 Track C starter (unchanged — already K8s-aware) and solution (replaced with completed K8s skill)
- Phase 7 (GOV): SOUL.md NEVER rules now include kubectl exec/edit/patch/apply — these are the write-action commands the allowlist must cover
- Phase 9 (FLEET): Module 11 fleet lab references Kiran; Kiran now has a working K8s skill, making fleet workflows meaningful

## Known Stubs

None — all profile copies are byte-identical to the canonical skill (no placeholder content). The SOUL.md edits are complete factual content. The cascade file updates describe real artifacts that exist.

## Self-Check: PASSED

### Files verified on disk:

- `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md` — EXISTS
- `agents/track-c-kubernetes/skills/sre-ec2-health-check/` — DELETED (confirmed)
- `modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md` — EXISTS
- `modules/module-10-agents/solution/track-c/skills/sre-ec2-health-check/` — DELETED (confirmed)
- `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` — EXISTS (replaced)
- `.planning/phases/06-k8s-skills-agents/06-03-SUMMARY.md` — EXISTS

### Commits verified:

- `bd8b0f8` — feat(06-03): update Track C agent profiles with K8s skill and light-edited SOUL.md
- `ce98964` — feat(06-03): cascade K8s skill updates across 6 lab/reading/resource files

### Checksums (all SKILL.md copies identical):

- `3b90bc92ec27674ed093dfd6fb3260bf` — skills/sre-k8s-pod-health/SKILL.md (canonical)
- `3b90bc92ec27674ed093dfd6fb3260bf` — agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md
- `3b90bc92ec27674ed093dfd6fb3260bf` — modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md
- `3b90bc92ec27674ed093dfd6fb3260bf` — modules/module-07-skills/solution/track-c-kubernetes/SKILL.md

### SOUL.md files synchronized:

- `8b3e080e75ec1ef9e2076d00eed21ee3` — agents/track-c-kubernetes/SOUL.md (42 lines)
- `8b3e080e75ec1ef9e2076d00eed21ee3` — modules/module-10-agents/solution/track-c/SOUL.md

---
*Phase: 06-k8s-skills-agents*
*Completed: 2026-04-07*
