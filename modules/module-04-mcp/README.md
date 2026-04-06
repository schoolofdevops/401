# Module 04 — Connecting to Everything with MCP

**Duration:** 90 minutes (35 min explainer + 50 min lab + 10 min quiz)
**Day:** 1 — Session 4
**Pillar:** 1 — Augmented DevOps (the universal bridge)
**Delivery:** CORE — included in all delivery formats (3/4/5 day)

---

## Overview

You've now learned what platform AI can do, and more importantly, what it can't. The gap between detection and resolution sits right there, waiting.

But here's the problem platform AI doesn't solve: how does an AI agent actually talk to your infrastructure? How does it run kubectl commands, query your database, check GitHub commit history, or pull Prometheus metrics — all in the same conversation? It can't SSH. It can't open a browser. It needs a bridge.

That bridge is MCP — the Model Context Protocol. Think of it as the USB-C of infrastructure automation. One standard connector that plugs into everything: kubectl, PostgreSQL, GitHub, AWS CLI, Prometheus, Datadog, PagerDuty, and hundreds more.

By the end of this module, your AI agent will be connected to multiple infrastructure tools and capable of cross-platform queries — asking a single question that reaches your Kubernetes cluster, your database, and your CI/CD system, then returns an integrated answer. This is the final module of Pillar 1 (Passenger seat). After this, you shift to Pillar 2 and become the Mechanic — building and fine-tuning your own agents.

## Learning Objectives

After completing this module, you will be able to:

1. Explain MCP architecture and why it solves the N×M integration problem
2. Install and configure 4+ MCP servers (Kubernetes, PostgreSQL, GitHub, optional Prometheus)
3. Execute cross-platform queries using a single AI agent
4. Compare manual copy-paste workflows with MCP-powered workflows
5. Identify security layers in MCP (read-only modes, scoped access, approval gates)
6. Articulate how MCP bridges the Platform AI Gap from Module 03

## Prerequisites

**Required:**

- Completed Module 01 (working KIND cluster with reference app deployed)
- Completed Module 02 (understanding of context engineering and LLM mechanics)
- Completed Module 03 (identified your Platform AI gaps)
- Claude Code or Crush installed and verified
- Node.js 18+ and npm installed

**Expected knowledge:**

- Comfortable with: kubectl basics, psql connection strings, GitHub personal access tokens
- Familiar with: JSON configuration files, port-forwarding
- No MCP experience needed — this module teaches it from scratch

**Optional (enhances but not required):**

- Prometheus basics (optional for Prometheus MCP exercise)

## Module Structure

```
module-04-mcp/
├── README.md              ← you are here
├── explainer/
│   ├── EXPLAINER.md       ← narrator notes for 14 diagrams (10 Excalidraw + 4 Gemini illustrations)
│   └── diagrams/          ← Excalidraw diagram files
│       └── GEMINI-BRIEFS.md  ← prompts for generating Gemini illustrations
├── reading/
│   ├── concepts.md        ← standalone reading: MCP fundamentals, architecture, server types
│   └── reference.md       ← quick-reference: server list, security patterns, .mcp.json syntax
├── lab/
│   ├── LAB.md             ← step-by-step hands-on lab with 4 exercises
│   ├── README.md          ← lab setup overview
│   ├── starter/           ← MCP configuration templates, GitHub token setup
│   │   ├── comparison-template.md
│   │   └── crush-setup-guide.md
│   └── solution/          ← completed .mcp.json + example exercise outputs
│       ├── .mcp.json
│       └── example-exercise-outputs.md
├── quiz/
│   └── QUIZ.md            ← 8 questions with answers
└── exploratory/
    └── PROJECTS.md        ← 3 stretch projects (multi-tool agent design, security audit, custom MCP server)
```

## Delivery Guide

**Live workshop flow:**

1. Explainer diagrams 1-5 (~12 min) — "The Integration Problem and MCP as the Solution"
2. Explainer diagrams 6-8 (~8 min) — "MCP Architecture and Protocol"
3. Break (5 min)
4. Explainer diagrams 9-11 (~9 min) — "MCP Servers and Security Layers"
5. Explainer diagrams 12-14 (~6 min) — "From Passenger to Mechanic"
6. Lab (~50 min) — install 4+ MCP servers, run cross-platform exercises, complete comparison template
7. Quiz (~10 min) — reinforce key concepts

**Udemy self-paced flow:**

1. Video: "The Integration Problem — Before MCP" (diagrams 1-3, ~6 min)
2. Video: "What is MCP? — The USB-C of Infrastructure" (diagrams 4-6, ~8 min)
3. Video: "How MCP Works — Architecture and Protocol" (diagrams 7-9, ~9 min)
4. Video: "Connecting Your Tools — Security and Best Practices" (diagrams 10-12, ~8 min)
5. Video: "Cross-Platform Queries — A Single Agent, Many Tools" (diagrams 13-14, ~4 min)
6. Lab walkthrough video (separate recording)
7. Quiz (Udemy native quiz)

## The "Aha Moment"

You ask a single question: "Check the latest database migration, review the commit history in GitHub, and tell me if there are any deployment risks right now."

Without MCP, you'd need to:
1. Run `kubectl exec` to access the database
2. Manually query PostgreSQL
3. Open GitHub in a browser
4. Read recent commits
5. Copy-paste results between windows
6. Ask an AI to analyze your notes

With MCP, you ask your AI agent once. It routes to PostgreSQL (via MCP server), GitHub (via MCP server), and synthesizes the answer in real time. You're no longer the middleware. The agent is.

This is the fundamental shift from Pillar 1 to Pillar 2: from the Passenger seat (using AI) to the Mechanic shop (building AI).

## Key Terminology

| Term | Definition |
|------|-----------|
| **MCP** | Model Context Protocol — an open standard for AI agents to access external tools, APIs, and data. Like USB-C for infrastructure. |
| **MCP Client** | The AI agent application that uses MCP servers (Claude Code, Crush, or custom agent). Initiates requests. |
| **MCP Server** | A process that exposes tools and resources to MCP clients. Examples: Kubernetes, PostgreSQL, GitHub, Prometheus servers. |
| **MCP Tool** | An operation an MCP server exposes (e.g., "kubectl get pods", "psql query", "git log"). Callable by the AI agent. |
| **MCP Resource** | Structured data an MCP server provides (e.g., pod metadata, database schema, GitHub repository info). |
| **MCP Prompt** | Dynamic instructions or context a server can inject into the LLM. Example: "Here are all available kubectl commands." |
| **stdio transport** | MCP communication method using standard input/output. Simplest; works locally. No network overhead. |
| **SSE transport** | MCP communication via HTTP Server-Sent Events. Used for remote connections, browser-based clients. |
| **Tool Discovery** | The process of an MCP client learning what tools a server provides. Automatic in most cases. |
| **Cross-Platform Query** | A single AI question that routes to multiple MCP servers and integrates results from different tools/systems. |
| **.mcp.json** | Configuration file (Claude Code standard) specifying which MCP servers to connect and how (stdio/SSE, command, arguments). |
| **Defense in Depth** | Security practice of multiple independent layers (read-only mode, scoped access, approval gates, rate limits). |

## What's Next

After completing this module, you'll transition to **Pillar 2: Agentic Engineering** and **Module 05: How AI Processing Works**, where you move from Passenger (using AI) to Mechanic (building AI). You'll go under the hood to understand how your AI agent processes context, makes decisions, and executes actions — the foundation for all context engineering in the rest of the course.

The gaps you identified in Module 03, the tools you connected in Module 04 — they all come together in Pillar 2 to build production-grade domain agents.
