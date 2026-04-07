# SKILL.md Authoring Guide: Two-Zone Design for Deterministic + Reasoning Workflows

**Purpose:** This document explains WHY the SKILL.md format works the way it does, what each design decision achieves, and what goes wrong when the design is violated. It is the reference for writing production-quality skills. Read this after completing Module 7 labs when you want to understand the reasoning behind what you built.

---

## Table of Contents

1. [Why Skills, Not Prompts?](#1-why-skills-not-prompts)
2. [The Two-Zone Design](#2-the-two-zone-design)
3. [The Hermes SKILL.md Implementation](#3-the-hermes-skillmd-implementation)
4. [DevOps Skill Examples](#4-devops-skill-examples)
5. [Course Examples — File References](#5-course-examples--file-references)
6. [Quick Reference](#6-quick-reference)

---

## 1. Why Skills, Not Prompts?

### 1.1 The Limitation of Ad-Hoc Prompting

When you first use an LLM for infrastructure diagnostics, the natural approach is to describe the problem in natural language: "The RDS CPU is high. What should I check?" The model produces a reasonable-sounding checklist. You follow it manually. It works, sort of.

The problems appear at scale:

**Inconsistency:** Ask the same question twice and you get a different procedure. Ask with a slightly different framing and you get a completely different set of checks. You cannot audit whether the agent followed the correct procedure because "the correct procedure" was never defined — it emerged from a natural language prompt each time.

**Incompleteness:** An LLM answering a vague question does not know which data points are critical for YOUR environment, which pg_stat_statements fields indicate which failure mode in YOUR PostgreSQL version, or which CloudWatch metric thresholds YOU have calibrated. It improvises from training data. The improvised procedure looks reasonable and misses the details that matter.

**Scope creep:** A vague prompt creates a vague agent. "Help me investigate the database" gives the agent latitude to try anything — including things your DBA team has decided are off-limits (DDL, parameter changes, anything requiring a maintenance window). The scope is defined at query time, not design time.

**No auditability:** After an incident, can you answer "did the agent follow the correct procedure?" With a prompt-based agent, the answer is always "the agent did what it decided to do based on the prompt." With a skill-based agent, you can compare the agent's actions against the SKILL.md procedure step by step.

### 1.2 What Skills Encode

A SKILL.md file encodes five things that an ad-hoc prompt cannot:

1. **When to activate.** Specific, observable trigger conditions — not "when the database is slow" but "when CloudWatch alarm `rds-cpu-high` fires on `$RDS_INSTANCE_ID`." The agent does not decide when to use the skill. The trigger conditions define that decision in advance.

2. **What data to gather.** Exact CLI commands with exact expected output. Not "check the metrics" but `aws rds describe-db-instances --db-instance-identifier $RDS_INSTANCE_ID --query 'DBInstances[0].{Status:DBInstanceStatus,...}'`. The agent does not improvise which data to collect. The script zone specifies every data point.

3. **How to reason about that data.** IF/THEN/ELSE decision trees with numeric thresholds. Not "if CPU is high, investigate further" but `IF CPUUtilization > 80 AND mean_exec_time_ms > 1000: Diagnosis = SLOW_QUERY_INDEX_GAP`. The reasoning is bounded and auditable.

4. **What is forbidden.** A NEVER DO list specific to this domain and this agent's scope. Not "be safe" but "NEVER execute `CREATE INDEX` without explicit human approval — reason: locks the table for the duration, blocks production writes during business hours."

5. **When to stop.** Escalation rules with specific triggering conditions. The agent does not decide when to escalate based on its own judgment. The skill defines the escalation threshold, and the agent follows it.

### 1.3 Skills as Context Engineering Artifacts

From the CLAUDE.md course philosophy: "Context engineering is THE core skill for building agentic systems. It's not about writing clever prompts — it's about structuring the right context."

A SKILL.md file is a context engineering artifact. When an agent loads a skill, the skill text becomes part of the LLM's context window at the system prompt level. The Brain reasons over:

```
[SOUL.md — who I am, what I never do]
[SKILL.md — what procedure to follow, what thresholds to apply]
[Tool results — what I have observed so far]
```

The quality of the agent's diagnostic decisions is directly proportional to the quality of the SKILL.md content. A skill with vague decision conditions produces vague diagnostics. A skill with numeric thresholds, named diagnosis strings, and specific escalation triggers produces auditable, reproducible diagnostics.

This is why the course teaches SKILL.md authoring as the primary skill, not Python agent code. The code (Hermes) is fixed. The context (SKILL.md) is the variable. Your domain expertise lives in the context, not in the code.

### 1.4 The Expert Vocabulary Effect

Consider two versions of a skill excerpt:

**Vague (poor skill):**
```
Check if the database is having performance problems.
Look at the slow queries and see if anything looks wrong.
```

**Expert vocabulary (good skill):**
```
Step 1.2 — Query pg_stat_statements for high-latency queries:
SELECT mean_exec_time_ms, total_exec_time_ms, calls, rows_per_call, query
FROM pg_stat_statements
WHERE mean_exec_time_ms > 1000
ORDER BY mean_exec_time_ms DESC
LIMIT 20;
```

The vague version forces the LLM to invent the query structure. It might produce a reasonable query — or it might query `pg_stat_activity` instead of `pg_stat_statements`, or order by `calls` instead of `mean_exec_time_ms`, or use a threshold of 500ms instead of your team's 1000ms standard. None of these are wrong in the abstract. All of them are wrong for your specific environment and investigation procedure.

The expert vocabulary version leaves the LLM no room to improvise. The exact query is specified. The exact threshold is specified. The field order is specified. The Brain's job is to execute this query and interpret the output — not to decide how to investigate slow queries.

This is the expert vocabulary effect: writing SKILL.md in the language of your domain (field names, threshold values, service identifiers, procedure steps) gives the LLM a better frame for reasoning than natural language descriptions. The LLM was trained on public documentation for these tools. Your domain-specific vocabulary activates that training precisely.

### 1.5 Escalation as a First-Class Concept

Every skill must know when to stop. Escalation rules are not failure paths — they are success paths for problems that are outside the agent's scope.

**Why agents do not escalate naturally:**

LLMs are trained to be helpful. Given a problem, the model's default behavior is to attempt a solution. This is exactly wrong for a production diagnostic agent. When an agent encounters a situation that requires human judgment (multi-service incident, hardware failure, DDL during business hours), the correct response is not "attempt a solution" — it is "escalate immediately with structured findings."

Without explicit escalation rules, the agent will continue attempting actions until it succeeds or reaches `max_turns`. During that time, it may be applying fixes to symptoms while the underlying cause propagates. The escalation rules in SKILL.md define the boundary condition: "beyond this point, human judgment is required."

**The escalation handoff template:**

An escalation rule is useless if it does not specify what information to hand off. The SKILL.md escalation section requires a handoff template:

```
Subject: [Skill Name] Escalation — [Diagnosis] on [Resource Identifier]

Findings:
  - Diagnosis: [Phase 2 diagnosis string]
  - [Primary metric]: [value] (threshold: [threshold])
  - Remediation attempted: [Yes/No]
  - Urgency: [CRITICAL | HIGH | MEDIUM]
```

The template ensures that the on-call engineer receives everything they need without follow-up questions. An escalation that says "there's a database problem, please check" has failed. An escalation that says "Diagnosis: SLOW_QUERY_LOCK_CONTENTION on prod-db-01, CPUUtilization: 91% sustained 8 minutes, mean_exec_time_ms: 4200ms on orders table update, parameter change requires restart — Urgency: HIGH" enables the engineer to act immediately.

### 1.6 NEVER DO Rules: The Specificity Requirement

Generic safety rules ("never do anything dangerous," "always be careful") are useless in a SKILL.md context. The Brain already knows to be careful — that is part of its training. What it does not know, without explicit encoding, is which specific commands are catastrophic in YOUR domain and WHY.

Compare:

**Generic (useless):**
```
NEVER do anything that could harm the production database.
```

**Domain-specific (useful):**
```
NEVER execute VACUUM FULL during business hours — reason: acquires exclusive lock on the table,
blocks all reads and writes for the duration (minutes to hours on large tables),
causes application timeout cascade.

NEVER run CREATE INDEX without CONCURRENTLY — reason: locks the table, blocks writes.
Use CREATE INDEX CONCURRENTLY instead (slower, does not block).

NEVER modify max_connections without scheduling a restart — reason: this is a static parameter
requiring DB restart; changing it applies immediately on parameter group but does not take effect
until the restart window, creating a false expectation that the change is live.
```

The domain-specific version tells the Brain exactly which actions to avoid, and exactly what catastrophic outcome each action causes. The Brain can now apply this knowledge when reasoning about a diagnosis: "I could create this index, but the skill says NEVER use CREATE INDEX without CONCURRENTLY because it locks the table. I'll recommend CREATE INDEX CONCURRENTLY instead."

---

## 2. The Two-Zone Design

### 2.1 The Problem the Two Zones Solve

Without the two-zone constraint, agents exhibit a failure mode called **mid-loop data discovery**:

1. Agent starts reasoning over the initial data (high CPU, slow queries visible)
2. During reasoning, the agent realizes it needs more data (what's the table size? is there a lock?)
3. Agent runs a new query to get that data
4. New data reveals a new dimension to the problem
5. Agent needs more data to understand the new dimension
6. Loop continues — the agent is not converging on a diagnosis, it is discovering new data indefinitely

This is not a hypothetical failure mode. It is the default behavior of an agent with no procedural constraints on data collection. The result is unpredictable session duration, escalating token costs, and a diagnosis that arrived at different conclusions depending on what data happened to be discovered in what order.

The two-zone design solves this by separating data collection from reasoning into distinct, sequential phases:

**Scripts Zone (Phase 1 and Phase 3):**
Run all the CLI commands. Collect all the data. No decisions. No interpretation. No "if this result looks concerning, also run X." Just: run this, get that, move to Phase 2.

The Scripts Zone is idempotent and deterministic. Running Phase 1 twice on the same database produces the same output. There is no branching based on intermediate results.

**Agents Zone (Phase 2 and Phase 4):**
Reason over the complete dataset collected in Phase 1. Apply the decision tree. Produce a named diagnosis or escalation. No new data collection. The reasoning is bounded.

The Agents Zone is where the LLM's reasoning capability is applied — but to a fixed input dataset, not an open-ended exploration.

### 2.2 Why Scripts Zone is Deterministic

The Scripts Zone serves a second purpose beyond controlling data collection scope: it makes skills testable.

Because Scripts Zone commands are exact CLI commands with exact expected outputs, the skill can be tested independently of the agent loop:

```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=messy
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c \
  "SELECT mean_exec_time_ms, calls, query FROM pg_stat_statements ORDER BY mean_exec_time_ms DESC"
```

The output is deterministic. It matches the `**Expected output**` block in the SKILL.md file. If it does not match, the mock data or the command is wrong — not an LLM reasoning failure.

This testability is why the RUBRIC.md Tier 1 checks include: "Every CLI command in a Scripts Zone phase is followed immediately by an `**Expected output**` block." The expected output blocks are not documentation. They are testable contracts.

### 2.3 Why Agents Zone Has No CLI Commands

Placing CLI commands inside an Agents Zone phase creates a mixed-concern violation that breaks two things:

**Breaks testability:** You can no longer test the Scripts Zone independently. The data collection is interleaved with reasoning, so you cannot verify "did the agent collect the right data?" separately from "did the agent reason correctly?"

**Creates feedback loops:** An LLM in a reasoning loop that can also run queries will run additional queries when its reasoning is uncertain. This is mid-loop data discovery — the exact failure mode the two-zone design prevents.

The enforced separation means the agent must work with the data it has. If the diagnosis is uncertain given available data, the correct response is escalation with "root cause ambiguous — missing data X" — not running another query to try to resolve the ambiguity.

### 2.4 Decision Tree Patterns: Specific vs Vague

The most common Tier 4 anti-pattern (which disqualifies a skill) is vague decision conditions:

```
# FAIL — vague condition:
IF the CPU is elevated:
  THEN investigate further

# PASS — specific condition with numeric threshold:
IF CPUUtilization > 80 AND mean_exec_time_ms > 1000:
  THEN Diagnosis = SLOW_QUERY_INDEX_GAP
  CONFIDENCE: High — both metrics confirm
```

The specific version does three things the vague version cannot:

1. **Reproducible:** Two agents running the same skill on the same data reach the same conclusion. The decision is not subject to LLM reasoning variation.

2. **Auditable:** After an incident, you can check whether the agent's diagnosis was consistent with the decision tree. If CPUUtilization was 92% and mean_exec_time_ms was 2400ms, you can verify: "Yes, the agent correctly diagnosed SLOW_QUERY_INDEX_GAP per the skill's decision tree."

3. **Bounded:** Every branch in the tree terminates at a named diagnosis string or an explicit escalation trigger. There is no path through the decision tree that ends in "continue investigating." Open-ended paths are a Tier 4 FAIL.

### 2.5 The Diagnosis String Pattern

The Agents Zone produces a named diagnosis string — not a description, a string:

```
Diagnosis = "SLOW_QUERY_INDEX_GAP"
Diagnosis = "PARAMETER_GROUP_DRIFT"
Diagnosis = "LOCK_CONTENTION_PEAK_HOURS"
Diagnosis = "NO_ISSUE_FOUND"
```

Why strings? Because:
- They are greppable. Audit logs can be searched for specific diagnoses.
- They are consistent. The same condition always produces the same string, regardless of LLM temperature or prompt variation.
- They are actionable. A diagnosis string maps directly to a remediation path in Phase 3 and Phase 4.
- They are comparable. Across multiple sessions, multiple agents, multiple incidents — the same string means the same finding.

### 2.6 The Structured Report Pattern (Track C)

Some skills produce a structured report instead of (or in addition to) a simple diagnosis string. Track C's Kubernetes health skill exemplifies this:

The Phase 2 Agents Zone produces a JSON report with defined fields:
- `diagnosis`: the diagnosis string
- `confidence`: the confidence level
- `evidence`: the supporting data points from Phase 1
- `recommendation`: the specific remediation step
- `ambiguity_statement`: what the agent cannot determine from available data

The `ambiguity_statement` field is required in Track C (per the design decision: "Ambiguity Statement is required Stage 2 field — drives agent to articulate limits of pod-level data"). It forces the agent to say explicitly what it does not know, rather than silently skipping over limitations. An agent that says "I cannot determine whether the OOM is caused by a memory leak or a workload spike — this requires container metrics not available in pod-level data" is more useful than one that provides a confident diagnosis based on incomplete information.

---

## 3. The Hermes SKILL.md Implementation

### 3.1 Frontmatter Fields and Their Purpose

Every SKILL.md file begins with a YAML frontmatter block. The fields are not decoration — each serves a specific purpose in the agent's skill loading and routing:

```yaml
---
name: dba-rds-slow-query
description: "Investigate RDS PostgreSQL slow query performance using pg_stat_statements.
  Use when CloudWatch RDS CPUUtilization alarm fires, application reports slow queries,
  or pg_stat_statements shows queries with mean_time > 1000ms."
version: 1.0.0
compatibility: "aws cli v2, psql, HERMES_LAB_MODE=mock|live"
metadata:
  hermes:
    category: devops
    tags: [rds, postgresql, slow-query, pg-stat-statements, index, performance]
---
```

**`name`:** Must match the skill directory name in kebab-case. Used for `hermes skill info`, skill selection, and audit logging.

**`description`:** The skill's searchable summary. The `description` field is what the `skills_search` tool queries when an agent has multiple skills and needs to locate the right one. It must answer: "When should I use this skill?" — not "What does this skill do?" Start with an action verb, include the domain, service, and trigger condition.

**`version`:** Semantic versioning (1.0.0). Skills can be versioned and updated without changing the agent configuration. When participants build their own skills in Module 7, starting at `1.0.0` and incrementing with each revision creates an audit trail.

**`compatibility`:** Lists required tool versions AND the `HERMES_LAB_MODE=mock|live` declaration. This field is checked by the Tier 1 rubric — a skill that does not declare mock/live compatibility cannot be used in course labs.

**`metadata.hermes.category`:** One of `devops`, `sre`, `dba`, `observability`. Used for skill discovery and filtering.

**`metadata.hermes.tags`:** Used for keyword search across the skills hub. At minimum: domain, service, key operations.

### 3.2 The agentskills.io Spec Alignment

The SKILL.md format used in this course aligns with the `agentskills.io` spec published in December 2025. This is a cross-platform standard — skills authored in the SKILL.md format are compatible with any framework that implements the spec, not just Hermes.

What this means practically:
- Skills you author in this course can be shared with colleagues using other agent frameworks (LangGraph, AutoGen, CrewAI, etc.)
- The agentskills.io spec uses YAML frontmatter + Markdown sections — the same structure you see in `course/skills/SKILL-TEMPLATE.md`
- The `hermes` metadata block (`metadata.hermes.*`) is a vendor extension — framework-specific extensions are explicitly supported by the spec

The cross-platform compatibility is why the format matters beyond Hermes. The operational knowledge encoded in a SKILL.md file is a reusable asset.

### 3.3 SKILL-TEMPLATE.md Walkthrough

The canonical template at `course/skills/SKILL-TEMPLATE.md` contains nine required sections in order:

1. **When to Use** — trigger conditions (specific alarms, metric thresholds, observable signals)
2. **Inputs** — table with columns `Input | Source | Required | Description`; must include `HERMES_LAB_MODE` row
3. **Prerequisites** — tools table, permissions table, environment variable setup block, mock mode setup instructions
4. **Procedure** — the two-zone phases (alternating Scripts Zone and Agents Zone)
5. **Escalation Rules** — trigger conditions + handoff template with required fields
6. **NEVER DO** — domain-specific prohibited actions with consequences
7. **Rollback Procedure** — steps to undo Phase 3 changes; must cover each change type Phase 3 makes
8. **Verification** — markdown checklist for confirming skill run is complete

The template uses `[square bracket]` placeholder syntax throughout. This is intentional: a grep for `[` returns any unfilled placeholder. Participants completing Module 7 can run:

```bash
grep -c "\[" skills/my-skill/SKILL.md
```

If the count is nonzero, the skill has unfilled placeholders and is not ready for use.

### 3.4 RUBRIC.md Structure: Four Tiers

The quality rubric at `course/skills/RUBRIC.md` has 62 checkboxes organized in four tiers:

**Tier 1 — Blockers (must ALL pass before skill can be used in any lab):**
- Frontmatter completeness (7 items: name, description, version, compatibility, category, tags, YAML delimiters)
- Section completeness (8 required sections present)
- When to Use quality (specific named triggers, no vague conditions)
- Inputs table format
- Prerequisites quality
- Two-zone design enforcement (SCRIPTS ZONE and AGENTS ZONE labels present; no CLI in Agents Zone; no prose decisions in Scripts Zone)
- Scripts Zone: CLI commands with expected output blocks (inline, not external references)
- Agents Zone: decision trees with numeric thresholds, named termination conditions
- Escalation Rules: 2+ triggers with observable conditions + handoff template
- NEVER DO: 3+ domain-specific items with stated consequences
- Rollback Procedure: numbered steps covering Phase 3 changes
- Verification checklist: 4+ checkboxes
- Mock mode documentation present

**Tier 2 — Quality (should fix before Module 10 agent build):**
Clean two-zone separation throughout. Escalation handoff is copy-paste ready. Expected output matches real API field names. Skill tested end-to-end in mock mode.

**Tier 3 — Production-Grade (required before shipping to participants as take-home material):**
Messy scenario tested. Mock and live produce equivalent diagnostic decisions. Tested with Haiku-tier model. Skills Hub metadata validated.

**Tier 4 — Anti-Patterns (one FAIL disqualifies the skill):**
These ten patterns are automatic disqualifiers. Key ones:
- Any decision branch ending in "investigate further" without a stopping criterion
- CLI commands inside an Agents Zone phase
- Expected output blocks that reference external files instead of inline output
- Subjective decision conditions ("slow," "high," "elevated" without numeric threshold)
- AWS field names in camelCase instead of PascalCase (real AWS uses `DBInstanceStatus`, not `dbInstanceStatus`)

### 3.5 Running Automated Rubric Checks

The RUBRIC.md "Automated Checks" section provides grep commands that confirm Tier 1 compliance before human review:

```bash
# Check mandatory sections (should return 8):
grep -c "## When to Use\|## Inputs\|## Prerequisites\|## Procedure\|## Escalation Rules\|## NEVER DO\|## Rollback Procedure\|## Verification" SKILL.md

# Verify both zones labeled (should return 2+):
grep -c "SCRIPTS ZONE\|AGENTS ZONE" SKILL.md

# Count NEVER DO items (should return 3+):
grep -c "^\- \*\*NEVER\|^- NEVER" SKILL.md

# Check HERMES_LAB_MODE present (should return 1+):
grep -c "HERMES_LAB_MODE" SKILL.md

# Count verification checkboxes (should return 4+):
grep -c "\- \[ \]" SKILL.md
```

These checks do not replace the full Tier 1 checklist — they surface obvious failures quickly. A skill that passes all automated checks may still fail human review on content quality.

### 3.6 How Skill Loading Works at Runtime

When Hermes loads an agent profile, it scans the `skills/` subdirectory and reads each `SKILL.md` file. The skill content is prepended to the system prompt — every skill the agent has is visible to the Brain from the first turn.

For agents with 1-3 skills (typical for course agents), this is the right approach: the agent does not need to decide which skill to use before using it, because all skills are already in context. For production agents with many skills (10+), the `skills_search` tool becomes important — the agent queries it to locate the right skill by keyword before loading its full text.

The session startup sequence:
1. Load `config.yaml` — determines model, toolsets, approval mode
2. Load `SOUL.md` — agent identity and behavioral constraints
3. Scan `skills/` directory — load all SKILL.md files
4. Initialize tool registry with enabled toolsets
5. First LLM call with full context: SOUL.md + all skills + tool schemas

The agent's context window contains everything it needs from the first token. There is no lazy loading, no on-demand skill injection. This is a deliberate tradeoff: simplicity and reliability over token efficiency.

---

## 4. DevOps Skill Examples

### 4.1 Track A: dba-rds-slow-query Skill Anatomy

The `dba-rds-slow-query` skill is the Track A reference implementation. Its anatomy illustrates how the two-zone design handles a realistic multi-step diagnostic:

**Phase 1 — Gather RDS and CloudWatch Data [SCRIPTS ZONE — deterministic]:**

Exactly 4 data collection steps:
- Step 1.1: `aws rds describe-db-instances` — instance status, class, engine version
- Step 1.2: `aws cloudwatch get-metric-statistics` — CPUUtilization last 60 minutes
- Step 1.3: `psql -c "SELECT ... FROM pg_stat_statements WHERE mean_exec_time_ms > 1000"` — slow query list
- Step 1.4: `psql -c "SELECT ... FROM pg_stat_user_tables"` — sequential scan ratios per table

Each step has an `**Expected output**` block with the exact JSON or CSV format the tool returns. These blocks match the mock data files in `course/infrastructure/mock-data/rds/`.

**Phase 2 — Diagnose Root Cause [AGENTS ZONE — reasoning]:**

The decision tree has these named termination points:
- `SLOW_QUERY_INDEX_GAP` — pg_stat_statements shows high mean_exec_time_ms AND pg_stat_user_tables shows > 80% sequential scans
- `CPU_SPIKE_NO_QUERY_MATCH` — CloudWatch shows CPU spike but pg_stat_statements shows no query > 1000ms (connection storm, non-query CPU usage)
- `PARAMETER_GROUP_PENDING` — `describe-db-instances` shows `PendingModifiedValues.DBParameterGroupName` (change queued, not applied)
- `NO_ISSUE_FOUND` — all metrics within normal range; report false positive

Every branch terminates at a named string. No open-ended paths.

**The mock/live behavior:**

In mock mode (`HERMES_LAB_MODE=mock`), the `psql` command is intercepted by `course/infrastructure/wrappers/mock-psql`. The wrapper reads `course/infrastructure/mock-data/rds/pg-stat-statements-clean.json` (or `-messy.json` if `HERMES_LAB_SCENARIO=messy`) and returns it in CSV format — matching exactly what the real psql command returns. The skill procedure does not change between mock and live modes. Only the data source changes.

### 4.2 Two-Zone Design with Code Example

Here is the two-zone separation from the dba-rds-slow-query skill — showing what belongs in each zone:

**Scripts Zone (Phase 1, Step 1.3) — correct:**
```bash
psql -h $DB_HOST -p ${DB_PORT:-5432} -U $DB_USER -d $DB_NAME --csv -c \
  "SELECT mean_exec_time_ms, total_exec_time_ms, calls, rows_per_call,
          LEFT(query, 200) as query
   FROM pg_stat_statements
   WHERE mean_exec_time_ms > 1000
   ORDER BY mean_exec_time_ms DESC
   LIMIT 20"
```
No interpretation. No branching. Run this, get that.

**Agents Zone (Phase 2) — correct:**
```
IF mean_exec_time_ms > 5000:
  THEN Diagnosis = "CRITICAL_SLOW_QUERY"
  → Escalate immediately (see Escalation Rules)

ELSE IF mean_exec_time_ms > 1000 AND sequential_scan_pct > 80:
  THEN Diagnosis = "SLOW_QUERY_INDEX_GAP"
  → Proceed to Phase 3 (index recommendation)

ELSE IF mean_exec_time_ms > 1000 AND sequential_scan_pct <= 80:
  THEN Diagnosis = "SLOW_QUERY_OTHER_CAUSE"
  → Check Phase 1 Step 1.4 for lock contention indicators
```
No CLI commands. Only IF/THEN/ELSE logic on the data already collected.

**Mixed violation (Tier 4 FAIL — do not do this):**
```
Phase 2 — Analysis:
Check if the queries are slow:
aws cloudwatch get-metric-statistics ...   ← CLI command in Agents Zone!
IF the metrics show high CPU...            ← vague condition
```

This violates both the Scripts Zone rule (no reasoning) AND the Agents Zone rule (no CLI commands). The result is an agent that runs unpredictable queries during reasoning, making its behavior session-dependent and unauditable.

### 4.3 Track B: cost-anomaly Skill Anatomy

The `cost-anomaly` skill for FinOps agents demonstrates the two-zone design applied to cost analysis instead of database diagnostics:

**Phase 1 [SCRIPTS ZONE]:**
- `aws ce get-cost-and-usage` — last 14 days of daily cost grouped by service
- `aws ce get-cost-and-usage` — same period, previous month (baseline period)
- `aws cloudwatch describe-alarms --alarm-name-prefix "billing-"` — billing alarm status

Each command is intercepted by `course/infrastructure/wrappers/mock-aws` in mock mode. The mock returns `course/infrastructure/mock-data/cost-explorer/anomaly-spike.json` (scenario=messy) or `normal-spend.json` (scenario=clean).

**Phase 2 [AGENTS ZONE]:**
```
IF current_day_cost > 1.5x baseline_daily_average:
  AND specific_service_cost increased > 200%:
    THEN Diagnosis = "SERVICE_COST_SPIKE"
    SERVICE = [service name from ce output]

IF cost still > 1.2x baseline at day 7 of anomaly:
  THEN Diagnosis = "SUSTAINED_ELEVATED_SPEND"
  NOTE: Partial resolution — spike not fully resolved

IF all services within 10% of baseline:
  THEN Diagnosis = "NO_ANOMALY_CURRENT_PERIOD"
```

Note: The mock data for cost anomaly includes "day 7 partially resolved at $26 (vs baseline $13)" — this intentional ambiguity tests whether the agent correctly identifies a SUSTAINED_ELEVATED_SPEND rather than declaring the incident closed.

### 4.4 Track C: sre-k8s-pod-health Skill Anatomy

The `sre-k8s-pod-health` skill exemplifies the read-only escalation model: the agent diagnoses but never remediates. It is the canonical example for Track C — a Kubernetes diagnostic procedure that gathers pod state in Phase 1 [SCRIPTS ZONE] using `kubectl get pods`, `kubectl describe pod`, `kubectl logs`, and `kubectl top pods`, then applies six decision branches in Phase 2 [AGENTS ZONE] to identify which of the six K8S failure modes is present (ImagePullBackOff, CrashLoopBackOff, OOMKilled, Liveness probe failure, CreateContainerConfigError, Service port mismatch).

**Phase 1 [SCRIPTS ZONE]:**
- `kubectl get pods -n $NAMESPACE -o json` — pod inventory and container status
- `kubectl describe pod $POD_NAME -n $NAMESPACE` — events and container last-state details
- `kubectl logs $POD_NAME -n $NAMESPACE --tail=100 --previous` — terminated-instance logs for crash diagnosis
- `kubectl top pods -n $NAMESPACE` — current resource consumption
- `kubectl get endpoints -n $NAMESPACE` — service endpoint state for port mismatch detection

No write operations. Every command is a read-only get or describe.

**Phase 2 [AGENTS ZONE]:**
All decision branches end in either a named diagnosis or escalation. No branch ends in a remediation action. This is the read-only model — the skill's scope is diagnosis and escalation, not remediation. When the diagnosis warrants action, the skill escalates to a human who executes the remediation.

This is NOT a limitation of the skill. It is a deliberate governance decision: SRE agents in the course operate with principle of least privilege. Read-only agents can be trusted with continuous monitoring because their blast radius is zero.

---

## 5. Course Examples — File References

The following files are the canonical examples for each concept covered in this guide. After reading this document, open these files to see the design principles applied:

**The complete blank template:**
`course/skills/SKILL-TEMPLATE.md` — Every required section with `[square bracket]` placeholders. Use this as your starting point for any new skill. Note the `[SCRIPTS ZONE — deterministic]` and `[AGENTS ZONE — reasoning]` labels in the Phase headings — these are REQUIRED labels, not optional descriptors.

**The quality rubric (62 checkboxes):**
`course/skills/RUBRIC.md` — Organized in four tiers. The Tier 4 Anti-Patterns section (ten automatic disqualifiers) is the most important for understanding what a failing skill looks like. The "Common Failure Patterns by Track" section at the bottom names the specific failures seen most often in each track.

**Track A reference implementation:**
`course/skills/dba-rds-slow-query/SKILL.md` — The most complete example. Shows numeric thresholds, named diagnosis strings, and the mock-data integration. Compare the Phase 1 expected output blocks against the actual mock files in `course/infrastructure/mock-data/rds/`.

**Track B reference implementation:**
`course/skills/cost-anomaly/SKILL.md` — Demonstrates the two-zone design for cost analysis. Shows how the cost anomaly ambiguity (day 7 partially resolved) is handled by the decision tree without open-ended "investigate further" branches.

**Track C reference implementation:**
`course/skills/sre-k8s-pod-health/SKILL.md` — The read-only escalation model for Kubernetes diagnosis. Notice that Phase 3 does not exist — there is no remediation phase. The skill escalates directly from Phase 2 diagnosis to structured handoff. This is correct for an agent operating under read-only governance.

**Module 7 solution skills:**
`course/modules/module-07-skills/solution/` — All four track solution skills from the Module 7 lab. These are what a completed participant skill looks like. Compare against SKILL-TEMPLATE.md to see how the placeholders are filled in.

---

## 6. Quick Reference

### 6.1 SKILL.md Sections — Required Order

| Section | Purpose | Required? | Rubric Tier |
|---|---|---|---|
| YAML frontmatter | Metadata for skill loading, discovery, versioning | Yes | Tier 1 |
| `## When to Use` | Specific trigger conditions; anti-cases | Yes | Tier 1 |
| `## Inputs` | Input table with `HERMES_LAB_MODE` row | Yes | Tier 1 |
| `## Prerequisites` | Tools, permissions, env var setup, mock setup | Yes | Tier 1 |
| `## Procedure` | Alternating Scripts Zone / Agents Zone phases | Yes | Tier 1 |
| `## Escalation Rules` | Observable triggers + handoff template | Yes | Tier 1 |
| `## NEVER DO` | 3+ domain-specific prohibited actions with consequences | Yes | Tier 1 |
| `## Rollback Procedure` | Steps to undo Phase 3 changes | Yes | Tier 1 |
| `## Verification` | 4+ checkboxes confirming skill run complete | Yes | Tier 1 |

### 6.2 Trigger Condition Patterns — Good vs Bad

| Good (Specific) | Bad (Vague) | Why Good Is Better |
|---|---|---|
| `When CloudWatch alarm rds-cpu-high fires (CPUUtilization > 80%)` | `When database is slow` | Names the specific alarm; maps to a specific metric |
| `When pg_stat_statements shows mean_exec_time_ms > 1000ms` | `When queries seem slow` | Numeric threshold; greppable in audit logs |
| `When aws ce get-cost-and-usage shows current day > 1.5x baseline` | `When costs are elevated` | Specific metric and specific formula |
| `When kubectl get pods shows STATUS=OOMKilled` | `When pods are having issues` | Named status string; no interpretation required |

### 6.3 Decision Tree Patterns — Numeric vs Subjective

| Acceptable (Numeric threshold) | Fails Tier 4 (Subjective) |
|---|---|
| `IF CPUUtilization > 80 AND mean_exec_time_ms > 1000` | `IF CPU is high and queries are slow` |
| `IF DBInstanceStatus == "modifying"` | `IF instance seems like it is changing` |
| `IF sequential_scan_pct > 80` | `IF sequential scan ratio is elevated` |
| `IF daily_cost > 1.5 * baseline_daily_average` | `IF costs look unusual compared to normal` |
| All branches terminate at diagnosis string or escalation | Branch ends: "investigate further" |

### 6.4 NEVER DO Patterns by Track

| Track | Domain | Example NEVER DO |
|---|---|---|
| Track A (DBA) | RDS PostgreSQL | NEVER execute ALTER TABLE or CREATE INDEX without explicit human approval — causes table lock, blocks production writes |
| Track A (DBA) | RDS PostgreSQL | NEVER run VACUUM FULL during business hours — acquires exclusive lock, blocks all reads and writes |
| Track B (FinOps) | AWS Cost Explorer | NEVER execute `aws ec2 terminate-instances` based on cost findings alone — requires cross-team approval |
| Track B (FinOps) | AWS Cost Explorer | NEVER modify Reserved Instance or Savings Plan coverage without finance team approval |
| Track C (K8s) | Kubernetes | NEVER run `kubectl delete pod` during active traffic — use rollout restart for controlled pod cycling |
| Track C (K8s) | Kubernetes | NEVER modify resource limits on running deployments without checking PodDisruptionBudget |
| All tracks | General | NEVER skip Phase 2 diagnosis and jump to Phase 3 remediation — blind remediation risks making the problem worse |

### 6.5 Tier 1 Quick-Check with Grep

Run these commands on any skill before human review:

```bash
# All 8 required sections present? (should return 8)
grep -c "## When to Use\|## Inputs\|## Prerequisites\|## Procedure\|## Escalation Rules\|## NEVER DO\|## Rollback Procedure\|## Verification" SKILL.md

# Both zone labels present? (should return 2+)
grep -c "SCRIPTS ZONE\|AGENTS ZONE" SKILL.md

# NEVER DO has 3+ items? (should return 3+)
grep -c "^\- \*\*NEVER\|^- NEVER" SKILL.md

# HERMES_LAB_MODE documented? (should return 1+)
grep -c "HERMES_LAB_MODE" SKILL.md

# Verification has 4+ checkboxes? (should return 4+)
grep -c "\- \[ \]" SKILL.md

# No unfilled placeholders? (should return 0)
grep -c "\[placeholder\]\|\[like this\]\|\[skill-name\]" SKILL.md
```

If all counts match, proceed to human review of Tier 1 content quality (are the conditions actually specific? do decision trees actually have named termination points?).

### 6.6 Two-Zone Design Summary

| Aspect | Scripts Zone | Agents Zone |
|---|---|---|
| Purpose | Data collection | Reasoning and diagnosis |
| Contains | CLI commands + expected output | IF/THEN/ELSE decision trees |
| Does NOT contain | Prose decisions, IF/THEN logic | CLI commands (aws, kubectl, psql) |
| Is it deterministic? | Yes — same input → same output | No — LLM reasoning varies |
| Is it testable independently? | Yes — run commands, compare expected output | Yes — feed Phase 1 output, verify diagnosis |
| Phase label | `[SCRIPTS ZONE — deterministic]` | `[AGENTS ZONE — reasoning]` |
| Typical phases | Phase 1 (data collection), Phase 3 (remediation) | Phase 2 (diagnosis), Phase 4 (verification) |
