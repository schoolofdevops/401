# AI Processing Reference Card — Quick Guide

## 1. The Three Phases: Tokenize → Prefill → Decode

```
INPUT (with context)
        ↓
┌─────────────────────┐
│  TOKENIZE           │  Text → tokens
│  (instant)          │  "Hello world" → [7, 45, 382, ...]
└─────────────────────┘
        ↓
┌─────────────────────┐
│  PREFILL            │  Read ALL input tokens in parallel
│  (1-5 sec)          │  Model understands context & question
│  TTFT delay here    │
└─────────────────────┘
        ↓
┌─────────────────────┐
│  DECODE             │  Generate tokens one at a time
│  (5-60 sec)         │  Output streams word by word
│  Output streaming   │
└─────────────────────┘
        ↓
OUTPUT (streaming response)
```

**Key insight:** Prefill time scales with INPUT size. Decode time scales with OUTPUT length.

---

## 2. TTFT (Time To First Token) Quick Guide

### What Causes Slow TTFT

| Factor | Impact | How to Diagnose |
|--------|--------|-----------------|
| **Large context** | Prefill reads everything; more tokens = slower | Count tokens in system prompt + conversation history + injected data |
| **Slow model** | Smaller/cheaper models are slower | Check model specs (Haiku < Sonnet < Opus) |
| **High server load** | Model queues your request | Check provider dashboard / API status |
| **Network latency** | Rare; usually < 100ms | Check `curl -w @curl-format.txt` timing |

### Quick Diagnosis Checklist

```bash
# Measure TTFT locally
time curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -d '{"model":"claude-3-5-sonnet-20241022","max_tokens":1,"messages":[{"role":"user","content":"hi"}]}' \
  | jq '.usage'

# If TTFT > 3 seconds:
# 1. Check context size: echo "$YOUR_PROMPT" | wc -c
# 2. Check model choice: echo "using $MODEL"
# 3. Ask: "Am I reusing context from a previous turn?"
```

---

## 3. Context Window Sizes

| Model | Max Tokens | ~Words | ~Pages | Best For |
|-------|-----------|--------|---------|----------|
| **Haiku** | 200K | 40K | ~160 | Fast, cheap, light context (e.g., log review) |
| **Sonnet** | 200K | 40K | ~160 | Balanced (default choice for most labs) |
| **Opus** | 200K | 40K | ~160 | Complex reasoning, deep context (rare in DevOps) |

**Note:** All current Claude models have 200K token context. Usage scales linearly with cost.

---

## 4. Temperature Settings Quick Reference

| Setting | Use Case | Why | Risk |
|---------|----------|-----|------|
| **0.0** | Deterministic outputs (code, configs, exact commands) | Same input → same output; reproducible | Too rigid for creative tasks |
| **0.3-0.5** | Most DevOps work (troubleshooting, runbook generation) | Slightly variable but grounded in training | Low risk |
| **0.7-1.0** | Brainstorming, creative problem-solving | More variety; explores different angles | Less reliable for exact configs |
| **>1.0** | Rare; creative text only (storytelling) | Very unpredictable | Dangerous for infrastructure work |

**Default:** Use 0.5 for DevOps labs. Change only if you need determinism (→0.0) or exploration (→0.7).

---

## 5. Model Tiers at a Glance

| Model | Speed | Quality | Cost | Best For | TTFT |
|-------|-------|---------|------|----------|------|
| **Haiku** | ⚡⚡⚡⚡⚡ | ⭐⭐ | $ | Simple queries, logs, CLI parsing | ~500ms |
| **Sonnet** | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | $$ | Infrastructure automation, agents, labs | ~1.5-2s |
| **Opus** | ⚡ | ⭐⭐⭐⭐⭐ | $$$ | Deep reasoning, complex cases (overkill for DevOps) | ~3-4s |

**Rule of thumb:** Use Sonnet for 95% of DevOps work. Use Haiku only when speed matters more than accuracy. Avoid Opus unless explicitly needed.

---

## 6. Agent Turn Cost Calculator

```
Estimated token cost per turn:

Turn cost = (prefill_tokens + avg_decode_tokens) × num_turns

Example:
  System prompt: 800 tokens
  Injected context (runbook): 2,000 tokens
  Agent query: 500 tokens
  Agent response: 800 tokens (average)
  ───────────────────────────
  Per-turn cost: (800 + 2,000 + 500 + 800) = 4,100 tokens

  5 turns × 4,100 = 20,500 tokens total for the agent session

  Cost @ $0.003/1K input tokens (Sonnet):
  20,500 × $0.003 / 1000 = $0.0615 (about 6 cents)
```

**Key formula for agents:**
```
agent_cost = num_turns × (context_tokens + avg_output_tokens)
```

To reduce cost:
- Compress context (top-3 runbooks, not all 20)
- Use fewer agent turns (batch queries when possible)
- Switch to Haiku for lightweight queries

---

## 7. Key Metrics to Monitor

| Metric | What It Means | Red Flag |
|--------|---------------|----------|
| **TTFT (Time to First Token)** | Delay before streaming starts | >5 seconds = bloated context |
| **Tokens/second** | Generation speed | <10 tok/s = model overloaded or slow network |
| **Context utilization %** | How much of your context window you're using | >80% = risk of truncation; consider compression |
| **Agent turns** | Number of back-and-forths needed | >10 turns = inefficient prompt design |
| **Total input tokens** | Size of everything you sent (prompts + context) | Growing? Compress or cache |
| **Total output tokens** | Size of all responses combined | >5K per turn = agent being too verbose |

---

## 8. Quick Troubleshooting Guide

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| **Agent slow to start** | Large context in Prefill phase | Reduce system prompt or injected runbooks; cache context between turns |
| **Agent responses slow** | Long output or slow model | Use Haiku for simple queries; ask for shorter responses |
| **TTFT > 5 seconds** | Context size too large OR server load | Count tokens; if >100K, split into multiple turns |
| **Agent hallucinates** | Temperature too high OR bad context | Lower temperature to 0.3; verify injected data is correct |
| **Consistent errors** | MCP tool failure OR token limit | Check MCP server logs; verify context < 80% of window |
| **Cost ballooning** | Too many turns OR huge context | Batch queries (fewer turns); compress context between turns |
| **Model refuses task** | Safety filtering OR malformed request | Rephrase; check request format; try different wording |

---

## 9. Key Terminology (Quick Definitions)

| Term | Definition |
|------|-----------|
| **Token** | Atomic unit of text. ~1 token per word, but varies. Special tokens for punctuation, control flow. |
| **Prefill** | Phase where the model reads all input tokens. Time scales with input size. Happens once per turn. |
| **Decode** | Phase where the model generates output, one token at a time. Time scales with output length. |
| **TTFT** | Time To First Token—the delay before streaming output starts. Dominated by Prefill phase. |
| **Context** | Everything you give the model: system prompt, conversation history, injected data, current request. |
| **Context window** | Maximum tokens the model can process (200K for Claude). Includes both input and output. |
| **Temperature** | Randomness slider. 0 = deterministic (same input → same output). 1+ = creative/random. |
| **Hallucination** | When the model invents false information with confidence. Often caused by insufficient context or bad prompts. |
| **Inference** | The process of running the model (Prefill + Decode). Measured in time and tokens consumed. |
| **Agent turn** | One back-and-forth: user question → model response → user follows up → model responds again. Each turn has its own Prefill. |
| **Streaming** | Sending output tokens as they're generated, instead of waiting for the full response. Improves perceived latency. |
| **Context compression** | Reducing the size of context (via summarization, extraction, or filtering) to speed up Prefill. |
| **Model quantization** | Running a smaller model (fewer parameters) for faster inference. Trade: less accuracy. |
| **Rate limiting** | API provider throttling requests to manage load. Shows as slow TTFT or request queueing. |
| **Token budget** | Maximum tokens available for a task (e.g., "I have 10K tokens for this agent session"). |

---

## 10. Useful Links

| Resource | Purpose | URL / Access |
|----------|---------|--------------|
| **Claude.ai tokenizer** | Estimate tokens for your prompt | https://claude.ai (paste text, look at token count in UI) |
| **Anthropic docs** | Model specs, pricing, API details | https://docs.anthropic.com |
| **Token counter CLI** | Count tokens offline | `pip install anthropic`, then `python -c "from anthropic import Anthropic; print(..."` |
| **Haiku vs. Sonnet vs. Opus** | Model comparison and benchmarks | https://docs.anthropic.com/en/docs/about-claude/models/latest |
| **MCP documentation** | Context engineering for agents | https://modelcontextprotocol.io |
| **Superpower guides** | Advanced Claude Code workflows | https://claudecode.com/docs/superpowers |

---

## Quick Copy-Paste: Token Counter Script

```bash
#!/bin/bash
# count-tokens.sh — Estimate token count for a file

FILE=$1
if [ -z "$FILE" ]; then
  echo "Usage: ./count-tokens.sh <file>"
  exit 1
fi

python3 << 'EOF'
import sys
from anthropic import Anthropic

client = Anthropic()

with open("$FILE", "r") as f:
    text = f.read()

# Estimate via tokenizer
import json
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1,
    messages=[{"role": "user", "content": text}]
)

print(f"Input tokens: {response.usage.input_tokens}")
print(f"Output tokens: {response.usage.output_tokens}")
print(f"Total: {response.usage.input_tokens + response.usage.output_tokens}")
EOF
```

---

## Reference Card Checklist

Before a critical agent deployment, verify:

- [ ] Context size < 150K tokens (allows 50K for output buffer)
- [ ] TTFT measured and < 3 seconds
- [ ] Temperature set appropriately (0.3-0.5 for DevOps)
- [ ] Agent turn count estimated (target: 3-5 turns max)
- [ ] MCP servers configured and tested
- [ ] Token budget calculated and approved
- [ ] Hallucination risk assessed (good context? well-scoped prompt?)
- [ ] Cost estimate reviewed (how much will this agent cost per run?)

**Pass score to move to production:** All checkboxes completed and reviewed with team.
