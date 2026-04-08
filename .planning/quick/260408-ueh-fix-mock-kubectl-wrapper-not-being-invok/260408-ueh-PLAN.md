---
phase: quick
plan: 260408-ueh
type: execute
wave: 1
files_modified:
  - infrastructure/wrappers/mock-kubectl
  - infrastructure/wrappers/mock-aws
  - infrastructure/wrappers/mock-psql
  - infrastructure/wrappers/kubectl
  - infrastructure/wrappers/aws
  - infrastructure/wrappers/psql
autonomous: false
---

<root_cause>
The wrapper scripts are named `mock-kubectl`, `mock-aws`, `mock-psql`. When learners follow the
lab instructions to `export PATH="$(pwd)/infrastructure/wrappers:$PATH"` and then invoke
`kubectl get pods` (as Kiran does via SKILL.md Phase 1 commands), the shell searches PATH for a
binary named `kubectl` — finds NONE in the wrapper dir — and falls through to the real
`/usr/local/bin/kubectl`. The wrapper is NEVER invoked. Every mock-mode learner has been silently
hitting the real kubectl binary. If they have a KIND cluster running, they see real pod data
(not scenario mock data); if they don't, they see connection errors.

Confirmed by running:
  export PATH="$(pwd)/infrastructure/wrappers:$PATH"
  which kubectl
  # Returns: /usr/local/bin/kubectl  (NOT the wrapper)

The Module 7 Track C lab's own verification command (`which mock-kubectl`) confirms the wrapper
exists — but no learner ever calls `mock-kubectl` explicitly. They all call `kubectl`.

Additionally, the wrappers' live-mode passthrough uses:
  exec "$(command -v kubectl)" "$@"
which would create an infinite loop the moment we symlink `kubectl -> mock-kubectl` (because
`command -v kubectl` would find the symlink first).
</root_cause>

<objective>
Make `kubectl`, `aws`, and `psql` resolve to the mock wrappers when the wrapper dir is first in
PATH, while preserving the live-mode passthrough to the real binaries when `HERMES_LAB_MODE=live`.

Scope: fix the wrapper infrastructure, not the lab content. Labs already say `export PATH=...`
and `which kubectl` — those instructions become correct once this fix is in place.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Create kubectl/aws/psql entrypoints in wrapper dir</name>
  <files>infrastructure/wrappers/kubectl, infrastructure/wrappers/aws, infrastructure/wrappers/psql</files>
  <action>
Create three symlinks in `infrastructure/wrappers/`:
- `kubectl` → `mock-kubectl`
- `aws` → `mock-aws`
- `psql` → `mock-psql`

Use `ln -s` (symlinks, not copies) so future edits to the mock-* scripts are picked up automatically.
Ensure both the symlinks and the originals remain executable.
  </action>
  <verify>
    <automated>
test -L infrastructure/wrappers/kubectl && readlink infrastructure/wrappers/kubectl
test -L infrastructure/wrappers/aws && readlink infrastructure/wrappers/aws
test -L infrastructure/wrappers/psql && readlink infrastructure/wrappers/psql
    </automated>
  </verify>
</task>

<task type="auto">
  <name>Task 2: Fix live-mode passthrough in all three wrappers to avoid infinite loop</name>
  <files>infrastructure/wrappers/mock-kubectl, infrastructure/wrappers/mock-aws, infrastructure/wrappers/mock-psql</files>
  <action>
In each mock-* wrapper, replace the live-mode passthrough:

OLD:
```bash
if [[ "$LAB_MODE" != "mock" ]]; then
  exec "$(command -v kubectl)" "$@"
fi
```

NEW (strips the wrapper dir from PATH before searching, to avoid finding itself):
```bash
if [[ "$LAB_MODE" != "mock" ]]; then
  # Find real <tool> by searching PATH, excluding our own directory,
  # so the symlink `<tool> -> mock-<tool>` doesn't create an infinite loop.
  WRAPPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REAL_BIN=""
  IFS=':' read -ra _PATH_PARTS <<< "$PATH"
  for _dir in "${_PATH_PARTS[@]}"; do
    [[ "$_dir" == "$WRAPPER_DIR" ]] && continue
    if [[ -x "$_dir/<tool>" ]]; then
      REAL_BIN="$_dir/<tool>"
      break
    fi
  done
  if [[ -z "$REAL_BIN" ]]; then
    printf 'ERROR: real <tool> not found in PATH (excluding wrapper dir)\n' >&2
    exit 127
  fi
  exec "$REAL_BIN" "$@"
fi
```

Substitute `<tool>` with `kubectl`, `aws`, or `psql` respectively in each file.
  </action>
  <verify>
    <automated>
# All three wrappers should contain the new WRAPPER_DIR pattern
grep -l 'WRAPPER_DIR=' infrastructure/wrappers/mock-kubectl infrastructure/wrappers/mock-aws infrastructure/wrappers/mock-psql
# None should still have the bare command -v pattern
! grep -q 'exec "\$(command -v kubectl)"' infrastructure/wrappers/mock-kubectl
! grep -q 'exec "\$(command -v aws)"' infrastructure/wrappers/mock-aws
! grep -q 'exec "\$(command -v psql)"' infrastructure/wrappers/mock-psql
    </automated>
  </verify>
</task>

<task type="auto">
  <name>Task 3: End-to-end test — mock mode interception</name>
  <action>
Run a sequence of commands that mirror what Kiran does in Module 10 Track C Step 2-3:

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=clean
export HERMES_LAB_TRACK=track-c
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"

# 1. `which kubectl` must now return the wrapper path
which kubectl
# Expected: .../infrastructure/wrappers/kubectl

# 2. `kubectl get pods` must return mock data (get-pods-healthy.json for SCENARIO=clean)
kubectl get pods 2>&1 | head -5
# Expected: MOCK MODE banner, then JSON content from get-pods-healthy.json

# 3. Scenario switch must work
HERMES_LAB_SCENARIO=crashloop2 kubectl get pods 2>&1 | head -5
# Expected: MOCK MODE banner, then JSON content from 02-crashloop2-get-pods.json

HERMES_LAB_SCENARIO=oom kubectl get pods 2>&1 | head -5
# Expected: MOCK MODE banner, then JSON content from 03-oom-get-pods.json

HERMES_LAB_SCENARIO=image-pull kubectl get pods 2>&1 | head -5
# Expected: MOCK MODE banner, then JSON content from 01-image-pull-get-pods.json

# 4. describe pod for a specific scenario
HERMES_LAB_SCENARIO=oom kubectl describe pod api-deployment-def456 2>&1 | head -5
# Expected: MOCK MODE banner, then text content from 03-oom-describe.txt

# 5. Live mode must still pass through (don't test this with a real cluster, just verify no loop)
HERMES_LAB_MODE=live timeout 5 kubectl version --client 2>&1 | head -3
# Expected: Real kubectl client version output (or kubectl not found message — NOT infinite loop)
```

Report the actual output for each check.
  </action>
</task>

<task type="auto">
  <name>Task 4: Write SUMMARY.md and update STATE.md</name>
  <files>.planning/quick/260408-ueh-fix-mock-kubectl-wrapper-not-being-invok/260408-ueh-SUMMARY.md, .planning/STATE.md</files>
</task>

</tasks>

<success_criteria>
- `which kubectl` returns the wrapper path when the wrapper dir is first in PATH
- `kubectl get pods` with HERMES_LAB_MODE=mock returns mock scenario data (MOCK MODE banner + correct JSON)
- Scenario switching works (crashloop2, oom, image-pull, etc. return the corresponding fixture)
- Live mode passthrough still works (no infinite loop)
- `aws` and `psql` symlinks work the same way (verify for kubectl only, aws/psql are identical fix)
</success_criteria>
