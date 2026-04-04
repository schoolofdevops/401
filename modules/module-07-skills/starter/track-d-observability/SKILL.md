<!--
Module 7 Lab — Track D: Observability & Alert Noise
You are writing an observability skill for CloudWatch alarm noise analysis.

TRACK COMMITMENT: Stay with Track D through Module 8. Your Module 7
skill will be used in future modules.

STEP 1 of 7: Fill in the YAML frontmatter below.
Each [placeholder] must be replaced with real content.
Quality gate: grep -c '\[' your-skill.md — must return 0 when complete.
-->

---
name: [skill-name-kebab-case]
description: "[One sentence starting with an action verb. Include: what it does, which CloudWatch metric/alarm it targets, when to use it.]"
version: 1.0.0
compatibility: "aws cli v2, HERMES_LAB_MODE=mock|live"
metadata:
  hermes:
    category: "observability"
    tags: [[tag1], [tag2], cloudwatch, alarms, [action]]
---

<!-- STEP 2: When to Use — complete Step 1 first.
Reveal: Read LAB.md Step 2 instructions, then add the ## When to Use section here.
Concept: Trigger-based thinking.
Track D triggers: alarm flood (>10 alarms in 5 minutes), duplicate alarm detection, flapping alarm.
Env vars for this track: ALARM_ARN, AWS_REGION, HERMES_LAB_MODE -->

<!-- STEP 3: Inputs and Prerequisites — complete Step 2 first.
Reveal: Read LAB.md Step 3 instructions, then add ## Inputs and ## Prerequisites sections.
Concept: Skills as functions.
Track D inputs: ALARM_ARN (env var), AWS_REGION (env var), HERMES_LAB_MODE.
Required tools: aws cli v2. -->

<!-- STEP 4: Procedure Phase 1 (Scripts Zone) — complete Step 3 first.
Reveal: Read LAB.md Step 4 instructions, then add ## Procedure / Phase 1.
Concept: Scripts Zone.
Track D Phase 1 commands: aws cloudwatch describe-alarms, aws cloudwatch get-metric-statistics -->

<!-- STEP 5: Procedure Phase 2 (Agents Zone) — complete Step 4 first.
Reveal: Read LAB.md Step 5 instructions, then add Phase 2 under ## Procedure.
Concept: Agents Zone.
Track D decision: IF alarm_count > 10 AND time_window == 5min THEN calculate noise_score ... -->

<!-- STEP 6: Escalation Rules and NEVER DO — complete Step 5 first.
Reveal: Read LAB.md Step 6 instructions, then add ## Escalation Rules and ## NEVER DO.
Concept: Safety posture.
Track D never-do: never silence alarms without documenting reason and expiry. -->

<!-- STEP 7: Rollback Procedure and Verification — complete Step 6 first.
Reveal: Read LAB.md Step 7 instructions, then add ## Rollback Procedure and ## Verification.
Concept: Reversibility. -->
