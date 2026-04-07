# Two Paradigms, One Agent

This directory contains the **same Kubernetes pod health investigator agent built two ways**:

| Directory | Paradigm | What you write |
|---|---|---|
| `langgraph-version/` | Code-orchestrated (LangGraph) | One Python file (~350 lines) — state schema, node functions, graph wiring, prompt construction, response parsing |
| `hermes-version/` | Context-orchestrated (Hermes / Claude Code) | Three text files (~220 lines) — `SOUL.md` (identity), `SKILL.md` (procedure), `config.yaml` (governance) |

**Read `COMPARISON.md` first** for the full conceptual side-by-side. This README covers **how to run them**.

---

## What you'll need

| Tool | Why | Install |
|---|---|---|
| Python 3.10+ | LangGraph version | `python3 --version` |
| `git` | Cloning the test workloads | `git --version` |
| `kubectl` | Talk to Kubernetes | https://kubernetes.io/docs/tasks/tools/ |
| Docker Desktop (or Rancher Desktop / Podman) | Run a local cluster | https://www.docker.com/products/docker-desktop/ |
| `kind` | Spin up Kubernetes-in-Docker | https://kind.sigs.k8s.io/docs/user/quick-start/#installation |
| Hermes Agent CLI | Hermes version only | https://hermes.sh — `curl -fsSL https://hermes.sh/install.sh \| sh` |
| A free **Gemini API key** | LLM provider for both agents | https://aistudio.google.com/apikey |

> **Why Gemini?** Free tier (10 req/min, 500 req/day for `gemini-2.5-flash`), no credit card, plenty for these labs. If you'd rather use a different provider (Claude, OpenAI, Groq, OpenRouter, etc.), see [Use a different LLM provider](#use-a-different-llm-provider) below — both agents support it with a small edit.

---

## Step 1 — Get a Gemini API key

1. Go to https://aistudio.google.com/apikey
2. Sign in with a Google account, click **Create API key**
3. Copy the key and export it in your shell:

```bash
export GEMINI_API_KEY="AIza..."
```

To make it permanent, add that line to `~/.zshrc` or `~/.bashrc`.

---

## Step 2 — Stand up a test cluster with broken pods

Both agents need a Kubernetes cluster with some unhealthy pods to investigate. We'll use `kind` (Kubernetes in Docker) and apply manifests from the [`kube-troublesim`](https://github.com/kubeagentix/kube-troublesim) repo, which intentionally creates pods in `ImagePullBackOff`, `CrashLoopBackOff`, `Pending`, and other unhealthy states.

```bash
# Make sure Docker Desktop is running first.

# Create a 1-control-plane / 2-worker cluster (takes ~60 seconds)
kind create cluster --name lab

# Verify
kubectl get nodes
# Expect: 3 nodes Ready

# Clone the troublesim repo and apply set01 to a 'troubled' namespace
git clone https://github.com/kubeagentix/kube-troublesim.git /tmp/kube-troublesim
kubectl create namespace troubled
kubectl apply -n troubled -f /tmp/kube-troublesim/set01/

# Wait ~90 seconds for failure modes to stabilise, then look:
sleep 90
kubectl get pods -n troubled
```

You should see something like:

```
NAME                                   READY   STATUS              RESTARTS
configmap-mount-test-d449d85b9-lvk4g   0/1     ContainerCreating   0
crashloop-test-6968688c54-p2hth        1/1     Running             3
imagepull-test-565f5d9cbd-8ks5t        0/1     ImagePullBackOff    0
imagepull-test-565f5d9cbd-k4g2h        0/1     ImagePullBackOff    0
liveness-probe-test-77464549fd-m87c7   0/1     Running             3
nginx-deployment-86c57bc6b8-cfmgc      1/1     Running             0
resource-limit-test-85d74d49cf-bw52z   0/1     Pending             0
...
```

**That's the input both agents will diagnose.** If you don't see any failing pods yet, wait another minute — `CrashLoopBackOff` and `ImagePullBackOff` take a few retry cycles to surface.

---

## Step 3 — Run the LangGraph version

```bash
cd langgraph-version

# One-time setup: virtual environment + dependencies
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run the agent against the troubled namespace
python3 k8s_pod_investigator.py troubled
```

**What you'll see:** the agent runs through its hard-wired graph — `check_pods` → `filter_unhealthy` → `pull_logs` → `check_deployments` → `diagnose` → `format_report` — and prints a structured investigation report to stdout. The whole run takes ~10–20 seconds.

> **Heads-up about the diagnosis output:** Gemini tends to wrap JSON responses in ```` ```json ```` code fences, and the LangGraph version's response parser does a strict `json.loads()`. When parsing fails, the script falls into a fallback path: the raw model text is preserved in the `DIAGNOSIS:` block, but `severity` defaults to `WARNING` and `RECOMMENDATIONS:` shows _"Manual investigation needed — LLM response was not structured"_. **This is not a bug in your setup — it's exactly the failure mode `COMPARISON.md` calls out** ("you parse the LLM response — hope it's valid JSON"). It's part of the lesson.

---

## Step 4 — Run the Hermes version

The Hermes version runs as a **profile** — an isolated Hermes instance with its own config, skills, and credentials. We create a profile, copy the three agent files into it, and tell Hermes how to reach Gemini.

### One-time install

```bash
# From the paradigm-comparison directory:

# 1. Create an isolated Hermes profile
hermes profile create k8s-investigator

PROFILE_DIR="$HOME/.hermes/profiles/k8s-investigator"

# 2. Install the three agent files
cp hermes-version/SOUL.md       "$PROFILE_DIR/SOUL.md"
cp hermes-version/config.yaml   "$PROFILE_DIR/config.yaml"

mkdir -p "$PROFILE_DIR/skills/devops/k8s-pod-health-investigator"
cp hermes-version/SKILL.md      "$PROFILE_DIR/skills/devops/k8s-pod-health-investigator/SKILL.md"

# 3. Wire your Gemini key into the profile.
#    Hermes' custom-provider auth chain reads OPENAI_API_KEY for
#    OpenAI-compatible endpoints, so we map GEMINI_API_KEY into it.
echo "OPENAI_API_KEY=$GEMINI_API_KEY" > "$PROFILE_DIR/.env"

# 4. (Optional but recommended) verify the wiring
HERMES_HOME="$PROFILE_DIR" hermes status
# Expect: Model: gemini-2.5-flash, Provider: custom:google-ai-studio,
#         OpenAI key shown as ✓
```

### Run the agent

**Non-interactive (one-shot):**

```bash
HERMES_HOME="$HOME/.hermes/profiles/k8s-investigator" \
  hermes chat --yolo --max-turns 30 \
    -s k8s-pod-health-investigator \
    -q "Investigate unhealthy pods in the troubled namespace and produce the structured investigation report defined in your skill."
```

**Interactive chat session** (better for exploring):

```bash
HERMES_HOME="$HOME/.hermes/profiles/k8s-investigator" \
  hermes chat -s k8s-pod-health-investigator
```

Then type your investigation request at the prompt. When Hermes wants to run a destructive command it'll pause for approval (because `approvals.mode: manual` in the profile config).

**What you'll see:** the agent reads its `SKILL.md` procedure, then autonomously runs ~15–20 `kubectl` commands in parallel (`get pods`, `describe pod` × N, `logs --previous`, `get deployments`, `get events`), adapts when a command fails (e.g. retries `kubectl logs` without `--previous` when there's no prior container), and produces the full structured report from the SKILL.md template — including FINDINGS, ROOT CAUSES, RECOMMENDATIONS, and ESCALATIONS.

---

## What to compare

When you run both agents back-to-back against the same `troubled` namespace, watch for:

1. **Adaptation when commands fail** — Hermes retries `kubectl logs` without `--previous` when the flag fails. LangGraph has a hard-coded retry path for that one specific case (because the developer thought of it). Try breaking something the LangGraph code _didn't_ anticipate and see what happens.
2. **Output structure** — Hermes' report follows the SKILL.md template directly (Markdown sections you can edit). LangGraph hardcodes the output format in `format_report()`.
3. **Code volume** — `k8s_pod_investigator.py` is ~350 lines of Python. The Hermes agent is ~220 lines of Markdown + YAML and **zero Python**.
4. **Where the intelligence lives** — In LangGraph, the orchestration logic is in your code (graph edges decide what runs next). In Hermes, the procedure is in `SKILL.md` and the model decides what runs next.
5. **Adding governance** — In `config.yaml` change `approvals.mode: manual` to see Hermes pause before any non-allowlisted command. To get the same effect in LangGraph you'd need to add ~100–150 lines of approval-gate code (see "Step 7" comment block at the bottom of `k8s_pod_investigator.py`).

---

## Use a different LLM provider

### LangGraph version

Edit two lines in `langgraph-version/k8s_pod_investigator.py`:

```python
# Original:
from langchain_google_genai import ChatGoogleGenerativeAI
...
llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash")

# Anthropic Claude:
from langchain_anthropic import ChatAnthropic         # pip install langchain-anthropic
llm = ChatAnthropic(model="claude-sonnet-4-20250514") # needs ANTHROPIC_API_KEY

# OpenAI:
from langchain_openai import ChatOpenAI               # pip install langchain-openai
llm = ChatOpenAI(model="gpt-4o-mini")                 # needs OPENAI_API_KEY

# Groq (free, very fast):
from langchain_groq import ChatGroq                   # pip install langchain-groq
llm = ChatGroq(model="llama-3.1-8b-instant")          # needs GROQ_API_KEY
```

Then add the matching package to `requirements.txt` (or just `pip install` it) and re-run.

### Hermes version

Edit `hermes-version/config.yaml` (or directly `~/.hermes/profiles/k8s-investigator/config.yaml` if you've already installed). The two blocks to change are `model:` and `custom_providers:`. Examples:

```yaml
# Anthropic Claude (native, no custom_providers needed):
model:
  default: "claude-sonnet-4-20250514"
  provider: "anthropic"
# Then put ANTHROPIC_API_KEY in the profile .env

# Groq (free, fast, OpenAI-compatible):
model:
  default: "llama-3.1-8b-instant"
  provider: "custom:groq"
custom_providers:
  - name: groq
    base_url: https://api.groq.com/openai/v1
    api_mode: chat_completions
# Then put OPENAI_API_KEY=<your-groq-key> in the profile .env
```

See [Hermes provider docs](https://hermes.sh/docs/integrations/providers) for the full list.

---

## Tear down when you're done

```bash
# Drop the workloads but keep the cluster
kubectl delete namespace troubled

# Or delete the whole cluster
kind delete cluster --name lab

# Remove the Hermes profile
hermes profile delete k8s-investigator
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `kubectl: command not found` | kubectl not installed or not on PATH | Install from https://kubernetes.io/docs/tasks/tools/ |
| `error: failed to create cluster` (kind) | Docker Desktop isn't running | Start Docker Desktop and wait until the whale icon goes solid, then retry |
| `kind: command not found` | kind not installed | `brew install kind` (macOS) or see https://kind.sigs.k8s.io |
| LangGraph: `ModuleNotFoundError: langgraph` | Forgot to activate venv | `source .venv/bin/activate` then re-run |
| LangGraph: empty / `KeyError` errors | `GEMINI_API_KEY` not set in this shell | `export GEMINI_API_KEY="AIza..."` and re-run |
| LangGraph: `RECOMMENDATIONS: Manual investigation needed — LLM response was not structured` | Gemini wrapped its JSON in ```` ```json ```` fences and the strict parser failed | **Expected** — see the heads-up in Step 3 above. The full diagnosis is still in the `DIAGNOSIS:` block. |
| Hermes: `Provider: ✗ no API key` in `hermes status` | Profile `.env` missing or `OPENAI_API_KEY` not set in it | `echo "OPENAI_API_KEY=$GEMINI_API_KEY" > ~/.hermes/profiles/k8s-investigator/.env` |
| Hermes: `HERMES_HOME` env var ignored | You ran `hermes` without the prefix | Always prefix: `HERMES_HOME=~/.hermes/profiles/k8s-investigator hermes ...`, or use the wrapper script Hermes creates at `~/.local/bin/k8s-investigator` |
| Hermes: agent stops after one tool call | Sometimes happens with terse prompts on small models | Use a more directive prompt: _"Follow your SKILL.md procedure end-to-end. Do not stop after the first command — keep going until the report is complete."_ |
| Both agents: report says "all pods healthy" | The troubled-namespace pods haven't reached failure state yet | `kubectl get pods -n troubled` — wait until you see `ImagePullBackOff` / `CrashLoopBackOff` |
| `kind create cluster` fails on Windows / no Docker | Docker won't run on this machine | Use `mock-bin/kubectl` (see below) instead of a real cluster |

### No-Docker fallback: `mock-bin/kubectl`

If you can't run Docker (corporate-locked Windows machine, no admin rights, etc.), there's a mock `kubectl` shell wrapper at `mock-bin/kubectl` that returns canned data for an unhealthy `payments` namespace. To use it, prepend `mock-bin/` to your `PATH` before running either agent:

```bash
export PATH="$PWD/mock-bin:$PATH"
# now run either agent against the 'payments' namespace
python3 langgraph-version/k8s_pod_investigator.py payments
```

The mock returns realistic JSON for `kubectl get pods`, `describe`, `logs`, `get events`, etc. — enough for both agents to complete a full investigation loop without a real cluster. Use it for code-walk-throughs and CI; use a real cluster for the real lesson.

---

## File map

```
paradigm-comparison/
├── README.md              ← you are here
├── COMPARISON.md          ← conceptual side-by-side (read this first)
├── langgraph-version/
│   ├── k8s_pod_investigator.py   ← the entire LangGraph agent
│   └── requirements.txt
├── hermes-version/
│   ├── SOUL.md            ← agent identity + NEVER rules
│   ├── SKILL.md           ← investigation procedure
│   └── config.yaml        ← model + governance + toolsets
└── mock-bin/
    └── kubectl            ← canned-data fake kubectl for no-Docker fallback
```
