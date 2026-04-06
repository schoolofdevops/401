# My MCP Lab Findings

**Date:** [YYYY-MM-DD]
**Participant:** [Your name]
**Agent Used:** [Claude Code / Crush]
**Module:** 04 — Cross-Platform Intelligence with MCP

---

## Exercise Results

### Exercise 4.1: Kubernetes-Only Query

**Prompt sent:**
```
Check my Kubernetes cluster. List all pods that have been restarted more than once in the last 24 hours. For each pod, show:
- Namespace
- Pod name
- Number of restarts
- Current status (Running, CrashLoopBackOff, etc.)
```

**Agent response:**
```
[Paste the agent's output here]
```

**Time taken:** ___ seconds

**Observations:**
- Which pod(s) had the most restarts? ___
- Any pods in non-Running states? ___

---

### Exercise 4.2: PostgreSQL-Only Query

**Prompt sent:**
```
Query my refapp PostgreSQL database. I want to understand the data:
1. How many records are in the 'events' table?
2. How many records are in the 'items' table?
3. What is the earliest and latest timestamp in the events table?
4. Show me a sample of 5 rows from the events table.
```

**Agent response:**
```
[Paste the agent's output here]
```

**Time taken:** ___ seconds

**Observations:**
- Total events count: ___
- Total items count: ___
- Date range: ___ to ___

---

### Exercise 4.3: Cross-Platform Query — Kubernetes + PostgreSQL

**Prompt sent:**
```
I'm trying to diagnose a potential database connection issue. Help me:

1. List all pods in the 'app' namespace (these are the reference-app services that interact with the database)
2. For each pod, show its restart count and current status
3. Query the refapp PostgreSQL database to show:
   - Total active connections (run: SELECT count(*) FROM pg_stat_activity)
   - How many events were recorded in the last hour
4. Correlate: Did any pod restarts coincide with database connection spikes or drops in event volume?
```

**Agent response:**
```
[Paste the agent's output here]
```

**Time taken:** ___ seconds

**Key finding:** What correlation did the agent identify between pod restarts and database activity?
```
[Your answer]
```

---

### Exercise 4.4: Cross-Platform Query — Kubernetes + PostgreSQL + GitHub

**Prompt sent:**
```
I want to understand if a recent code change caused the pod restart pattern we identified.

1. In Kubernetes, show the latest pod events/status changes (any error events or restarts) from the last 2 hours
2. In PostgreSQL, show if there are any unusual patterns in the events table (e.g., null values, duplicate IDs, data anomalies)
3. In GitHub, search the course repository (use the repo URL from your lab setup) for the 5 most recent commits. Show:
   - Commit message
   - Author
   - Changed files
   - Commit timestamp

4. Correlate: Could any of these code changes explain the pod restarts or data anomalies?
```

**Agent response:**
```
[Paste the agent's output here]
```

**Time taken:** ___ seconds

**Hypothesis:** Based on the three data sources, what is your hypothesis about the root cause?
```
[Your answer]
```

---

## Comparison: Manual vs. MCP Workflow

### How I Would Solve This Manually (Without MCP)

**Step-by-step process I would follow:**

1. `kubectl get pods -n app --context kind-lab`
2. `kubectl describe pod [name] -n app` for restart details
3. `psql -h localhost -p 5433 -U refapp -d refapp` then run SQL queries
4. Open GitHub, search commits manually
5. Correlate findings in a text document
(add or replace with your own steps)

**Estimated time:** ___ minutes

**Where I'd lose time:**
- Switching between tools: ___
- Copy-pasting data: ___
- Remembering syntax: ___
- Correlating findings manually: ___

**Error risk:** [Low / Medium / High]
**Why:** ___

---

### How I Solved It With MCP

**What I actually did:**

1. ___
2. ___
3. ___

**Actual time taken:** ___ minutes

**What the agent did for me:**
- ___
- ___
- ___

**Error risk:** [Low / Medium / High]
**Why:** ___

---

## Time Comparison

| Workflow | Time | Context Switches | Manual Steps |
|----------|------|------------------|--------------|
| Manual (no MCP) | ___ min | ___ | ___ |
| With MCP | ___ min | ___ | ___ |
| **Speedup** | **___ %** | — | — |

---

## Reflection: How MCP Closes the Capabilities Gap

### From Module 03, Recall:

**Platform AI (AWS Bedrock agents, etc.) can:**
- Query CloudWatch metrics
- Recommend scaling strategies
- Understand costs

**Platform AI cannot:**
- Query your database directly
- Access your Kubernetes cluster
- Read your Git history
- Correlate across multiple systems

### Your Observation:

**In 1–2 sentences, describe how MCP filled this gap for you:**

```
[Your answer]
```

**Specific example from your lab:**

```
[Your answer]
```

---

## Key Insights

### Insight 1: One Question, Multiple Tools

**Before MCP:** You had to ask the question in your head, then manually run commands in each tool.
**With MCP:** You ask one question, the agent runs all the tools.

**How this applies to your work:** ___

---

### Insight 2: Integration Is Context Engineering

**What you did:** You wired MCP servers (structured context). You did NOT write clever prompts.

**Why this matters:** Context engineering is scalable. Clever prompts are not.

**Example:** ___

---

### Insight 3: Coordination Without Context-Switching

**What happened in Exercise 4.4:** The agent coordinated between Kubernetes, PostgreSQL, and GitHub without you reading three different outputs and manually comparing them.

**Real-world scenario where you'd use this:** ___

---

## Extending This Lab

### If I had more time, I would:

1. ___
2. ___
3. ___

### For my team:

**Which MCP servers would I want to wire up in production?**

| Server | Why | Use Case |
|--------|-----|----------|
| ___ | ___ | ___ |
| ___ | ___ | ___ |
| ___ | ___ | ___ |

---

## Feedback

### What worked well in this lab:
- ___
- ___

### What was confusing:
- ___
- ___

### What I want to explore next (Modules 05–06):
- ___
