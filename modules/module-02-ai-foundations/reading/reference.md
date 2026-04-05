# Module 02 — Quick Reference: AI Foundations for DevOps

**TL;DR:** Context beats prompts. Your DevOps expertise is the competitive advantage. Use the 4-layer pattern and token budgets to structure what the AI sees.

---

## AI Spectrum at a Glance

| Level | Description | DevOps Analogy | Example |
|-------|-------------|---|---------|
| **Chat** | Conversational response, no memory between turns | Asking a colleague a question once | "What does MTTD mean?" |
| **Copilot** | Code suggestions inline in your editor | Pair programming — suggests next line | Claude Code autocomplete in your IDE |
| **Agent** | Tool-using automation with memory | On-call runbook executor with escalation | Read CloudWatch → SSH → run diagnostic → decide → escalate |
| **Squad** | Multi-agent workflow coordination | Team of specialists coordinating a complex incident | Incident commander + SRE + DBA + network engineer |

---

## Agent Anatomy Cheat Sheet

**What you build vs. what comes pre-built:**

| Component | What It Is | What You Build | Pre-Built? |
|-----------|-----------|---|---|
| **Brain** | The LLM (Claude, Gemini, Llama, etc.) | Your choice of model; temperature tuning | No — you select |
| **Skills** | Operational knowledge (runbooks, decision trees, config templates) | SKILL.md files that encode YOUR expertise | No — you write these |
| **Tools** | External APIs and CLIs the agent can call (AWS SDK, kubectl, Terraform) | MCP server definitions that connect to your infrastructure | Partial — you wire them |
| **Guardrails** | Safety, approval gates, cost limits, rate limits | Rules: "Don't delete without approval", "Max 5 API calls per run" | No — you define these |

---

## The 4-Layer Context Pattern

**Before sending ANY prompt, build these four layers (in order):**

### Layer 1: Task Definition
What are you asking for? Be specific.
```
"Analyze this CloudWatch alarm and recommend the next debugging step."
```

### Layer 2: Role Context
Set up the AI's mental frame using domain expertise language.
```
"You are an SRE with 5 years of incident response experience. Think about:
 - MTTR (mean time to recovery)
 - Common failure modes
 - Escalation criteria"
```

### Layer 3: System Context
Current state of YOUR infrastructure — topology, baselines, dependencies.
```
"Catalog API (i-0abc7ef):
 - Normally: CPU 60-65%, P95 latency <100ms, error rate <0.1%
 - Dependencies: RDS (us-east-1c), Cache (Redis), Message queue (SQS)
 - Recent deployments: v2.3.1 deployed 30min ago"
```

### Layer 4: Procedural Context
Runbooks, decision trees, how things should be done.
```
"Runbook: Elevated CPU
 1. Check traffic patterns (CloudWatch Metrics)
 2. Check process CPU (SSM Session Manager)
 3. Check recent deployments (CodeDeploy)
 4. If CPU > 80% and errors rise: page DBA
 5. If CPU normal but alarms misconfigured: update thresholds"
```

---

## Context Engineering Checklist

**Before sending a prompt:**

- [ ] **Task**: Is the goal clearly stated? (Not "analyze this" but "what's the root cause?")
- [ ] **Role**: Have you set the expertise context? (SRE, DevOps lead, on-call engineer)
- [ ] **System State**: Is current infrastructure state included? (Topology, resource baselines, recent changes)
- [ ] **Procedures**: Are runbooks or decision trees attached? (How decisions are made)
- [ ] **Output Format**: Specified what you want back? (JSON, markdown list, runbook steps)
- [ ] **Token Budget**: Reasonable for your model? (Most labs fit in 5K-20K tokens)

---

## Token Size Estimates

**Rough token counts for common DevOps artifacts:**

| Content Type | Approx Tokens | Notes |
|--------------|---------------|-------|
| Simple question ("What is MTTD?") | 10–30 | Just the question itself |
| Single CloudWatch alarm JSON | 150–250 | 1 alarm with metadata |
| EC2 instance metadata (1 server) | 100–200 | Instance ID, tags, security groups, AMI |
| Kubernetes service manifest | 200–400 | One K8s YAML file (Service + Deployment + ConfigMap) |
| IaC Layer 2 context (system state) | 300–600 | Brief topology + resource names + baselines |
| IaC Layer 4 context (full runbook) | 800–1,500 | 5–10 decision steps + examples |
| Terraform module (typical) | 400–800 | 100–200 lines of HCL |
| SRE runbook (1 page) | 500–900 | Multi-step incident procedure |
| CloudWatch alarm history (7 days) | 2,000–5,000 | ~100 data points |
| Service topology (10 services) | 1,500–3,000 | All services + dependencies |
| Incident history (30 days, 20 incidents) | 15,000–30,000 | Full timeline + root causes |
| **Full context for complex troubleshooting** | 5,000–20,000 | Layers 1–4 + system state |

**Total budget rule of thumb:** Input + output ≤ 30% of your model's context window.

---

## Context Window Sizes (April 2026)

| Model | Window | Approx Word Equiv | Use Case |
|-------|--------|---|---|
| **Claude Sonnet 4.6** | 200K tokens | ~150K words | Production agent work; best reasoning |
| **Gemini 2.5 Flash** | 1M tokens | ~750K words | Free tier (500 req/day); high throughput |
| **GPT-4o** | 128K tokens | ~96K words | OpenAI ecosystem; competitive reasoning |
| **Llama 3.1 8B** | 128K tokens | ~96K words | Groq free (14.4K req/day); fast inference |

**Word-to-token ratio:** 1 word ≈ 1.3 tokens (rough estimate).

---

## Token Economics Quick Math

**Claude pricing (as of April 2026):**
- Input: $3/1M tokens
- Output: $15/1M tokens

**Quick formula for daily cost:**
```
Daily input cost = (alarms/day × tokens/alarm × $3) / 1M
Daily output cost = (alarms/day × output_tokens × $15) / 1M
Total daily cost = input + output
```

**Example:** 500 alarms/day, 1,000 tokens input, 500 tokens output:
```
Input:  (500 × 1,000 × $3) / 1M = $1.50/day
Output: (500 × 500 × $15) / 1M = $3.75/day
Total: $5.25/day (~$150/month)
```

**Free tier alternatives:**
- **Gemini 2.5 Flash**: 500 requests/day (no cost)
- **Groq Llama 3.1 8B**: 14,400 requests/day (no cost)
- **Both**: Suitable for course labs and small-scale automation

---

## Model Selection Guide

| Use Case | Recommended | Why |
|----------|-------------|-----|
| **Daily agent automation** | Claude Sonnet 4.6 | Best reasoning; handles complex incident analysis |
| **Free tier high volume** | Gemini 2.5 Flash | 500 req/day free; good for demonstrations |
| **Fast inference demos** | Groq Llama 3.1 8B | 14.4K req/day free; lightning fast for brainstorming |
| **Course labs (flexible)** | Any | Design labs to work with any model; no preference |
| **IaC generation** | Claude Sonnet 4.6 | Strongest Terraform/Ansible output |
| **Runbook execution** | Any (use temp=0) | All models perform well with deterministic settings |

---

## Temperature Settings: Quick Reference

**Temperature = creativity dial. Lower = more consistent, Higher = more varied.**

| Setting | Behavior | Use Case | DevOps Example |
|---------|----------|----------|---|
| **0.0** | Always picks most likely token | Incident triage, runbook execution, IaC generation | "Execute this runbook step exactly as written" |
| **0.3** | Mostly consistent, slight variation | Structured analysis with minor variation | "Analyze alarm patterns; note anomalies" |
| **0.7** | Balanced consistency & creativity | Documentation, explanations, brainstorming | "Draft runbook for new failure mode" |
| **1.0** | High randomness | Creative brainstorming, test scenarios | "Generate 3 chaos engineering test cases" |
| **Agent skills** | **ALWAYS 0** | Deterministic, repeatable automation | All SKILL.md execution should use temp=0 |

---

## Terminology Shift: What This Course Uses

**As you build agentic systems, re-frame your language:**

| ❌ Old Term | ✅ Course Term | Why It Matters |
|-----------|----------------|---|
| "Write a prompt" | "Design your context" | Shifts focus from clever wording to structural information architecture |
| "Good prompting skills" | "Context architecture skills" | It's not about writing talent — it's about system knowledge |
| "Prompt template" | "Context template" | Emphasizes that you're templating information, not phrasing |
| "System prompt" | "Role & identity context" | Clearer: you're setting the AI's operational frame |
| "Few-shot examples" | "Procedural context examples" | Makes explicit: you're encoding HOW to do things |
| "Prompt injection" | "Context injection attack" | Broader: any untrusted data influencing the AI's behavior |
| "Prompt engineering" | "Context engineering" | THE core concept of this course |

---

## Domain Expertise → Results Pipeline

```
Your 5 years of DevOps experience
         ↓
    Specialized vocabulary
    (MTTD, incident severity, escalation criteria, runbook patterns)
         ↓
    Rich context architecture
    (Layers 1–4: task + role + system + procedures)
         ↓
    Expert-level AI output
    (Root cause analysis that matches your thinking)
```

**The insight:** Your domain expertise IS the AI's superpower. Generic ChatGPT without your context ≠ your custom agent with your context.

---

## Quick Lookup: Common Questions

**Q: Why does the same alarm produce different outputs when I add context?**
A: The AI's reasoning doesn't change — the *information available* changes. More context = better pattern matching.

**Q: How much context is "too much"?**
A: Aim for 5K–20K tokens for typical troubleshooting. Stay well under 30% of your model's context window.

**Q: Should I include my entire runbook library?**
A: No. Include only the runbook(s) relevant to THIS task. Use Layer 4 strategically.

**Q: What temperature should my agent skills use?**
A: Always 0. Consistency is non-negotiable for automation.

**Q: Can I use a free-tier model for production agents?**
A: Yes, if volume is low (< 500 req/day). Gemini 2.5 Flash and Groq work well for this.

**Q: Why is the 4-layer pattern so important?**
A: It's systematic. Without it, you add context randomly (or not at all), and output quality suffers. It's the repeatability that matters.

---

## Key Takeaway

**Context engineering is the skill that separates generic ChatGPT responses from expert-level incident analysis.**

You have 5 years of operational knowledge. The AI's job is to encode and apply it. The 4-layer pattern, token budgets, and procedural context are the tools. Master these, and you've mastered agentic DevOps.

---

**Next step:** Move to the lab and prove this to yourself with real CloudWatch alarm data.
