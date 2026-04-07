"""
K8s Pod Health Investigator — LangGraph Version
=================================================
An agent that investigates unhealthy pods in a Kubernetes namespace.
Given a namespace, it: checks pod status → finds unhealthy pods →
pulls logs → checks recent deployments → produces a diagnosis.

This is the "Code-Orchestrated" paradigm: YOU wire every step.
"""

import json
import subprocess
from typing import TypedDict, Literal, Annotated
from langgraph.graph import StateGraph, END
from langgraph.graph.message import add_messages
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage, SystemMessage

# ============================================================
# STEP 1: Define State Schema
# In LangGraph, YOU must define every field the agent tracks.
# Miss a field? The data won't flow between nodes.
# ============================================================

class InvestigationState(TypedDict):
    """State that flows through the investigation graph."""
    namespace: str
    pod_status_raw: str           # raw kubectl output
    unhealthy_pods: list[dict]    # parsed unhealthy pod info
    pod_logs: dict[str, str]      # pod_name -> last 50 log lines
    recent_deployments: str       # raw kubectl rollout output
    diagnosis: str                # LLM-generated diagnosis
    severity: Literal["critical", "warning", "info"]
    recommendations: list[str]    # action items
    messages: Annotated[list, add_messages]


# ============================================================
# STEP 2: Define Tool Functions
# Each tool is a Python function YOU write and maintain.
# ============================================================

def run_kubectl(cmd: list[str]) -> str:
    """Execute a kubectl command and return output."""
    try:
        result = subprocess.run(
            ["kubectl"] + cmd,
            capture_output=True, text=True, timeout=30
        )
        if result.returncode != 0:
            return f"ERROR: {result.stderr}"
        return result.stdout
    except subprocess.TimeoutExpired:
        return "ERROR: kubectl command timed out after 30s"
    except FileNotFoundError:
        return "ERROR: kubectl not found in PATH"


# ============================================================
# STEP 3: Define Graph Nodes
# Each node is a function that takes state, does one thing,
# and returns updated state fields. YOU wire the data flow.
# ============================================================

def check_pod_status(state: InvestigationState) -> dict:
    """Node 1: Get all pods in the namespace."""
    namespace = state["namespace"]
    output = run_kubectl([
        "get", "pods",
        "-n", namespace,
        "-o", "json"
    ])
    return {"pod_status_raw": output}


def filter_unhealthy_pods(state: InvestigationState) -> dict:
    """Node 2: Parse pod JSON and find unhealthy ones."""
    try:
        pods_data = json.loads(state["pod_status_raw"])
    except json.JSONDecodeError:
        return {"unhealthy_pods": []}

    unhealthy = []
    for pod in pods_data.get("items", []):
        name = pod["metadata"]["name"]
        phase = pod["status"].get("phase", "Unknown")

        # Check container statuses for CrashLoopBackOff, Error, etc.
        for cs in pod["status"].get("containerStatuses", []):
            ready = cs.get("ready", False)
            restart_count = cs.get("restartCount", 0)
            waiting = cs.get("state", {}).get("waiting", {})
            waiting_reason = waiting.get("reason", "")

            if not ready or restart_count > 3 or \
               waiting_reason in ("CrashLoopBackOff", "ImagePullBackOff",
                                  "ErrImagePull", "OOMKilled"):
                unhealthy.append({
                    "name": name,
                    "phase": phase,
                    "ready": ready,
                    "restart_count": restart_count,
                    "waiting_reason": waiting_reason,
                    "container": cs["name"]
                })

    return {"unhealthy_pods": unhealthy}


def pull_pod_logs(state: InvestigationState) -> dict:
    """Node 3: Pull last 50 log lines for each unhealthy pod."""
    logs = {}
    for pod in state["unhealthy_pods"]:
        pod_name = pod["name"]
        container = pod["container"]
        namespace = state["namespace"]

        output = run_kubectl([
            "logs", pod_name,
            "-n", namespace,
            "-c", container,
            "--tail=50",
            "--previous"   # get logs from crashed container
        ])

        # If --previous fails (no previous), try current
        if "ERROR" in output:
            output = run_kubectl([
                "logs", pod_name,
                "-n", namespace,
                "-c", container,
                "--tail=50"
            ])

        logs[pod_name] = output

    return {"pod_logs": logs}


def check_recent_deployments(state: InvestigationState) -> dict:
    """Node 4: Check recent rollout history for context."""
    namespace = state["namespace"]

    # Get deployments in the namespace
    deployments = run_kubectl([
        "get", "deployments",
        "-n", namespace,
        "-o", "json"
    ])

    # Get recent events (often reveals why pods are failing)
    events = run_kubectl([
        "get", "events",
        "-n", namespace,
        "--sort-by=.lastTimestamp",
        "--field-selector", "type!=Normal"
    ])

    combined = f"=== DEPLOYMENTS ===\n{deployments}\n\n=== RECENT EVENTS ===\n{events}"
    return {"recent_deployments": combined}


def generate_diagnosis(state: InvestigationState) -> dict:
    """Node 5: Use LLM to analyze all collected data."""
    llm = ChatAnthropic(model="claude-sonnet-4-20250514")

    # YOU must construct the prompt manually
    # YOU must decide what context to include
    # YOU must parse the response into structured fields
    system_prompt = """You are a Kubernetes SRE specialist.
Analyze the pod health data and produce a diagnosis.

Respond in this exact JSON format:
{
    "severity": "critical|warning|info",
    "diagnosis": "one paragraph root cause analysis",
    "recommendations": ["action 1", "action 2", ...]
}

Severity guide:
- critical: data loss risk, service down, CrashLoopBackOff with OOM
- warning: degraded performance, high restart counts, image pull issues
- info: minor issues, pods recovering on their own
"""

    # Assemble the investigation data for the LLM
    investigation_data = f"""
## Namespace: {state['namespace']}

## Unhealthy Pods ({len(state['unhealthy_pods'])} found):
{json.dumps(state['unhealthy_pods'], indent=2)}

## Pod Logs:
"""
    for pod_name, logs in state["pod_logs"].items():
        investigation_data += f"\n### {pod_name}:\n{logs}\n"

    investigation_data += f"\n## Deployment & Events:\n{state['recent_deployments']}"

    response = llm.invoke([
        SystemMessage(content=system_prompt),
        HumanMessage(content=investigation_data)
    ])

    # YOU must parse the LLM response — hope it's valid JSON!
    try:
        result = json.loads(response.content)
        return {
            "severity": result.get("severity", "info"),
            "diagnosis": result.get("diagnosis", "Unable to determine"),
            "recommendations": result.get("recommendations", [])
        }
    except json.JSONDecodeError:
        # LLM didn't return valid JSON — now what?
        return {
            "severity": "warning",
            "diagnosis": response.content,
            "recommendations": ["Manual investigation needed — LLM response was not structured"]
        }


# ============================================================
# STEP 4: Define Conditional Edges
# YOU must write the routing logic between nodes.
# ============================================================

def should_continue_investigation(state: InvestigationState) -> str:
    """Decide whether to investigate further or report no issues."""
    if not state["unhealthy_pods"]:
        return "all_healthy"
    return "has_unhealthy"


def format_report(state: InvestigationState) -> dict:
    """Terminal node: format the final report."""
    if not state["unhealthy_pods"]:
        report = f"All pods in namespace '{state['namespace']}' are healthy."
    else:
        report = f"""
=== K8S POD HEALTH INVESTIGATION REPORT ===
Namespace: {state['namespace']}
Severity:  {state['severity'].upper()}

DIAGNOSIS:
{state['diagnosis']}

UNHEALTHY PODS:
"""
        for pod in state["unhealthy_pods"]:
            report += f"  - {pod['name']} ({pod['waiting_reason']}, "
            report += f"{pod['restart_count']} restarts)\n"

        report += "\nRECOMMENDATIONS:\n"
        for i, rec in enumerate(state["recommendations"], 1):
            report += f"  {i}. {rec}\n"

    return {"messages": [HumanMessage(content=report)]}


def format_healthy_report(state: InvestigationState) -> dict:
    """Terminal node: all pods healthy."""
    report = f"All pods in namespace '{state['namespace']}' are healthy. No issues found."
    return {"messages": [HumanMessage(content=report)]}


# ============================================================
# STEP 5: Wire the Graph
# THIS is the orchestration — YOU define every edge.
# ============================================================

def build_investigation_graph():
    """Build and compile the LangGraph investigation workflow."""
    graph = StateGraph(InvestigationState)

    # Add nodes
    graph.add_node("check_pods", check_pod_status)
    graph.add_node("filter_unhealthy", filter_unhealthy_pods)
    graph.add_node("pull_logs", pull_pod_logs)
    graph.add_node("check_deployments", check_recent_deployments)
    graph.add_node("diagnose", generate_diagnosis)
    graph.add_node("format_report", format_report)
    graph.add_node("format_healthy", format_healthy_report)

    # Wire edges — YOU decide the flow
    graph.set_entry_point("check_pods")
    graph.add_edge("check_pods", "filter_unhealthy")

    # Conditional: if no unhealthy pods, skip to healthy report
    graph.add_conditional_edges(
        "filter_unhealthy",
        should_continue_investigation,
        {
            "has_unhealthy": "pull_logs",
            "all_healthy": "format_healthy"
        }
    )

    # If unhealthy, continue the investigation pipeline
    graph.add_edge("pull_logs", "check_deployments")
    graph.add_edge("check_deployments", "diagnose")
    graph.add_edge("diagnose", "format_report")
    graph.add_edge("format_report", END)
    graph.add_edge("format_healthy", END)

    return graph.compile()


# ============================================================
# STEP 6: Run It
# ============================================================

if __name__ == "__main__":
    import sys
    namespace = sys.argv[1] if len(sys.argv) > 1 else "default"

    app = build_investigation_graph()
    result = app.invoke({
        "namespace": namespace,
        "pod_status_raw": "",
        "unhealthy_pods": [],
        "pod_logs": {},
        "recent_deployments": "",
        "diagnosis": "",
        "severity": "info",
        "recommendations": [],
        "messages": []
    })

    # Print the last message (the report)
    print(result["messages"][-1].content)


# ============================================================
# STEP 7 (not shown): To add governance, YOU must build it
#
# - Wrap run_kubectl with permission checks
# - Build an approval function for destructive commands
# - Add approval nodes to the graph
# - Wire conditional edges for "approved" vs "denied"
# - Maintain an audit log (another state field, another node)
# - Handle timeouts on approvals
#
# That's probably another 100-150 lines of code.
# ============================================================
