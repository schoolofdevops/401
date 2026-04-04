<!--
SKILL-TEMPLATE.md — Canonical blank template for all four DevOps course tracks.

PURPOSE:
  Use this template to author any skill for the Agentic DevOps course
  (Track A: SRE/EC2, Track B: DevOps/Deployment, Track C: DBA/RDS, Track D: Observability).
  Every section is required. Fill each placeholder (marked with square brackets [like this]).

QUALITY GATE:
  Before submitting, run every item in course/skills/RUBRIC.md.
  Tier 1 blockers must ALL pass. No exceptions.

AUTHORING TIPS:
  - "When to Use" names the EXACT alert or request pattern — not a vague description
  - "Scripts Zone" phases: only CLI commands + expected output (no prose decisions)
  - "Agents Zone" phases: only IF/THEN/ELSE reasoning (no raw CLI commands)
  - Decision conditions MUST be numeric: "CPUUtilization > 80" not "CPU is high"
  - Expected output matches real AWS/K8s API PascalCase field names
-->

---
name: [skill-name-kebab-case]
description: "[One sentence. Start with an action verb. Include: what it does, which service/domain, when to use it. Example: 'Investigate RDS slow queries using pg_stat_statements. Use when CloudWatch CPUUtilization alarm fires on RDS instance or application reports query latency > 500ms.']"
version: 1.0.0
compatibility: "[tool versions required, e.g., 'aws cli v2, psql 14+, HERMES_LAB_MODE=mock|live']"
metadata:
  hermes:
    category: "[devops | sre | dba | observability]"
    tags: [[tag1], [tag2], [tag3], [service], [action]]
---

# [Human-Readable Skill Name]

[One paragraph: what operational problem this skill solves, which system it targets, and what outcome the agent produces. Example: "Diagnoses RDS PostgreSQL performance issues by querying pg_stat_statements for slow queries, correlating with CloudWatch CPU and IOPS metrics, then recommends index changes or parameter tuning. Works in both HERMES_LAB_MODE=mock (offline labs) and HERMES_LAB_MODE=live (real infrastructure)."]

---

## When to Use

[Name the specific alert, threshold breach, or request pattern that activates this skill.
Example format — pick the most precise trigger for your domain:]

- When CloudWatch alarm `[alarm-id]` fires (metric: `[MetricName]`, threshold: `[operator] [value]`)
- When [application | service | user] reports `[specific symptom with observable signal]`
- When `[CLI output pattern]` is observed during routine `[operational review | deploy | incident]`
- [Add 2-4 more trigger conditions, all specific and observable]

**Do NOT use this skill for:**
- [Anti-case 1: vague or unrelated scenario]
- [Anti-case 2: different service or domain]

---

## Inputs

| Input | Source | Required | Description |
|-------|--------|----------|-------------|
| `[INPUT_VAR_1]` | [CloudWatch alarm / env var / user prompt / config file] | Yes | [What this value is and where to find it. E.g., "RDS instance identifier — find in AWS Console → RDS → Instances"] |
| `[INPUT_VAR_2]` | [Source] | Yes | [Description] |
| `[INPUT_VAR_3]` | [Source] | No | [Description. Default: `[default_value]`] |
| `HERMES_LAB_MODE` | Environment variable | Yes | `mock` for offline labs using pre-baked JSON fixtures; `live` for real AWS/K8s infrastructure |
| `AWS_REGION` | Environment variable | Yes (live mode) | AWS region where resources are deployed. Example: `us-east-1` |

---

## Prerequisites

### Tools Required

| Tool | Version | Install |
|------|---------|---------|
| [aws cli] | [v2+] | `brew install awscli` or official installer |
| [psql / kubectl / other] | [version] | [install command or URL] |

### Permissions Required

- `[IAM action 1]` on `[resource ARN pattern]` — needed for [step N.N]
- `[IAM action 2]` on `[resource ARN pattern]` — needed for [step N.N]

### Environment Variables

```bash
# Set before running this skill:
export HERMES_LAB_MODE=mock      # or: live
export AWS_REGION=[your-region]  # e.g., us-east-1
export [OTHER_REQUIRED_VAR]=[value]
```

### Mock Mode Setup (offline labs)

Mock data files are pre-loaded in `course/infrastructure/mock-data/[track]/`. No AWS account required in mock mode.

```bash
# Verify mock data is accessible:
ls course/infrastructure/mock-data/[track]/
# Expected output: [list of .json fixture files]
```

---

## Procedure

### Phase 1: [Collect Raw Data] [SCRIPTS ZONE — deterministic]

**What this phase does:** Run CLI commands to gather all data the agent will need. No interpretation yet — just collect.

**Step 1.1 — [Check current state / List instances / Describe resource]:**

```bash
[exact CLI command here]
# Example: aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_ID --region $AWS_REGION
```

**Expected output (healthy state):**
```json
{
  "[FieldName]": "[expected_value]",
  "[StatusField]": "available"
}
```

**Expected output (degraded state):**
```json
{
  "[FieldName]": "[expected_value]",
  "[StatusField]": "modifying",
  "[MetricField]": [value_indicating_problem]
}
```

**Step 1.2 — [Collect metric / Query performance data / Get logs]:**

```bash
[exact CLI command here]
# Example: aws cloudwatch get-metric-statistics \
#   --namespace AWS/RDS \
#   --metric-name CPUUtilization \
#   --dimensions Name=DBInstanceIdentifier,Value=$DB_INSTANCE_ID \
#   --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
#   --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
#   --period 300 \
#   --statistics Average
```

**Expected output:**
```json
{
  "Datapoints": [
    {
      "Timestamp": "2026-04-04T13:00:00Z",
      "Average": [numeric_value],
      "Unit": "[Percent | Count | Bytes]"
    }
  ]
}
```

**Step 1.3 — [Collect additional supporting data]:**

```bash
[exact CLI command here]
```

**Expected output:**
```
[exact text or JSON the CLI returns — use PascalCase for AWS fields, camelCase for kubectl fields]
```

**Step 1.4 — [Final data collection command]:**

```bash
[exact CLI command here]
```

**Expected output:**
```
[expected output]
```

---

### Phase 2: [Diagnose Root Cause] [AGENTS ZONE — reasoning]

**What this phase does:** Interpret the data collected in Phase 1. Apply decision logic to identify the root cause. All branches terminate at a named diagnosis or escalation — no open-ended "investigate further."

**Input:** Output from Phase 1 steps (structured data).

**Decision Tree:**

```
IF [MetricField from Step 1.1] > [threshold_A]:
  THEN: Execute Step 2.1 (high-[resource] path)

  IF [SecondaryMetricField] > [threshold_B]:
    THEN: Diagnosis = "[SPECIFIC_ROOT_CAUSE_A]"
    CONFIDENCE: High — both primary and secondary metrics confirm

  ELSE IF [SecondaryMetricField] <= [threshold_B]:
    THEN: Diagnosis = "[SPECIFIC_ROOT_CAUSE_B]"
    CONFIDENCE: Medium — primary metric elevated but secondary normal

ELSE IF [MetricField] > [threshold_C] AND [MetricField] <= [threshold_A]:
  THEN: Diagnosis = "[SPECIFIC_ROOT_CAUSE_C]"
  CONFIDENCE: Medium — metric in warning zone

ELSE ([MetricField] <= [threshold_C]):
  THEN: Diagnosis = "NO_ISSUE_FOUND"
  ACTION: Report clean status. Check if alarm was a false positive.
```

**Step 2.1 — Assess severity:**

Based on Phase 1 data:
- If `[field] == "[value_A]"`: severity = CRITICAL → escalate immediately (see Escalation Rules)
- If `[field] == "[value_B]"`: severity = HIGH → execute Phase 3 remediation
- If `[field] == "[value_C]"`: severity = MEDIUM → monitor and report

**Step 2.2 — Correlate findings:**

Cross-reference:
- `[Metric A]` from Step 1.2 vs `[Metric B]` from Step 1.3
- IF both elevated: indicates `[correlated_cause]`
- IF only A elevated: indicates `[isolated_cause]`
- IF discrepancy > `[threshold]`: indicates `[anomaly_pattern]`

**Output from Phase 2:** Named diagnosis string + supporting evidence list + recommended action.

---

### Phase 3: [Remediate / Apply Fix] [SCRIPTS ZONE — deterministic]

**What this phase does:** Execute the remediation action determined in Phase 2. Run only if Phase 2 diagnosis is NOT "NO_ISSUE_FOUND" and NOT CRITICAL (CRITICAL → escalate first).

**Step 3.1 — Pre-change snapshot (for rollback):**

```bash
[command to capture current state before making changes]
# Example: aws rds describe-db-parameters --db-parameter-group-name $PARAM_GROUP > /tmp/params-before.json
```

**Expected output:**
```
[what the snapshot command returns]
```

**Step 3.2 — Apply remediation:**

```bash
[exact remediation command]
# Example: aws rds modify-db-instance \
#   --db-instance-identifier $DB_INSTANCE_ID \
#   --db-parameter-group-name $NEW_PARAM_GROUP \
#   --apply-immediately
```

**Expected output (success):**
```json
{
  "DBInstance": {
    "DBInstanceIdentifier": "[instance-id]",
    "PendingModifiedValues": {
      "[ParameterName]": "[new_value]"
    }
  }
}
```

**Step 3.3 — Confirm change applied:**

```bash
[verification command — confirms the remediation took effect]
```

**Expected output:**
```
[what success looks like]
```

---

### Phase 4: [Verify Resolution] [AGENTS ZONE — reasoning]

**What this phase does:** Confirm the metric or symptom that triggered this skill has returned to normal. Apply pass/fail criteria.

**Verification criteria (ALL must pass):**

```
IF [primary metric] <= [recovery_threshold]:
  AND [secondary metric] < [recovery_threshold]:
    THEN: Resolution confirmed. Document findings and close.

ELSE IF [primary metric] still > [recovery_threshold]:
  AND time_elapsed > [wait_period]:
    THEN: Remediation failed. Escalate (see Escalation Rules).

ELSE ([primary metric] improving but not yet recovered):
  THEN: Monitor for [wait_period] and re-check.
  NOTE: Set reminder to verify at [time].
```

---

## Escalation Rules

Escalate to on-call engineer / DBA / infrastructure lead when:

- **Escalate immediately if:** `[specific observable condition]` — do NOT attempt remediation (risk: `[what could go wrong]`)
- **Escalate immediately if:** `[Phase 2 diagnosis]` == `"[SPECIFIC_ROOT_CAUSE_A]"` — requires `[human action]`
- **Escalate after N attempts if:** Phase 3 remediation applied but Phase 4 verification fails after `[wait_period]`
- **Escalate if:** `[metric]` > `[threshold]` and still rising after `[time period]`

**Escalation handoff — include ALL of the following:**

```
Subject: [Skill Name] Escalation — [Diagnosis] on [Resource Identifier]

Findings:
  - Diagnosis: [Phase 2 diagnosis string]
  - Trigger: [what alarm/threshold fired]
  - [Primary metric]: [value] (threshold: [threshold])
  - [Secondary metric]: [value]
  - Remediation attempted: [Yes/No — if yes, describe]
  - Remediation result: [outcome]

Evidence:
  - Phase 1 output: [attach or paste Step 1.N output]
  - Phase 3 pre-change snapshot: /tmp/[snapshot-file]

Urgency: [CRITICAL | HIGH | MEDIUM]
```

---

## NEVER DO

- **NEVER** `[dangerous command 1]` — reason: `[what catastrophic outcome this causes, e.g., "permanently deletes production data without recovery"]`
- **NEVER** `[dangerous command 2]` — reason: `[specific impact]`
- **NEVER** `[dangerous command 3]` — reason: `[specific impact, e.g., "causes cascading failure to dependent services"]`
- **NEVER** run Phase 3 remediation steps without first completing Phase 2 diagnosis — reason: blind remediation risks making the problem worse
- **NEVER** skip the pre-change snapshot in Step 3.1 — reason: rollback is impossible without a known-good state reference

---

## Rollback Procedure

If remediation in Phase 3 caused a new problem or made things worse:

**Step R.1 — Verify rollback is needed:**

```bash
[command to check current state — compare against pre-change snapshot]
```

**Expected output indicating rollback needed:**
```
[what you see when the change made things worse]
```

**Step R.2 — Restore previous state:**

```bash
[exact rollback command — e.g., aws rds modify-db-instance ... restoring original params]
```

**Expected output (rollback applied):**
```json
{
  "[StatusField]": "modifying"
}
```

**Step R.3 — Confirm rollback complete:**

```bash
[command to confirm original state restored]
```

**Expected output (rollback confirmed):**
```
[original state values]
```

**Step R.4 — Escalate after rollback:** Even if rollback succeeds, escalate with: (1) what change was made, (2) what problem it caused, (3) rollback evidence.

---

## Verification

Use this checklist to confirm the skill run is complete and successful:

- [ ] Phase 1 all steps completed — raw data collected with no CLI errors
- [ ] Phase 2 decision tree produced a named diagnosis (not "investigate further")
- [ ] Phase 3 executed only when diagnosis warranted remediation (not for NO_ISSUE_FOUND)
- [ ] Pre-change snapshot saved before any modification (Step 3.1)
- [ ] Phase 4 verification passed — primary metric at or below recovery threshold
- [ ] Escalation triggered if Phase 4 failed after `[wait_period]`
- [ ] Run documented: diagnosis, action taken, outcome, timestamp
- [ ] `HERMES_LAB_MODE` was set correctly for this session (mock vs live confirmed)
