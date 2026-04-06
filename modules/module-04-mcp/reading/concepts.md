# MCP: The Bridge Between AI and Your Infrastructure

Welcome to Module 04. By now, you understand how LLMs work (Module 02), what built-in AI your cloud provider offers (Module 03), and where the gaps are. This module answers the hardest question: **How do you connect Claude or any AI agent to your actual infrastructure tools?**

The answer is MCP — Model Context Protocol. It's not rocket science, but it's the difference between asking an AI questions and having an AI that *does things*.

## The Integration Problem: You as the Middleware

Think about your last incident. You had a service degrading. You probably did something like this:

1. Check CloudWatch logs in the AWS console
2. SSH to a pod and review application logs
3. Check your database connection pool via psql
4. Query your Terraform state file to understand the infrastructure
5. Check your Git history to see what changed
6. Post findings in Slack

You were the middleware — the human integrating five different systems to solve one problem. Your brain is context-switching between APIs, CLI tools, authentication schemes, and output formats. If an AI agent could do that context-switching for you, you'd get faster answers and fewer typos.

But here's the challenge: Claude doesn't speak psql. Crush doesn't know how to read your Terraform state. Claude Code can't directly call `kubectl apply`. They're expert at reasoning, but they're isolated from your actual infrastructure.

That's the gap MCP fills.

## MCP = USB-C for AI Agents

Remember when every device had a different charging cable? Your phone, laptop, tablet, camera — all proprietary connectors. Frustrating.

USB-C is the universal standard. One connector. It works everywhere.

MCP is USB-C for AI agents. It's a standard protocol that lets Claude, Crush, or any future AI agent connect to any tool without the tool knowing the agent exists. And without the agent knowing the specific tool's quirks.

Here's the math. Imagine you have:
- 3 different AI agents (Claude Code, Crush, Hermes)
- 8 different tools (kubectl, psql, Terraform, CloudWatch, Ansible, git, Prometheus, Cost Explorer)

**Without MCP:** You need 3 × 8 = 24 integrations. Each agent needs custom code to talk to each tool.

**With MCP:** Each tool builds one MCP server. Each agent supports the MCP protocol. You need 3 + 8 = 11 integrations. Tools and agents are decoupled.

That's N+M instead of N×M.

## How MCP Works: Three-Layer Architecture

MCP has three layers:

```
┌─────────────────────────────────────────────────────────┐
│  Client Layer (Claude Code, Crush, Web UI)              │
│  - Sends tool calls                                      │
│  - Receives results                                      │
└─────────────────────────────────────────────────────────┘
                         ↕
                      MCP Protocol
                (JSON-RPC over stdio)
                         ↕
┌─────────────────────────────────────────────────────────┐
│  Server Layer (MCP Servers for each tool)               │
│  - Exposes tools, resources, prompts                     │
│  - Translates MCP calls to tool calls                    │
└─────────────────────────────────────────────────────────┘
                         ↕
                    (integration varies)
                         ↕
┌─────────────────────────────────────────────────────────┐
│  Tool Layer (kubectl, psql, Terraform, etc.)            │
│  - Actual infrastructure                                 │
│  - Doesn't know MCP exists                              │
└─────────────────────────────────────────────────────────┘
```

The client (Claude Code) doesn't need to know how to run `psql` queries. It just calls a tool named "query_database" and gets back structured JSON.

The server translates. It takes the MCP tool call, figures out which CLI command to run, parses the output, and returns clean JSON.

The tool stays the same — `psql` still works exactly as it always has.

## Inside an MCP Server: Tools, Resources, and Prompts

An MCP server is like an OpenAPI specification for your CLI tools. It tells the client three things:

**1. Tools** — Functions the agent can call.

A tool is a function with inputs and outputs. Example:

```json
{
  "name": "query_kubernetes_pods",
  "description": "List all pods in a namespace, with their status and resource usage",
  "inputSchema": {
    "type": "object",
    "properties": {
      "namespace": {
        "type": "string",
        "description": "Kubernetes namespace (default: default)"
      },
      "label_selector": {
        "type": "string",
        "description": "Optional label selector (e.g., app=api)"
      }
    },
    "required": ["namespace"]
  }
}
```

When the client calls this tool with `namespace="production"` and `label_selector="app=api"`, the server runs something like:

```bash
kubectl get pods -n production -l app=api -o json
```

It parses the JSON output and returns it to the client.

**2. Resources** — Structured data the agent can read.

A resource is a file or data that the agent can access without calling a tool. Examples:

- Your Terraform state file (`terraform.tfstate`)
- A recently-generated Cost Explorer report (CSV)
- Your infrastructure documentation (Markdown)
- A ConfigMap from Kubernetes

Resources are like attaching context to a conversation. Instead of the agent asking "What's in our Terraform state?" and you having to run a tool, the resource is just *there* for the agent to read.

**3. Prompts** — Pre-written context that guides the agent.

A prompt is like a template or runbook. Example:

```markdown
# Incident Response Workflow

When diagnosing a pod crash:
1. Check pod logs: use query_pod_logs with --tail=200
2. Check events: use query_kubernetes_events
3. Check node resources: use query_node_status
4. Collect metrics: use query_prometheus for CPU/memory
5. Suggest next steps based on findings
```

The agent can invoke this prompt when it encounters a pod issue, and the MCP server will inject this structured guidance into the conversation.

## Tool Discovery: Self-Describing Interfaces

When Claude Code connects to an MCP server, the first thing it does is ask: "What can you do?"

The server responds with its full capability list — all tools, resources, and prompts. This is self-discovery, like service discovery in Kubernetes.

If you've set up a Kubernetes MCP server, it might advertise tools like:

- `list_pods`
- `describe_pod`
- `get_pod_logs`
- `check_pod_events`
- `scale_deployment`
- `apply_manifest`
- `rollback_deployment`

Claude Code doesn't need a manual "here's what the Kubernetes server can do" document. It asks the server, gets back a structured list, and learns the interface automatically.

This also means when you update your MCP server with new tools, Claude Code learns about them instantly.

## The MCP Ecosystem: 200+ Community Servers

MCP is open. The Anthropic community has built 200+ public MCP servers. Here are the ones most relevant to your work:

**Infrastructure & Cloud:**
- `mcp-server-kubernetes` — interact with K8s clusters via kubectl
- `mcp-server-terraform` — read/write Terraform plans and state
- `mcp-server-aws` — call AWS services (EC2, RDS, Lambda, CloudWatch, etc.)
- `mcp-server-docker` — manage Docker containers and images
- `mcp-server-ansible` — run and parse Ansible playbooks
- `mcp-server-git` — query Git history, branches, diff

**Databases & Observability:**
- `mcp-server-postgresql` — query PostgreSQL, run migrations
- `mcp-server-mysql` — interact with MySQL/MariaDB
- `mcp-server-prometheus` — query metrics and generate alerts
- `mcp-server-grafana` — fetch dashboards and annotations
- `mcp-server-elastic` — search and manage Elasticsearch indices

**CI/CD & Automation:**
- `mcp-server-github` — interact with GitHub (PRs, issues, actions)
- `mcp-server-gitlab` — interact with GitLab (similar)
- `mcp-server-jenkins` — trigger builds, check logs
- `mcp-server-argocd` — manage ArgoCD deployments

**General Utilities:**
- `mcp-server-postgres` (core) — generic database interface
- `mcp-server-filesystem` — read files from approved directories
- `mcp-server-web` — fetch and parse web pages
- `mcp-server-memory` — persistent note-taking across conversations

These are maintained by the community and Anthropic. You can install them, run them locally, or build your own custom server if you have a proprietary tool or internal API.

## Configuration: Wiring MCP Servers

An MCP server is just a program. How do you tell Claude Code to use it?

**In Claude Code** (via `.mcp.json`):

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "node",
      "args": ["/path/to/mcp-server-kubernetes/dist/index.js"],
      "env": {
        "KUBECONFIG": "$HOME/.kube/config"
      }
    },
    "terraform": {
      "command": "python",
      "args": ["/path/to/mcp-server-terraform/server.py"],
      "env": {
        "TF_ROOT": "/path/to/terraform"
      }
    },
    "postgres": {
      "command": "node",
      "args": ["/path/to/mcp-server-postgres/dist/index.js"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost/dbname"
      }
    }
  }
}
```

Each server entry specifies:
- How to run it (command and args)
- Environment variables (credentials, config paths)
- Optional restrictions (which directories/namespaces it can access)

When you start Claude Code, it reads `.mcp.json`, starts all the servers, handshakes with each one, and advertises their tools to Claude.

**In Crush**, you use the `/connect` command to add servers on the fly:

```
/connect mcp-server-kubernetes
/connect mcp-server-terraform
/connect mcp-server-postgres
```

This is simpler for quick one-off work but less persistent than `.mcp.json`.

## Cross-Platform Queries: One Question, Multiple Tools

Here's where it gets powerful.

You ask Claude Code: "Tell me about the pod `api-server` in production. Is it crashing repeatedly? If so, why? What changed in the infrastructure in the last day?"

Claude Code uses the Kubernetes MCP server to:
1. Get pod status and logs
2. Check recent events
3. Query pod resource limits

It uses the Git MCP server to:
4. Check recent commits that touched the deployment

It uses the Terraform MCP server to:
5. Check what the intended state is vs. actual state

It uses Prometheus via its MCP server to:
6. Pull 24-hour metric history for that pod

One question. Three MCP servers. One integrated answer.

You're not copy-pasting between five tools anymore. The agent does the integration.

## MCP vs. Direct CLI vs. Raw API: When to Use Each

You have three options for infrastructure interaction:

**Option 1: Direct CLI (kubectl, terraform, psql)**

Pros:
- You're already comfortable with it
- Full control
- Works offline
- No credential sharing required

Cons:
- Manual context-switching
- Prone to mistakes under stress
- Can't be automated from Claude without MCP

*Use when:* You're doing quick, familiar tasks. One tool. No integration needed.

**Option 2: Raw API (AWS SDK, Kubernetes API, etc.)**

Pros:
- Programmatic control
- Can be scripted
- Standardized (most tools have REST/gRPC APIs)

Cons:
- Need to manage authentication
- Need to parse responses yourself
- Need to write integration code

*Use when:* You're building a custom automation tool and MCP doesn't exist for your use case.

**Option 3: MCP Server**

Pros:
- Claude/Crush can use it natively
- Self-describing interface
- One credential per tool, managed by the server
- Standardized across all agents
- Community servers already exist

Cons:
- Server process must be running
- Adds one extra layer (but a very thin one)

*Use when:* You want Claude or another AI agent to reliably interact with your infrastructure without you being in the loop.

For most DevOps work, especially incident response and investigation, MCP is the right choice.

## Security: Defense in Depth

"You're giving an AI agent access to my production database?"

Fair question. MCP has multiple layers of defense.

**Layer 1: Authentication & Credentials**

MCP servers never expose credentials to the client. The server owns the credentials (in environment variables or a config file). The client just calls tools; the server handles auth.

Example: Your Kubernetes MCP server has `KUBECONFIG` pointing to your kubeconfig file. Claude Code never sees the kubeconfig. It just calls `list_pods`, and the server handles authentication to the API server.

**Layer 2: Tool-Level Approval Gates**

You can configure MCP servers to require approval before executing certain tools.

```json
{
  "requireApproval": ["scale_deployment", "delete_pod", "apply_manifest"]
}
```

When Claude Code tries to call `scale_deployment`, the server pauses and waits for your approval before executing.

**Layer 3: Resource Restrictions**

MCP servers can restrict which resources agents can access.

For example, a Kubernetes server might be restricted to:

```json
{
  "allowedNamespaces": ["production", "staging"],
  "deniedNamespaces": ["kube-system", "kube-public"],
  "allowedResources": ["pods", "deployments", "services"],
  "deniedResources": ["secrets", "configmaps"]
}
```

Or a filesystem server might be restricted to:

```json
{
  "rootPath": "/opt/terraform",
  "allowedPaths": ["/opt/terraform/prod", "/opt/terraform/shared"],
  "deniedPaths": ["/opt/terraform/secrets"]
}
```

**Layer 4: Audit Logging**

Every tool call through MCP is logged. You can see exactly what Claude Code asked for, what the server executed, and what was returned.

**Layer 5: Process Isolation**

MCP servers run as separate processes. If one is compromised, others aren't affected. And you can kill the server (and revoke its access) without restarting Claude Code.

**Layer 6: RBAC & Scoping**

Some MCP servers support role-based access control. The Kubernetes server might run with a read-only service account for investigation, and a limited write account for remediation. Different tools call different API objects with different permissions.

Think of it like writing fine-grained IAM policies for your database: different roles for SELECT, INSERT, and DELETE.

## Connecting Back to Module 03: The Capabilities Gap

Remember Module 03? We talked about the capabilities gap between what platform AI offers and what you actually need.

Platform AI (AWS Bedrock agents, etc.) can:
- ✓ Ask questions about CloudWatch
- ✓ Read cost data
- ✓ Understand your infrastructure in broad strokes

Platform AI cannot:
- ✗ SSH to a server and check logs
- ✗ Run custom queries on your database
- ✗ Access your internal APIs
- ✗ Modify Terraform state
- ✗ Trigger CI/CD pipelines
- ✗ Manage Kubernetes resources

MCP fills that gap. It lets Claude Code (and other agents) do the things platform AI can't.

MCP doesn't replace platform AI. It complements it. You might use AWS Bedrock for high-level cost analysis, then use Claude Code + MCP servers to investigate the detailed cause of a cost spike.

## The Context Engineering Angle

Here's something crucial: MCP is context engineering in practice.

When you set up an MCP server, you're not "prompting" Claude to do something. You're structuring the context — the tools, resources, and guidance — that Claude needs to solve a problem.

You're saying: "Here are the tools you have. Here's how to use them. Here's the reference data." You're not writing prompts like "Please be helpful" or "Think step by step." You're designing the system so Claude naturally makes the right decisions.

The tool descriptions are context. The resources are context. The prompt templates are context. All of it is encoding your operational knowledge into a structure that Claude can use.

That's the power of MCP: it's not magic prompting. It's good architecture.

## Key Terminology

Here's a quick reference for MCP terms you'll see throughout this module and beyond:

| Term | Meaning |
|------|---------|
| **MCP** | Model Context Protocol. Standard for connecting AI agents to infrastructure tools. |
| **MCP Client** | The AI agent using the tools. Usually Claude Code, Crush, or a custom application. |
| **MCP Server** | A small program that translates between MCP protocol and a specific tool (kubectl, psql, Terraform, etc.). |
| **Tool** | A function exposed by an MCP server that the client can call. Example: `list_pods`, `query_database`. |
| **Resource** | Static or semi-static data exposed by an MCP server. Example: a Terraform state file, a ConfigMap. |
| **Prompt** | A pre-written context template exposed by an MCP server. Example: an incident response runbook. |
| **Tool Discovery** | The process by which a client learns what tools an MCP server exposes. |
| **Stdio Transport** | How MCP communicates: JSON-RPC over standard input/output. Simple, process-based. |
| **Context Window** | The amount of text Claude can see at once. MCP helps you pack more useful context into that window. |
| **Tool Call** | When Claude asks an MCP server to execute a tool. Example: `{"tool": "list_pods", "args": {"namespace": "prod"}}`. |
| **Tool Result** | The response from an MCP server after executing a tool. Usually JSON, sometimes plain text. |
| **Approval Gate** | A security mechanism that requires human sign-off before an MCP tool executes. |
| **RBAC** | Role-based access control. MCP servers can enforce RBAC to restrict which tools an agent can use. |
| **Defense in Depth** | Multiple layers of security (authentication, approval gates, restrictions, audit logging). |

---

You're now at the bridge between AI and infrastructure. In the lab, you'll build an MCP server and connect it to Claude Code. You'll see firsthand how one question can reach five different tools and come back with integrated answers.

That's the future of infrastructure automation: not you as the middleware, but AI as the integration layer, wired safely into your tools.
