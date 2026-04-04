---
phase: 01-foundation
plan: 02
subsystem: infrastructure/mock-data
tags: [mock-data, cloudwatch, aws-cli, lab-infrastructure]
dependency_graph:
  requires: []
  provides:
    - infrastructure/mock-data/cloudwatch/describe-alarms-clean.json
    - infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json
    - infrastructure/mock-data/cloudwatch/describe-alarm-history.json
    - infrastructure/mock-data/ec2/describe-instances.json
    - infrastructure/wrappers/mock-aws (updated routing)
  affects:
    - Module 1 lab (MOD1-01, MOD1-02) context engineering exercises
    - Any lab using mock-aws cloudwatch describe-alarms or describe-alarm-history
tech_stack:
  added: []
  patterns:
    - Static JSON fixtures with _metadata block for source attribution
    - Scenario-based routing in mock-aws (HERMES_LAB_SCENARIO=clean|messy)
    - Banner output redirected to stderr so JSON stdout is pipeable
key_files:
  created:
    - infrastructure/mock-data/cloudwatch/describe-alarms-clean.json
    - infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json
    - infrastructure/mock-data/cloudwatch/describe-alarm-history.json
    - infrastructure/mock-data/ec2/describe-instances.json
  modified:
    - infrastructure/wrappers/mock-aws
decisions:
  - "_metadata pattern established: all new mock JSON files include source, format_date, aws_cli_version, and note fields"
  - "Banner output moved to stderr — diagnostic/status output belongs on stderr so stdout JSON is directly pipeable"
  - "EC2 mock data given its own ec2/ directory instead of residing under cost-explorer/ — better organization by service"
metrics:
  duration_minutes: 3
  tasks_completed: 2
  files_created: 4
  files_modified: 1
  completed_date: "2026-04-04"
---

# Phase 01 Plan 02: CloudWatch Mock Data and Wrapper Routing Summary

**One-liner:** CloudWatch alarm mock data (clean/anomaly/history JSON fixtures) with scenario-based routing via HERMES_LAB_SCENARIO in the mock-aws wrapper.

## What Was Built

Three CloudWatch JSON fixtures and updated mock-aws routing enable Module 1's progressive context engineering lab — participants feed these JSON payloads to an LLM and observe how adding structured context layers changes analysis quality.

### Files Created

**`infrastructure/mock-data/cloudwatch/describe-alarms-clean.json`**
4 alarms all with `StateValue: "OK"`. Covers EC2 (CPUUtilization), RDS (DatabaseConnections), and two custom metrics (MemoryUsage, P99Latency). Each alarm has a 2-3 sentence operational description, realistic thresholds, proper AWS ARN format, and SNS action ARN.

**`infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json`**
Same 4 alarms with mixed states: 2 ALARM (CPU and DB connections firing with realistic datapoints in StateReason), 1 OK (memory — not everything is broken), 1 INSUFFICIENT_DATA (API latency — new metric with no data yet). Designed for the lab where participants observe how context about the incident timeline changes AI analysis quality.

**`infrastructure/mock-data/cloudwatch/describe-alarm-history.json`**
6 history items for HighCPUUtilization showing a realistic incident pattern: config change (threshold lowered 90->85 at 08:00), first ALARM at 09:35, SNS action, brief OK recovery at 09:50, recurrence at 10:05, second SNS action. This timeline gives participants rich context for MOD1-02.

**`infrastructure/mock-data/ec2/describe-instances.json`**
EC2 instances data with `_metadata` block added, moved to its own `ec2/` directory (was previously under `cost-explorer/`).

### Updated: `infrastructure/wrappers/mock-aws`

- `cloudwatch describe-alarms` now routes to clean or anomaly JSON based on `HERMES_LAB_SCENARIO`
- `cloudwatch describe-alarm-history` now serves the history JSON (was returning empty array)
- `ec2 describe-instances` now routes to `ec2/describe-instances.json`
- Available mocks error message updated to include `cloudwatch describe-alarm-history`

## Verification Results

```
describe-alarms-clean.json:   4 alarms, all StateValue "OK"
describe-alarms-anomaly.json: 4 alarms — ["ALARM", "ALARM", "OK", "INSUFFICIENT_DATA"]
describe-alarm-history.json:  6 history items (StateUpdate, Action, ConfigurationUpdate)
mock-aws clean scenario:      jq '.MetricAlarms | length' → 4
mock-aws messy scenario:      jq '.MetricAlarms[0].StateValue' → "ALARM"
mock-aws alarm history:       jq '.AlarmHistoryItems | length' → 6
No regressions on:            rds (1 instance), ce (7 time periods), cloudwatch metrics
```

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed mock-aws banner writing to stdout instead of stderr**
- **Found during:** Task 2 verification
- **Issue:** The MOCK MODE banner was printed with `printf` to stdout, which broke piping JSON output to `jq`. Command like `mock-aws cloudwatch describe-alarms 2>/dev/null | jq '.'` failed with parse error because jq received the banner before the JSON.
- **Fix:** Added `>&2` to all 7 `printf` calls in the banner block, redirecting diagnostic output to stderr. This is standard POSIX behavior — status/diagnostic messages go to stderr, data to stdout.
- **Files modified:** `infrastructure/wrappers/mock-aws`
- **Commit:** cb2bc7b (included in Task 2 commit)
- **Impact:** All existing mock routes (rds, ce, cloudwatch metrics) now also work correctly when piped to jq.

## Commits

| Task | Name | Commit | Key Files |
|------|------|--------|-----------|
| 1 | Create CloudWatch alarm mock data files | 530b5ac | describe-alarms-clean.json, describe-alarms-anomaly.json, describe-alarm-history.json |
| 2 | Update mock-aws wrapper + EC2 mock data | cb2bc7b | mock-aws (wrapper), ec2/describe-instances.json |

## Known Stubs

None. All mock data files contain realistic, complete data. The wrapper correctly routes all commands to populated JSON files.

## Self-Check: PASSED

Files exist:
- `infrastructure/mock-data/cloudwatch/describe-alarms-clean.json` — FOUND
- `infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json` — FOUND
- `infrastructure/mock-data/cloudwatch/describe-alarm-history.json` — FOUND
- `infrastructure/mock-data/ec2/describe-instances.json` — FOUND
- `infrastructure/wrappers/mock-aws` — FOUND (modified)

Commits exist:
- `530b5ac` — FOUND (feat(01-02): add CloudWatch alarm mock data files)
- `cb2bc7b` — FOUND (feat(01-02): update mock-aws wrapper for CloudWatch alarm routing)
