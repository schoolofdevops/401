# Hermes Agent Anatomy: Brain, Skills, Tools, and Guardrails

**Purpose:** This document is the "textbook" version of what you built hands-on in Modules 7-10. It explains WHY the Hermes agent architecture works the way it does — the reasoning behind the design, not the steps for operating it. Bookmark this and return to it when you hit unexpected agent behavior, design a new agent, or onboard a teammate.

---

## Table of Contents

1. [What Is an Agent? Plain English.](#1-what-is-an-agent-plain-english)
2. [The Four-Component Architecture](#2-the-four-component-architecture)
3. [The Hermes Implementation](#3-the-hermes-implementation)
4. [DevOps Agent Walkthroughs](#4-devops-agent-walkthroughs)
5. [Course Examples — File References](#5-course-examples--file-references)
6. [Quick Reference](#6-quick-reference)

---

## 1. What Is an Agent? Plain English.

### 1.1 The Difference Between a Chatbot and an Agent

A chatbot waits for your question, produces one response, and stops. Every interaction is stateless — the bot does not carry intent forward between messages, it does not take initiative, and it cannot alter anything in the world beyond producing text.

An agent is different in one fundamental way: it has **goals**, not just responses. Given an objective, an agent runs a loop:

```
receive goal
  → plan what tools to use
    → execute a tool
      → observe the result
        → update the plan
          → execute the next tool
            → ... (repeat until goal reached or stuck)
```

That loop is the core capability that separates a chatbot from an agent. The agent does not just answer "what queries are slow?" — it runs `psql -c "SELECT * FROM pg_stat_statements"`, reads the output, decides which queries to investigate deeper, runs `EXPLAIN ANALYZE` on each candidate, cross-references with CloudWatch CPU metrics, and produces a structured diagnosis. Each step observes the environment and informs the next.

### 1.2 Why DevOps Practitioners Should Care

You already think in loops. An SRE incident response is:

```
observe alert → gather metrics → form hypothesis → test fix → verify result → close or escalate
```

An agent implements exactly this loop — autonomously, in code, 24/7. The agent does not replace the engineer's domain expertise. It runs the engineer's expertise (encoded in SKILL.md) on demand, at scale, without paging the on-call at 2am for a task that has a known procedure.

The reason this matters now and not five years ago: the loop only becomes useful when the reasoning step (the "decide what to do next" step) is good enough to be trusted. Modern LLMs crossed that threshold for structured diagnostic tasks in well-scoped domains. An RDS slow-query diagnosis is bounded enough that an LLM with the right context makes the same decision a senior DBA makes, repeatedly and without fatigue.

### 1.3 The ReAct Pattern: Observe, Think, Act

Under the hood, the Hermes agent loop implements the ReAct pattern (Reasoning + Acting), which was formalized in a 2022 research paper but maps directly to how humans debug infrastructure problems:

- **Observe:** The agent receives tool output (CloudWatch metrics, psql query results, kubectl describe output).
- **Think:** The LLM reasons about what the output means, whether it confirms or contradicts a hypothesis, and what to do next. This reasoning happens inside the model's context window — it is invisible to the operator but drives every decision.
- **Act:** The agent emits a tool call. The tool runs. Output comes back. The loop continues.

The loop terminates when the agent decides it has reached its goal (diagnosis complete, remediation applied, escalation triggered) or when it hits the `max_turns` limit from `config.yaml`.

### 1.4 Why Four Components? Why Not Just the LLM?

Early agent frameworks tried to use a single LLM to do everything: reason about infrastructure, remember procedures, execute commands, and self-govern. This fails for predictable reasons:

**The pure-LLM agent problem:**

- **Hallucination at the tool layer:** Without constrained tool access, the LLM invents commands ("run `db-heal --auto`" — no such command exists). The agent loop spins, the environment does not change, and the agent hallucinates a fix that never ran.
- **Context drift:** Over long loops, the model forgets the original objective and starts solving the wrong problem. Without external skills anchoring the procedure, the reasoning drifts.
- **Scope creep:** Without behavioral constraints, the agent attempts more than it should. A DBA agent that can run DDL will eventually run DDL when it thinks a schema change would help — even without human review.
- **No auditability:** A pure-LLM agent has no observable decision points. You cannot inspect "why did it do that?" You can only see the final output.

The four-component model solves each failure mode with a dedicated layer:

| Failure Mode | Component That Solves It |
|---|---|
| Hallucinated commands | Tools (only registered tools can be called) |
| Context drift | Skills (SKILL.md anchors the procedure) |
| Scope creep | Guardrails (SOUL.md + DANGEROUS_PATTERNS) |
| No auditability | Registry + approval audit log |

### 1.5 The Four Components and Their Roles

Every Hermes agent has four distinct components. They are not interchangeable — each layer has a different job and a different contract:

**Brain (LLM):**
The reasoning engine. Receives the current context (system prompt + SOUL.md + loaded skill + tool results so far) and decides what to do next: which tool to call, with what arguments, and why. The Brain does not "know" the domain — it reasons about the domain using the context provided to it. The quality of its decisions depends entirely on the quality of the context it receives. This is why context engineering is the core skill for building effective agents.

**Skills (SKILL.md files):**
Domain knowledge encoded as machine-readable runbooks. The skill tells the Brain: when to start this procedure, what data to collect (Scripts Zone), how to reason about that data (Agents Zone), what is forbidden, and when to escalate. Skills are the difference between an agent that knows "I should investigate slow queries" and one that knows "run `SELECT mean_exec_time_ms, calls, query FROM pg_stat_statements WHERE mean_exec_time_ms > 1000 ORDER BY mean_exec_time_ms DESC LIMIT 20` against the production database, then cross-reference with CloudWatch CPUUtilization, then check pg_stat_user_tables for sequential scan ratios."

**Tools (terminal, MCP, wrappers):**
The execution layer. Tools are the only way the agent changes or observes the external world. The terminal tool runs shell commands. MCP tools call structured external services. Wrapper scripts intercept CLI calls and route to mock data or real infrastructure depending on `HERMES_LAB_MODE`. The agent cannot run arbitrary code — it can only call registered tools. This is a feature, not a limitation: constrained execution is auditable execution.

**Guardrails (SOUL.md NEVER rules + DANGEROUS_PATTERNS):**
Two-layer behavioral and mechanical safety. The SOUL.md layer is behavioral: it defines the agent's identity, scope, and NEVER DO rules at the prompt level. The DANGEROUS_PATTERNS layer is mechanical: a list of regex patterns in `tools/approval.py` that intercept any matching command before it executes, regardless of what the Brain decided. The two layers address different threat models. SOUL.md prevents the agent from deciding to do something dangerous. DANGEROUS_PATTERNS intercepts the command even if the agent decision was wrong.

### 1.6 Why the Separation Matters

Consider an agent without Skills: the Brain must figure out from scratch what "diagnose RDS slow queries" means every time. It cannot be consistent. Different sessions will follow different procedures. Findings cannot be compared across runs. There is no way to audit whether the agent followed the correct operational procedure.

Consider an agent without Guardrails: the Brain might decide that running `DROP INDEX users_email_idx` would be a useful test. The agent executes it. On the production database. The Brain is capable of reasoning that dropping an index is reversible — it does not have the DevOps engineer's institutional knowledge that "reversible in theory" means "multi-hour incident in practice."

The separation is not a convenience. It is the governance model. Each component can be audited, updated, and tested independently:
- Skills can be updated by domain experts without touching agent code.
- Guardrails can be tightened (or relaxed) without changing the Brain or Skills.
- Tools can be mocked (via wrappers) for testing without touching the agent configuration.

### 1.7 Context Engineering: Why It Is More Important Than Prompt Engineering

Prompt engineering is about writing effective questions. Context engineering is about constructing the right environment for answers.

Consider the difference:
- Prompt: "Check if the database is slow" — forces the agent to decide what "slow" means, what tool to use, what threshold to apply.
- Context (SKILL.md + SOUL.md): "When CloudWatch alarm `rds-cpu-high` fires: run Step 1.1 to check DBInstanceStatus, run Step 1.2 to query pg_stat_statements for queries with mean_exec_time_ms > 1000, run Step 1.3 to check pg_stat_user_tables for sequential scan ratios..." — the agent has no ambiguity.

The agent's quality is proportional to the quality of the context it receives. A mediocre model with excellent context (expert domain knowledge in SKILL.md, precise behavioral constraints in SOUL.md, correct tool access in config.yaml) outperforms an excellent model with a vague prompt. This is why the course teaches SKILL.md authoring as the primary skill — the SKILL.md file IS the context engineering artifact.

### 1.8 The Two Failure Modes of Agent Governance

**Runaway agents (under-governed):**
No SOUL.md NEVER rules, no DANGEROUS_PATTERNS matching, approval mode set to `off`. The agent executes anything the Brain decides. This works fine 99% of the time and catastrophically 1% of the time. The 1% is what defines production readiness.

**Useless agents (over-governed):**
Every command requires manual approval. The agent can only read documentation and cannot touch anything. Useful for building initial trust (L1 governance), but zero operational value for automated diagnostic work.

The governance maturity levels (L1 through L4, defined in `course/governance/`) are a calibration path. You start restrictive and earn autonomy through demonstrated correct behavior. L1 requires approval for everything. L4 has a pre-approved allowlist for known-safe commands.

---

## 2. The Four-Component Architecture

### 2.1 Brain: The LLM Reasoning Engine

The Brain is any LLM that supports tool calling (function calling). In Hermes, the Brain is configured in `config.yaml` under the `model` key:

```yaml
model:
  default: "anthropic/claude-haiku-4"
  provider: "auto"
```

The Brain receives, at each turn of the agent loop:
- The system prompt (SOUL.md + any platform context)
- All loaded skills for this session
- The conversation history so far (previous messages + tool outputs)
- The list of available tool schemas (JSON function definitions)

From this context, the Brain produces either:
- A tool call (name + arguments) → dispatched to the registry
- A final response (no tool call) → loop terminates, response returned to user

The Brain never directly accesses the file system, network, or database. It only emits decisions. The execution layer (Tools) carries out those decisions.

**Why LLM model choice matters:** For structured diagnostic tasks, a smaller model (Haiku-tier) is sufficient and preferred — lower cost, lower latency, shorter context window requirements. The Brain does not need to "know" everything; it needs to reason over the context it is given. The context (SKILL.md) does the heavy lifting.

### 2.2 Skills: Encoded Domain Expertise

A Skill is a SKILL.md file loaded into the agent's context at session start. It is procedural memory — the operational playbook the agent follows for a specific diagnostic or remediation task.

Skills are discovered from the `skills/` directory inside the agent's profile:

```
~/.hermes/profiles/track-a/
  config.yaml
  SOUL.md
  skills/
    dba-rds-slow-query/
      SKILL.md
```

The Hermes skill format aligns with the `agentskills.io` spec (December 2025) — a cross-platform standard used across 30+ agent frameworks. Skills authored for Hermes can be shared with other compatible platforms without modification.

A Skill's two zones enforce a fundamental separation of concerns:

- **Scripts Zone (Phase 1):** Deterministic. CLI commands only. Exact expected output. No reasoning. No decisions. Run this, get that. Every command is reproducible and auditable.
- **Agents Zone (Phase 2):** Reasoning. IF/THEN/ELSE logic on the data collected in Phase 1. No new data collection. The reasoning is bounded by numeric thresholds and named diagnosis strings — not open-ended "investigate further."

This separation prevents a class of agent failure called "mid-loop data discovery": the agent starts reasoning, realizes it needs more data, collects more data mid-reasoning, the new data changes the reasoning direction, and the loop spirals. Scripts Zone collects everything up front. Agents Zone reasons over a fixed dataset.

### 2.3 Tools: The Execution Layer

Tools are the only channel through which the agent affects or observes the external world. In Hermes, tools are registered in `tools/registry.py` using a singleton `ToolRegistry` instance.

Each tool registration specifies:
- `name`: the function name the LLM uses to call it
- `toolset`: the logical group this tool belongs to (`terminal`, `file`, `web`, `skills`, `mcp`)
- `schema`: the JSON Schema defining inputs the LLM must provide
- `handler`: the Python function that executes the actual work
- `check_fn`: a function that returns True/False based on whether this tool is available in the current environment
- `requires_env`: environment variables this tool needs (e.g., `ANTHROPIC_API_KEY`)

The `platform_toolsets.cli` key in `config.yaml` determines which toolsets are enabled for this agent:

```yaml
platform_toolsets:
  cli: [terminal, file, web, skills]   # Track A: full access
```

```yaml
platform_toolsets:
  cli: [web, skills]   # Fleet coordinator: no terminal
```

A tool not in the enabled toolsets is not passed to the LLM — the Brain never knows it exists. This is why a coordinator agent with `[web, skills]` cannot execute shell commands even if it tries: `terminal_tool` is not in its schema list.

### 2.4 Guardrails: Two-Layer Safety

Hermes implements a two-layer safety system. The layers are independent — both must be satisfied for a command to execute.

**Layer 1 — Behavioral (SOUL.md NEVER rules):**

The SOUL.md file defines the agent's identity, scope, and behavioral constraints. The NEVER DO section encodes domain-specific prohibitions:

```
NEVER execute ALTER TABLE, CREATE INDEX, or any DDL without explicit human approval
NEVER recommend VACUUM FULL during business hours
NEVER mask an ambiguous root cause
```

These rules are part of the Brain's context. When the Brain generates a plan, it applies these rules during reasoning — before emitting a tool call. The behavioral layer operates at the decision level.

**Layer 2 — Mechanical (DANGEROUS_PATTERNS in `tools/approval.py`):**

Even if the Brain decides to run a command (violating a SOUL.md rule), `tools/approval.py` intercepts every terminal command before execution. The `DANGEROUS_PATTERNS` list contains regex patterns for commands with catastrophically bad outcomes:

```python
DANGEROUS_PATTERNS = [
    (r'\bDROP\s+(TABLE|DATABASE)\b', "SQL DROP"),
    (r'\bDELETE\s+FROM\b(?!.*\bWHERE\b)', "SQL DELETE without WHERE"),
    (r'\brm\s+-[^\s]*r', "recursive delete"),
    # ... 30+ patterns
]
```

When a pattern matches, the command does not execute. The agent receives an `{"approved": False, ...}` response and must either seek approval or report that it cannot proceed.

The approval mode (from `config.yaml`) determines what happens when a pattern matches:
- `manual`: blocks and waits for a human to type `[o]nce / [s]ession / [a]lways / [d]eny`
- `smart`: an auxiliary LLM reviews the flagged command and auto-approves low-risk matches
- `off`: no blocking (not recommended for production)

The two-layer model is necessary because the behavioral layer (SOUL.md) can be overridden by context — a sufficiently clever framing can sometimes bypass prompt-level constraints. The mechanical layer (DANGEROUS_PATTERNS) cannot be bypassed by context: the regex runs after the command is formed, before it executes, regardless of what the Brain decided.

---

## 3. The Hermes Implementation

### 3.1 How the Agent Loop Works in run_agent.py

The main agent loop lives in `run_agent.py` inside the `AIAgent` class (defined at line 408). The loop follows this structure:

1. **System prompt construction:** Loads SOUL.md, platform context, and all enabled skills into the system prompt via `agent/prompt_builder.py`.

2. **Tool schema injection:** Queries `tools/registry.py` for all registered tools whose toolsets match `platform_toolsets.cli`. Returns JSON Schema definitions for each tool. These schemas are passed to the LLM in the `tools` parameter of every API call.

3. **LLM call:** Sends the conversation history + tool schemas to the configured model. The model returns either a final message or a list of `tool_calls`.

4. **Tool dispatch:** For each `tool_call`, the registry's `dispatch()` method routes the call to the correct handler by name. If the tool is `terminal_tool`, the command passes through `check_all_command_guards()` in `tools/approval.py` first.

5. **Result injection:** Tool outputs are appended to the conversation as `tool` role messages, then the loop calls the LLM again with the updated history.

6. **Termination:** The loop ends when the LLM returns a message with no `tool_calls`, or when `max_turns` (from `config.yaml`) is reached.

The loop is not magic. It is a `while` loop that calls an API. The agent's intelligence comes from the context (steps 1-2), not from special logic in the loop itself. This is why SKILL.md quality directly determines agent quality.

### 3.2 How tools/registry.py Manages Tool Discovery

The `ToolRegistry` class in `tools/registry.py` is a singleton (`registry = ToolRegistry()` at module level). Each tool file (e.g., `tools/terminal_tool.py`, `tools/web_tool.py`) calls `registry.register()` at import time with its name, toolset, schema, and handler.

When the agent starts, `model_tools.py` imports all tool modules (triggering their module-level `registry.register()` calls), then calls `registry.get_definitions(enabled_tool_names)` to retrieve the JSON Schema list that gets passed to the LLM.

The registry's `dispatch(name, args)` method provides a single entry point for all tool execution. It:
- Looks up the tool by name
- Handles async tools by bridging to `asyncio`
- Catches all exceptions and returns a consistent `{"error": "..."}` format so the agent loop never crashes on tool failure

The key insight: the registry separates *registration* (which tools exist) from *availability* (which tools are enabled for this agent). The same codebase serves all agents — only `platform_toolsets.cli` in `config.yaml` changes which tools are visible.

### 3.3 How Skills Are Discovered and Loaded

Skills live in the `skills/` subdirectory of the agent's profile:

```
~/.hermes/profiles/track-a/
  skills/
    dba-rds-slow-query/
      SKILL.md
```

At agent startup, Hermes scans the `skills/` directory, reads each `SKILL.md` file, and prepends their content to the system prompt. The Brain sees the complete skill procedure as part of its initial context — not retrieved on demand, but present from turn 1.

This "always loaded" model has a cost (larger context, higher token usage) and a benefit (the agent does not need to decide to load a skill before using it). For course agents with 1-3 skills, the context cost is negligible.

The `skills` toolset (registered separately from `terminal`) gives the agent access to a `skills_search` tool — useful when the agent has a large skill library and needs to locate the right skill for a given situation.

### 3.4 How SOUL.md Defines Agent Identity

The SOUL.md file is loaded at agent startup and becomes part of the system prompt. It defines:

- **Role and domain:** What this agent is for, what it covers, what it does not.
- **Behavior Rules:** Specific, observable behavioral constraints. Not vague ("be careful") but specific ("NEVER execute ALTER TABLE without explicit human approval").
- **Escalation Policy:** Exactly when to stop and hand off to a human, with named triggering conditions (CPUUtilization sustained > 90% for 5+ minutes, etc.)

SOUL.md is loaded once at startup, not per-request. The identity is established in the initial context and persists throughout the session. An agent that forgets its SOUL.md rules mid-session has a context window management problem, not a SOUL.md problem.

See `course/agents/track-a-database/SOUL.md` for the complete Track A example.

### 3.5 How config.yaml Controls Capabilities

The `config.yaml` file in a profile directory is the capability manifest. It controls:

```yaml
model:
  default: "anthropic/claude-haiku-4"   # which Brain

platform_toolsets:
  cli: [terminal, file, web, skills]    # which Tools

approvals:
  mode: manual                           # Guardrail behavior
  timeout: 300

command_allowlist: []                    # pre-approved patterns (empty = nothing permanent)

agent:
  max_turns: 30                          # loop termination
```

The `platform_toolsets.cli` list is the single most impactful config decision. It determines:
- Can the agent run shell commands? (`terminal` in list → yes)
- Can the agent read files? (`file` in list → yes)
- Can the agent search the web? (`web` in list → yes)
- Can the agent use loaded skills programmatically? (`skills` in list → yes)

A coordinator agent with `cli: [web, skills]` cannot execute commands no matter what it decides — the terminal tool is never registered in its schema.

### 3.6 Approval Modes: manual, smart, off

The `approvals.mode` config key controls how the mechanical guardrail layer behaves when a `DANGEROUS_PATTERNS` match is found:

**`manual`:** The agent thread blocks. The user sees:
```
⚠️  DANGEROUS COMMAND: SQL DROP
    DROP TABLE users
    [o]nce  |  [s]ession  |  [a]lways  |  [d]eny
```
The agent cannot proceed until the user responds. This is L2 governance.

**`smart`:** An auxiliary LLM reviews the flagged command in context and decides:
- `APPROVE`: command is a false positive (e.g., `python -c "print('hello')"` triggering the `-c flag` pattern) → auto-approved
- `DENY`: command is genuinely dangerous → blocked, no user prompt
- `ESCALATE`: uncertain → falls through to manual prompt

Smart mode reduces approval fatigue for agents running complex diagnostic scripts with harmless commands that happen to match patterns. It is L3 governance.

**`off`:** All DANGEROUS_PATTERNS checks are bypassed. The agent runs any command the Brain decides. Only appropriate for trusted local development environments. Never for production.

---

## 4. DevOps Agent Walkthroughs

### 4.1 Aria — Track A Database Health Agent

Aria is the reference implementation of a domain specialist agent. Its anatomy:

| Component | Implementation | File |
|---|---|---|
| Brain | `anthropic/claude-haiku-4` | `config.yaml` line 7 |
| Skills | `dba-rds-slow-query/SKILL.md` | `skills/` directory |
| Tools | `terminal, file, web, skills` | `config.yaml` platform_toolsets |
| Behavioral guardrails | NEVER DDL, NEVER VACUUM FULL in hours | `SOUL.md` NEVER DO section |
| Mechanical guardrails | DANGEROUS_PATTERNS: DROP TABLE, DELETE without WHERE | `tools/approval.py` |
| Governance level | L2: manual approval for all flagged commands | `config.yaml` approvals.mode |

**Why Aria has no DDL capability (behavioral layer):**
Aria's SOUL.md states: "NEVER execute ALTER TABLE, CREATE INDEX, or any DDL without explicit human approval." Even if Aria diagnoses that a missing index is causing 80% of slow queries, it cannot create the index. It reports the finding, proposes the exact `CREATE INDEX` statement, and escalates to a human DBA for review and execution. This is the read-only diagnostic model — agents diagnose, humans approve changes.

**Why DDL blocking is behavioral (not mechanical):**
`CREATE INDEX` is not in Hermes `DANGEROUS_PATTERNS`. The mechanical guardrail covers catastrophically destructive commands (DROP, DELETE without WHERE, recursive rm). `CREATE INDEX` is potentially disruptive (locks, replication lag) but not irreversibly catastrophic. Blocking it via SOUL.md behavioral rules (rather than DANGEROUS_PATTERNS) keeps the mechanical layer focused on genuinely dangerous commands and teaches participants the difference between the two guardrail layers.

**The mock/live duality:**
Aria uses `mock-psql` and `mock-aws` wrappers (in `course/infrastructure/wrappers/`). When `HERMES_LAB_MODE=mock`, the wrappers intercept `psql` and `aws` calls and return pre-baked JSON fixtures from `course/infrastructure/mock-data/`. Aria does not know whether it is in mock or live mode — it runs the same commands either way. The wrappers handle the routing transparently.

### 4.2 Fleet Coordinator — No Terminal, Delegation Only

The fleet coordinator agent has a deliberately minimal capability set:

```yaml
platform_toolsets:
  cli: [web, skills]   # No terminal
delegation:
  max_iterations: 30
  default_toolsets: ["terminal", "file", "web", "skills"]
```

**Why no terminal?**
A coordinator's job is to route work to domain specialists, not execute domain commands directly. If the coordinator had terminal access, it could start running `aws` and `psql` commands itself instead of delegating to Aria. This would bypass all of Aria's SKILL.md procedures and guardrails. The coordinator is kept "hands-off the keyboard" by design — it cannot run commands because its role is orchestration, not execution.

**Why it has no skills/ directory:**
Coordinator capability comes from `delegation:` config, not from SKILL.md files. Adding skills to a coordinator would cause it to start applying those skills itself instead of routing to specialists. Skills belong to domain agents, not coordinators.

**The delegation tool:**
When the coordinator needs domain work done, it calls `delegate_task` — a tool that spins up a subagent using one of the installed specialist profiles. The specialist inherits the coordinator's context, runs its SKILL.md procedure, and returns a structured result. The coordinator collects results from all specialists and synthesizes the cross-domain view.

See `course/agents/fleet-coordinator/config.yaml` for the complete coordinator configuration.

### 4.3 Why the Coordinator Has the Same Brain as Domain Agents

The coordinator uses `anthropic/claude-haiku-4` — the same model as Aria. The coordination intelligence (deciding which specialists to invoke, synthesizing cross-domain results) does not require a more powerful model. Haiku is sufficient because:

1. The coordinator's reasoning is bounded — it routes work, it does not do deep domain analysis.
2. A more powerful (and expensive) model at the coordinator level does not produce meaningfully better routing decisions for structured DevOps scenarios.
3. Cost is additive across coordinator + specialists — using a cheap model at the coordinator level keeps total session cost manageable.

---

## 5. Course Examples — File References

The following files are the canonical examples of each architectural concept. After reading this document, open these files to see the concepts in production:

**Brain + Identity configuration:**
`course/agents/track-a-database/SOUL.md` — Complete agent identity file. Observe how: (1) the Role and Domain section scopes the agent's responsibilities, (2) the Behavior Rules use specific numeric thresholds ("CPUUtilization > 80%", "mean_time > 1000ms"), and (3) the NEVER DO rules each have a stated consequence, not just a prohibition.

**Capability configuration:**
`course/agents/track-a-database/config.yaml` — Complete config.yaml for an L2 agent. See how `platform_toolsets.cli: [terminal, file, web, skills]` enables all four toolsets, and how `approvals.mode: manual` with `command_allowlist: []` implements L2 governance.

**Coordinator pattern:**
`course/agents/fleet-coordinator/config.yaml` — The no-terminal coordinator. Compare `platform_toolsets.cli: [web, skills]` against Track A's four-toolset config. The absence of `terminal` from the list is the entire implementation of "coordinator delegates, never executes."

**Skills configuration:**
`course/skills/dba-rds-slow-query/SKILL.md` — The Track A reference implementation. The two-zone structure is visible in the Phase labels: `[SCRIPTS ZONE — deterministic]` and `[AGENTS ZONE — reasoning]`. The decision tree in Phase 2 uses numeric thresholds throughout.

**Mechanical guardrail implementation:**
`tools/approval.py` — The `DANGEROUS_PATTERNS` list starts at line 68. Each entry is a `(regex, description)` tuple. The `check_all_command_guards()` function (line 645) is the main entry point called by `terminal_tool` before executing any command.

**Governance progression:**
`course/governance/governance-L1.yaml` through `governance-L4-track-a.yaml` — Four YAML fragments showing the evolution from no-terminal (L1) through terminal + manual approval (L2), smart approval (L3), and allowlisted commands (L4).

---

## 6. Quick Reference

### 6.1 Four-Component Summary

| Component | Role | Hermes File | Config Key |
|---|---|---|---|
| Brain (LLM) | Reasoning and planning — decides what to do next | `run_agent.py` (AIAgent class) | `model.default` in `config.yaml` |
| Skills (SKILL.md) | Domain knowledge — tells the Brain HOW to do domain work | `skills/*/SKILL.md` in profile | Auto-loaded from `skills/` dir |
| Tools | Execution — the only way to affect the outside world | `tools/registry.py` + tool files | `platform_toolsets.cli` in `config.yaml` |
| Guardrails | Safety — two layers: behavioral (SOUL.md) + mechanical (DANGEROUS_PATTERNS) | `SOUL.md` + `tools/approval.py` | `approvals.mode` in `config.yaml` |

### 6.2 Agent Types and Typical Configurations

| Agent Type | Platform Toolsets | Skills | Approval Mode | Example |
|---|---|---|---|---|
| Domain specialist | `[terminal, file, web, skills]` | 1-3 domain skills | `manual` (L2) or `smart` (L3) | Track A, B, C agents |
| Fleet coordinator | `[web, skills]` | None (uses delegation) | `manual` | `fleet-coordinator` |
| Read-only advisor | `[web, skills]` | Domain skills | `manual` | L1 governance pattern |
| Autonomous executor | `[terminal, file, web, skills]` | Domain skills + allowlist | `smart` + `command_allowlist` | L4 governance |

### 6.3 Common Failure Modes and Diagnosis

| Symptom | Likely Cause | Check |
|---|---|---|
| Agent runs same tool 5+ times in a loop | Skill missing "when to stop" criterion | Agents Zone decision tree — does every branch terminate? |
| Agent proposes commands it could run directly | SOUL.md NEVER rule not strong enough, or missing | Review SOUL.md NEVER DO section |
| Agent ignores DANGEROUS_PATTERNS and runs dangerous command | `approvals.mode: off` set in config | Set `mode: manual` or `mode: smart` |
| Coordinator executing commands instead of delegating | `terminal` in coordinator's `platform_toolsets.cli` | Remove `terminal` from coordinator config |
| Agent uses wrong skill for the problem | `skills/` dir has multiple skills, Brain chooses wrong one | Check `When to Use` section in each skill — are triggers specific? |
| Mock mode produces wrong output | Wrong `HERMES_LAB_SCENARIO` or wrappers not in PATH | Verify `export PATH="$(pwd)/wrappers:$PATH"` and `HERMES_LAB_SCENARIO=clean|messy` |
| Agent loop terminates too early | `max_turns` too low for multi-step skill | Increase `agent.max_turns` in `config.yaml` |

### 6.4 Does Your Agent Have All Four Components?

Before deploying or demonstrating any Hermes agent, verify:

- [ ] **Brain:** `model.default` is set in `config.yaml`. Model is available (API key configured).
- [ ] **Skills:** `skills/` directory exists in profile. At least one `SKILL.md` is present. Skill passes Tier 1 RUBRIC.md checks.
- [ ] **Tools:** `platform_toolsets.cli` matches the agent's role (domain specialist has `terminal`, coordinator does not).
- [ ] **Behavioral guardrails:** `SOUL.md` exists. NEVER DO section has domain-specific rules with stated consequences. Escalation policy names numeric thresholds.
- [ ] **Mechanical guardrails:** `approvals.mode` is set (not `off` unless intentional). `command_allowlist` is reviewed.
- [ ] **Governance level documented:** Team knows which L1-L4 level this agent operates at and why.

### 6.5 Key Vocabulary

| Term | Definition |
|---|---|
| SOUL.md | Agent identity file — role, behavior rules, escalation policy. Loaded at startup. |
| SKILL.md | Machine-readable runbook — when to use, how to collect data (Scripts Zone), how to reason (Agents Zone), never do, escalation |
| Scripts Zone | Phase of a skill that runs deterministic CLI commands. No reasoning. No decisions. |
| Agents Zone | Phase of a skill that applies IF/THEN/ELSE reasoning to collected data. No new CLI commands. |
| DANGEROUS_PATTERNS | Regex list in `tools/approval.py`. Any matching command is blocked pending approval. |
| platform_toolsets | Config key controlling which tool categories are available to this agent. |
| HERMES_LAB_MODE | Env var that controls mock vs live routing in wrapper scripts. |
| ReAct loop | Observe → Think → Act → Observe pattern implemented in `run_agent.py` AIAgent class. |
| delegation | Fleet coordinator capability: routing work to specialist subagents instead of executing directly. |
| command_allowlist | Permanent approval list for pre-approved command patterns (L4 governance). |
| max_turns | Loop termination limit from `config.yaml`; prevents runaway agents |
| agentskills.io | Cross-platform SKILL.md specification (Dec 2025) — skills portable across 30+ frameworks |

### 6.6 Governance Levels at a Glance

| Level | Name | Terminal | Approval Mode | Allowlist | Profile |
|---|---|---|---|---|---|
| L1 | Assistive | No | manual (moot) | Empty | Read-only advisory agents |
| L2 | Advisory | Yes | manual | Empty | Domain specialist agents (course default) |
| L3 | Proposal | Yes | smart | Empty | Agents with smart approval for reduced fatigue |
| L4 | Semi-autonomous | Yes | smart | Populated | Trusted production agents with known-safe commands |

**Promotion criteria:** Move from L2 to L3 after demonstrating correct DANGEROUS_PATTERNS assessment in at least 5 sessions. Move from L3 to L4 only after a formal review of the proposed allowlist patterns — each entry must be justified.

See `course/governance/governance-L1.yaml` through `course/governance/governance-L4-track-a.yaml` for the YAML fragments implementing each level. The progression is additive: each level adds or changes one key from the previous level.
