# Hermes Tool Integration Patterns: CLI, MCP, and Wrappers

**Purpose:** This document explains WHY the Hermes tool architecture is designed the way it is — the reasoning behind CLI tools, MCP tools, and the mock wrapper pattern, and how safety configuration layers interact with tool access. This is the reference for understanding what tools your agents can use, how to configure that access, and why certain boundaries are enforced.

---

## Table of Contents

1. [What Is a Tool in an Agent Context?](#1-what-is-a-tool-in-an-agent-context)
2. [Three Tool Integration Patterns](#2-three-tool-integration-patterns)
3. [The Hermes Tool Architecture](#3-the-hermes-tool-architecture)
4. [DevOps Tool Integration Examples](#4-devops-tool-integration-examples)
5. [Course Examples — File References](#5-course-examples--file-references)
6. [Quick Reference](#6-quick-reference)

---

## 1. What Is a Tool in an Agent Context?

### 1.1 The Definition

A tool is anything an agent can call to interact with the outside world: run a command, read a file, call an API, query a service, or delegate work to another agent. Tools are the only mechanism by which an agent affects or observes the environment outside its context window.

This definition has an important implication: an agent without tools is a chatbot. It can reason about infrastructure all day but cannot observe real state, run diagnostics, or execute changes. Tools are what make an agent operational rather than advisory.

### 1.2 Why Tool Boundaries Matter for Governance

The governance question "what can this agent do?" is answered entirely by which tools are available to it. You do not control agent behavior by writing clever prompts. You control it by controlling tool access:

- Remove `terminal` from `platform_toolsets.cli` → agent cannot run any shell commands, regardless of what it decides
- Add `terminal` but set `approvals.mode: manual` → agent can run shell commands, but DANGEROUS_PATTERNS-matching commands require human approval
- Set `command_allowlist: ["SELECT", "EXPLAIN"]` → specific patterns are pre-approved at L4 governance

This is why `platform_toolsets.cli` is the first thing to review when evaluating an agent's governance posture. Tool access is the mechanical boundary. SOUL.md NEVER rules are the behavioral boundary. Both must be reviewed together — but the mechanical boundary is easier to audit and harder to accidentally override.

### 1.3 Tool Discovery vs Tool Invocation

The agent interacts with tools in two distinct phases:

**Discovery:** At session startup, the tool registry builds a list of all available tools (those whose toolset is in `platform_toolsets.cli` AND whose `check_fn()` returns True). This list is expressed as JSON Schema function definitions and passed to the LLM in the `tools` parameter of every API call. The Brain "knows" what tools exist because they are in its context.

**Invocation:** During the agent loop, the LLM emits a `tool_call` object specifying the tool name and arguments. The registry's `dispatch()` method routes this to the correct handler. The handler executes, returns a result string, and the loop continues.

The separation matters because it means: the agent cannot call a tool that is not in its schema list. Even if the Brain generates text that looks like a tool call to a non-registered tool, the registry returns `{"error": "Unknown tool: ..."}`. This is not a bug — it is the enforcement mechanism for tool-based governance.

### 1.4 Delegation as a Tool

In the fleet coordinator pattern, `delegate_task` is a tool. Routing work to a specialist agent is mechanically identical to calling `terminal_tool` or `web_search` — it is a registered tool in the registry, with a schema, a handler, and a dispatch path.

This design choice has important implications:
- Delegation limits (`MAX_DEPTH`, `MAX_CONCURRENT_CHILDREN`) are enforceable the same way DANGEROUS_PATTERNS are — at the tool execution layer
- A coordinator with no `terminal` in its toolset cannot accidentally start executing commands: it can only call `delegate_task`, `web_search`, and `skills_search`
- Delegation traces are auditable in the same format as tool calls — each `delegate_task` call is a logged tool invocation with inputs and outputs

---

## 2. Three Tool Integration Patterns

### 2.1 Pattern 1: CLI Tools via Terminal Toolset

**What it is:** The agent runs shell commands directly, using the `terminal_tool` registered in the `terminal` toolset. Any command that can be executed in a shell can be run by the agent: `aws`, `kubectl`, `psql`, `curl`, `grep`, `terraform`, `ansible`, etc.

**When to use it:**
- Any standard DevOps CLI tool that the environment has installed
- Commands with well-known output formats (AWS JSON responses, kubectl YAML/JSON, psql CSV)
- Operations that map directly to existing operational procedures in SKILL.md

**How to configure it:**
```yaml
platform_toolsets:
  cli: [terminal, file, web, skills]
```
The presence of `terminal` in the list enables the agent to execute shell commands.

**What it enables vs what it does not:**
CLI tools give the agent general command execution capability. This is powerful and general. What it does NOT do:
- Provide structured input validation (the agent must format commands correctly)
- Guarantee output parsing (the agent must interpret CLI output from the context)
- Enforce safe operations (that is the job of DANGEROUS_PATTERNS and SOUL.md)

**The tradeoff:**
CLI is the lowest-friction integration pattern. Any tool your team already uses can be called by the agent without writing adapter code. The cost is that CLI tools have no type safety, no versioned API contract, and no structured output guarantee. The agent must interpret the output based on its training knowledge and the expected output blocks in SKILL.md.

### 2.2 Pattern 2: MCP (Model Context Protocol) Tools

**What it is:** The agent calls a structured external service that implements the MCP protocol (Model Context Protocol, standardized by Anthropic in late 2024). MCP servers expose typed function interfaces — the agent calls a function with typed inputs and receives a typed output, rather than running a shell command and parsing text.

**When to use it:**
- Complex integrations that benefit from structured I/O (observability platforms, ticketing systems, notification services)
- Services where you want a versioned API contract that is stable across agent updates
- When you want to wrap a complex multi-step workflow (multiple API calls, authentication, pagination) behind a single clean tool interface
- When you want to share tools across multiple agent frameworks — MCP is a cross-platform protocol

**How it works:**
An MCP server is a process that the agent connects to over a socket or HTTP. The server exposes a `tools/list` endpoint that returns tool schemas. Hermes's MCP client (registered in the `mcp` toolset) discovers available tools from connected MCP servers and registers them in the same `ToolRegistry` used for CLI tools. From the Brain's perspective, MCP tools and CLI tools look identical — both appear as function schemas in the tool list.

The key difference: when an MCP tool is called, the registry routes it to the MCP client handler, which makes a structured request to the MCP server. The server handles execution. The MCP server can be running locally, on a remote machine, or as a cloud service.

**In the Hermes configuration:**
MCP server connections are configured in `config.yaml` under `mcp_servers`. Tools discovered from connected servers are available when `mcp` is in `platform_toolsets.cli`.

**The tradeoff:**
MCP provides better structure, versioning, and reusability than CLI tools. The cost is setup complexity: you need a running MCP server, a connection configuration, and the server must implement the protocol correctly. For simple DevOps CLI tools that already work well from the command line, MCP adds overhead without significant benefit. For complex integrations (PagerDuty, Datadog, Slack), MCP is the right choice.

### 2.3 Pattern 3: Mock Wrapper Scripts

**What it is:** A thin shell script placed earlier in `PATH` than the real CLI tool. The wrapper intercepts calls to the CLI tool (e.g., `aws`, `psql`, `kubectl`) and routes them either to pre-baked mock data files or to the real tool, based on an environment variable (`HERMES_LAB_MODE`).

**When to use it:**
- Lab environments where real infrastructure is not available (offline workshops, free-tier constraints)
- Testing agent behavior against specific scenarios without a live system
- Simulating failure scenarios that would be unsafe or expensive to reproduce on real infrastructure (e.g., a database under heavy load, a cost anomaly spike)
- Demonstrations that need to be reproducible regardless of network connectivity or account access

**How it works:**

The mock wrapper pattern (from `course/infrastructure/wrappers/`) uses a simple routing mechanism:

```bash
if [[ "$HERMES_LAB_MODE" != "mock" ]]; then
  exec "$(command -v aws)" "$@"   # pass through to real aws CLI
fi
# MOCK MODE: serve pre-baked JSON
case "$1 $2" in
  "rds describe-db-instances")
    cat "$MOCK_DATA_DIR/rds/describe-db-instances.json"
    ;;
  "ce get-cost-and-usage")
    cat "$MOCK_DATA_DIR/cost-explorer/normal-spend.json"
    ;;
  ...
esac
```

The agent never knows it is in mock mode (unless it reads the mock banner printed to stderr). It runs the same `aws rds describe-db-instances` command it would run in live mode. The wrapper transparently substitutes mock data.

**The scenario selection mechanism:**

Mock wrappers support a second environment variable, `HERMES_LAB_SCENARIO`:

```bash
SCENARIO="${HERMES_LAB_SCENARIO:-clean}"
# ...
if [[ "$SCENARIO" == "messy" ]]; then
  cat "$MOCK_DATA_DIR/rds/describe-db-instances-slow.json"
else
  cat "$MOCK_DATA_DIR/rds/describe-db-instances.json"
fi
```

This allows instructors and participants to switch between a clean baseline scenario (`clean`) and a problematic scenario (`messy`) without changing any agent configuration. The mock data files encode specific failure states that the agent must correctly diagnose.

**Why not LocalStack?**

LocalStack Community Edition reached end-of-life on March 23, 2026, and now requires account creation even for non-commercial use. More importantly, LocalStack does not support all the services used in this course (RDS, Cost Explorer) on the free tier. The mock wrapper pattern is:
- Zero dependency (just bash + pre-existing JSON files)
- Works offline
- Perfectly reproducible (JSON files are checked in with the course)
- Easy to extend (add a new `case` branch for a new command)

The tradeoff: mock wrappers only simulate the specific commands coded into the `case` statement. An agent that runs a command outside the mock's coverage gets a `MOCK ERROR: No mock defined for...` response, which is a clear signal that the mock needs to be extended — not a mysterious failure.

### 2.4 Choosing the Right Pattern

**Use CLI tools when:** The tool already exists as a CLI binary that your team uses operationally. Standard DevOps tools (aws, kubectl, psql, terraform, helm, curl) all fall here. No additional setup required beyond `platform_toolsets.cli: [terminal, ...]`.

**Use MCP when:** You need structured I/O that a CLI tool cannot provide cleanly, or when you want to reuse the same integration across multiple agent frameworks. Consider MCP for observability platforms, ticketing systems, or any integration that requires authentication token management, pagination, or complex request/response structures.

**Use wrappers when:** You are in a lab environment, testing environment, or demonstration environment where real infrastructure is not available or not appropriate. Wrappers are also the right choice for smoke testing: `HERMES_LAB_MODE=mock` lets you verify the skill procedure is correct before running it against real infrastructure.

**Combine patterns:** Production agents typically use CLI (direct tools) in live mode and wrappers (CLI interception) in test/demo mode. The `HERMES_LAB_MODE` env var controls which path is taken at runtime, without changing agent configuration. This combination gives you the best of both: real CLI integration for production, reliable mock data for testing.

---

## 3. The Hermes Tool Architecture

### 3.1 How tools/registry.py Enables Tool Discovery

The `ToolRegistry` class in `tools/registry.py` is the single source of truth for all tool metadata. It implements the singleton pattern (`registry = ToolRegistry()` at module level) so all tool files share the same registry instance.

Tool files call `registry.register()` at module import time:

```python
registry.register(
    name="terminal_command",
    toolset="terminal",
    schema={
        "name": "terminal_command",
        "description": "Execute a shell command...",
        "parameters": {
            "type": "object",
            "properties": {
                "command": {"type": "string", "description": "The shell command to execute"}
            },
            "required": ["command"]
        }
    },
    handler=execute_terminal_command,
    check_fn=lambda: shutil.which("bash") is not None,
    requires_env=[],
    is_async=False,
)
```

At session startup, `model_tools.py` imports all tool modules (triggering their `register()` calls), then calls `registry.get_definitions(enabled_tool_names)` to retrieve JSON Schemas for the tools whose toolsets match `platform_toolsets.cli`. These schemas become the `tools` parameter in every LLM API call.

The `check_fn` is called before including a tool in the schema list. Tools whose `check_fn()` returns False are excluded — their name never appears in the LLM's context. This is how environment-dependent tools (tools requiring specific env vars, specific binaries, or specific connectivity) are safely excluded from agents that do not have those prerequisites.

### 3.2 Platform Toolsets: What Each Enables

The `platform_toolsets.cli` list in `config.yaml` controls which logical tool groups are available:

| Toolset | What it enables | Typical use |
|---|---|---|
| `terminal` | Shell command execution (`terminal_command`, `execute_script`) | Domain specialist agents running CLI tools |
| `file` | File read/write/create/search (`read_file`, `write_file`, `search_files`) | Agents that need to read config files, write reports, or create output files |
| `web` | Web search and page retrieval (`web_search`, `read_webpage`) | Any agent that may need to look up documentation, check external APIs, or verify public information |
| `skills` | Skills discovery (`skills_search`) | Agents with a large skill library that need to dynamically select the right skill |
| `mcp` | All tools from connected MCP servers | Agents using structured external integrations |
| `memory` | Cross-session memory storage/retrieval | Agents that need to persist findings across multiple sessions |
| `delegate` | Subagent delegation (`delegate_task`) | Fleet coordinator and multi-agent orchestration patterns |

**Domain specialist agents** (Track A, B, C) use: `[terminal, file, web, skills]`

**Fleet coordinator** uses: `[web, skills]` — no terminal, so it cannot execute commands directly

**Read-only advisor** (L1 governance) uses: `[web, skills]` — same as coordinator, different SOUL.md identity

**The minimum functional set:** An agent needs at least `[terminal, skills]` to run CLI-based diagnostic skills. Remove `terminal` and the agent can read its skills but cannot execute the commands in them.

### 3.3 How Mock Wrappers Work: Environment Variable Routing

The mock wrapper pattern uses `HERMES_LAB_MODE` as a routing variable that changes the behavior of CLI tools at the OS level, below the agent framework. This is the key design insight: the agent does not need any knowledge of mock mode. The environment itself changes what `aws` and `psql` do.

**Setup:**
```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=messy    # or: clean
export PATH="$(pwd)/course/infrastructure/wrappers:$PATH"
```

Adding the `wrappers/` directory at the front of `PATH` ensures that when the agent runs `aws rds describe-db-instances`, the OS finds `wrappers/aws` first and executes the mock wrapper instead of the real AWS CLI.

**Routing logic in mock-aws:**
```bash
LAB_MODE="${HERMES_LAB_MODE:-live}"
if [[ "$LAB_MODE" != "mock" ]]; then
  exec "$(command -v aws)" "$@"   # route to real aws
fi
# MOCK MODE path:
case "$1 $2" in
  "rds describe-db-instances") cat "$MOCK_DATA_DIR/rds/describe-db-instances.json" ;;
  "ce get-cost-and-usage")      cat "$MOCK_DATA_DIR/cost-explorer/normal-spend.json" ;;
  ...
esac
```

**The mock banner:**

Mock wrappers print a visible banner to stderr:
```
╔══════════════════════════════════════════╗
║            [ MOCK MODE ]                 ║
║   Data source: pre-baked JSON files      ║
║   Set HERMES_LAB_MODE=live for real AWS  ║
╚══════════════════════════════════════════╝
```

This banner serves two purposes: participants can visually confirm they are in mock mode, and agents' SOUL.md (for Track A, Aria) includes a rule to "confirm HERMES_LAB_MODE before every session: state MOCK or LIVE clearly in your first line." The banner makes the mode unambiguous.

**Per-session env var:**

`HERMES_LAB_MODE` is documented as a per-session environment variable (set in the terminal session before launching Hermes) rather than a persistent configuration key. This is intentional: making it persistent (e.g., in `~/.hermes/.env`) risks accidentally keeping mock mode active in production use. Setting it per-session requires an explicit decision at the start of each diagnostic session.

### 3.4 DANGEROUS_PATTERNS: The Mechanical Safety Gate

`tools/approval.py` implements the mechanical guardrail layer. Before any terminal command executes, `check_all_command_guards(command, env_type)` runs. This function:

1. Normalizes the command (strips ANSI escapes, null bytes, Unicode homoglyphs — obfuscation bypass prevention)
2. Runs the normalized command against each pattern in `DANGEROUS_PATTERNS`
3. If a match is found, checks if the pattern is already approved for this session
4. If not approved, applies the approval mode behavior (`manual`, `smart`, or `off`)

The DANGEROUS_PATTERNS list includes approximately 30 patterns covering:

| Category | Example patterns |
|---|---|
| Destructive filesystem | `rm -rf`, `rm -r`, `find -delete`, `xargs rm` |
| Database destruction | `DROP TABLE`, `DROP DATABASE`, `TRUNCATE TABLE`, `DELETE FROM` (without WHERE) |
| System file writes | `> /etc/`, `tee /etc/`, `sed -i /etc/`, `cp ... /etc/` |
| System service control | `systemctl stop`, `systemctl disable`, `systemctl mask` |
| Process termination | `kill -9 -1` (all processes), `pkill -9` |
| Remote code execution | `curl ... | bash`, `wget ... | sh` |
| Shell injection | `bash -c`, `python -c`, `bash -lc` |
| Sensitive path writes | `~/.ssh/`, `~/.hermes/.env` |
| Self-termination | `pkill hermes`, `killall gateway` |

**What is NOT in DANGEROUS_PATTERNS:**

By design, some commands that could cause damage in the wrong context are NOT in the list. Examples relevant to course agents:
- `kubectl delete pod`, `kubectl drain`, `kubectl cordon` — not in the list; safety is behavioral (SOUL.md NEVER rules)
- `aws ec2 terminate-instances` — not in the list; safety is behavioral
- `CREATE INDEX`, `ALTER TABLE` — not in the list; safety is behavioral
- `aws rds modify-db-instance` — not in the list; safety is behavioral

This separation is intentional and pedagogically important. DANGEROUS_PATTERNS covers commands that are catastrophically, universally dangerous. Domain-specific dangerous commands (dangerous in context, but potentially legitimate in other contexts) are handled by SOUL.md NEVER rules. The two-layer model keeps DANGEROUS_PATTERNS focused on clear-cut cases and teaches participants that behavioral safety (SOUL.md) must complement mechanical safety.

### 3.5 Approval Modes: Manual, Smart, Off

When DANGEROUS_PATTERNS detects a match, the `approvals.mode` from `config.yaml` determines the response:

**`manual` (L2 governance):**
The agent thread blocks. The user sees an interactive prompt:
```
⚠️  DANGEROUS COMMAND: SQL DROP
    DROP TABLE users
    [o]nce  |  [s]ession  |  [a]lways  |  [d]eny
```
- `once`: approve this instance only; future matches of the same pattern require re-approval
- `session`: approve for the duration of this Hermes session
- `always`: add to `command_allowlist` in config (permanent, survives session restart)
- `deny`: block the command; the agent receives `{"approved": False, "message": "BLOCKED: User denied..."}` and must report it cannot proceed

The 5-minute timeout (`timeout: 300`) is important for lab flows with multiple approval steps — without it, the agent would be blocked indefinitely waiting for approval input.

**`smart` (L3 governance):**
An auxiliary LLM (Haiku-tier, configured in `agent/auxiliary_client.py`) reviews the flagged command. The review prompt asks: "Is this command actually dangerous, or is it a false positive?" The auxiliary model responds APPROVE, DENY, or ESCALATE:

- APPROVE: command is a false positive (e.g., `python -c "print('hello')"` matching the `-c flag` pattern). Auto-approved, session-level.
- DENY: command is genuinely dangerous. Blocked without user prompt.
- ESCALATE: uncertain. Falls through to manual prompt.

Smart mode reduces approval fatigue in diagnostic scenarios where the agent runs many commands that happen to match patterns but are operationally safe. The auxiliary LLM filters out false positives before they interrupt the operator.

**`off` (no guardrails):**
All DANGEROUS_PATTERNS checks are skipped. The agent executes any command the Brain decides. Appropriate only for trusted local development environments. The YOLO mode flag (`HERMES_YOLO_MODE=1`) achieves the same effect at runtime without changing config.

### 3.6 Fleet Delegation: Tools for Multi-Agent Coordination

The `delegate_task` tool (registered in the `delegate` toolset) enables fleet coordinator patterns. When a coordinator calls `delegate_task`, it:

1. Creates a new Hermes agent instance using the specified profile
2. Passes context (the coordinator's findings so far, the specific subtask to execute)
3. Runs the subagent to completion
4. Returns the subagent's final response to the coordinator
5. The coordinator synthesizes results from all delegates into a unified finding

**Delegation safety controls:**

- `MAX_DEPTH`: maximum recursion depth for subagent delegation (prevents infinite delegation chains)
- `MAX_CONCURRENT_CHILDREN`: limits parallel subagent spawning (prevents resource exhaustion)
- `DELEGATE_BLOCKED_TOOLS`: tools the subagent is not allowed to use, regardless of its profile config (allows coordinator to apply additional restrictions to delegated work)

These limits are enforced at the `delegate_task` handler level — not in the coordinator's config, but in the implementation. This is a defense-in-depth measure: even if a coordinator's SOUL.md allows unlimited delegation, the tool handler enforces resource caps.

**Why coordinator has no skills/ directory:**

A coordinator with domain skills in `skills/` would start applying those skills directly instead of delegating to specialists. If the coordinator has a `dba-rds-slow-query` skill loaded, it has all the information needed to run the diagnostic itself — and it will. Keeping `skills/` empty in the coordinator profile forces it to delegate, which keeps specialist logic in specialist agents where it can be independently governed and audited.

See `course/agents/fleet-coordinator/config.yaml` for the complete coordinator configuration showing `delegation:` block without any `skills/` directory.

---

## 4. DevOps Tool Integration Examples

### 4.1 CLI Pattern: Track A Agent Running mock-psql

Track A's Aria agent runs `psql` queries as part of the `dba-rds-slow-query` skill procedure (Phase 1, Steps 1.3 and 1.4). The tool call from the Brain looks like:

```json
{
  "name": "terminal_command",
  "arguments": {
    "command": "psql -h $DB_HOST -p 5432 -U $DB_USER -d $DB_NAME --csv -c \"SELECT mean_exec_time_ms, total_exec_time_ms, calls, LEFT(query,200) as query FROM pg_stat_statements WHERE mean_exec_time_ms > 1000 ORDER BY mean_exec_time_ms DESC LIMIT 20\""
  }
}
```

The registry routes this to `terminal_tool`'s handler. `check_all_command_guards()` runs — `psql` queries do not match DANGEROUS_PATTERNS (no DROP, no DELETE without WHERE). The command executes.

In mock mode, the OS finds `course/infrastructure/wrappers/mock-psql` in PATH before the real `psql`. The wrapper detects `pg_stat_statements` in the query string and routes to the appropriate mock data file based on `HERMES_LAB_SCENARIO`.

In live mode, the same command hits the real RDS instance via the psql CLI. No change to the agent configuration or SKILL.md is required.

### 4.2 Mock-psql Routing Logic

The routing logic in `course/infrastructure/wrappers/mock-psql` parses the `-c` argument to detect the query intent:

```bash
QUERY_LOWER=$(printf '%s' "$QUERY" | tr '[:upper:]' '[:lower:]')

if printf '%s' "$QUERY_LOWER" | grep -q "pg_stat_statements"; then
  if [[ "$SCENARIO" == "messy" ]]; then
    python3 -c "
import json, sys
data = json.load(open('$MOCK_DATA_DIR/rds/pg-stat-statements-messy.json'))
print('mean_time_ms,total_time_ms,calls,rows_per_call,query')
for row in data:
    q = row['query'].replace('\"', '\"\"')
    print(str(row['mean_exec_time_ms']) + ',' + str(row['total_exec_time_ms']) + ',' + str(row['calls']) + ',' + str(row['rows_per_call']) + ',\"' + q + '\"')
"
  else
    # clean scenario
    python3 -c "
import json, sys
data = json.load(open('$MOCK_DATA_DIR/rds/pg-stat-statements-clean.json'))
..."
  fi
elif printf '%s' "$QUERY_LOWER" | grep -q "pg_stat_user_tables"; then
  printf 'schemaname,table_name,seq_scan,idx_scan,seq_scan_pct\n'
  printf 'public,users,8420,312,96.43\n'
  ...
```

The wrapper produces CSV output in the same format as real psql with `--csv` flag. The agent's skill procedure (and the `**Expected output**` blocks in SKILL.md) are written to match this CSV format.

### 4.3 Fleet Delegation Pattern

The fleet coordinator receives a cross-domain incident report and delegates to three specialists:

```
User: "We have a high-severity incident — database is slow, costs are spiking, and K8s pods are OOMKilling. Investigate."

Coordinator Brain decides:
  → delegate_task to track-a specialist: "Diagnose RDS CPUUtilization and slow query pattern"
  → delegate_task to track-b specialist: "Identify cost spike service and root cause"
  → delegate_task to track-c specialist: "Identify OOMKilled pods and memory pressure source"

[Parallel subagent execution]

Coordinator receives:
  - Track A: "Diagnosis: SLOW_QUERY_INDEX_GAP on orders table. Recommendation: CREATE INDEX CONCURRENTLY..."
  - Track B: "Diagnosis: SERVICE_COST_SPIKE in EC2. Analytics service (deployed 2026-04-02) consuming 3x normal"
  - Track C: "Diagnosis: memory-hog-mno345 pod in analytics namespace hitting memory limit. OOMKilled 7 times in 4h"

Coordinator synthesizes:
  "Cross-domain root cause: analytics service (deployed 2026-04-02) with memory leak causing cascade:
   (1) OOMKills in K8s → pod restart storm → (2) database connection floods on restart → slow queries
   → (3) retry loops in application → EC2 cost spike from increased instance activity"
```

The coordinator does not run any psql queries, aws commands, or kubectl commands. It only calls `delegate_task` and synthesizes the structured results. This is the coordinator pattern: orchestration without execution.

### 4.4 No-Terminal Pattern: L1 Governance

At L1 governance (`course/governance/governance-L1.yaml`):

```yaml
platform_toolsets:
  cli: [web, skills]   # No terminal
```

The agent has `web` (can search the web and read documentation) and `skills` (can search and reference loaded skills). It cannot run any shell commands. When asked to diagnose a slow database, it:

1. Reads the loaded SKILL.md procedure
2. States which commands should be run and what output to expect
3. Asks the operator to run the commands and paste the output
4. Applies the Agents Zone decision tree to the pasted output
5. Produces a diagnosis and recommendation

This is the human-in-the-loop model for operators who do not yet trust the agent with command execution, or in environments where automated command execution requires change management approval. The agent provides the intelligence; the human provides the execution.

The L1 pattern is useful for building initial organizational trust. After demonstrating correct diagnostic behavior with manual execution, teams can promote the agent to L2 (terminal enabled, DANGEROUS_PATTERNS enforced, manual approval gate).

### 4.5 How HERMES_LAB_MODE Affects the Full Toolchain

`HERMES_LAB_MODE` is not a Hermes configuration key — it is an environment variable that the mock wrapper scripts inspect. The routing is done at the OS level, transparent to Hermes. The full chain:

```
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=messy
export PATH="$(pwd)/course/infrastructure/wrappers:$PATH"
hermes -p track-a chat
```

1. `hermes -p track-a chat` starts the agent with the Track A profile
2. Agent loads `config.yaml` — sees `platform_toolsets.cli: [terminal, file, web, skills]`
3. Agent calls `aws rds describe-db-instances` via `terminal_tool`
4. OS resolves `aws` → finds `wrappers/aws` in PATH first
5. `wrappers/aws` checks `HERMES_LAB_MODE=mock` → serves `describe-db-instances.json`
6. Agent receives mock JSON, proceeds with diagnosis
7. Agent calls `psql -c "SELECT ... FROM pg_stat_statements"` via `terminal_tool`
8. OS resolves `psql` → finds `wrappers/mock-psql` in PATH first
9. `wrappers/mock-psql` checks `HERMES_LAB_MODE=mock` AND `HERMES_LAB_SCENARIO=messy` → serves pg-stat-statements-messy.json in CSV
10. Agent receives messy data, applies decision tree, produces diagnosis

Hermes itself is unaware of the mock routing. The same tool calls, the same SKILL.md procedure, the same agent configuration — only the data source changes.

---

## 5. Course Examples — File References

The following files are the canonical examples for each concept covered in this guide. After reading this document, open these files to see the patterns in practice:

**Mock wrapper pattern — AWS:**
`course/infrastructure/wrappers/mock-aws` — The complete mock-aws wrapper. Observe the `case "$1 $2"` routing structure: each two-word subcommand (`rds describe-db-instances`, `ce get-cost-and-usage`, etc.) maps to a specific mock data file. Adding new commands requires adding new `case` branches and new mock JSON files.

**Mock wrapper pattern — PostgreSQL:**
`course/infrastructure/wrappers/mock-psql` — The mock-psql wrapper. Observe the query content detection approach: it parses the `-c` argument and routes based on SQL keywords (`pg_stat_statements`, `pg_stat_user_tables`, `pg_stat_activity`). This pattern handles the fact that psql is called with full query strings, not subcommands.

**Mock wrapper pattern — Kubernetes:**
`course/infrastructure/wrappers/mock-kubectl` — The mock-kubectl wrapper. Uses `${1:-} ${2:-} ${3:-}` argument capture to handle both `kubectl get pods` and `kubectl get pods -o json` with single case branches.

**Complete platform_toolsets configuration (domain specialist):**
`course/agents/track-a-database/config.yaml` — Full L2 agent config with `platform_toolsets.cli: [terminal, file, web, skills]`, `approvals.mode: manual`, and `command_allowlist: []`. This is the baseline domain specialist configuration.

**No-terminal coordinator configuration:**
`course/agents/fleet-coordinator/config.yaml` — Shows `platform_toolsets.cli: [web, skills]` (no terminal) and the `delegation:` config block. Compare with Track A's config to see exactly what the coordinator is and is not able to do.

**Governance safety config progression:**
`course/governance/governance-L1.yaml` through `governance-L3.yaml` — Three YAML fragments showing the key config differences:
- L1: `cli: [web, skills]` (no terminal)
- L2: `cli: [terminal, file, web, skills]` + `approvals.mode: manual`
- L3: same as L2 but `approvals.mode: smart`

`course/governance/governance-L4-track-a.yaml` — L4 adds `command_allowlist: ["SELECT", "EXPLAIN", "SHOW"]` for pre-approved read-only PostgreSQL commands.

**Mechanical guardrail implementation:**
`tools/approval.py` (in the hermes-agent repo) — `DANGEROUS_PATTERNS` list starts at line 68. Each entry is a `(regex_pattern, description_string)` tuple. The `check_all_command_guards()` function (line 645) is the main entry point called by `terminal_tool` before every command execution.

---

## 6. Quick Reference

### 6.1 Three Tool Patterns Comparison

| Pattern | Use Case | Config Key | Example |
|---|---|---|---|
| CLI (terminal toolset) | Standard DevOps CLIs: aws, kubectl, psql, terraform | `platform_toolsets.cli: [terminal, ...]` | Track A running `aws rds describe-db-instances` |
| MCP (mcp toolset) | Structured integrations: observability, ticketing, notification services | `platform_toolsets.cli: [mcp, ...]` + `mcp_servers:` config | Datadog MCP server for metric queries |
| Mock wrappers | Lab environments, testing, offline demos | `HERMES_LAB_MODE=mock` + wrappers in PATH | Track A using mock-aws and mock-psql for offline labs |

### 6.2 platform_toolsets Values and What They Enable

| Toolset | Enables | Required env | Notes |
|---|---|---|---|
| `terminal` | Shell command execution | None (uses system shell) | Gate for all DANGEROUS_PATTERNS checks |
| `file` | File read/write/search | None | Needed for agents that write reports or read configs |
| `web` | Web search and page retrieval | None | Needed for any agent that looks up docs |
| `skills` | Skills search tool | None | Needed when agent has 10+ skills; optional for 1-3 |
| `mcp` | Tools from MCP servers | Depends on servers | Requires `mcp_servers:` config block |
| `memory` | Cross-session memory | None | Enables `remember` and `recall` tools |
| `delegate` | Subagent delegation | None | Required for fleet coordinator pattern |

### 6.3 Safety Config Keys and Their Behavior

| Config Key | Location | Values | What It Controls |
|---|---|---|---|
| `platform_toolsets.cli` | `config.yaml` | Array of toolset names | Which tool categories are visible to the LLM |
| `approvals.mode` | `config.yaml` | `manual`, `smart`, `off` | Behavior when DANGEROUS_PATTERNS match |
| `approvals.timeout` | `config.yaml` | seconds (default: 300) | How long to wait for manual approval before denying |
| `command_allowlist` | `config.yaml` | Array of pattern strings | Patterns permanently pre-approved (L4) |
| `DANGEROUS_PATTERNS` | `tools/approval.py` (code) | Regex list | Commands that trigger the approval gate |
| `HERMES_YOLO_MODE` | env var | `1` / unset | Bypasses all DANGEROUS_PATTERNS checks (dev only) |
| SOUL.md NEVER rules | `SOUL.md` | Free text | Behavioral constraints enforced at the Brain/reasoning level |

### 6.4 HERMES_LAB_MODE Routing Summary

| Variable | Value | Effect |
|---|---|---|
| `HERMES_LAB_MODE` | `mock` | Wrapper intercepts CLI calls → serves mock data from `mock-data/` |
| `HERMES_LAB_MODE` | `live` (default) | Wrapper passes through to real CLI |
| `HERMES_LAB_SCENARIO` | `clean` (default) | Mock serves normal/healthy state data |
| `HERMES_LAB_SCENARIO` | `messy` | Mock serves degraded/anomalous state data (multi-fault scenario) |
| `MOCK_DATA_DIR` | path | Override mock data directory location (default: `../mock-data` relative to wrappers/) |

**Setup pattern for mock mode:**
```bash
export HERMES_LAB_MODE=mock
export HERMES_LAB_SCENARIO=messy
export PATH="$(pwd)/course/infrastructure/wrappers:$PATH"
hermes -p track-a chat
```

**Verify mock mode is active:**
```bash
aws rds describe-db-instances --db-instance-identifier test
# Should show: [ MOCK MODE ] banner + return JSON from mock file
```

### 6.5 Tool Pattern Decision Tree

```
Does the tool exist as a standard CLI binary (aws, kubectl, psql, etc.)?
  YES → Use CLI pattern (terminal toolset)
    Is real infrastructure available in this environment?
      YES → Set HERMES_LAB_MODE=live, use real CLI
      NO → Set HERMES_LAB_MODE=mock, use mock wrapper
    Does a mock wrapper exist for this CLI?
      YES → Add command to existing case statement in wrapper
      NO → Create new wrapper script using mock-aws as template
  NO → Does the service have an MCP server available?
    YES → Use MCP pattern (mcp toolset + mcp_servers config)
    NO → Build a CLI wrapper or MCP adapter first, then use above

Is this a coordination/orchestration task (not domain execution)?
  YES → Use delegation pattern (delegate toolset, no terminal in coordinator config)
  NO → Use domain specialist pattern (terminal + skills in config)
```

### 6.6 Common Configuration Mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Coordinator has `terminal` in toolset | Coordinator runs commands directly instead of delegating | Remove `terminal` from coordinator's `platform_toolsets.cli` |
| `HERMES_LAB_MODE` not set | Wrappers pass through to real CLI; agent hits real AWS | `export HERMES_LAB_MODE=mock` before starting Hermes |
| Wrappers not in PATH | Agent runs real CLI even with HERMES_LAB_MODE=mock | `export PATH="$(pwd)/course/infrastructure/wrappers:$PATH"` |
| `approvals.mode: off` in production config | DANGEROUS_PATTERNS checks bypassed; dangerous commands execute | Set `approvals.mode: manual` or `smart` |
| `command_allowlist` with broad patterns | Pre-approves too many commands; defeats DANGEROUS_PATTERNS | Keep allowlist specific; only add patterns that the team has verified are safe |
| Missing `file` toolset | Agent cannot write diagnostic reports | Add `file` to `platform_toolsets.cli` list |
| Skill not loading | `skills/` directory empty or skill not in subdirectory | Each skill must be in its own subdirectory: `skills/skill-name/SKILL.md` |
