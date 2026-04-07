---
phase: 06-k8s-skills-agents
plan: "01"
subsystem: skills
tags: [kubernetes, sre, skill-authoring, kubectl, pod-health, k8s-diagnostics]
dependency_graph:
  requires: []
  provides:
    - skills/sre-k8s-pod-health/SKILL.md
    - skills/sre-k8s-node-health/SKILL.md
    - skills/sre-k8s-resource-quota/SKILL.md
    - skills/sre-k8s-rollback-investigator/SKILL.md
  affects:
    - agents/track-c-kubernetes/skills/ (Plan 06-03 copies primary skill here)
    - modules/module-07-skills/ (scaffold files used in Module 7 lab)
    - modules/module-10-agents/ (primary skill replaces sre-ec2-health-check in Track C solution)
tech_stack:
  added: []
  patterns:
    - Structural twin pattern: K8s skill mirrors EC2 skill section ordering exactly
    - HTML-commented Phase 2 TODO pattern for participant-extension scaffolds
    - kubectl JSON path field references as contract for downstream mock JSON (Plan 06-02)
key_files:
  created:
    - skills/sre-k8s-pod-health/SKILL.md
    - skills/sre-k8s-node-health/SKILL.md
    - skills/sre-k8s-resource-quota/SKILL.md
    - skills/sre-k8s-rollback-investigator/SKILL.md
  modified: []
decisions:
  - sre-k8s-pod-health is 287 lines (EC2 template is 281) — within acceptable range, 6 extra lines from K8s-specific Phase 1 annotations
  - Phase 2 has 7 decision branches (6 K8S-02 failure modes + Branch 7 "no active issue") mirroring EC2 skill's 4 branches + "no issue" pattern
  - Scaffold Phase 2 uses HTML comment block (not prose TODO list) to mark participant extension points — visible to text editors, grep-discoverable, not rendered in markdown previews
  - All 4 addon scaffolds have 4 TODO branches each (plan minimum was 3) — extra branch gives participants more scaffolding guidance
metrics:
  duration: "5min"
  completed_date: "2026-04-07"
  tasks_completed: 2
  files_created: 4
  files_modified: 0
---

# Phase 6 Plan 01: K8s Diagnostic SKILL.md Files Summary

**One-liner:** Four K8s diagnostic SKILL.md files authored — sre-k8s-pod-health (full depth, 6 K8S-02 decision branches) plus three starter scaffolds with PARTICIPANT EXTENSION POINT markers for Module 7 lab.

## What Was Built

### Primary Skill: sre-k8s-pod-health

**Path:** `skills/sre-k8s-pod-health/SKILL.md`
**Line count:** 287 lines
**Commit:** c5ca1b8

Structural twin of `skills/sre-ec2-health-check/SKILL.md` — identical section ordering, same heading strings, same NEVER DO format, same Verification checkbox style. Only the domain vocabulary differs (kubectl instead of aws ec2, pods instead of instances).

**Phase 1 commands (6 data-gathering steps):**
- Step 1.1: `kubectl get pods -n $NAMESPACE -o json` — pod inventory with containerStatuses
- Step 1.2: `kubectl describe pod $POD_NAME -n $NAMESPACE` — Events table, container state, restart count
- Step 1.3: `kubectl logs $POD_NAME --tail=100` + `--previous` — current and previous container logs
- Step 1.4: `kubectl top pods -n $NAMESPACE` — resource consumption vs limits
- Step 1.5: `kubectl get endpoints -n $NAMESPACE -o json` — service endpoint health
- Step 1.6: `kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp' -o json` — namespace event stream

**Phase 2 decision branches (7 total — 6 K8S-02 failure modes + 1 "no issue"):**
1. ImagePullBackOff — `containerStatuses[].state.waiting.reason == "ImagePullBackOff"`
2. CrashLoopBackOff — `containerStatuses[].state.waiting.reason == "CrashLoopBackOff"` + exitCode analysis
3. OOMKilled / Resource Limits — `lastState.terminated.reason == "OOMKilled"` + exitCode 137
4. Liveness Probe Failure — Events table `"Liveness probe failed"` + probe port vs containerPort compare
5. Missing Secret / CreateContainerConfigError — `state.waiting.reason == "CreateContainerConfigError"`
6. Service Port Mismatch — `kubectl get endpoints` ENDPOINTS == `<none>` + selector + targetPort analysis
7. No active issue — all pods Running, ready=true, no recent events (mirrors EC2 Branch 4)

**Field reference contract for Plan 06-02 (mock JSON):**
The primary skill's Phase 2 reads these kubectl JSON paths — mock JSON files must include these fields:
- `status.containerStatuses[].state.waiting.reason`
- `status.containerStatuses[].lastState.terminated.reason`
- `status.containerStatuses[].lastState.terminated.exitCode`
- `status.containerStatuses[].restartCount`
- `status.containerStatuses[].ready`
- `status.phase`
- `spec.containers[].resources.limits.memory`
- `spec.containers[].livenessProbe.httpGet.port`
- `spec.containers[].ports[].containerPort`
- `spec.imagePullSecrets`
- `items[].reason` (EventList)
- `subsets[].addresses[]` (Endpoints)

### Addon Scaffolds (3 files)

**Path pattern:** `skills/<name>/SKILL.md`
**Commit:** 5aa6435

| Skill | Lines | Phase 1 Commands | TODO Branches | Failure Modes Covered |
|-------|-------|------------------|---------------|----------------------|
| sre-k8s-node-health | 167 | 4 (get nodes, describe node, top nodes, get pods --field-selector) | 4 | NotReady, MemoryPressure, DiskPressure, PIDPressure |
| sre-k8s-resource-quota | 167 | 4 (get resourcequota, describe resourcequota, get limitrange, get pods) | 4 | Quota saturation, blocked creation, missing LimitRange, pod count limit |
| sre-k8s-rollback-investigator | 174 | 4 (get deployment, rollout history, rollout status, get replicaset) | 4 | ProgressDeadlineExceeded, image regression, replica drift, RS sprawl |

Each scaffold has:
- Complete YAML frontmatter (name, description, version, compatibility, hermes metadata)
- Phase 1 with 4 kubectl commands and Expected output annotations
- Phase 2 with `<!-- PARTICIPANT EXTENSION POINT -->` HTML comment block containing 4 TODO branches
- 5 NEVER rules including a prompt injection guard
- Rollback Procedure (read-only statement)
- Verification checklist (6 checkboxes each)

## Section Structure Verification

All 4 K8s skills match the EC2 structural template (`skills/sre-ec2-health-check/SKILL.md`) exactly:

| Section | EC2 Skill | K8s Skills | Match |
|---------|-----------|------------|-------|
| YAML frontmatter | Lines 1-10 | Present in all 4 | Yes |
| ## When to Use | Line 12 | Present in all 4 | Yes |
| ## Inputs (table) | Line 22 | Present in all 4 | Yes |
| ## Prerequisites | Line 31 | Present in all 4 | Yes |
| ### Phase 1: Gather ... [SCRIPTS ZONE — deterministic] | Line 49 | Present in all 4 | Yes |
| ### Phase 2: Interpret and Decide [AGENTS ZONE — reasoning] | Line 170 | Present in all 4 | Yes |
| ## Escalation Rules | Line 225 | Present in all 4 | Yes |
| ## NEVER DO | Line 242 | Present in all 4 | Yes |
| ## Rollback Procedure | Line 250 | Present in all 4 | Yes |
| ## Verification | Line 269 | Present in all 4 | Yes |

## Deviations from Plan

None — plan executed exactly as written.

The primary skill has 7 decision branches instead of the plan's specified 6 — this matches the plan exactly, which explicitly calls for "Decision Branch 7 — No active issue (mirror EC2 skill Decision Branch 4)" at line 319 of the plan. Not a deviation.

The three scaffolds each have 4 TODO branches instead of the plan's minimum of 3 — extra branch provides more scaffolding guidance for participants. Not a deviation.

## Downstream Contracts

**Plan 06-02 (infrastructure scenarios):** The 6 failure mode scenario manifests must produce kubectl JSON outputs where:
- `containerStatuses[].state.waiting.reason` equals one of: `ImagePullBackOff`, `CrashLoopBackOff`, `CreateContainerConfigError`
- `lastState.terminated.reason` equals `OOMKilled` for the OOMKilled scenario
- `lastState.terminated.exitCode` equals `137` for the OOMKilled scenario
- Events contain `"Liveness probe failed"` for the liveness probe scenario
- Endpoints `subsets[]` is empty/null for the port mismatch scenario

**Plan 06-03 (agent profile updates):** Copy `skills/sre-k8s-pod-health/SKILL.md` to `agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md`. The canonical source is at `skills/sre-k8s-pod-health/SKILL.md` — do not author a second version.

## Known Stubs

None — all sections are filled with concrete K8s content. The scaffold Phase 2 HTML comment blocks are intentional, not stubs — they are the participant extension points by design per D-05 and D-06.

## Self-Check: PASSED
