# Phase 9: Multi-Agent Workflows & Production — Research

**Researched:** 2026-04-07
**Domain:** Hermes inter-agent delegation, webhook-to-agent invocation, governance env propagation, K8s Agent Sandbox, ArgoCD presence, reference-app Helm, Module 11 infrastructure audit
**Confidence:** HIGH (all load-bearing findings verified against Hermes source code and course repo directly)

---

## DISCOVERED BLOCKERS — READ BEFORE PLANNING

### BLOCKER-01 (CRITICAL): No Hermes `_deliver_github_pr` method exists — Path B PR creation needs a different mechanism

`gateway/platforms/webhook.py` has exactly ONE GitHub delivery method: `_deliver_github_comment` (calls `gh pr comment`). There is **no** `_deliver_github_pr` method for opening PRs. The webhook adapter cannot open a PR as a delivery step.

**Impact:** Path B (GitOps PR-based apply, D-07) cannot use `--deliver github_comment` style to open PRs. The agent must produce the diff/patch file and the PR creation is a separate step — either the specialist agent calls `gh pr create` directly (using the `terminal` toolset), or the lab walkthrough has a separate manual step.

**Recommended resolution (Claude's discretion):** The simplest lab path for Path B: specialist agent writes the YAML patch file, commits to a feature branch, then calls `gh pr create --title "..." --body "..." --base main` via its terminal toolset at L4 governance. The `gh` CLI is already a prerequisite (Module 12 lab uses it for `gh pr comment`). This is a terminal tool call, not a Hermes delivery mechanism — it goes through the mock-kubectl/wrapper layer. HOWEVER: `gh pr create` is not a kubectl or aws command, so the wrapper does not intercept it. The agent calls `gh pr create` directly (no governance wrapper for git/gh commands). Lab must note this.

### BLOCKER-02 (CRITICAL): `setup-argocd.sh` is documentation-only — file does not exist in the repo

Module 5 exploratory `PROJECTS.mdx` references `reference-app/helm/setup-argocd.sh` and instructs participants to run `bash reference-app/helm/setup-argocd.sh`. This file **does not exist** in the course repo. The `reference-app/helm/` directory does not exist at all (only `reference-app/reference-app/` with Cargo/Rust content).

**Impact for Phase 9 Path B Sub-path B1 (ArgoCD on KIND sync):** ArgoCD is referenced in Module 5 exploratory PROJECTS.mdx as a project with a prerequisite install script that is missing. The course's actual Module 5 lab tracks (Track A Helm, Track B Terraform) do NOT ship ArgoCD. There is no `setup-argocd.sh` script anywhere in the repo. ArgoCD is mentioned in instructor guides and the COMPLETED-HANDOFF.md but was never committed as infrastructure.

**Impact classification:** Sub-path B1 (ArgoCD sync) CANNOT be walked as a GUIDED step in Phase 9 because no ArgoCD install infrastructure exists. The lab MUST use Sub-path B2 (helm upgrade fallback script, `infrastructure/scenarios/k8s/gitops/apply.sh`) as the primary Path B route. Sub-path B1 should be described in a callout as "if you separately installed ArgoCD via `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`" but cannot be the guided path.

**Resolution:** The Phase 9 plan creates `infrastructure/scenarios/k8s/gitops/apply.sh` (D-09) as the ONLY required Path B mechanism. Sub-path B1 ArgoCD is described conceptually with a link to the ArgoCD quick install command, but no new install script is committed for Phase 9.

### NON-BLOCKER (Verify): Reference-app Helm chart does not exist in expected location

`reference-app/helm/` does not contain a `Chart.yaml` or `values.yaml`. The reference app is a Rust application (Cargo.toml present). Phase 9 Path B D-09 requires "helm upgrade --install reference-app reference-app/helm/ --values <merged-patch>". If no Helm chart exists, this command fails.

**Action for planner:** Phase 9 Wave 0 must either (a) confirm a Helm chart exists somewhere else in the repo, or (b) create a minimal `reference-app/helm/Chart.yaml` + `values.yaml` that deploys the crashloop2 app with a configurable memory limit. Given that crashloop2 is the demo scenario (not the reference Rust app), the helm fallback likely wraps the crasher deployment — the planner must scope this carefully. See Architecture Pattern 4 for the recommended approach.

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**D-01:** Morgan IS the triage step. No separate triage agent. AlertManager → Hermes webhook gateway → Morgan invocation with alert payload → Morgan triages (which domains) → Morgan delegates to relevant specialists → specialists return findings → Morgan synthesizes + proposes fix → human approves → specialist re-delegated for apply.

**D-02:** Human approval via Telegram bot from Phase 8. Proposal posted to Telegram channel with incident summary, proposed action, risk assessment, governance level required. Admin user replies `/approve <incident-id>` or `/reject <incident-id>`. Reuses Phase 8 admin allowlist mechanism.

**D-03:** Specialist applies under L4 governance. After human approval, Morgan re-delegates to same specialist. The re-delegation sets `HERMES_LAB_GOVERNANCE=L4` + `HERMES_LAB_TRACK=track-c` in the spawned agent's environment. Phase 7 wrapper enforces L4 allowlist.

**D-04:** Demo scenario = Phase 6 crashloop2 + Phase 8 alert. 02-crashloop-backoff.yaml. Track C specialist diagnoses OOMKilled root cause via sre-k8s-pod-health. Morgan proposes kubectl patch increasing memory limit. Human approves. Specialist applies. Reuses ALL existing Phase 6+7+8 infrastructure.

**D-05 through D-10:** Two apply paths. Path A (direct kubectl apply at L4, primary) and Path B (GitOps PR-based, "production upgrade" section with sub-paths B1 ArgoCD and B2 helm fallback).

**D-09:** Helm upgrade fallback script at `infrastructure/scenarios/k8s/gitops/apply.sh`. New gitops/ directory.

**D-11:** Module 11 lab REPLACED (not extended). Existing 7-step mock-only walkthrough replaced with ~11 live-primary GUIDED steps.

**D-12:** Solo Learner callouts inside live lab for mock-mode equivalent.

**D-13:** Light edit to Morgan SOUL.md: 3 small additions to Behavior Rules and Escalation Policy.

**D-15:** K8s Agent Sandbox is exploratory PROJECTS.mdx entry only. No required lab steps, no infrastructure file commitments.

**D-17:** No infrastructure file commitments for Sandbox beyond install commands.

**D-18:** New productionization reference section in Module 11 reading.

**D-22:** Phase 9 adds `GITOPS_REPO_URL` and `GITOPS_BRANCH_PREFIX` env vars.

**D-23:** Phase 9 is the milestone close.

### Claude's Discretion

- Exact YAML patch generation pattern (jq-style overlay vs full manifest replacement)
- The GitOps repo branch naming convention details
- Specific Sandbox CRD release version pin (researcher recommends v0.2.1 — the latest stable alpha)
- Whether the Module 11 lab rewrite uses a single LAB.mdx or splits (planner decides based on length)
- Exact wording of the "Production upgrade: GitOps PR-based apply" section
- Quiz question phrasing and rationale depth
- Whether to add a Phase 9 PROJECTS.mdx exploratory entry beyond Sandbox
- Order and structure of PROD-02 reference content sections

### Deferred Ideas (OUT OF SCOPE)

- Separate triage agent (v1.2)
- GitOps-only apply (v1.2)
- Real production K8s Agent Sandbox required lab (v1.2 if Sandbox CRDs reach beta/stable)
- Multi-cluster fleet coordination (v1.2)
- Approval state machine with timeout/retry (v1.2)
- Audit log export to SIEM (v1.2)
- Morgan delegation parallelism (v1.2)
- Cross-domain incident replay (v1.2)
- Agent Sandbox + Module 11 fleet integration (v1.2)
- Advanced GitOps patterns — multi-environment, promotion workflows, drift detection
- Slack chatops as approval surface (v1.2)
- K8s native operators for agent management (v1.2)
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| FLEET-01 | End-to-end workflow: AlertManager alert triggers triage agent, diagnostic agent investigates, proposes fix, human approves, agent applies | Webhook invocation confirmed in-process (handle_message via base adapter). Morgan invocation confirmed via `hermes webhook subscribe`. Env var propagation confirmed (children inherit os.environ). `kubectl apply` in L4 Track C allowlist verified. Path B PR creation mechanism gap identified (BLOCKER-01). |
| FLEET-02 | Fleet coordinator (Morgan) rebuilt with real cross-domain incident synthesis using working specialist agents | Morgan SOUL.md and config.yaml verified. delegation tool confirmed with `delegate_task` as in-process child AIAgent spawn. Delegation toolset scoping confirmed. Module 11 both mirrors confirmed (LAB.mdx + LAB.md both exist). cross-domain mock fixture verified via modules/module-11-fleet/LAB.md. |
| PROD-01 | K8s Agent Sandbox exploratory lab — install CRDs on KIND, deploy agent, demonstrate isolation | Sandbox confirmed at v0.2.1 (latest), alpha CRDs (agents.x-k8s.io/v1alpha1), four CRD types: Sandbox, SandboxTemplate, SandboxClaim, SandboxWarmPool. No KIND v0.31 explicit compatibility mentioned. D-15 exploratory-only decision validated. |
| PROD-02 | Conceptual content on productionizing agents: packaging, deployment, monitoring, scaling patterns | Module 11 reference.mdx (212 lines, more reference-heavy than concepts.mdx at 176 lines). Target file confirmed. Cross-reference points: Phase 7 audit logs, Phase 8 AlertManager, Phase 9 Path B. |
</phase_requirements>

---

## Summary

Phase 9 is the final v1.1 phase. Research confirms most of the D-01 through D-23 locked decisions are implementable with existing infrastructure. Three non-trivial findings materially affect planning.

**Finding 1 (LOAD-BEARING):** Hermes delegation is in-process, not subprocess. The `delegate_tool.py` spawns child `AIAgent` objects within the same Python process. This means `os.environ` is shared — `HERMES_LAB_GOVERNANCE=L4` set in the Morgan gateway process IS visible to delegated specialist child agents. D-03 works as designed with no additional mechanism needed.

**Finding 2 (BLOCKER-01):** Hermes webhook adapter has no `_deliver_github_pr` method. Path B PR creation must go through the specialist agent's terminal toolset (calling `gh pr create` directly), not through a Hermes delivery mechanism.

**Finding 3 (BLOCKER-02):** No ArgoCD install infrastructure exists in the course repo. `setup-argocd.sh` is referenced in documentation but never committed. Sub-path B1 cannot be a guided step — the lab uses Sub-path B2 (helm upgrade fallback script) as the guided Path B route.

**Primary recommendation:** Wire Phase 9 around the confirmed working paths: AlertManager → webhook → Morgan (in-process, handles env propagation) → delegate_task to Track C → Telegram approval → re-delegation at L4 → `kubectl apply` via L4-track-c wrapper. Path B sub-path B2 (helm fallback) is the only fully implementable GitOps path given the ArgoCD gap.

---

## Standard Stack

### Core — Hermes Integration

| Component | Version/Location | Purpose | Confirmed |
|-----------|-----------------|---------|-----------|
| `tools/delegate_tool.py` | Hermes source | In-process child agent spawning via `delegate_task` tool | HIGH — read source |
| `gateway/platforms/webhook.py` | Hermes source | Webhook → `handle_message(event)` → agent run | HIGH — read source |
| `gateway/platforms/telegram.py` | 91.6K, python-telegram-bot v22.6+ | Approval message delivery + slash command reception | HIGH — Phase 8 confirmed |
| `governance/governance-L4-track-c.yaml` | `course/governance/` | L4 wrapper_allowlist with `apply ` entry | HIGH — read file |
| `infrastructure/wrappers/mock-kubectl` | `course/infrastructure/wrappers/` | Governance enforcement wrapper | HIGH — Phase 7 shipped |

### Course Infrastructure — Phase 9 Builds On

| Asset | Path | Phase | Confirmed |
|-------|------|-------|-----------|
| `02-crashloop-backoff.yaml` | `infrastructure/scenarios/k8s/` | Phase 6 | EXISTS |
| `02-crashloop2-*.json` | `infrastructure/mock-data/kubernetes/` | Phase 6 | EXISTS — get-pods, describe, logs |
| `prometheus-rules.yaml` | `infrastructure/scenarios/k8s/alertmanager/` | Phase 8 | EXISTS |
| `alertmanager-config.yaml` | `infrastructure/scenarios/k8s/alertmanager/` | Phase 8 | EXISTS |
| `bot-config.example.yaml` | `infrastructure/scenarios/k8s/telegram-bot/` | Phase 8 | EXISTS |
| `admin-allowlist.example.yaml` | `infrastructure/scenarios/k8s/telegram-bot/` | Phase 8 | EXISTS |
| `agents/fleet-coordinator/SOUL.md` | `course/agents/fleet-coordinator/` | Phase 4 | EXISTS |
| `agents/fleet-coordinator/config.yaml` | `course/agents/fleet-coordinator/` | Phase 4 | EXISTS |
| `agents/track-c-kubernetes/SOUL.md` | `course/agents/track-c-kubernetes/` | Phase 6 | EXISTS |
| `agents/track-c-kubernetes/config.yaml` | `course/agents/track-c-kubernetes/` | Phase 7 | EXISTS (L2 wrapper_allowlist) |

### Phase 9 New Files

| File | Purpose |
|------|---------|
| `infrastructure/scenarios/k8s/gitops/apply.sh` | Path B Sub-path B2 helm upgrade fallback |
| `infrastructure/scenarios/k8s/gitops/README.md` | GitOps directory documentation |
| `infrastructure/scenarios/k8s/gitops/memory-patch.yaml` | Sample memory limit overlay |
| `course-site/docs/module-11-fleet/lab/LAB.mdx` | REPLACEMENT live-primary lab |
| `modules/module-11-fleet/LAB.md` | Mirror of above |
| `course-site/docs/module-11-fleet/reading/reference.mdx` | EXTENDED with PROD-02 productionization section |
| `course-site/docs/module-11-fleet/quiz/QUIZ.mdx` | EXTENDED with 2-3 new questions |
| `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx` | EXTENDED with Sandbox project entry |

---

## Architecture Patterns

### Pattern 1: Hermes In-Process Delegation (Confirmed Design for D-03)

The `delegate_task` tool in `tools/delegate_tool.py` creates child `AIAgent` instances within the same Python process using `AIAgent()` constructor (not `subprocess.Popen`). Critical implications:

- Child agents share `os.environ` with the parent Morgan process
- `HERMES_LAB_GOVERNANCE=L4` set before Morgan starts IS visible to delegated Track C specialist
- `HERMES_LAB_TRACK=track-c` similarly propagates
- Delegation is sequential by default (Morgan SOUL.md enforces sequential rules)
- Max depth: 2 (parent → child → grandchild rejected). Morgan → Track C is depth 1 (allowed).
- `DELEGATE_BLOCKED_TOOLS` strips `delegate_task` from children — Track C cannot re-delegate
- Children inherit parent's enabled toolsets (intersection). Morgan has `cli: [web, skills]` — Track C specialist needs `terminal` to run `kubectl`. **This means Morgan must NOT be the process running with `cli: [web, skills]` for the apply step.** The re-delegation from Morgan spawns a child with Track C's toolsets, but the child's toolsets are intersected with Morgan's enabled_toolsets (which has no `terminal`). **This is a CRITICAL finding — see Pattern 1 Caveat below.**

**Pattern 1 Caveat — Toolset Intersection Problem (LOAD-BEARING):**

From `delegate_tool.py` line 178-184:
```python
parent_toolsets = set(getattr(parent_agent, "enabled_toolsets", None) or DEFAULT_TOOLSETS)
if toolsets:
    # Intersect with parent — subagent must not gain tools the parent lacks
    child_toolsets = _strip_blocked_tools([t for t in toolsets if t in parent_toolsets])
elif parent_agent and getattr(parent_agent, "enabled_toolsets", None):
    child_toolsets = _strip_blocked_tools(parent_agent.enabled_toolsets)
```

Morgan's `config.yaml` has `platform_toolsets: cli: [web, skills]` — no `terminal`. When Morgan calls `delegate_task(goal=..., toolsets=["terminal", "file", "web", "skills"])`, the intersection with Morgan's `{web, skills}` = `{web, skills}`. Track C specialist gets no `terminal` toolset and **cannot run kubectl**.

**Resolution options for planner:**
- **Option A (recommended):** Morgan's config.yaml is updated to include `terminal` in its platform_toolsets for the gateway-facing invocation context, or a separate `fleet-live` profile is created that adds `terminal` to Morgan's toolset just for delegation purposes. Morgan itself still doesn't execute terminal commands (SOUL.md NEVER rules), but the toolset must be present so children can inherit it.
- **Option B:** Pass explicit `toolsets: ["terminal", "file", "web", "skills"]` in Morgan's `delegate_task` call — but the intersection still blocks `terminal` because Morgan's `enabled_toolsets` doesn't include it.
- **Option C:** The delegate_tool code path falls through to `DEFAULT_TOOLSETS = ["terminal", "file", "web"]` if `parent_agent.enabled_toolsets` is None or empty. The planner should verify what `enabled_toolsets` actually resolves to for a gateway-launched Morgan agent.

**Planner action required:** Resolve the toolset inheritance before writing the FLEET-01 delegation task. If Morgan's gateway process doesn't have `terminal` in enabled_toolsets, the Track C specialist cannot run kubectl and the entire apply chain breaks.

### Pattern 2: Webhook → Morgan Invocation Flow

When `hermes webhook subscribe alertmanager --prompt "..."` fires:

1. AlertManager POST to `http://host.docker.internal:8644/webhooks/alertmanager`
2. `WebhookAdapter._handle_webhook()` parses payload, renders `{alerts}` template
3. `asyncio.create_task(self.handle_message(event))` — non-blocking, returns 202 immediately
4. `handle_message` is inherited from `BasePlatformAdapter` — runs agent in-process
5. Agent's response is delivered per `route_config.deliver` setting

For Phase 9 FLEET-01, the webhook is configured with `--profile fleet` pointing to Morgan. The `{alerts}` payload reaches Morgan as the prompt text. Morgan runs in-process in the gateway.

Morgan then calls `delegate_task` for Track C diagnosis. After receiving Track C findings, Morgan synthesizes and posts proposal to Telegram (cross-platform delivery: `deliver: telegram` with `chat_id` from `TELEGRAM_ALLOWED_USERS`).

After human Telegram approval, Morgan calls `delegate_task` again for Track C apply step with `context` field containing `HERMES_LAB_GOVERNANCE=L4 HERMES_LAB_TRACK=track-c`. **Note:** env var propagation works at os.environ level (shared process), but the `context` field in `delegate_task` is the LLM-facing instruction, not the Python environment. The planner must ensure the gateway process itself has `HERMES_LAB_GOVERNANCE=L4` set before Morgan runs, OR Morgan's delegation logic sets env vars (which it can do via terminal tool if it has terminal access — but Morgan doesn't).

**Recommended approach:** Export `HERMES_LAB_GOVERNANCE=L4` in the lab's export block BEFORE starting the gateway. The gateway process inherits the env var, Morgan inherits it, delegated children inherit it. L4 is the escalated level for the full chain. L2 (read-only diagnosis) and L4 (apply) both need to be supported — the lab can start at L4 and the wrapper allows everything L2 does plus apply.

### Pattern 3: L4 Track C Allowlist — `kubectl apply` Is In There

From `governance/governance-L4-track-c.yaml` (confirmed read):

```yaml
wrapper_allowlist:
  kubectl:
    # L3 baseline...
    - "apply "
    - "rollout undo"
```

`kubectl apply` (prefix match `"apply "`) is in the L4 Track C allowlist. Phase 9 D-03 (specialist applies under L4 governance) works with existing Phase 7 infrastructure. No modifications to governance YAML needed.

**Wrapper behavior:** `mock-kubectl` reads `HERMES_LAB_GOVERNANCE` + `HERMES_LAB_TRACK`, finds `governance-L4-track-c.yaml`, checks the `wrapper_allowlist.kubectl` list, finds `"apply "` matches `kubectl apply -f memory-patch.yaml`, passes through. If `HERMES_LAB_MODE=mock`, the apply is intercepted (no real cluster change — appropriate for Solo Learner callout). If `HERMES_LAB_MODE=live`, real kubectl apply runs.

### Pattern 4: Path B GitOps Helm Fallback (apply.sh)

Since no Helm chart for the crasher workload exists, Phase 9 must choose between:

**Option A (recommended):** `apply.sh` wraps `kubectl apply -f <merged-patch>` against the crashloop namespace. The crasher deployment is just a Kubernetes manifest, not a Helm release. The "fix" is a `kubectl apply -f memory-patch.yaml -n k8s-trouble-crashloop` after patching the YAML. No Helm needed for Path B Sub-path B2 if framed as "GitOps manifest apply" rather than "Helm upgrade".

**Option B:** Create a minimal Helm chart for the crasher workload (`infrastructure/scenarios/k8s/gitops/crasher-chart/`) with `values.yaml` containing the memory limit. `apply.sh` calls `helm upgrade`. Adds overhead, less teachable.

**Planner recommendation:** Use Option A. The `apply.sh` script creates the patched YAML from the PR diff and calls `kubectl apply`. This is authentic GitOps at the manifest level. The teaching point (PR → merge → apply) remains intact. Label this "GitOps manifest apply via PR" not "Helm upgrade".

### Pattern 5: Telegram Approval → Morgan Re-delegation Flow

The Telegram approval flow creates a state coupling problem: Morgan posts a proposal to Telegram (via cross-platform delivery from the webhook-triggered agent run), then the participant sends `/approve <incident-id>` via Telegram slash command, which triggers a NEW agent run. How does the new Morgan invocation know which incident is being approved?

**Hermes-native approach:** The approval handler (Telegram bot's `_handle_command`) invokes Morgan with the slash command text as the prompt. Morgan's SOUL.md + context must reconstruct the approval → re-delegation. This requires Morgan to either: (a) query `hermes sessions` for the prior run, or (b) receive a self-contained approval prompt that includes the incident context.

**Recommended approach for lab (planner discretion):** The Telegram proposal message Morgan sends includes the full incident summary AND the kubectl command in the message body. When the participant sends `/approve`, the bot includes the original incident message in the context (Telegram threading). Morgan's re-delegation context field in the approval handler prompt template should include: `"Apply approved for incident [ID]. Command: kubectl apply -f memory-patch.yaml -n k8s-trouble-crashloop"`. The specialist runs it.

This is simpler than session lookup and demonstrates the real-world pattern: ChatOps approval messages carry the context they need to be acted on.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Inter-agent delegation | Custom subprocess manager | `delegate_task` tool (already in Hermes) | In-process, toolset-scoped, depth-limited, already tested |
| Telegram approval gateway | Custom HTTP bot server | Phase 8 Telegram adapter (telegram.py) | 91.6K of battle-tested bot code already shipped |
| Webhook → agent invocation | Custom web server | Hermes webhook gateway (webhook.py) | Already running from Phase 8, just needs Morgan profile subscription |
| L4 kubectl enforcement | Custom approval gate | Phase 7 mock-kubectl wrapper with `wrapper_allowlist` | Already reads `HERMES_LAB_GOVERNANCE`, already has `apply ` in L4 track-c allowlist |
| GitOps apply trigger | Full ArgoCD install | `infrastructure/scenarios/k8s/gitops/apply.sh` | ArgoCD install infrastructure does not exist in repo; script is faster and teachable |
| Sandbox CRD installation | Custom CRD manifests | `kubectl apply -f https://github.com/kubernetes-sigs/agent-sandbox/releases/download/v0.2.1/manifest.yaml` | Alpha CRDs change — no committed manifests, install command only |

---

## Runtime State Inventory

Phase 9 is NOT a rename/refactor phase. However, it wires live infrastructure that requires participant runtime state to be correct before the lab runs.

| Category | Items | Action Required |
|----------|-------|-----------------|
| Stored data | `hermes sessions` audit trail — prior runs from Phase 7/8 labs | No action needed — read-only, does not block Phase 9 |
| Live service config | Telegram bot (`TELEGRAM_BOT_TOKEN` + `TELEGRAM_ALLOWED_USERS`) set up in Phase 8 lab | Participant must have configured this from Phase 8. Phase 9 lab Step 1 prerequisites checklist must verify. |
| Live service config | Hermes webhook gateway process running on port 8644 | Phase 9 lab starts fresh gateway with `--profile fleet` (not the Phase 8 single-agent profile). Gateway must be stopped and restarted with fleet profile. |
| Live service config | KIND cluster running with Phase 6 scenarios + Phase 7 wrappers on PATH + Phase 8 AlertManager stack | Phase 9 lab Step 1 prerequisites checklist covers all four. |
| OS-registered state | None — no OS-level registrations introduced by Phase 9 | None |
| Secrets/env vars | `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`, `GITHUB_TOKEN` (Path B only), `GITOPS_REPO_URL` (Path B only), `GITOPS_BRANCH_PREFIX` (Path B only) | Export block in Phase 9 lab Step 1. All extend Phase 8 set. |
| Build artifacts | None — no compiled artifacts | None |

---

## Common Pitfalls

### Pitfall 1: Toolset Intersection Blocks Track C Terminal Access (LOAD-BEARING)

**What goes wrong:** Morgan's `config.yaml` has `cli: [web, skills]` — no `terminal`. When Morgan calls `delegate_task`, the child toolset is intersected with Morgan's enabled_toolsets. Track C specialist gets `{web, skills}` — no `terminal` — and cannot run `kubectl`.

**Why it happens:** `delegate_tool.py` line 178 enforces security: subagents cannot gain tools the parent lacks. Morgan is a coordinator and was designed not to execute — but that design assumption blocks it from delegating terminal work.

**How to avoid:** Phase 9 plan must add `terminal` to Morgan's platform_toolsets for the live gateway context OR create a `fleet-live` profile variant. The `terminal` entry must be present in Morgan's `enabled_toolsets` even though Morgan's SOUL.md prohibits it from using terminal directly. Morgan's SOUL.md NEVER rules remain the behavioral gate; the toolset must be present structurally.

**Warning signs:** Track C specialist returns "I don't have access to the terminal tool" or similar — this is the toolset intersection kicking in.

### Pitfall 2: `HERMES_LAB_GOVERNANCE=L4` Must Be Set BEFORE Gateway Starts

**What goes wrong:** Participant sets `HERMES_LAB_GOVERNANCE=L4` after `hermes gateway run` — the gateway process already has `L2` in its env. Delegated children inherit the old value.

**Why it happens:** `os.environ` is copied at process start. Changes in a new terminal tab don't propagate to a running process.

**How to avoid:** Lab export block sets `HERMES_LAB_GOVERNANCE=L4` BEFORE `hermes gateway run`. Phase 9 lab Step 1 must include this in the complete export block. Show `echo $HERMES_LAB_GOVERNANCE` verification step.

### Pitfall 3: PrometheusRule `release: kube-prometheus` Label (Already Known — Verify Status)

**What goes wrong:** PrometheusRule silently ignored if the `release: kube-prometheus` label doesn't match the actual Helm release name.

**Why it happens:** `kube-prometheus-stack` Helm chart configures its Prometheus CRD `ruleSelector` to only discover PrometheusRule resources with matching `release` label.

**Verification:** The helm install command in `infrastructure/scenarios/k8s/alertmanager/README.md` uses `helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack`. Release name is `kube-prometheus`. The `prometheus-rules.yaml` label `release: kube-prometheus` matches. **This is CORRECT and already confirmed by Phase 8 research.**

**How to avoid:** Lab includes `kubectl get prometheusrule -n monitoring` verification step to confirm rule appears.

### Pitfall 4: Webhook Deliver Type `telegram` Requires Gateway Runner Cross-Platform Routing

**What goes wrong:** Morgan posts proposal to Telegram via `deliver: telegram` — but this requires `WebhookAdapter.gateway_runner` to be set and the Telegram adapter to be running in the same gateway process.

**Why it happens:** `webhook.py` `_deliver_cross_platform` (line 579) checks `self.gateway_runner` — this is set externally. The gateway runner must have BOTH webhook AND telegram platforms enabled.

**How to avoid:** Morgan's `config.yaml` (fleet profile) must enable both `webhook` and `telegram` platforms. Lab must confirm `hermes gateway run` starts with the fleet profile that has both. The bot-config.example.yaml from Phase 8 covers the Telegram side.

### Pitfall 5: Telegram Approval State — Incident ID Must Be Self-Contained in Proposal Message

**What goes wrong:** Morgan posts "incident summary" without including the command to run. When participant sends `/approve`, the new Morgan invocation has no context about what to apply.

**Why it happens:** Hermes sessions are per-run — the approval slash command spawns a new agent run with no memory of the prior run's incident findings.

**How to avoid:** Morgan's proposal template (in SOUL.md or webhook prompt template) must include the full kubectl command in the Telegram message, e.g.:

```
INCIDENT PROPOSAL — CrashLoopBackOff in k8s-trouble-crashloop
Root cause: OOMKilled (memory limit 64Mi, needs 256Mi)
Proposed fix: kubectl apply -f /tmp/memory-patch.yaml -n k8s-trouble-crashloop
Governance: L4 (apply)
Reply: /approve incident-001 OR /reject incident-001
```

Lab instruction tells the participant to include this full context in the `/approve incident-001` channel message or via the bot's threaded reply feature.

### Pitfall 6: Module 11 Lab Mirror Sync

**What goes wrong:** `course-site/docs/module-11-fleet/lab/LAB.mdx` is updated but `modules/module-11-fleet/LAB.md` is not updated (or vice versa).

**Why it happens:** Phase 7 and 8 established the dual-mirror pattern, but automated sync doesn't exist — planner must include both files in the same task.

**How to avoid:** Phase 9 FLEET-02 plan must explicitly list BOTH files in every task that modifies the lab.

---

## Code Examples

### Delegation with explicit toolsets (from delegate_tool.py)

```python
# Source: tools/delegate_tool.py line 178-184
# When Morgan calls delegate_task with explicit toolsets,
# they are intersected with Morgan's enabled_toolsets.
# If Morgan has cli: [web, skills], child gets {web, skills} ∩ {terminal, file, web, skills} = {web, skills}
# Terminal is stripped — kubectl is unavailable to the child.

# SOLUTION: Morgan's config.yaml must include terminal in platform_toolsets:
# platform_toolsets:
#   cli: [terminal, web, skills]   # terminal added for delegation support
#                                  # SOUL.md NEVER rules still prevent Morgan from using it
```

### Morgan fleet profile config (required state for Phase 9)

```yaml
# agents/fleet-coordinator/config.yaml — Phase 9 adds terminal to toolsets
model:
  default: "anthropic/claude-haiku-4"
  provider: "auto"

platform_toolsets:
  cli: [terminal, web, skills]  # terminal added: required for child delegation to Track C
                                 # Morgan SOUL.md NEVER rules prevent direct kubectl use

delegation:
  max_iterations: 30
  default_toolsets: ["terminal", "file", "web", "skills"]  # existing

approvals:
  mode: manual
  timeout: 300

agent:
  max_turns: 30
  verbose: false
```

### Webhook subscribe command for FLEET-01

```bash
# Source: infrastructure/scenarios/k8s/alertmanager/README.md (pattern extended for fleet)
hermes webhook subscribe alertmanager \
  --profile fleet \
  --events "alertmanager-alert" \
  --prompt "AlertManager alert received: {alerts}. \
You are Morgan, the fleet coordinator. \
1. Triage: identify which domains are affected. \
2. Delegate to track-c specialist to diagnose the K8s issue. \
3. After receiving findings, synthesize root cause and propose a fix as a kubectl apply command. \
4. Post the proposal to the Telegram approval channel. \
5. After /approve received, re-delegate to track-c with governance=L4 to apply the fix." \
  --deliver telegram
```

### K8s Agent Sandbox install command (exploratory only)

```bash
# Source: https://github.com/kubernetes-sigs/agent-sandbox releases (verified 2026-04-07)
# Current release: v0.2.1 (alpha — CRD names subject to change)
kubectl apply -f https://github.com/kubernetes-sigs/agent-sandbox/releases/download/v0.2.1/manifest.yaml

# Verify CRDs installed:
kubectl get crd | grep agents.x-k8s.io
# Expected: sandboxes.agents.x-k8s.io
#           sandboxtemplates.agents.x-k8s.io  (if extensions.yaml applied)

# Extensions (SandboxClaim, SandboxWarmPool):
kubectl apply -f https://github.com/kubernetes-sigs/agent-sandbox/releases/download/v0.2.1/extensions.yaml
```

### Path B memory-patch.yaml overlay structure

```yaml
# Source: Researcher recommendation (Claude's discretion per CONTEXT.md)
# infrastructure/scenarios/k8s/gitops/memory-patch.yaml
# Generated by Track C specialist after diagnosis, committed to feature branch
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crasher
  namespace: k8s-trouble-crashloop
spec:
  template:
    spec:
      containers:
      - name: crasher
        resources:
          limits:
            memory: "256Mi"
          requests:
            memory: "128Mi"
```

### apply.sh helm/kubectl fallback script

```bash
#!/usr/bin/env bash
# infrastructure/scenarios/k8s/gitops/apply.sh
# Path B Sub-path B2: apply a merged YAML patch after PR merge
# Usage: ./apply.sh <patch-file>
set -euo pipefail
PATCH_FILE="${1:-memory-patch.yaml}"
NAMESPACE="k8s-trouble-crashloop"

echo "[gitops/apply.sh] Applying patch: ${PATCH_FILE}"
echo "[gitops/apply.sh] Namespace: ${NAMESPACE}"

# Validate the patch file exists
if [[ ! -f "${PATCH_FILE}" ]]; then
  echo "ERROR: Patch file not found: ${PATCH_FILE}" >&2
  exit 1
fi

# Apply the patch
kubectl apply -f "${PATCH_FILE}" -n "${NAMESPACE}"
echo "[gitops/apply.sh] Applied. Checking rollout..."
kubectl rollout status deployment/crasher -n "${NAMESPACE}" --timeout=60s
```

---

## K8s Agent Sandbox — Current Status

**Source:** https://github.com/kubernetes-sigs/agent-sandbox (verified 2026-04-07)

| Property | Value |
|----------|-------|
| Latest release | v0.2.1 (Mar 14, 2026) |
| API version | `agents.x-k8s.io/v1alpha1` |
| Maturity | Alpha — CRDs subject to breaking changes |
| KIND v0.31 compatibility | Not explicitly documented |
| CRD names | `Sandbox`, `SandboxTemplate`, `SandboxClaim`, `SandboxWarmPool` |
| Total releases | 6 (active development) |
| D-15 decision | Exploratory only — confirmed correct given alpha status |

**Recommended pinned release for PROJECTS.mdx:** `v0.2.1` (latest at research time). Lab text must note this is alpha and the install URL may need updating for newer releases.

**Install verification command:**
```bash
kubectl get crd | grep agents.x-k8s.io
```

---

## ArgoCD Presence in Course Repo — Full Audit

**Source:** Direct file search of course repo (2026-04-07)

| Location | Status | Notes |
|----------|--------|-------|
| `reference-app/helm/setup-argocd.sh` | DOES NOT EXIST | Referenced in Module 5 PROJECTS.mdx but never committed |
| `infrastructure/` ArgoCD manifests | DOES NOT EXIST | No ArgoCD YAML anywhere in infrastructure/ |
| `course-site/docs/module-05-*/lab/` | No Track B ArgoCD lab | Module 5 has Track A (Helm) and Track B (Terraform) only |
| Instructor guides | ArgoCD mentioned as setup requirement | `instructor/day-2-guide.md` assumes setup-argocd.sh exists but it doesn't |

**Verdict:** ArgoCD is **documentation-only**. No infrastructure code for ArgoCD exists in the course repo. Phase 9 Sub-path B1 (ArgoCD sync) cannot be a guided lab step.

**Phase 9 Path B guidance:**
- Primary Path B: Sub-path B2 (`infrastructure/scenarios/k8s/gitops/apply.sh`)
- Sub-path B1: Callout block — "If you have ArgoCD installed: `kubectl apply -n argocd -f application.yaml`" — no setup steps provided

---

## Reference-App Helm Chart — Audit

**Source:** Direct file search of course repo (2026-04-07)

No `Chart.yaml` or `values.yaml` found anywhere in the course repo. The `reference-app/` directory contains a Rust workspace (Cargo.toml, services/, dashboard/) and Docker Compose files — no Helm chart.

The reference app is deployed via Docker Compose for local dev and direct `kubectl apply` for KIND. There is no Helm chart for the reference app.

**Impact:** D-09 in CONTEXT.md references "helm upgrade --install reference-app reference-app/helm/ --values <merged-patch>". This cannot be executed against the reference Rust app because no chart exists.

**Recommended resolution:** Path B Sub-path B2 applies the crasher deployment YAML patch directly (see apply.sh pattern above). The description "helm upgrade fallback" in CONTEXT.md was conceptual. The actual implementation uses `kubectl apply -f memory-patch.yaml`. This is a simpler and more authentic implementation — GitOps at the manifest level rather than Helm chart level. Lab text should use "GitOps manifest apply" terminology.

---

## Module 11 Infrastructure — Current State

### Lab files

| File | Exists | Lines | Content |
|------|--------|-------|---------|
| `course-site/docs/module-11-fleet/lab/LAB.mdx` | YES | 652 | 7-step mock-only walkthrough. Phase 9 REPLACES entirely. |
| `modules/module-11-fleet/LAB.md` | YES | 626 | Mirror of MDX (without MDX front matter and admonitions). Phase 9 REPLACES entirely. |

### Cross-domain fixture

The Module 11 mock lab uses `HERMES_LAB_SCENARIO=messy` and routes to the "messy" scenario in the mock data. The "memory-hog analytics service" cross-domain scenario is embedded in the lab text — the mock data directory (`infrastructure/mock-data/`) has `cloudwatch/`, `cost-explorer/`, `ec2/`, `kubernetes/`, `rds/` subdirectories but no explicit "cross-domain" fixture file. The fixture is the combination of scenario=messy data across all three tracks.

**D-14 assessment:** The existing cross-domain fixture (HERMES_LAB_SCENARIO=messy) is based on EC2/RDS/K8s scenarios from before Phase 6. Phase 9 replaces the lab, so the mock fixture for the new lab should use `HERMES_LAB_SCENARIO=crashloop2` for the live demo (Phase 6 K8s crashloop) and retain `HERMES_LAB_SCENARIO=messy` for the Solo Learner mock-mode callout path. The existing fixture is STILL USABLE for Solo Learner callouts — it doesn't need updating.

### Reading files

| File | Exists | Lines | Add Target |
|------|--------|-------|-----------|
| `course-site/docs/module-11-fleet/reading/reference.mdx` | YES | 212 | **PROD-02 target** — more reference-heavy than concepts.mdx |
| `course-site/docs/module-11-fleet/reading/concepts.mdx` | YES | 176 | Light touch cross-references only |

Reference.mdx is the correct target for PROD-02 productionization content (confirmed: it currently covers fleet architecture, coordinator SOUL.md template, config templates). Adding ~500-800 lines of productionization content brings it to ~700-1000 lines — comparable to Phase 7's Module 13 reference.mdx.

### Quiz and exploratory

| File | Exists | Current Content |
|------|--------|----------------|
| `course-site/docs/module-11-fleet/quiz/QUIZ.mdx` | YES | Needs reading |
| `course-site/docs/module-11-fleet/exploratory/PROJECTS.mdx` | YES | 107 lines — 2 projects (Incident Response Fleet, Auto-Routing Coordinator). Phase 9 ADDS Sandbox project. |

### Morgan agent files

| File | Exists | Phase 9 Action |
|------|--------|----------------|
| `agents/fleet-coordinator/SOUL.md` | YES | LIGHT EDIT — 3 additions per D-13 |
| `agents/fleet-coordinator/config.yaml` | YES | UPDATE — add `terminal` to `cli` toolsets |

**No Module 11 starter/solution copies of fleet-coordinator found.** There are no `modules/module-11-fleet/agents/` or `course-site/docs/module-11-fleet/lab/starter/` directories. The agents directory is at the course root. Phase 9 lab refers participants to `agents/fleet-coordinator/` directly.

---

## Phase 8 GitHub Webhook PR Creation — Delivery Gap

Hermes `webhook.py` delivery types:
- `log` — terminal only
- `github_comment` — calls `gh pr comment` on an existing PR
- `telegram` — cross-platform to Telegram adapter
- `discord`, `slack`, `signal`, `sms` — cross-platform

**No `github_pr` or `github_pr_create` delivery type exists.**

**Phase 9 Path B PR creation must use the agent's terminal toolset** to call `gh pr create`. The specialist agent:
1. Writes the memory-patch.yaml file
2. `git checkout -b ${GITOPS_BRANCH_PREFIX}$(date +%s)`
3. `git add memory-patch.yaml && git commit -m "fix: increase crasher memory limit to 256Mi"`
4. `git push origin <branch>`
5. `gh pr create --title "fix: increase crasher memory limit" --body "..." --base main`

The delivery mechanism for the PR URL back to the participant is: the agent's text response includes the PR URL. If cross-platform delivery to Telegram is configured, the agent's final message (containing the PR URL) is posted to Telegram. This works with existing `deliver: telegram` mechanism — no new delivery type needed.

**Summary:** Phase 9 Path B works without new Hermes code. The agent uses its terminal toolset to create the PR. The existing `deliver: telegram` posts the PR URL back to the approval channel.

---

## PrometheusRule Label — Verification

**Confirmed CORRECT (no action needed).**

The helm install command in `infrastructure/scenarios/k8s/alertmanager/README.md` uses release name `kube-prometheus`:
```bash
helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack ...
```

The `prometheus-rules.yaml` label:
```yaml
labels:
  release: kube-prometheus
```

These match. The `ruleSelector` in kube-prometheus-stack matches `release: kube-prometheus`. Phase 8 noted this as a potential open question; it is confirmed resolved.

---

## Environment Availability

| Dependency | Required By | Available | Notes |
|------------|------------|-----------|-------|
| KIND cluster | FLEET-01 live demo | Participant-dependent | Setup from Phase 6. Lab Step 1 prerequisites checklist must verify. |
| Telegram bot | FLEET-01 approval loop | Participant-dependent | Setup from Phase 8. Must have `TELEGRAM_BOT_TOKEN` + `TELEGRAM_ALLOWED_USERS`. |
| Hermes gateway (port 8644) | FLEET-01 webhook ingestion | Participant starts it | Phase 8 confirmed. Restarted with fleet profile for Phase 9. |
| `gh` CLI | Path B PR creation | Phase 8 prerequisite | Phase 8 lab already requires `gh` for `gh pr comment`. Present if Phase 8 completed. |
| `git` CLI | Path B branch/commit | Universal | Standard prerequisite. |
| ArgoCD | Sub-path B1 | NOT in repo | Sub-path B1 is optional callout only. No Phase 9 setup steps for ArgoCD. |

**Missing dependencies with no fallback:**
- KIND cluster + Prometheus stack: required for FLEET-01 live demo. Solo Learner callouts use mock-mode fallback — this is the planned fallback.

**Missing dependencies with fallback:**
- ArgoCD (Sub-path B1): fallback is Sub-path B2 `apply.sh` — this is the PRIMARY guided path.

---

## Validation Architecture

Per `.planning/config.json` (not found — treating nyquist_validation as enabled by default).

Phase 9 deliverables are primarily content (MDX files, YAML infrastructure, shell scripts). Validation is functional + content review, not unit tests.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Manual functional verification (no automated test suite for content) |
| Config file | None |
| Quick run command | `bash infrastructure/scenarios/k8s/gitops/apply.sh memory-patch.yaml` (smoke test) |
| Full suite command | End-to-end: AlertManager fire → Morgan delegation → Telegram approval → apply |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Verification |
|--------|----------|-----------|-------------|
| FLEET-01 | Full chain: AM fires → Morgan triages → Track C diagnoses → proposal → Telegram approve → apply | Integration/live | Manual: follow lab steps on KIND. Solo Learner: mock mode with HERMES_LAB_MODE=mock. |
| FLEET-02 | Morgan synthesizes input from 2+ specialists | Manual review | Run Morgan with cross-domain scenario, verify synthesis output cites both domain findings. |
| PROD-01 | Sandbox CRDs install on KIND, agent deploys in sandbox mode | Exploratory/manual | `kubectl get crd \| grep agents.x-k8s.io` after install. |
| PROD-02 | Reading covers 4 productionization topics with Hermes config examples | Content review | Review reference.mdx new section for all 4 topics + cross-references. |

### Wave 0 Gaps

- [ ] `infrastructure/scenarios/k8s/gitops/` directory — does not exist, needs creation
- [ ] `infrastructure/scenarios/k8s/gitops/apply.sh` — new script
- [ ] `infrastructure/scenarios/k8s/gitops/memory-patch.yaml` — sample patch
- [ ] `infrastructure/scenarios/k8s/gitops/README.md` — documentation
- [ ] Morgan `config.yaml` update — add `terminal` to toolsets (LOAD-BEARING for Pitfall 1)

---

## Open Questions

1. **Toolset inheritance resolution for Morgan delegation**
   - What we know: Morgan's `config.yaml` has `cli: [web, skills]`. Delegation intersects with parent toolsets. Children cannot gain `terminal` if Morgan lacks it.
   - What's unclear: Does `gateway/run.py` override `platform_toolsets` when launching an agent? Does the gateway process always enable all toolsets regardless of config?
   - Recommendation: Planner verifies by checking `run_agent.py` `enabled_toolsets` initialization logic. If gateway always enables terminal, no config change needed. If it respects config.yaml, Morgan's config must be updated.

2. **Telegram → Morgan re-delegation incognito context**
   - What we know: Approval `/approve incident-001` spawns a new agent run. New run has no memory of prior diagnostic run.
   - What's unclear: Does the lab walkthrough have Morgan write a structured proposal file (e.g., `/tmp/incident-001.json`) that the approval handler reads? Or is the Telegram message text sufficient?
   - Recommendation: Simplest approach — Telegram proposal message is self-contained (includes kubectl command). Approval handler prompt template includes the full incident message text. Lab walks participant through configuring this in bot-config.

3. **Solo Learner Telegram mock for FLEET-01**
   - What we know: D-12 requires Solo Learner callouts with mock-mode equivalent.
   - What's unclear: What exactly is the mock path for Telegram approval? The participant can't use `/approve` without a running bot.
   - Recommendation: Solo Learner callout says: "Skip Telegram approval. Set `HERMES_LAB_GOVERNANCE=L4` and run: `hermes -p track-c chat` with the prompt: 'Apply the approved fix: kubectl apply -f infrastructure/scenarios/k8s/gitops/memory-patch.yaml -n k8s-trouble-crashloop'. Observe the L4 governance pass-through.'"

---

## State of the Art

| Old Approach (v1.0) | Current Approach (Phase 9) | Impact |
|---------------------|---------------------------|--------|
| Module 11 mock-only fleet lab (HERMES_LAB_SCENARIO=messy, no real agents) | Live-primary fleet lab with AlertManager → Morgan → Track C → Telegram approval → apply | Participants see a real automated incident response chain, not a mock walkthrough |
| Fleet coordinator demonstrates delegation conceptually | Fleet coordinator delegates to WORKING Track C specialist with real K8s skills | Agents produce actual diagnostic output, not placeholder text |
| No productionization content | ~500-800 line reference section: packaging, deployment, monitoring, scaling | Participants understand how to take their Phase 6-9 agents to production |
| K8s Agent Sandbox not covered | Exploratory PROJECTS.mdx entry with install + deploy walkthrough (alpha v0.2.1) | Participants exposed to Kubernetes-native agent isolation even before Sandbox reaches GA |

---

## Sources

### Primary (HIGH confidence)
- `/Users/gshah/work/agentic/devops/hermes-agent/tools/delegate_tool.py` — Full delegation mechanism, env inheritance, toolset intersection logic
- `/Users/gshah/work/agentic/devops/hermes-agent/gateway/platforms/webhook.py` — Webhook → agent invocation flow, delivery types
- `/Users/gshah/work/agentic/devops/course/governance/governance-L4-track-c.yaml` — L4 Track C allowlist with `apply ` entry confirmed
- `/Users/gshah/work/agentic/devops/course/agents/fleet-coordinator/config.yaml` — Morgan current toolsets (`cli: [web, skills]`) confirmed
- `/Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/alertmanager/README.md` — Helm release name `kube-prometheus` confirmed
- `/Users/gshah/work/agentic/devops/course/infrastructure/scenarios/k8s/alertmanager/prometheus-rules.yaml` — `release: kube-prometheus` label confirmed
- `/Users/gshah/work/agentic/devops/course/course-site/docs/module-11-fleet/` — Module 11 structure, both mirrors, reading file line counts
- `/Users/gshah/work/agentic/devops/course/modules/module-11-fleet/LAB.md` — Mirror confirmed exists, 626 lines
- https://github.com/kubernetes-sigs/agent-sandbox — v0.2.1 current release, CRD names, alpha status (WebFetch 2026-04-07)

### Secondary (MEDIUM confidence)
- Phase 8 RESEARCH.md (prior verified findings): Telegram adapter exists, Hermes Docker image, github_comment built-in — all still valid
- Phase 7 CONTEXT.md D-07: `kubectl apply` confirmed in L4 Track C — matches governance-L4-track-c.yaml (corroborated by file read)

### Tertiary (LOW confidence)
- K8s Agent Sandbox KIND v0.31 compatibility — not documented; assumed compatible given standard Kubernetes CRD API compatibility

---

## Metadata

**Confidence breakdown:**
- Hermes delegation env propagation (D-03): HIGH — read `delegate_tool.py` source
- Hermes toolset intersection (BLOCKER for Morgan terminal): HIGH — read source, line citations
- Webhook → agent flow: HIGH — read `webhook.py` source
- L4 allowlist `kubectl apply`: HIGH — read governance yaml
- ArgoCD absence: HIGH — exhaustive file search
- Reference-app Helm chart absence: HIGH — exhaustive file search
- Module 11 infrastructure: HIGH — read all files
- K8s Agent Sandbox: MEDIUM — WebFetch from GitHub

**Research date:** 2026-04-07
**Valid until:** 2026-05-07 (30 days — stable infrastructure, alpha Sandbox may change faster)
