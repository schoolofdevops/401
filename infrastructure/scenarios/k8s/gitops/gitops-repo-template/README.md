# Hermes Fleet Fixes — Sample GitOps Repo

This is a template README for the participant-facing GitOps repo used in Phase 9 FLEET-01 Path B.

**This directory is NOT a functioning git repo inside the course repo.** It is a template to copy
when you initialize your own GitOps repo (either locally or on GitHub).

## How to initialize your GitOps repo

**Option A — GitHub repo (primary for live workshop):**

```bash
# Create a new GitHub repo named "hermes-fleet-fixes" (or similar) in the GitHub UI, then:
mkdir ~/hermes-fleet-fixes && cd ~/hermes-fleet-fixes
git init
git remote add origin git@github.com:<your-user>/hermes-fleet-fixes.git
cp /path/to/course/infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md ./README.md
cp /path/to/course/infrastructure/scenarios/k8s/gitops/memory-patch.yaml ./memory-patch.yaml
git add . && git commit -m "chore: bootstrap GitOps repo"
git branch -M main && git push -u origin main
export GITOPS_REPO_URL="https://github.com/<your-user>/hermes-fleet-fixes"
export GITOPS_BRANCH_PREFIX="hermes-fix-"
```

**Option B — Local-only repo (Solo Learner callout, no GitHub push):**

```bash
mkdir ~/hermes-fleet-fixes && cd ~/hermes-fleet-fixes
git init
cp /path/to/course/infrastructure/scenarios/k8s/gitops/memory-patch.yaml ./memory-patch.yaml
git add . && git commit -m "chore: bootstrap local GitOps repo"
# Skip git remote / gh pr create — use git log to inspect "PR" branches instead.
export GITOPS_REPO_URL="file://$HOME/hermes-fleet-fixes"
export GITOPS_BRANCH_PREFIX="hermes-fix-"
```

## What the Track C specialist does

When Morgan re-delegates to Track C for Path B, the specialist agent (using its terminal
toolset, which it inherits from Morgan per the Phase 9 toolset fix):

1. `cd ~/hermes-fleet-fixes` (the local checkout of the GitOps repo)
2. `git checkout -b ${GITOPS_BRANCH_PREFIX}$(date +%s)` (e.g., `hermes-fix-1712534400`)
3. Writes the generated `memory-patch.yaml` at the repo root
4. `git add memory-patch.yaml && git commit -m "fix: increase crasher memory limit"`
5. `git push origin HEAD` (skipped in Option B)
6. `gh pr create --title "fix: increase crasher memory limit" --body "..." --base main` (skipped in Option B)
7. Posts the PR URL back to Telegram via its final message (delivered via `deliver: telegram`)

Note: `gh pr create` is a direct terminal tool call — Hermes has no `_deliver_github_pr` method.
The specialist invokes `gh` directly from its terminal toolset.

After the participant merges the PR in GitHub UI (or in Option B, inspects and merges locally),
they run `bash infrastructure/scenarios/k8s/gitops/apply.sh` to sync the manifest to KIND.
