# Installing Hermes

Hermes is the agent framework used throughout this course for all hands-on labs in Modules 7–13. This guide walks you through installation and connecting Hermes to an LLM provider.

**Time required:** 10–15 minutes

---

## Prerequisites

- macOS 12+ (arm64 or x86_64) or Ubuntu 22.04+
- Python 3.11 or later (`python3 --version`)
- Docker Desktop or Docker Engine (required for KIND-based Kubernetes labs)
- Terminal access (bash or zsh)

---

## Step 1: Install Hermes

### Method A: Install via uv (Recommended)

`uv` is a fast Python package manager. If you do not have it:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then install Hermes:

```bash
uv tool install hermes-agent
```

### Method B: Install via pip

If you prefer pip:

```bash
pip install hermes-agent
```

> **Note:** Use `pip3` if your system defaults to Python 2.

### Verify the installation

```bash
hermes --version
```

Expected output:

```
hermes v0.7.0
```

If you see `command not found`, add the install location to your PATH. For `uv`, this is typically `~/.local/bin`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Add this line to your `~/.zshrc` or `~/.bashrc` to persist across sessions, then restart your terminal.

---

## Step 2: Choose Your LLM Provider

Pick **one** of the four options below based on what you already have access to. All four work equally well for the lab exercises.

---

### Option A: Claude Code OAuth

**For:** Participants with an active Claude Pro or Claude Team subscription.

**Why this works:** Hermes can borrow the OAuth token that Claude Code stores after login — no separate API key needed.

**Step 1 — Ensure Claude Code is authenticated:**

```bash
claude auth status
```

If not logged in:

```bash
claude auth login
```

**Step 2 — Connect Hermes to Claude Code:**

```bash
hermes login --provider claude-code
```

Hermes reads the OAuth token from the Claude Code credential store. No API key is required.

**Step 3 — Verify the connection:**

```bash
hermes run "say: OK"
```

Expected output:

```
OK
```

---

### Option B: Google AI Studio

**For:** Participants without a Claude subscription. Google AI Studio is completely free — no credit card required.

**Step 1 — Get a free API key:**

1. Go to [aistudio.google.com](https://aistudio.google.com)
2. Sign in with your Google account
3. Click **Get API key** → **Create API key**
4. Copy the key (starts with `AIza…`)

**Step 2 — Connect Hermes:**

```bash
hermes login --provider google-ai-studio --api-key YOUR_API_KEY
```

Replace `YOUR_API_KEY` with the key you copied.

**Step 3 — Set the model to Gemini 2.5 Flash:**

```bash
hermes config set model gemini-2.5-flash
```

**Step 4 — Verify the connection:**

```bash
hermes run "say: OK"
```

Expected output:

```
OK
```

---

### Option C: Hugging Face Inference

**For:** Participants who want an open-weight model. The free tier requires no credit card.

**Step 1 — Get a free HF access token:**

1. Sign up or log in at [huggingface.co](https://huggingface.co)
2. Go to **Settings → Access Tokens → New token**
3. Select **Read** scope, name it `hermes-lab`, copy the token

**Step 2 — Connect Hermes:**

```bash
hermes login --provider huggingface --api-key YOUR_HF_TOKEN
```

**Step 3 — Set the model:**

```bash
hermes config set model meta-llama/Llama-3.1-8B-Instruct
```

> **Note:** Response latency on the free HF tier is 2–5 seconds per request. This is normal.

**Step 4 — Verify the connection:**

```bash
hermes run "say: OK"
```

Expected output:

```
OK
```

---

### Option D: OpenRouter

**For:** Participants who want flexibility — OpenRouter provides a single API key that routes to multiple model families (Claude, Gemini, Llama, Mistral, and more).

**Step 1 — Create a free account and get credits:**

1. Go to [openrouter.ai](https://openrouter.ai)
2. Sign up — free credits are added automatically on first signup
3. Go to **Keys → Create Key**, copy the key

**Step 2 — Connect Hermes:**

```bash
hermes login --provider openrouter --api-key YOUR_OPENROUTER_KEY
```

**Step 3 — Set the default model:**

```bash
hermes config set model anthropic/claude-haiku-4-5
```

> **Tip:** OpenRouter also supports free-tier models. Append `:free` to a model name to use the free version, e.g., `meta-llama/llama-3.1-8b-instruct:free`.

**Step 4 — Verify the connection:**

```bash
hermes run "say: OK"
```

Expected output:

```
OK
```

---

## Step 3: Set the Default Model to Haiku

All lab exercises are designed for a fast, inexpensive model. Set Haiku as your default:

```bash
hermes config set model claude-haiku-4-5
```

Or edit `~/.hermes/config.yaml` directly:

```yaml
model: claude-haiku-4-5
```

> **Why Haiku?** Skills give Hermes structured instructions and mock data is compact JSON, so Haiku produces correct results at near-zero token cost. Upgrade to Sonnet only for the complex reasoning scenarios in Module 10. See [llm-access.md](llm-access.md) for a full model selection guide and cost estimates.

> **Note on `HERMES_LAB_MODE`:** This environment variable (`mock` or `live`) controls whether Hermes uses pre-baked mock data or real infrastructure. It is set per-lab in each module's instructions — not here. Do not set it globally.

---

## Step 4: Verify the Full Setup

After completing Steps 1–3, run the environment validation script:

```bash
bash course/setup/verify.sh
```

Expected output:

```
[PASS] hermes --version: v0.7.0
[PASS] LLM connectivity: OK
[PASS] Docker: running
[PASS] KIND: v0.31.0 or later (run setup-kind.md if missing)
[PASS] All checks passed — ready for labs
```

If any check fails, see the Troubleshooting section below.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `hermes: command not found` | Install location not in PATH | Add `~/.local/bin` to PATH and restart terminal |
| `hermes --version` shows old version | Multiple installs conflict | Run `which hermes` to find the active binary; uninstall the old one |
| `hermes run "say: OK"` returns auth error | Provider login not completed | Re-run `hermes login --provider <your-provider>` |
| LLM connectivity fails | Wrong API key or expired token | Re-run `hermes login …` with a fresh key |
| `verify.sh` fails on KIND check | KIND not installed | Follow [setup-kind.md](setup-kind.md) first |
| Google AI Studio: rate limit error | Free tier quota (500 req/day) | Wait until next UTC day or switch provider |
| HF Inference: model not found | Model name changed | Check [huggingface.co/models](https://huggingface.co/models) for current Llama-3.1-8B model ID |
