# Module 11 Lab: Fleet Orchestration — Live FLEET-01 Incident Response

**Duration:** ~135 minutes (90 min guided + 45 min free explore)
**Track:** Fleet — Live incident response chain on KIND
**Prerequisites:**
- Module 6 complete — KIND cluster running with Phase 6 crashloop2 scenario applied
- Module 12 complete — Phase 8 AlertManager + Telegram bot working
- Module 13 complete — Phase 7 L4 governance understood
- Morgan profile installed at `~/.hermes/profiles/fleet/` (Plan 01 updated toolset)
- Track C profile installed at `~/.hermes/profiles/track-c/`

**Outcome:** An end-to-end automated incident response chain running LIVE on your KIND cluster:
AlertManager fires → Morgan (fleet profile) triages → Track C specialist diagnoses with sre-k8s-pod-health
→ Morgan synthesizes + proposes fix → Telegram approval → Track C re-delegated at L4 → kubectl apply
succeeds. You will observe every handoff in the gateway logs. You will also walk the Path B production
upgrade path where the fix flows through a GitHub PR instead of direct apply.

> **SOLO LEARNER PATH (Udemy / self-paced)**
>
> The full live chain requires a Telegram bot (Phase 8 setup) and a running KIND cluster with
> AlertManager. If either is not available, set `HERMES_LAB_MODE=mock` and follow the Solo Learner
> callouts embedded at each step — they walk you through the equivalent mock-mode commands. You
> will see the same delegation → synthesis → proposal → approval flow without live infrastructure.

> **LIVE WORKSHOP VARIANT (Instructor-led)**
>
> In a live workshop, the instructor typically demos Steps 1-5 on a shared screen (setting up
> Morgan + subscribing the webhook), then each team member runs Steps 6-11 on their own cluster
> to observe Morgan's behavior. The lab steps are identical for both modes.

---

## GUIDED PHASE — 90 minutes

---

## Step 1: Prerequisites and Complete Environment Export (10 min)

Before starting the gateway, export all environment variables at the root of your course directory.
This is the single canonical export block for the entire lab — every subsequent step assumes
these values are set. Phase 9 adds `GITOPS_REPO_URL` and `GITOPS_BRANCH_PREFIX` to the
accumulated Phase 1-8 set.

```bash
cd ~/work/agentic/devops/course   # adjust to your course root

# Cluster + mode
export HERMES_LAB_MODE=live                              # Phase 1 — set mock for Solo Learner
export HERMES_LAB_SCENARIO=crashloop2                    # Phase 6 scenario name
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"   # Phase 1
export PATH="$(pwd)/infrastructure/wrappers:$PATH"       # Phase 1

# Governance (L4 = allows kubectl apply, Phase 7)
export HERMES_LAB_GOVERNANCE=L4
export HERMES_LAB_TRACK=track-c                          # K8s specialist

# Telegram approval (from Phase 8 setup)
export TELEGRAM_BOT_TOKEN="<your-bot-token-from-BotFather>"
export TELEGRAM_ALLOWED_USERS="<your-telegram-user-id>"

# GitHub for Path B Production Upgrade (Steps 10-11)
export GITHUB_TOKEN="<your-PAT-with-repo-scope>"

# GitOps Path B (Phase 9 NEW per D-22)
export GITOPS_REPO_URL="https://github.com/<your-username>/hermes-fleet-fixes"
export GITOPS_BRANCH_PREFIX="hermes-fix-"
```

Verify the exports are active:

```bash
echo "MODE=$HERMES_LAB_MODE"
echo "GOVERNANCE=$HERMES_LAB_GOVERNANCE"
echo "TRACK=$HERMES_LAB_TRACK"
[[ -n "$TELEGRAM_BOT_TOKEN" ]] && echo "TELEGRAM: configured" || echo "TELEGRAM: MISSING"
[[ -n "$GITOPS_REPO_URL" ]] && echo "GITOPS_REPO_URL: $GITOPS_REPO_URL" || echo "GITOPS_REPO_URL: MISSING (needed for Step 10)"
```

Run the KIND cluster readiness checks:

```bash
# KIND running
kubectl cluster-info --context kind-kind

# crashloop2 scenario applied (apply now if not yet done)
kubectl apply -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml
kubectl get pods -n k8s-trouble-crashloop
# Expected: crasher pod in CrashLoopBackOff

# AlertManager + Prometheus running
kubectl get pods -n monitoring
# Expected: prometheus-*, alertmanager-* pods all Running

# PrometheusRule loaded (Phase 8 rule fires on crashloop2)
kubectl get prometheusrule -n monitoring -l release=kube-prometheus
```

> **SOLO LEARNER**
>
> Set `HERMES_LAB_MODE=mock` if you cannot run KIND. The mock-kubectl wrapper
> intercepts every kubectl command in this lab and returns pre-canned crashloop2 output.
> You can still observe the full delegation chain in gateway logs — just no real cluster mutation.
> Skip the KIND/Prometheus readiness checks; they don't apply in mock mode. The Solo Learner
> callouts in Steps 5-9 give you mock-mode equivalents for every live step.

---

## Step 2: Install and Verify Morgan Profile with the Phase 9 Toolset Update (8 min)

Install the Morgan fleet coordinator profile from the course repo:

```bash
hermes profile create fleet
cp agents/fleet-coordinator/config.yaml ~/.hermes/profiles/fleet/
cp agents/fleet-coordinator/SOUL.md ~/.hermes/profiles/fleet/
```

Add your Google AI Studio API key to the fleet profile environment file:

```bash
# Get your free API key from aistudio.google.com → Get API key → Create API key
echo 'OPENAI_API_KEY=YOUR_GOOGLE_AI_STUDIO_KEY' >> ~/.hermes/profiles/fleet/.env
```

Then add the platform configuration (webhook + Telegram) to the fleet profile. This is required for the gateway to enable webhook ingestion and Telegram delivery under the fleet profile:

```bash
# Store Telegram bot token securely in the profile .env file
# (Get your token from @BotFather on Telegram)
echo 'TELEGRAM_BOT_TOKEN=YOUR_TELEGRAM_BOT_TOKEN' >> ~/.hermes/profiles/fleet/.env

# Append platform config to fleet profile
cat >> ~/.hermes/profiles/fleet/config.yaml << 'EOF'

platforms:
  webhook:
    enabled: true
    extra:
      host: "0.0.0.0"
      port: 8644
  telegram:
    enabled: true
    extra:
      token: "${TELEGRAM_BOT_TOKEN}"
EOF
```

> **Solo Learner — no Telegram bot?**
> Set `--deliver log` instead of `--deliver telegram` in Step 4's `fleet-webhook-subscribe.sh`. Morgan's output goes to the gateway log instead. You can still observe the full TRIAGE → DELEGATE → SYNTHESIZE chain in `~/.hermes/logs/gateway.log`.

Inspect the critical toolset change from Phase 9 Plan 01:

```bash
grep -A3 'platform_toolsets:' ~/.hermes/profiles/fleet/config.yaml
# Expected output includes:
#   cli: [terminal, web, skills]
```

If you see `cli: [web, skills]` (no terminal), the delegation chain WILL fail — Track C children
cannot inherit `terminal` from a parent that lacks it. Copy again to pick up the Phase 9 fix:

```bash
# Re-running 'hermes profile create fleet' is safe — it is idempotent.
hermes profile create fleet
cp agents/fleet-coordinator/config.yaml ~/.hermes/profiles/fleet/
cp agents/fleet-coordinator/SOUL.md ~/.hermes/profiles/fleet/
grep -A1 'cli:' ~/.hermes/profiles/fleet/config.yaml
```

Also verify Track C is installed:

```bash
hermes profile create track-c
cp agents/track-c-kubernetes/config.yaml ~/.hermes/profiles/track-c/
cp agents/track-c-kubernetes/SOUL.md ~/.hermes/profiles/track-c/
cp -r agents/track-c-kubernetes/skills/sre-k8s-pod-health ~/.hermes/profiles/track-c/skills/
# Add API key if not already done in Module 10
echo 'OPENAI_API_KEY=YOUR_GOOGLE_AI_STUDIO_KEY' >> ~/.hermes/profiles/track-c/.env
hermes profiles list
# Expected: fleet, track-a, track-b, track-c (plus any other Module 10 profiles)
```

Quick smoke test — send Morgan a test prompt to confirm she introduces herself correctly:

```bash
hermes -p fleet chat
```

Prompt:

```
What is your role?
```

Expected: Morgan introduces herself as the fleet coordinator, mentions delegation to Track A/B/C
specialists, and confirms she does not execute domain commands directly. Exit with Ctrl+D.

> **WHY TERMINAL IS IN MORGAN'S CONFIG**
>
> Hermes delegation uses a toolset intersection: when Morgan calls `delegate_task`, the child
> agent's toolsets are intersected with Morgan's `enabled_toolsets`. Without `terminal` in
> Morgan's `platform_toolsets.cli`, the intersection strips `terminal` from Track C — and Track C
> cannot run kubectl.
>
> The `terminal` entry in Morgan's config is a **mechanical capability for delegation** (belt).
> The behavioral prohibition against Morgan calling terminal directly is enforced by Morgan's
> NEVER rule in SOUL.md (suspenders). Belt + suspenders = Morgan can delegate kubectl apply to
> Track C without herself executing any kubectl commands.

> **SOLO LEARNER**
>
> Everything in this step runs identically in mock mode — `hermes -p fleet chat` works without a cluster.

---

## Step 3: Read Morgan's Updated SOUL.md — The Delegation-with-Approval Pattern (7 min)

Open Morgan's SOUL.md from the installed profile:

```bash
cat ~/.hermes/profiles/fleet/SOUL.md
```

Find these 4 Phase 9 additions (added in Plan 01). They appear after the original 4 NEVER rules:

**1. The NEW NEVER terminal rule (in Behavior Rules section):**

```
NEVER call terminal tools directly — your role is delegation, not execution.
```

**2. The re-delegation rule (in Phase 9 belt + suspenders section):**

```
After human approval, re-delegate to the SAME specialist that diagnosed the issue
with HERMES_LAB_GOVERNANCE=L4 in the instructions context
```

**3. The fix proposal format rule:**

```
Generate fix proposals as kubectl patch commands OR YAML diff overlays — kubectl
commands for Path A (direct apply), YAML overlays for Path B (GitOps PR)
```

**4. The Telegram approval gate (in Escalation Policy section):**

```
Await human approval via Telegram before re-delegating apply — never trigger a fix
without explicit /approve <incident-id> confirmation
```

Compare Morgan's before vs. after state:

| Before Phase 9 | After Phase 9 |
|---|---|
| 4 NEVER rules (db, aws, kubectl, delegation loops) | 5 NEVER rules (+ terminal direct) |
| No approval gate in Escalation Policy | Awaits Telegram `/approve` before re-delegating apply |
| No fix-format rule | Generates kubectl patches OR YAML overlays |
| `cli: [web, skills]` — delegation chain broken | `cli: [terminal, web, skills]` — delegation chain works |

> **TIP: Read SOUL.md as a behavioral spec**
>
> Every line in SOUL.md is a constraint on what Morgan will do. `delegation:` in `config.yaml`
> tells Hermes HOW to spawn child agents. SOUL.md tells the LLM WHEN and WHY. Together they
> fully specify Morgan's behavior for the FLEET-01 chain.

> **SOLO LEARNER**
>
> Everything in this step is file reading — no infrastructure needed.

---

## Step 4: Start the Gateway and Subscribe Morgan to AlertManager Webhook (10 min)

This step starts the Hermes gateway and wires Morgan to receive AlertManager events via the
Plan 01 helper script.

Open **Terminal 1** (stays running throughout the lab):

```bash
# Set env vars first — gateway process inherits them at startup
# (already done in Step 1 — confirm HERMES_LAB_GOVERNANCE is in scope)
echo "GOVERNANCE=$HERMES_LAB_GOVERNANCE"   # must print L4

# Start the gateway with the fleet profile
hermes -p fleet gateway run
```

The gateway should start on port 8644 and show both webhook and telegram platforms active.

Open **Terminal 2**:

```bash
bash infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh
# Expected output:
#   [fleet-webhook-subscribe.sh] Subscribed. AlertManager -> Morgan is now wired.
#   Next step: trigger a test alert to verify the chain...
```

> **CAUTION: HERMES_LAB_GOVERNANCE must be set BEFORE gateway start**
>
> Environment variables are inherited by the gateway process at startup. If you export
> `HERMES_LAB_GOVERNANCE=L4` AFTER the gateway is already running, child agents inherit the OLD
> value (empty or L1). The wrapper will then block `kubectl apply` at the L1 level.
>
> Verify the gateway process has L4 in its environment:
>
> ```bash
> # Linux
> GATEWAY_PID=$(pgrep -f 'hermes gateway')
> cat /proc/$GATEWAY_PID/environ | tr '\0' '\n' | grep HERMES_LAB
>
> # macOS
> GATEWAY_PID=$(pgrep -f 'hermes gateway')
> ps eww $GATEWAY_PID | tr ' ' '\n' | grep HERMES_LAB
> ```
>
> Expected: `HERMES_LAB_MODE=live`, `HERMES_LAB_GOVERNANCE=L4`, `HERMES_LAB_TRACK=track-c`.

> **SOLO LEARNER**
>
> Run `hermes -p fleet gateway run` the same way in mock mode. You still see webhook
> subscriptions succeed. Instead of waiting for AlertManager to fire, proceed to Step 5 where
> you hand-craft the webhook test payload.

---

## Step 5: Trigger the AlertManager Alert and Observe Morgan Receiving the Webhook (10 min)

**Live path (KIND + AlertManager running):**

Restart the crasher to force a fresh CrashLoopBackOff event that AlertManager will detect:

```bash
# Terminal 2 — trigger the crash loop
kubectl rollout restart deployment/crasher -n k8s-trouble-crashloop

# Watch pods restart (wait 2-3 minutes for alert to fire)
watch -n 5 'kubectl get pods -n k8s-trouble-crashloop'
```

Expected sequence in Terminal 1 (gateway log):

```
webhook.alertmanager received: {alerts: [{labels: {alertname: KubePodCrashLooping,
  namespace: k8s-trouble-crashloop, pod: crasher-xxx}, ...}]}
→ invoking profile: fleet
→ Morgan (fleet-coordinator) starting triage...
```

> **SOLO LEARNER**
>
> No live AlertManager? Send a hand-crafted AlertManager-shaped payload:
>
> ```bash
> cat > /tmp/test-alert.json <<'EOF'
> {
>   "alerts": [{
>     "status": "firing",
>     "labels": {
>       "alertname": "KubePodCrashLooping",
>       "namespace": "k8s-trouble-crashloop",
>       "pod": "crasher-xxx"
>     },
>     "annotations": {
>       "description": "Pod crasher is crash looping in namespace k8s-trouble-crashloop"
>     }
>   }]
> }
> EOF
> hermes webhook test alertmanager --payload @/tmp/test-alert.json
> ```
>
> You will see the same Morgan triage output in Terminal 1 — the delegation mechanics are identical.

> **NOTE: The PrometheusRule that fires this alert**
>
> The alert originates from `infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml`
> (Phase 8, `PodCrashLooping` rule). It requires the label `release: monitoring` (matching the
> Helm release name) for auto-discovery by kube-prometheus-stack. If the alert is not firing
> after 3 minutes, verify the label matches:
>
> ```bash
> kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.ruleSelector}'
> kubectl get prometheusrule hermes-lab-rules -n monitoring -o yaml | grep -A2 'labels:'
> ```

---

## Step 6: Observe Morgan's Triage and Delegation to Track C (10 min)

Watch Terminal 1 (gateway log) as Morgan processes the AlertManager webhook:

**Expected gateway output:**

```
Morgan: Triage: This is a Kubernetes pod failure (alertname=KubePodCrashLooping).
        Affected domains: kubernetes only (no database or cost signals in this alert).
        Delegating to Track C for diagnosis.

[delegate_task] spawning child agent: track-c
  toolsets: [terminal, web, skills]   <- Phase 9 fix: terminal inherited from Morgan
  env: HERMES_LAB_GOVERNANCE=L4, HERMES_LAB_TRACK=track-c, HERMES_LAB_SCENARIO=crashloop2

Track C specialist: Received task — "Diagnose crasher pod in k8s-trouble-crashloop namespace.
  Alert: KubePodCrashLooping. Check pod status, logs, and resource configuration."
```

Point out the `toolsets: [terminal, web, skills]` line in the log. Without the Phase 9 toolset
fix, this line would say `[web, skills]` and Track C would fail on its first kubectl call with
"terminal tool not available."

The delegation is **in-process**: Track C specialist is a child `AIAgent` object spawned inside
the same Python process as Morgan. This means `os.environ` is shared — `HERMES_LAB_GOVERNANCE=L4`
is visible to Track C without any additional passing mechanism.

> **SOLO LEARNER**
>
> Same log output in mock mode — the wrapper intercepts kubectl calls but the delegation mechanics
> are identical. You see the same triage statement and delegation logs.

---

## Step 7: Observe Track C Specialist Diagnosing the Pod with sre-k8s-pod-health (10 min)

Track C runs its diagnostic sequence using the sre-k8s-pod-health SKILL.md from Phase 6.
Watch the continuation in Terminal 1:

**Expected Track C output:**

```
Track C: Running sre-k8s-pod-health diagnostic tree for namespace k8s-trouble-crashloop...

$ kubectl get pods -n k8s-trouble-crashloop -l app=crasher
  NAME          READY   STATUS             RESTARTS   AGE
  crasher-xxx   0/1     CrashLoopBackOff   5 (45s ago)   8m

$ kubectl describe pod crasher-xxx -n k8s-trouble-crashloop
  ...
  Last State: Terminated
    Reason: Error
    Exit Code: 1
  ...
  Limits: <none>        <- no resource limits set (root cause contributing factor)
  Requests: <none>

$ kubectl logs crasher-xxx -n k8s-trouble-crashloop --previous
  starting...
  fatal: missing config

Root cause: Container exits 1 on startup (startup failure).
Contributing factor: No resource limits or requests configured on the crasher deployment.
In a production cluster with memory pressure, this pod would be an OOMKill candidate.

Recommended fix: Add resource limits and requests to the crasher deployment.
  Path A (direct apply):  kubectl apply -f infrastructure/scenarios/k8s/gitops/memory-patch.yaml
  Path B (GitOps PR):     Generate YAML overlay in your GitOps repo, open PR, run apply.sh on merge.

Returning findings to Morgan.
```

> **NOTE: Lab narrative note**
>
> The crasher deployment exits 1 (startup failure from `busybox exit 1`) — the actual FLEET-01
> fix teaches the resource limit pattern, not a literal OOMKill fix. The mock data for
> `crashloop2` correctly reflects this. The teaching point is the delegation flow and the apply
> governance, not the specific patch content.

> **SOLO LEARNER**
>
> mock-kubectl returns the same structured output from Phase 6 mock data files in
> `infrastructure/mock-data/kubernetes/`. The diagnosis is identical — the wrapper just doesn't
> touch a real cluster.

---

## Step 8: Observe Morgan Synthesizing Findings and Posting the Proposal to Telegram (10 min)

After Track C returns findings, Morgan:
1. Receives findings in-process (return value from `delegate_task`)
2. Synthesizes: root cause summary + proposed fix
3. Composes a self-contained Telegram proposal message
4. Delivers via `deliver: telegram` cross-platform routing

**Expected Telegram message (also visible in gateway Terminal 1):**

```
INCIDENT PROPOSAL — crasher pod in k8s-trouble-crashloop

Root cause: Container exits 1 on startup (startup failure). Missing resource limits
and requests — contributing factor for production memory pressure.

Proposed fix (Path A — direct apply):
  kubectl apply -f infrastructure/scenarios/k8s/gitops/memory-patch.yaml -n k8s-trouble-crashloop

Alternative (Path B — GitOps PR):
  See Step 10 to walk the production upgrade path instead.

Governance: L4 (re-delegation at L4 level, kubectl apply is in wrapper_allowlist)
Reply: /approve incident-001   OR   /reject incident-001
```

> **CAUTION: Self-contained proposal message (Pitfall 5)**
>
> Morgan's proposal message contains the **full kubectl command**. This is intentional: when the
> `/approve` handler fires, it creates a NEW Morgan agent invocation. That new invocation must
> know what to apply. The self-contained proposal message provides that context.
>
> If the proposal contains only "apply the fix" without specifying the command, the approval
> handler cannot re-delegate correctly.

> **SOLO LEARNER**
>
> If no Telegram bot is configured, Morgan's proposal text appears in the gateway Terminal 1 log
> instead. Read the proposed command there and proceed to Step 9 using the manual apply path.

---

## Step 9: Approve via Telegram and Observe Path A Re-delegation + kubectl Apply (10 min)

Send the approval from your Telegram client:

```
/approve incident-001
```

**Expected gateway flow (Terminal 1):**

```
Telegram bot received: /approve incident-001
Admin allowlist check: user_id=<your-id> — ALLOWED (in TELEGRAM_ALLOWED_USERS)

New Morgan invocation: processing /approve incident-001
Morgan: Approval received. Re-delegating fix to Track C at L4 governance.

[delegate_task] spawning child agent: track-c (re-delegation for apply)
  toolsets: [terminal, web, skills]
  env: HERMES_LAB_GOVERNANCE=L4, HERMES_LAB_TRACK=track-c

Track C (apply run):
$ kubectl apply -f infrastructure/scenarios/k8s/gitops/memory-patch.yaml -n k8s-trouble-crashloop
[mock-kubectl] HERMES_LAB_GOVERNANCE=L4 HERMES_LAB_TRACK=track-c
[mock-kubectl] Loading allowlist: governance/governance-L4-track-c.yaml
[mock-kubectl] Checking: "apply " against wrapper_allowlist.kubectl
[mock-kubectl] PASS — "apply " is in L4 Track C allowlist
deployment.apps/crasher configured

Track C: Apply succeeded. Deployment crasher updated in k8s-trouble-crashloop.
Morgan: Posting success confirmation to Telegram...
```

Verify the patch applied:

```bash
kubectl get deployment crasher -n k8s-trouble-crashloop -o yaml | grep -A5 resources:
# Expected:
#   resources:
#     limits:
#       memory: "256Mi"
#       cpu: "200m"
#     requests:
#       memory: "128Mi"
#       cpu: "100m"
```

> **NOTE: The pod may still crash-loop**
>
> Our memory-patch.yaml adds resource limits but does NOT fix the `exit 1` startup failure in the
> crasher container. This is intentional — the lab demonstrates the resource limit governance
> pattern, not a complete bug fix. The Free Explore section challenges you to write a real fix.

> **SOLO LEARNER**
>
> Without a Telegram bot, skip `/approve`. Run the apply directly with governance intact:
>
> ```bash
> hermes -p track-c chat
> ```
>
> Prompt:
>
> ```
> Apply the approved fix: kubectl apply -f infrastructure/scenarios/k8s/gitops/memory-patch.yaml -n k8s-trouble-crashloop
> ```
>
> Observe the L4 governance wrapper pass-through in the output. Same mechanism as live — just no
> Telegram in the loop.

**This is the end of Path A.** Steps 10-11 walk Path B (Production Upgrade — GitOps PR flow).

---

## Step 10: PRODUCTION UPGRADE — Path B GitOps PR Flow with `gh pr create` (10 min)

> **NOTE: Production upgrade section**
>
> This section demonstrates the production-grade pattern. In a real production deployment, you
> would typically use a GitOps PR-based flow rather than direct apply. Paths A and B exist in
> Phase 9 because not every team runs ArgoCD — some run kubectl or helm from CI on PR merge.
> The diff between A and B IS the teaching moment.

Initialize your GitOps repo (choose Option A or Option B):

**Option A: GitHub repo (requires GITHUB_TOKEN):**

```bash
mkdir ~/hermes-fleet-fixes && cd ~/hermes-fleet-fixes
git init
cp $OLDPWD/infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md ./README.md
cp $OLDPWD/infrastructure/scenarios/k8s/gitops/memory-patch.yaml ./memory-patch.yaml
git add . && git commit -m "chore: bootstrap GitOps repo"

# Create the repo on GitHub
gh repo create hermes-fleet-fixes --public --source=. --push

export GITOPS_REPO_URL="https://github.com/$(gh api user -q .login)/hermes-fleet-fixes"
echo "GITOPS_REPO_URL=$GITOPS_REPO_URL"
```

**Option B: Local-only repo (Solo Learner — no GitHub required):**

```bash
mkdir ~/hermes-fleet-fixes && cd ~/hermes-fleet-fixes
git init
cp $OLDPWD/infrastructure/scenarios/k8s/gitops/memory-patch.yaml ./memory-patch.yaml
git add . && git commit -m "chore: bootstrap local GitOps repo"
export GITOPS_REPO_URL="file://$HOME/hermes-fleet-fixes"
```

Now trigger the Path B flow — invoke Track C directly with a Path B instruction:

```bash
cd $OLDPWD   # back to course root
hermes -p track-c chat
```

Prompt:

```
Generate a YAML overlay that adds memory limits to the crasher deployment (memory: 256Mi).
Write it to ~/hermes-fleet-fixes/memory-patch.yaml.
Commit to a feature branch named hermes-fix-<timestamp>.
Push to origin (if GitHub repo is set up).
Open a PR with: gh pr create --title "fix: add memory limits to crasher" --body "Adds resource limits: memory 256Mi, cpu 200m." --base main
Post back the PR URL.
```

**Expected specialist output:**

```
Track C: Generating YAML overlay for crasher deployment...
Writing to ~/hermes-fleet-fixes/memory-patch.yaml

$ git -C ~/hermes-fleet-fixes checkout -b hermes-fix-1712534400
$ git -C ~/hermes-fleet-fixes add memory-patch.yaml
$ git -C ~/hermes-fleet-fixes commit -m "fix: add memory limits to crasher deployment"
$ git -C ~/hermes-fleet-fixes push origin HEAD
$ gh pr create --title "fix: add memory limits to crasher" \
    --body "Adds resource limits: memory 256Mi, cpu 200m." \
    --base main
  https://github.com/your-username/hermes-fleet-fixes/pull/1

PR URL: https://github.com/your-username/hermes-fleet-fixes/pull/1
```

> **NOTE: No `_deliver_github_pr` in Hermes (RESEARCH BLOCKER-01)**
>
> Track C calls `gh pr create` **directly** from its terminal toolset. Hermes has a
> `_deliver_github_comment` method for posting to EXISTING PRs, but **no `_deliver_github_pr`
> method for opening new ones**. The `gh` CLI is not a kubectl command, so the mock-kubectl
> governance wrapper does NOT intercept it — PR creation is un-governed (git/gh commands are
> outside the wrapper's scope).
>
> This is noted in `infrastructure/scenarios/k8s/gitops/gitops-repo-template/README.md`.

> **SOLO LEARNER**
>
> Use `file://$HOME/hermes-fleet-fixes` for GITOPS_REPO_URL (Option B above). Skip `gh pr create`
> — merge the feature branch locally instead:
>
> ```bash
> cd ~/hermes-fleet-fixes
> git checkout main
> git merge --no-ff hermes-fix-<timestamp>
> git log --oneline main
> ```
>
> The merged local commit is your "PR". Proceed to Step 11 with your local repo path.

---

## Step 11: Sync via apply.sh and Verify the Full Path B Chain (8 min)

Review the PR in the GitHub UI (Option A) or inspect the local git log (Option B), then merge:

```bash
# Option A: merge in GitHub UI, then pull locally
gh pr merge 1 --squash
cd ~/hermes-fleet-fixes && git checkout main && git pull
cd $OLDPWD   # back to course root

# Option B: already merged locally in Step 10
```

Run `apply.sh` to sync the merged manifest:

```bash
bash infrastructure/scenarios/k8s/gitops/apply.sh ~/hermes-fleet-fixes/memory-patch.yaml
```

Expected output:

```
[gitops/apply.sh] Phase 9 FLEET-01 Path B sync
[gitops/apply.sh] Patch file: /Users/.../hermes-fleet-fixes/memory-patch.yaml
[gitops/apply.sh] Namespace:  k8s-trouble-crashloop
deployment.apps/crasher configured
[gitops/apply.sh] Sync complete. Waiting for rollout...
deployment.apps/crasher: 0 of 1 updated replicas are available...
deployment.apps/crasher condition met
[gitops/apply.sh] Rollout complete.
```

Verify the deployed configuration:

```bash
kubectl get deployment crasher -n k8s-trouble-crashloop -o yaml | grep -A5 resources:
```

> **Path A vs Path B — what changed?**
>
> | | Path A (direct apply) | Path B (GitOps PR) |
> |---|---|---|
> | **Who executes** | Track C under L4 governance | apply.sh (you, after PR merge) |
> | **Auditability** | Wrapper audit log only | Git history + PR review + wrapper log |
> | **Rollback** | `kubectl rollout undo` | Revert PR + apply.sh again |
> | **Governance gate** | Telegram approval | PR review + Telegram approval |
> | **ArgoCD** | Not needed | v1.2 alternative to replace apply.sh |
>
> Path B Sub-path B2 (`apply.sh`) is the v1.1 implementation. ArgoCD (Sub-path B1) would replace
> this script in a production deployment with ArgoCD already installed. See
> `infrastructure/scenarios/k8s/gitops/README.md` for the B1/B2 distinction.

> **SOLO LEARNER**
>
> Everything runs identically with a local repo — apply.sh is wrapper-aware and honors
> `HERMES_LAB_MODE=mock`. In mock mode, the kubectl apply inside apply.sh goes through the
> mock-kubectl wrapper and produces expected output without a real cluster change.

---

## Milestone Close Note

Congratulations — you have just run the **final v1.1 lab**. Phase 9 closes the v1.1 milestone:
"Realistic Agents & Production Workflows." The incident response chain you walked (AlertManager →
Morgan → Track C → Telegram approval → L4 apply) is the capstone pattern for the entire v1.1 track.

When you are ready to move on, the next steps are:
- Run `/gsd:audit-uat` for cross-phase verification debt review
- Run `/gsd:complete-milestone` to archive v1.1 and prepare for v1.2

---

## FREE EXPLORE PHASE — 45 minutes

---

### Challenge 1 (Starter — 15 min): Two-Stage Approval

Extend Morgan's SOUL.md to support a two-stage approval flow:
1. `/approve-draft <incident-id>` — Morgan generates the fix YAML but does NOT apply
2. `/approve-apply <incident-id>` — Morgan re-delegates the actual apply

What new behavior rule is needed in Morgan's SOUL.md? What changes in the Escalation Policy?

---

### Challenge 2 (Intermediate — 20 min): Different Phase 6 Scenario

Trigger the chain against a different Phase 6 scenario:

```bash
kubectl apply -f infrastructure/scenarios/k8s/03-oom-killed.yaml
kubectl rollout restart deployment/crasher -n k8s-trouble-oom
```

Observe:
- Does Morgan's triage correctly route to Track C for this scenario?
- What does Track C's sre-k8s-pod-health output look like for OOMKilled vs CrashLoopBackOff?
- Does the proposed fix differ?

---

### Challenge 3 (Intermediate — 20 min): Audit the Gateway Logs

Compare the gateway logs for your Path A run (Step 9) vs your Path B run (Step 11):

1. What is the total latency difference from alert fire to fix confirmed?
2. Which path has a richer audit trail?
3. Which path is reversible with a single command?

Find the governance wrapper audit lines in the log:

```bash
# Filter gateway log for wrapper decisions
journalctl --user -u hermes-gateway 2>/dev/null | grep 'mock-kubectl'
# Or look at gateway Terminal 1 output scrollback
```

---

### Challenge 4 (Advanced — 30 min): Parallel Delegation

Can you trigger a scenario where Morgan delegates to TWO specialists in parallel? What breaks
with Morgan's current SOUL.md?

Hints:
- The anti-loop rule (`NEVER spawn more than one delegation per domain per incident`) prevents
  duplicate Track C calls
- The sequential rule (`Wait for specialist response before delegating the next task`) prevents
  parallel dispatch
- Try a cross-domain incident that touches K8s AND cost simultaneously

---

### Challenge 5 (Advanced — 30 min): K8s Agent Sandbox

Project 3 in `exploratory/PROJECTS.mdx` walks the K8s Agent Sandbox install (alpha v0.2.1).
Try installing the Sandbox CRDs on your KIND cluster and deploying the Track C agent inside a
Sandbox. Observe the namespace isolation.

---

## Verification Checklist

```
- [ ] Morgan profile installed with `cli: [terminal, web, skills]` in config.yaml
- [ ] Morgan's SOUL.md shows the Phase 9 NEVER rule and re-delegation behavior (5 total NEVER rules)
- [ ] hermes -p fleet gateway run started with HERMES_LAB_GOVERNANCE=L4 in env
- [ ] fleet-webhook-subscribe.sh ran successfully
- [ ] AlertManager alert fired (live) OR hand-crafted payload sent (Solo Learner)
- [ ] Morgan triaged and delegated to Track C (observed in gateway log)
- [ ] Track C diagnosed via sre-k8s-pod-health (observed kubectl output)
- [ ] Morgan synthesized + posted proposal to Telegram (or gateway log for Solo Learner)
- [ ] /approve incident-001 sent (or manual apply for Solo Learner)
- [ ] Path A kubectl apply succeeded at L4 governance
- [ ] GitOps repo initialized (Option A or B)
- [ ] Track C opened PR via gh pr create (Option A) or created local branch (Option B)
- [ ] apply.sh synced the merged patch
- [ ] Free Explore: picked at least one challenge to investigate
```

---

## Appendix: Complete FLEET-01 Architecture Reference

```
AlertManager (monitoring namespace)
  │ POST /webhooks/alertmanager (KubePodCrashLooping fires)
  ▼
Hermes Gateway (port 8644, fleet profile)
  │ route: alertmanager → Morgan (in-process)
  ▼
Morgan (fleet-coordinator)
  │ triage: K8s domain → Track C
  │ delegate_task(target=track-c, toolsets=[terminal,web,skills])
  ▼
Track C (track-c-kubernetes, in-process child)
  │ sre-k8s-pod-health diagnostic tree
  │ kubectl get/describe/logs (via mock-kubectl L4 wrapper)
  │ returns: root cause + fix proposal
  ▼
Morgan
  │ synthesizes: unified root cause + fix command
  │ posts proposal to Telegram: /approve incident-001
  ▼
Human (Telegram)
  │ /approve incident-001
  ▼
Morgan
  │ re-delegates: track-c with HERMES_LAB_GOVERNANCE=L4
  ▼
Track C (apply run)
  │ kubectl apply -f memory-patch.yaml -n k8s-trouble-crashloop
  │ mock-kubectl wrapper: L4 Track C allowlist → "apply " PASS
  │ deployment updated
  ▼
Morgan
  │ posts success to Telegram
  ▼
FLEET-01 complete (Path A)

--- Path B branch (Steps 10-11) ---

Track C (path-b run)
  │ generates YAML overlay → ~/hermes-fleet-fixes/memory-patch.yaml
  │ git commit + push feature branch
  │ gh pr create (direct terminal call — no Hermes delivery method)
  ▼
Human (GitHub UI or local git)
  │ reviews diff, merges PR
  ▼
apply.sh
  │ kubectl apply -f ~/hermes-fleet-fixes/memory-patch.yaml -n k8s-trouble-crashloop
  ▼
FLEET-01 complete (Path B)
```

**Phase 6 assets reused:** `02-crashloop-backoff.yaml`, `sre-k8s-pod-health` SKILL.md, Track C profile
**Phase 7 assets reused:** `mock-kubectl` wrapper, `governance-L4-track-c.yaml` allowlist
**Phase 8 assets reused:** `prometheus-rules.yaml`, `alertmanager-config.yaml`, Telegram bot adapter
**Phase 9 Plan 01 assets:** Morgan `config.yaml` (terminal toolset), Morgan `SOUL.md` (4 additions),
  `fleet-webhook-subscribe.sh`, `gitops/apply.sh`, `gitops/memory-patch.yaml`
