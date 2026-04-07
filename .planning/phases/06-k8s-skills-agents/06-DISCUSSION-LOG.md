# Phase 6: K8s Skills & Agents - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-07
**Phase:** 06-k8s-skills-agents
**Areas discussed:** Skill architecture, kube-troublesim, Mock vs live KIND, K8S-04 depth

---

## Skill architecture

### Q1: How should the K8s diagnostic skills be structured?

| Option | Description | Selected |
|--------|-------------|----------|
| 1 primary + 3 addons | kubernetes-pod-health as comprehensive primary skill (covers all 6 failure modes via decision branches), 3 separate addon skills for K8S-04 at varying depth | ✓ |
| Split per failure mode | 6 narrow skills, one per failure mode. Cleaner separation, agent loads only what it needs. Higher file count, more orchestration burden | |
| 1 monolithic skill | Single kubernetes-health skill covers everything: pod failures + node + quota + rollback. K8S-04 becomes sections inside the same SKILL.md | |

**User's choice:** 1 primary + 3 addons (Recommended)
**Notes:** Mirrors existing sre-ec2-health-check pattern. Maintains separation between primary diagnosis and addon specialization.

---

### Q2: What name for the primary skill?

| Option | Description | Selected |
|--------|-------------|----------|
| sre-k8s-pod-health | Mirrors existing naming pattern (sre-ec2-health-check). Domain prefix + tech + scope. Slot-in replacement, minimal cross-module text changes | ✓ |
| kubernetes-pod-diagnosis | Action-oriented — 'diagnosis' is what the agent actually does. Cleaner but doesn't match the sre- prefix convention used elsewhere | |
| k8s-health-check | Short, mirrors the EC2 'health-check' suffix. Less specific about pods vs nodes vs cluster scope | |

**User's choice:** sre-k8s-pod-health (Recommended)
**Notes:** Naming consistency with existing sre- prefixed skills wins.

---

### Q3: Where should the primary skill live as the canonical source?

| Option | Description | Selected |
|--------|-------------|----------|
| skills/ at repo root | Matches existing pattern — skills/sre-ec2-health-check/SKILL.md is the canonical source today. agents/track-c-kubernetes/skills/ becomes a copy for profile install. Single source of truth | ✓ |
| agents/track-c-kubernetes/skills/ | Skill lives only inside the Track C agent profile. Tighter coupling between agent and skill, but breaks the 'shared skill catalog' pattern from v1.0 | |
| Both (canonical at root + copy in profile) | Explicit duplication — root for catalog discovery, profile copy for self-contained agent install. Matches what v1.0 actually does today, even if not ideal | |

**User's choice:** skills/ at repo root (Recommended)
**Notes:** Single source of truth in skills/ root; profile copy is install artifact.

---

### Q4: How should the primary skill handle the 6 K8S-02 failure modes inside one SKILL.md?

| Option | Description | Selected |
|--------|-------------|----------|
| Phase 1 commands cover all, Phase 2 decision tree branches per mode | Mirrors EC2 skill: Phase 1 (Scripts Zone) gathers data once; Phase 2 (Agents Zone) has 6 decision branches routing diagnosis based on observed signals | ✓ |
| All 6 modes get separate Phase 1+2 sections | Skill has 6 mini-procedures stacked. More navigable for teaching but more redundant code, harder for agent to choose | |
| Cover only OOM/CrashLoop/ImagePull in primary; liveness/secret/port handled by scenario context | Leaner primary skill, the more nuanced 3 modes get walked through in scenario .md files | |

**User's choice:** Phase 1 commands cover all, Phase 2 decision tree branches per mode (Recommended)
**Notes:** Single Phase 1 broad data gather, Phase 2 branches by signal — mirrors EC2 structure.

---

## kube-troublesim

### Q1: How should broken pods be created on KIND for the labs?

| Option | Description | Selected |
|--------|-------------|----------|
| Baked manifests primary, kube-troublesim optional | Repo ships infrastructure/scenarios/k8s/*.yaml — 6 hand-crafted manifests, one per failure mode. kube-troublesim documented in exploratory/ as optional advanced path. Mitigates STATE.md compatibility blocker | ✓ |
| kube-troublesim primary, manifests fallback | Lab installs kube-troublesim CRDs and uses its scenario API. Risk: KIND v0.31 compatibility unverified, version churn could break labs | |
| kube-troublesim only, no fallback | Single source of broken pods. Cleaner but binds the entire lab to a third-party tool's lifecycle | |

**User's choice:** Baked manifests primary, kube-troublesim optional (Recommended)
**Notes:** Removes dependency on external tool stability; baked manifests are reproducible and version-pinned.

---

### Q2: What's the target verification for kube-troublesim before Phase 6 builds lab content?

| Option | Description | Selected |
|--------|-------------|----------|
| Researcher confirms compatibility, then bake manifests anyway | Phase 6 researcher does a quick smoke test. Even on success, baked manifests stay primary so lab is independent. Researcher result determines whether kube-troublesim earns its exploratory mention | ✓ |
| Block phase until kube-troublesim verified compatible | Phase 6 cannot proceed until compatibility confirmed. Highest assurance but creates a hard dependency | |
| Drop kube-troublesim entirely from this phase | Defer kube-troublesim mention to v1.2. Phase 6 only ships baked manifests + scenario .md files | |

**User's choice:** Researcher confirms compatibility, then bake manifests anyway (Recommended)
**Notes:** Researcher's smoke test result determines exploratory inclusion; phase content authoring not blocked.

---

### Q3: How should the 6 baked scenario manifests be organized on disk?

| Option | Description | Selected |
|--------|-------------|----------|
| infrastructure/scenarios/k8s/ — one .yaml per failure mode | Mirrors existing infrastructure/scenarios/ pattern. Each file is self-contained: Deployment + ConfigMap + matching scenario .md doc | ✓ |
| Single multi-doc YAML with all 6 | One file, kubectl apply -f scenarios.yaml installs everything | |
| Helm chart with values toggling each scenario | infrastructure/scenarios/k8s-trouble/ Helm chart. Probably overkill | |

**User's choice:** infrastructure/scenarios/k8s/ — one .yaml per failure mode (Recommended)
**Notes:** Self-contained per scenario; easy selective application; mirrors existing scenarios/ pattern.

---

### Q4: Should each scenario manifest pair with a scenario .md doc?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — .md doc per scenario with expected agent output | Each .yaml gets a sibling .md describing setup, broken state, expected Kiran diagnosis, instructor anti-patterns. Mirrors track-c-messy.md | ✓ |
| Yes, but a single combined doc for all 6 | One scenarios/k8s-trouble-pods.md catalogs all 6. Less file sprawl, harder to navigate during lab | |
| No — manifest comments are sufficient | YAML files have header comments explaining the scenario. Faster to author, weaker for self-paced learners | |

**User's choice:** Yes — .md doc per scenario with expected agent output (Recommended)
**Notes:** Self-paced Udemy learners need the explicit expected-output narrative.

---

## Mock vs live KIND

### Q1: Which is the primary lab path for Phase 6?

| Option | Description | Selected |
|--------|-------------|----------|
| Live KIND primary, mock fallback | Lab default: HERMES_LAB_MODE=live. K8S-03 explicitly requires 'live KIND integration' and 'meaningful diagnosis output, not an EC2 health check'. Mock fallback documented as Solo Learner callout | ✓ |
| Mock primary, live optional | Keep v1.0 pattern. Lower friction, but K8S-03 success criteria say agent must connect to a live cluster — mock-primary doesn't validate that | |
| Both required, equal weight | Lab requires running both modes back-to-back to compare. Most pedagogically rich, doubles lab time | |

**User's choice:** Live KIND primary, mock fallback (Recommended)
**Notes:** K8S-03 success criterion forces live cluster integration; mock fallback for Udemy learners.

---

### Q2: How should the mock fallback stay in sync with the new baked live manifests?

| Option | Description | Selected |
|--------|-------------|----------|
| Generate mock JSON from live kubectl outputs | After applying each baked manifest live, capture kubectl outputs as canonical mock JSON. Mock data IS the captured live output. Guarantees parity | ✓ |
| Hand-author mock JSON | Author mock data manually based on K8s API spec. More control, risk of drift | |
| Skip mock for new scenarios; only existing 3 mock files stay | Live KIND becomes the only path for new scenarios. Drops mock parity but reduces authoring scope | |

**User's choice:** Generate mock JSON from live kubectl outputs (Recommended)
**Notes:** Live capture guarantees parity and reduces hand-authoring effort.

---

### Q3: How should KIND cluster setup be handled for Phase 6 labs?

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse existing infrastructure/kind/cluster-config.yaml | The 'lab' cluster from Phase 1 already has 1 control-plane + 2 workers and the right port mappings. Lab adds preflight script. No new cluster config | ✓ |
| Phase 6 ships its own dedicated kind config | Separate cluster for Phase 6. Cleaner separation, more setup overhead | |
| Use existing cluster + dedicated namespace per scenario | Single cluster, one namespace per failure mode. Easy cleanup, scenarios isolated | |

**User's choice:** Reuse existing infrastructure/kind/cluster-config.yaml (Recommended)
**Notes:** Selected option includes the namespace-per-scenario pattern (combined with reuse). No new cluster config needed.

---

### Q4: How prominent should the mock fallback be in the lab text?

| Option | Description | Selected |
|--------|-------------|----------|
| Solo Learner callout block per major step | Each lab step using live kubectl gets a :::info Solo Learner block showing mock equivalent. Same pattern as Module 11 fleet lab | ✓ |
| Single mock setup block at lab start | One callout at top: 'No Docker? Set HERMES_LAB_MODE=mock and proceed.' Less repetition | |
| Separate LAB-mock.mdx file | Two parallel lab files. Cleanest separation, doubles maintenance | |

**User's choice:** Solo Learner callout block per major step (Recommended)
**Notes:** Reuses Phase 4's established Solo Learner pattern for Module 11.

---

## K8S-04 depth

### Q1: How deep should the 3 K8S-04 additional skills be authored?

| Option | Description | Selected |
|--------|-------------|----------|
| 1 full + 3 starter scaffolds | Primary sre-k8s-pod-health is full-depth. The 3 additional skills ship as starter scaffolds: frontmatter complete, Phase 1 commands listed, Phase 2 stub with TODOs, NEVER DO present | ✓ |
| All 4 full-depth skills | All 4 skills authored to same completeness. Maximum value, ~3x authoring scope | |
| 1 full + 3 exploratory specs only | Only the primary is a real SKILL.md. Other 3 are listed in exploratory/PROJECTS.mdx as design exercises. Lightest scope | |

**User's choice:** 1 full + 3 starter scaffolds (Recommended)
**Notes:** Scaffolds become the natural extension exercise for Module 7 lab participants.

---

### Q2: Where should the 3 starter scaffolds live?

| Option | Description | Selected |
|--------|-------------|----------|
| skills/ at repo root, alongside primary | Same level as the primary. Consistent with skill catalog pattern. Module 7 lab points to them as 'extend these'. Discoverable for fleet/governance phases later | ✓ |
| modules/module-07-skills/starter/ alongside the existing track-c starter | Tied to the Module 7 authoring lab specifically. Less discoverable from agent profiles | |
| Both — canonical at root, copy in Module 7 starter | Same dual-location pattern as the primary skill. Consistent but explicit duplication | |

**User's choice:** skills/ at repo root, alongside primary (Recommended)
**Notes:** Discoverable from any phase needing K8s skills; consistent with primary skill location.

---

### Q3: Should Phase 6 update the cross-module references to sre-ec2-health-check?

| Option | Description | Selected |
|--------|-------------|----------|
| Full audit + cascade | Phase 6 updates every reference in K8s contexts: Module 10 lab text, Module 11 fleet lab, Module 7 starter/solution, agent profile copy. Goal: zero EC2 references in any Track C / Kiran context | ✓ |
| Track C files only — leave lab text | Update agent profile, Module 7 solution file, Module 10 solution config. Leave lab MDX text alone. Faster, leaves orphan rationalizations | |
| Phase 6 owns Module 10 lab text but not Module 11 | Module 10 is Track C's home, Module 11 is fleet. Update Module 10 fully, leave Module 11 for fleet phase later | |

**User's choice:** Full audit + cascade (Recommended)
**Notes:** Eliminates the "cross-domain teaching moment" rationalization wart in Module 10 lab text. Module 11 cascade is text-only — Phase 9 owns the fleet workflow rebuild.

---

### Q4: Should the Track C agent SOUL.md (Kiran) be updated?

| Option | Description | Selected |
|--------|-------------|----------|
| Light edit — align with new skill capabilities | 3 small edits: explicit reference to new sre-k8s-pod-health skill, extend NEVER rules if needed, update Escalation Policy to call out the 6 failure modes. No identity rewrite | ✓ |
| Full rewrite | Treat Kiran as new — rewrite SOUL.md from scratch. Higher cost, may diverge from existing test expectations | |
| No changes | Just swap the attached skill, leave SOUL.md untouched. Lowest scope; some phrasing won't match new skill exactly | |

**User's choice:** Light edit — align with new skill capabilities (Recommended)
**Notes:** Existing SOUL.md is already K8s-focused and well-written; only minor alignment needed.

---

## Claude's Discretion

These are intentionally left to Claude during planning and execution:

- Exact kubectl flag combinations within Phase 1 of the primary skill
- Specific decision branch thresholds (e.g., restartCount > 5 vs > 3)
- Exact mock JSON field values (whatever the live KIND capture produces)
- Namespace name format (k8s-trouble-* is suggested, exact spelling is Claude's call)
- Whether to ship a Makefile target or shell script for the live-capture mock generation workflow
- Exact wording of the SOUL.md sre-k8s-pod-health reference and any extended NEVER rule
- Frontmatter tags for the new skills
- Order in which the 6 scenarios are presented to participants

## Deferred Ideas

- **Phase 7 territory:** Hermes command allowlist for kubectl get/describe/logs/top (allow) and kubectl delete/drain/exec/cordon (block). GOV-01 owns this.
- **Phase 9 territory:** Multi-agent fleet workflow rebuild for Module 11 using the new working Kiran. FLEET-02 owns this. Phase 6 only does text-reference updates.
- **v1.2:** Reading and quiz full rewrite for Modules 7 and 10.
- **v1.2:** kube-troublesim as a primary lab tool (only if researcher's smoke test confirms compatibility AND it gains stability).
- **v1.2:** Comparative chaos-engineering tooling unit (chaos-mesh, litmus alongside kube-troublesim).
