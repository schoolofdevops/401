# Two Paradigms, One Agent: LangGraph vs Hermes

## The Same Agent, Built Two Ways

Both versions do the exact same job: given a Kubernetes namespace, investigate unhealthy pods, pull logs, check deployment history, diagnose the root cause, and recommend fixes.

The difference is **where the intelligence lives**.

---

## At a Glance

| Dimension | LangGraph (Code-Orchestrated) | Hermes (Context-Orchestrated) |
|-----------|-------------------------------|-------------------------------|
| **Files to write** | 1 Python file (~350 lines) | 3 files: SKILL.md + SOUL.md + config.yaml (~220 lines of markdown + YAML) |
| **Language** | Python | Markdown + YAML |
| **Who writes it** | Developer / ML engineer | SRE / DevOps engineer (domain expert) |
| **Orchestration** | You wire the graph: nodes → edges → conditionals | The model reads your procedure and figures out the steps |
| **Tool integration** | Custom Python functions wrapping `subprocess.run()` | Agent runs `kubectl` directly via terminal toolset |
| **State management** | TypedDict schema — you define every field | Model maintains context in its conversation window |
| **Error handling** | You write try/except for every node | Model adapts — if `--previous` flag fails, it tries without it |
| **Governance** | You build it: wrap tools, add approval nodes, wire edges (~100-150 more lines) | Built in: config.yaml sets approval mode, SOUL.md sets NEVER rules, DANGEROUS_PATTERNS catches the rest |
| **Changing behavior** | Change Python code → test → redeploy | Edit the SKILL.md or SOUL.md markdown file |
| **Testing** | pytest with mocked subprocess calls | `HERMES_LAB_MODE=mock` with wrapper scripts (same commands, fake data) |
| **Model dependency** | Any LLM (Claude, GPT, Gemini, Llama) | Tied to models Hermes supports (Claude, via provider config) |
| **Determinism** | High — same input follows same graph path | Lower — model may take slightly different investigation paths |
| **Auditability** | You build logging into each node | Built-in session logs + approval audit trail |

---

## The LangGraph Version: What You're Writing

```
k8s_pod_investigator.py  (~250 lines)
```

You define a **state schema** (every field the agent tracks):

```python
class InvestigationState(TypedDict):
    namespace: str
    pod_status_raw: str
    unhealthy_pods: list[dict]
    pod_logs: dict[str, str]
    recent_deployments: str
    diagnosis: str
    severity: Literal["critical", "warning", "info"]
    recommendations: list[str]
    messages: Annotated[list, add_messages]
```

You write **node functions** (each step of the investigation):

```python
def check_pod_status(state):     # Node 1: run kubectl get pods
def filter_unhealthy_pods(state): # Node 2: parse JSON, find failures
def pull_pod_logs(state):         # Node 3: kubectl logs for each pod
def check_recent_deployments(state): # Node 4: rollout history + events
def generate_diagnosis(state):    # Node 5: send data to LLM for analysis
def format_report(state):         # Node 6: format final output
```

You **wire the graph** (every edge, every branch):

```python
graph.set_entry_point("check_pods")
graph.add_edge("check_pods", "filter_unhealthy")
graph.add_conditional_edges(
    "filter_unhealthy",
    should_continue_investigation,
    {"has_unhealthy": "pull_logs", "all_healthy": "format_healthy"}
)
graph.add_edge("pull_logs", "check_deployments")
graph.add_edge("check_deployments", "diagnose")
graph.add_edge("diagnose", "format_report")
```

You **manually construct the LLM prompt** in the diagnosis node:

```python
system_prompt = """You are a Kubernetes SRE specialist.
Analyze the pod health data and produce a diagnosis.
Respond in this exact JSON format: ..."""
```

And you **parse the LLM response** (hoping it's valid JSON):

```python
try:
    result = json.loads(response.content)
except json.JSONDecodeError:
    # LLM didn't return valid JSON — now what?
```

**To add governance**, you'd need another ~100-150 lines: wrap `run_kubectl` with permission checks, build an approval function, add approval nodes to the graph, wire conditional edges for approved/denied, maintain an audit log.

---

## The Hermes Version: What You're Writing

```
SOUL.md     (~30 lines)  — Who the agent IS
SKILL.md    (~130 lines) — What the agent KNOWS
config.yaml (~20 lines)  — What the agent CAN DO
```

**SOUL.md** — the agent's identity and hard constraints:

```markdown
# Kiran — Kubernetes Pod Health Investigator

**Role:** Kubernetes cluster health diagnosis and self-healing specialist

## Behavior Rules
- Start every diagnosis with: kubectl get pods -n <namespace>
- Cite the exact pod name, namespace, and failure reason code
- NEVER execute kubectl delete without human approval
- NEVER execute kubectl drain — always escalate
```

**SKILL.md** — the investigation procedure:

```markdown
### Phase 1: Collect Cluster State [SCRIPTS ZONE — deterministic]

Step 1.1 — Get all pods in the namespace:
    kubectl get pods -n $NAMESPACE -o json

Step 1.2 — Describe unhealthy pods:
    kubectl describe pod <POD_NAME> -n $NAMESPACE

Step 1.3 — Pull logs:
    kubectl logs <POD_NAME> -n $NAMESPACE --tail=50 --previous

### Phase 2: Diagnose and Recommend [AGENTS ZONE — reasoning]

IF any pod has CrashLoopBackOff:
  Check logs:
    IF OOMKilled → recommend increasing memory limits
    IF connection refused → check dependency health
    IF stack trace → escalate to dev team
```

**config.yaml** — governance in 5 lines:

```yaml
platform_toolsets:
  cli: [terminal, file, web, skills]
approvals:
  mode: manual    # every dangerous command → human approval
command_allowlist: []
```

That's it. No Python. No state schema. No graph wiring. No output parser. No error handling code. The model reads the SKILL.md procedure and executes it step by step, using its reasoning ability to handle edge cases (like retrying without `--previous` if the flag fails).

---

## The Key Insight: Where Does the Intelligence Live?

### LangGraph: Intelligence is in YOUR CODE

```
Your Python code decides:
  → what to do first (entry point)
  → what to do next (edges)
  → when to branch (conditional edges)
  → how to parse data (filter_unhealthy_pods function)
  → what to send to the LLM (prompt construction)
  → how to read LLM output (JSON parsing)

The LLM is a COMPONENT you call at one specific node.
```

### Hermes: Intelligence is in the MODEL + YOUR CONTEXT

```
Your SKILL.md provides:
  → domain knowledge (what kubectl commands to run)
  → decision framework (IF OOMKilled THEN...)
  → output format (report template)
  → safety boundaries (NEVER rules)

The model figures out:
  → execution order (reads Phase 1, runs all commands)
  → error recovery (--previous failed? try without it)
  → data correlation (connects log patterns to event timestamps)
  → report generation (fills the template with actual findings)
```

---

## The Governance Story

This is where the paradigm difference hits hardest.

### LangGraph: Governance is Code You Write

```python
# You need to build ALL of this:

ALLOWED_COMMANDS = {"get", "describe", "logs", "top"}
APPROVAL_REQUIRED = {"delete", "apply", "patch", "drain", "cordon"}
DENIED_COMMANDS = {"delete node", "delete namespace"}

def governed_kubectl(cmd, state):
    verb = cmd[0]
    if verb in DENIED_COMMANDS:
        return "DENIED: This command is not permitted"
    if verb in APPROVAL_REQUIRED:
        approval = wait_for_human_approval(cmd, timeout=300)
        if not approval:
            return "DENIED: Human did not approve within timeout"
        log_approval(cmd, state["session_id"])
    return run_kubectl(cmd)

# Then add approval nodes to the graph...
# Then wire conditional edges for approved/denied...
# Then add audit logging to every node...
# Then handle approval timeouts...
```

Estimated: 100-150 additional lines of Python.

### Hermes: Governance is Configuration + Natural Language

**config.yaml** — one line changes the governance level:

```yaml
# L1: No terminal at all (agent can only suggest)
platform_toolsets:
  cli: [web, skills]

# L2: Terminal enabled, manual approval for dangerous commands
platform_toolsets:
  cli: [terminal, file, web, skills]
approvals:
  mode: manual

# L3: Smart approval (auxiliary LLM auto-approves safe commands)
approvals:
  mode: smart

# L4: Pre-approved patterns bypass the gate
command_allowlist: ["kubectl_read_operations"]
```

**SOUL.md** — domain-specific safety in plain English:

```markdown
- NEVER execute kubectl delete without human approval
- NEVER execute kubectl drain — always escalate
- NEVER modify resource limits without an approved change request
```

**DANGEROUS_PATTERNS** — catches generic destructive commands automatically:
`rm -rf`, `DROP TABLE`, `kill -9`, writes to `/etc/` — all blocked before execution, no code needed.

**Total additional code for governance: 0 lines.** It's already there.

---

## When Each Paradigm Wins

### Choose LangGraph When:

- **Deterministic workflows required:** Regulatory compliance, audit trails where the exact same input must produce the exact same execution path every time
- **Complex state persistence:** Long-running workflows that pause for hours (human approval at 2am, resume at 9am) — LangGraph's checkpointing and time-travel debugging are unmatched
- **Model-agnostic requirement:** You need to swap between Claude, GPT, Gemini, Llama without changing agent code
- **Custom orchestration patterns:** Fan-out/fan-in, parallel branches with merge logic, retry with exponential backoff on specific nodes

### Choose Hermes/Claude Code When:

- **Domain experts build the agents:** Your best SRE shouldn't need to learn Python graph APIs to encode 15 years of K8s troubleshooting knowledge
- **Rapid iteration:** Changing investigation procedure = editing markdown, not redeploying Python
- **Governance is a first-class requirement:** L1-L4 maturity levels, approval gates, audit trails, promotion criteria — all built in
- **Adaptive investigation:** The agent should handle edge cases you didn't anticipate (model figures it out from context)
- **CLI-native workflows:** DevOps tools are already on the PATH — no need to wrap subprocess calls in Python functions

### The Hybrid Reality

In production, many teams use both:

- **Hermes/Claude Code** for domain-specific investigation and troubleshooting agents (SRE-authored, context-engineered)
- **LangGraph** for complex multi-stage pipelines with strict ordering requirements (developer-authored, code-orchestrated)
- **The agent's SKILL.md might even invoke a LangGraph pipeline** as one of its tools — the paradigms compose, they don't conflict

---

## Try It Yourself

### LangGraph Version:

```bash
cd langgraph-version/
pip install langgraph langchain-anthropic
python k8s_pod_investigator.py payments
```

### Hermes Version:

```bash
cp -r hermes-version/ ~/.hermes/profiles/k8s-investigator/
hermes -p k8s-investigator chat
# Then type: "Investigate unhealthy pods in the payments namespace"
```

The Hermes version will run the same `kubectl` commands, but it will:
- Adapt if a command fails (try alternative approaches)
- Ask for approval before any destructive action
- Produce a structured report following the SKILL.md template
- Log every action for audit

The LangGraph version will follow the exact graph you wired — no more, no less.

---

## The Context Engineering Connection

This comparison illustrates the core philosophy of this course: **context engineering > prompt engineering**.

The SKILL.md file IS the context engineering artifact. It encodes 15 years of SRE knowledge — the exact commands to run, the decision trees for diagnosis, the escalation thresholds — into structured context that the model consumes. The person writing the SKILL.md doesn't need to know Python, graph theory, or LLM APIs. They need to know Kubernetes.

In the LangGraph paradigm, domain knowledge is scattered across Python functions, prompt strings, and state schemas. In the context-engineered paradigm, domain knowledge is concentrated in a single, readable, editable, version-controllable markdown file.

**The mental model:** LangGraph is writing a detailed playbook for a robot. Hermes is briefing a senior SRE and saying "here's what we know, here are the procedures, here are the boundaries — go investigate."
