# Crush MCP Setup Guide for Module 04

**For participants using Crush instead of Claude Code**

This is a parallel guide to the main LAB.md. Use this if you're running Crush (Charm's terminal AI agent).

---

## Prerequisites

- Crush installed (see installation section below)
- Node.js 18+ and npm
- All infrastructure from Module 01 running (KIND cluster, PostgreSQL, Prometheus)

---

## Installation

### Option 1: Homebrew (macOS)

```bash
brew install charmbracelet/tap/crush
```

### Option 2: Download Binary

Visit https://github.com/charmbracelet/crush and download the latest release for your platform.

### Option 3: From Source

```bash
git clone https://github.com/charmbracelet/crush
cd crush
make install
```

### Verify Installation

```bash
crush --version
# Output should show a version number, e.g. "v1.2.3"
```

---

## Getting Started with Crush

### Launch the REPL

```bash
crush
```

You should see:

```
Crush v1.2.3
Type /help for commands

> _
```

### First Command: List Available Servers

```
/list
```

Output: Empty or shows any previously-connected servers.

### Help

```
/help
```

Shows all available commands:

```
/connect <server>     - Connect to an MCP server
/disconnect <server>  - Disconnect from an MCP server
/list                 - List connected servers
/config               - Show config file location
/help                 - Show this help
exit                  - Exit Crush
```

---

## Part 1: Connect Kubernetes MCP Server

### Step 1: Connect

```
/connect mcp-server-kubernetes
```

Crush will prompt:

```
Configure mcp-server-kubernetes
KUBECONFIG: _
```

**Enter:** The path to your kubeconfig file. Typically:

```
~/.kube/config
```

(Or use the full path: `/home/yourname/.kube/config`)

### Step 2: Verify

```
List all pods in my default namespace
```

Expected response:

```
I found the following pods in the 'app' namespace:

- reference-app-api-gateway-abc123 (Running)
- reference-app-catalog-xyz789 (Running)
- reference-app-dashboard-def456 (Running)
- reference-app-worker-ghi789 (Running)

[Additional details...]
```

### Step 3: Check Configuration

To see where Crush stored the config:

```
/config
```

Output:

```
Config file: /home/yourname/.crush/config.toml
```

The file looks like:

```toml
[[servers]]
name = "kubernetes"
command = "npx"
args = ["mcp-server-kubernetes"]

[servers.env]
KUBECONFIG = "/home/yourname/.kube/config"
```

---

## Part 2: Connect PostgreSQL MCP Server

### Step 1: Verify Port-Forward

```bash
# In a separate terminal, check if PostgreSQL is accessible
psql -h localhost -p 5433 -U refapp -d refapp -c "SELECT COUNT(*) FROM events;"
```

If this fails, set up the port-forward:

```bash
kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &
```

### Step 2: Configure via Config File

The PostgreSQL MCP server takes a connection URL as an argument — Crush's `/connect` wizard doesn't support this format. Configure it directly in the Crush config file:

```bash
# Find config location by running /config inside Crush, then edit it:
nano ~/.config/crush/config.toml
```

Add this block:

```toml
[[servers]]
name = "postgres"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-postgres", "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"]
```

Save and restart Crush for changes to take effect.

### Step 3: Verify

```
Query the refapp database. How many records are in the events table?
```

Expected response:

```
I queried the refapp database. Here are the results:

Total events: [count from your cluster]

[Sample rows from the events table...]
```

### Step 4: Check Configuration

```
/config
```

You should see both kubernetes and postgres entries in the config file.

---

## Part 3: Connect GitHub MCP Server

### Step 1: Get a GitHub Personal Access Token

If you don't already have one:

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name: `agentic-devops-lab`
4. Scope: Check only `repo` (read access)
5. Expiration: 30 days
6. Click "Generate token"
7. **Copy it immediately** (you won't see it again)

### Step 2: Connect

In the Crush REPL:

```
/connect @modelcontextprotocol/server-github
```

Crush will prompt:

```
Configure @modelcontextprotocol/server-github
GITHUB_PERSONAL_ACCESS_TOKEN: _
```

Paste your token:

```
GITHUB_PERSONAL_ACCESS_TOKEN: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Step 3: Verify

```
Show me the 3 most recent commits in the Anthropic/anthropic-sdk-python repository
```

Expected response:

```
I found 3 recent commits:

1. Commit: abc123de (2 hours ago)
   Author: Alice Dev
   Message: Add MCP server support to SDK

2. Commit: f4g3d2e1 (1 day ago)
   Author: Bob Smith
   Message: Fix token expiration handling

3. Commit: xyz789ab (2 days ago)
   Author: Charlie Brown
   Message: Refactor message routing
```

### Step 4: Check Configuration

```
/config
```

You now have three servers in the config file.

---

## Part 4: Optional — Prometheus Access

> **Note:** The official `@modelcontextprotocol/server-prometheus` package is not yet available on npm (as of April 2026). Check the [MCP servers registry](https://github.com/modelcontextprotocol/servers) for a community alternative.

Your lab cluster exposes Prometheus at `http://localhost:30091`. You can verify it's working:

```bash
curl -s "http://localhost:30091/api/v1/query?query=up" | jq '.data.result | length'
# Should return a number > 0
```

If you find a working Prometheus MCP server package, configure it in your `config.toml`:

```toml
[[servers]]
name = "prometheus"
command = "npx"
args = ["-y", "<prometheus-mcp-package-name>"]

[servers.env]
PROMETHEUS_URL = "http://localhost:30091"
```

---

## Running the Lab Exercises

Once you have all servers connected, the exercises are identical to the main LAB.md.

### Exercise 4.1: Kubernetes-Only

```
Check my Kubernetes cluster. List all pods that have been restarted more than once in the last 24 hours. For each pod, show:
- Namespace
- Pod name
- Number of restarts
- Current status (Running, CrashLoopBackOff, etc.)
```

### Exercise 4.2: PostgreSQL-Only

```
Query my refapp PostgreSQL database. I want to understand the data:
1. How many records are in the 'events' table?
2. How many records are in the 'items' table?
3. What is the earliest and latest timestamp in the events table?
4. Show me a sample of 5 rows from the events table.
```

### Exercise 4.3: Cross-Platform (Kubernetes + PostgreSQL)

```
I'm trying to diagnose a potential database connection issue. Help me:

1. List all pods in the 'app' namespace (these are the reference-app services that interact with the database)
2. For each pod, show its restart count and current status
3. Query the refapp PostgreSQL database to show:
   - Total active connections (run: SELECT count(*) FROM pg_stat_activity)
   - How many events were recorded in the last hour
4. Correlate: Did any pod restarts coincide with database connection spikes or drops in event volume?
```

### Exercise 4.4: Full Stack (Kubernetes + PostgreSQL + GitHub)

```
I want to understand if a recent code change caused any pod restarts or data anomalies.

1. In Kubernetes, show the latest pod events/status changes (any error events or restarts) from the 'app' namespace in the last 2 hours
2. In PostgreSQL, show if there are any unusual patterns in the events table (e.g., null values, duplicate IDs, data anomalies)
3. In GitHub, search the course repository for the 5 most recent commits. Show:
   - Commit message
   - Author
   - Changed files
   - Commit timestamp

4. Correlate: Could any of these code changes explain the pod restarts or data anomalies?
```

---

## Crush-Specific Commands

### Disconnect a Server

If you want to remove a server temporarily:

```
/disconnect postgres
```

This removes it from the current session but keeps it in the config file.

### Reconnect a Server

```
/connect @modelcontextprotocol/server-postgres
```

If the server is already in the config, Crush will load the saved environment variables automatically.

### Edit the Config File Directly

If you want to change credentials or add servers manually, find the config file location by running `/config` inside Crush, then edit it:

```bash
nano ~/.config/crush/config.toml
```

Example config (3 servers):

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
GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

> **Note on Prometheus:** The official `@modelcontextprotocol/server-prometheus` package is not yet available on npm. Skip it for now. Prometheus is directly accessible at `http://localhost:30091` in your lab cluster.

After editing, restart Crush for changes to take effect:

```bash
exit  # Exit current Crush session
crush  # Start new session (loads updated config)
```

---

## Troubleshooting

### Issue: "Server not found" when trying to connect

**Cause:** The server package isn't installed.

**Solution:**

```bash
npm install -g mcp-server-kubernetes
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-github
```

### Issue: "Connection refused" for PostgreSQL

**Cause:** Port-forward isn't running.

**Solution:**

```bash
kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &
# Wait 2 seconds for tunnel to establish
```

Then try your query again.

### Issue: "Unauthorized" or "Invalid token" for GitHub

**Cause:** Token is expired, revoked, or doesn't have `repo` scope.

**Solution:**

1. Go to https://github.com/settings/tokens
2. Verify your token is active and has `repo` scope
3. If expired, create a new one
4. Update the config: `nano ~/.config/crush/config.toml` (run `/config` inside Crush to find exact path)
5. Replace the `GITHUB_PERSONAL_ACCESS_TOKEN` value
6. Restart Crush

### Issue: Crush crashes or freezes

**Cause:** Large query or server is overloaded.

**Solution:**

```bash
# Kill Crush with Ctrl+C
# Start a new session
crush

# Try a simpler query (fewer resources requested)
```

---

## Comparing Crush vs. Claude Code

| Aspect | Crush | Claude Code |
|--------|-------|-------------|
| **Setup** | `/connect` commands | `.mcp.json` file |
| **Configuration storage** | `~/.config/crush/config.toml` | `.mcp.json` in project root |
| **First setup** | ~5 minutes | ~5 minutes |
| **Persistence** | Automatic (config.toml) | Manual (restart app) |
| **Context window** | Smaller (varies by model) | Larger (Sonnet 3.5 = 200K tokens) |
| **Best for** | Quick queries, debugging | Complex analysis, long conversations |
| **Cost** | Free (uses Groq or Gemini) | Claude Pro subscription |

For this lab, both work equally well. Choose based on your existing setup.

---

## Next Steps

After completing Module 04:

- **Module 05–06:** Learn how to use MCP servers in your own code and automation
- **Module 07:** Build custom MCP servers (SKILL.md files) for proprietary tools
- **Module 10+:** Chain MCP servers into autonomous agents

---

