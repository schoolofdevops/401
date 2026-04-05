# Module 01 — Welcome + AgenticOps Trinity Framework + Environment Setup

**Duration:** 90 minutes (35 min explainer + 45 min lab + 10 min quiz)
**Day:** 1 — Session 1
**Pillar:** Introduction (spans all three pillars)
**Delivery:** CORE — included in all delivery formats (3/4/5 day)

---

## Overview

This is your launchpad. You'll learn what AgenticOps is, why it matters for DevOps practitioners, and how the course is structured. Then you'll set up the complete lab environment that powers every module for the rest of the course.

By the end of this module, your AI coding agent will be connected to a live Kubernetes cluster, a PostgreSQL database, and your monitoring stack — all running locally on your laptop.

## Learning Objectives

After completing this module, you will be able to:

1. Explain the four eras of operations: Manual, Scripted, Automated, and Agentic
2. Describe the AgenticOps Trinity Framework and its three pillars
3. Articulate why domain expertise matters more — not less — in the age of AI agents
4. Deploy the reference application to a local KIND cluster
5. Connect MCP servers to your AI coding agent (Claude Code or Crush)
6. Verify your complete lab environment is ready for all course labs

## Prerequisites

**Required:**

- macOS or Linux terminal proficiency (Windows users: WSL2 — see setup notes)
- Docker Desktop installed with 4+ CPUs, 6+ GB memory allocated
- One of: Claude Pro/Team subscription (for Claude Code) OR a free Google/Groq account (for Crush)

**Expected knowledge:**

- Comfortable with: Docker, kubectl basics, Helm basics, git, shell commands
- No AI/ML experience needed — that's what this course teaches

## Module Structure

```
module-01-welcome/
├── README.md              ← you are here
├── explainer/
│   ├── EXPLAINER.md       ← narrator notes for 14 concept diagrams
│   └── diagrams/          ← Excalidraw diagram files
├── reading/
│   ├── concepts.md        ← standalone reading: core concepts
│   └── reference.md       ← quick-reference card
├── lab/
│   ├── LAB.md             ← step-by-step setup lab
│   ├── starter/           ← MCP config templates
│   └── solution/          ← completed MCP configs
├── quiz/
│   └── QUIZ.md            ← 7 questions with answers
└── exploratory/
    └── PROJECTS.md        ← optional stretch projects
```

## Delivery Guide

**Live workshop flow:**

1. Explainer diagrams 1-11 (~30 min) — present concepts with whiteboard diagrams
2. Break (5 min)
3. Explainer diagrams 12-14 (~5 min) — lab introduction
4. Lab (~45 min) — hands-on environment setup
5. Quiz (~10 min) — reinforce key concepts

**Udemy self-paced flow:**

1. Video: "Welcome to AgenticOps" (diagrams 1-3, ~7 min)
2. Video: "The AgenticOps Trinity Framework" (diagrams 4-7, ~12 min)
3. Video: "The Driving Analogy" (diagram 8, ~3 min)
4. Video: "Domain Expertise is Your Superpower" (diagrams 9-10, ~6 min)
5. Video: "Human-in-the-Loop" (diagram 11, ~3 min)
6. Video: "Workshop Overview + Lab Setup" (diagrams 12-14, ~5 min)
7. Lab walkthrough video (separate recording)
8. Quiz (Udemy native quiz)

## Key Terminology

| Term | Definition |
|------|-----------|
| **AgenticOps** | The practice of building AI agents that encode operational expertise for infrastructure automation |
| **Context engineering** | The discipline of structuring the right context — domain knowledge, system state, constraints — so AI produces expert-level results. NOT "prompt engineering." |
| **MCP** | Model Context Protocol — an open standard that lets AI agents connect to external tools (kubectl, databases, APIs) |
| **KIND** | Kubernetes IN Docker — a tool for running local K8s clusters as Docker containers |
| **SKILL.md** | A structured knowledge file that encodes operational expertise in a format AI agents can use |

## What's Next

After completing this module, you'll move to **Module 02: AI Foundations for DevOps Teams**, where you'll have your first hands-on conversation with an AI agent using real operational data from your newly deployed lab environment.
