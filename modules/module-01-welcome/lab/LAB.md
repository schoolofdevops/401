# Lab 01 — Environment Setup

**Estimated time:** 30–45 minutes
**Difficulty:** Beginner (DevOps tools you already know + new AI tool setup)
**Deliverable:** A fully connected lab environment — KIND cluster + reference app + monitoring + AI coding agent with MCP

---

## What You're Building

By the end of this lab, you'll have:

1. A local 3-node Kubernetes cluster (KIND) with pre-mapped ports for all course services
2. A reference microservices application (3 Rust services + Svelte dashboard)
3. PostgreSQL database with sample data
4. Prometheus + Grafana monitoring stack
5. An AI coding agent (Claude Code or Crush) connected via MCP to kubectl, PostgreSQL, and GitHub
6. A verified smoke test proving your AI agent can query live infrastructure

Everything runs locally. No cloud account needed. No paid APIs beyond your existing Claude subscription (or free-tier alternatives).

---

## Prerequisites: Tool Installation

Before starting the lab, make sure every tool below is installed. If anything is missing, follow the official documentation link to install it.

- **Docker Desktop** — [docs.docker.com/get-started](https://docs.docker.com/get-started/)
  Allocate at least 4 CPUs, 6 GB memory, 30 GB disk (Settings → Resources).
  _Alternative:_ **Rancher Desktop** (open source) — [rancherdesktop.io](https://rancherdesktop.io/). If using Rancher Desktop, select the `dockerd (moby)` container runtime during setup so all `docker` commands work identically.

- **KIND** (Kubernetes IN Docker) v0.27+ — [kind.sigs.k8s.io/docs/user/quick-start/#installation](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

- **kubectl** — [kubernetes.io/docs/tasks/tools/install-kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  _Tip:_ Docker Desktop bundles kubectl. Check with `kubectl version --client` before installing separately.

- **Helm** v3+ — [helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/)

- **Node.js** v18+ (includes `npx`) — [nodejs.org/en/download](https://nodejs.org/en/download/)
  _Tip:_ If you use `nvm`, run `nvm install 18 && nvm use 18`.

- **Git** — [git-scm.com/downloads](https://git-scm.com/downloads)

- **AI Coding Agent** — choose ONE:
  - **Claude Code** (recommended with Claude Pro/Team subscription) — [docs.anthropic.com/en/docs/claude-code](https://docs.anthropic.com/en/docs/claude-code/overview)
  - **Crush** (free, open source, by Charm) — [github.com/charmbracelet/crush](https://github.com/charmbracelet/crush)

> **Windows users:** Run everything inside WSL2. Install Docker Desktop with WSL2 integration enabled. See [learn.microsoft.com/en-us/windows/wsl/install](https://learn.microsoft.com/en-us/windows/wsl/install).

---

## Step 1: Verify Your Tools

Run each command and check the output matches:

```bash
# Container runtime
docker --version
# Expected: Docker version 24.x or later

# Kubernetes tools
kind version
# Expected: kind v0.27.0 or later

kubectl version --client
# Expected: Client Version: v1.29+

helm version
# Expected: version.BuildInfo{Version:"v3.x.x" ...}

# Node.js (required for MCP servers and Claude Code)
node --version
# Expected: v18.x or later

npx --version
# Expected: 9.x or later (bundled with Node.js)

# Git
git --version
```

**Quick check — all at once:**

```bash
echo "Docker:  $(docker --version 2>/dev/null || echo 'NOT FOUND')"
echo "KIND:    $(kind version 2>/dev/null || echo 'NOT FOUND')"
echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo 'NOT FOUND')"
echo "Helm:    $(helm version --short 2>/dev/null || echo 'NOT FOUND')"
echo "Node:    $(node --version 2>/dev/null || echo 'NOT FOUND')"
echo "npx:     $(npx --version 2>/dev/null || echo 'NOT FOUND')"
echo "Git:     $(git --version 2>/dev/null || echo 'NOT FOUND')"
```

**Missing something?** Go back to the Prerequisites section above and follow the official install link.

---

## Step 2: Clone the Course Repository

```bash
git clone https://github.com/schoolofdevops/401.git
cd 401
```

Verify you're in the right place:

```bash
ls
```

You should see: `modules/`, `reference-app/`, `infrastructure/`, `setup/`, and other top-level files.

---

## Step 3: Review the KIND Cluster Configuration

Before deploying, take a look at the KIND cluster configuration. This is worth understanding because you'll be working with this cluster for the entire course.

```bash
cat infrastructure/kind/cluster-config.yaml
```

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: lab
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      # Reference app dashboard
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
      # Grafana
      - containerPort: 30090
        hostPort: 30090
        protocol: TCP
      # Prometheus
      - containerPort: 30091
        hostPort: 30091
        protocol: TCP
      # Reserved for future services (Hermes UI, ArgoCD, etc.)
      - containerPort: 30400
        hostPort: 30400
        protocol: TCP
      - containerPort: 30500
        hostPort: 30500
        protocol: TCP
      - containerPort: 30600
        hostPort: 30600
        protocol: TCP
  - role: worker
  - role: worker
networking:
  apiServerAddress: "127.0.0.1"
```

**What to notice:**

- **3 nodes:** 1 control-plane + 2 workers. This gives you a realistic multi-node cluster for scheduling, affinity, and disruption budget labs later in the course.
- **6 port mappings:** 3 for current services (dashboard, Grafana, Prometheus) + 3 reserved buffer ports (30400, 30500, 30600) for services we'll deploy in later modules (Hermes UI, ArgoCD, agent dashboards, etc.).
- **NodePort range:** KIND uses the standard Kubernetes NodePort range (30000-32767). All services in the course use NodePort for simplicity — no ingress controller needed.

---

## Step 4: Deploy the Reference Application

This single command creates your entire lab environment:

```bash
cd reference-app
make deploy
```

**What this does (behind the scenes):**

1. Creates a 3-node KIND cluster named `lab` with all port mappings
2. Installs PostgreSQL via Helm into the `db` namespace
3. Installs Prometheus + Grafana (kube-prometheus-stack) into the `monitoring` namespace
4. Pulls four pre-built Docker images from Docker Hub (api-gateway, catalog, worker, dashboard)
5. Loads images into the KIND cluster
6. Deploys the reference app via Helm into the `app` namespace

> **Want to build from source?** Run `make deploy-from-source` instead. This compiles the Rust services locally and takes 5–10 minutes on first run.

**Expected time:** 5–10 minutes on first run (Docker pulls base images).

**Expected output (final lines):**

```
=== Deployment Complete ===
Dashboard:  http://localhost:30080
Grafana:    http://localhost:30090  (admin/admin)
Prometheus: http://localhost:30091
```

### Verify the deployment

Open these URLs in your browser:

- **Dashboard:** [http://localhost:30080](http://localhost:30080) — you should see three services (api-gateway, catalog, worker) with green health indicators
- **Grafana:** [http://localhost:30090](http://localhost:30090) — log in with `admin` / `admin`

From the terminal:

```bash
# Check all pods are running across all 3 nodes
kubectl get pods --all-namespaces --context kind-lab -o wide
```

You should see pods distributed across `lab-control-plane`, `lab-worker`, and `lab-worker2` nodes, all with `Running` status.

```bash
# Quick status check
make status
```

### Troubleshooting

**KIND cluster creation fails:**

```bash
# Clean up and retry
kind delete cluster --name lab
make deploy
```

**Pods stuck in Pending:**
Docker Desktop (or Rancher Desktop) may need more memory. Open Settings → Resources → increase Memory to 8 GB. With 3 nodes, the cluster needs a bit more headroom.

**Port 30080 already in use:**

```bash
lsof -i :30080
# Kill the conflicting process, then retry make deploy
```

---

## Step 5: Install Your AI Coding Agent

Choose ONE path. Both are fully supported throughout the course.

### Path A: Claude Code (recommended with Claude Pro/Team subscription)

Claude Code is Anthropic's terminal-based AI coding agent. It uses your existing Claude subscription — no separate API billing.

**Official docs:** [docs.anthropic.com/en/docs/claude-code](https://docs.anthropic.com/en/docs/claude-code/overview)

```bash
# Install (requires Node.js 18+ and npx)
npm install -g @anthropic-ai/claude-code

# Verify
claude --version

# Authenticate (opens browser for OAuth)
claude
```

Sign in with your Claude account when the browser opens. Once authenticated, you'll see the Claude Code terminal interface.

Type `/quit` to exit for now — we'll come back to configure MCP.

### Path B: Crush (free — no subscription required)

Crush (by Charm, formerly OpenCode) is an open-source terminal AI agent that works with 75+ LLM providers including several free options.

**Official repo:** [github.com/charmbracelet/crush](https://github.com/charmbracelet/crush)

```bash
# macOS
brew install charmbracelet/tap/crush

# Linux
curl -fsSL https://charm.sh/install.sh | sh
```

```bash
# Verify
crush --version

# Launch and connect to a free provider
crush
```

Inside Crush, run `/connect` and choose a free provider:

| Provider | Free Limit | Setup |
|----------|-----------|-------|
| **Gemini 2.5 Flash** (recommended) | 10 RPM / 500 req/day | Get API key from [aistudio.google.com](https://aistudio.google.com) |
| **Groq** (llama-3.1-8b) | 14,400 req/day | Get API key from [console.groq.com](https://console.groq.com) |
| **OpenRouter** (`:free` models) | Free credits | Sign up at [openrouter.ai](https://openrouter.ai) |

**Recommended: Gemini 2.5 Flash** — 500 requests/day is plenty for all labs (typical lab uses 5-15 requests).

Type `/quit` to exit for now.

---

## Step 6: Connect MCP Servers

This is where the magic happens. MCP (Model Context Protocol) lets your AI agent talk directly to your infrastructure — kubectl, PostgreSQL, GitHub — instead of just generating text.

### For Claude Code users

Claude Code uses a `.mcp.json` file in your project directory. Create it:

```bash
# Make sure you're in the course root directory
cd /path/to/401
```

Create the file `.mcp.json` in the course root:

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
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

> **Note on PostgreSQL:** The PostgreSQL service inside KIND is ClusterIP-only (no NodePort). You must keep a port-forward running while using the postgres MCP server:
>
> ```bash
> kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &
> ```
>
> We use local port **5433** (not 5432) to avoid conflicts with any PostgreSQL instance you may have running locally — a common setup for DevOps practitioners.

> **Note on GitHub:** The GitHub MCP server is optional for this lab. If you want to use it, create a personal access token at [github.com/settings/tokens](https://github.com/settings/tokens) and export it:
>
> ```bash
> export GITHUB_TOKEN=ghp_your_token_here
> ```

### For Crush users

Crush uses a similar MCP configuration. Add to your Crush config (typically `~/.config/crush/mcp.json`):

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
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://refapp:refapp-lab-password@localhost:5433/refapp"
      ]
    }
  }
}
```

### Starter files

Pre-built MCP configuration templates are available in `lab/starter/`:

- `mcp-claude-code.json` — Claude Code MCP config (copy to `.mcp.json` in course root)
- `mcp-crush.json` — Crush MCP config (copy to your Crush config directory)

```bash
# Claude Code users (from course root):
cp modules/module-01-welcome/lab/starter/mcp-claude-code.json .mcp.json

# Crush users:
mkdir -p ~/.config/crush
cp modules/module-01-welcome/lab/starter/mcp-crush.json ~/.config/crush/mcp.json
```

---

## Step 7: Smoke Test — Your First AI + Infrastructure Query

Now let's prove your AI agent can actually talk to your infrastructure.

### Start your AI agent

```bash
# Claude Code users (from the course root):
claude

# Crush users:
crush
```

### Test 1: Ask about your cluster

Type this into your AI agent:

```
What Kubernetes pods are running in my cluster?
List them grouped by namespace with their status.
```

**Expected behavior:** The agent uses the kubectl MCP server to run `kubectl get pods --all-namespaces` and returns a structured response showing pods across the 3-node cluster in `app`, `db`, `monitoring`, and `kube-system` namespaces.

If it works, your kubectl MCP connection is live.

### Test 2: Ask about your database

```
Connect to the PostgreSQL database and list all tables.
What schema does the refapp database have?
```

**Expected behavior:** The agent uses the postgres MCP server to query the database and returns table information.

> **Note:** If the postgres MCP connection fails, make sure the port-forward is running:
> ```bash
> kubectl port-forward svc/postgresql 5433:5432 -n db --context kind-lab &
> ```

### Test 3: Cross-platform query (the real test)

```
Check if all pods in the 'app' namespace are healthy,
then check the PostgreSQL database connection count.
Give me a quick health summary.
```

**Expected behavior:** The agent queries BOTH kubectl and PostgreSQL in a single response, correlating infrastructure state across two different systems. This is what MCP enables — your AI agent can reason across multiple data sources.

### What success looks like

If all three tests work, you've achieved something significant: your AI coding agent can now interact with your live Kubernetes cluster and database. It's not just generating text — it's reading real infrastructure state and reasoning about it.

This is the foundation for every lab in this course.

---

## Step 8: Run the Full Verification

The course provides an automated verification script that checks 29+ items (exact count varies by which optional tools are installed):

```bash
# From the course root directory
bash setup/verify.sh
```

**Expected final output:**

```
=== Results: 26 passed, 0 failed ===

Ready for labs!
```

If any checks fail, the script shows specific remediation steps. See `setup/SETUP.md` Troubleshooting section for common fixes.

---

## Checklist — Module 01 Complete

Before moving on, confirm:

- [ ] Docker Desktop (or Rancher Desktop) running with adequate resources (4+ CPU, 6+ GB RAM)
- [ ] KIND cluster `lab` is running with 3 nodes (`kubectl get nodes --context kind-lab`)
- [ ] Reference app deployed — dashboard accessible at [localhost:30080](http://localhost:30080)
- [ ] Grafana accessible at [localhost:30090](http://localhost:30090)
- [ ] AI coding agent installed (Claude Code or Crush)
- [ ] MCP servers configured (at minimum: kubernetes)
- [ ] Smoke test passed — AI agent can query your cluster
- [ ] `bash setup/verify.sh` shows all PASS

---

## Port Reference

| Port | Service | Status |
|------|---------|--------|
| 30080 | Reference app dashboard | Used from Module 01 |
| 30090 | Grafana | Used from Module 01 |
| 30091 | Prometheus | Used from Module 01 |
| 30400 | Reserved | Available for later modules |
| 30500 | Reserved | Available for later modules |
| 30600 | Reserved | Available for later modules |

---

## What You've Built

```
┌──────────────────────────────────────────────────────┐
│  YOUR LAPTOP                                          │
│                                                        │
│  ┌──────────────────────────────────────────────────┐ │
│  │  Docker Desktop / Rancher Desktop                 │ │
│  │                                                    │ │
│  │  ┌──────────────────────────────────────────────┐ │ │
│  │  │  KIND Cluster ("lab") — 3 nodes               │ │ │
│  │  │  control-plane + worker + worker2             │ │ │
│  │  │                                                │ │ │
│  │  │  [app]        [db]      [monitoring]          │ │ │
│  │  │  API Gateway  Postgres  Prometheus            │ │ │
│  │  │  Catalog                Grafana               │ │ │
│  │  │  Worker                                       │ │ │
│  │  │  Dashboard                                    │ │ │
│  │  │                                                │ │ │
│  │  │  Ports: 30080, 30090, 30091                    │ │ │
│  │  │  Reserved: 30400, 30500, 30600                │ │ │
│  │  └──────────────────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────┘ │
│                                                        │
│  ┌──────────────────────────────────────────────────┐ │
│  │  AI Coding Agent (Claude Code / Crush)            │ │
│  │  ├── kubectl MCP  ────→ KIND cluster              │ │
│  │  ├── postgres MCP ────→ PostgreSQL                │ │
│  │  └── github MCP   ────→ GitHub (optional)         │ │
│  └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

**Congratulations** — you're ready for the rest of the course. Your AI agent is no longer just a chatbot. It can see your infrastructure, query your databases, and reason across multiple systems.

Next up: **Module 02 — AI Foundations for DevOps Teams**, where you'll have your first real conversation with AI using operational data from this environment.
