# Module 05 — How AI Actually Works: The Engine Under the Hood

**Duration:** 80 minutes (40 min explainer + 30 min lab + 10 min quiz)
**Day:** 2 — Session 1
**Pillar:** Pillar 2 — Agentic Engineering
**Delivery:** RECOMMENDED

---

## Overview

This module opens the hood on AI processing. Participants learn what actually happens when they type a question into Claude or ChatGPT — from tokenization through Prefill and Decode to the streaming response. Every concept maps to a DevOps parallel: Prefill is terraform plan, Decode is terraform apply, the context window is container RAM, and temperature is your creativity/consistency dial. By the end, participants have a mental model of the AI engine that informs every decision they make in Pillar 2 and beyond.

This is a conceptual module — the lab is an interactive observation exercise, not a coding lab. Participants measure TTFT, experiment with temperature, and observe multi-turn agent pipelines firsthand.

## Learning Objectives

By the end of this module, participants will be able to:

1. **Trace** the full AI processing pipeline from input to output (tokenize → prefill → decode)
2. **Explain** the difference between Prefill (parallel, reads all input) and Decode (sequential, generates one token at a time)
3. **Define** TTFT (Time to First Token) and explain why it scales with context size
4. **Compare** the context window to container memory limits and articulate the right-sizing principle
5. **Describe** how temperature affects output reliability vs. creativity and identify DevOps sweet spots
6. **Explain** why agents with tool calls are slower than simple chat (multi-turn prefill/decode cycles)
7. **Choose** the right model tier (Haiku/Sonnet/Opus) based on the task, using the right-sizing principle

## Prerequisites

**Required:**
- Completed Module 01 (lab environment with KIND cluster and AI agent)
- Completed Module 04 (MCP servers connected — used in lab exercises)

**Expected knowledge:**
- Basic familiarity with AI chat interfaces (Claude, ChatGPT) from Modules 01-04
- Understanding of DevOps concepts: containers, resource limits, terraform plan/apply, CI/CD pipelines

**Tools needed:**
- Claude Code (via Claude Pro/Team subscription) OR Crush (free, with Groq or Gemini)
- MCP servers from M04 still connected (kubectl, PostgreSQL)
- Timer/stopwatch (phone timer works fine)

## Module Structure

```
module-05-how-ai-works/
├── README.md              ← This file
├── explainer/
│   ├── EXPLAINER.md       ← Narrator notes for 14 diagrams (40 min)
│   └── diagrams/          ← 10 Excalidraw + 4 Gemini illustrations + GEMINI-BRIEFS.md
├── reading/
│   ├── concepts.md        ← Standalone reading (~15 min)
│   └── reference.md       ← Quick-reference card (print-friendly)
├── lab/
│   ├── LAB.md             ← Interactive exercises (30 min)
│   ├── starter/           ← Observation template
│   │   └── observation-template.md
│   └── solution/          ← Example observations
│       └── example-observations.md
├── quiz/
│   └── QUIZ.md            ← 8 questions with collapsible answers
└── exploratory/
    └── PROJECTS.md        ← 4 stretch projects
```

## Delivery Guide

### Live Workshop Flow (80 minutes)

1. **Opening (2 min):** "Welcome to Pillar 2. You've been using AI — now we're opening the hood."
2. **Explainer Diagrams 1-4 (10 min):** Title card, full pipeline, email analogy, terraform parallel
3. **Check-in (2 min):** "Has anyone noticed the TTFT pause?" (connects to M04 experience)
4. **Explainer Diagrams 5-8 (14 min):** Prefill deep dive, decode deep dive, assembly line, TTFT explained
5. **Explainer Diagrams 9-12 (12 min):** Context as RAM, temperature, agent pipeline, model sizes
6. **Explainer Diagrams 13-14 (5 min):** Implications, bridge to M06
7. **Lab: Interactive Exercises (30 min):** TTFT measurement, tokenization, temperature, agent pipeline
8. **Debrief (5 min):** Share surprising observations, connect to M06 context engineering

### Udemy Self-Paced Flow

1. **Videos 1-2:** "Opening the Hood" + "Prefill & Decode" (10 min)
2. **Videos 3-4:** "Inside Prefill" + "The Assembly Line" (12 min)
3. **Videos 5-6:** "Context as RAM" + "Agent Pipeline" (13 min)
4. **Video 7:** "Implications + Wrap-Up" (5 min)
5. **Reading:** concepts.md for deeper standalone study
6. **Lab:** Interactive exercises (30 min, solo)
7. **Quiz:** 8 questions (10 min)
8. **Optional:** Exploratory projects

## Key Terminology

| Term | Definition | DevOps Parallel |
|------|-----------|-----------------|
| Token | Atomic unit of text processed by the model (~3/4 of a word) | Log entry in a structured log |
| Prefill | Phase where model reads ALL input tokens in parallel | `terraform plan` — reads everything before acting |
| Decode | Phase where model generates output tokens sequentially | `terraform apply` — executes changes one by one |
| TTFT | Time to First Token — pause before first output appears | Cold start latency on a container |
| Context Window | Maximum tokens the model can process (input + output) | Container memory limit |
| Attention | Mechanism allowing tokens to reference all other tokens | DNS service discovery in K8s |
| Temperature | Parameter controlling output randomness (0.0 = deterministic) | Chaos engineering dial |
| Haiku | Smallest, fastest, cheapest Claude model | t3.micro — quick tasks |
| Sonnet | Balanced Claude model — daily driver | t3.large — most workloads |
| Opus | Largest, most capable Claude model | c5.4xlarge — heavy compute |

## What's Next

After completing this module, you'll move to **Module 06: Context Engineering — Beyond Prompts**. Now that you understand how the AI engine processes context, you'll learn THE core skill of the entire course: engineering the right context for the right task. You'll build a CLAUDE.md for your reference app and see the dramatic quality difference between minimal and optimized context. Everything in Pillar 2 and Pillar 3 builds on what you learn in Module 06.

## Connection to Course Journey

**Where this fits:**

```
Pillar 1 (Passenger)                    Pillar 2 (Mechanic)
M01 → M02 → M03 → M04                  M05 → M06 → M07 → M08 → ...
Setup  Found  Platform  MCP             How AI  Context  Super   IaC
       ations AI       Connect          Works   Eng     powers
                                        ▲
                                    YOU ARE HERE
```

Module 05 is the bridge from "using AI" to "understanding AI." Every concept taught here — Prefill scaling, context budgeting, model right-sizing, agent pipeline costs — directly informs the practical skills in Modules 06 through 12.
