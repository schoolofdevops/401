---
phase: quick
plan: 260408-v6c
type: summary
status: complete
---

# Quick Task 260408-v6c: Summary

## Bug (continuation of 260408-ueh)

The previous fix (260408-ueh) added symlinks and fixed the wrapper's live-mode
passthrough. That made `kubectl` → wrapper work **in the outer shell** where the
learner typed `export PATH=...`. But when Hermes spawns its terminal tool as
`bash -lic` (login + interactive), login-shell startup rebuilds PATH via macOS
`path_helper` + the user's `~/.bash_profile` PATH mutations (conda, cargo,
rancher, deno, etc.), and the wrapper directory gets demoted to the tail of
PATH. Inside Hermes, `kubectl` resolves to `/usr/local/bin/kubectl` and hits
the real KIND cluster.

## Why the symlink fix alone wasn't enough

- `subprocess.Popen(env=run_env)` passes the wrapper PATH to bash at process
  start — but bash's `-l` flag then runs `/etc/profile`, which calls
  `/usr/libexec/path_helper` and rebuilds PATH from `/etc/paths` + `/etc/paths.d/*`
- Then `~/.bash_profile` prepends conda, cargo, rancher, deno paths
- The wrapper directory from the initial env ends up at the tail of PATH
- `which kubectl` → `/usr/local/bin/kubectl` (real binary)

Verified with a direct test: `env PATH="$wrapper:..." bash -lic 'which kubectl'`
returns `/usr/local/bin/kubectl`, not the wrapper.

## Fix: bash aliases in `~/.bash_profile`

Aliases survive login-shell PATH rewrites because they're defined by the shell
itself, not by the `PATH` environment variable. Added this block to
`~/.bash_profile`:

```bash
# ── Hermes DevOps Course lab wrapper aliases ─────────────────────────
if [ -n "${HERMES_LAB_WRAPPERS:-}" ] && [ -d "$HERMES_LAB_WRAPPERS" ]; then
  shopt -s expand_aliases
  alias kubectl="$HERMES_LAB_WRAPPERS/mock-kubectl"
  alias aws="$HERMES_LAB_WRAPPERS/mock-aws"
  alias psql="$HERMES_LAB_WRAPPERS/mock-psql"
fi
```

The block is gated by `HERMES_LAB_WRAPPERS` so it only activates for lab
sessions. Learners set that env var before launching `hermes chat`, and the
alias block auto-configures inside Hermes's bash subshell.

Points directly at `mock-kubectl`/`mock-aws`/`mock-psql` (not the
`kubectl`/`aws`/`psql` symlinks from task 260408-ueh) so the setup works on
Windows Git Bash even when `git config core.symlinks=true` is not set.

## Cross-platform instructions added to `setup.mdx`

New section **Step 5: Lab Wrapper Aliases (One-Time Setup)** covers:

1. **Why** the setup is needed (login-shell PATH rewrite explanation)
2. **macOS / Linux / WSL2** instructions — add block to `~/.bash_profile`, export
   `HERMES_LAB_WRAPPERS` per session
3. **Windows Git Bash** instructions — same alias block + `git config core.symlinks=true`
   + optional `HERMES_GIT_BASH_PATH`
4. **zsh callout** — explicit note that the block goes in `~/.bash_profile`
   regardless of your login shell, because Hermes always spawns bash
5. **Verification inside a Hermes session** — a concrete `type kubectl` +
   `kubectl get pods` test that confirms the alias is live
6. **Troubleshooting** — 4 common failure modes with fixes

## Files Changed

| File | Change |
|---|---|
| `~/.bash_profile` (user's personal, not in repo) | Added the alias block (done on Gourav's machine) |
| `course-site/docs/setup.mdx` | New "Step 5: Lab Wrapper Aliases" section with Mac/Linux/WSL2/Git Bash instructions |
| `course-site/docs/module-07-agent-skills/lab/LAB-track-c-kubernetes.mdx` | Prerequisite block now exports `HERMES_LAB_WRAPPERS`; added link to Setup Step 5 |
| `course-site/docs/module-08-tool-integration/lab/LAB-track-c-kubernetes.mdx` | Same fix |
| `course-site/docs/module-10-domain-agent/lab/LAB-track-c-kubernetes.mdx` | Same fix |
| `course-site/docs/module-13-governance/lab/LAB-track-c-kubernetes.mdx` | All 4 env blocks (L2 Step 5 + 3× L4 in Steps 9/10/12) now export `HERMES_LAB_WRAPPERS`; verification check #8 rewritten to invoke `mock-kubectl` directly via relative path (portable) |
| `course-site/docs/module-13-governance/lab/LAB.mdx` | Verification check #8 rewritten same way |

## Verification

```
# End-to-end test: simulate zsh → hermes → bash -lic chain
$ zsh -c '
    cd /Users/gshah/work/agentic/devops/course
    export HERMES_LAB_WRAPPERS="$(pwd)/infrastructure/wrappers"
    export HERMES_LAB_MODE=mock HERMES_LAB_SCENARIO=clean
    export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
    bash -lic "type kubectl; kubectl get pods 2>&1 | head -5"
  '
kubectl is aliased to `.../infrastructure/wrappers/mock-kubectl'          ✓
╔══════════════════════════════════════════╗
║            [ MOCK MODE ]                 ║                              ✓
║   Data source: pre-baked JSON files      ║
...

# Live mode passthrough still works (no infinite loop, no MOCK banner)
$ HERMES_LAB_WRAPPERS=... HERMES_LAB_MODE=live bash -lic 'kubectl version --client'
Client Version: v1.32.3                                                   ✓
Kustomize Version: v5.5.0

# Scenario switching
$ HERMES_LAB_SCENARIO=crashloop2 ... bash -lic 'kubectl get pods | grep reason'
"reason": "CrashLoopBackOff"                                              ✓

# Docusaurus build
[SUCCESS] Generated static files in "build".                              ✓
```

## Impact

- **Mock mode now works end-to-end inside Hermes** for all Track C labs (Modules 7, 8, 10, 13)
- **Scenario switching works** — Kiran can exercise all 6 failure modes against mock data
- **Module 13 governance tests work** — `kubectl delete pod foo` inside the agent now hits the `wrapper_allowlist.kubectl` rejection banner instead of the real cluster
- **Cross-platform support documented** — macOS, Linux, WSL2, Windows Git Bash
- **Hermes source untouched** — the fix lives in course content + user's `~/.bash_profile`, nothing upstream

## Scope Boundary

- Touched: `~/.bash_profile` (local), `course-site/docs/setup.mdx`, 6 Track C/unified lab files
- NOT touched: Hermes source code, `modules/` source files, Track A/B primary prerequisite blocks (they still need the same fix but are out of scope for the Track C-focused work Gourav is doing now)

## Deferred

- Track A and Track B primary labs (Module 10 A/B) still have the old `export PATH=...wrappers` approach. They'll need the same alias fix applied before other learners try those tracks. Tracked as a follow-up.
- Module 11 (Fleet) and Module 12 (Triggers) env blocks still have the old PATH approach. Same follow-up.
