# Module 03 — Platform AI: Features Already in Your Stack

**Duration:** 100 minutes (37 min explainer + 45 min lab + 10 min quiz + 8 min buffer)
**Day:** 1 — Session 3
**Pillar:** 1 — Augmented DevOps ("Use what's already there")
**Delivery:** CORE — included in all delivery formats (3/4/5 day)

---

## Overview

Before building custom agents, discover what your cloud platform, observability stack, and code editors already offer. AWS CloudWatch Anomaly Detection, Cost Explorer AI, DevOps Guru, Q Developer, Datadog Watchdog, Grafana Sift — these are AI features you're already paying for. Most teams use less than 10% of what's available.

This module is a discovery exercise. You'll explore what's there, understand its capability ceiling, and document precisely where it falls short. That gap — between "what platform AI detects" and "what you need at 3am" — becomes your build list for the rest of the course.

## Learning Objectives

After completing this module, you will be able to:

1. Identify AI features already embedded in your cloud, observability, and code tooling
2. Categorize platform AI into four types: anomaly detection, cost intelligence, cross-service correlation, and code assistance
3. Apply the Capabilities Matrix to evaluate any platform AI feature (Detect → Investigate → Act → Your Context)
4. Explain the Platform AI Gap — why detection is solved but investigation and action are not
5. Document capability gaps in your own environment using the Platform AI Assessment
6. Articulate why custom agents exist — to fill the space between detection and resolution

## Prerequisites

**Required:**

- Completed Module 01 (working lab environment with KIND cluster + AI coding agent)
- Completed Module 02 (understand context engineering and the 4-layer pattern)

**Expected knowledge:**

- Comfortable with: CloudWatch alarms, monitoring dashboards, cost analysis
- Familiar with: incident response workflows, observability tools (any vendor)
- No AI/ML experience needed — Module 02 covered those foundations

**Optional (enhances but not required):**

- AWS account with free tier
- AWS Builder ID (free, no credit card) for Q Developer exercise

## Module Structure

```
module-03-platform-ai/
├── README.md              ← you are here
├── explainer/
│   ├── EXPLAINER.md       ← narrator notes for 12 diagrams (8 Excalidraw + 4 Gemini illustrations)
│   └── diagrams/          ← Excalidraw diagram files + Gemini illustration briefs
│       └── GEMINI-BRIEFS.md  ← prompts for generating Gemini illustrations
├── reading/
│   ├── concepts.md        ← standalone reading: platform AI landscape, ceiling, and gaps
│   └── reference.md       ← quick-reference: service matrix, CLI commands, pricing, links
├── lab/
│   ├── LAB.md             ← step-by-step exploration: CloudWatch, Cost Explorer, Q Developer, Grafana
│   ├── starter/           ← assessment template + mock JSON data for offline labs
│   │   ├── platform-ai-assessment.md
│   │   ├── mock-alarms.json
│   │   ├── mock-cost-normal.json
│   │   └── mock-cost-spike.json
│   └── solution/          ← completed assessment example
│       └── assessment-expected.md
├── quiz/
│   └── QUIZ.md            ← 8 questions with collapsible answers
└── exploratory/
    └── PROJECTS.md        ← 4 stretch projects (multi-cloud audit, agent spec design)
```

## Delivery Guide

**Live workshop flow:**

1. Diagrams 1-3 (~7 min) — "What's Already in Your Stack"
2. Diagrams 4-5 (~7 min) — "Detection vs Investigation — The Gap"
3. Diagrams 6-7 (~8 min) — "Platform AI by Category and Its Ceiling"
4. Break (5 min)
5. Diagrams 8-10 (~9 min) — "AWS Free Tier, Observability Tools, Q Developer"
6. Diagrams 11-12 (~6 min) — "The Three-Way Comparison and The Bridge Forward"
7. Lab (~45 min) — Hands-on exploration of platform AI features
8. Quiz (~10 min) — Reinforce key concepts

**Udemy self-paced flow:**

1. Video: "Platform AI — What's Already in Your Stack" (diagrams 1-3, ~7 min)
2. Video: "The Platform AI Gap — Detection vs Investigation" (diagrams 4-7, ~15 min)
3. Video: "AWS AI Features and Observability Tools" (diagrams 8-10, ~9 min)
4. Video: "Manual vs Platform AI vs Custom Agents" (diagrams 11-12, ~6 min)
5. Lab walkthrough video (separate recording)
6. Quiz (Udemy native quiz)

## The "Aha Moment"

Platform AI features are excellent at telling you THAT something happened. They cannot tell you WHY, what to DO about it, or apply YOUR team's specific decision criteria. The Capabilities Matrix makes this viscerally clear — the first column (Detect) is full of checkmarks. The last three columns (Investigate, Act, Your Context) are almost entirely empty.

The gap isn't a technology problem. It's a context problem. And context engineering — which you learned in Module 02 — is what fills it.

## Key Terminology

| Term | Definition |
|------|-----------|
| **Platform AI** | AI features built into existing tools (cloud providers, observability platforms, code editors) — available without building anything custom. |
| **Capabilities Matrix** | Framework for evaluating platform AI: can it Detect, Investigate, Act, and use Your Context? Most stop at Detect. |
| **Platform AI Gap** | The space between what platform AI detects and what you need for full incident resolution — investigation, action, and your operational context. |
| **Anomaly detection** | AI that learns "normal" metric patterns and alerts on deviations — CloudWatch Anomaly, Datadog Watchdog. |
| **Cross-service correlation** | AI that finds relationships between issues across multiple services — DevOps Guru, Datadog RCA. |
| **Capability ceiling** | The limit of what a platform AI feature can do — typically stops at detection, rarely reaches investigation or action. |
| **Build list** | Your personal list of gaps that platform AI can't fill — becomes the requirements for custom agents in Modules 7-14. |

## What's Next

After completing this module, you'll move to **Module 04: Connecting to Everything with MCP**, where you'll learn how MCP (Model Context Protocol) gives AI agents access to your tools — kubectl, AWS CLI, databases, GitHub. The gaps you identified here become the capabilities you wire up with MCP servers.
