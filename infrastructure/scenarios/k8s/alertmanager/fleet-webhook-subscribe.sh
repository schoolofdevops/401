#!/usr/bin/env bash
# infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh
#
# Phase 9 FLEET-01: subscribe the Hermes webhook gateway to AlertManager events
# with Morgan (fleet profile) as the receiving agent.
#
# This is the FLEET-01 wiring command: AlertManager → host.docker.internal:8644
# → webhook gateway → Morgan (in-process agent invocation) → delegation to Track C
# → Telegram approval → re-delegation with L4 governance → kubectl apply via wrapper.
#
# This script does NOT start the gateway process — it subscribes a route on an
# already-running gateway. The gateway must be started FIRST with the fleet profile
# active and both webhook + telegram platforms enabled.
#
# Usage (after the gateway is running):
#   bash infrastructure/scenarios/k8s/alertmanager/fleet-webhook-subscribe.sh
#
# Prerequisites (from Phase 8):
#   - Hermes gateway running on port 8644 with --profile fleet
#   - Telegram adapter active in the same gateway process (for deliver: telegram)
#   - AlertManager configured to POST to http://host.docker.internal:8644/webhooks/alertmanager
#     (see alertmanager-config.yaml in this directory)
#   - Morgan profile updated with terminal toolset (Phase 9 Plan 01 Task 1)
#
# Required env vars (set BEFORE starting the gateway so they propagate to agent runs):
#   HERMES_LAB_MODE=live
#   HERMES_LAB_GOVERNANCE=L4         <- escalated for full chain through apply step
#   HERMES_LAB_TRACK=track-c          <- scenario is K8s crashloop
#   HERMES_LAB_SCENARIO=crashloop2
#   TELEGRAM_BOT_TOKEN                <- from Phase 8 @BotFather
#   TELEGRAM_ALLOWED_USERS            <- from Phase 8 admin allowlist
#   GITOPS_REPO_URL                   <- Phase 9 Path B only
#   GITOPS_BRANCH_PREFIX=hermes-fix-  <- Phase 9 Path B only
#
# Verify env vars are set in the gateway process (not just your terminal):
#   ps aux | grep 'hermes gateway'
#   Then inspect the process's env via /proc/<pid>/environ on Linux or lsof on macOS.

set -euo pipefail

# Fleet coordinator receives alert text as prompt.
# The prompt template below is the complete instruction Morgan receives when AlertManager fires.
# {alerts} is the full alerts array payload from AlertManager (Hermes template variable).
# Morgan's SOUL.md + this prompt together drive the triage -> delegate -> synthesize flow.
PROMPT='AlertManager alert received: {alerts}.

You are Morgan, the fleet coordinator. Your job is to triage this incident and
coordinate specialist diagnosis and remediation.

1. TRIAGE: Identify which domains are affected based on the alert labels and annotations.
   - kubernetes alerts -> Track C specialist
   - database alerts -> Track A specialist
   - cost/AWS alerts -> Track B specialist

2. DELEGATE: For each affected domain, delegate ONE task to the appropriate specialist.
   Clear scope: "Diagnose the specific pod/service referenced in the alert."

3. SYNTHESIZE: After specialists respond, combine their findings into a unified root
   cause summary.

4. PROPOSE: Generate a fix recommendation as either:
   - Path A: a kubectl patch command (for direct apply)
   - Path B: a YAML overlay file path (for GitOps PR)

5. POST TO TELEGRAM: Send a structured proposal message including:
   - Incident summary (alert name + affected resource)
   - Root cause (from specialist findings)
   - Proposed fix (kubectl command OR PR URL)
   - Governance level required (L4 for apply)
   - Approval format: /approve incident-<id> OR /reject incident-<id>

6. AWAIT APPROVAL: Do NOT execute or re-delegate the fix before receiving /approve.
   Per your NEVER rules: delegation, not execution.

7. ON APPROVAL: Re-delegate to the SAME specialist that diagnosed the issue, including
   HERMES_LAB_GOVERNANCE=L4 in the instructions so the specialist runs the apply
   under the L4 wrapper_allowlist enforcement (Phase 7 wrapper).'

hermes webhook subscribe alertmanager \
  --profile fleet \
  --events "alertmanager-alert" \
  --prompt "${PROMPT}" \
  --deliver telegram

echo ""
echo "[fleet-webhook-subscribe.sh] Subscribed. AlertManager -> Morgan is now wired."
echo ""
echo "Next step: trigger a test alert to verify the chain:"
echo "  kubectl apply -f infrastructure/scenarios/k8s/02-crashloop-backoff.yaml"
echo "  # Wait 2-3 minutes for AlertManager to fire, then check:"
echo "  kubectl logs -n monitoring -l alertname=KubePodCrashLooping --tail=20"
echo "  # Morgan should receive the alert and begin triage."
