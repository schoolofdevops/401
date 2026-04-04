# Agentic DevOps Workshop — Environment Setup

**Estimated time:** 30–45 minutes

**What you'll set up:**
- Docker (container runtime)
- KIND (local Kubernetes cluster)
- kubectl and Helm (Kubernetes tools)
- An AI coding tool: Claude Code **or** OpenCode (your choice — both fully supported)
- The reference microservices application (your lab environment for the whole course)

**Prerequisites:**
- macOS or Linux (Windows users: run everything inside WSL2 — see Windows Notes at the bottom)
- Terminal proficiency: you're comfortable running commands and reading output
- Text editor: any editor you like (VS Code, Neovim, whatever you use day-to-day)

---

## Step 1: Docker

All Kubernetes labs run containers locally. Docker is the required container runtime.

### Install Docker Desktop

Download from [docker.com/get-started](https://www.docker.com/get-started/) and install. Docker Desktop includes the Docker daemon, CLI, and Docker Compose.

> **macOS ARM (Apple Silicon):** Download the Apple Silicon installer, not the Intel one.

### Allocate enough resources

Open Docker Desktop → Settings → Resources and set:

- **CPUs:** 4+
- **Memory:** at least 6 GB (Prometheus + app services + PostgreSQL need ~4 GB combined; leave headroom)
- **Disk:** at least 30 GB

### Verify

```bash
docker info
```

Expected output starts with:

```
Client: Docker Engine - Community
 Version:    26.x.x
Server: Docker Desktop
```

```bash
docker --version
```

Expected output:

```
Docker version 26.1.3, build b72abbb
```

> **Version requirement:** Docker 24 or later. If your output shows an older version, update Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/).

---

## Step 2: Kubernetes Tools

### Install KIND (Kubernetes IN Docker)

KIND runs a complete Kubernetes cluster as Docker containers on your laptop. No cloud account required.

**macOS:**

```bash
brew install kind
```

Or install the binary directly:

```bash
# Apple Silicon
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.27.0/kind-darwin-arm64
chmod +x kind && sudo mv kind /usr/local/bin/

# Intel
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.27.0/kind-darwin-amd64
chmod +x kind && sudo mv kind /usr/local/bin/
```

**Linux (x86_64):**

```bash
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.27.0/kind-linux-amd64
chmod +x kind && sudo mv kind /usr/local/bin/
```

**Verify:**

```bash
kind version
```

Expected output:

```
kind v0.27.0 go1.23.3 linux/amd64
```

> **Minimum version:** KIND v0.27 or later.

### Install kubectl

**macOS:**

```bash
brew install kubectl
```

Or use the Docker Desktop bundled version (it's installed automatically with Docker Desktop).

**Linux:**

```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

**Verify:**

```bash
kubectl version --client
```

Expected output:

```
Client Version: v1.32.0
Kustomize Version: v5.5.0
```

### Install Helm

Helm is the Kubernetes package manager used to deploy the reference application and observability stack.

**macOS:**

```bash
brew install helm
```

**Linux:**

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

**Verify:**

```bash
helm version
```

Expected output:

```
version.BuildInfo{Version:"v3.18.4", ...}
```

> **Minimum version:** Helm 3.x (any Helm 3 release works).

---

## Step 3: AWS CLI (Optional — for real AWS connection)

The course includes labs that work against real AWS services. If you have an AWS account, install the AWS CLI. If you don't, skip this step — all labs have a mock data fallback that works without any AWS credentials.

**Install AWS CLI v2:**

**macOS:**

```bash
brew install awscli
```

Or use the official installer from [docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

**Linux:**

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
```

**Verify:**

```bash
aws --version
```

Expected output:

```
aws-cli/2.22.0 Python/3.12.7 ...
```

**Configure (if you have an AWS account):**

```bash
aws configure
```

Enter your Access Key ID, Secret Access Key, default region (e.g., `us-east-1`), and output format (`json`).

> **No AWS account?** That's fine. All labs that use AWS services have a local mock fallback. You'll see a note at the start of each AWS lab indicating the mock path.

---

## Step 4: AI Coding Tool — Choose Your Path

The course supports two equally valid AI coding tools. Choose the one that works for your situation. Both are terminal-based agents you'll use throughout all labs.

### Path A: Claude Code (recommended if you have a Claude Pro/Team subscription)

Claude Code is Anthropic's official terminal AI coding agent. It uses your existing Claude subscription — no separate API billing.

**Requirements:** An active Claude Pro ($20/month) or Claude Team subscription at claude.ai.

**Install Node.js first** (if not already installed):

```bash
node --version   # must be v18 or later
```

If Node.js is not installed or is older than v18:

```bash
brew install node   # macOS
# or use nvm: https://github.com/nvm-sh/nvm
```

**Install Claude Code:**

```bash
npm install -g @anthropic-ai/claude-code
```

**Verify:**

```bash
claude --version
```

Expected output:

```
1.x.x (claude-code)
```

**Authenticate:**

Run `claude` in your terminal for the first time. It opens a browser window for OAuth authentication. Sign in with your Claude account.

```bash
claude
```

Expected: browser opens, you log in, terminal shows your Claude workspace.

> **Note:** Claude Code uses your existing Claude subscription. No additional API costs or token billing.

> **Known issue — January 2026 Anthropic OAuth block:** In January 2026, Anthropic temporarily blocked OAuth-based authentication for Claude Code in some regions. If you encounter an authentication error during the first `claude` run:
> 1. Update to the latest version: `npm update -g @anthropic-ai/claude-code`
> 2. Check [status.anthropic.com](https://status.anthropic.com) for current auth status
> 3. As a workaround, set an API key directly: `export ANTHROPIC_API_KEY=sk-ant-...` (get key from [console.anthropic.com](https://console.anthropic.com))
>
> This issue was resolved for most users by February 2026 and is documented here for reference only.

---

### Path B: OpenCode (free — no subscription required)

OpenCode (from [opencode.ai](https://opencode.ai)) is a terminal-based AI coding agent maintained by the SST team. It supports 75+ LLM providers including several completely free options. No Claude subscription needed.

> **Important:** This is `sst/opencode` from [opencode.ai](https://opencode.ai) — not the archived `opencode-ai/opencode` project (archived September 2025), and not any other terminal agent tool with a similar name. Use the installer from opencode.ai only.

**Install:**

**macOS:**

```bash
brew install sst/tap/opencode
```

**Linux:**

```bash
curl -fsSL https://opencode.ai/install.sh | sh
```

**Verify:**

```bash
opencode --version
```

Expected output:

```
opencode 0.x.x
```

**Connect to a provider:**

Run `opencode` in your terminal, then use the `/connect` command to configure a free LLM provider.

```bash
opencode
```

Inside OpenCode:

```
/connect
```

This opens the provider selector. Choose one of the free providers below.

**Recommended free providers for this course:**

| Provider | Free Limit | Best For |
|----------|-----------|---------|
| Gemini 2.5 Flash | 10 RPM / 500 req/day | All labs — recommended default |
| Groq (llama-3.1-8b-instant) | 14,400 req/day | Fast inference demos |
| OpenRouter (`:free` models) | Free credits on signup | Flexible fallback |

**Quick setup for Gemini 2.5 Flash (recommended):**
1. Go to [aistudio.google.com](https://aistudio.google.com) and sign in with your Google account
2. Click "Get API Key" → "Create API Key"
3. Copy the key
4. In OpenCode: `/connect` → select Google → paste your API key
5. Select model: `gemini-2.5-flash`

> 500 requests/day is more than enough for all course labs. A typical lab uses 5–15 requests.

For full provider details, rate limits, and cost estimates, see [llm-access.md](llm-access.md).

---

## Step 5: Clone the Course Repository

```bash
git clone https://github.com/YOUR_ORG/agentic-devops-course.git
cd agentic-devops-course
```

> **Note:** Replace the URL with the actual repository URL provided by your instructor. If you received a zip file instead, extract it and `cd` into the course directory.

Verify you're in the right place:

```bash
ls
```

You should see: `modules/`, `reference-app/`, `infrastructure/`, `setup/`, `CLAUDE.md`, and other top-level files.

---

## Step 6: Deploy the Reference Application

The reference application is a microservices system that serves as the lab environment for the entire course. It includes:
- Three Rust backend services (api-gateway, catalog, worker)
- A Svelte health dashboard
- PostgreSQL database
- Prometheus + Grafana for observability

Deploy everything with a single command:

```bash
cd reference-app
make deploy
```

**What this does:**
1. Creates a KIND cluster named `lab`
2. Installs PostgreSQL via Helm
3. Installs Prometheus + Grafana (kube-prometheus-stack)
4. Builds and deploys the three Rust services and dashboard

**Expected time:** 5–10 minutes on first run (Docker pulls images).

**Expected output:**

```
Creating KIND cluster 'lab'...
Installing PostgreSQL...
Installing Prometheus stack...
Deploying reference app...

Deployment complete!
Dashboard: http://localhost:30080
Grafana:   http://localhost:30090 (admin/admin)
```

**Verify the deployment:**

Open [http://localhost:30080](http://localhost:30080) in your browser. You should see the health dashboard showing three services: `api-gateway`, `catalog`, and `worker`, all with green "healthy" status indicators.

Optional: Open [http://localhost:30090](http://localhost:30090) to see Grafana. Log in with `admin` / `admin`.

---

## Step 7 (Optional): Datadog as Alternative Observability

The course default is Prometheus + Grafana, pre-installed in Step 6. If you want experience with SaaS observability tooling, Datadog offers a free tier that works alongside the lab environment.

> **This step is entirely optional.** All observability labs have a Prometheus path. Datadog is documented here for participants who want exposure to commercial observability tooling.

### Datadog Free Tier Setup

1. Sign up at [app.datadoghq.com](https://app.datadoghq.com) — the free tier includes up to 5 hosts and 1-day metric retention
2. After signup, go to your account settings and copy your API key
3. Install the Datadog Agent on the KIND cluster:

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm install datadog-agent datadog/datadog \
  --set datadog.apiKey=<YOUR_DATADOG_API_KEY> \
  --set datadog.site=datadoghq.com \
  --namespace monitoring \
  --create-namespace
```

4. Verify the agent appears in your [Datadog Infrastructure page](https://app.datadoghq.com/infrastructure) within 2–3 minutes.

**When to use Datadog vs Prometheus:**

| | Prometheus + Grafana | Datadog |
|---|---|---|
| Setup | Already done via `make deploy` | Requires account + Helm install above |
| Cost | Free (local) | Free tier (5 hosts, 1-day retention) |
| Experience | Open-source, self-hosted | Commercial SaaS |
| Lab support | Full support, all labs | Alternative path, observability labs only |

---

## Step 8: Verify Your Environment

Run the course verification script to confirm everything is working:

```bash
bash setup/verify.sh
```

**Expected output:**

```
=== Agentic DevOps Course — Environment Verification ===

--- Required CLI Tools ---
  PASS  Docker daemon running
  PASS  Docker version >= 24
  PASS  kubectl installed
  PASS  kind installed
  PASS  kind version >= 0.27
  PASS  Helm installed
  PASS  Helm version >= 3
  PASS  Node.js installed
  PASS  Node.js version >= 18

--- AI Coding Tools (at least one required) ---
  PASS  Claude Code installed     (or)
  PASS  OpenCode installed

--- Optional Tools ---
  PASS  git installed

--- KIND Cluster ---
  PASS  KIND cluster 'lab' exists
  PASS  kubectl context 'kind-lab' configured
  PASS  kubectl can reach KIND cluster (nodes ready)

--- Reference App ---
  PASS  Reference app Cargo workspace exists
  PASS  Helm chart exists
  PASS  Makefile exists
  PASS  Dashboard package.json exists

--- Mock Data Files ---
  PASS  mock-data/cloudwatch/describe-alarms-clean.json
  PASS  mock-data/cloudwatch/describe-alarms-anomaly.json
  PASS  mock-data/cost-explorer/normal-spend.json
  PASS  mock-data/cost-explorer/anomaly-spike.json
  PASS  mock-data/ec2/describe-instances.json

--- Mock Wrappers ---
  PASS  mock-aws wrapper
  PASS  mock-kubectl wrapper

--- Mock Mode Smoke Tests ---
  PASS  mock-aws CloudWatch alarms return data
  PASS  mock-aws Cost Explorer returns data

--- Deployment Status ---
  PASS  App pods running in namespace 'app'
  PASS  Dashboard accessible at localhost:30080

=== Results: 26 passed, 0 failed ===

Ready for labs!
```

If any checks FAIL, see the Troubleshooting section below.

---

## Troubleshooting

**Docker not running:**
Start Docker Desktop, wait 30 seconds, then retry `bash setup/verify.sh`.

**KIND cluster creation fails:**
```bash
kind delete cluster --name lab
cd reference-app && make deploy
```

**Dashboard not accessible at localhost:30080:**
```bash
kubectl get pods -n app --context kind-lab
```
All pods should show `Running`. If pods are in `Pending` or `CrashLoopBackOff`, check Docker resources.

**Pods stuck in Pending:**
Docker Desktop may need more memory. Open Docker Desktop → Settings → Resources → increase Memory to 8 GB.

**OpenCode provider connection fails:**
- Verify your API key is correct (re-copy from the provider console)
- Check the provider's status page for rate limit resets
- Try a different provider (e.g., switch from Gemini to Groq)

**Port 30080 already in use:**
```bash
lsof -i :30080
```
Find the process and stop it, or adjust the port in `infrastructure/kind/cluster-config.yaml`.

**Claude Code authentication fails (OAuth error):**
- Update Claude Code: `npm update -g @anthropic-ai/claude-code`
- Check [status.anthropic.com](https://status.anthropic.com)
- Use an API key as a workaround: `export ANTHROPIC_API_KEY=sk-ant-...`

**Node.js version too old:**
```bash
node --version
```
If version is below v18, install or update Node.js:
```bash
brew install node    # macOS
# or use nvm: nvm install 18 && nvm use 18
```

**`kind` or `kubectl` not found after installation:**
The binary may not be in your PATH. Check:
```bash
echo $PATH
```
Ensure `/usr/local/bin` is included. Add it if missing: `export PATH="$PATH:/usr/local/bin"`.

---

## Windows Notes (WSL2)

All lab commands run inside WSL2. The recommended setup:

1. Install WSL2 with Ubuntu 22.04+: open PowerShell as Administrator and run `wsl --install`
2. Install Docker Desktop for Windows with WSL2 integration enabled (Settings → Resources → WSL Integration → enable your Ubuntu distro)
3. Inside WSL2, install KIND, kubectl, and Helm using the Linux installation commands above
4. Claude Code and OpenCode both work natively on Windows — you can run them in PowerShell or WSL2
5. All `bash setup/*.sh` scripts must be run from a WSL2 terminal

> **Why WSL2?** Lab shell scripts and the reference app Makefile use bash. Windows PowerShell is not compatible with bash scripts. WSL2 gives you a real Linux environment on Windows without a separate VM.

---

## What's Next

Once `bash setup/verify.sh` shows all PASS:

1. Open the course modules at `modules/module-01-ai-foundations/`
2. Read the `README.md` for Module 1 — it has lab prerequisites and learning objectives
3. Start with `modules/module-01-ai-foundations/lab/LAB.md`

The lab will tell you which AI tool to use (Claude Code or OpenCode) and whether to run in mock mode or with the live KIND cluster.

Good luck — you're ready.
