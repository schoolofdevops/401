---
phase: 06-k8s-skills-agents
plan: "02"
subsystem: infrastructure
tags:
  - kubernetes
  - broken-pod-scenarios
  - mock-kubectl
  - kind
  - lab-infrastructure
dependency_graph:
  requires:
    - "06-01: sre-k8s-pod-health SKILL.md (Phase 2 decision branches reference these mock field shapes)"
  provides:
    - "6 baked KIND scenario manifests (K8S-02 failure modes)"
    - "6 sibling scenario .md docs"
    - "Extended mock-kubectl with 6 new HERMES_LAB_SCENARIO values"
    - "13 mock parity files (JSON + txt) for offline/Udemy fallback"
    - "capture-mock-data.sh for live KIND re-capture"
  affects:
    - "06-03: Lab MDX text references these scenario file paths and SCENARIO values"
    - "Module 10 lab: mock-kubectl changes are backward-compatible (messy/crashloop unchanged)"
tech_stack:
  added:
    - "python:3.12-alpine (OOM scenario — arm64-reliable bytearray heap allocation)"
    - "busybox:1.36 (crashloop and missing-secret scenarios)"
    - "nginx:1.27-alpine (liveness-probe and port-mismatch scenarios)"
  patterns:
    - "Multi-document YAML (--- separator) for Namespace + Deployment in single file"
    - "Dedicated namespace per scenario (k8s-trouble-*) for isolation and clean cleanup"
    - "mock-kubectl nested case statement: outer CMD switch, inner SCENARIO case"
    - "Hand-authored mock JSON following live kubectl output field shapes"
key_files:
  created:
    - infrastructure/scenarios/k8s/01-image-pull-backoff.yaml
    - infrastructure/scenarios/k8s/01-image-pull-backoff.md
    - infrastructure/scenarios/k8s/02-crashloop-backoff.yaml
    - infrastructure/scenarios/k8s/02-crashloop-backoff.md
    - infrastructure/scenarios/k8s/03-oom-killed.yaml
    - infrastructure/scenarios/k8s/03-oom-killed.md
    - infrastructure/scenarios/k8s/04-liveness-probe.yaml
    - infrastructure/scenarios/k8s/04-liveness-probe.md
    - infrastructure/scenarios/k8s/05-missing-secret.yaml
    - infrastructure/scenarios/k8s/05-missing-secret.md
    - infrastructure/scenarios/k8s/06-port-mismatch.yaml
    - infrastructure/scenarios/k8s/06-port-mismatch.md
    - infrastructure/scenarios/k8s/capture-mock-data.sh
    - infrastructure/mock-data/kubernetes/01-image-pull-get-pods.json
    - infrastructure/mock-data/kubernetes/01-image-pull-describe.txt
    - infrastructure/mock-data/kubernetes/02-crashloop2-get-pods.json
    - infrastructure/mock-data/kubernetes/02-crashloop2-describe.txt
    - infrastructure/mock-data/kubernetes/02-crashloop2-logs.txt
    - infrastructure/mock-data/kubernetes/03-oom-get-pods.json
    - infrastructure/mock-data/kubernetes/03-oom-describe.txt
    - infrastructure/mock-data/kubernetes/04-liveness-get-pods.json
    - infrastructure/mock-data/kubernetes/04-liveness-describe.txt
    - infrastructure/mock-data/kubernetes/05-missing-secret-get-pods.json
    - infrastructure/mock-data/kubernetes/05-missing-secret-describe.txt
    - infrastructure/mock-data/kubernetes/06-port-mismatch-get-pods.json
    - infrastructure/mock-data/kubernetes/06-port-mismatch-get-endpoints.json
  modified:
    - infrastructure/wrappers/mock-kubectl
decisions:
  - "OOM scenario uses python:3.12-alpine bytearray(64MB) not busybox dd — arm64/macOS Docker does not reliably trigger cgroup OOM kill with I/O-bound dd"
  - "CrashLoop mock SCENARIO name is crashloop2 not crashloop — avoids collision with Module 10 existing lab"
  - "Mock files hand-authored (KIND not available in execution environment) — capture-mock-data.sh is the canonical re-capture workflow"
  - "describe pod for port-mismatch uses existing fallthrough (pod is healthy — describe rarely needed for this scenario)"
  - "logs command mock only supports crashloop2 — other scenarios either cannot start (image-pull, missing-secret) or don't need log analysis"
metrics:
  duration: "10min"
  completed_date: "2026-04-07"
  tasks_completed: 2
  files_created: 28
---

# Phase 6 Plan 02: Broken-Pod Scenario Infrastructure Summary

6 baked KIND scenario manifests, 6 sibling scenario docs, extended mock-kubectl with 6 new HERMES_LAB_SCENARIO routes and 2 new commands (logs, get endpoints), 13 hand-authored mock JSON/txt parity files, and a capture-mock-data.sh live-capture script.

## Objective

Build the broken-pod scenario infrastructure for Phase 6's K8S-02 deliverable: 6 YAML manifests each producing a specific Kubernetes failure mode on KIND, with full mock-mode fallback for Udemy/offline learners.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Author 6 baked scenario YAML manifests + 6 sibling scenario .md docs | c9fa336 | 12 files in infrastructure/scenarios/k8s/ |
| 2 | Extend mock-kubectl wrapper, author capture-mock-data.sh, create mock JSON parity files | b03d1f5 | mock-kubectl, capture-mock-data.sh, 13 mock data files |

## Scenario Files Created

### YAML Manifests (infrastructure/scenarios/k8s/)

| File | Failure Mode | Namespace | Key Mechanism |
|------|-------------|-----------|---------------|
| 01-image-pull-backoff.yaml | ImagePullBackOff | k8s-trouble-image-pull | image: nonexistent-registry.io/fake-app:v1.0.0 |
| 02-crashloop-backoff.yaml | CrashLoopBackOff | k8s-trouble-crashloop | busybox exit 1 with "fatal: missing config" |
| 03-oom-killed.yaml | OOMKilled (exitCode 137) | k8s-trouble-oom | python:3.12-alpine bytearray(64MB) vs 32Mi limit |
| 04-liveness-probe.yaml | Liveness probe failure | k8s-trouble-liveness | livenessProbe.httpGet.port=9999 vs containerPort=80 |
| 05-missing-secret.yaml | CreateContainerConfigError | k8s-trouble-secret | secretName: app-credentials (not created) |
| 06-port-mismatch.yaml | No endpoints (Service layer) | k8s-trouble-port | Service targetPort=9090 vs containerPort=80 |

Each YAML starts with a Namespace document (D-15 compliance). Cleanup is `kubectl delete namespace <ns>`.

### Scenario Documentation (.md files)

Each sibling `.md` follows the 5-section structure from `infrastructure/scenarios/track-c-messy.md`:
- **Setup**: Live MODE (kubectl apply) + Mock mode (env var exports with :::info Solo Learner callout) + Cleanup
- **Context**: Alert text / narrative (what Kiran is paged about)
- **Expected Agent Behavior**: Numbered diagnostic steps with specific field references
- **Instructor Notes**: What to tell participants + anti-patterns to flag
- **Mock Data Files Used**: File list for capture-mock-data.sh reference

## mock-kubectl Extension

### Changes to infrastructure/wrappers/mock-kubectl

**Edit A — get pods case extended** from simple if/else to nested case:
```
image-pull)     -> 01-image-pull-get-pods.json
crashloop2)     -> 02-crashloop2-get-pods.json
oom)            -> 03-oom-get-pods.json
liveness)       -> 04-liveness-get-pods.json
missing-secret) -> 05-missing-secret-get-pods.json
port-mismatch)  -> 06-port-mismatch-get-pods.json
messy|crashloop) -> get-pods-crashloop.json  (PRESERVED — Module 10 unchanged)
*)              -> get-pods-healthy.json      (PRESERVED — clean scenario unchanged)
```

**Edit B — describe pod case extended** from inline printf to file-dispatch for 5 new scenarios. The `*)` fallthrough preserves ALL existing printf lines verbatim (Module 10 messy/crashloop describe unchanged).

**Edit C — NEW `logs *` command** added before catch-all:
```
crashloop2) -> 02-crashloop2-logs.txt
*)          -> error exit 1 (not supported for other scenarios)
```

**Edit D — NEW `get endpoints` command** added:
```
port-mismatch) -> 06-port-mismatch-get-endpoints.json
*)             -> empty EndpointsList JSON
```

**Edit E — catch-all error message** updated to list new mocks.

### Regression Verification
- `HERMES_LAB_SCENARIO=messy` still returns `api-deployment-def456` (Module 10 safe)
- `HERMES_LAB_SCENARIO=crashloop` still returns `api-deployment-def456` (Module 10 safe)
- `HERMES_LAB_SCENARIO=clean` still returns `get-pods-healthy.json` (baseline unchanged)

## Mock Data Files

### Field Shape Requirements (from RESEARCH.md Failure Mode Kubectl Output Reference)

| File | Required Fields Present |
|------|------------------------|
| 01-image-pull-get-pods.json | state.waiting.reason="ImagePullBackOff", spec.containers[0].image="nonexistent-registry.io/..." |
| 01-image-pull-describe.txt | Events: "Failed to pull image" + "ImagePullBackOff" |
| 02-crashloop2-get-pods.json | state.waiting.reason="CrashLoopBackOff", lastState.terminated.exitCode=1, restartCount=5 |
| 02-crashloop2-describe.txt | Last State: Terminated, Reason: Error, Exit Code: 1 |
| 02-crashloop2-logs.txt | "starting...\nfatal: missing config\n" |
| 03-oom-get-pods.json | lastState.terminated.reason="OOMKilled", exitCode=137, resources.limits.memory="32Mi" |
| 03-oom-describe.txt | Last State: Terminated, Reason: OOMKilled, Exit Code: 137 |
| 04-liveness-get-pods.json | state.waiting.reason="CrashLoopBackOff", livenessProbe.httpGet.port=9999, containerPort=80 |
| 04-liveness-describe.txt | Events: "Liveness probe failed" on port 9999, "Container app failed liveness probe, will be restarted" |
| 05-missing-secret-get-pods.json | status.phase="Pending", state.waiting.reason="CreateContainerConfigError" |
| 05-missing-secret-describe.txt | Events: "MountVolume.SetUp failed" + "secret 'app-credentials' not found" |
| 06-port-mismatch-get-pods.json | status.phase="Running", containerStatuses[0].ready=true (pod is healthy) |
| 06-port-mismatch-get-endpoints.json | EndpointsList with subsets=[] (no backend endpoints) |

### Hand-Authored vs Live Capture

Mock files were hand-authored in this execution (KIND not available in agent execution environment). The `capture-mock-data.sh` script is the canonical source for re-generating them from a live cluster and should be used before course delivery to ensure field shapes match actual KIND output.

## capture-mock-data.sh

Script at `infrastructure/scenarios/k8s/capture-mock-data.sh`:
- Validates kubectl and cluster connectivity before starting
- Uses `wait_for_state()` function with configurable timeout (prevents premature capture before failure state is reached)
- Captures pods JSON + describe text for all 6 scenarios
- Captures logs (scenario 2) and endpoints (scenario 6) for scenarios needing extra commands
- Saves all files to `infrastructure/mock-data/kubernetes/` with `NN-prefix` naming
- Does NOT auto-cleanup — leaves namespaces for manual inspection

## Deviations from Plan

### Auto-fixed Issues

None — plan executed exactly as written.

### Decisions Made During Execution

**1. OOM scenario — Python bytearray (planned)**
- Used `python:3.12-alpine` with `bytearray(64 * 1024 * 1024)` as specified in RESEARCH Pitfall 4
- Explicitly documented in 03-oom-killed.md Instructor Notes (arm64/Apple Silicon note)

**2. crashloop2 SCENARIO name (planned)**
- Used `HERMES_LAB_SCENARIO=crashloop2` not `crashloop` to avoid Module 10 collision
- Documented in both 02-crashloop-backoff.md Setup section and Instructor Notes

**3. Hand-authored mock files**
- KIND not available in agent execution environment
- All 13 files authored with correct field shapes per RESEARCH.md "Failure Mode Kubectl Output Reference"
- capture-mock-data.sh provides the canonical re-capture path for course delivery prep

**4. describe pod for port-mismatch**
- port-mismatch pod is Running/Ready — describe pod is rarely needed in this scenario
- Falls through to existing inline printf describe (the failure surfaces only via endpoints)
- 05-missing-secret-describe.txt created for the missing-secret scenario (pod is Pending, describe events are critical)

## Known Stubs

None — all mock files contain real field shapes matching the required failure modes. No placeholder content.

## Self-Check: PASSED

### Files verified on disk:
All 27 created/modified files exist and are non-empty.

### Commits verified:
- c9fa336: feat(06-02): add 6 baked K8s scenario YAML manifests and sibling scenario docs
- b03d1f5: feat(06-02): extend mock-kubectl with 6 new scenarios, add capture script and 13 mock data files

### Self-Check result: PASSED
