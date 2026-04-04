# Module 13 Lab: Governance — Approval Workflows, Maturity Levels, and Audit Trails

**Duration:** 90 minutes (60 min guided + 30 min free explore)
**Track:** A, B, or C — works for all tracks (steps show Track A examples with Track B/C callouts)
**Prerequisite:** Module 10 track agent installed and working (`~/.hermes/profiles/track-a/` exists)
**Outcome:** Track agent configured at L3 governance, approval behavior observable in action, session audit trail readable via sqlite3

> Governance is not about trust — it's about observability and control surfaces. L1 through L4 is a
> spectrum from "human does everything" to "agent does routine work autonomously." Today you walk from
> L1 to L3 and see exactly what each level changes. The diff between levels IS the governance decision.

---

## GUIDED PHASE — 60 minutes

---

## Step 1: Prerequisites (5 min)

Verify your Module 10 track agent is still working:

```bash
hermes -p track-a chat
```

Ask:

```
What is your name and what domain do you cover?
```

**Expected:** Agent introduces itself by name (Aria for Track A, Finley for Track B, Kepler for Track C)
and confirms its domain.

Exit when done: type `exit` or press Ctrl+C.

Note your profile path:

```bash
# Track A
ls ~/.hermes/profiles/track-a/config.yaml

# Track B
ls ~/.hermes/profiles/track-b/config.yaml

# Track C
ls ~/.hermes/profiles/track-c/config.yaml
```

> **Before you proceed:** make a backup of your working config so you can restore it in Step 10.
>
> ```bash
> cp ~/.hermes/profiles/track-a/config.yaml ~/.hermes/profiles/track-a/config.yaml.backup
> ```

---

## Step 2: View All Governance Levels (5 min)

From your course directory, list the governance YAML fragments:

```bash
ls course/governance/
```

**Expected output:**

```
governance-L1.yaml
governance-L2.yaml
governance-L3.yaml
governance-L4-track-a.yaml
governance-L4-track-b.yaml
governance-L4-track-c.yaml
```

Read L1:

```bash
cat course/governance/governance-L1.yaml
```

Notice the structure: three keys control everything:

- `platform_toolsets.cli` — which tool categories the agent can access
- `approvals.mode` — how flagged commands are handled (`manual`, `smart`, `off`)
- `command_allowlist` — patterns permanently pre-approved (bypasses the gate entirely)

> **Teaching callout:** Notice what L1 does NOT have: the terminal toolset. The agent can read web
> pages and use skills but cannot run any commands. L1 is the read-only, advisory mode — the agent
> proposes; a human executes. This is appropriate for untrusted or newly-deployed agents.

---

## Step 3: Apply L1 — No Terminal (10 min)

Open your profile's config.yaml for editing:

```bash
# On macOS
open -e ~/.hermes/profiles/track-a/config.yaml

# Or any editor
nano ~/.hermes/profiles/track-a/config.yaml
```

In the config.yaml, add or update the `platform_toolsets` and `approvals` keys to match L1:

```yaml
# Copy from governance-L1.yaml
platform_toolsets:
  cli: [web, skills]      # No terminal: agent cannot execute commands

approvals:
  mode: manual
  timeout: 300

command_allowlist: []
```

Save the file. Then start a chat session:

```bash
hermes -p track-a chat
```

Ask a diagnostic question that requires a CLI command — for example:

```
Check the current RDS slow query count and show me the top queries
```

**Expected:** The agent cannot run any commands. It will respond with something like:
- "I don't have access to a terminal to run commands directly..."
- "Based on my knowledge, here is what you would need to run..."
- Or it will propose the commands as text without executing them.

> **This failure is intentional. The L1 failure is the teaching moment.**
>
> L1 is the appropriate starting point for any newly-deployed or untrusted agent:
> - Zero risk of accidental command execution
> - All proposed actions are explicit proposals for human review
> - The agent still has full reasoning capability — it just cannot execute
>
> When you promote an agent from L1 to L2, you are making a governance decision:
> "I have reviewed this agent's behavior and I trust it to run diagnostic commands."

Exit the session: type `exit`

---

## Step 4: Diff L1 to L2 — Terminal Added (5 min)

From your course directory:

```bash
diff course/governance/governance-L1.yaml course/governance/governance-L2.yaml
```

**Expected output:**

```diff
< platform_toolsets:
<   cli: [web, skills]      # No terminal: agent cannot execute commands
---
> platform_toolsets:
>   cli: [terminal, file, web, skills]   # Terminal enabled: agent can run commands
```

Only one key changed: `platform_toolsets.cli` gains `terminal` and `file`.

> **Teaching point:** One line change — one profound capability shift. Terminal access is the gate
> to everything diagnostic. With `terminal` in the toolset, the agent can run `psql`, `aws`, `kubectl`,
> shell scripts, and any command available in the environment.
>
> Both levels have `approvals.mode: manual`. The difference is that at L1, the agent never reaches
> the approval gate because it cannot form a terminal command in the first place. At L2, it can form
> the command — and if that command matches `DANGEROUS_PATTERNS`, the gate fires.

---

## Step 5: Apply L2 — Manual Approval Gate (10 min)

Update your config.yaml to match L2:

```yaml
# Copy from governance-L2.yaml
platform_toolsets:
  cli: [terminal, file, web, skills]   # Terminal enabled: agent can run commands

approvals:
  mode: manual
  timeout: 300

command_allowlist: []
```

Save the file. Start a chat session:

```bash
hermes -p track-a chat
```

Ask a diagnostic question that will trigger a database command:

```
Check RDS slow queries on prod-db-01
```

The agent will run diagnostic commands. Eventually it will try to run a command that matches
Hermes's `DANGEROUS_PATTERNS` list. When that happens, the CLI will **pause** and show:

```
  WARNING  DANGEROUS COMMAND: SQL DROP
      DROP TABLE ...

      [o]nce  |  [s]ession  |  [a]lways  |  [d]eny

      Choice [o/s/a/D]:
```

Type `d` and press Enter to deny.

> **What is DANGEROUS_PATTERNS?**
>
> Hermes maintains a hardcoded list of command patterns that can cause data loss, system damage,
> or irreversible changes. When a terminal command matches any of these patterns, the approval gate
> fires regardless of the agent's intentions.
>
> Here are the key patterns that each track is likely to encounter:

**DANGEROUS_PATTERNS Reference (partial — from `tools/approval.py`)**

| Pattern | Description | Track Most Likely to Encounter |
|---------|-------------|-------------------------------|
| `DROP TABLE` or `DROP DATABASE` | SQL DROP | Track A (Database) |
| `DELETE FROM` without `WHERE` | SQL DELETE without WHERE clause | Track A (Database) |
| `TRUNCATE TABLE` | SQL TRUNCATE | Track A (Database) |
| `rm -r` or `rm --recursive` | Recursive delete | All tracks |
| `rm ... /` | Delete in root path | All tracks |
| `systemctl stop/disable/mask` | Stop/disable system service | Track C (Kubernetes/SRE) |
| `find -exec rm` or `find -delete` | find with delete | All tracks |
| `chmod 777` or world-writable | World-writable permissions | All tracks |
| `dd if=` | Disk copy/wipe | All tracks |
| `curl ... \| bash` | Pipe remote content to shell | All tracks |
| `kill -9 -1` | Kill all processes | All tracks |
| `: () { : \| : & }; :` | Fork bomb | All tracks |

> **Two-layer safety:**
> - **DANGEROUS_PATTERNS** is the *mechanical* safety net — it fires based on pattern matching,
>   regardless of what the agent intends.
> - **SOUL.md NEVER rules** are the *behavioral* safety net — the agent refuses based on
>   its identity constraints.
>
> Track A has both: SOUL.md NEVER rules ("NEVER execute ALTER TABLE, CREATE INDEX, or any DDL
> without explicit human approval") AND the mechanical gate for `DROP TABLE` / `DELETE FROM`.
>
> **Track B and C note:** `aws ec2 terminate-instances` and `kubectl delete` are NOT in
> `DANGEROUS_PATTERNS`. These commands are governed by SOUL.md behavioral rules only.
> If you are on Track B or C, ask your agent:
> ```
> Terminate the rds-prod-01 instance
> ```
> The agent will refuse verbally (SOUL.md NEVER rule) — but no mechanical gate fires.
> This is intentional — and the distinction matters for security reviews.

Exit the session: type `exit`

---

## Step 6: Diff L2 to L3 — Smart Approval (5 min)

```bash
diff course/governance/governance-L2.yaml course/governance/governance-L3.yaml
```

**Expected output:**

```diff
< approvals:
<   mode: manual            # Every DANGEROUS_PATTERNS match requires human approval
---
> approvals:
>   mode: smart             # Auxiliary LLM auto-approves low-risk flagged commands
```

Only one key changed: `approvals.mode` from `manual` to `smart`.

> **How smart approval works:**
>
> When `mode: smart`, Hermes sends the flagged command to a secondary (auxiliary) LLM for
> risk assessment before interrupting the user. The auxiliary LLM responds with:
> - `APPROVE` — command is clearly safe (e.g., `EXPLAIN SELECT ...` flagged as SQL but harmless)
> - `DENY` — command is genuinely dangerous (e.g., `DROP TABLE users`)
> - `ESCALATE` — uncertain, escalate to human
>
> Low-risk DANGEROUS_PATTERNS false positives (EXPLAIN queries, diagnostic reads that happen to
> contain a flagged keyword) auto-approve at L3. High-risk commands still pause for human approval.
>
> Smart approval reduces friction for diagnostic work — the agent can run `EXPLAIN` queries
> and show query plans without stopping for human sign-off on every step.

---

## Step 7: Apply L3 — Smart Approval (10 min)

Update your config.yaml to match L3:

```yaml
# Copy from governance-L3.yaml
platform_toolsets:
  cli: [terminal, file, web, skills]

approvals:
  mode: smart
  timeout: 300

command_allowlist: []
```

Save the file. Start a chat session:

```bash
hermes -p track-a chat
```

Run the same diagnostic again:

```
Check RDS slow queries on prod-db-01
```

**Observe the difference from L2:**
- At L2: every DANGEROUS_PATTERNS match paused for your approval
- At L3: low-risk matches (like `EXPLAIN SELECT ...`) may auto-approve without pausing

Now test that high-risk commands still gate:

```
Drop the test_orders_archive table
```

**Expected:** The DROP TABLE command matches `DANGEROUS_PATTERNS`. At L3, the auxiliary LLM will
assess it. Because `DROP TABLE` is genuinely dangerous, the auxiliary LLM will respond `DENY` or
`ESCALATE` — and the gate will still fire, asking for your approval.

Type `d` to deny.

> **Teaching callout:**
> Smart approval does not remove the gate for genuinely dangerous commands. It removes the gate
> for false positives — commands that match a pattern but are actually harmless in context.
>
> The security contract at L3: "Routine diagnostics run without interruption. Novel or destructive
> actions still require human review."
>
> This is why L3 is called "Proposal" mode in the governance spectrum. The agent can autonomously
> execute read operations and propose — but not unilaterally execute — mutations.

Exit the session: type `exit`

---

## Step 8: Read Your Session Audit Trail (10 min)

Every command the agent attempts — and every approval decision — is recorded in the Hermes
session database. This is the audit trail a security review would ask to see.

**Find the session database:**

```bash
ls ~/.hermes/state.db
# Expected: ~/.hermes/state.db
```

**Inspect recent sessions:**

```bash
hermes sessions list
```

Note the session ID from your most recent session (e.g., `a1b2c3d4`).

**Query the audit trail with sqlite3:**

Open the database:

```bash
sqlite3 ~/.hermes/state.db
```

Inside sqlite3, run these queries:

```sql
-- List recent sessions
SELECT id, datetime(started_at, 'unixepoch', 'localtime') as started, title
FROM sessions
ORDER BY started_at DESC
LIMIT 5;
```

```sql
-- Show all terminal tool calls in the most recent session
-- (replace SESSION_ID with the ID from hermes sessions list)
SELECT
    datetime(timestamp, 'unixepoch', 'localtime') as time,
    role,
    tool_name,
    substr(content, 1, 200) as content_preview
FROM messages
WHERE session_id = 'SESSION_ID'
  AND (tool_name = 'terminal' OR role = 'tool')
ORDER BY timestamp ASC;
```

```sql
-- Search for approval-related messages across all recent sessions
SELECT
    datetime(m.timestamp, 'unixepoch', 'localtime') as time,
    s.id as session_id,
    m.role,
    substr(m.content, 1, 300) as content_preview
FROM messages m
JOIN sessions s ON s.id = m.session_id
WHERE m.content LIKE '%DANGEROUS%'
   OR m.content LIKE '%BLOCKED%'
   OR m.content LIKE '%approval%'
ORDER BY m.timestamp DESC
LIMIT 20;
```

Exit sqlite3:

```sql
.quit
```

> **What you just read:**
>
> The `messages` table is the complete record of everything the agent attempted.
> Tool-role messages with `tool_name = 'terminal'` show every terminal command the agent ran.
> Messages containing "BLOCKED" or "DANGEROUS" show approval gate events.
>
> This is what a security review asks to see: "Show me every command your agent ran last week
> and what the approval outcome was." The answer is in `~/.hermes/state.db`.
>
> **Alternative — export a session to JSON for analysis:**
> ```bash
> # View a session's full message log as formatted JSON
> sqlite3 ~/.hermes/state.db \
>   "SELECT json_object('role', role, 'tool_name', tool_name, 'content', content, \
>    'timestamp', datetime(timestamp, 'unixepoch', 'localtime')) \
>    FROM messages WHERE session_id = 'SESSION_ID' ORDER BY timestamp" \
>   | python3 -m json.tool
> ```
>
> If you have `jq` installed (install: `brew install jq` on macOS or `apt install jq` on Linux),
> you can also pipe the output through `jq` for more filtering options:
> ```bash
> sqlite3 -json ~/.hermes/state.db \
>   "SELECT role, tool_name, content, datetime(timestamp, 'unixepoch', 'localtime') as ts \
>    FROM messages WHERE session_id = 'SESSION_ID' ORDER BY timestamp" \
>   | jq '.[] | select(.tool_name == "terminal")'
> ```

---

## Step 9: Review DANGEROUS_PATTERNS (5 min)

The full `DANGEROUS_PATTERNS` list is the mechanical safety contract for your agent.
Review it directly from the source:

```bash
grep -A1 "DANGEROUS_PATTERNS = \[" tools/approval.py
# Or view the full list:
grep '(r"\\b' tools/approval.py | head -30
```

> **For your track — which patterns are you most likely to trigger?**
>
> - **Track A (Database):** `DROP TABLE`, `DELETE FROM` without `WHERE`, `TRUNCATE TABLE`,
>   and any variation of these in SQL queries. Your agent's slow-query diagnosis may EXPLAIN
>   dangerous-looking queries — smart approval handles these false positives.
>
> - **Track B (FinOps):** The dangerous AWS commands (`aws ec2 terminate-instances`,
>   `modify-instance-attribute`) are NOT in `DANGEROUS_PATTERNS`. Your protection is
>   behavioral via SOUL.md NEVER rules. The patterns you might hit: `rm -r` if the agent
>   tries to clean up cost report files, or `bash -c` script execution patterns.
>
> - **Track C (Kubernetes/SRE):** `kubectl delete`, `kubectl drain`, `kubectl cordon` are NOT
>   in `DANGEROUS_PATTERNS`. Your protection is behavioral via SOUL.md. The patterns you might
>   hit: `systemctl stop/disable` for service management, `rm -r` for log cleanup,
>   `kill -9 -1` for runaway process diagnosis.
>
> **Both layers always apply:**
> DANGEROUS_PATTERNS is the mechanical gate. SOUL.md NEVER rules are the behavioral gate.
> Neither replaces the other. At L3, the mechanical gate is smart — but SOUL.md NEVER rules
> still refuse genuinely dangerous requests at the reasoning level before a terminal command
> is even formed.

---

## Step 10: Restore Agent to Working Config (5 min)

Restore your profile to a clean working state. Use either your backup or the L3 config
(L3 is also fully functional — it is the recommended governance level for active lab work):

**Option A: Restore from backup (returns to Module 10 state):**

```bash
cp ~/.hermes/profiles/track-a/config.yaml.backup ~/.hermes/profiles/track-a/config.yaml
```

**Option B: Keep L3 governance (recommended — it is a working governance level):**

The L3 config you applied in Step 7 is already a valid production config. No changes needed.

**Verify the agent still works:**

```bash
hermes -p track-a chat
```

Ask:

```
What is your name and what domain do you cover?
```

**Expected:** Agent responds with its identity, no errors.

Exit: type `exit`

> **Teaching callout:** Governance configs are reversible. You can promote and demote your agent
> by swapping config keys. There is no destructive migration — L1, L2, L3, L4 are just keys in
> a YAML file. The agent's SOUL.md identity, skills, and memory are unchanged by governance level.
>
> This is intentional design: governance controls what the agent CAN DO; identity (SOUL.md)
> controls who the agent IS. Changing governance level does not change the agent's values.

---

## FREE EXPLORE PHASE — 30 minutes

---

## Step 11: Challenge 1 — Write Promotion Criteria (Starter, 10 min)

Using the L2 to L3 diff as a model, write a one-paragraph promotion criteria for your track agent.
Paste it into a `promotion-criteria.md` file in your profile directory:

```bash
nano ~/.hermes/profiles/track-a/promotion-criteria.md
```

Template to fill in:

```
My track-a agent should be promoted from L2 (manual approval) to L3 (smart approval) when:

Observable conditions:
- [ ] [metric 1 — e.g., "100 consecutive sessions with 0 BLOCKED commands"]
- [ ] [metric 2 — e.g., "0 DANGEROUS_PATTERNS matches in queries that resulted in data loss"]
- [ ] [metric 3 — e.g., "Smart approval auto-approved >= 90% of EXPLAIN queries over 30 days"]

Review process:
- [who reviews? what evidence do they examine?]

Demotion trigger:
- [what condition forces demotion back to L2?]
```

> **Why promotion criteria matter:** Governance without promotion criteria is governance that
> never advances. The criteria you write here are the observable conditions that justify trusting
> the agent with more autonomy. They should be specific, measurable, and tied to real audit data
> from the `state.db` queries you practiced in Step 8.

---

## Step 12: Challenge 2 — Add a Command to command_allowlist (Intermediate, 15 min)

At L3, the `command_allowlist` lets you permanently pre-approve specific pattern-description
strings. A command that matches an allowlisted pattern skips the approval gate entirely.

Try adding a safe pattern to the allowlist.

First, check what description strings are available. The allowlist uses the `description` field
from `DANGEROUS_PATTERNS` — the human-readable string (not the regex):

```bash
# View all description strings in DANGEROUS_PATTERNS
grep '",' tools/approval.py | grep -v "^#" | grep -v "import\|logger\|class\|def " | head -30
```

For Track A, try pre-approving the `SQL DROP` description — but first think about whether
this is appropriate.

Add to your config.yaml:

```yaml
command_allowlist: ["SQL DROP"]
```

Start a session and run the test again:

```bash
hermes -p track-a chat
```

```
Drop the test_archive_table_2019 if it exists
```

**Observe:** Does the DROP command now skip the approval gate?

**Security review question:** A security auditor asks: "Why is SQL DROP in your allowlist?"
What is your answer? What conditions would make this acceptable in a real environment?

> **Restore the allowlist to empty after this exercise:**
> ```yaml
> command_allowlist: []
> ```
> Pre-approving `SQL DROP` is appropriate only when you have verified that the agent's SOUL.md
> NEVER rules prevent destructive use — and even then, only for specific named tables, not
> the entire DROP pattern. This challenge shows the mechanism; production use requires
> more granular control.

---

## Step 13: Challenge 3 — Compare Track A vs Track B L4 Governance (Advanced, 20 min)

Read both L4 configs:

```bash
cat course/governance/governance-L4-track-a.yaml
cat course/governance/governance-L4-track-b.yaml
```

Diff them:

```bash
diff course/governance/governance-L4-track-a.yaml course/governance/governance-L4-track-b.yaml
```

Notice that the YAML keys are nearly identical — but the comments explain a critical difference
in the enforcement model.

**Questions to answer in your lab notes:**

1. At L4, what is different about the risk profile for Track A (Database) vs Track B (FinOps)?

2. Track B's most dangerous commands (`aws ec2 terminate-instances`) are not in
   `DANGEROUS_PATTERNS`. At L4, the `command_allowlist` cannot protect against them.
   What IS the protection mechanism, and is it sufficient for L4 autonomy?

3. If you were writing a security review for a Track B agent at L4, what evidence would you
   need to see in the audit trail (from `state.db`) before signing off on L4 promotion?

4. Write a one-paragraph justification for why Track B (FinOps) and Track A (Database) have
   different L4 governance configurations even though the YAML looks the same.

> **Hint:** The difference is not in the YAML — it is in the threat model. Database mutations
> (DROP, TRUNCATE) are in `DANGEROUS_PATTERNS` and can be mechanically gated. Cloud resource
> mutations (terminate-instances) are behavioral, governed only by SOUL.md NEVER rules.
> L4 governance for Track B requires higher confidence in behavioral alignment, not just
> mechanical gate configuration.

---

## Closing

**What you observed:**

- L1: Agent cannot run commands — the no-terminal configuration is the teaching moment
- L2: Terminal enabled, every DANGEROUS_PATTERNS match pauses for human approval
- L3: Smart approval reduces friction for false positives; genuinely dangerous commands still gate
- Audit trail: Every session is recorded in `~/.hermes/state.db` — queryable with sqlite3
- DANGEROUS_PATTERNS is the mechanical safety net; SOUL.md NEVER rules are the behavioral net
- Both layers exist simultaneously; neither replaces the other

**The governance spectrum in one sentence:**

> L1 proposes, L2 pauses, L3 filters, L4 trusts — and the audit trail observes everything.

**Next:** Module 14 capstone. You will present your track agent with its current governance
configuration, show one promotion criteria you wrote in this lab, and demonstrate the approval
gate behavior to your team.

---

## Verification Checklist

Run these commands to confirm your lab completed successfully:

```bash
# 1. Governance YAML fragments are in place
ls course/governance/
# Expected: 6 files (governance-L1.yaml through governance-L4-track-c.yaml)

# 2. Profile config is at a known governance level (L3 recommended)
grep "mode:" ~/.hermes/profiles/track-a/config.yaml
# Expected: mode: smart (L3) or mode: manual (L2) — not missing

# 3. Terminal toolset is present (L2 or above)
grep "terminal" ~/.hermes/profiles/track-a/config.yaml
# Expected: terminal appears in platform_toolsets.cli

# 4. Agent still works
hermes -p track-a chat
# Type: What is your name? — Expected: named identity response

# 5. Session database exists with at least one session from today
sqlite3 ~/.hermes/state.db \
  "SELECT count(*) FROM sessions WHERE started_at > strftime('%s', 'now', '-1 day');"
# Expected: a number > 0

# 6. Diff commands work (course governance directory is present)
diff course/governance/governance-L1.yaml course/governance/governance-L2.yaml | wc -l
# Expected: a non-zero number (lines of diff output)
```
