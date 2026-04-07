# Phase 6: K8s Skills & Agents - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Build real, working Kubernetes diagnostic skills and rebuild the Track C agent (Kiran) so it actually performs Kubernetes work — eliminating the EC2 skill mismatch throughout the course. Phase 6 ships:

1. One full-depth primary K8s diagnostic skill (`sre-k8s-pod-health`) that covers all 6 K8S-02 failure modes via decision branches
2. Three starter-scaffold K8s skills (`sre-k8s-node-health`, `sre-k8s-resource-quota`, `sre-k8s-rollback-investigator`) for participant extension in Module 7 lab
3. Six baked Kubernetes manifests (one per failure mode) under `infrastructure/scenarios/k8s/` that produce the broken-pod scenarios on a live KIND cluster
4. Captured-from-live mock JSON parity files in `infrastructure/mock-data/kubernetes/` for the 6 new scenarios
5. Lightly updated Track C agent profile (Kiran SOUL.md) attaching the new skill and aligning NEVER rules
6. Cascade update of every cross-module reference to `sre-ec2-health-check` in K8s contexts (Module 7, 10, 11, agent profiles, lab MDX text)

Phase 6 does NOT touch Module 1-5, governance allowlists (Phase 7), agent triggers (Phase 8), or multi-agent fleet workflows (Phase 9).

</domain>

<decisions>
## Implementation Decisions

### Skill Architecture
- **D-01:** Skill structure is **1 primary + 3 addons**. Primary = `sre-k8s-pod-health` (full depth). Addons = `sre-k8s-node-health`, `sre-k8s-resource-quota`, `sre-k8s-rollback-investigator` (starter scaffolds).
- **D-02:** Primary skill name is `sre-k8s-pod-health` — mirrors existing `sre-` naming convention used by `sre-ec2-health-check`. Slot-in replacement minimizes cross-module text drift.
- **D-03:** Canonical source for all 4 K8s skills lives at `skills/` at repo root. The Track C agent profile (`agents/track-c-kubernetes/skills/`) gets a copy of the primary skill for self-contained install. Module 7 starter directory references the canonical root for the addon scaffolds.
- **D-04:** Primary skill internal structure mirrors `sre-ec2-health-check`: Phase 1 (Scripts Zone) runs `kubectl get pods`, `kubectl describe pod`, `kubectl logs`, `kubectl top pods` — broad data gathering once. Phase 2 (Agents Zone) contains 6 decision branches, one per K8S-02 failure mode (ImagePullBackOff, CrashLoopBackOff, OOMKilled/resource limits, liveness probe failure, missing secret, port mismatch).

### Addon Skill Depth
- **D-05:** Addon skills are **starter scaffolds**, not full-depth procedures. Each scaffold ships:
  - Complete YAML frontmatter (name, description, version, compatibility, hermes metadata)
  - Phase 1 commands listed as code blocks (kubectl commands ready to run)
  - Phase 2 stub with structured TODOs marking the decision branches participants must complete
  - NEVER DO section populated with the universal kubectl write-action prohibitions
  - Verification checklist
- **D-06:** Module 7 lab uses these scaffolds as the natural skill-authoring exercise. Participants extend them following the existing 7-step pattern. The starter scaffolds replace what is currently a generic template-only fill-in.

### Broken-Pod Scenarios (K8S-02)
- **D-07:** Broken pods come from **baked static manifests** in `infrastructure/scenarios/k8s/` — one `.yaml` file per failure mode. Lab applies them with `kubectl apply -f`. No runtime dependency on kube-troublesim.
- **D-08:** Each scenario `.yaml` pairs with a sibling scenario `.md` doc (mirroring the existing `track-c-messy.md` pattern). The doc contains: setup commands, the broken-state participants should observe, expected Kiran diagnosis output, instructor anti-patterns to flag.
- **D-09:** kube-troublesim is **optional exploratory content only**. Phase 6 researcher does a smoke test (kube-troublesim latest on KIND v0.31, apply 1 scenario) and documents the result. If compatible, kube-troublesim earns a mention in `exploratory/PROJECTS.mdx` as an advanced chaos-engineering path. If not, it's deferred to v1.2 with no Phase 6 dependency. **Either outcome unblocks Phase 6 lab content authoring.**
- **D-10:** Six failure modes are locked by K8S-02: ImagePullBackOff, CrashLoopBackOff, resource limits / OOMKilled, liveness probe failure, missing secret, port mismatch. All 6 ship in Phase 6.

### Live KIND vs Mock Mode
- **D-11:** **Live KIND is the primary lab path.** Lab default is `HERMES_LAB_MODE=live`. Kiran connects to a real KIND cluster, the baked manifests are applied for real, kubectl returns real cluster state. K8S-03 success criteria explicitly require live cluster integration.
- **D-12:** **Mock mode is the documented Udemy/no-Docker fallback.** Each major lab step gets a `:::info Solo Learner` callout block showing the mock-mode equivalent (same pattern Phase 4 established for Module 11 fleet lab). Mock mode is supported, never silently broken.
- **D-13:** Mock JSON parity is achieved by **capturing real kubectl outputs** from live KIND after applying each baked manifest. After applying scenario 01-image-pull-backoff.yaml live, run `kubectl get pods -o json > infrastructure/mock-data/kubernetes/01-image-pull-backoff.json`, repeat for `describe`, `logs`, `top`. Mock data IS the canonical live output. Six new scenarios → ~24 new mock JSON files (4 commands × 6 scenarios), or fewer if scenarios share output shapes.
- **D-14:** Reuse the existing `infrastructure/kind/cluster-config.yaml` (the "lab" cluster from Phase 1, 1 control-plane + 2 workers, port mappings already correct). Phase 6 lab includes a preflight script that verifies the cluster is running and creates it if not. **No new KIND cluster config.**
- **D-15:** Each scenario lives in its own dedicated namespace (e.g., `k8s-trouble-image-pull`, `k8s-trouble-crashloop`) so cleanup is `kubectl delete namespace <ns>` and scenarios are isolated from each other and from the reference app.

### Track C Agent (Kiran) Updates
- **D-16:** Kiran's `SOUL.md` gets a **light edit, not a rewrite**. Three small changes: (1) explicit reference to the new `sre-k8s-pod-health` skill, (2) extend NEVER rules if the new skill enables any new dangerous-command vectors not covered by the existing 4 NEVER rules, (3) update Escalation Policy to reference the 6 K8S-02 failure modes by name. Identity statement and Behavior Rules stay intact.
- **D-17:** `agents/track-c-kubernetes/config.yaml` updates: `command_allowlist: []` stays (Phase 7 owns the allowlist work — GOV-01). The model field (`anthropic/claude-haiku-4`) and approvals mode (`manual`) stay unchanged.
- **D-18:** Old `agents/track-c-kubernetes/skills/sre-ec2-health-check/` directory is **deleted** (not preserved). The EC2 skill remains intact at the root `skills/sre-ec2-health-check/` for Track B reuse — only the misattached profile copy is removed.

### Cross-Module Cascade
- **D-19:** Phase 6 performs a **full audit and cascade** of every `sre-ec2-health-check` reference in a Track C / Kiran / Kubernetes context:
  - `agents/track-c-kubernetes/skills/sre-ec2-health-check/` → delete, replace with primary skill copy
  - `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` → replace with completed `sre-k8s-pod-health` content
  - `modules/module-07-skills/starter/track-c-kubernetes/SKILL.md` → keep 7-step authoring template structure, but ensure all examples reference K8s (current version is mostly OK)
  - `modules/module-10-agents/solution/track-c/skills/sre-ec2-health-check/` → delete, replace with primary skill
  - `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` → remove the "cross-domain teaching moment" rationalization (lines ~150-166), replace with text that acknowledges Kiran now ships with a real K8s skill, update verification commands (`ls ~/.hermes/profiles/track-c/skills/` expected output changes from `sre-ec2-health-check` to `sre-k8s-pod-health`)
  - `course-site/docs/module-07-agent-skills/lab/LAB.mdx` → audit for any Track C step that references EC2; align with the new starter scaffolds
  - `course-site/docs/module-11-fleet/**/*.mdx` → audit for references to Kiran or sre-ec2-health-check; update text-only references where Kiran's attached skill is named
- **D-20:** Goal of the cascade: **zero `sre-ec2-health-check` references in K8s/Kiran/Track C contexts**. Any remaining EC2 references must be intentional Track B (FinOps / EC2 ops) work. A grep for `sre-ec2-health-check.*kiran|kiran.*sre-ec2|track-c.*sre-ec2|sre-ec2.*track-c` should return zero hits.

### Reading & Quiz Updates
- **D-21:** Module 7 reading and quiz updates are in scope only where the existing content references the EC2 example for skill structure. Light touch: swap one or two examples to use the new `sre-k8s-pod-health` skill, keep the conceptual content (Scripts Zone vs Agents Zone, frontmatter, NEVER DO) intact. **Not a full reading/quiz rewrite** — Phase 5 just completed Module 5/6 and that pattern stays.

### Claude's Discretion
- Exact kubectl flag combinations within Phase 1 of the primary skill (e.g., `-o jsonpath=` vs `-o json | jq`)
- Specific decision branch thresholds (e.g., "restartCount > 5" vs "> 3") — use realistic SRE values
- Exact mock JSON field values (whatever the live KIND capture produces)
- Namespace name format (`k8s-trouble-*` is suggested, exact spelling is Claude's call)
- Whether to ship a `Makefile` target or shell script for the live-capture mock generation workflow
- Exact wording of the SOUL.md `sre-k8s-pod-health` reference and any extended NEVER rule
- Frontmatter `tags` for the new skills (within the SKILL.md convention)
- Order in which the 6 scenarios are presented to the participant (suggested: simplest → most ambiguous: image-pull → port-mismatch → missing-secret → liveness → crashloop → oom)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing K8s-related Code (must read)
- `agents/track-c-kubernetes/SOUL.md` — Kiran's existing identity, behavior rules, escalation policy. The light-edit baseline.
- `agents/track-c-kubernetes/config.yaml` — Profile config: model, approvals mode, command_allowlist (currently empty — Phase 7 territory).
- `agents/track-c-kubernetes/skills/sre-ec2-health-check/SKILL.md` — The misattached EC2 skill currently in the profile. To be deleted and replaced with `sre-k8s-pod-health` copy. Read the structure (Phase 1 / Phase 2 / Escalation / NEVER DO / Verification) — primary skill should mirror this structure.
- `skills/sre-ec2-health-check/SKILL.md` — Canonical EC2 skill at repo root. **Stays as-is for Track B.** Used as the structural template for the new K8s skill.
- `modules/module-07-skills/starter/track-c-kubernetes/SKILL.md` — The current 7-step authoring template (mostly K8s-aware already). Stays as a template; verify K8s examples are correct.
- `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` — Currently empty/placeholder (needs the completed `sre-k8s-pod-health` content).
- `modules/module-10-agents/solution/track-c/SOUL.md` and `config.yaml` — Module 10 Track C reference solution; mirror updates from `agents/track-c-kubernetes/`.

### Existing Lab and Mock Infrastructure
- `infrastructure/wrappers/mock-kubectl` — kubectl mock/live router. Already routes via `HERMES_LAB_MODE`. Need to extend the case statements to serve the 6 new scenarios (currently only handles `clean`, `messy`, `crashloop`).
- `infrastructure/mock-data/kubernetes/` — Existing 3 mock JSON files (`get-pods-healthy.json`, `get-pods-crashloop.json`, `describe-pod-oom.json`). Need to add ~24 new files captured from live KIND.
- `infrastructure/scenarios/track-c-clean.md` and `track-c-messy.md` — Existing scenario doc pattern. New `infrastructure/scenarios/k8s/*.md` files follow this exact structure.
- `infrastructure/kind/cluster-config.yaml` — Existing KIND cluster definition (1 control-plane + 2 workers, port mappings). Reused as-is.

### Existing Course Lab MDX (must read for cascade impact)
- `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` — The most heavily affected lab MDX. Currently rationalizes the EC2 skill mismatch as a "cross-domain teaching moment" (lines ~150-166). That rationalization gets removed.
- `course-site/docs/module-07-agent-skills/lab/LAB.mdx` — Module 7 skill-authoring lab. Audit for Track C references.
- `course-site/docs/module-11-fleet/**/*.mdx` — Fleet lab references Kiran. Audit only — fleet workflow rebuild belongs to Phase 9.

### Course Project & Conventions
- `.planning/PROJECT.md` — v1.1 Active requirements list, Key Decisions table, current state (v1.0 known issues).
- `.planning/REQUIREMENTS.md` §K8s Skills & Agents — Requirements K8S-01 through K8S-05 (the deliverables for this phase).
- `.planning/ROADMAP.md` Phase 6 — Phase goal and 5 success criteria.
- `.planning/phases/05-module-consolidation/05-CONTEXT.md` — Phase 5 prior context (labs-first, context-first starter pattern, no pre-written code skeletons — applies here too).
- `CLAUDE.md` — Course conventions, module structure, learner profile, free-tier constraint.

### External References (verify in researcher phase)
- `https://github.com/kubeagentix/kube-troublesim` — Optional exploratory mention only. Researcher must smoke-test on KIND v0.31 and document version + result.
- `https://kind.sigs.k8s.io/docs/user/configuration/` — KIND configuration reference (only needed if cluster config changes; D-14 says it doesn't).
- `https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/` — Pod phases and conditions reference (decision branch logic for Phase 2 of the primary skill).

### Hermes Skill Structure Reference
- `~/.claude/superpowers/tdd.md`, `debugging.md`, `verification.md`, `code-review.md` — Phase 5 used these. Phase 6 lab content (Module 7 skill authoring) does NOT need to teach Superpowers again — that's Module 5's job. Phase 6 builds the *artifact* (skills + agent) that Module 7 lab uses as material.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **EC2 skill structure (`skills/sre-ec2-health-check/SKILL.md`)** — 280-line full-depth skill with Phase 1 (deterministic data gathering) → Phase 2 (decision tree) → Escalation → NEVER DO → Rollback → Verification. The primary K8s skill should mirror this exactly, swapping aws ec2 calls for kubectl.
- **mock-kubectl wrapper (`infrastructure/wrappers/mock-kubectl`)** — Already routes mock/live based on `HERMES_LAB_MODE`. Already handles `clean`, `messy`, `crashloop` scenarios. Just needs new case statements for the 6 new scenarios. Do NOT rewrite — extend.
- **Existing mock JSON files (`infrastructure/mock-data/kubernetes/`)** — Stay. The 3 existing files (`get-pods-healthy.json`, `get-pods-crashloop.json`, `describe-pod-oom.json`) are referenced by Module 10 lab text. Don't break them.
- **KIND cluster config** — Already shipped in Phase 1, has the right node count and port mappings. Reuse, don't reauthor.
- **`infrastructure/scenarios/track-c-messy.md`** — A perfect template for the 6 new scenario .md docs. Same structure (Setup / Context / Expected Agent Behavior / Instructor Notes / Mock Data Files).
- **Solo Learner callout pattern** — Established by Phase 4 in Module 11. Reuse `:::info Solo Learner` blocks for mock fallbacks.

### Established Patterns
- **Skill naming:** `<domain-prefix>-<tech>-<scope>` — `sre-` for SRE/K8s, `dba-` for database, `devops-` for deployment, `observability-` for alerts. The new primary skill follows this: `sre-k8s-pod-health`.
- **Skill file location:** Canonical at `skills/<name>/SKILL.md`, copy in agent profile `agents/<track>/skills/<name>/SKILL.md`. The dual-location pattern is the v1.0 reality — keep it.
- **HERMES_LAB_MODE env var:** Universal mock/live toggle. Every lab respects it. Phase 6 is no exception.
- **Scenario .md doc pattern:** `infrastructure/scenarios/<track>-<state>.md` — has Setup, Context, Expected Agent Behavior, Instructor Notes, Mock Data Files Used. The 6 new K8s scenario docs follow this exactly.
- **Module 10 lab "cross-domain teaching moment":** Currently used to *justify* the EC2-on-K8s mismatch. This rationalization is a known wart and Phase 6 explicitly removes it.
- **Frontmatter `compatibility:` field:** Used to encode tool versions and required env vars. New skills declare `kubectl 1.28+, KIND v0.31+, HERMES_LAB_MODE=mock|live`.
- **Phase 1 / Phase 2 zone naming:** Phase 1 = SCRIPTS ZONE (deterministic, run-and-capture). Phase 2 = AGENTS ZONE (reasoning, decision tree). This is the established skill structure for all SKILL.md files.

### Integration Points
- **Hermes profile install path:** `~/.hermes/profiles/track-c/skills/<skill-name>/SKILL.md`. Lab text shows participants the `cp -r` install. Updates needed wherever the lab text lists the expected `ls` output.
- **Module 10 lab verification block:** Lines 460-482 of `LAB-track-c-kubernetes.mdx` lists exact `ls ~/.hermes/profiles/track-c/skills/` expected output (currently `sre-ec2-health-check`). Must change to `sre-k8s-pod-health`.
- **Module 11 fleet lab:** Imports Track C agent reference; updates Kiran's identity references, not the skill files themselves.
- **Reference app deployment:** Phase 6 scenarios use their own dedicated namespaces (`k8s-trouble-*`) so they don't collide with the reference app's `default` namespace deployments from Phase 1.

</code_context>

<specifics>
## Specific Ideas

- **The EC2 skill stays the canonical structural template.** Read `skills/sre-ec2-health-check/SKILL.md` end-to-end and copy its skeleton: same headings, same Phase 1/Phase 2/Escalation/NEVER DO/Rollback/Verification structure. The new primary skill is a structural twin in K8s vocabulary.
- **The "cross-domain teaching moment" rationalization in `LAB-track-c-kubernetes.mdx` lines 150-166 must die.** It's a known wart. Phase 6 replaces it with text that says: "Kiran ships with `sre-k8s-pod-health` — a K8s diagnostic skill matching its domain. List the skills directory to confirm." This removes course credibility damage.
- **Live KIND is the primary path because K8S-03's success criterion explicitly requires it.** Read criterion 3 verbatim: "The Track C agent (Kiran) loads with the K8s diagnostic skill, **connects to a live KIND cluster**, and returns meaningful diagnosis output." Mock mode cannot satisfy this — it has to actually connect.
- **The 6 scenarios are in K8S-02. Don't add or drop scenarios.** Six exact failure modes: ImagePullBackOff, CrashLoopBackOff, resource limits / OOMKilled, liveness probe failure, missing secret, port mismatch.
- **Capture, don't author, the mock JSON.** Apply each baked manifest live, run kubectl, redirect output to `infrastructure/mock-data/kubernetes/<NN>-<scenario>.json`. The live cluster IS the source of truth for mock data.
- **Phase 7 owns the command_allowlist.** Phase 6 leaves `command_allowlist: []` as-is. Don't preempt Phase 7's GOV-01 work.
- **kube-troublesim is a research-output decision.** The researcher's smoke test result drives whether it earns an exploratory mention or gets deferred to v1.2. Either way, Phase 6 lab content is authored against baked manifests, not against kube-troublesim.
- **Fleet (Module 11) cascade is text-only.** Phase 9 owns the fleet workflow rebuild (FLEET-01, FLEET-02). Phase 6 only updates Module 11 *text references* to Kiran's attached skill — does not rebuild the fleet lab logic.

</specifics>

<deferred>
## Deferred Ideas

### Phase 7 territory (do not preempt)
- **Hermes command allowlist for new K8s commands** — `kubectl get`, `describe`, `logs`, `top` should be in the L1+ allowlist; `kubectl delete`, `drain`, `exec`, `cordon` should be blocked. This is GOV-01 in Phase 7.

### Phase 9 territory (do not preempt)
- **Multi-agent fleet workflow rebuild for Module 11** using the new working Kiran. This is FLEET-02. Phase 6 only does text-reference updates in Module 11; Phase 9 owns the actual workflow logic.

### v1.2 candidates (capture but defer)
- **Reading and quiz full rewrite for Modules 7 and 10** — Phase 5 didn't rewrite Module 6's reading/quiz beyond a rename, and Phase 6 follows that pattern. A deeper reading/quiz overhaul incorporating the new K8s skills could happen in v1.2 once Phase 9 fleet work also lands.
- **kube-troublesim as a primary lab tool** — If the researcher confirms KIND v0.31 compatibility AND it gains stability, v1.2 could promote kube-troublesim from optional exploratory to part of the main lab flow.
- **Live K8s scenarios from a chaos-engineering tool other than kube-troublesim** (e.g., chaos-mesh, litmus) — one alternative tool per scenario could become a comparative chaos-engineering teaching unit in v1.2.

</deferred>

---

*Phase: 06-k8s-skills-agents*
*Context gathered: 2026-04-07*
