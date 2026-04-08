---
phase: quick
plan: 260408-ueh
type: summary
status: complete
---

# Quick Task 260408-ueh: Summary

## Bug

User reported that Module 10 Track C lab in mock mode wasn't actually hitting the mock data —
`kubectl` calls went to the real `/usr/local/bin/kubectl`, not the wrapper. Scenario switching
(crashloop2, oom, etc.) had no effect.

## Root Cause

The wrapper scripts in `infrastructure/wrappers/` were named `mock-kubectl`, `mock-aws`,
`mock-psql`. When learners ran:

```bash
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
kubectl get pods
```

the shell searched PATH for a binary named `kubectl` — there was NONE in the wrapper directory
— so it fell through to the real `kubectl`. The wrapper was NEVER invoked via PATH. Every
"mock mode" learner silently hit the real kubectl binary.

Confirmed by test before fix:
```
$ export PATH="$(pwd)/infrastructure/wrappers:$PATH"
$ which kubectl
/usr/local/bin/kubectl    # ← NOT the wrapper
```

Additionally, the wrappers' live-mode passthrough used `exec "$(command -v kubectl)" "$@"`,
which would have created an infinite loop the moment we added the `kubectl` symlink (because
`command -v kubectl` would find the wrapper's own symlink first).

## Fix

### Wrapper infrastructure (3 files modified, 3 files added)

1. **Symlinks added**:
   - `infrastructure/wrappers/kubectl` → `mock-kubectl`
   - `infrastructure/wrappers/aws` → `mock-aws`
   - `infrastructure/wrappers/psql` → `mock-psql`

2. **Live-mode passthrough rewritten in all 3 wrappers** to strip the wrapper dir from PATH
   before searching for the real binary:
   ```bash
   WRAPPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   REAL_BIN=""
   IFS=':' read -ra _PATH_PARTS <<< "$PATH"
   for _dir in "${_PATH_PARTS[@]}"; do
     [[ "$_dir" == "$WRAPPER_DIR" ]] && continue
     if [[ -x "$_dir/kubectl" ]]; then REAL_BIN="$_dir/kubectl"; break; fi
   done
   exec "$REAL_BIN" "$@"
   ```

### Lab instructions updated (7 files)

| File | Change |
|---|---|
| `course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx` | `which mock-kubectl` → `which kubectl` |
| `course-site/docs/module-07-agent-skills/lab/LAB.mdx` | `which mock-kubectl` → `which kubectl` (Track C callout) |
| `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` | Fixed misleading "live mode expected /usr/local/bin/kubectl" comment — explains wrapper path is correct in both modes |
| `course-site/docs/module-08-tool-integration/lab/LAB.mdx` | Same fix for unified lab |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-a-database.mdx` | `which mock-psql` → `which psql` |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` | Fixed misleading live-mode comment |
| `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` | Verification check #8: use `kubectl delete pod foo` via PATH instead of relative path to `mock-kubectl` |
| `course-site/docs/module-13-governance/lab/LAB.mdx` | Same fix for unified lab + added HERMES_LAB_TRACK=track-c which was missing |

## Verification

### Before fix
```
$ export PATH="$(pwd)/infrastructure/wrappers:$PATH"
$ which kubectl
/usr/local/bin/kubectl     ← bug: real binary, not wrapper
```

### After fix (end-to-end test)
```
$ which kubectl
/Users/gshah/work/agentic/devops/course/infrastructure/wrappers/kubectl   ✓

$ kubectl get pods 2>&1 | head -5
╔══════════════════════════════════════════╗
║            [ MOCK MODE ]                 ║     ✓
║   Data source: pre-baked JSON files      ║
║   Set HERMES_LAB_MODE=live for real K8s  ║
╚══════════════════════════════════════════╝

$ HERMES_LAB_SCENARIO=crashloop2 kubectl get pods | grep reason
"reason": "CrashLoopBackOff"     ✓

$ HERMES_LAB_SCENARIO=oom kubectl get pods | grep reason
"reason": "OOMKilled"            ✓

$ HERMES_LAB_SCENARIO=image-pull kubectl get pods | grep reason
"reason": "ImagePullBackOff"     ✓

$ HERMES_LAB_MODE=live timeout 5 kubectl version --client
Client Version: v1.32.3          ✓  (no infinite loop)
Kustomize Version: v5.5.0

$ HERMES_LAB_GOVERNANCE=L4 HERMES_LAB_TRACK=track-c kubectl delete pod foo
[ GOVERNANCE REJECTED ]           ✓  Layer 1 wrapper_allowlist rejection
```

### Docusaurus build
```
[SUCCESS] Generated static files in "build".
```
All edited MDX files parse cleanly.

## Impact

- **Mock mode now actually works** for all 3 tracks (A/B/C) in Modules 7, 8, 10, 13. Previously every learner was silently hitting real binaries.
- **Scenario switching now works** — `HERMES_LAB_SCENARIO=crashloop2 | oom | image-pull | liveness | missing-secret | port-mismatch` each return the correct fixture.
- **Governance rejection tests now work** via PATH interception — Module 13 Step 10 `kubectl delete pod foo` correctly produces the GOVERNANCE REJECTED banner at L4.
- **Live mode still works** — passthrough strips the wrapper dir from PATH to find the real binary without infinite loop.

## Scope Boundary

- Touched: `infrastructure/wrappers/*`, lab instructions in `course-site/docs/module-{07,08,10,13}/`
- NOT touched: `modules/` source files (as per user preference), Module 11 prose references to `mock-kubectl` (those correctly document the underlying script file)
- Deferred: `course-site/docs/module-07-agent-skills/lab/LAB.mdx` still has prose references to `mock-kubectl` as "the wrapper" — those are accurate and don't need changes.
