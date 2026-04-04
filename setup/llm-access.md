# LLM Access and Cost Guide

This guide helps you choose the right model for each lab exercise, understand why Haiku is the default, and estimate total token cost across the course. All providers listed here can be used at zero or near-zero cost.

---

## Model Tiers for Labs

| Model | Provider | Cost | Best For |
|-------|----------|------|----------|
| claude-haiku-4-5 | Anthropic (Claude Code OAuth) | ~$0 (within subscription) | ALL lab exercises (default) |
| gemini-2.5-flash | Google AI Studio | Free (500 req/day) | Default alternative if not on Claude subscription |
| meta-llama/Llama-3.1-8B-Instruct | Hugging Face Inference | Free (rate-limited) | Budget fallback — higher latency |
| anthropic/claude-haiku-4-5 | OpenRouter | Free credits on signup | Flexible fallback with model variety |
| claude-sonnet-4-5 | Anthropic (Claude Code OAuth) | ~$0.01–0.05 per lab | Complex reasoning only (Module 10 messy scenario) |

> **Default for all labs: `claude-haiku-4-5`** (or provider-equivalent fast model). Do not upgrade to Sonnet unless a specific lab step instructs it.

---

## Setting Your Default Model

### Via CLI

```bash
hermes config set model claude-haiku-4-5
```

### Via config file

Edit `~/.hermes/config.yaml`:

```yaml
model: claude-haiku-4-5
```

### Override per-run (without changing default)

```bash
hermes run --model claude-sonnet-4-5 "analyze this incident timeline"
```

---

## Rule: Haiku for Learning, Sonnet for Complex Reasoning

### Why Haiku works for all labs

Lab exercises are designed around three principles that make Haiku reliable:

1. **Skills give structured instructions** — SKILL.md files encode exact CLI commands, decision trees, and expected output formats. Haiku does not need to guess what to do.
2. **Mock data is compact, clean JSON** — pre-baked responses contain exactly the fields the skill expects. No noise, no ambiguity.
3. **Lab scenarios are single-issue** — each exercise has one clear problem with an obvious fix. Complex multi-cause reasoning is not required until Module 10.

### When to upgrade to Sonnet

Use `claude-sonnet-4-5` only in these situations:

- **Module 10 messy scenario** — simultaneous DB slowdown + cost spike + pod OOM with ambiguous root cause. Sonnet's stronger reasoning reduces false-positive diagnosis.
- **When you receive unclear or contradictory evidence** — if Haiku is producing unhelpful outputs and you have ruled out a prompt issue, try Sonnet once.

For all other exercises, Haiku produces correct results at a fraction of the cost.

### Cost estimate per lab module

| Module | Exercise type | Token estimate (Haiku) | Approximate cost |
|--------|--------------|----------------------|-----------------|
| Module 7 | Write SKILL.md (authoring) | 3,000–5,000 | ~$0.00 |
| Module 8 | Wire tools to agent | 4,000–7,000 | ~$0.00 |
| Module 10 | Build domain agent, run scenarios | 8,000–15,000 | ~$0.01 |
| Module 11 | Fleet orchestration | 10,000–20,000 | ~$0.01–0.02 |
| Module 12 | Triggers (cron + webhook) | 5,000–8,000 | ~$0.00 |
| Module 13 | Governance + approval workflows | 5,000–10,000 | ~$0.00 |

These estimates assume `HERMES_LAB_MODE=mock`. Live mode may be 2–3x higher due to longer agent reasoning chains interpreting real CLI output.

---

## Token Budget Awareness

### What consumes tokens in a Hermes session

1. **System prompt** — SOUL.md identity file + all loaded skills (SKILL.md contents). Typically 2,000–4,000 tokens per session.
2. **Conversation history** — each back-and-forth exchange accumulates. Longer sessions cost more.
3. **Tool output** — terminal command output fed back to the agent. Mock JSON is compact; real AWS CLI output is verbose.
4. **Agent reasoning** — the internal thinking chain before each tool call.

### How mock mode saves tokens

When `HERMES_LAB_MODE=mock`, shell wrapper scripts return pre-baked JSON files instead of making real CLI calls. The difference:

| Data source | Example size | Notes |
|------------|-------------|-------|
| `aws rds describe-db-instances` (real) | 8,000–15,000 chars | Full API response with every field |
| Mock `describe-db-instances.json` | 1,200–2,000 chars | Only the fields the skill needs |
| `kubectl get pods -o json` (real) | 20,000+ chars (many pods) | Complete JSON for entire namespace |
| Mock `get-pods-crashloop.json` | 2,000–3,000 chars | Single pod in CrashLoopBackOff |

**Each skill invocation in mock mode uses approximately 2,000–5,000 tokens.** In live mode the same skill invocation may use 10,000–25,000 tokens.

### Tip: Start every lab session fresh

Hermes conversation history accumulates within a session. If you restart Hermes between labs, the system prompt reloads cleanly and conversation history does not carry over — keeping token usage predictable.

---

## HERMES_LAB_MODE and Token Cost

`HERMES_LAB_MODE` controls whether Hermes uses mock data or real infrastructure:

| Value | Data source | Token cost | When to use |
|-------|------------|-----------|-------------|
| `mock` | Pre-baked JSON files in `course/infrastructure/mock-data/` | Low (~2K–5K per invocation) | All labs by default |
| `live` | Real AWS CLI, kubectl, psql calls | High (~10K–25K per invocation) | Optional: after completing the lab exercise with mock data |

Set it per-lab in your terminal session before running Hermes:

```bash
export HERMES_LAB_MODE=mock
hermes run "check the database health"
```

**For all labs, start with `HERMES_LAB_MODE=mock`.** This keeps token usage predictable, works without an AWS account, and lets you focus on the agentic patterns rather than infrastructure setup. The live mode is available for validation after you understand the scenario.

Do not set `HERMES_LAB_MODE` in `~/.hermes/config.yaml` — it should be an explicit per-session choice.

---

## Provider-Specific Notes

### Claude Code OAuth

- **Cost:** No per-token billing within a Claude Pro or Claude Team subscription
- **Rate limits:** Claude Pro allows approximately 10M tokens per day (varies by subscription tier)
- **Recommended model:** `claude-haiku-4-5` for labs; `claude-sonnet-4-5` for Module 10 messy scenario
- **Setup:** See [install-hermes.md](install-hermes.md) Option A

### Google AI Studio

- **Cost:** Free — no credit card required
- **Rate limits:** Gemini 2.5 Flash: 10 RPM / 500 requests per day; Flash-Lite: 15 RPM / 1,000 per day
- **Recommended model:** `gemini-2.5-flash` — best free alternative to Haiku for lab work
- **Note:** 500 requests/day is more than sufficient for all lab exercises (typical lab uses 5–15 requests)
- **Setup:** See [install-hermes.md](install-hermes.md) Option B

### Hugging Face Inference

- **Cost:** Free on the shared inference API (rate-limited)
- **Rate limits:** Variable; expect throttling during high-traffic periods
- **Recommended model:** `meta-llama/Llama-3.1-8B-Instruct`
- **Latency:** Expect 2–5 seconds per response on the free tier (serverless inference)
- **Best for:** Participants with no access to any other provider; also good for exploring open-weight model behavior
- **Setup:** See [install-hermes.md](install-hermes.md) Option C

### OpenRouter

- **Cost:** Free credits on signup; sufficient for the full course. Models with `:free` suffix are permanently free but may have variable availability.
- **Recommended model:** `anthropic/claude-haiku-4-5` (uses your free credits) or `meta-llama/llama-3.1-8b-instruct:free`
- **Flexibility:** Single API key gives access to Claude, Gemini, Llama, Mistral, and more
- **Setup:** See [install-hermes.md](install-hermes.md) Option D

---

## Estimated Total Course Cost

| Provider | Total token estimate (all labs) | Estimated cost |
|----------|--------------------------------|----------------|
| Claude Code OAuth (Claude Pro) | ~200K–400K tokens | $0 — within subscription |
| Google AI Studio | ~200K–400K tokens | $0 — within free tier limits |
| Hugging Face Inference | ~200K–400K tokens | $0 — free tier |
| OpenRouter (free credits) | ~200K–400K tokens | $0–$1 — within free signup credits |
| OpenRouter (paid, Haiku) | ~200K–400K tokens | ~$0.20–$0.50 total |

Token estimates are based on `HERMES_LAB_MODE=mock`. Live mode may push totals 2–3x higher.

**Bottom line:** With any of the four providers, the complete course costs effectively $0 in LLM API fees.
