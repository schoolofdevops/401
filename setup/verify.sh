#!/usr/bin/env bash
# course/setup/verify.sh
# Pre-workshop environment validation for Hermes Agentic DevOps labs.
#
# Usage: bash verify.sh  (run from any directory — uses relative paths from script location)
# Exits 0 if all checks pass, 1 if any fail.
# Expected final output: "Ready for labs!" with all PASS lines.
#
# Note: LLM connectivity check requires 'hermes login' first.
#       Complete setup/install-hermes.md steps before running verify.sh.
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

printf '=== Hermes Lab Environment Verification ===\n'
printf '\n'

# ── Section 1: Required CLI Tools ───────────────────────────────────────────
printf '--- Tool Versions ---\n'

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

check "aws cli v2 installed" \
  bash -c 'aws --version 2>&1 | grep "aws-cli/2"'

check "hermes installed" \
  hermes --version

printf '\n'

# ── Section 2: Hermes Configuration ─────────────────────────────────────────
printf '--- Hermes Configuration ---\n'

check "Hermes home directory exists (~/.hermes)" \
  test -d "$HOME/.hermes"

check "Hermes config.yaml exists" \
  test -f "$HOME/.hermes/config.yaml"

# Note: This check will FAIL if you have not yet run 'hermes login'.
# Complete setup/install-hermes.md before expecting this to PASS.
check "LLM connectivity (hermes responds to prompt)" \
  bash -c 'hermes run "respond with exactly: OK" --no-stream 2>&1 | grep -q "OK"'

printf '\n'

# ── Section 3: KIND Cluster ──────────────────────────────────────────────────
printf '--- KIND Cluster ---\n'

check "KIND cluster 'lab' exists" \
  bash -c 'kind get clusters 2>/dev/null | grep -q "^lab$"'

check "kubectl context 'kind-lab' configured" \
  bash -c 'kubectl config get-contexts kind-lab >/dev/null 2>&1'

check "kubectl can reach KIND cluster (nodes ready)" \
  kubectl get nodes --context kind-lab

printf '\n'

# ── Section 4: Mock Data Files ───────────────────────────────────────────────
printf '--- Mock Data Files ---\n'

check "Mock data directory exists" \
  test -d "$COURSE_ROOT/infrastructure/mock-data"

check "mock-data/rds/describe-db-instances.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/rds/describe-db-instances.json"

check "mock-data/rds/pg-stat-statements-clean.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/rds/pg-stat-statements-clean.json"

check "mock-data/rds/pg-stat-statements-messy.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/rds/pg-stat-statements-messy.json"

check "mock-data/cost-explorer/normal-spend.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cost-explorer/normal-spend.json"

check "mock-data/cost-explorer/anomaly-spike.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/cost-explorer/anomaly-spike.json"

check "mock-data/kubernetes/get-pods-healthy.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/kubernetes/get-pods-healthy.json"

check "mock-data/kubernetes/get-pods-crashloop.json" \
  test -f "$COURSE_ROOT/infrastructure/mock-data/kubernetes/get-pods-crashloop.json"

printf '\n'

# ── Section 5: Mock Wrapper Scripts ─────────────────────────────────────────
printf '--- Mock Wrappers ---\n'

check "mock-aws wrapper exists and is executable" \
  test -x "$COURSE_ROOT/infrastructure/wrappers/mock-aws"

check "mock-kubectl wrapper exists and is executable" \
  test -x "$COURSE_ROOT/infrastructure/wrappers/mock-kubectl"

check "mock-psql wrapper exists and is executable" \
  test -x "$COURSE_ROOT/infrastructure/wrappers/mock-psql"

printf '\n'

# ── Section 6: Mock Mode Smoke Tests ────────────────────────────────────────
# Verify the mock wrappers actually return data. These tests use HERMES_LAB_MODE=mock
# so they work even without AWS credentials or a running cluster.
printf '--- Mock Mode Smoke Tests ---\n'

check "mock-aws serves RDS instance data (DBInstances key present)" \
  bash -c 'HERMES_LAB_MODE=mock MOCK_DATA_DIR="$COURSE_ROOT/infrastructure/mock-data" "$COURSE_ROOT/infrastructure/wrappers/mock-aws" rds describe-db-instances 2>/dev/null | grep -q "DBInstances"'

check "mock-kubectl serves pod list (items key present)" \
  bash -c 'HERMES_LAB_MODE=mock MOCK_DATA_DIR="$COURSE_ROOT/infrastructure/mock-data" "$COURSE_ROOT/infrastructure/wrappers/mock-kubectl" get pods 2>/dev/null | grep -q "items"'

printf '\n'

# ── Section 7: Skill Files ───────────────────────────────────────────────────
printf '--- Skills ---\n'

check "sre-ec2-health-check/SKILL.md exists" \
  test -f "$COURSE_ROOT/skills/sre-ec2-health-check/SKILL.md"

check "dba-rds-slow-query/SKILL.md exists" \
  test -f "$COURSE_ROOT/skills/dba-rds-slow-query/SKILL.md"

check "devops-deployment-safety-check/SKILL.md exists" \
  test -f "$COURSE_ROOT/skills/devops-deployment-safety-check/SKILL.md"

check "observability-alert-noise-analyzer/SKILL.md exists" \
  test -f "$COURSE_ROOT/skills/observability-alert-noise-analyzer/SKILL.md"

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
  printf '  Tool install:    %s/setup/install-hermes.md\n' "$COURSE_ROOT"
  printf '  KIND setup:      %s/setup/setup-kind.md\n' "$COURSE_ROOT"
  printf '  LLM access:      %s/setup/llm-access.md\n' "$COURSE_ROOT"
  printf '\n'
  printf 'Common fixes:\n'
  printf '  Docker not running?  -> Start Docker Desktop\n'
  printf '  KIND cluster missing? -> bash %s/setup/setup-kind.md (Step 3)\n' "$COURSE_ROOT"
  printf '  hermes not found?     -> See %s/setup/install-hermes.md\n' "$COURSE_ROOT"
  printf '  LLM check fails?      -> Run: hermes login\n'
  exit 1
fi
