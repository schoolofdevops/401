# MCP Reference Card — DevOps Quick Guide

## 1. MCP Architecture Quick Reference

```
┌─────────────────────────────────────────────────────────┐
│                    AI CODING AGENT                       │
│           (Claude Code / Crush / IDE Plugin)            │
└──────────────────────────┬──────────────────────────────┘
                           │
                    MCP Protocol
                    (JSON-RPC 2.0)
                           │
┌──────────────────────────▼──────────────────────────────┐
│                    MCP CLIENT                            │
│    (Claude Code Agent Runtime / Crush Runtime)          │
│  • Resource discovery                                   │
│  • Tool/Resource/Prompt routing                         │
│  • Call result marshaling                               │
└──────────────────────────┬──────────────────────────────┘
                           │
        (stdio / HTTP / SSE transport)
                           │
┌──────────────────────────▼──────────────────────────────┐
│                    MCP SERVER                            │
│   (Specialized agent — kubectl, postgres, github, etc)  │
│  • Tool definitions (callable functions)                │
│  • Resource definitions (state/data)                    │
│  • Prompt definitions (expert prompts)                  │
└──────────────────────────┬──────────────────────────────┘
                           │
              (System calls / APIs / Network)
                           │
┌──────────────────────────▼──────────────────────────────┐
│                  DOMAIN SYSTEMS                          │
│      (Kubernetes, PostgreSQL, GitHub, AWS, Docker)      │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Key MCP Servers for DevOps

| Server | Package/Install | What It Does | Key Tools Exposed |
|--------|-----------------|--------------|-------------------|
| **kubectl** | `mcp://smithery.ai/kubectl` or `npm install @modelcontextprotocol/server-kubectl` | Query K8s cluster state; get pods, deployments, services | `kubectl_get_pods`, `kubectl_get_services`, `kubectl_apply_manifest`, `kubectl_get_logs` |
| **PostgreSQL** | `npm install @modelcontextprotocol/server-postgres` | Query/update Postgres databases; schema introspection | `sql_query`, `sql_execute`, `schema_describe`, `schema_list` |
| **GitHub** | `npm install @modelcontextprotocol/server-github` | Query repos, issues, PRs, workflows; read code; commit state | `github_list_repos`, `github_get_issue`, `github_list_pull_requests`, `github_get_file_content` |
| **AWS** | `npm install @modelcontextprotocol/server-aws` or community variants | Query EC2, S3, CloudFormation, IAM; read-only by default | `aws_ec2_describe_instances`, `aws_s3_list_buckets`, `aws_cloudformation_describe_stacks` |
| **Docker** | `npm install @modelcontextprotocol/server-docker` (community) | Query running containers, images, volumes, networks | `docker_ps`, `docker_inspect`, `docker_logs`, `docker_exec` |
| **Filesystem** | `mcp://smithery.ai/filesystem` or built-in | Read/write files on host; directory traversal | `file_read`, `file_write`, `directory_list`, `file_create` |
| **Prometheus** | Community (e.g., `mcp-prometheus`) | Query metrics, alerts, scrape targets | `prometheus_query`, `prometheus_query_range`, `prometheus_rules_list` |
| **Grafana** | Community (e.g., `mcp-grafana`) | Query dashboards, datasources, alerts; read alert state | `grafana_list_dashboards`, `grafana_list_datasources`, `grafana_get_alerts` |
| **Slack** | `npm install @modelcontextprotocol/server-slack` | Send/read messages, check channel state | `slack_send_message`, `slack_read_messages`, `slack_list_channels` |
| **Git** | `npm install @modelcontextprotocol/server-git` | Clone, query commit history, diff, branches | `git_clone`, `git_log`, `git_diff`, `git_status` |

---

## 3. Claude Code MCP Configuration

### `.mcp.json` (Claude settings directory: `~/.config/claude/`)

```json
{
  "mcpServers": {
    "kubectl": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-kubectl"],
      "env": {
        "KUBECONFIG": "/path/to/kubeconfig"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "PG_HOST": "localhost",
        "PG_PORT": "5432",
        "PG_USER": "postgres",
        "PG_PASSWORD": "***",
        "PG_DATABASE": "myapp"
      }
    },
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_***"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/home/user/projects"],
      "env": {}
    }
  }
}
```

### `settings.json` (Claude Code UI settings)

```json
{
  "mcpEnabled": true,
  "mcpTimeout": 30000,
  "mcpServersAlwaysAllow": false,
  "mcpApprovalRequired": true
}
```

**Key env variables to set:**
- `KUBECONFIG` — path to kubeconfig file
- `PG_*` — PostgreSQL connection params
- `GITHUB_TOKEN` — GitHub PAT (Personal Access Token)
- `AWS_*` — AWS credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION)
- `DOCKER_HOST` — Docker socket (unix:///var/run/docker.sock)

---

## 4. Crush MCP Configuration

### `~/.config/crush/crushrc.toml` (or `crushrc` env var)

```toml
[mcp_servers]

[mcp_servers.kubectl]
command = "npx"
args = ["@modelcontextprotocol/server-kubectl"]
env = { KUBECONFIG = "/path/to/kubeconfig" }

[mcp_servers.postgres]
command = "npx"
args = ["@modelcontextprotocol/server-postgres"]
env = { PG_HOST = "localhost", PG_PORT = "5432", PG_USER = "postgres", PG_PASSWORD = "***", PG_DATABASE = "myapp" }

[mcp_servers.github]
command = "npx"
args = ["@modelcontextprotocol/server-github"]
env = { GITHUB_TOKEN = "ghp_***" }

[mcp_servers.filesystem]
command = "npx"
args = ["@modelcontextprotocol/server-filesystem", "/home/user/projects"]
env = {}
```

**Model provider config** (set before starting Crush):

```bash
export CRUSH_MODEL=groq  # or "gemini", "claude", "openai"
export CRUSH_API_KEY=***
crush
```

---

## 5. MCP Server Capabilities Matrix

| Capability | What It Is | Use Case | Example |
|-----------|-----------|----------|---------|
| **Tools** | Callable functions exposed by the server; agent can call them | Imperative actions: run a query, execute a command, apply a manifest | `kubectl apply_manifest`, `postgres sql_execute`, `github create_pr` |
| **Resources** | Read-only data artifacts indexed by URI; agent can reference them | Contextualize decisions: "I need to read this file," "get cluster state" | `kubectl://pods/default`, `postgres://schema/users`, `file:///app/config.yaml` |
| **Prompts** | Expert prompt templates baked into the server; agent can trigger them | Guided workflows: "run diagnostic," "generate IaC from this cluster" | "diagnose pod crash logs", "suggest scaling policy" |

---

## 6. Common Cross-Platform Queries

| Natural Language Query | MCP Servers Hit | What Happens |
|------------------------|-----------------|--------------|
| "List all pods in my Kubernetes cluster not in Running state" | `kubectl` | Tool: `kubectl_get_pods`, filter logic in agent |
| "Query my Postgres database for users with no recent activity" | `postgres` | Tool: `sql_query`, agent constructs WHERE clause |
| "Show me open GitHub PRs on my main repo with failing CI checks" | `github` | Tools: `github_list_pull_requests`, agent filters by status |
| "Read the Terraform config in my repo and suggest improvements" | `github` + `filesystem` | Resource: fetch via GitHub API; Prompt: apply TF best-practices template |
| "Get the last 100 lines of logs from the payment-api container" | `docker` | Tool: `docker_logs`, agent parses container ID |
| "Query Prometheus for CPU spike in the past hour on prod cluster" | `prometheus` | Tool: `prometheus_query_range`, agent builds PromQL |

---

## 7. MCP vs CLI vs API — Decision Matrix

| Approach | When to Use | Pros | Cons |
|----------|------------|------|------|
| **MCP** | Agent needs to interactively explore + reason about state; declarative queries | AI-native; context window efficient; no auth key in agent code; prompt/resource templating | Requires MCP server; slightly higher latency than direct CLI |
| **CLI (bash/sh)** | Agent needs to run sequential shell commands; imperative scripting | Familiar to DevOps teams; full expressiveness; no network latency | Requires shell access; harder for agent to parse unstructured output; hard to compress context |
| **API** | Agent needs raw/advanced access not abstracted by MCP; custom integrations | Maximum flexibility; direct; no abstraction layer | Requires credential management; verbose; agent must know API schema |

**Rule of thumb:** Use MCP for discovery + reasoning. Use CLI when you need edge-case flexibility. Use API only when MCP server doesn't exist and CLI is insufficient.

---

## 8. Security Checklist

- [ ] **Read-only mode enabled** — MCP servers configured to reject writes by default (e.g., postgres in read-only SQL mode)
- [ ] **Namespace/scope restrictions** — kubectl MCP limited to specific namespaces; postgres MCP limited to non-sensitive tables
- [ ] **RBAC enforced** — Kubernetes ServiceAccount bound to minimal required permissions; GitHub token scoped to specific repos
- [ ] **Secrets never in config files** — Use env vars or secret management (1Password, Vault); never commit credentials
- [ ] **Approval gates** — Claude Code / Crush configured to require human approval for destructive tools (apply, delete, drop)
- [ ] **Audit logging enabled** — MCP server logs all tool invocations (who, what, when)
- [ ] **Connection timeout set** — MCP client timeout < 30s to prevent hanging on stalled servers
- [ ] **TLS verified** — If using HTTP/SSE transport, enforce HTTPS and certificate verification
- [ ] **Rate limits configured** — MCP servers throttled to prevent accidental bulk operations
- [ ] **Tool blacklist reviewed** — Confirm no unintended destructive tools exposed (e.g., `rm -rf`, `DROP TABLE`)

---

## 9. Troubleshooting

### MCP Server Won't Start

**Symptom:** "MCP server failed to initialize"

**Steps:**
1. Verify server package installed: `npm ls @modelcontextprotocol/server-kubectl`
2. Check env vars set correctly: `echo $KUBECONFIG`
3. Test server in isolation: `npx @modelcontextprotocol/server-kubectl` (should start listening on stdio)
4. Check agent logs: Claude Code console or Crush `--debug` flag

---

### Tools Not Available in Agent

**Symptom:** "I don't see the kubectl tools in my context"

**Steps:**
1. Verify MCP server in `.mcp.json` or `crushrc.toml`
2. Confirm agent has discovered tools: ask Claude "What tools do you have available?"
3. Check MCP client is connected: look for "Connected to X MCP servers" in startup logs
4. Restart agent: kill and restart Claude Code or Crush session

---

### Slow Queries / Timeouts

**Symptom:** "MCP request timed out after 30s"

**Steps:**
1. Increase timeout in Claude Code settings: `"mcpTimeout": 60000` (60s)
2. Simplify the query: break into smaller steps
3. Check server responsiveness: run native CLI (e.g., `kubectl get pods`) — if slow, the issue is server-side
4. Check network: ping the MCP server host if remote

---

### Authentication Failures

**Symptom:** "Unauthorized" or "Invalid token" from MCP server

**Steps:**
1. Verify credential is current: test with native tool (e.g., `gh api user`)
2. Rotate credential if expired (e.g., `gh auth refresh` for GitHub)
3. Check env var is loaded: `echo $GITHUB_TOKEN` (should not be empty)
4. Ensure credential has correct scopes (GitHub PAT needs `repo`, `read:user`)

---

### Parsing Errors in Agent

**Symptom:** Agent returns junk or corrupted output from MCP tool

**Steps:**
1. Check MCP server output format is valid JSON
2. Reduce returned data size: ask MCP server to filter (e.g., `kubectl get pods -n kube-system` instead of all namespaces)
3. Verify tool input params match server schema (use `resources` to inspect)
4. File a bug if server output is malformed

---

## 10. Useful Links

- **MCP Official Docs** — https://modelcontextprotocol.io/
- **Smithery.ai MCP Registry** — https://smithery.ai (discover public MCP servers)
- **Awesome MCP Servers** — https://github.com/pglombardo/awesome-mcp-servers (community-curated list)
- **Anthropic MCP GitHub** — https://github.com/modelcontextprotocol/servers (official reference servers)
- **Claude Code MCP Setup** — https://modelcontextprotocol.io/docs/tools/claude-code (integration guide)
- **Crush by Charm** — https://charm.sh/crush (multi-provider AI CLI agent)
- **Groq Console** — https://console.groq.com (free LLM provider for Crush)

---

## Quick Start Template

1. **Install MCP server:**
   ```bash
   npm install @modelcontextprotocol/server-kubectl
   ```

2. **Add to `.mcp.json`:**
   ```json
   {
     "mcpServers": {
       "kubectl": {
         "command": "npx",
         "args": ["@modelcontextprotocol/server-kubectl"],
         "env": { "KUBECONFIG": "~/.kube/config" }
       }
     }
   }
   ```

3. **Restart Claude Code or Crush**

4. **Ask agent:** "List all pods in my cluster"

5. **Enable approvals if doing writes:** Set `"mcpApprovalRequired": true` in Claude Code settings

---

**Version:** MCP 1.0+ | **Updated:** 2026-04 | **For:** Agentic DevOps Course Module 04
