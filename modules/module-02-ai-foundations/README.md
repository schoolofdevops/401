# Module 02 — AI Foundations for DevOps Teams

**Duration:** 95 minutes (40 min explainer + 40 min lab + 15 min quiz)
**Day:** 1 — Session 2
**Pillar:** 1 — Augmented DevOps (foundational knowledge)
**Delivery:** CORE — included in all delivery formats (3/4/5 day)

---

## Overview

You've built applications, written Terraform, and debugged production at 3am. Now you're going to understand the machine that's about to become your newest team member.

This module teaches you how LLMs actually work — not from a data science perspective, but through the operational lens you already think in. You'll learn why "context engineering" (not prompt engineering) is THE core skill, and you'll prove it to yourself with a hands-on exercise using real CloudWatch alarm data from your lab environment.

By the end of this module, you'll have hard evidence that your DevOps expertise — the vocabulary, the mental models, the runbook knowledge — is what turns a generic AI response into an expert-level incident analysis.

## Learning Objectives

After completing this module, you will be able to:

1. Explain how LLMs work using operational analogies (tokenization, context windows, inference pipeline)
2. Place AI capabilities on the spectrum from Chat → Copilot → Agent → Squad
3. Describe agent anatomy: Brain (LLM) + Skills (runbooks) + Tools (MCP) + Guardrails (approvals)
4. Demonstrate progressive context engineering on a CloudWatch alarm (4 layers)
5. Articulate why domain expertise — not clever prompts — drives AI output quality
6. Estimate token costs and evaluate quality vs. cost tradeoffs

## Prerequisites

**Required:**

- Completed Module 01 (working lab environment with KIND cluster + AI coding agent)
- AI coding agent connected and verified (Claude Code or Crush)

**Expected knowledge:**

- Comfortable with: CloudWatch alarms (or willingness to learn from provided data)
- Familiar with: incident response workflows, runbooks, escalation procedures
- No AI/ML experience needed — this module teaches it from scratch

## Module Structure

```
module-02-ai-foundations/
├── README.md              ← you are here
├── explainer/
│   ├── EXPLAINER.md       ← narrator notes for 14 diagrams (10 Excalidraw + 4 Gemini illustrations)
│   └── diagrams/          ← Excalidraw diagram files
├── reading/
│   ├── concepts.md        ← standalone reading: how LLMs work (operations perspective)
│   └── reference.md       ← quick-reference card: AI spectrum, context layers, token economics
├── lab/
│   ├── LAB.md             ← step-by-step progressive context engineering lab
│   ├── starter/           ← context layer templates + alarm data
│   └── solution/          ← completed context templates + expected outputs
├── quiz/
│   └── QUIZ.md            ← 7 questions with answers
└── exploratory/
    └── PROJECTS.md        ← optional stretch projects
```

## Delivery Guide

**Live workshop flow:**

1. Diagrams 1-5 (~13 min) — "How AI Works Under the Hood"
2. Diagrams 6-8 (~11 min) — "The AI Landscape and Agent Architecture"
3. Break (5 min)
4. Diagrams 9-10 (~5 min) — "Parameters and Economics"
5. Diagrams 11-14 (~11 min) — "Domain Expertise and the Lab Preview"
6. Lab (~40 min) — progressive context engineering with CloudWatch alarms
7. Quiz (~15 min) — reinforce key concepts

**Udemy self-paced flow:**

1. Video: "How LLMs Work — An Operations Perspective" (diagrams 1-5, ~13 min)
2. Video: "The AI Spectrum and Agent Anatomy" (diagrams 6-8, ~11 min)
3. Video: "Temperature, Cost, and the Business Case" (diagrams 9-10, 14, ~7 min)
4. Video: "Domain Expertise — Your Superpower" (diagrams 11-13, ~9 min)
5. Lab walkthrough video (separate recording)
6. Quiz (Udemy native quiz)

## The "Aha Moment"

Same CloudWatch alarm sent four times with increasing context layers produces dramatically different outputs. By Layer 4, the AI output matches what an experienced SRE would say at 3am. The AI's intelligence didn't change between layers — your context did.

This is the fundamental insight of the entire course: **context engineering is the core skill.**

## Key Terminology

| Term | Definition |
|------|-----------|
| **Token** | The smallest unit an LLM processes — roughly 3-4 characters. Like log parsing: raw text gets broken into structured chunks. |
| **Context window** | The total text an LLM can see at once — like a war room whiteboard with fixed space. Everything outside it is invisible. |
| **Inference** | The process of an LLM generating a response — two phases: prefill (parallel, cheap) and decode (sequential, expensive). |
| **Temperature** | Controls output randomness — 0 for deterministic (incident triage), 1.0 for creative (brainstorming). |
| **Context engineering** | Structuring the right information for an AI — domain knowledge, system state, constraints. THE core skill. |
| **AI Spectrum** | Four levels of AI capability: Chat → Copilot → Agent → Squad. Each level requires more context engineering. |
| **Agent anatomy** | Four components: Brain (LLM) + Skills (runbooks) + Tools (MCP/CLI) + Guardrails (approvals/limits) |

## What's Next

After completing this module, you'll move to **Module 03: Platform AI — Features Already in Your Stack**, where you'll explore the AI capabilities built into AWS, observability tools, and coding assistants you may already have access to — and identify the gaps that custom agents fill.
