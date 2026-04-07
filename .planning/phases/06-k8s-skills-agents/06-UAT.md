---
status: testing
phase: 06-k8s-skills-agents
source: [06-01-SUMMARY.md, 06-02-SUMMARY.md, 06-03-SUMMARY.md]
started: 2026-04-07T08:30:00Z
updated: 2026-04-07T08:30:00Z
---

## Current Test

number: 1
name: Primary K8s diagnostic skill content
expected: |
  Open `skills/sre-k8s-pod-health/SKILL.md`. The file should be ~287 lines, structured as a twin of `skills/sre-ec2-health-check/SKILL.md`.

  You should see these sections in order:
  - YAML frontmatter (name, description, version, compatibility, hermes metadata)
  - `## When to Use`
  - `## Inputs` (table)
  - `## Prerequisites`
  - `### Phase 1: Gather ... [SCRIPTS ZONE — deterministic]` with 6 kubectl commands (get pods, describe pod, logs, top, get endpoints, get events)
  - `### Phase 2: Interpret and Decide [AGENTS ZONE — reasoning]` with 7 decision branches (ImagePullBackOff, CrashLoopBackOff, OOMKilled, Liveness Probe, CreateContainerConfigError/missing secret, Port Mismatch, No active issue)
  - `## Escalation Rules`
  - `## NEVER DO` (5 rules including a prompt injection guard)
  - `## Rollback Procedure`
  - `## Verification` (checkbox list)

  Quick check: `grep -c "^### Decision Branch\|^### Phase\|^## " skills/sre-k8s-pod-health/SKILL.md` should show the K8s sections. `grep -i "ec2\|cloudwatch\|i-0123" skills/sre-k8s-pod-health/SKILL.md` should return nothing (zero EC2 vocabulary).
awaiting: user response

## Tests

### 1. Primary K8s diagnostic skill content
expected: |
  Open `skills/sre-k8s-pod-health/SKILL.md`. ~287 lines, structural twin of EC2 skill, 6 kubectl commands in Phase 1, 7 decision branches in Phase 2 (one per K8S-02 failure mode + "no issue"), zero EC2 vocabulary.
result: [pending]

### 2. Addon scaffold with participant extension markers
expected: |
  Open `skills/sre-k8s-node-health/SKILL.md`. ~167 lines. Complete YAML frontmatter and Phase 1 with 4 kubectl commands (get nodes, describe node, top nodes, get pods --field-selector). Phase 2 contains an HTML comment block with `<!-- PARTICIPANT EXTENSION POINT -->` markers and 4 TODO branches (NotReady, MemoryPressure, DiskPressure, PIDPressure). NEVER DO section has 5 rules. This is the natural extension exercise for Module 7 lab participants.
result: [pending]

### 3. OOM scenario manifest uses Apple-Silicon-safe pattern
expected: |
  Open `infrastructure/scenarios/k8s/03-oom-killed.yaml`. The file is multi-document YAML starting with a `kind: Namespace` named `k8s-trouble-oom`, then a Deployment that uses `image: python:3.12-alpine` running a command that allocates `bytearray(64 * 1024 * 1024)` (64 MB) against `resources.limits.memory: 32Mi`. This pattern reliably triggers cgroup OOM kill on arm64/macOS Docker, unlike `busybox dd` which is unreliable on Apple Silicon.
result: [pending]

### 4. Scenario .md doc structure
expected: |
  Open `infrastructure/scenarios/k8s/01-image-pull-backoff.md`. Five sections present: Setup (with both `kubectl apply -f` live mode AND a `:::info Solo Learner` callout for mock mode env vars + cleanup command), Context (PagerDuty-style alert narrative), Expected Agent Behavior (numbered diagnostic steps citing exact field references like `state.waiting.reason`), Instructor Notes (what to tell participants + anti-patterns), Mock Data Files Used (file list).
result: [pending]

### 5. mock-kubectl backward compatibility (Module 10 not broken)
expected: |
  Run: `HERMES_LAB_MODE=mock HERMES_LAB_SCENARIO=crashloop infrastructure/wrappers/mock-kubectl get pods`

  Output should contain `api-deployment-def456` (the existing Module 10 messy/crashloop scenario data from `get-pods-crashloop.json`). This proves Phase 6 did NOT break the existing Module 10 lab — the old `crashloop` SCENARIO value still routes correctly. Phase 6 used `crashloop2` for its new scenario to avoid this collision.
result: [pending]

### 6. mock-kubectl new K8S-02 scenario routing
expected: |
  Run: `HERMES_LAB_MODE=mock HERMES_LAB_SCENARIO=image-pull infrastructure/wrappers/mock-kubectl get pods`

  Output should be valid JSON containing `"reason": "ImagePullBackOff"` and `"image": "nonexistent-registry.io/...` — proving the new ImagePullBackOff mock data is correctly routed when the new SCENARIO value is set. Repeat for `oom`, `liveness`, `missing-secret`, `port-mismatch`, `crashloop2` to verify all 6 new routes work.
result: [pending]

### 7. Kiran agent profile rebuilt with K8s skill
expected: |
  Run: `ls agents/track-c-kubernetes/skills/`

  Output should show ONLY `sre-k8s-pod-health` directory. The `sre-ec2-health-check` directory should be DELETED (no longer present in the K8s agent profile). Run `cat agents/track-c-kubernetes/skills/sre-k8s-pod-health/SKILL.md | head -3` — it should match the canonical skill at `skills/sre-k8s-pod-health/SKILL.md` (byte-identical, both md5 to `3b90bc92ec27674ed093dfd6fb3260bf`).
result: [pending]

### 8. Kiran SOUL.md light edit (3 changes only)
expected: |
  Open `agents/track-c-kubernetes/SOUL.md`. The file should be ~42 lines (was 31). Three targeted changes are visible:

  1. An explicit reference to the `sre-k8s-pod-health` skill in the Identity section
  2. A new NEVER rule covering kubectl exec / kubectl edit / kubectl patch / kubectl apply (write-action commands)
  3. Escalation Policy expanded to enumerate the 6 K8S-02 failure modes by name (ImagePullBackOff, CrashLoopBackOff, OOMKilled, liveness probe failure, missing secret, port mismatch)

  The original Identity statement, original 4 NEVER rules (kubectl delete, drain, cordon, resource-limit modifications), and Behavior Rules section should still be intact — this was a light edit, not a rewrite.
result: [pending]

### 9. Module 10 lab "cross-domain teaching moment" rationalization removed
expected: |
  Open `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` and search around line 150-166. The original `:::info Cross-domain skill — teaching moment` admonition (which used to apologize for Kiran shipping with the EC2 skill) should be GONE. In its place: a `:::tip` admonition with positive language describing that Kiran ships with the new `sre-k8s-pod-health` skill matching its domain.

  Also verify: the expected `ls ~/.hermes/profiles/track-c/skills/` outputs throughout the lab now show `sre-k8s-pod-health/` (not `sre-ec2-health-check/`). At least 3 such ls expected-output blocks should be updated.

  Run: `grep -c "sre-ec2-health-check" course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` → should return 0.
result: [pending]

### 10. Phase 7 boundary preserved + EC2 skill at canonical root preserved
expected: |
  Two negative checks:

  1. `grep -q 'command_allowlist: \[\]' agents/track-c-kubernetes/config.yaml && echo "preserved"` → should print `preserved`. Phase 6 explicitly does NOT touch the empty allowlist — that's Phase 7 / GOV-01 territory.

  2. `test -f skills/sre-ec2-health-check/SKILL.md && echo "preserved"` → should print `preserved`. The canonical EC2 skill at the repo root is INTENTIONALLY kept because Track B (FinOps) reuses it. Phase 6 only deleted the *misattached profile copies* in `agents/track-c-kubernetes/skills/` and `modules/module-10-agents/solution/track-c/skills/`.

  Together these confirm Phase 6 stayed within its scope and didn't break Track B.
result: [pending]

## Summary

total: 10
passed: 0
issues: 0
pending: 10
skipped: 0
blocked: 0

## Gaps

[none yet]
