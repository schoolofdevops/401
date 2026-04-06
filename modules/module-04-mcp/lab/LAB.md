# Module 04: Cross-Platform Intelligence with MCP — Hands-On Lab

**Duration:** 50 minutes
**Difficulty:** Beginner (first time wiring MCP servers)
**Prerequisites:** Module 01 complete (KIND cluster running, reference app deployed, PostgreSQL and Prometheus available)
**Deliverable:** 4+ MCP servers connected, cross-platform queries working, findings documented in comparison template

---

## Lab Objective

You will learn that **integration across tools is not manual copy-paste work — it's context engineering.** By connecting four MCP servers (Kubernetes, PostgreSQL, GitHub, Prometheus) and running cross-platform queries, you will experience how a single question can reach five different tools and return an integrated answer.

**Key insight:** MCP is the bridge that removes you as the middleware. You structure the context (which servers, which tools, which restrictions). The agent does the integration. This principle scales to all DevOps domains and forms the foundation for custom agents in Modules 07–13.

---

## What You're Building

You will:
1. Verify your existing Kubernetes MCP server (from Module 01)
2. Install and configure PostgreSQL MCP server (query the reference app database)
3. Install and configure GitHub MCP server (query commit history in the course repo)
4. Install optional Prometheus MCP server (query metrics from your cluster)
5. Run four exercises, starting with single-tool queries and ending with three-tool cross-platform queries
6. Document your findings in a comparison template that connects back to Module 03's capabilities gap

**Deliverables:**
- `.mcp.json` (or Crush `/connect` transcript) showing 4+ servers configured
- Outputs from four cross-platform query exercises
- Completed comparison table: manual workflow vs. MCP workflow
- Reflection on how MCP changes the capabilities gap

---

## Prerequisites

### Tools & Access

You need:
- **KIND cluster running** (from Module 01) with reference app deployed
- **PostgreSQL port-forward** active (reference app database)
- **GitHub personal access token** (read-only, for querying commit history)
- **Claude Code** OR **Crush** installed
- **Node.js 18+** and `npm` (for installing MCP servers)

### Verify Your Setup

Run these commands in your terminal to confirm everything is in place:

```bash
# Check KIND cluster is running
kind get clusters
# Output should show: lab

# Check kubectl access to KIND
kubectl get pods -n app --context kind-lab
# Output should show reference-app pods (api-gateway, catalog, dashboard, worker)

# Check PostgreSQL is accessible (from Module 01 port-forward)
psql -h localhost -p 5433 -U refapp -d refapp -c "SELECT COUNT(*) FROM events;" 2>/dev/null || echo "PostgreSQL not ready yet"
```

If any of these fail, return to Module 01 and complete the setup first.

---

## Part 1: Understanding Your Current MCP Configuration (8 minutes)

### Step 1.1: Check What MCP Servers Are Already Configured

**If you're using Claude Code:**

Open Claude Code and check the `.mcp.json` file in your course project root (the directory you run `claude` from):

```bash
# From your course root directory:
cat .mcp.json
```

**Expected output:** You should see a configuration file with at least one server entry (likely `kubernetes`). If the file doesn't exist, you'll create it in Part 2.

> **Note:** Claude Code uses `.mcp.json` from the current project directory. This is the same file you set up in Module 01. All further edits in this lab go into this same file.

**If you're using Crush:**

Crush stores server connections differently. You'll use the `/connect` command to manage servers. For now, just verify Crush is installed:

```bash
crush --version
# Output should show a version number (e.g., 1.2.3)
```

### Step 1.2: Understand the .mcp.json Structure

If your `.mcp.json` exists, it looks like this:

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["mcp-server-kubernetes"],
      "env": {
        "KUBECONFIG": "/path/to/kubeconfig"
      }
    }
  }
}
```

**Breaking it down:**

| Field | Meaning |
|-------|---------|
| `"kubernetes"` | Server name (you choose this; used to reference the server in conversations) |
| `"command"` | How to run the server (`npx` runs npm packages, or `node`, `python`, etc.) |
| `"args"` | What to run (package name or script path) |
| `"env"` | Environment variables passed to the server (credentials, config paths) |

### Step 1.3: Test Your Existing Kubernetes Server

**If you're using Claude Code:**

Open Claude Code and run this prompt:

```
I need to list all pods in my Kubernetes cluster. Use the kubectl tool to get pod names, namespaces, and their current status.
```

You should see Claude Code call a tool like `kubectl_get_pods` and return a JSON list of pods.

**If you're using Crush:**

First, connect the Kubernetes MCP server:

```bash
crush
# Inside Crush REPL:
/connect mcp-server-kubernetes
# Crush will ask for your kubeconfig path (typically ~/.kube/config)
```

Then ask:

```
List all pods in my cluster
```

Crush should return pod information.

**Checkpoint:** Both tools should successfully query your KIND cluster. If they don't, the issue is likely your `KUBECONFIG` path or kubectl access. Verify by running:

```bash
kubectl get pods --all-namespaces
```

---

## Part 2: Adding PostgreSQL MCP Server (10 minutes)

### Step 2.1: Verify PostgreSQL is Accessible

Before configuring the MCP server, confirm your port-forward is active and the database is reachable:

```bash
# Test connection
psql -h localhost -p 5433 -U refapp -d refapp -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';" 2>&1

# Expected output:
#  table_name
# ─────────────
#  events
#  items
# (2 rows)
```

If this fails with "connection refused", you need to set up the port-forward:

```bash
# Port-forward PostgreSQL from the KIND cluster to localhost:5433
# (port 5433 avoids conflict with any local PostgreSQL installation)
kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &
# Keep this running in the background. Wait 2 seconds for the tunnel to establish.
```

### Step 2.2: Install the PostgreSQL MCP Server

Install the official Anthropic MCP server for PostgreSQL:

```bash
npm install -g @modelcontextprotocol/server-postgres
# Or, if you prefer local install:
npm install @modelcontextprotocol/server-postgres
```

Verify installation:

```bash
npx @modelcontextprotocol/server-postgres --help 2>&1 | head -5
# You should see help output or at least no "command not found" error
```

### Step 2.3: Configure PostgreSQL Server (Claude Code Path)

Edit your `.mcp.json` file in the course project root and add the PostgreSQL server entry:

```bash
# Open the file in your editor (from your course root directory)
nano .mcp.json
```

Add this entry to the `mcpServers` object:

```json
"postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
}
```

> **Important:** The PostgreSQL MCP server takes the connection URL as a positional argument (not environment variables). The format is `postgresql://user:password@host:port/database`.

**Full example** (with Kubernetes and PostgreSQL):

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"],
      "env": {
        "KUBECONFIG": "${HOME}/.kube/config"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
    }
  }
}
```

Save the file (Ctrl+O, Enter, Ctrl+X in nano).

**Restart Claude Code** so it loads the updated configuration.

### Step 2.4: Configure PostgreSQL Server (Crush Path)

The PostgreSQL MCP server takes a connection URL as an argument, so you need to configure it directly in the Crush config file rather than using `/connect`.

Open the Crush config file:

```bash
# Crush config location (may vary by version — run /config inside Crush to confirm)
nano ~/.config/crush/config.toml
```

Add this server block:

```toml
[[servers]]
name = "postgres"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
```

Save the file and restart Crush for changes to take effect.

### Step 2.5: Test PostgreSQL Server

**Claude Code:**

Open Claude Code and run:

```
Query the refapp database. Show me the tables that exist and the schema of the 'events' table (column names and data types).
```

Expected output: Claude should call `sql_query` and return the schema.

**Crush:**

In the Crush REPL:

```
Show me the tables in the refapp database and the schema of the 'events' table
```

Expected output: Table structure with columns.

---

## Part 3: Adding GitHub MCP Server (10 minutes)

### Step 3.1: Create or Retrieve Your GitHub Personal Access Token

You need a GitHub token with read-only access to the course repository.

**If you don't have a token:**

1. Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Name: `agentic-devops-course-lab`
4. Scopes: Check only `repo` (read-only access to public and private repos)
5. Expiration: 30 days (or whatever you're comfortable with)
6. Click "Generate token"
7. **Copy the token immediately** (you won't see it again)

**If you already have a token:**

You can reuse it if it has `repo` scope.

### Step 3.2: Install the GitHub MCP Server

```bash
npm install -g @modelcontextprotocol/server-github
# Or local:
npm install @modelcontextprotocol/server-github
```

### Step 3.3: Configure GitHub Server (Claude Code Path)

Edit your `.mcp.json` in the course project root and add the GitHub entry:

```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN_HERE"
  }
}
```

Replace `ghp_YOUR_TOKEN_HERE` with your actual token.

**Full example** (with Kubernetes, PostgreSQL, and GitHub):

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"],
      "env": {
        "KUBECONFIG": "${HOME}/.kube/config"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN_HERE"
      }
    }
  }
}
```

Save and restart Claude Code.

### Step 3.4: Configure GitHub Server (Crush Path)

In the Crush REPL:

```
/connect @modelcontextprotocol/server-github
```

Crush will ask for:

```
GITHUB_PERSONAL_ACCESS_TOKEN: ghp_YOUR_TOKEN_HERE
```

### Step 3.5: Test GitHub Server

**Claude Code:**

```
Query the Anthropic/anthropic-sdk-python GitHub repository. Show me the 3 most recent commits.
```

Expected output: Claude should call `github_search_repositories` or `github_get_repository` and return recent commits.

**Crush:**

```
Show me recent commits in the Anthropic/anthropic-sdk-python repo
```

---

## Part 4: Cross-Platform Queries (15 minutes)

Now that you have 3+ servers configured (Kubernetes, PostgreSQL, GitHub), you'll run four exercises. Each builds on the previous one.

**Note:** These exercises use your actual KIND cluster, so the exact pod names and database entries may differ from the examples. Adapt the queries to your environment.

### Exercise 4.1: Single-Tool Query — Kubernetes Only

**Goal:** Query only the Kubernetes server. Establish a baseline.

**Your prompt:**

```
Check my Kubernetes cluster. List all pods that have been restarted more than once in the last 24 hours. For each pod, show:
- Namespace
- Pod name
- Number of restarts
- Current status (Running, CrashLoopBackOff, etc.)
```

**What's happening:** The agent uses only the Kubernetes MCP server. It queries pod status and restart counts.

**Expected output:**

```
Pods with multiple restarts:
- Namespace: app
  Pod: reference-app-api-gateway-xyz
  Restarts: 0
  Status: Running

- Namespace: monitoring
  Pod: prometheus-kube-prometheus-stack-prometheus-0
  Restarts: 0
  Status: Running
```

(Your actual output depends on your cluster's pod churn. In a freshly deployed lab cluster, most pods will show 0 restarts — that's a healthy baseline.)

(Your actual output depends on your cluster's pod churn. If all pods have 0 restarts, that's fine — adjust the query to "restarts > 0" or just "all pods".)

**Capture this:** Note the timestamp and pod restart counts. You'll use this in Exercise 4.3.

---

### Exercise 4.2: Single-Tool Query — PostgreSQL Only

**Goal:** Query only the PostgreSQL server. Establish a baseline.

**Your prompt:**

```
Query my refapp PostgreSQL database. I want to understand the data:
1. How many records are in the 'events' table?
2. How many records are in the 'items' table?
3. What is the earliest and latest timestamp in the events table?
4. Show me a sample of 5 rows from the events table.
```

**What's happening:** The agent uses only the PostgreSQL MCP server. It runs SQL queries against your database.

**Expected output:**

```
Events table:
- Total records: 47
- Earliest: 2026-04-05 10:23:15
- Latest: 2026-04-05 14:47:02

Items table:
- Total records: 12

Sample events (5 rows):
[agent returns actual rows from your cluster]
```

**Capture this:** Note the record counts and date range. You'll reference this in Exercise 4.3.

---

### Exercise 4.3: Cross-Platform Query — Kubernetes + PostgreSQL

**Goal:** Ask one question that requires both Kubernetes and PostgreSQL. The agent integrates the answer.

**Your prompt:**

```
I'm trying to diagnose a potential database connection issue. Help me:

1. List all pods in the 'app' namespace (these are the reference-app services that interact with the database)
2. For each pod, show its restart count and current status
3. Query the refapp PostgreSQL database to show:
   - Total active connections (run: SELECT count(*) FROM pg_stat_activity)
   - How many events were recorded in the last hour
4. Correlate: Did any pod restarts coincide with database connection spikes or drops in event volume?
```

**What's happening:** The agent now coordinates between two servers:
- First, it queries Kubernetes for pod status and restarts
- Then, it queries PostgreSQL for connection info and recent vote volume
- Finally, it correlates the findings

This is *integration*. You're not manually running kubectl, then psql, then comparing spreadsheets. The agent does it.

**Expected output structure:**

```
Pod Status (Kubernetes):
- reference-app-api-gateway: 0 restarts, Running
- reference-app-catalog: 0 restarts, Running
- reference-app-worker: 0 restarts, Running
- reference-app-dashboard: 0 restarts, Running

Database Connections (PostgreSQL):
- Current connections: 3 (of 100 max)
- Events in last hour: [count from your cluster]

Correlation Analysis:
[Agent synthesizes: whether pod restarts correlate with DB connection patterns]
```

> **Note:** In a freshly deployed lab cluster, you'll likely see 0 restarts and low connection counts — a healthy baseline. The correlation exercise shows the *pattern* even if there's nothing alarming to find.

**Capture this:** Note how the answer is *synthesized* across two different systems.

---

### Exercise 4.4: Cross-Platform Query — Kubernetes + PostgreSQL + GitHub

**Goal:** Add a third tool. Ask about infrastructure, database state, and code changes.

**Your prompt:**

```
I want to understand if a recent code change caused any pod restarts or data anomalies.

1. In Kubernetes, show the latest pod events/status changes (any error events or restarts) from the 'app' namespace in the last 2 hours
2. In PostgreSQL, show if there are any unusual patterns in the events table (e.g., null values, duplicate IDs, data anomalies)
3. In GitHub, search the course repository (use the repo URL from your lab setup) for the 5 most recent commits. Show:
   - Commit message
   - Author
   - Changed files
   - Commit timestamp

4. Correlate: Could any of these code changes explain the pod restarts or data anomalies?
```

**What's happening:** Three systems. One question. The agent:
1. Pulls pod events from Kubernetes
2. Queries the database for anomalies
3. Searches Git history for recent changes
4. Synthesizes a hypothesis

This is the power of MCP: *you are no longer the integration layer*.

**Expected output structure:**

```
Kubernetes Events (last 2 hours):
- reference-app pods: 0 restarts, all Running (or any actual events from your cluster)

Database Anomalies (PostgreSQL):
- events table: [null count, duplicate check results from your cluster]

GitHub Recent Commits:
- Commit abc1234 (most recent): [your actual latest commit message]
  Author: [committer]
  Files: [changed files]

Correlation Hypothesis:
[Agent synthesizes: whether any commits correlate with cluster events or data anomalies]
```

> **Note:** Your lab cluster is likely clean (fresh deployment, no bugs). The value of this exercise is the *workflow* — one prompt reaching three tools and synthesizing an integrated answer. The pattern is the lesson, not the specific findings.

**Capture this:** This is the full power of MCP. One question, three tools, one integrated answer.

---

## Part 5: Document Your Findings (7 minutes)

### Step 5.1: Open the Starter Template

Find the file `lab/starter/comparison-template.md` in this module:

```bash
cat /path/to/course/modules/module-04-mcp/lab/starter/comparison-template.md
```

Or create a new file `my-findings.md` with this structure:

### Step 5.2: Fill Out the Comparison Table

Use your outputs from Exercises 4.1–4.4 to complete this table:

```markdown
# My MCP Lab Findings

## Exercise 1: Kubernetes-Only Query
**Time taken:** [seconds]
**Complexity:** Single tool, straightforward
**Result:** [paste or summarize output]

## Exercise 2: PostgreSQL-Only Query
**Time taken:** [seconds]
**Complexity:** Single tool, straightforward
**Result:** [paste or summarize output]

## Exercise 3: Kubernetes + PostgreSQL (Cross-Platform)
**Time taken:** [seconds]
**Complexity:** Two tools, agent had to synthesize
**Result:** [paste or summarize output]

## Exercise 4: Kubernetes + PostgreSQL + GitHub (Full Stack)
**Time taken:** [seconds]
**Complexity:** Three tools, correlation required
**Result:** [paste or summarize output]

---

## Manual vs. MCP Workflow

### How I Would Solve This Manually (Without MCP)

**Steps:**
1. Open terminal, run `kubectl get pods -n app --context kind-lab`
2. Copy pod names into a text editor
3. Run `kubectl describe pod [name] -n app` for restart info
4. Open psql terminal: `psql -h localhost -p 5433 -U refapp -d refapp`
5. Run SQL queries manually
6. Context-switch to GitHub web UI, search commits
7. Read commit messages, find files changed
8. Manually correlate findings in a text document

**Time estimate:** 10–15 minutes
**Error surface:** Typos in pod names, SQL syntax, misread timestamps
**Mental load:** High context-switching; easy to miss correlations

### How I Solved It With MCP

**Steps:**
1. Write one prompt asking for the integrated answer
2. Agent queries all three servers
3. Agent correlates results and presents one synthesis

**Time estimate:** 1–2 minutes (agent runs in parallel where possible)
**Error surface:** Low; the agent doesn't typo CLI commands
**Mental load:** Low; you describe the problem, not the solution steps

---

## Reflection: How MCP Closes the Capabilities Gap

In Module 03, we identified the capabilities gap:

**Platform AI can:**
- Understand CloudWatch metrics and costs
- Recommend scaling strategies

**Platform AI cannot:**
- Query your database
- Read your Kubernetes events
- Correlate code changes with infrastructure events

**How MCP closes this gap:**

[Write 2–3 sentences about what you learned. Examples:]
- "MCP lets Claude Code act as the middleware, integrating tools I would normally context-switch between."
- "The difference between asking 'What's wrong?' (without tools) and 'What's wrong? Here's Kubernetes, PostgreSQL, and Git' is transformative."
- "I can now build agents that reason across infrastructure, data, and code — something platform AI alone can't do."

---

## Key Takeaways

**MCP ≠ Magic Prompting**

You didn't write a clever prompt that made Claude smarter. You restructured the *context* — wired tools, defined boundaries, provided self-describing interfaces. Claude's intelligence was constant. Your system design changed.

This is context engineering: building the right container for the agent to reason well.

**Scaling Pattern**

In this lab, you used 3 MCP servers for 4 exercises. In production:
- Module 07–08: You'll build custom MCP servers for proprietary tools
- Module 10–13: You'll chain MCP servers into multi-step agents and automations

The pattern is always the same: structure the context, let the agent integrate.
```

### Step 5.3: Save and Share Your Findings

Save your completed file:

```bash
cp lab/starter/comparison-template.md my-mcp-lab-findings.md
# Edit my-mcp-lab-findings.md with your results
```

---

## Appendix A: Claude Code MCP Configuration Reference

### Full `.mcp.json` Example (3 Servers)

Location: `.mcp.json` in your course project root directory (where you run `claude` from)

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"],
      "env": {
        "KUBECONFIG": "${HOME}/.kube/config"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN_HERE"
      }
    }
  }
}
```

### Key Points

- **KUBECONFIG**: Uses `${HOME}` which Claude Code expands at runtime — no hardcoded path needed
- **PostgreSQL**: Connection URL is passed as a positional argument, not as environment variables
- **GITHUB_PERSONAL_ACCESS_TOKEN**: Use a personal access token with `repo` scope only

> **Note on Prometheus:** The official `@modelcontextprotocol/server-prometheus` package is not yet available on npm (as of April 2026). Prometheus is accessible at `http://localhost:30091` in your lab cluster — you can query it directly via tools that use HTTP. A community Prometheus MCP server may be available; check the [MCP servers registry](https://github.com/modelcontextprotocol/servers) for the latest.

### Creating Config on Each Platform

**macOS/Linux** (from your course root directory):

```bash
nano .mcp.json
```

**Windows (PowerShell)** (from your course root directory):

```powershell
notepad .mcp.json
```

### Restarting Claude Code After Changes

After editing `.mcp.json`, restart Claude Code completely:

1. Close Claude Code
2. Wait 2 seconds
3. Reopen Claude Code
4. Verify servers are connected by running a test query

---

## Appendix B: Crush MCP Configuration Reference

### Installation

```bash
brew install charmbracelet/tap/crush  # macOS
# Or download from https://github.com/charmbracelet/crush
```

### Connecting Servers Interactively

```bash
crush
# Inside the Crush REPL:

/connect mcp-server-kubernetes
# Crush prompts: KUBECONFIG: [enter your kubeconfig path, e.g. ~/.kube/config]

/connect @modelcontextprotocol/server-github
# Crush prompts: GITHUB_PERSONAL_ACCESS_TOKEN: [enter your token]
```

> **PostgreSQL note:** The PostgreSQL MCP server uses a connection URL argument rather than env vars, so Crush's `/connect` wizard won't work for it. Configure it directly in the Crush config file instead (see "Persisting Connections" below).

### Disconnecting a Server

```
/disconnect postgres
```

### Listing Connected Servers

```
/list
# Shows all currently connected servers
```

### Persisting Connections

Crush stores server connections in its config file after the first connection. Find the location by running `/config` inside Crush — typically `~/.config/crush/config.toml`. You can edit this file directly:

```bash
nano ~/.config/crush/config.toml
```

Example (full 3-server config):

```toml
[[servers]]
name = "kubernetes"
command = "npx"
args = ["-y", "mcp-server-kubernetes"]

[servers.env]
KUBECONFIG = "/home/user/.kube/config"

[[servers]]
name = "postgres"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]

[[servers]]
name = "github"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]

[servers.env]
GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_YOUR_TOKEN_HERE"
```

> **Note on Prometheus:** The official `@modelcontextprotocol/server-prometheus` package is not yet available on npm. Skip this server for now; Prometheus is accessible directly at `http://localhost:30091` in your lab cluster.

### Restarting Crush

Crush loads server configs on startup. No restart needed; just run `crush` again.

---

## Appendix C: Troubleshooting Common MCP Issues

### Issue: "MCP Server failed to start" or "command not found"

**Cause:** The MCP server package isn't installed or isn't in your PATH.

**Solution:**

```bash
# Install globally
npm install -g mcp-server-kubernetes

# Or verify local install
npx mcp-server-kubernetes --help

# If using a path-based install, use full path in .mcp.json:
"args": ["/path/to/node_modules/.bin/server-name"]
```

### Issue: "Cannot connect to PostgreSQL" (Connection refused)

**Cause:** Port-forward isn't active, or credentials are wrong.

**Solution:**

```bash
# Check port-forward is running
lsof -i :5433
# Should show: kubectl port-forward listening on 5433

# If not running, start it:
kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &

# Test connection:
psql -h localhost -p 5433 -U refapp -d refapp -c "SELECT 1;"
```

### Issue: "GitHub token invalid" or "Unauthorized"

**Cause:** Token is expired, revoked, or doesn't have `repo` scope.

**Solution:**

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Check if your token is still there and not expired
3. Verify it has `repo` scope
4. If expired, create a new token and update `.mcp.json` or Crush config
5. Restart your agent

### Issue: "Kubernetes server connected but returns no pods"

**Cause:** KUBECONFIG path is wrong, or kubectl access is broken.

**Solution:**

```bash
# Verify kubectl works directly
kubectl get pods -A
# If this works but MCP doesn't, the KUBECONFIG env var in .mcp.json is likely wrong

# Check your kubeconfig path
echo $KUBECONFIG
# Or use the default:
cat ~/.kube/config | head -5

# Update .mcp.json with the correct path
```

### Issue: "Tool call timed out"

**Cause:** Large query is taking too long, or server is overloaded.

**Solution:**

- Add filters to your queries (e.g., namespace, date range) to reduce scope
- Wait a few seconds and retry
- Check if the underlying service (Kubernetes API, PostgreSQL, GitHub) is responsive

### Issue: "MCP server crashes after a few minutes"

**Cause:** Memory leak, infinite loop, or long-running query in the server.

**Solution:**

- Restart the server (restart Claude Code or run `/disconnect` then `/connect` in Crush)
- Check if your query is reasonable (e.g., not querying 100,000 pods)
- Update the MCP server to the latest version:

```bash
npm install -g mcp-server-kubernetes@latest
```

---

## Appendix D: Facilitator Notes (Live Workshop)

### Timing Notes

- Part 1: 8 min (flexible; skip if group already configured in M01)
- Part 2: 10 min (PostgreSQL is usually fastest to set up)
- Part 3: 10 min (GitHub token can add 2–3 min if participants don't have one)
- Part 4: 15 min (exercises run in parallel; agent integration makes this feel fast)
- Part 5: 7 min (reflection and template fill-in)

**Total: 50 min** (includes buffer for troubleshooting)

### Common Participant Hiccups

1. **Port-forward forgotten** — Remind them from Module 01; have one participant screen-share a working setup
2. **GitHub token scoping** — Emphasize `repo` scope only; most participants default to all scopes
3. **`.mcp.json` syntax errors** — JSON is fragile; have participants use an online JSON validator before restarting Claude Code
4. **Crush vs. Claude Code confusion** — Clarify at the start: if using Claude Code, use `.mcp.json`; if using Crush, use `/connect`. Don't mix both.

### Debrief Questions (15 min, after the lab)

1. **"How did the third exercise feel different from the first two?"**
   - Answer they should give: "One question, two tools, integrated answer. I didn't have to manually correlate."

2. **"In your daily work, which tool-combinations do you find yourself context-switching between?"**
   - Answers: "kubectl → logs → git history", "database → Terraform state → CloudWatch", etc.
   - **Callback**: "That's where MCP shines. Build servers for those tool-chains."

3. **"What would it take to add a fourth server (e.g., Prometheus, AWS, Terraform)?"**
   - Answer: "Just add another entry to `.mcp.json` and restart." Emphasize N+M vs N×M.

4. **"How is this different from what platform AI (AWS Bedrock, etc.) offers?"**
   - **Callback to Module 03**: Platform AI is great for structured cloud services. MCP lets you reach proprietary tools, local infrastructure, and custom APIs.

### Live Troubleshooting Workflow

If a participant's MCP server won't connect:

1. **Verify the underlying tool works directly:**
   ```bash
   kubectl get pods -n app --context kind-lab
   psql -h localhost -p 5433 -U refapp -d refapp -c "SELECT 1;"
   ```

2. **Check `.mcp.json` syntax:**
   ```bash
   cat .mcp.json | jq .
   # If this errors, JSON is malformed
   ```

3. **Test the MCP server in isolation:**
   ```bash
   npx mcp-server-kubernetes --help
   # Should not error
   ```

4. **Restart the agent completely** and have them retry a simple query.

### Extension Activity (If Time Permits)

**"Build a Custom MCP Resource"**

If a group finishes early:

1. Have them create a simple MCP server that exposes a custom resource
2. Example: a Markdown file with their infrastructure runbook as a resource
3. The agent can then reference it alongside kubectl/psql output
4. This preps them for Module 07 (building custom SKILL.md agents)

---

## Solution Reference

See `/path/to/course/modules/module-04-mcp/lab/solution/` for:

1. **Completed `.mcp.json`** with all 4 servers
2. **Sample outputs** from each exercise (using a representative KIND cluster state)
3. **Filled-in comparison template** showing the manual vs. MCP contrast
4. **Transcript** of cross-platform queries from Claude Code (example conversation)

These are reference materials only. Participants' outputs will vary based on their cluster's actual pod state, database contents, and GitHub history.

---

## Summary

You've just experienced MCP in action: **context engineering, not prompting**.

- **Part 1:** Verified your Kubernetes baseline
- **Part 2:** Wired PostgreSQL (database context)
- **Part 3:** Wired GitHub (code context)
- **Part 4:** Ran cross-platform queries (integration context)
- **Part 5:** Reflected on how this closes the capabilities gap

By Module 07, you'll build custom MCP servers that encode your operational runbooks, decision trees, and domain-specific knowledge. By Module 10, you'll chain MCP servers into autonomous agents that handle incident response, cost optimization, and deployment decisions.

The bridge between AI and infrastructure is MCP. You've now walked across it.
