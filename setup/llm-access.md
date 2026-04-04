# AI Coding Tool Setup and Provider Guide

This guide covers setup for both AI coding tools supported by the course and documents the LLM providers available for OpenCode. Both paths are fully supported — all labs include expected outputs for both Claude Code and OpenCode.

---

## Choose Your Path

| Path | Tool | Cost | Best For |
|------|------|------|---------|
| **Path A** | Claude Code | $0 (within Claude Pro/Team subscription) | Participants with an existing Claude subscription |
| **Path B** | OpenCode | $0 (free LLM providers) | Participants without a Claude subscription |

Both paths are equally supported throughout the course. Lab instructions show expected outputs for both tools.

---

## Path A — Claude Code Setup

### What it is

Claude Code is Anthropic's official terminal AI coding agent. It integrates directly with your Claude subscription — no separate API billing, no per-token charges.

### Requirements

An active **Claude Pro** ($20/month) or **Claude Team** subscription at [claude.ai](https://claude.ai). If you have access to claude.ai, you have Claude Code access.

### Install Node.js (prerequisite)

Claude Code requires Node.js v18 or later:

```bash
node --version   # must show v18 or later
```

If not installed or below v18:

```bash
brew install node   # macOS
# or use nvm: https://github.com/nvm-sh/nvm
# nvm install 18 && nvm use 18
```

### Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### Verify

```bash
claude --version
```

Expected output:

```
1.x.x (claude-code)
```

### First run and authentication

```bash
claude
```

This opens a browser window for OAuth authentication. Sign in with your Claude account. After successful authentication, you'll be returned to the terminal where Claude Code is ready to use.

### Default model

Claude Code automatically uses the Claude Sonnet model — no configuration needed. The model is selected based on your subscription type.

### Rate limits

Within a Claude Pro subscription, the daily limit is approximately 10M tokens. This is far more than any individual lab or the full course will use.

### Lab usage pattern

Navigate to your lab directory, then run `claude` to start a session. Example:

```bash
cd modules/module-01-ai-foundations/lab
claude
```

Inside Claude Code, you can ask questions, request code generation, and run multi-step tasks. Claude Code has access to your filesystem and can read and write files directly.

### Known issue — January 2026 Anthropic OAuth block

In January 2026, Anthropic temporarily blocked OAuth-based authentication for Claude Code in some regions. If you encounter an authentication error during the first `claude` run:

1. Update to the latest version: `npm update -g @anthropic-ai/claude-code`
2. Check [status.anthropic.com](https://status.anthropic.com) for current auth service status
3. As a workaround, use an API key directly:
   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   claude
   ```
   Get your API key from [console.anthropic.com](https://console.anthropic.com) → API Keys.

This issue was resolved for most users by February 2026. It is documented here for reference in case it recurs or affects participants in specific regions.

---

## Path B — OpenCode Setup

### What it is

OpenCode ([opencode.ai](https://opencode.ai)) is a terminal-based AI coding agent maintained by the SST team. It supports 75+ LLM providers including several free options — no Claude subscription required.

> **Critical identity note:** This is `sst/opencode` from [opencode.ai](https://opencode.ai). There is an archived project named `opencode-ai/opencode` (archived September 18, 2025) that is no longer maintained — do not install that one. Use only the installer from opencode.ai or the Homebrew tap below.

### Install

**macOS:**

```bash
brew install sst/tap/opencode
```

**Linux:**

```bash
curl -fsSL https://opencode.ai/install.sh | sh
```

### Verify

```bash
opencode --version
```

Expected output:

```
opencode 0.x.x
```

### Connect to a provider

Run OpenCode, then use `/connect` to configure an LLM provider:

```bash
opencode
```

Inside OpenCode:

```
/connect
```

This opens an interactive provider selector. Choose from the free providers documented in the next section.

### Lab usage pattern

Navigate to your lab directory and run `opencode`:

```bash
cd modules/module-01-ai-foundations/lab
opencode
```

Use `/connect` to verify your provider is active if this is your first session. Then interact with OpenCode the same way you would with Claude Code — ask questions, request code generation, work through lab steps.

---

## Free LLM Providers for OpenCode

### Provider 1: Google Gemini 2.5 Flash (recommended)

The best choice for all course labs. Generous free limits, reliable availability, and strong reasoning for infrastructure tasks.

- **Cost:** Free, no credit card required
- **Rate limits:** 10 RPM / 500 requests per day (as of early 2026)
  - Verify current limits at [ai.google.dev/gemini-api/docs/rate-limits](https://ai.google.dev/gemini-api/docs/rate-limits)
  - 500 req/day is far more than any lab uses — typical lab: 5–15 requests
- **Model name:** `gemini-2.5-flash` — do NOT use `gemini-2.0-flash` (deprecated February 2026, retiring June 1, 2026)

**Setup:**

1. Go to [aistudio.google.com](https://aistudio.google.com) and sign in with a Google account
2. Click **Get API Key** → **Create API Key**
3. Copy the key (it starts with `AIza...`)
4. In OpenCode: type `/connect` → select **Google** → paste your API key
5. Select model: `gemini-2.5-flash`

**Verify connection:**

After setup, send a test message in OpenCode. You should receive a response within 2–3 seconds.

---

### Provider 2: Groq (fast inference)

The fastest option for code-heavy labs. Groq uses dedicated LPU hardware for extremely fast token generation.

- **Cost:** Free, no credit card required
- **Rate limits:** 14,400 requests/day for `llama-3.1-8b-instant`, 6,000 TPM
  - Verify current limits at [console.groq.com/docs/rate-limits](https://console.groq.com/docs/rate-limits)
- **Model:** `llama-3.1-8b-instant`
- **Best for:** Fast inference demos, code-heavy labs where speed matters

**Setup:**

1. Sign up at [console.groq.com](https://console.groq.com) — no credit card needed
2. Go to API Keys → **Create API Key**
3. Copy the key (it starts with `gsk_...`)
4. In OpenCode: type `/connect` → select **Groq** → paste your API key
5. Select model: `llama-3.1-8b-instant`

---

### Provider 3: OpenRouter (flexible fallback)

OpenRouter gives access to many models through a single API key. Free credits on signup; models with the `:free` suffix are permanently free (subject to change).

- **Cost:** Free credits on signup; `:free` suffix models cost nothing
- **Setup:** Sign up at [openrouter.ai](https://openrouter.ai) → copy API key → in OpenCode: `/connect` → select **OpenRouter**
- **Best for:** Flexibility and model variety — use as fallback if Gemini or Groq limits are hit
- **Recommended models:**
  - `meta-llama/llama-3.1-8b-instruct:free` — permanently free
  - `anthropic/claude-haiku-4-5` — uses free signup credits

> **Note on `:free` models:** Free model availability on OpenRouter changes without notice. Use Gemini or Groq as your primary free provider and OpenRouter as a fallback.

---

### Provider 4: Grok (optional)

Grok's API is available from xAI's developer console. Free tier status as of April 2026 is uncertain.

- **Cost:** May require payment — verify current pricing at [console.x.ai](https://console.x.ai) before using
- **Setup:** Get API key from [console.x.ai](https://console.x.ai) → in OpenCode: `/connect` → select **xAI** → paste key
- **Recommendation:** Use Gemini 2.5 Flash or Groq as your primary free provider. Set up Grok only if you prefer it and are comfortable with its current pricing model.

---

## Token Budget Awareness

Understanding token consumption helps you stay within free tier limits and keep lab costs predictable.

### What consumes tokens in a session

1. **System context** — the AI tool's system prompt and any CLAUDE.md or configuration context loaded at startup. Typically 1,000–3,000 tokens per session.
2. **Conversation history** — each exchange accumulates. Longer sessions cost more tokens than shorter ones.
3. **Tool output** — when the AI tool reads files or runs commands, the output is fed back into the context. Real AWS CLI output is verbose; mock JSON is compact.
4. **AI reasoning** — the internal thinking chain before each response or tool call.

### How mock mode saves tokens

When using `HERMES_LAB_MODE=mock`, the shell wrapper scripts return pre-baked JSON files instead of making real CLI calls. This significantly reduces token usage:

| Data source | Example size | Notes |
|------------|-------------|-------|
| Real `aws cloudwatch describe-alarms` | 8,000–15,000 chars | Full API response with all fields |
| Mock `describe-alarms-clean.json` | 1,200–2,500 chars | Only the fields the lab needs |
| Real `kubectl get pods -o json` | 20,000+ chars | Complete namespace JSON |
| Mock `get-pods-crashloop.json` | 2,000–3,000 chars | Single pod scenario |

**Each mock lab interaction uses approximately 2,000–5,000 tokens.** Live mode (real CLI) uses 10,000–25,000 tokens for the same operation.

### Tip: Start each lab fresh

Close and reopen your AI tool between labs. This resets conversation history and keeps token usage predictable. With Claude Code, exit with `/exit` and start a new session. With OpenCode, quit and reopen.

---

## Estimated Course Cost

All token estimates assume `HERMES_LAB_MODE=mock` for labs that support it.

| Path | Total tokens (all labs) | Estimated cost |
|------|------------------------|----------------|
| Claude Code (Claude Pro subscription) | ~200K–400K | $0 — within subscription |
| OpenCode + Gemini 2.5 Flash | ~200K–400K | $0 — within free tier limits |
| OpenCode + Groq | ~200K–400K | $0 — within free tier limits |
| OpenCode + OpenRouter (`:free` models) | ~200K–400K | $0 — within free credits |

**Bottom line:** The complete course costs effectively $0 in LLM API fees with any supported provider.

Live mode (real AWS, real K8s) may push token totals 2–3x higher if you choose to run labs against live infrastructure, but the total cost remains under $5 even with paid providers.

---

## Switching Providers Mid-Course

If you run into rate limits or want to try a different provider, switching is straightforward.

**In OpenCode:** Run `/connect` at any time to add or change providers. Your conversation history within the current session will be preserved. For a clean start, quit and reopen OpenCode with the new provider active.

**In Claude Code:** Claude Code always uses your Claude subscription — no provider switching needed. If you hit limits, wait for your daily quota to reset or upgrade to Claude Team.

---

## Frequently Asked Questions

**Can I use both Claude Code and OpenCode in the same course?**

Yes. Some participants use Claude Code for most labs and OpenCode when they want to try a different model. The lab instructions work with either tool. Just make sure you complete each lab consistently — switching tools mid-lab can produce different outputs.

**The lab shows "expected output (Claude Code)" but I'm using OpenCode. Is that okay?**

Yes. Minor phrasing differences in AI-generated output are normal. The lab acceptance criteria check for specific facts (was the alarm identified? was the fix applied?) not for exact wording matches. Both tool paths produce correct results for all course exercises.

**My Gemini API key stopped working.**

Possible causes: API key revoked (check aistudio.google.com), daily quota exhausted (resets at midnight Pacific), or a temporary service outage. Try the Groq provider as a fallback.

**Claude Code says my subscription doesn't have access.**

Claude Code requires Claude Pro or Claude Team. A free claude.ai account does not include Claude Code access. You can upgrade at claude.ai/settings/billing or use OpenCode with a free provider instead.
