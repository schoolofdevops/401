# Starter Prompt for Course Content Development

**Copy everything below the line into a new Claude Code session in `/Users/gshah/work/agentic/devops/course/`**

---

I'm building a 3-day "Agentic DevOps" workshop course. Read CLAUDE.md and HANDOFF.md in this repo first — they contain the full context.

**My approach:** Build labs/projects FIRST, then use Claude Cowork to generate explainers and concepts from the hands-on content.

**What I need you to build in this session:**

## Priority 1: Module 1 — AI Foundations Lab (Day 1 morning)

This is the MOST critical module — everything builds on this foundation. Participants are DevOps practitioners with ZERO AI knowledge.

Build the Module 1 lab that teaches:

### Lab Part 1: Understanding LLMs Through Operational Data
- Give participants a real CloudWatch alarm JSON (create a realistic sample)
- Have them interact with an LLM (via Claude Code or OpenCode) using progressive prompt structures:
  1. Raw alarm dump → observe messy output
  2. Add system prompt with SRE role context → observe improvement
  3. Add structured output requirements → observe formatted response
  4. Add few-shot examples → observe consistency
- **Key teaching moment:** Show how CONTEXT (domain knowledge, structured input) matters more than clever prompting

### Lab Part 2: Context Engineering Fundamentals
- Teach context engineering as THE core skill (not prompt engineering)
- Exercise: Take the same CloudWatch alarm and build progressively better context:
  1. Just the alarm JSON (minimal context)
  2. Add infrastructure topology context (what connects to what)
  3. Add historical incident context (what happened before)
  4. Add runbook context (what to check and in what order)
- Show how each layer of context dramatically improves LLM reasoning
- **Key teaching moment:** Your domain expertise IS the context. A DBA's vocabulary gives the LLM better frame than generic prompts.

### Lab Part 3: Token Economics
- Show participants how to estimate token costs
- Compare: same task with different context sizes → cost vs quality tradeoff
- Practical: how to stay within free tier limits

### Reading Material Needed:
Use the Layer 1 and Layer 2 concept tables from HANDOFF.md as your checklist. Create `reading/concepts.md` covering:
- Tokenization, context windows, inference pipeline (prefill/decode)
- Temperature, Top-P, Top-K with operational analogies
- Context engineering philosophy (context > prompts)
- Token economics and cost management

## Priority 2: Module 5-6 — Structured AI Coding + IaC Labs (Day 2 morning)

### Module 5 Lab: Structured AI Coding
- Build an Ansible playbook for EC2 hardening using a structured workflow:
  1. Brainstorm approaches (with Claude Code)
  2. Design structure
  3. Blueprint specs
  4. Implement code
  5. Validate output
- Show why unstructured "just write me an ansible playbook" fails for production

### Module 6 Lab: AI-Assisted IaC (pick one track)
- Track A: Terraform RDS PostgreSQL module with CloudWatch alarms + SNS notifications
- Track B: Ansible PostgreSQL client setup with monitoring agents + backup scripts
- Track C: Kubernetes deployment with HPA, resource limits, PodDisruptionBudget
- Each track should produce production-quality, validated IaC

## Priority 3: Module 2 — Platform AI Lab (Day 1 afternoon)

- Lab exploring AWS AI features on free tier
- CloudWatch anomaly detection setup
- Cost Explorer analysis
- Written assessment template: "Platform AI capabilities and gaps for your environment"

## Priority 4: Module 4 — Impact Assessment Exercise (Day 1 end)

- Automation Quadrant template (frequency × complexity)
- Scoring sheet for top 10 operational tasks
- Selection criteria for Day 3 capstone project

## Structure

Follow the module structure in CLAUDE.md for every module. Create realistic, tested lab exercises that a DevOps practitioner can follow step-by-step.

**Remember:** These participants know infrastructure deeply but are AI beginners. Use operational analogies everywhere. Context engineering (not prompt engineering) is the primary skill being taught.

Start with Module 1 — it's the foundation everything else builds on.
