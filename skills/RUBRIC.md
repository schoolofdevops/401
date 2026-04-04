# Skill Quality Rubric

**Applies to:** All DevOps course skills (SKIL-01 through SKIL-04 and any participant-authored skills)
**Reference template:** [SKILL-TEMPLATE.md](./SKILL-TEMPLATE.md)
**Used by:** Instructor reviewing participant skills in Module 7 lab; Claude self-checking before submitting any skill

A skill that fails Tier 1 CANNOT be loaded into an agent and used in labs. Work through the tiers in order — do not proceed to Tier 2 if any Tier 1 item is unchecked.

---

## Tier 1: BLOCKERS

**A skill with ANY unchecked item here cannot be used in Hermes or course labs. Fix these first.**

### 1.1 Frontmatter

- [ ] YAML frontmatter block is present (starts with `---`, ends with `---`)
- [ ] `name` field present: kebab-case, matches the skill directory name
- [ ] `description` field present: one sentence, starts with an action verb, contains domain + service + trigger condition (not "manages X" — must say WHEN to use it)
- [ ] `version` field present: follows semantic versioning (`1.0.0` format)
- [ ] `compatibility` field present: lists required tool versions AND `HERMES_LAB_MODE=mock|live`
- [ ] `metadata.hermes.category` field present: one of `devops`, `sre`, `dba`, `observability`
- [ ] `metadata.hermes.tags` field present: list with at least 3 tags covering domain, service, and key actions

### 1.2 Section Completeness (all 9 sections in order, per SKILL-TEMPLATE.md)

- [ ] `## When to Use` section exists
- [ ] `## Inputs` section exists
- [ ] `## Prerequisites` section exists
- [ ] `## Procedure` section exists
- [ ] `## Escalation Rules` section exists
- [ ] `## NEVER DO` section exists
- [ ] `## Rollback Procedure` section exists
- [ ] `## Verification` section exists

### 1.3 When to Use Quality

- [ ] At least one named trigger condition — references a specific alarm ID, metric name, or observable signal (example: "When CloudWatch alarm `rds-cpu-high` fires" — NOT "When database is slow")
- [ ] No vague triggers like "when the system is degraded" or "when things seem off"

### 1.4 Inputs Table

- [ ] `## Inputs` contains a table with exactly these columns: `Input | Source | Required | Description`
- [ ] Table has at least 2 data rows (not counting header)
- [ ] `HERMES_LAB_MODE` row present with values `mock` (offline) and `live` (real infra) documented

### 1.5 Prerequisites Quality

- [ ] Tools table lists each required CLI tool with version and install command
- [ ] Permissions section lists at least one IAM action / RBAC role / access requirement
- [ ] `HERMES_LAB_MODE` environment variable documented with example export command

### 1.6 Procedure: Two-Zone Design

- [ ] `## Procedure` has at least 2 phases
- [ ] Every phase heading includes EITHER `[SCRIPTS ZONE — deterministic]` OR `[AGENTS ZONE — reasoning]` label
- [ ] No CLI commands (`aws`, `kubectl`, `psql`, `curl`, etc.) appear inside an AGENTS ZONE phase
- [ ] No prose decision logic ("check if...", "determine whether...") appears inside a SCRIPTS ZONE phase
- [ ] At least 1 Scripts Zone phase and at least 1 Agents Zone phase are present

### 1.7 Scripts Zone: CLI Commands and Expected Output

- [ ] Minimum 5 distinct CLI commands across ALL Scripts Zone phases combined
- [ ] Every CLI command in a Scripts Zone phase is followed immediately by an `**Expected output**` block (on the very next non-blank line after the code block)
- [ ] No expected output block says "see separate file" or references an external fixture path — output must be inline
- [ ] Expected output blocks show the ACTUAL format the tool returns (AWS: PascalCase fields like `DBInstances`, `DBInstanceStatus`; kubectl JSON: camelCase; plain text CLIs: verbatim sample text)

### 1.8 Agents Zone: Decision Trees

- [ ] Minimum 3 decision branches across ALL Agents Zone phases combined
- [ ] Every IF condition uses an observable, numeric criterion — no subjective conditions
  - PASS: `IF CPUUtilization > 80`
  - PASS: `IF DBInstanceStatus == "modifying"`
  - FAIL: `IF database is slow`
  - FAIL: `IF CPU seems high`
- [ ] Every decision branch terminates at either: a named action, a named diagnosis string, or an explicit escalation trigger — NOT "investigate further" without a stopping criterion
- [ ] Decision tree uses consistent IF/THEN/ELSE syntax (not free-form prose)

### 1.9 Escalation Rules

- [ ] `## Escalation Rules` section has at least 2 named escalation triggers
- [ ] Each trigger specifies the OBSERVABLE condition that fires it (not just "if things go wrong")
- [ ] Escalation handoff block specifies WHAT information to include (diagnosis, metric values, pre-change snapshot path, urgency level) — not just "share your findings"

### 1.10 NEVER DO

- [ ] `## NEVER DO` section exists with at least 3 items
- [ ] Each item includes the forbidden command or action AND the reason (what bad outcome it causes)
- [ ] Items are specific to this skill's domain — not generic security hygiene copy-paste

### 1.11 Rollback Procedure

- [ ] `## Rollback Procedure` section has numbered steps
- [ ] Rollback addresses each type of change the skill's Phase 3 might make
- [ ] Pre-change snapshot step referenced (Step 3.1 in template) — rollback relies on it

### 1.12 Verification Checklist

- [ ] `## Verification` section contains at least 4 markdown checkboxes (`- [ ]`)
- [ ] Checkboxes cover: data collection complete, diagnosis produced, remediation (if applicable), recovery metric confirmed, HERMES_LAB_MODE verified

### 1.13 Mock Mode Documentation

- [ ] `[MOCK MODE]` behavior documented or referenced — participants must know when data is simulated
- [ ] Mock mode setup instructions in Prerequisites (where to find fixture files, how to verify)

---

## Tier 2: QUALITY

**Skill is usable but needs improvement before Module 10 agent build. Fix before participants rely on it in advanced labs.**

- [ ] `description` field is keyword-rich for agent retrieval: contains domain name, service name, and at least 2 action verbs (not just nouns)
- [ ] Two-zone separation is clean throughout the entire document — reviewer did not find a single reasoning sentence in a Scripts Zone, or a raw CLI command in an Agents Zone
- [ ] Escalation handoff block is copy-paste ready — a human receiving it would have all context without follow-up questions
- [ ] `## NEVER DO` items are domain-specific: they call out exactly the commands that would be tempting and dangerous in THIS skill's context (not boilerplate like "never run rm -rf")
- [ ] Expected output samples match real API response field names and value types — not invented names, not camelCase for AWS services
- [ ] `## Rollback Procedure` addresses each class of change Phase 3 makes — if Phase 3 has 3 different remediation paths, rollback covers all 3
- [ ] Skill has been tested end-to-end in `HERMES_LAB_MODE=mock` — all commands run without error, all expected output blocks match actual mock output
- [ ] Phase step numbering is consistent: outer phases are `Phase N`, inner steps are `Step N.N` (not random numbering)

---

## Tier 3: PRODUCTION-GRADE

**Required before delivering this skill as a take-home artifact in Tier 1 participant packages.**

- [ ] Messy scenario tested: skill was run against a scenario with SIMULTANEOUS issues (not just the clean single-fault case) and produced an unambiguous diagnosis — per D-09
- [ ] Mock and live mode produce equivalent information: an agent running with `HERMES_LAB_MODE=mock` makes the same diagnostic decision as with `HERMES_LAB_MODE=live` on a matching real scenario
- [ ] `HERMES_LAB_MODE=mock` propagation fully documented for all tool calls in this skill — every CLI command has a mock wrapper or fixture documented
- [ ] Skill tested end-to-end with `claude-haiku-4-5` (or equivalent Haiku-tier model) — no reasoning step requires a larger model to produce a correct diagnosis per D-11
- [ ] Skills Hub metadata validated: `hermes skill info [skill-name]` returns correct name, description, version, and tags

---

## Tier 4: ANTI-PATTERNS

**Scan for these AFTER completing Tier 1 checklist. A single FAIL here disqualifies the skill.**

- FAIL if: Any decision branch ends with "investigate further", "check more", "look into it", or any open-ended instruction without a stopping criterion or escalation trigger
- FAIL if: Any CLI command (`aws`, `kubectl`, `psql`, `curl`, `grep`, etc.) appears inside an `[AGENTS ZONE — reasoning]` phase
- FAIL if: Any `**Expected output**` block references an external file ("see `output-examples/rds.json`", "refer to fixtures/") — all expected output MUST be inline
- FAIL if: `## NEVER DO` section is absent OR has fewer than 3 items OR any item lacks a stated reason
- FAIL if: Any decision condition uses subjective or relative language ("slow", "high", "elevated", "bad", "unusual") without a numeric threshold or named status value
- FAIL if: `## Escalation Rules` section exists but the handoff template does not specify WHAT information to include (lists escalation conditions but not what to send)
- FAIL if: Any mock JSON expected output uses camelCase for AWS service fields — real AWS uses PascalCase exclusively (`DBInstances`, `DBInstanceStatus`, `DBInstanceClass`, not `dbInstances`, `status`, `instanceClass`)
- FAIL if: The `compatibility` frontmatter field is absent or does not mention `HERMES_LAB_MODE=mock|live`
- FAIL if: `## Procedure` has only 1 phase — minimum is 2 (one Scripts Zone, one Agents Zone)
- FAIL if: The `## Inputs` table is missing the `HERMES_LAB_MODE` row

---

## How to Use This Rubric

### Sequence

1. **Open the skill file** and the [SKILL-TEMPLATE.md](./SKILL-TEMPLATE.md) side by side
2. **Run Tier 1 blockers first** — work through every checkbox in order
   - If ANY Tier 1 item fails: STOP, fix the skill, re-check from the top of Tier 1
   - Do not proceed to Tier 2 until ALL Tier 1 items are checked
3. **Run Tier 2 quality checks** — these are fixable before the next module lab
4. **Run Tier 3 production-grade checks** — required before shipping to participants as take-home material
5. **Quick-scan Tier 4 anti-patterns** — one FAIL disqualifies the skill; fix before any further use

### Automated Checks You Can Run

```bash
# Count mandatory section headers (should return 8):
grep -c "## When to Use\|## Inputs\|## Prerequisites\|## Procedure\|## Escalation Rules\|## NEVER DO\|## Rollback Procedure\|## Verification" SKILL.md

# Verify both zones are labeled (should return 2+):
grep -c "SCRIPTS ZONE\|AGENTS ZONE" SKILL.md

# Count NEVER DO items (should return 3+):
grep -c "^\- \*\*NEVER\|^- NEVER" SKILL.md

# Verify FAIL if count (should return 10 for this rubric, N for a skill's anti-patterns):
grep -c "FAIL if" RUBRIC.md

# Check HERMES_LAB_MODE is present (should return 1+):
grep -c "HERMES_LAB_MODE" SKILL.md

# Count checkboxes in Verification section (should return 4+):
grep -c "\- \[ \]" SKILL.md
```

### Review Roles

| Reviewer | When | Use Tiers |
|----------|------|-----------|
| Participant (self-check) | Before submitting Module 7 lab | Tier 1 only |
| Instructor (lab review) | During Module 7 lab debrief | Tier 1 + Tier 2 |
| Claude (self-check before submitting SKIL-01 through SKIL-04) | Before any skill commit | Tier 1 + Tier 2 + Tier 4 |
| Course developer (shipping) | Before final participant package | All 4 Tiers |

### Common Failure Patterns by Track

**Track A (SRE / EC2):** Most common Tier 1 failures:
- `## When to Use` lists EC2 as the service but doesn't name the CloudWatch alarm ID
- Expected output for `aws ec2 describe-instances` uses lowercase field names

**Track B (DevOps / Deployment):** Most common Tier 1 failures:
- Phase 3 (deploy steps) has no rollback procedure — "rollback by reverting the commit" is not a rollback procedure
- Decision tree says "IF deployment fails" without defining what failure looks like (exit code, metric threshold, log pattern)

**Track C (DBA / RDS):** Most common Tier 1 failures:
- Expected output for `aws rds describe-db-instances` uses camelCase (`dbInstanceStatus` instead of `DBInstanceStatus`)
- pg_stat_statements output section uses invented column names that don't match real PostgreSQL output

**Track D (Observability / Alerts):** Most common Tier 1 failures:
- `## When to Use` is too broad ("when alerts are noisy") — must name which CloudWatch alarm stream or Grafana alert group
- Agents Zone decision tree treats alert count thresholds as vague ("many alerts") instead of numeric ("> 10 alerts in 5 minutes")
