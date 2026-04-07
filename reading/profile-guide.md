# Profile-Based Agent Definition: SOUL.md as Identity, config.yaml as Capabilities

**Type:** Reference Document
**Audience:** DevOps practitioners building Hermes agents for the first time
**Companion:** Module 8 Lab (hands-on profile construction from SOUL-TEMPLATE.md)
**This doc explains WHY — the lab shows HOW**

---

## Overview

In Hermes, an agent IS its profile. There is no Python code to write. No class to subclass. No framework-specific agent API to learn. A profile is a directory with two files — `SOUL.md` (who the agent is) and `config.yaml` (what it can do) — and that directory is the complete definition of the agent.

This is the fundamental shift the course teaches: from "agents as code" to "agents as configuration." The LLM provides reasoning. The profile provides identity, constraints, and capabilities. You get a specialized DevOps agent by writing YAML and Markdown, not Python.

This reference covers:

- What a profile is and the "profile = agent definition" insight
- SOUL.md anatomy: identity, behavior rules, escalation policy
- config.yaml anatomy: model, toolsets, delegation, approvals
- The skills/ subdirectory and how domain knowledge is loaded
- How Hermes discovers and instantiates profiles at runtime
- The fleet coordinator pattern: delegation without execution
- SOUL-TEMPLATE.md and the placeholder completeness check
- Course examples with specific file paths and comparison tables

Read this document before or after Module 8. It is the conceptual map. The lab is the territory.

---

## Section 1 — What Is a Profile and Why Does It Define an Agent?

### The Profile = Agent Definition Insight

Before diving into file formats, it is worth understanding why this design is surprising — and why it works.

Traditional software agents are code. You write a Python class that inherits from an agent framework, implements methods, registers tools, and handles the agent loop. The agent's behavior is spread across class methods, tool implementations, system prompt strings scattered through the code, and configuration files.

In Hermes, the agent behavior is concentrated in two files in a directory:

```
~/.hermes/profiles/track-a/
├── SOUL.md          # Identity: who the agent is, what it NEVER does
├── config.yaml      # Capabilities: tools, model, governance
└── skills/          # Domain knowledge: SKILL.md runbooks
    ├── db-health-check.md
    └── slow-query-analysis.md
```

The Hermes runtime provides the agent loop, tool execution, context management, and LLM integration. The profile provides the agent-specific layer on top of that generic infrastructure.

This separation means:

1. **No Python required for participants:** DevOps practitioners can build production-grade agents without writing application code. The course constraint "no Python coding for participants" is satisfied by design.
2. **Profiles are readable by non-engineers:** A SOUL.md is plain English. An operations manager can read it and understand what the agent will and won't do. A config.yaml is YAML. A sysadmin can audit it.
3. **Profiles are version-controllable artifacts:** SOUL.md and config.yaml go in git. Drift detection is `git diff`. Rollback is `git checkout`.
4. **Profile-based agents transfer across environments:** Run `hermes profile create track-a`, copy `config.yaml`, `SOUL.md`, and the skills directory into `~/.hermes/profiles/track-a/`, then run immediately. No build step, no environment-specific compilation.

The profile IS the agent definition. This is not a simplification for the course — it is the design principle that makes Hermes profiles different from most agent frameworks.

### The Two Core Files

Every Hermes profile requires exactly two files:

**`SOUL.md`** — The agent's identity layer. Loaded once at startup and injected as system context for every conversation turn. The LLM reads SOUL.md and internalizes it as "who I am." It is not a per-request instruction; it is a persistent identity layer that shapes every response.

**`config.yaml`** — The agent's capability configuration. Determines which tools are available, which LLM to use, what governance constraints apply, and (for coordinators) how delegation works.

The skills/ subdirectory is optional — a profile without skills/ has no domain knowledge loaded at startup, relying entirely on the LLM's general knowledge. For DevOps specialists, skills/ is where the domain runbooks live.

---

## Section 2 — SOUL.md Anatomy

### What SOUL.md Is

SOUL.md is the agent's job description, written in first person, that the agent internalizes on every session startup. Think of it as the document that answers: "Who is this agent and what are its non-negotiable operating principles?"

SOUL.md has three required sections:

```markdown
# Agent Name — Role Title

**Role:** One-line role description
**Domain:** Track A: Database | Track B: FinOps | Track C: Kubernetes | Fleet Coordinator
**Scope:** What this agent is responsible for — and what it explicitly is NOT responsible for

## Identity

## Behavior Rules

## Escalation Policy
```

### The Header Block

The header (before any section heading) is metadata, not prose. Four lines that establish the agent's identity at a glance:

- **Name:** The agent's name. Aria, Finley, Kiran, Morgan in the course. Name matters — the LLM uses it when referring to itself.
- **Role:** One sentence. "RDS PostgreSQL health and tuning specialist." Specific enough to shape behavior; broad enough to handle edge cases.
- **Domain:** Which track. The domain line helps the agent self-locate within the fleet.
- **Scope:** What the agent IS responsible for AND what it explicitly IS NOT. The scope exclusion is as important as the inclusion. "Parameter changes route through DBA approval workflow" tells the agent what it cannot do unilaterally.

### The Identity Section

Two to three sentences in first person. The template pattern:

```
You are [Name], a [role] agent for [team/org].
You [what you do + how you do it].
You [what you never do + why not].
```

The Identity section is not a general AI assistant description. It is a domain-specific statement that overrides the LLM's default helpful-assistant behavior. An identity that says "You are Aria, a database reliability agent who diagnoses performance problems and recommends fixes but never executes changes" will refuse DDL execution even when a user explicitly asks, because the identity makes refusal consistent with self-concept.

Compare the Track A and Fleet Coordinator identities:

**Aria (Track A, domain specialist):**
> You are Aria, a database reliability agent for DevOps teams running PostgreSQL on AWS RDS. You diagnose performance problems — slow queries, index gaps, parameter drift — and recommend precise fixes. You do not execute changes; you surface findings and propose remediation steps for human approval. Every diagnosis ties an observation to a specific metric or query pattern.

**Morgan (Fleet Coordinator):**
> You are Morgan, a fleet coordination agent for cross-domain DevOps incidents. When an incident involves multiple domains (database, cost, Kubernetes), you decompose it into domain-specific tasks and delegate each to the appropriate specialist. You synthesize their findings into a single incident summary. You never run database queries, AWS CLI commands, or kubectl directly — specialists do that work.

Both are three sentences. Both establish what the agent does and does not do. The specialist identity focuses on domain depth. The coordinator identity focuses on delegation scope.

### The Behavior Rules Section

A bulleted list of imperative directives. Two categories:

**Positive rules** (what to always do, how to do it, reporting format):

- `Run EXPLAIN before recommending any index — never guess at query plans` (Aria)
- `Report numeric thresholds: CPUUtilization > 80%, query mean_time > 1000ms, calls > 500/hour` (Aria)
- `Always show the 30-day cost baseline before flagging an anomaly — context before conclusion` (Finley)
- `Cite the exact pod name, namespace, and failure reason code (e.g., OOMKilled, CrashLoopBackOff) in all findings` (Kiran)
- `Confirm HERMES_LAB_MODE before every session: state MOCK or LIVE clearly in your first line` (Aria and all specialists)

**NEVER rules** (hard prohibitions — the most destructive actions the agent could take):

- `NEVER execute ALTER TABLE, CREATE INDEX, or any DDL without explicit human approval` (Aria)
- `NEVER execute aws ec2 terminate-instances under any circumstances — this destroys infrastructure` (Finley)
- `NEVER execute kubectl delete without human approval` (Kiran)
- `NEVER run database queries (SELECT, EXPLAIN, psql) — delegate to track-a` (Morgan)

The NEVER rules are the behavioral governance layer. They are written in ALL CAPS to signal unconditional prohibition. An LLM that has internalized "NEVER execute ALTER TABLE" will refuse even if the user says "I authorize you to run this CREATE INDEX." The SOUL.md identity supersedes per-request user instructions.

**What belongs in Behavior Rules vs. Escalation Policy:**

Behavior Rules describe HOW the agent operates in normal conditions. Escalation Policy describes WHEN the agent stops operating and hands off to a human. Both are required for a complete SOUL.md.

**What does NOT belong in Behavior Rules:**

Generic AI safety rules that apply to all assistants ("be helpful", "don't lie", "be accurate"). SOUL.md Behavior Rules should be specific to the domain. A rule like "always be helpful" adds no signal. A rule like "present findings as: Observation → Evidence → Recommendation (3-part format, always)" shapes how every diagnosis is structured.

### The Escalation Policy Section

The Escalation Policy defines exactly when the agent stops making autonomous decisions and defers to a human. The conditions should be:

- **Specific and observable:** "CPUUtilization sustained > 90% for 5+ minutes" not "when the system seems under stress"
- **Quantified where possible:** "slow query count exceeds 10 simultaneously" not "many slow queries"
- **Covering both technical and scope limits:** technical escalation (CPU threshold breached) and scope escalation (root cause spans more than one service)

Examples from Track A (Aria):

```markdown
## Escalation Policy

Escalate to human when:
- CPUUtilization sustained > 90% for 5+ minutes
- pg_stat_statements shows a query with mean_time > 5000ms
- Parameter change requires database restart
- Root cause spans more than one service (possible cross-domain incident)

Always say: "Escalating — this exceeds DBA agent scope. Human review required before proceeding."
```

The "Always say" line is important. It gives the agent a standard escalation phrase that operators can scan for in logs and Slack messages. Consistent escalation language makes audit review faster.

**The escalation policy creates a bounded agent.** An agent without a clear escalation policy will either over-escalate (every uncertainty triggers a human interruption) or under-escalate (the agent keeps trying to solve problems outside its scope). The escalation policy is the contract between the agent and the operator: "Here is exactly when you will hear from me."

### SOUL.md vs. System Prompts

SOUL.md is sometimes confused with a per-request system prompt. They are not the same:

| | SOUL.md | Per-Request System Prompt |
|---|---|---|
| **When loaded** | Once at agent startup | Reconstructed each turn |
| **Scope** | Entire session | Single turn |
| **Purpose** | Persistent identity layer | Contextual instruction |
| **Written by** | Agent designer (profile author) | Agent runtime (prompt builder) |
| **Mutability** | Fixed for the session | Can change each turn |

SOUL.md is loaded by `agent/prompt_builder.py` during system prompt assembly. It is injected as the first, highest-priority context block — before skills, before memory, before the user's current instruction. This placement means SOUL.md constraints are always visible to the LLM in every turn.

---

## Section 3 — config.yaml Anatomy

### The Core Configuration

`config.yaml` defines the agent's operational capabilities. The file has five functional groups of keys:

**Model configuration:**

```yaml
model:
  default: "anthropic/claude-haiku-4"
  provider: "auto"
```

`model.default` specifies the LLM identifier in OpenRouter format (provider/model-name). `model.provider: "auto"` lets Hermes select the appropriate API client based on the model identifier. Course agents use `anthropic/claude-haiku-4` — a cost-efficient model appropriate for diagnostic and analysis tasks.

**Platform toolsets:**

```yaml
platform_toolsets:
  cli: [terminal, file, web, skills]  # Full toolkit for domain specialists
  # OR
  cli: [web, skills]                   # Coordinator pattern: no terminal
```

`platform_toolsets.cli` is the list of tool categories available to this agent. Available categories:

- `terminal` — Execute shell commands, run CLI tools (psql, aws, kubectl)
- `file` — Read and write files in the agent's working context
- `web` — Web search and URL fetching
- `skills` — Load and query SKILL.md domain knowledge files

Domain specialists (Track A, B, C) need `terminal` to run diagnostic commands. The fleet coordinator explicitly does NOT have `terminal` — this is the mechanical enforcement of the coordinator pattern. Morgan can never accidentally execute a domain command because the terminal tool is not in its toolset.

**Delegation (coordinator only):**

```yaml
delegation:
  max_iterations: 30
  default_toolsets: ["terminal", "file", "web", "skills"]
```

The `delegation` block is what makes a profile a coordinator. `max_iterations` limits how many agent turns the coordinator can take overall. `default_toolsets` specifies which tools are granted to spawned specialist subagents when they are delegated to by the coordinator. This is why the coordinator can spawn specialists with terminal access even though the coordinator itself has none — the coordinator grants toolsets to its children, but does not use them itself.

Domain specialist profiles do not have a `delegation` block. They receive delegation requests but do not spawn their own subagents (in normal course operation).

**Approvals (governance):**

```yaml
approvals:
  mode: manual       # L2: all flagged dangerous commands require human approval
  timeout: 300       # 5 minutes — required for lab flows with multiple approval steps
```

See the Governance Reference (`course/reading/governance-ref.md`) for full detail on approval modes. In the profile context: `mode: manual` is the L2 default. `timeout: 300` gives humans 5 minutes to respond in interactive sessions — important for lab scenarios where participants may need time to read the approval prompt and decide.

**Agent behavior:**

```yaml
agent:
  max_turns: 30
  verbose: false
```

`max_turns` limits the agent loop — how many tool-calling turns the agent can take in a single conversation. 30 is appropriate for complex multi-step diagnostic tasks. `verbose: false` suppresses intermediate tool output in non-debug mode.

**Command allowlist:**

```yaml
command_allowlist: []  # L2: nothing pre-approved; L4 would add description-key strings
```

The `command_allowlist` contains description-key strings from `tools/approval.py` DANGEROUS_PATTERNS. Any pattern whose description appears in this list bypasses the approval gate. At the course level, all agents start with an empty allowlist.

### How config.yaml Keys Map to Runtime Behavior

When `hermes -p track-a chat` is launched:

1. Hermes resolves the profile directory: `~/.hermes/profiles/track-a/`
2. `config.yaml` is loaded and merged with the user's global `~/.hermes/config.yaml`
3. `platform_toolsets.cli` determines which tools are registered for this session
4. `approvals.mode` is read by `tools/approval.py` before every terminal command
5. `model.default` is used when no per-request model override is specified
6. `agent.max_turns` sets the conversation loop limit
7. SOUL.md is loaded from the profile directory and injected into the system prompt
8. `skills/` is scanned — all SKILL.md files found are loaded as domain knowledge

The profile directory name becomes the profile identifier. `~/.hermes/profiles/track-a/` is referenced as `-p track-a` in the CLI. `~/.hermes/profiles/fleet/` is referenced as `-p fleet`. The directory name is the profile handle.

### The Install Pattern

```bash
# Register the profile, then copy the agent files in
hermes profile create track-a
cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/

# Launch the agent
hermes -p track-a chat

# Or specify a model override
hermes -p track-a --model anthropic/claude-3-5-sonnet-20241022 chat
```

No build step. No restart required. `hermes profile create` registers the profile in Hermes's index and creates the directory; the `cp` commands populate it with the agent files. The profile is immediately available after the copies finish.

---

## Section 4 — Hermes-Specific Implementation Details

### How Hermes Discovers and Loads Profiles

Profile discovery happens at CLI startup via `hermes_cli/profiles.py`. Hermes scans `~/.hermes/profiles/` for subdirectories that contain `config.yaml`. Any directory without `config.yaml` is ignored. The directory name becomes the profile name used in `-p <name>` flags.

The loaded profile config is deep-merged with the user's global `~/.hermes/config.yaml`. Profile-level keys override global defaults. This allows users to set a global model preference while letting individual profiles override for specific use cases.

### How SOUL.md Is Loaded and Injected

SOUL.md is loaded by `agent/prompt_builder.py` during system prompt assembly. The loading sequence:

1. Read `SOUL.md` from the profile directory
2. Check for unfilled placeholders: if the file still contains `[placeholder]` syntax, log a warning
3. Inject SOUL.md content as the leading block of the system prompt, before skills and memory
4. The LLM sees SOUL.md as its "who I am" context on every turn

SOUL.md is not re-read on every turn — it is loaded once at session start and cached. Changes to SOUL.md take effect on the next session.

### The skills/ Subdirectory

The `skills/` directory in a profile is optional. When present, every SKILL.md file in the directory is loaded at session startup and made available to the agent as domain knowledge.

```
~/.hermes/profiles/track-a/
├── SOUL.md
├── config.yaml
└── skills/
    ├── db-health-check.md           # When to run this skill, what metrics to check
    ├── slow-query-analysis.md       # Step-by-step query analysis workflow
    ├── parameter-tuning-guide.md    # RDS parameter recommendations
    └── escalation-runbook.md        # When and how to escalate
```

Skills are machine-readable runbooks — SKILL.md files teach the agent domain-specific workflows. A Track A profile with skills knows how to run a PostgreSQL health check in the same way that a human DBA follows a runbook. Without skills/, the agent falls back to the LLM's general knowledge of PostgreSQL diagnostics, which is broader but less precise.

**Skills vs. SOUL.md:** The boundary is procedural vs. behavioral:
- SOUL.md: "WHO you are, what you NEVER do" — identity and hard constraints
- SKILL.md: "HOW to diagnose, what commands to run in which order" — procedural knowledge

An agent with a rich SOUL.md but no skills/ knows its values but not its workflows. An agent with skills/ but no SOUL.md has procedures but no identity or constraints. Both are required for a complete specialist agent.

### The Fleet Coordinator Pattern

The fleet coordinator (Morgan) demonstrates a distinct profile design pattern. Its profile has a key distinguishing feature: **no `skills/` directory**.

```
~/.hermes/profiles/fleet/
├── SOUL.md        # Identity: coordinator, NOT a domain specialist
└── config.yaml    # No terminal, delegation block active
                   # (No skills/ directory — intentional)
```

Why no skills/? The coordinator's capability is delegation, not domain execution. If Morgan had a `skills/` directory with K8s SKILL.md files, it might attempt to execute kubectl commands directly instead of delegating to Kiran. The absence of skills/ enforces the coordinator pattern at the configuration level, not just at the SOUL.md NEVER rule level.

Compare Morgan's config.yaml to Aria's:

| Key | Aria (Track A, Specialist) | Morgan (Fleet Coordinator) |
|---|---|---|
| `platform_toolsets.cli` | `[terminal, file, web, skills]` | `[web, skills]` |
| `delegation` block | Not present | `max_iterations: 30` + `default_toolsets` |
| `skills/` directory | Present (domain runbooks) | Absent (no domain commands) |
| `approvals.mode` | `manual` (L2) | `manual` |
| Identity focus | Domain depth: diagnose + recommend | Delegation scope: triage + coordinate |

The absence of `terminal` in Morgan's toolset is mechanical enforcement of "Morgan never runs commands." Even if Morgan's reasoning led it to want to run `kubectl get pods`, the terminal tool is simply not available. This is defense in depth — the SOUL.md NEVER rules are backed by the config.yaml toolset restriction.

### Profile Naming Convention

Profile directory names use kebab-case: `track-a-database`, `track-b-finops`, `track-c-kubernetes`, `fleet-coordinator`. The directory name in `~/.hermes/profiles/` is what you pass to `-p`. The course installs profiles to shorter names for convenience (`track-a`, `track-b`, `track-c`, `fleet`) while the source directory uses the full descriptive name.

### SOUL-TEMPLATE.md and the Placeholder Completeness Check

`course/agents/SOUL-TEMPLATE.md` is the starting template for writing a new agent's SOUL.md. It uses `[square bracket]` syntax for every placeholder that must be filled in:

```markdown
# [Agent Name]

**Role:** [One-line role description — what this agent does]
**Domain:** [Track A: Database | Track B: FinOps | Track C: Kubernetes | Fleet Coordinator]

## Identity

[2-3 sentences. First person. Start with: "You are [Name], a [role] agent for [team/org]."]
```

The `[square bracket]` syntax is greppable. The completeness check is a single command:

```bash
grep -c '\[' your-SOUL.md
```

Result must be 0. Any remaining `[` character means an unfilled placeholder. This is the same pattern used across the course (SKILL-TEMPLATE.md uses the same syntax). One command tells you whether the file is complete.

Hermes also warns at startup if SOUL.md contains unfilled placeholders — participants see the warning immediately when they try to run an incomplete agent.

---

## Section 5 — DevOps Examples

### Aria (Track A) — Database Specialist Profile Walkthrough

**Location:** `course/agents/track-a-database/`

**Identity:** Aria is a DBA specialist for PostgreSQL on AWS RDS. The identity anchors every interaction in the diagnostic frame: "You diagnose performance problems and recommend fixes. You do not execute changes."

**Behavior Rules:** The behavioral layer enforces read-only operation:
- Positive rules: run EXPLAIN before recommending any index, report numeric thresholds, present findings in Observation → Evidence → Recommendation format
- NEVER rules: ALTER TABLE, CREATE INDEX, DDL without approval, VACUUM FULL during business hours

**Escalation Policy:** Quantified and specific — CPU > 90% sustained, query mean_time > 5000ms, parameter change requiring restart, cross-domain root cause. The specificity of these thresholds prevents both under-escalation and over-escalation.

**config.yaml:** L2 governance (manual approval), full terminal toolset, claude-haiku-4. The approval gate fires when Aria encounters SQL DROP or other DANGEROUS_PATTERNS — which can happen during diagnostic work if a suggested remediation involves schema-level operations.

**Skills:** The `skills/` directory carries the DevOps skill pack for database operations — the machine-readable runbooks that teach Aria the diagnostic procedures.

**Install and launch:**
```bash
hermes profile create track-a
cp agents/track-a-database/config.yaml ~/.hermes/profiles/track-a/
cp agents/track-a-database/SOUL.md ~/.hermes/profiles/track-a/
cp -r agents/track-a-database/skills/dba-rds-slow-query ~/.hermes/profiles/track-a/skills/
hermes -p track-a chat
```

### Finley (Track B) — FinOps Specialist Profile Walkthrough

**Location:** `course/agents/track-b-finops/`

**Identity:** Finley is a FinOps agent for AWS cost analysis. The identity frames every interaction as cost investigation: "You identify cost anomalies, correlate spend spikes to infrastructure changes, and propose rightsizing actions."

**Behavior Rules:** The behavioral layer enforces read-only cost analysis:
- Positive rules: show 30-day baseline before flagging anomaly, quantify every recommendation with specific dollar amounts and CPU utilization percentages, separate detection from attribution
- NEVER rules: terminate EC2 instances, modify-instance-attribute without approval, recommend terminating Reserved Instances or Savings Plans

**The critical distinction for Track B:** `aws ec2 terminate-instances` is NOT in Hermes DANGEROUS_PATTERNS. The NEVER rule in Finley's SOUL.md is the sole safety control for this command. This means the behavioral governance layer is load-bearing — not optional, not backed by a mechanical gate.

**config.yaml:** L2 governance (manual approval), full terminal toolset for aws cli commands, claude-haiku-4.

### Kiran (Track C) — Kubernetes Specialist Profile Walkthrough

**Location:** `course/agents/track-c-kubernetes/`

**Identity:** Kiran is a Kubernetes health agent for platform engineering teams. The identity focuses on diagnosis with specific evidence requirements: "Your diagnosis always cites the specific pod name, namespace, and event timestamp."

**Behavior Rules:**
- Positive rules: start with `kubectl get pods --all-namespaces` for baseline, cite exact failure reason codes (OOMKilled, CrashLoopBackOff)
- NEVER rules: kubectl delete without approval, kubectl drain (always escalate), kubectl cordon without approval, modify resource limits without change request

Same pattern as Track B: kubectl destructive commands are not in DANGEROUS_PATTERNS. SOUL.md NEVER rules are the primary governance mechanism.

### Morgan (Fleet Coordinator) — Coordinator Profile Walkthrough

**Location:** `course/agents/fleet-coordinator/`

**Identity:** Morgan is a cross-domain incident coordinator. The identity is defined by delegation scope, not domain expertise: "You never run database queries, AWS CLI commands, or kubectl directly — specialists do that work."

**Behavior Rules (NEVER rules):**
- NEVER run database queries — delegate to track-a
- NEVER run AWS CLI commands — delegate to track-b
- NEVER run kubectl commands — delegate to track-c
- NEVER spawn more than one delegation per domain per incident

These NEVER rules create the coordinator pattern in behavioral governance. The `platform_toolsets.cli: [web, skills]` in config.yaml creates the same pattern in mechanical governance.

**config.yaml distinguishing features:**
- No `terminal` in toolsets — mechanical enforcement of the coordinator pattern
- `delegation` block present — enables spawning specialist subagents
- No `skills/` directory — coordinator capability is delegation configuration, not domain runbooks

**The `default_toolsets` in delegation:**

```yaml
delegation:
  max_iterations: 30
  default_toolsets: ["terminal", "file", "web", "skills"]
```

When Morgan spawns a specialist subagent, that subagent receives the `default_toolsets` list as its available tools. This is why Aria (spawned by Morgan) can run terminal commands even when Morgan cannot — the coordinator grants toolsets to its children.

---

## Section 6 — Course Examples

The following course artifacts are the concrete profile implementations. Read this document first, then inspect the files to see how the concepts are expressed.

**Agent profile directories:**

- `course/agents/track-a-database/SOUL.md` — Aria, DBA specialist. The clearest example of domain-specific identity with quantified Behavior Rules and specific Escalation Policy conditions.
- `course/agents/track-a-database/config.yaml` — Complete capability config: model, terminal toolset, L2 manual approval. The reference config for a domain specialist.
- `course/agents/track-b-finops/SOUL.md` — Finley, FinOps analyst. Demonstrates SOUL.md NEVER rules as load-bearing safety controls for non-DANGEROUS_PATTERNS commands.
- `course/agents/track-c-kubernetes/SOUL.md` — Kiran, K8s health specialist. Same behavioral governance pattern as Track B.
- `course/agents/fleet-coordinator/SOUL.md` — Morgan, fleet coordinator. The identity-as-delegation-scope pattern. Contrast with the specialist identities.
- `course/agents/fleet-coordinator/config.yaml` — Coordinator config: no terminal, delegation block active, no skills/. The reference for the coordinator pattern.

**Template:**

- `course/agents/SOUL-TEMPLATE.md` — The template with `[placeholder]` syntax and the `grep -c '\['` completeness check. Used in the Module 8 lab.

**Governance reference:**

- `course/reading/governance-ref.md` — The companion document for understanding approval modes and maturity levels as they appear in config.yaml.

**The Module 8 lab** walks building a profile from scratch using SOUL-TEMPLATE.md and the course agent profiles as reference implementations. This document explains the conceptual model. The lab provides the hands-on construction steps.

---

## Section 7 — Quick Reference

### SOUL.md Sections

| Section | Purpose | What to Write There |
|---|---|---|
| Header block | Agent metadata: name, role, domain, scope | Name (used by LLM self-reference), one-sentence role, domain track, scope inclusions AND exclusions |
| `## Identity` | First-person 2-3 sentence identity statement | Who you are + what you do + what you never do. Domain-specific, not generic AI behavior. |
| `## Behavior Rules` | Imperative operating directives | Positive rules (reporting format, thresholds, always-do), NEVER rules (hard prohibitions in ALL CAPS) |
| `## Escalation Policy` | Conditions for handing off to human | Specific, quantified, observable conditions. Technical thresholds AND scope boundaries. Standard escalation phrase. |

### config.yaml Keys

| Key | Type / Values | Effect on Agent Behavior |
|---|---|---|
| `model.default` | String (e.g., `anthropic/claude-haiku-4`) | LLM used for all conversations. Override with `--model` flag in CLI. |
| `model.provider` | `auto` or provider name | API client selection. `auto` lets Hermes detect from model identifier. |
| `platform_toolsets.cli` | Array of tool categories | Which tools are available. Specialists: `[terminal, file, web, skills]`. Coordinators: `[web, skills]`. |
| `delegation.max_iterations` | Integer (e.g., 30) | Maximum agent loop turns for this coordinator profile. |
| `delegation.default_toolsets` | Array of tool categories | Tools granted to spawned specialist subagents by the coordinator. |
| `approvals.mode` | `manual`, `smart`, `auto` | Governance mode. `manual` = L2 (every dangerous command requires human). `smart` = L3 (aux LLM filters false positives). `auto` = bypass all approval gates. |
| `approvals.timeout` | Integer (seconds, e.g., 300) | How long to wait for human approval before treating as denial. |
| `command_allowlist` | Array of description-key strings | Permanently pre-approved DANGEROUS_PATTERNS. Empty at course level. |
| `agent.max_turns` | Integer (e.g., 30) | Maximum conversation turns before agent loop exits. |
| `agent.verbose` | Boolean (`true`/`false`) | Show intermediate tool output. `false` for production; `true` for debugging. |

### Profile Types and Characteristic Config

| Type | Terminal Toolset | skills/ Dir | delegation Block | approvals.mode | Example |
|---|---|---|---|---|---|
| Domain specialist | Yes (`terminal` in cli) | Yes (domain runbooks) | No | `manual` (L2) or `smart` (L3+) | Aria (Track A), Finley (Track B), Kiran (Track C) |
| Fleet coordinator | No (`terminal` absent from cli) | No | Yes (with `default_toolsets`) | `manual` | Morgan (Fleet Coordinator) |
| Read-only advisor | Yes (but SOUL.md NEVER on mutations) | Yes (advisory runbooks) | No | `manual` | Any L2 specialist before promotion |
| Semi-autonomous (L4) | Yes | Yes | No | `smart` + non-empty `command_allowlist` | Post-promotion specialist profiles |

### Profile vs. Skill — What Belongs Where

A common source of confusion is what should be in SOUL.md vs. what should be in a SKILL.md file:

| Content Type | Goes In | Reason |
|---|---|---|
| Agent name and role | SOUL.md header | Identity — applies to every interaction |
| Hard prohibitions (NEVER rules) | SOUL.md Behavior Rules | Behavioral governance — always active |
| Escalation conditions | SOUL.md Escalation Policy | Operational boundary — always active |
| Step-by-step diagnostic procedure | SKILL.md in skills/ | Procedural knowledge — invoked when relevant |
| CLI commands to run for a specific task | SKILL.md in skills/ | Workflow — situation-specific |
| Thresholds for a specific scenario | SKILL.md in skills/ | Context-specific runbook data |
| Domain vocabulary and terminology | SKILL.md in skills/ | Knowledge — builds agent's domain framing |
| Reporting format (generic) | SOUL.md Behavior Rules | Always applies — format all findings this way |
| Reporting format (scenario-specific) | SKILL.md in skills/ | Applies when this specific skill is relevant |
| Model and tool configuration | config.yaml | Runtime configuration — not behavioral |

**The test:** "Does this always apply, regardless of what the user asks?" → SOUL.md. "Does this apply only when the agent is working on a specific type of task?" → SKILL.md.

### Is Your Profile Complete? Checklist

**SOUL.md completeness:**
- [ ] Header block: Name, Role, Domain, Scope are all filled in (no `[placeholder]` syntax)
- [ ] Identity section: 2-3 first-person sentences, domain-specific (not generic AI behavior)
- [ ] Behavior Rules: At least 3 positive rules with specific, observable criteria
- [ ] Behavior Rules: At least 2 NEVER rules in ALL CAPS for domain's most dangerous actions
- [ ] Escalation Policy: At least 3 specific, observable conditions (quantified where possible)
- [ ] Escalation Policy: Standard escalation phrase defined
- [ ] Completeness check: `grep -c '\[' SOUL.md` returns 0 (no unfilled placeholders)

**config.yaml completeness:**
- [ ] `model.default` specified with valid model identifier
- [ ] `platform_toolsets.cli` matches the intended agent type (specialist: include `terminal`; coordinator: exclude `terminal`)
- [ ] `approvals.mode` set to `manual` for first deployment
- [ ] `approvals.timeout` set (300 recommended for interactive sessions)
- [ ] For coordinators: `delegation` block present with `max_iterations` and `default_toolsets`
- [ ] `agent.max_turns` set appropriate to task complexity

**skills/ directory:**
- [ ] At least one domain-relevant SKILL.md present (unless intentionally coordinator pattern)
- [ ] SKILL.md files use agentskills.io format (frontmatter + structured sections)
- [ ] No placeholder syntax remaining in any SKILL.md file
