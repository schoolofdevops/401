#!/usr/bin/env bash
# course/setup/verify.sh
# Pre-workshop environment validation for Agentic DevOps course.
#
# Usage: bash verify.sh  (run from any directory — uses relative paths from script location)
# Exits 0 if all checks pass, 1 if any fail.
# Expected final output: "Ready for labs!" with all PASS lines.
#
# Compatibility: bash 3.2+ (macOS system bash, Linux bash)
#   - No declare -A (no associative arrays)
#   - No mapfile / readarray
#   - Uses PASS/FAIL counters, not arrays
#   - Uses $((expr)) arithmetic, not ((++var))

set -uo pipefail

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COURSE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export COURSE_ROOT

# ── Check helper ────────────────────────────────────────────────────────────
# Usage: check "description" command [args...]
# Runs the command silently. Prints PASS or FAIL. Increments counters.
check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '  PASS  %s\n' "$desc"
    PASS=$((PASS + 1))
  else
    printf '  FAIL  %s\n' "$desc"
    FAIL=$((FAIL + 1))
  fi
}

printf '=== Agentic DevOps Course — Environment Verification ===\n'
printf '\n'

# ── Section 1: Required CLI Tools ───────────────────────────────────────────
printf '%s\n' '--- Required CLI Tools ---'

check "Docker daemon running" \
  docker info

check "Docker version >= 24" \
  bash -c 'docker --version 2>&1 | grep -E "Docker version 2[4-9]\.|Docker version [3-9][0-9]\."'

check "kubectl installed" \
  kubectl version --client

check "kind installed" \
  kind version

check "kind version >= 0.27" \
  bash -c 'kind version 2>&1 | grep -E "v0\.(2[7-9]|[3-9][0-9])\.|v[1-9][0-9]*\."'

check "Helm installed" \
  helm version

check "Helm version >= 3" \
  bash -c 'helm version 2>&1 | grep -E "v3\."'

check "Node.js installed" \
  node --version

check "Node.js version >= 18" \
  bash -c 'node --version 2>&1 | grep -E "v(1[89]|[2-9][0-9])\."'

printf '\n'

# ── Section 2: AI Coding Tools (at least one required) ──────────────────────
printf '%s\n' '--- AI Coding Tools (at least one required) ---'
AI_TOOL_FOUND=0

if command -v claude >/dev/null 2>&1; then
  check "Claude Code installed" claude --version
  AI_TOOL_FOUND=1
else
  printf '  SKIP  Claude Code not installed (Path A — optional if using OpenCode)\n'
fi

if command -v opencode >/dev/null 2>&1; then
  check "OpenCode installed" opencode --version
  AI_TOOL_FOUND=1
else
  printf '  SKIP  OpenCode not installed (Path B — optional if using Claude Code)\n'
fi

if [ "$AI_TOOL_FOUND" -eq 0 ]; then
  printf '  FAIL  No AI coding tool found. Install Claude Code (Path A) or OpenCode (Path B).\n'
  printf '        See setup/SETUP.md Step 4.\n'
  FAIL=$((FAIL + 1))
fi

printf '\n'

# ── Section 3: Optional Tools ────────────────────────────────────────────────
printf '%s\n' '--- Optional Tools ---'

check "git installed" \
  git --version

if command -v aws >/dev/null 2>&1; then
  check "AWS CLI v2 installed (optional)" \
    bash -c 'aws --version 2>&1 | grep "aws-cli/2"'
else
  printf '  SKIP  AWS CLI not installed (optional — labs have mock data fallback)\n'
fi

printf '\n'

# ── Section 4: KIND Cluster ──────────────────────────────────────────────────
printf '%s\n' '--- KIND Cluster ---'

check "KIND cluster 'lab' exists" \
  bash -c 'kind get clusters 2>/dev/null | grep -q "^lab$"'

check "kubectl context 'kind-lab' configured" \
  bash -c 'kubectl config get-contexts kind-lab >/dev/null 2>&1'

check "kubectl can reach KIND cluster (nodes ready)" \
  kubectl get nodes --context kind-lab

printf '\n'

# ── Section 5: Reference App ─────────────────────────────────────────────────
printf '%s\n' '--- Reference App ---'

check "Reference app Cargo workspace exists" \
  test -f "$COURSE_ROOT/reference-app/Cargo.toml"

check "Helm chart exists" \
  test -f "$COURSE_ROOT/reference-app/helm/reference-app/Chart.yaml"

check "Makefile exists" \
  test -f "$COURSE_ROOT/reference-app/Makefile"

check "Dashboard package.json exists" \
  test -f "$COURSE_ROOT/reference-app/dashboard/package.json"

printf '\n'

# ── Section 6: Mock Data Files ───────────────────────────────────────────────
printf '%s\n' '--- Mock Data Files ---'

check "mock-data/cloudwatch/describe-alarms-clean.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cloudwatch/describe-alarms-clean.json"

check "mock-data/cloudwatch/describe-alarms-anomaly.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json"

check "mock-data/cost-explorer/normal-spend.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cost-explorer/normal-spend.json"

check "mock-data/cost-explorer/anomaly-spike.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cost-explorer/anomaly-spike.json"

check "mock-data/ec2/describe-instances.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/ec2/describe-instances.json"

printf '\n'

# ── Section 7: Mock Wrapper Scripts ─────────────────────────────────────────
printf '%s\n' '--- Mock Wrappers ---'

check "mock-aws wrapper" \
  test -x "$COURSE_ROOT/infrastructure/wrappers/mock-aws"

check "mock-kubectl wrapper" \
  test -x "$COURSE_ROOT/infrastructure/wrappers/mock-kubectl"

printf '\n'

# ── Section 8: Mock Mode Smoke Tests ────────────────────────────────────────
# Verify the mock wrappers actually return data. These tests use HERMES_LAB_MODE=mock
# so they work even without AWS credentials or a running cluster.
printf '%s\n' '--- Mock Mode Smoke Tests ---'

check "mock-aws CloudWatch alarms return data" \
  bash -c 'HERMES_LAB_MODE=mock MOCK_DATA_DIR="$COURSE_ROOT/infrastructure/mock-data" "$COURSE_ROOT/infrastructure/wrappers/mock-aws" cloudwatch describe-alarms 2>/dev/null | grep -q "MetricAlarms"'

check "mock-aws Cost Explorer returns data" \
  bash -c 'HERMES_LAB_MODE=mock MOCK_DATA_DIR="$COURSE_ROOT/infrastructure/mock-data" "$COURSE_ROOT/infrastructure/wrappers/mock-aws" ce get-cost-and-usage 2>/dev/null | grep -q "ResultsByTime"'

printf '\n'

# ── Section 9: Deployment Verification (only if KIND cluster exists) ─────────
printf '%s\n' '--- Deployment Status ---'

if kind get clusters 2>/dev/null | grep -q "^lab$"; then
  check "App pods running in namespace 'app'" \
    bash -c 'kubectl get pods -n app --context kind-lab 2>/dev/null | grep -q "Running"'

  check "Dashboard accessible at localhost:30080" \
    bash -c 'curl -sf http://localhost:30080/ >/dev/null 2>&1'
else
  printf '  SKIP  KIND cluster not running — deploy with: cd reference-app && make deploy\n'
fi

printf '\n'

# ── Results Summary ──────────────────────────────────────────────────────────
printf '=== Results: %s passed, %s failed ===\n' "$PASS" "$FAIL"
printf '\n'

if [ "$FAIL" -eq 0 ]; then
  printf 'Ready for labs!\n'
  exit 0
else
  printf 'Fix the FAIL items above before starting labs.\n'
  printf '\n'
  printf 'Reference guides:\n'
  printf '  Full setup guide:  %s/setup/SETUP.md\n' "$COURSE_ROOT"
  printf '  KIND setup:        %s/setup/setup-kind.md\n' "$COURSE_ROOT"
  printf '  LLM access:        %s/setup/llm-access.md\n' "$COURSE_ROOT"
  printf '\n'
  printf 'Common fixes:\n'
  printf '  Docker not running?         -> Start Docker Desktop\n'
  printf '  KIND cluster missing?       -> cd reference-app && make deploy\n'
  printf '  No AI tool found?           -> See %s/setup/SETUP.md Step 4\n' "$COURSE_ROOT"
  printf '  Mock data files missing?    -> git status (check repo is complete)\n'
  printf '  Dashboard not accessible?  -> kubectl get pods -n app --context kind-lab\n'
  exit 1
fi
