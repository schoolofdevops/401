# Module 01 — Quick Reference Card

> Print this page. Keep it next to your keyboard for the first two days.

---

## AgenticOps Trinity Framework

```
PILLAR 1               →  PILLAR 2               →  PILLAR 3
Augmented DevOps           Agentic Engineering        Agentic DevOps
"Use what exists"          "Understand the machinery" "Build agents for you"
Passenger                  Mechanic                   Driver
Days 1                     Days 2-3                   Days 4-5
```

## The Chain

```
Domain Expertise → Better Vocabulary → Better Context → Better Results
```

Your DevOps experience is the starting point. Everything builds from there.

## Trust Spectrum

```
Observe ──→ Recommend ──→ Act with Approval ──→ Act + Report
(read-only)  (suggest)     (you approve)         (autonomous)
```

Every agent starts at Observe and earns trust over time.

---

## Lab Environment Quick Reference

### Course Repository

```bash
git clone https://github.com/schoolofdevops/401.git
cd 401
```

### Access Points

| Port | Service | URL | Credentials |
|------|---------|-----|-------------|
| 30080 | Dashboard | [localhost:30080](http://localhost:30080) | — |
| 30090 | Grafana | [localhost:30090](http://localhost:30090) | admin / admin |
| 30091 | Prometheus | [localhost:30091](http://localhost:30091) | — |
| 5432 | PostgreSQL | localhost:5432 | refapp / refapp-lab-password |
| 30400 | Reserved | — | For later modules |
| 30500 | Reserved | — | For later modules |
| 30600 | Reserved | — | For later modules |

### Cluster

3-node KIND cluster: 1 control-plane + 2 workers.

### Namespaces

| Namespace | Contents |
|-----------|----------|
| `app` | API gateway, catalog, worker, dashboard |
| `db` | PostgreSQL |
| `monitoring` | Prometheus, Grafana |
| `kube-system` | KIND cluster internals |

### Common Commands

```bash
# Check cluster status
kubectl get pods --all-namespaces --context kind-lab

# Check app pods specifically
kubectl get pods -n app --context kind-lab

# View reference app status
cd reference-app && make status

# Check node distribution
kubectl get nodes --context kind-lab

# Rebuild and redeploy (if needed)
cd reference-app && make deploy

# Destroy and start fresh
cd reference-app && make destroy && make deploy

# Port-forward PostgreSQL (if MCP connection fails)
kubectl port-forward svc/postgresql 5432:5432 -n db --context kind-lab &

# Run full environment verification
bash setup/verify.sh
```

---

## AI Coding Agent Quick Reference

### Claude Code

```bash
# Install / update
npm install -g @anthropic-ai/claude-code

# Launch
claude

# Inside Claude Code:
/help                 # Show available commands
/mcp                  # Show connected MCP servers
/cost                 # Show token usage
/quit                 # Exit
```

### Crush (Charm)

```bash
# Install (macOS)
brew install charmbracelet/tap/crush

# Launch
crush

# Inside Crush:
/connect              # Connect to LLM provider
/help                 # Show available commands
/quit                 # Exit
```

---

## MCP Configuration

### Claude Code (`.mcp.json` in project root)

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"],
      "env": { "KUBECONFIG": "${HOME}/.kube/config" }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres",
        "postgresql://refapp:refapp-lab-password@localhost:5432/refapp"]
    }
  }
}
```

### Crush (`~/.config/crush/mcp.json`)

Same format as Claude Code — copy the JSON above.

---

## Key Terminology (one-liners)

| Term | One-liner |
|------|-----------|
| AgenticOps | Building AI agents that encode your operational expertise |
| Context engineering | Structuring the right info so AI gives expert answers (not "prompt engineering") |
| MCP | Universal plug for connecting AI agents to tools (kubectl, postgres, etc.) |
| SKILL.md | Your operational runbook in a format AI agents can use |
| KIND | Local Kubernetes cluster running inside Docker |
| Hermes | Open-source framework for building DevOps agents |

---

## Tool Installation Links

| Tool | Install Docs |
|------|-------------|
| Docker Desktop | [docs.docker.com/get-started](https://docs.docker.com/get-started/) |
| Rancher Desktop (alt) | [rancherdesktop.io](https://rancherdesktop.io/) |
| KIND | [kind.sigs.k8s.io/docs/user/quick-start](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) |
| kubectl | [kubernetes.io/docs/tasks/tools](https://kubernetes.io/docs/tasks/tools/install-kubectl/) |
| Helm | [helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/) |
| Node.js (includes npx) | [nodejs.org/en/download](https://nodejs.org/en/download/) |
| Git | [git-scm.com/downloads](https://git-scm.com/downloads) |
| Claude Code | [docs.anthropic.com/en/docs/claude-code](https://docs.anthropic.com/en/docs/claude-code/overview) |
| Crush (Charm) | [github.com/charmbracelet/crush](https://github.com/charmbracelet/crush) |

---

## Troubleshooting Cheat Sheet

| Symptom | Fix |
|---------|-----|
| `kind: command not found` | `brew install kind` or see SETUP.md Step 2 |
| Pods stuck in `Pending` | Docker Desktop → Resources → increase RAM to 8 GB |
| Dashboard not loading (:30080) | `kubectl get pods -n app --context kind-lab` — check pod status |
| MCP: "connection refused" on postgres | Run `kubectl port-forward svc/postgresql 5432:5432 -n db --context kind-lab &` |
| Claude Code auth error | `npm update -g @anthropic-ai/claude-code` + check status.anthropic.com |
| Crush `/connect` fails | Verify API key, try a different provider (Gemini → Groq) |
| `verify.sh` fails on mock data | Ensure you're running from the course root: `cd agentic-devops-course` |
| KIND cluster won't create | `kind delete cluster --name lab` then `cd reference-app && make deploy` |
