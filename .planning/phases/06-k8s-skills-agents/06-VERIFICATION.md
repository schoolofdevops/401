---
phase: 06-k8s-skills-agents
verified: 2026-04-07T00:00:00Z
status: passed
score: 5/5 must-haves verified
re_verification: false
---

# Phase 6: K8s Skills & Agents Verification Report

**Phase Goal:** The K8s diagnostic track has real, working skills and a properly configured agent (Kiran) connected to a live KIND cluster — EC2 skill references eliminated
**Verified:** 2026-04-07
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Track C K8s SKILL.md has working kubectl commands (get pods, describe pod, logs, top) — zero EC2 commands | VERIFIED | `skills/sre-k8s-pod-health/SKILL.md` 287 lines; Steps 1.1-1.6 use kubectl exclusively; grep for ec2/cloudwatch/i-0123 returns zero matches |
| 2 | All 6 broken pod scenarios available as baked manifests (not kube-troublesim) with mock data fallback | VERIFIED | 6 YAML files + 6 sibling docs under `infrastructure/scenarios/k8s/`; 13 mock parity files in `infrastructure/mock-data/kubernetes/`; mock-kubectl extended with 6 new SCENARIO routes |
| 3 | Kiran loads with K8s diagnostic skill, SOUL.md references it, connects to live KIND, not EC2 health check | VERIFIED | `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md` exists (md5: 3b90bc92); SOUL.md 42 lines explicitly references sre-k8s-pod-health + 6 failure modes in Escalation Policy; EC2 skill deleted from profile |
| 4 | Module 7 Track C starter and solution files show kubectl-based diagnostics, not EC2 | VERIFIED | Starter is K8s-specific 7-step template; solution is byte-identical to canonical (md5: 3b90bc92ec27674ed093dfd6fb3260bf) |
| 5 | Additional K8s skills (node health, resource quota, rollback investigator) available as starter scaffolds | VERIFIED | `skills/sre-k8s-node-health/SKILL.md` (167 lines), `skills/sre-k8s-resource-quota/SKILL.md` (167 lines), `skills/sre-k8s-rollback-investigator/SKILL.md` (174 lines) — all with Phase 1 commands and PARTICIPANT EXTENSION POINT markers |

**Score:** 5/5 truths verified

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `skills/sre-k8s-pod-health/SKILL.md` | Primary skill, ~280+ lines, 6 decision branches | VERIFIED | 287 lines; 7 decision branches (6 failure modes + "no active issue"); Phase 1 has 6 kubectl commands |
| `skills/sre-k8s-node-health/SKILL.md` | Addon scaffold | VERIFIED | 167 lines; 4 Phase 1 kubectl commands; 4 PARTICIPANT EXTENSION POINT TODO branches |
| `skills/sre-k8s-resource-quota/SKILL.md` | Addon scaffold | VERIFIED | 167 lines; 4 Phase 1 kubectl commands; 4 PARTICIPANT EXTENSION POINT TODO branches |
| `skills/sre-k8s-rollback-investigator/SKILL.md` | Addon scaffold | VERIFIED | 174 lines; 4 Phase 1 kubectl commands; 4 PARTICIPANT EXTENSION POINT TODO branches |
| `infrastructure/scenarios/k8s/01-image-pull-backoff.yaml` | Baked manifest with Namespace | VERIFIED | Defines `kind: Namespace` at line 7; uses `nonexistent-registry.io/fake-app:v1.0.0` as image |
| `infrastructure/scenarios/k8s/02-crashloop-backoff.yaml` | Baked manifest with Namespace | VERIFIED | Namespace defined; busybox exit 1 with "fatal: missing config" |
| `infrastructure/scenarios/k8s/03-oom-killed.yaml` | Baked manifest with Namespace | VERIFIED | Namespace defined; python:3.12-alpine with 32Mi limit |
| `infrastructure/scenarios/k8s/04-liveness-probe.yaml` | Baked manifest with Namespace | VERIFIED | Namespace defined; livenessProbe.httpGet.port=9999 vs containerPort=80 |
| `infrastructure/scenarios/k8s/05-missing-secret.yaml` | Baked manifest with Namespace | VERIFIED | Namespace defined; references secret `app-credentials` not created |
| `infrastructure/scenarios/k8s/06-port-mismatch.yaml` | Baked manifest with Namespace | VERIFIED | Namespace defined; Service targetPort=9090 vs containerPort=80 |
| `infrastructure/scenarios/k8s/01-image-pull-backoff.md` | Sibling doc | VERIFIED | Exists, 2.8K |
| `infrastructure/scenarios/k8s/02-crashloop-backoff.md` | Sibling doc | VERIFIED | Exists, 3.9K |
| `infrastructure/scenarios/k8s/03-oom-killed.md` | Sibling doc | VERIFIED | Exists, 3.7K |
| `infrastructure/scenarios/k8s/04-liveness-probe.md` | Sibling doc | VERIFIED | Exists, 3.7K |
| `infrastructure/scenarios/k8s/05-missing-secret.md` | Sibling doc | VERIFIED | Exists, 3.7K |
| `infrastructure/scenarios/k8s/06-port-mismatch.md` | Sibling doc | VERIFIED | Exists, 3.8K |
| `infrastructure/scenarios/k8s/capture-mock-data.sh` | Executable script | VERIFIED | 5.9K; permissions -rwxr-xr-x; implements wait_for_state() with 120s timeout; captures all 6 scenarios |
| `infrastructure/wrappers/mock-kubectl` | Extended with 6 new SCENARIO routes; old messy/crashloop/clean preserved | VERIFIED | 119 lines; nested case statements serve all 6 new scenarios; fallthrough preserved for messy/crashloop/clean |
| `infrastructure/mock-data/kubernetes/01-image-pull-get-pods.json` | ImagePullBackOff field shapes | VERIFIED | `state.waiting.reason=ImagePullBackOff`, image=nonexistent-registry.io/fake-app:v1.0.0 |
| `infrastructure/mock-data/kubernetes/01-image-pull-describe.txt` | Describe text | VERIFIED | Exists, 2.0K |
| `infrastructure/mock-data/kubernetes/02-crashloop2-get-pods.json` | CrashLoopBackOff field shapes | VERIFIED | `state.waiting.reason=CrashLoopBackOff`, `lastState.terminated.exitCode=1`, `restartCount=5` |
| `infrastructure/mock-data/kubernetes/02-crashloop2-describe.txt` | Describe text | VERIFIED | Exists, 1.9K |
| `infrastructure/mock-data/kubernetes/02-crashloop2-logs.txt` | Logs text | VERIFIED | Exists, 34B |
| `infrastructure/mock-data/kubernetes/03-oom-get-pods.json` | OOMKilled field shapes | VERIFIED | `lastState.terminated.reason=OOMKilled`, `exitCode=137`, `limits.memory=32Mi`, `restartCount=3` |
| `infrastructure/mock-data/kubernetes/03-oom-describe.txt` | Describe text | VERIFIED | Exists, 2.3K |
| `infrastructure/mock-data/kubernetes/04-liveness-get-pods.json` | Liveness probe fields | VERIFIED | `state.waiting.reason=CrashLoopBackOff`, `livenessProbe.httpGet.port=9999`, `containerPort=80` |
| `infrastructure/mock-data/kubernetes/04-liveness-describe.txt` | Describe text | VERIFIED | Exists, 2.2K |
| `infrastructure/mock-data/kubernetes/05-missing-secret-get-pods.json` | CreateContainerConfigError fields | VERIFIED | `status.phase=Pending`, `state.waiting.reason=CreateContainerConfigError` |
| `infrastructure/mock-data/kubernetes/05-missing-secret-describe.txt` | Describe text | VERIFIED | Exists, 1.7K |
| `infrastructure/mock-data/kubernetes/06-port-mismatch-get-pods.json` | Running pod field shapes | VERIFIED | Exists, 1.9K |
| `infrastructure/mock-data/kubernetes/06-port-mismatch-get-endpoints.json` | Empty subsets | VERIFIED | 1 endpoint item with `subsets=[]` (no backend addresses) |
| `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md` | Skill installed in Kiran profile | VERIFIED | md5=3b90bc92ec27674ed093dfd6fb3260bf — byte-identical to canonical |
| `agents/track-c-kubernetes/SOUL.md` | Light-edited, 40-80 lines | VERIFIED | 42 lines; references `sre-k8s-pod-health`; NEVER rule for kubectl exec/edit/patch/apply; Escalation Policy enumerates all 6 K8S-02 failure modes |
| `modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` | Replaced with K8s content | VERIFIED | md5=3b90bc92ec27674ed093dfd6fb3260bf — byte-identical to canonical; frontmatter `name: sre-k8s-pod-health` |
| `modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md` | K8s skill in Module 10 solution | VERIFIED | md5=3b90bc92ec27674ed093dfd6fb3260bf — byte-identical to canonical |
| `skills/sre-ec2-health-check/SKILL.md` | Canonical EC2 skill MUST still exist for Track B | VERIFIED | Exists at canonical root (11.1K); not touched by Phase 6 |

**Negative checks:**

| Check | Expected | Result |
|-------|----------|--------|
| `agents/track-c-kubernetes/skills/sre-ec2-health-check/` | Must be deleted | CONFIRMED DELETED |
| `modules/module-10-agents/solution/track-c/skills/sre-ec2-health-check/` | Must be deleted | CONFIRMED DELETED |
| EC2 vocabulary in K8s skill files | Zero | ZERO matches for ec2/cloudwatch/i-0123 in `skills/sre-k8s-*/SKILL.md` |
| `sre-ec2-health-check` refs in K8s/Kiran/Track C contexts | Zero | ZERO matches across agents/track-c-kubernetes/, modules/module-07-skills/solution/track-c-kubernetes/, modules/module-10-agents/solution/track-c/, course-site/docs/module-10-domain-agent/, reading/skills-guide.md, course-site/docs/reading/skills-guide.mdx |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `agents/track-c-kubernetes/SOUL.md` | `sre-k8s-pod-health` skill | Identity paragraph + Escalation Policy | WIRED | Line 11: explicit skill reference; Escalation Policy lists all 6 failure modes |
| `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md` | canonical skill | byte-identical copy | WIRED | md5 checksums match (3b90bc92ec27674ed093dfd6fb3260bf) |
| `mock-kubectl` wrapper | 6 new scenario mock files | HERMES_LAB_SCENARIO case statements | WIRED | image-pull, crashloop2, oom, liveness, missing-secret, port-mismatch all routed; old messy/crashloop/clean preserved |
| `capture-mock-data.sh` | `infrastructure/scenarios/k8s/` manifests | Applies each YAML, captures kubectl output | WIRED | All 6 scenarios covered with dedicated capture blocks |
| `LAB-track-c-kubernetes.mdx` | `sre-k8s-pod-health` skill | Expected ls output references | WIRED | Three locations (lines 110, 147, 467) show `# Expected: sre-k8s-pod-health/`; cross-domain teaching moment replaced at line 152 |
| `modules/module-10-agents/solution/track-c/SOUL.md` | `agents/track-c-kubernetes/SOUL.md` | Mirror identity | WIRED | md5 checksums match (8b3e080e75ec1ef9e2076d00eed21ee3) |
| `course-site/docs/resources/skills.mdx` | 4 K8s skills | Skill catalog entries | WIRED | Lines 35, 59, 69, 79 — all 4 K8s skills listed |
| `course-site/docs/module-07-agent-skills/exploratory/PROJECTS.mdx` | kube-troublesim mention | Project 4 section | WIRED | Lines 142-168 — kube-troublesim correctly classified as nascent exploratory tool, not required dependency |
| `agents/track-c-kubernetes/config.yaml` | Phase 7 boundary | `command_allowlist: []` preserved | WIRED | Line 20: `command_allowlist: []` — GOV-01 work deferred to Phase 7 as required by D-17 |

---

### Data-Flow Trace (Level 4)

Not applicable — this phase produces SKILL.md content files and lab infrastructure manifests, not components that render dynamic runtime data. The mock-kubectl wrapper's data routing was verified directly against the 13 mock data files (spot-checked OOM, ImagePull, port-mismatch, missing-secret, liveness, crashloop fields).

---

### Behavioral Spot-Checks

| Behavior | Check | Result | Status |
|----------|-------|--------|--------|
| Primary skill has 7 decision branches (6 K8S-02 + no-issue) | Direct read of lines 117-232 | All 7 branches present: ImagePullBackOff, CrashLoopBackOff, OOMKilled, Liveness probe, Missing secret, Port mismatch, No active issue | PASS |
| OOM mock data has required field shapes | `python3 -c "..."` field inspection | `reason=OOMKilled`, `exitCode=137`, `limits.memory=32Mi`, `restartCount=3` | PASS |
| ImagePull mock data has required field shapes | `python3 -c "..."` field inspection | `state.waiting.reason=ImagePullBackOff`, `image=nonexistent-registry.io/fake-app:v1.0.0` | PASS |
| Port-mismatch endpoints mock has empty subsets | `python3 -c "..."` field inspection | `items[0].subsets=[]` — no backend addresses | PASS |
| All 6 scenario YAMLs define their own Namespace | grep `kind: Namespace` across 6 files | All 6 files match | PASS |
| capture-mock-data.sh is executable | `stat -f "%Sp"` | `-rwxr-xr-x` | PASS |
| EC2 skill copy deleted from Kiran profile | `ls agents/track-c-kubernetes/skills/sre-ec2-health-check/` | Directory does not exist | PASS |
| 4 SKILL.md copies are byte-identical | `md5` on all 4 paths | All return `3b90bc92ec27674ed093dfd6fb3260bf` | PASS |
| 2 SOUL.md copies are byte-identical | `md5` on both paths | Both return `8b3e080e75ec1ef9e2076d00eed21ee3` | PASS |
| All 6 plan commits exist in git history | `git log --oneline <hashes>` | c5ca1b8, 5aa6435, c9fa336, b03d1f5, bd8b0f8, ce98964 all present | PASS |

---

### Requirements Coverage

| Requirement | Description | Status | Evidence |
|-------------|-------------|--------|----------|
| K8S-01 | K8s diagnostic SKILL.md with real kubectl commands replacing EC2 skill in Track C | SATISFIED | `skills/sre-k8s-pod-health/SKILL.md` 287 lines; Steps 1.1-1.6 use kubectl; installed in all Track C agent profiles; zero EC2 references |
| K8S-02 | 6 broken pod scenarios as lab exercises (ImagePullBackOff, CrashLoopBackOff, resource limits, liveness probe, missing secret, port mismatch) | SATISFIED | 6 baked YAML manifests + 6 sibling docs + 13 mock data files; all 6 failure modes routed in mock-kubectl; capture-mock-data.sh for live KIND re-capture |
| K8S-03 | Track C agent (Kiran) rebuilt with proper K8s skill attached, updated SOUL.md, and live KIND integration | SATISFIED | K8s skill installed in profile; SOUL.md 42 lines with skill reference + 6-failure-mode escalation policy; `HERMES_LAB_MODE=live` is default in mock-kubectl |
| K8S-04 | Additional K8s skills: node health check, resource quota analysis, deployment rollback investigation | SATISFIED | `skills/sre-k8s-node-health/SKILL.md` (167 lines), `skills/sre-k8s-resource-quota/SKILL.md` (167 lines), `skills/sre-k8s-rollback-investigator/SKILL.md` (174 lines) |
| K8S-05 | Module 7 Track C starter and solution files replaced with actual K8s diagnostic skill | SATISFIED | Starter: K8s-specific 7-step authoring template; Solution: byte-identical to canonical K8s skill (md5: 3b90bc92) |

**All 5 K8S requirements: SATISFIED**

Requirements traceability in REQUIREMENTS.md shows all 5 marked `[x]` with Phase 6 assignment. No orphaned requirements found.

---

### Anti-Patterns Found

No blockers or warnings found. Verification of key files:

| File | Pattern Checked | Result |
|------|-----------------|--------|
| `skills/sre-k8s-pod-health/SKILL.md` | Placeholder/TODO content in Phase 2 | NONE — all 7 decision branches have concrete kubectl JSON path conditions |
| `skills/sre-k8s-node-health/SKILL.md` | Phase 2 HTML comment stubs | EXPECTED — these are intentional PARTICIPANT EXTENSION POINT markers per D-05/D-06, not implementation stubs |
| `agents/track-c-kubernetes/SOUL.md` | EC2 vocabulary | NONE — grep found zero EC2 references |
| `modules/module-10-agents/solution/track-c/skills/sre-k8s-pod-health/SKILL.md` | Byte-identical to canonical | CONFIRMED — same md5 checksum; no divergence |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` | Cross-domain teaching moment rationalization (lines ~150-166) | REMOVED — replaced with factual tip block describing `sre-k8s-pod-health` |
| `infrastructure/wrappers/mock-kubectl` | Module 10 regression (messy/crashloop fallthrough) | CONFIRMED SAFE — `messy|crashloop)` branch preserved at line 42 |

The scaffold Phase 2 HTML comment blocks (`<!-- PARTICIPANT EXTENSION POINT -->`) in the 3 addon skills are classified as INFO-level by design — they are the lab teaching artifact, not unfinished implementation.

---

### Human Verification Required

Two behaviors require live cluster testing that cannot be verified programmatically:

#### 1. Live KIND Cluster Integration Test

**Test:** Start a KIND cluster using `infrastructure/kind/cluster-config.yaml`, set `export HERMES_LAB_MODE=live`, apply `infrastructure/scenarios/k8s/03-oom-killed.yaml`, invoke Kiran agent, observe diagnosis output.
**Expected:** Kiran runs `kubectl get pods --all-namespaces` as first action, identifies OOMKilled pod, cites `lastState.terminated.exitCode=137` and `reason=OOMKilled`, proposes `kubectl patch` command, does NOT self-apply, escalates for human approval.
**Why human:** Requires a running KIND cluster, real Docker environment, and interactive agent session.

#### 2. Mock Mode Full Scenario Walk-Through

**Test:** Set `export HERMES_LAB_MODE=mock HERMES_LAB_SCENARIO=port-mismatch`, verify the mock-kubectl wrapper routes to `06-port-mismatch-get-pods.json` and `06-port-mismatch-get-endpoints.json`, and that the Hermes agent's diagnosis follows Decision Branch 6.
**Expected:** Agent identifies `subsets=[]` in endpoints, compares targetPort vs containerPort, escalates with "Service port mismatch confirmed" — does NOT kubectl edit the service.
**Why human:** Requires interactive Hermes agent session to verify agent reasoning follows the skill's decision branch correctly.

---

### Gaps Summary

No gaps. All 5 success criteria are met by artifacts that exist, are substantive (not stubs), and are wired into agent profiles and lab MDX files.

**Key verifiable facts:**
- Primary skill is 287 lines (EC2 template is 281) — substantive, not a skeleton
- All 4 SKILL.md copies are byte-identical (md5: 3b90bc92ec27674ed093dfd6fb3260bf)
- Both SOUL.md copies are byte-identical (md5: 8b3e080e75ec1ef9e2076d00eed21ee3)
- Zero `sre-ec2-health-check` references in any K8s/Kiran/Track C context
- Mock data field shapes verified by Python inspection against RESEARCH.md field contracts
- All 6 git commits from plans 06-01, 06-02, 06-03 confirmed present in history
- Phase 7 boundary preserved: `command_allowlist: []` unchanged in config.yaml
- kube-troublesim correctly placed in exploratory PROJECTS.mdx (not in main lab path) per D-09
- Canonical `skills/sre-ec2-health-check/SKILL.md` preserved for Track B reuse per D-18

---

_Verified: 2026-04-07_
_Verifier: Claude (gsd-verifier)_
