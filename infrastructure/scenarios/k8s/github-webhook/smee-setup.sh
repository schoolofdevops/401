#!/usr/bin/env bash
# Phase 8 / TRIG-03: smee.io client launcher
#
# Forwards GitHub webhook events from a smee.io public channel to the local
# Hermes gateway running on localhost:8644.
#
# Usage:
#   export SMEE_URL="https://smee.io/your-channel-id"
#   ./infrastructure/scenarios/k8s/github-webhook/smee-setup.sh
#
# Or:
#   SMEE_URL=https://smee.io/abc123 ./infrastructure/scenarios/k8s/github-webhook/smee-setup.sh
#
# Prerequisites:
#   - Node.js + npm (for npx)
#   - Hermes gateway running on localhost:8644 (separate terminal)
#   - hermes webhook subscribe github (separate terminal)
#
# Why npx instead of npm install -g smee-client?
#   - No global installs (cleaner participant environment)
#   - No version drift (npx pulls the latest published version each time, or
#     pin via SMEE_CLIENT_VERSION env var below)
#   - Works on participant laptops without sudo

set -euo pipefail

# Pin to a specific smee-client version for reproducibility (override via env if needed)
SMEE_CLIENT_VERSION="${SMEE_CLIENT_VERSION:-5.0.0}"

# Hermes webhook target — matches the route created by `hermes webhook subscribe github`
HERMES_TARGET="${HERMES_TARGET:-http://localhost:8644/webhooks/github}"

# Validate SMEE_URL
if [[ -z "${SMEE_URL:-}" ]]; then
  echo "ERROR: SMEE_URL environment variable is not set."
  echo ""
  echo "Get a channel URL:"
  echo "  1. Visit https://smee.io/"
  echo "  2. Click 'Start a new channel'"
  echo "  3. Copy the URL (looks like https://smee.io/abc123XYZ)"
  echo "  4. export SMEE_URL=\"https://smee.io/abc123XYZ\""
  echo ""
  exit 1
fi

if [[ ! "$SMEE_URL" =~ ^https://smee\.io/ ]]; then
  echo "ERROR: SMEE_URL must start with https://smee.io/"
  echo "Got: $SMEE_URL"
  exit 1
fi

# Sanity-check Node.js is available
if ! command -v npx > /dev/null 2>&1; then
  echo "ERROR: npx not found. Install Node.js + npm first:"
  echo "  macOS:   brew install node"
  echo "  Linux:   sudo apt install nodejs npm   (or use nvm)"
  echo "  Windows: https://nodejs.org/"
  exit 1
fi

# Sanity-check the gateway port is reachable BEFORE starting smee
# (smee-client will silently swallow connection errors otherwise)
if ! curl -sf -o /dev/null "http://localhost:8644/health" 2>/dev/null; then
  echo "WARNING: Hermes gateway not reachable at http://localhost:8644/health"
  echo "Start it in another terminal first: hermes gateway run"
  echo ""
  echo "Continuing anyway in 5 seconds (Ctrl+C to abort)..."
  sleep 5
fi

echo "================================================================"
echo " smee.io → Hermes webhook gateway forwarder"
echo "================================================================"
echo "  Source:  $SMEE_URL"
echo "  Target:  $HERMES_TARGET"
echo "  Client:  smee-client@${SMEE_CLIENT_VERSION}"
echo "================================================================"
echo ""
echo "Press Ctrl+C to stop forwarding."
echo ""

exec npx --yes "smee-client@${SMEE_CLIENT_VERSION}" \
  --url "$SMEE_URL" \
  --target "$HERMES_TARGET"
