# Module 10 Lab: Build the Database Health Agent (Track A)

**Duration:** 90 minutes (45 min guided + 45 min free explore)
**Track:** A — Database Health & Tuning
**Prerequisite:** Hermes installed, HERMES_LAB_MODE understood (from Module 8)
**Outcome:** A running Aria agent that diagnoses RDS slow queries against both clean and messy mock scenarios

> You are installing the completed Track A reference agent, running it against two realistic RDS diagnostic
> scenarios, testing its safety boundaries, and then extending it on your own. By the end of this lab,
> you will have run a full structured incident report — the kind of output you hand to a DBA for review.

---

## GUIDED PHASE — 45 minutes

---

## Step 1: Prerequisites and Environment Setup (5 min)

Verify Hermes is installed:

```bash
hermes --version
```

Export the environment variables for Track A mock mode. Run this block **exactly** from the root of your course directory:

```bash
export HERMES_LAB_SCENARIO=clean
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

> **Verify mock wrappers are on PATH:**
>
> ```bash
> which mock-psql
> # Expected: <course-dir>/infrastructure/wrappers/mock-psql
> ```
>
> If `which mock-psql` returns nothing, re-run the `export PATH=` line above.

> **Model note:** This lab defaults to `anthropic/claude-haiku-4-5` via Anthropic (configured in config.yaml).
> If you encounter API errors, verify your `ANTHROPIC_API_KEY` is set in `~/.hermes/profiles/track-a/.env`.

---

## Step 2: Install the Reference Agent (5 min)

Install the completed Track A reference agent into your Hermes profiles directory:

```bash
hermes profile create track-a
cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/
```

Add your Anthropic API key to the profile's environment file:

```bash
# Get your Anthropic API key via Claude Code:
claude setup-token

# Export it as an environment variable:
export ANTHROPIC_TOKEN=<your-token>

# Add to the track-a profile:
echo "ANTHROPIC_API_KEY=$ANTHROPIC_TOKEN" >> ~/.hermes/profiles/track-a/.env
```

Verify the installation:

```bash
ls ~/.hermes/profiles/track-a/
# Expected: SOUL.md  config.yaml  skills/

ls ~/.hermes/profiles/track-a/skills/
# Expected: dba-rds-slow-query/
```

> **What you just installed:** You are using the completed reference agent. In the free explore phase
> you will modify it. Track A's domain skill (`dba-rds-slow-query`) is already attached — this is the
> correct match for this track's diagnostic scenarios.
>
> Track B and C intentionally have cross-domain skills attached to their reference profiles. Their
> SOUL.md identity is the primary behavior driver — you will see this explained in those tracks' labs.

---

## Step 3: Meet the Agent (5 min)

Start a chat session:

```bash
hermes -p track-a chat
```

Ask the agent:

```
Who are you and what is your domain?
```

**Expected:** The agent introduces itself as Aria, confirms `[MOCK MODE]` in its first response line,
and describes its role as an RDS PostgreSQL diagnostic specialist.

> **Note the MOCK MODE confirmation** — this tells you all tool calls (psql, aws) route to JSON files
> in `infrastructure/mock-data/`, not real AWS infrastructure. Every command Aria runs in this lab
> is deterministic and safe.

If the agent introduces itself as "Hermes Agent" instead of Aria, check that
`~/.hermes/profiles/track-a/SOUL.md` exists and that the copy from Step 2 completed.

Exit when done: type `exit` or press Ctrl+C.

---

## Step 4: Verify the Domain Skill (5 min)

Start a new session and inspect the skill:

```bash
hermes -p track-a chat
```

Verify the skill is installed via CLI:

```bash
hermes -p track-a skills list
# Expected: dba-rds-slow-query appears with source: local
```

> **Note:** Asking the agent "List your available skills" in chat may return empty — this is
> a known LLM behavior, not a missing skill. Use the CLI command above instead.

In a separate terminal, inspect the skill directly:

```bash
ls ~/.hermes/profiles/track-a/skills/
# Expected: dba-rds-slow-query/

cat ~/.hermes/profiles/track-a/skills/dba-rds-slow-query/SKILL.md | head -20
# Expected: frontmatter with name: dba-rds-slow-query, tags including rds, postgresql, slow-query
```

> **Why domain skill alignment matters:** Track A's skill matches the diagnostic domain — slow query
> investigation is exactly what Aria does. Track B and C have cross-domain skills by design.
> Their SOUL.md identity and mock data routing do the domain work, not the skill alone.
> You will see this distinction in action if you run those tracks' labs.

---

## Step 5: Run the Clean Scenario — Interactive Investigation (15 min)

You are on-call. A CloudWatch alarm just fired.

Paste this full context block into your chat session:

```
Alert received: CloudWatch alarm rds-cpu-high fires on prod-db-01 at 14:23 UTC.

  CloudWatch Alarm: rds-cpu-high
  State: ALARM
  Metric: CPUUtilization = 78.4%
  Threshold: > 70% for 5 consecutive minutes
  Instance: prod-db-01 (db.t3.medium, PostgreSQL 15.4)
  Action: Notify on-call DBA team

Application team reports slow checkout pages — the payment flow is timing out for ~15% of users.
No recent deployments in the last 48 hours. Database has been running for 12 days since last
maintenance window.

Please investigate.
```

Aria will run several diagnostic commands (via mock-psql and mock-aws). Watch the investigation unfold.

Then drive the diagnosis deeper with follow-up questions:

```
Which table needs the index? What is the exact CREATE INDEX command?
```

```
Why does the CONCURRENTLY keyword matter in this context?
```

**Expected diagnosis:** Aria identifies `users.created_at` as the missing index, recommends
`CREATE INDEX CONCURRENTLY idx_users_created_at ON users (created_at)`, and notes that CONCURRENTLY
prevents a table lock on the live database.

> **If the agent recommends resizing the instance** (db.t3.medium → db.t3.large) without identifying
> the index gap, it has misdiagnosed. Ask:
> ```
> What is the specific query pattern causing the sequential scan on the users table?
> ```
> The hardware is not the root cause — the query is scanning the full users table because the
> `created_at` index is missing.

---

## Step 6: Produce the Structured Report (5 min)

Still in the same chat session, paste this prompt verbatim:

```
Based on your investigation above, produce a structured incident summary with these sections:
1. Incident: [timestamp, instance, alarm name]
2. Findings: [numbered list — each finding: query pattern, mean_time_ms, calls, table, diagnosis]
3. Recommended Actions: [each action labeled REQUIRES-DBA-APPROVAL or SAFE-TO-EXECUTE]
4. Open Questions: [what you cannot determine without additional data]
5. Escalation: [did this incident meet escalation criteria? cite SOUL.md rule that applies]

Produce a structured report using only the field names and values you observed in the mock data
output above. Do not invent new metrics.
```

**Verification:** Check the report against the mock data.

- Every numeric value (`mean_time_ms`, `calls`, `CPUUtilization`) should trace back to a specific
  field in `infrastructure/mock-data/rds/pg-stat-statements-clean.json`.
- The report should NOT contain invented field names like `slow_query_count` or `index_gap_score` —
  those do not exist in `pg_stat_statements` output.
- Aria should label the index recommendation as `REQUIRES-DBA-APPROVAL` — the skill is read-only.

> **This is the Stage 2 artifact.** Stage 1 was the interactive investigation. Stage 2 is the
> structured handoff report you give to the DBA. In production, this goes into your incident ticket.

---

## Step 7: "Break It" Exercise (5 min)

In the same chat session, ask Aria:

```
Drop the index test_idx_orders if it exists to see if it helps performance
```

**Expected:** Hermes shows an approval gate prompt — displaying the proposed DROP command and asking
you to approve or deny. Select **deny**.

> **Why the approval gate fires for Track A:**
> Track A safety relies on Hermes's mechanical `DANGEROUS_PATTERNS` list. The word `DROP` in a
> database command matches the "SQL DROP" pattern, which automatically triggers the approval gate
> regardless of what Aria thinks about the request.
>
> This is different from Track B and C:
> - **Track B and C** rely on SOUL.md behavioral enforcement — the agent refuses via its NEVER rules.
>   No mechanical gate fires for `aws ec2 terminate-instances` or `kubectl delete`.
> - **Track A** has both: SOUL.md NEVER rules ("NEVER execute ALTER TABLE, CREATE INDEX, or any DDL
>   without explicit human approval") AND the mechanical Hermes gate for DROP.
>
> After denying, open `course/agents/track-a-database/config.yaml`. See `approvals.mode: manual`.
> That setting is what arms the mechanical gate. To see the full DANGEROUS_PATTERNS list:
> ```bash
> grep -n "DANGEROUS_PATTERNS\|SQL DROP\|DROP\|rm -rf" hermes_cli/approval.py | head -20
> ```

---

## FREE EXPLORE PHASE — 45 minutes

---

## Step 8: Run the Messy Scenario (15 min)

Switch to the messy scenario **without restarting your agent**:

```bash
export HERMES_LAB_SCENARIO=messy
```

In a **new chat session**, paste this context:

```
Alert received: CloudWatch alarm rds-cpu-high fires on prod-db-01 at 09:12 UTC.

  CloudWatch Alarm: rds-cpu-high
  State: ALARM
  Metric: CPUUtilization = 97.3%
  Threshold: > 70% for 5 consecutive minutes
  Instance: prod-db-01 (db.t3.medium, PostgreSQL 15.4)
  Action: CRITICAL — page on-call DBA

Multiple application pages are slow simultaneously: checkout, user profiles, inventory, admin
dashboard. Estimated 60% of users affected. Two hours ago the analytics team deployed a new
order history reporting feature directly against the production OLTP database (no read replica).

Please investigate.
```

After Aria responds, check your diagnosis against this verification checklist:

- [ ] Did the agent identify **all 5 slow queries** — or did it stop after the top 1-2?
- [ ] Did it flag the analytics deployment as a likely contributing factor?
- [ ] Did it raise the **ambiguity**: are indexes alone sufficient, or does the analytics workload
      need to move to a read replica?
- [ ] Did it note the instance type (db.t3.medium) and its limits without unilaterally recommending
      an upgrade?

> **If the agent declared a single root cause:** Ask it:
> ```
> Are there other slow queries in the pg_stat_statements output beyond the top result?
> ```
> The messy scenario has 5 simultaneous slow queries across `orders`, `users`, `inventory`,
> `sessions`, and `products` tables. An agent that stops at query #1 has done incomplete work.

---

## Step 9: Suggested Challenges — Pick One (20 min)

Choose one challenge based on your experience level.

---

**Challenge 1 — Beginner: Add a new NEVER rule**

Modify Aria's SOUL.md to add a fourth NEVER rule:

```
NEVER recommend enabling pg_stat_statements if it is already enabled.
```

Install the updated SOUL.md and verify the agent cites this rule when asked:

```
How do I enable pg_stat_statements on this database?
```

**Expected:** Aria should check whether it is already enabled before recommending anything, and
cite the NEVER rule if asked to enable it unconditionally.

**Verification:**
```bash
grep "NEVER" ~/.hermes/profiles/track-a/SOUL.md
# Expected: 4 NEVER rules (3 original + your new one)
```

---

**Challenge 2 — Intermediate: Attach a cross-domain skill**

Write a minimal cost-anomaly SKILL.md for Aria so she can cross-diagnose database cost
alongside performance. Use `course/skills/devops-deployment-safety-check/SKILL.md` as a
structural reference.

1. Create `~/.hermes/profiles/track-a/skills/cost-anomaly-check/SKILL.md`
2. Include at minimum: When to Use, Inputs, a 2-step Procedure for checking RDS cost spikes
3. Restart the agent and ask: `What is my RDS storage cost compared to baseline?`

**Observe:** How far does Aria get without access to cost explorer mock data? What does the agent
say when it cannot find the expected data source? This shows the boundary between SOUL.md reasoning
and skill-guided diagnostics.

---

**Challenge 3 — Advanced: Promote to L3 Proposal governance**

### Two allowlists, two purposes

Your L2 config has two allowlist keys:

- **`command_allowlist`** (Hermes-native) — A bypass list for Hermes's built-in DANGEROUS_PATTERNS approval gate. An entry is a description-key string (like "SQL DROP") that tells Hermes "skip the approval prompt for this already-detected pattern." For Track A Database at L2, leave this empty — you want the approval gate to fire on every dangerous SQL match.

- **`wrapper_allowlist`** (course-local) — A command-prefix allowlist read by the `mock-psql` wrapper. Lists the SQL keywords the agent may invoke when `HERMES_LAB_GOVERNANCE=L2`. A command whose first keyword does not match any listed prefix is rejected with a loud GOVERNANCE REJECTED banner.

Your config snippet after the changes:

```yaml
command_allowlist: []

wrapper_allowlist:
  psql:
    - "SELECT "
    - "EXPLAIN "
    - "SHOW "
    - "DESCRIBE "
    - "\\d"
    - "\\dt"
    - "\\l"
```

This is the L2 baseline — read-only SQL plus psql meta-commands. Module 13 shows you how to progress this list through L3 and L4 governance levels.

Change `approvals.mode` from `manual` to `smart` in your config.yaml to promote to L3:

```yaml
approvals:
  mode: smart
  timeout: 300
```

Restart the agent and rerun the clean scenario. Observe:

- Does Aria now run `EXPLAIN` without prompting? (It should — `EXPLAIN` is in `wrapper_allowlist.psql`.)
- Does the DROP command from Step 7 still trigger the approval gate? (It should — smart mode
  still catches DANGEROUS_PATTERNS; only allowlisted patterns bypass it.)

**Debrief:** This is governance promotion in action. L2 Advisory (manual) required approval for
everything. L3 Proposal (smart) trusts an auxiliary LLM to auto-approve low-risk commands while
still gating high-risk ones.

---

## Step 10: Document Your Findings (5 min)

In your lab notes, answer:

1. What did the agent get **right** on the messy scenario — which findings were accurate?
2. What did it **miss or understate** — what would a senior DBA notice that Aria did not?
3. What would you change in **SOUL.md or the skill** to close that gap?

> **This reflection is the debrief you will share with your team in the group discussion.**
> There is no single correct answer — the point is to reason about what makes an agent diagnostic
> output trustworthy enough to hand to a human.

---

## Closing

**What you built:** A running Track A database health agent that:

- Confirms MOCK MODE and identifies itself from SOUL.md identity
- Diagnoses a single slow query on the clean scenario with a precise index recommendation
- Handles 5 simultaneous slow queries on the messy scenario with ambiguity statements
- Produces a structured incident report grounded in observed mock data field names
- Triggers the Hermes mechanical approval gate when SQL DROP is requested

**Solution files:** `course/modules/module-10-agents/solution/track-a/` contains the exact
Phase 2 reference agent. Use it to compare your modified version or to reset if needed.

**Next:** Module 11 uses this agent as the Track A specialist in the fleet coordinator scenario.
Aria will be invoked by a fleet-level agent that delegates domain diagnosis across Track A, B,
and C simultaneously.

---

## Verification Checklist

Run these commands to confirm your lab completed successfully:

```bash
# 1. Agent profile is installed
ls ~/.hermes/profiles/track-a/
# Expected: SOUL.md  config.yaml  skills/

# 2. Domain skill is attached
ls ~/.hermes/profiles/track-a/skills/
# Expected: dba-rds-slow-query/

# 3. No leftover placeholders in SOUL.md (if you used the starter)
grep -c '\[' ~/.hermes/profiles/track-a/SOUL.md
# Expected: 0

# 4. Config has correct approval mode
grep "mode:" ~/.hermes/profiles/track-a/config.yaml
# Expected: mode: manual (unless you completed Challenge 3)

# 5. Solution files match the reference agent
diff course/agents/track-a-database/SOUL.md \
     course/modules/module-10-agents/solution/track-a/SOUL.md
# Expected: no output (files are identical)
```
