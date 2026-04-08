# Module 7 Lab: Write a Domain-Specific SKILL.md

**Duration:** 60 minutes
**Track:** Choose one: A (Database), B (FinOps), C (Kubernetes), D (Observability)
**Outcome:** A complete SKILL.md that passes the RUBRIC.md quality gate

> IMPORTANT: Choose your track now and stay with it through Module 8.
> Your Module 7 skill will be attached to your agent profile in Module 8.
> Cross-track contamination (mixing kubectl and aws commands in one skill) is a Tier 1 rubric failure.

---

## Prerequisites

- Hermes installed and working (`hermes --version`)
- Lab mode set: `export HERMES_LAB_MODE=mock`
- Your track starter file open: `course/modules/module-07-skills/starter/<your-track>/SKILL.md`
- RUBRIC.md open in a second window: `course/skills/RUBRIC.md`

> **Track C (Kubernetes) — additional setup**
>
> Phase 6 ships 6 baked broken-pod scenarios and a `mock-kubectl` wrapper you should exercise as you author your skill. From the course root, export the full block before Step 4:
>
> ```bash
> export HERMES_LAB_MODE=mock
> export HERMES_LAB_SCENARIO=image-pull       # or crashloop2 | oom | liveness | missing-secret | port-mismatch
> export HERMES_LAB_TRACK=track-c               # Phase 7 wrapper governance
> export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
> export PATH="$(pwd)/infrastructure/wrappers:$PATH"
>
> # Verify the wrapper is on PATH
> which mock-kubectl
> # Expected: <course-dir>/infrastructure/wrappers/mock-kubectl
> ```
>
> **Your reference material as a Track C participant:**
> - 6 broken pod manifests at `infrastructure/scenarios/k8s/0[1-6]-*.yaml` (apply with `kubectl apply -f` for live mode, or just read them for the failure-mode patterns)
> - 13 captured mock JSON/text files at `infrastructure/mock-data/kubernetes/0[1-6]-*.{json,txt}` — these are the exact outputs your skill's Phase 1 will receive in mock mode
> - The production reference skill at `course/modules/module-07-skills/solution/track-c-kubernetes/SKILL.md` (287 lines, all 6 failure modes — your skill in 60 minutes will be smaller, that's fine)

---

## File Structure

```
course/modules/module-07-skills/
├── LAB.md            ← you are here
├── starter/
│   ├── track-a-database/SKILL.md    ← Track A participants start here
│   ├── track-b-finops/SKILL.md      ← Track B participants start here
│   ├── track-c-kubernetes/SKILL.md  ← Track C participants start here
│   └── track-d-observability/SKILL.md ← Track D participants start here
└── solution/
    ├── track-a-database/SKILL.md    ← Track A reference implementation
    ├── track-b-finops/SKILL.md
    ├── track-c-kubernetes/SKILL.md
    └── track-d-observability/SKILL.md
```

Copy your starter file to a working location:

```bash
cp course/modules/module-07-skills/starter/<your-track>/SKILL.md /tmp/my-skill.md
```

Edit `/tmp/my-skill.md` throughout this lab.

---

## Step 1: Metadata — Skill Identity (5 min)

**Concept:** A skill is a named, versioned runbook. The frontmatter is its identity card.
It tells Hermes when to surface this skill and what domain it belongs to.

**What's visible in your starter file:** The YAML frontmatter block.

**Your task:** Fill in every [placeholder] in the frontmatter:
- `name`: kebab-case, describes what the skill does (`rds-slow-query-investigation`, not `skill1`)
- `description`: one sentence, action verb first, includes: what it does + service + when to trigger
- `compatibility`: list the CLI tools and versions required (aws cli v2, psql 14+, etc.)
- `metadata.hermes.category`: choose from: devops | sre | dba | observability
- `metadata.hermes.tags`: 3-5 relevant tags

**Check your work:**

```bash
grep -c '\[' /tmp/my-skill.md
```

Result must show no [placeholders] remaining in the frontmatter section.

---

## Step 2: When to Use — Trigger Conditions (8 min)

**Concept:** Skills activate on SPECIFIC, OBSERVABLE conditions — not vague descriptions.
"When CPU is high" is wrong. "When CloudWatch alarm `RDS-CPU-High` fires (CPUUtilization > 80)" is right.
If the trigger is vague, the agent will invoke the skill for the wrong scenarios.

**Reveal:** Add the `## When to Use` section to your skill file after the frontmatter.

**Your task:**
1. Name 3-5 specific trigger conditions for your track:
   - Track A: CloudWatch alarm name, pg_stat_statements query latency threshold, CPU threshold
   - Track B: Cost spike percentage, EC2 utilization below threshold, unused resource age
   - Track C: Pod status (CrashLoopBackOff, OOMKilled), node condition, restart count threshold
   - Track D: Alarm count in time window, flapping detection period, noise score threshold
2. Add 2 "Do NOT use this skill for" anti-cases (out-of-scope scenarios)

**Reference:** Check the solution file for your track to see an example trigger list.

---

## Step 3: Inputs — Parameterize Your Skill (7 min)

**Concept:** Skills are functions. Explicit inputs make skills reusable across environments.
A skill that hardcodes `us-east-1` cannot be used in `ap-southeast-1` without editing.

**Reveal:** Add the `## Inputs` and `## Prerequisites` sections.

**Your task:**
1. Fill the Inputs table with every env var and parameter your skill uses
2. For each input: name, source (env var/alarm/user prompt), required (yes/no), description
3. ALWAYS include `HERMES_LAB_MODE` as a required input (mock vs live mode)
4. List required tools with version numbers
5. Add the mock mode setup block showing how to verify mock data files are accessible

**Track-specific inputs:**

| Track | Required Inputs |
|-------|----------------|
| A (Database) | `RDS_INSTANCE_ID`, `DB_HOST`, `DB_NAME`, `HERMES_LAB_MODE` |
| B (FinOps) | `EC2_INSTANCE_ID`, `AWS_REGION`, `HERMES_LAB_MODE` |
| C (Kubernetes) | `KUBECONFIG`, `NAMESPACE` (default: `default`), `HERMES_LAB_MODE` |
| D (Observability) | `ALARM_ARN`, `AWS_REGION`, `HERMES_LAB_MODE` |

---

## Step 4: Phase 1 — Scripts Zone (10 min)

**Concept:** The Scripts Zone is deterministic. It contains only CLI commands and their expected output.
No prose decisions. No "if you see X...". Just: run this command, here is what success looks like,
here is what a problem looks like. The agent executes these commands and feeds the output to Phase 2.

**Reveal:** Add `## Procedure` with `### Phase 1` content.

**Your task:**
1. Write 3-5 CLI steps that collect all diagnostic data your skill needs
2. For EACH step: exact command (with env var references) + expected healthy output + expected degraded output
3. Use real AWS/K8s API field names (PascalCase for AWS: `DBInstanceStatus`, `Datapoints`; camelCase for kubectl)
4. HERMES_LAB_MODE check: your mock wrapper returns the same JSON structure as real AWS — same field names

**Track A example Step 1:**

```bash
aws rds describe-db-instances \
  --db-instance-identifier $RDS_INSTANCE_ID \
  --region $AWS_REGION \
  --output json
# Mock mode: reads from course/infrastructure/mock-data/rds/
```

**Track C (Kubernetes) example Step 1:**

```bash
# Pod inventory — broad scan with field-level details
mock-kubectl get pods -n $NAMESPACE -o json
# Mock mode: reads from course/infrastructure/mock-data/kubernetes/{HERMES_LAB_SCENARIO}-get-pods.json
# Live mode: hits your real KIND cluster

# Pod-specific deep-dive — events, container state, restart count
mock-kubectl describe pod $POD_NAME -n $NAMESPACE
# Mock mode: reads from course/infrastructure/mock-data/kubernetes/{HERMES_LAB_SCENARIO}-describe.txt
```

**Expected output (image-pull scenario, partial):**

```json
{
  "items": [{
    "status": {
      "containerStatuses": [{
        "state": {"waiting": {"reason": "ImagePullBackOff", "message": "Back-off pulling image..."}},
        "ready": false,
        "restartCount": 0
      }]
    },
    "spec": {
      "containers": [{"image": "nonexistent-registry.io/fake-app:v1.0.0"}]
    }
  }]
}
```

The exact JSON path your Phase 2 decision tree should reference is `status.containerStatuses[].state.waiting.reason` — that's the field that distinguishes ImagePullBackOff from CrashLoopBackOff from CreateContainerConfigError. Always cite the path, never invent it.

**To exercise other scenarios:** swap `HERMES_LAB_SCENARIO=image-pull` for `crashloop2`, `oom`, `liveness`, `missing-secret`, or `port-mismatch` in your shell. Each produces different mock JSON shapes with different `state.waiting.reason` / `lastState.terminated.reason` values that your skill needs to handle.

**Common mistake:** Including reasoning ("if CPU is high, do X") in Phase 1. Phase 1 is data collection only. Save reasoning for Phase 2.

---

## Step 5: Phase 2 — Agents Zone (12 min)

**Concept:** The Agents Zone is where reasoning happens. Decision trees must be numeric and complete:
every branch must end at a named diagnosis or escalation. "Investigate further" is not a valid terminal.
Vague conditions ("if CPU seems high") are Tier 1 rubric failures.

**Reveal:** Add `### Phase 2` under `## Procedure`.

**Your task:**
1. Write a decision tree using the data from Phase 1
2. Every IF condition must be numeric: `CPUUtilization > 80`, not "CPU is high"
3. Every branch must end with: `Diagnosis = "NAMED_ROOT_CAUSE"` or `ESCALATE`
4. Include at least one ELSE branch (handles normal state)
5. Add a correlation step (cross-reference two metrics)

**Required format:**

```
IF [Phase1_metric] > [threshold]:
  THEN: Diagnosis = "SPECIFIC_CAUSE"
  CONFIDENCE: High/Medium/Low — reason
ELSE:
  THEN: Diagnosis = "NO_ISSUE_FOUND"
```

**Common mistake:** Writing a Phase 2 step that runs a new CLI command. Phase 2 interprets existing data — it does not gather new data. If you need a new CLI command, it goes in Phase 1.

---

## Step 6: Escalation Rules and NEVER DO (8 min)

**Concept:** Safety posture. Every skill must know when to stop and hand off to a human.
NEVER DO rules prevent the most catastrophic agent actions — they must be specific,
not abstract ("never do anything dangerous" is not a NEVER DO rule).

**Reveal:** Add `## Escalation Rules` and `## NEVER DO`.

**Your task (Escalation Rules):**
1. Write 3-4 escalation triggers with specific, observable conditions
2. Each trigger: what condition, why it exceeds agent scope, what to hand off to human
3. Include the escalation handoff template (Subject, Findings, Evidence, Urgency)

**Your task (NEVER DO):**
1. Write 4-5 hard prohibitions — the most destructive things your agent could do
2. Each prohibition: specific command, specific catastrophic outcome

**Track-specific NEVER DO examples:**

| Track | NEVER DO |
|-------|----------|
| A (Database) | `ALTER TABLE` without approval, `VACUUM FULL` during business hours |
| B (FinOps) | `aws ec2 terminate-instances`, modify Reserved Instance commitments |
| C (Kubernetes) | `kubectl delete`, `kubectl drain`, `kubectl cordon` without approval |
| D (Observability) | silence alarms without documented reason and expiry time |

---

## Step 7: Rollback and Verification (5 min)

**Concept:** Every mutation needs an undo path. If your skill's Phase 3 makes things worse,
the rollback procedure is how you restore the known-good state. Even read-only skills
need a verification checklist to confirm the diagnostic run was complete.

**Reveal:** Add `## Rollback Procedure` and `## Verification`.

**Your task (Rollback):**
1. Write a 3-4 step rollback for the primary mutation in Phase 3
2. Step R.1: verify rollback is needed (compare against pre-change snapshot)
3. Step R.2: exact rollback command
4. Step R.3: confirm rollback complete
5. Step R.4: escalate after rollback (always — even if rollback succeeds)

**Your task (Verification checklist):**
- Copy the Verification section from SKILL-TEMPLATE.md
- Replace [wait_period] with a real time value for your track

---

## Quality Gate

Run the rubric before submitting:

```bash
# Check 1: No unfilled placeholders
grep -c '\[' /tmp/my-skill.md
# Expected: 0

# Check 2: Decision tree has numeric conditions
grep -E ">[[:space:]]*[0-9]" /tmp/my-skill.md | head -5
# Expected: at least 3 lines with numeric thresholds

# Check 3: NEVER DO section exists
grep "NEVER" /tmp/my-skill.md | head -5
# Expected: at least 4 NEVER DO rules

# Check 4: Both SCRIPTS ZONE and AGENTS ZONE present
grep "SCRIPTS ZONE\|AGENTS ZONE" /tmp/my-skill.md
# Expected: both appear
```

Open `course/skills/RUBRIC.md` and run all Tier 1 checkers. Tier 1 items are blockers — your skill must pass all of them.

---

## Compare with Solution

Your completed skill vs. the reference implementation for your track:

```bash
diff /tmp/my-skill.md course/modules/module-07-skills/solution/<your-track>/SKILL.md
```

Differences are expected and fine — this is YOUR skill for YOUR chosen scenario.
The solution file shows one valid implementation; yours may be legitimately different.
What must match: structure (all sections present), format (numeric conditions, named diagnoses), completeness (0 placeholders).

---

## Next Steps

Your completed skill carries directly into Module 8.

**Save your work:**

```bash
cp /tmp/my-skill.md course/modules/module-07-skills/my-<track>-skill.md
```

In Module 8, you will:
1. Create a Hermes agent profile for your track
2. Write a SOUL.md for your agent using SOUL-TEMPLATE.md
3. Copy your Module 7 skill into your profile's `skills/` directory
4. Run your agent against the mock scenario for your track
