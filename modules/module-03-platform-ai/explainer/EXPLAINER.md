# Module 03 — Explainer Notes

> **Delivery format:** 12 diagrams (8 Excalidraw + 4 Gemini illustrations), presented sequentially.
> Each diagram = one concept beat. Use for live whiteboard delivery or Udemy video segments.
>
> **Naming convention:** `01-title-card.excalidraw` through `12-bridge-to-custom.excalidraw`
> **Style:** Black & white, hand-drawn (Excalidraw sketchy), outlines only — no fills, no colors.
> **Gemini illustrations:** 4 visual metaphor illustrations generated via Gemini image generator, same B&W style.
> See `diagrams/GEMINI-BRIEFS.md` for generation prompts.
>
> **Tool split:**
> | Diagram | Tool | Why |
> |---------|------|-----|
> | 1, 2, 5, 6, 8, 9, 10, 12 | Excalidraw | Schematic flows, matrices, comparisons |
> | 3, 4, 7, 11 | Gemini illustration | Visual metaphors, scenes, whimsical sketches |

---

## Diagram 1: Title Card — Platform AI: Features Already in Your Stack

**File:** `diagrams/01-title-card.excalidraw`
**Tool:** Excalidraw
**Duration:** ~1 minute

**Narrator notes:**

Welcome to Module 03 — Platform AI: Features Already in Your Stack.

In Module 02, you learned how LLMs work, what context windows are, and you proved to yourself that domain expertise drives AI output quality. You now have a mental model of AI. Great.

Before we start building custom agents — and we will — there's something we need to check first. Your cloud platform, your observability stack, your code editors — they already have AI features built in. Features you're already paying for. Features most teams haven't even turned on yet.

This module is about discovery. We're going to explore what's already there, understand what it does well, and — critically — map where it falls short. Because that gap between "what platform AI does" and "what you actually need at 3am" is EXACTLY where custom agents live. That gap is what we build in Pillars 2 and 3.

Think of it this way: before you build a custom monitoring stack, you check what CloudWatch already gives you for free. Same principle.

---

## Diagram 2: Platform AI Landscape — What's Already There

**File:** `diagrams/02-platform-ai-landscape.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Title: "Platform AI — Features Already in Your Stack"
- Three columns: Cloud (AWS), Observability, Code Assistance
- AWS column: CloudWatch Anomaly Detection, Cost Explorer AI, DevOps Guru, Q Developer
- Observability column: Datadog Watchdog, Grafana Sift, New Relic AI, Splunk AI Assistant
- Code column: GitHub Copilot, Amazon Q, Cursor, Claude Code (IDE mode)
- Bottom annotation: "You're already paying for most of these. Are you using them?"

**Narrator notes:**

Let's map the landscape. AI isn't something you need to add to your stack — it's already embedded in it. Let me walk you through three categories.

First, **cloud provider AI**. AWS has been quietly adding AI features across its services. CloudWatch now has anomaly detection that learns your metric baselines automatically. Cost Explorer has AI-assisted cost analysis with forecasting. DevOps Guru does cross-service anomaly correlation — it can spot that your Lambda errors correlate with DynamoDB throttling. And Q Developer is AWS's code assistant, free with a Builder ID.

Second, **observability platform AI**. Datadog has Watchdog — it automatically surfaces anomalies across your entire stack. Grafana has Sift — it investigates metric spikes by analyzing related signals. New Relic and Splunk both have AI assistants that can query your telemetry in natural language.

Third, **code assistance AI**. GitHub Copilot, Amazon Q, Cursor, Claude Code — these suggest code, explain configurations, generate IaC, review security.

Here's the thing — most DevOps teams are using maybe 10% of what's available. The first step isn't building custom agents. It's discovering what you're already paying for.

---

## Diagram 3: The Mechanic Checking the Toolkit

**File:** `diagrams/03-mechanic-checking-toolkit.png`
**Tool:** Gemini illustration
**Duration:** ~2 minutes

**Visual layout:**
- A mechanic (our Pillar 1 "Passenger becoming Mechanic") opening a toolbox labeled "Your Stack"
- Inside the toolbox: various AI tools labeled "CloudWatch Anomaly", "Cost Explorer AI", "Q Developer", "Grafana Sift"
- Some tools are dusty/cobwebbed (unused), others are shiny (already in use)
- The mechanic has a checklist: "Step 1: Know what you have"
- Caption: "Before you build new tools, check the ones in your toolbox."

**Narrator notes:**

Remember the driving analogy from Module 01? In Pillar 1, you're the Passenger becoming a Mechanic. You're learning to open the hood and understand what's there.

This illustration captures exactly where we are. You're the mechanic opening the toolbox. Inside, there are AI tools you didn't even know you had. Some are dusty — CloudWatch Anomaly Detection that nobody enabled. Some are shiny — maybe your team's already using Copilot.

Before you build anything custom, you need to know what you already have. That's what this module is about — an inventory check. You can't identify the gaps if you don't know what's already filling them.

Step 1 is always: know what you have. Then you can figure out what's missing.

---

## Diagram 4: CloudWatch Anomaly Detection — What It Actually Does

**File:** `diagrams/04-cloudwatch-anomaly-in-action.png`
**Tool:** Gemini illustration
**Duration:** ~3 minutes

**Visual layout:**
- A metric graph showing a smooth "normal" band (gray shaded area) and a spike that breaks above it
- The spike has a speech bubble: "Something is wrong!"
- Below the graph, a conveyor belt showing what happens next: Alert fires → SNS notification → ??? (a big question mark) → Engineer manually SSHs in
- The "???" is the gap — investigation, correlation, remediation are all missing
- Caption: "It detects. It alerts. Then it stops."

**Narrator notes:**

Let me show you exactly what CloudWatch Anomaly Detection does — and where it stops.

CloudWatch learns your metric's "normal" pattern over two weeks. It builds a band — the gray area in this illustration. When your metric breaks out of that band — a CPU spike, a latency surge, an unusual error rate — it fires an alarm.

And that's where it stops. It detected the anomaly. It sent the SNS notification. But look at the question mark on this conveyor belt. What happens between "alert fires" and "problem solved"?

That gap includes: checking if there was a recent deployment, querying related metrics to see if this is an isolated issue or systemic, looking at your runbook for this alarm type, deciding whether to scale, rollback, or escalate, and then actually executing that decision.

Platform AI handles the detection. Everything from the question mark onwards — that's still you at 3am. Or it's a custom agent. This pattern repeats across every platform AI feature we'll look at today. Detection is solved. Investigation and action are the gap.

---

## Diagram 5: The Capabilities Matrix — Detect vs Investigate vs Act

**File:** `diagrams/05-capabilities-matrix.excalidraw`
**Tool:** Excalidraw
**Duration:** ~4 minutes

**Visual layout:**
- Table with 6 rows and 5 columns
- Columns: "Service", "Detects?", "Investigates?", "Acts?", "Knows Your Context?"
- Rows: CloudWatch Anomaly, Cost Explorer, Q Developer, DevOps Guru, Grafana Sift, Custom Agent
- First 5 rows: checkmarks only in Detect (and partial in Investigate for some)
- Custom Agent row: checkmarks across all four columns
- Bottom insight: "Detection is solved. Investigation and action are the gap."

**Narrator notes:**

This matrix is the single most important takeaway from this module. Let me walk you through it.

I've listed six AI capabilities across four columns: can it detect a problem, can it investigate the cause, can it take action, and does it know YOUR specific context?

CloudWatch Anomaly Detection — detects? Absolutely. Investigates? No. Acts? No. Knows your context? No. It fires an alarm. Full stop.

Cost Explorer — detects cost spikes? Yes. Investigates why? Partially — it can break down by service, but it can't tell you that your staging environment is running 24/7 because of a config drift from three months ago. Acts? No. Context? No.

Q Developer — it doesn't detect problems in the traditional sense — it's code-focused. But it can investigate code issues and generate suggestions. Still no action, still no context about YOUR architecture.

DevOps Guru — detects cross-service anomalies. Partially investigates by correlating metrics. But no remediation and no knowledge of your runbooks.

Now look at the Custom Agent row — the one we'll build in Modules 7 through 14. Detects? Yes. Investigates? Yes — it follows your runbook. Acts? Yes — with the right tools and guardrails. Knows your context? Yes — because YOU encode it in SKILL.md files.

The pattern is clear: platform AI is excellent at detection. Custom agents fill everything to the right.

---

## Diagram 6: Platform AI by Category — What Each One Does

**File:** `diagrams/06-platform-ai-by-category.excalidraw`
**Tool:** Excalidraw
**Duration:** ~5 minutes

**Visual layout:**
- Four quadrants arranged in a 2x2 grid
- Top-left: "Anomaly Detection" — CloudWatch Anomaly, Datadog Watchdog, Grafana Sift
  - Does: learns baselines, alerts on deviations
  - Doesn't: investigate why, follow runbooks
- Top-right: "Cost Intelligence" — AWS Cost Explorer, Azure Cost Management
  - Does: trends, forecasts, rightsizing suggestions
  - Doesn't: correlate with deployments, know your SLAs
- Bottom-left: "Cross-Service Correlation" — DevOps Guru, Datadog RCA
  - Does: finds relationships between service anomalies
  - Doesn't: execute remediation, access non-cloud data
- Bottom-right: "Code Assistance" — Q Developer, GitHub Copilot, Cursor
  - Does: explain code, suggest fixes, generate IaC
  - Doesn't: know your architecture, test against your environment

**Narrator notes:**

Let me organize platform AI into four categories so you know what each type does.

**Anomaly Detection** — CloudWatch Anomaly, Datadog Watchdog, Grafana Sift. These learn what "normal" looks like for your metrics and alert when something deviates. They're great at saying "something is unusual." They can't tell you "here's why, and here's what to do about it."

**Cost Intelligence** — AWS Cost Explorer, Azure Cost Management. They show you trends, generate forecasts, and suggest rightsizing. They can say "your EC2 spend jumped 40% this month." They can't say "that's because the QA team launched 15 test instances on Thursday and forgot to terminate them."

**Cross-Service Correlation** — DevOps Guru, Datadog's root cause analysis. These are the most sophisticated platform AI features. They find relationships — "your Lambda errors correlate with DynamoDB throttling." That's genuinely useful. But they still can't execute a fix, and they're limited to the data within that single platform.

**Code Assistance** — Q Developer, Copilot, Cursor. These understand code syntax and common patterns. They can review your Terraform and spot a missing encryption setting. But they don't know your naming conventions, your approved AMI list, or your team's deployment constraints.

Each category has a ceiling. Understanding that ceiling is how you decide what to build custom.

---

## Diagram 7: The Ceiling Illustration — Where Platform AI Stops

**File:** `diagrams/07-platform-ai-ceiling.png`
**Tool:** Gemini illustration
**Duration:** ~3 minutes

**Visual layout:**
- A vertical building cross-section showing floors
- Ground floor labeled "Detection" — well-lit, furnished, occupied (platform AI lives here)
- Second floor labeled "Investigation" — partially lit, some furniture (platform AI has limited presence)
- Third floor labeled "Action & Remediation" — dark, empty, "UNDER CONSTRUCTION" sign
- Fourth floor labeled "Your Context (Runbooks, Topology, SLAs)" — completely dark, padlocked door
- An elevator on the side labeled "Custom Agent" goes all the way to the top
- Caption: "Platform AI lives on the ground floor. Custom agents take the elevator to the penthouse."

**Narrator notes:**

I love this illustration because it captures the Platform AI Gap perfectly.

Think of operational capability as a building. Platform AI lives on the ground floor — Detection. It's well-lit, well-furnished. CloudWatch Anomaly Detection, Cost Explorer, DevOps Guru — they're all comfortable here. Detection is a solved problem.

The second floor is Investigation. Some platform AI reaches here — DevOps Guru can correlate metrics, Cost Explorer can break down spending. But it's only partially furnished. The investigation is limited to what the platform can see.

The third floor — Action and Remediation — is under construction. No platform AI feature will run `kubectl scale deployment` for you or execute a runbook step. This floor is empty.

And the top floor — Your Context. Your runbooks, your topology, your SLAs, your team's decision criteria. Platform AI can't even get through the door. That knowledge lives in your heads, your wikis, your Post-it notes.

The custom agent — that's the elevator. It goes all the way from detection to investigation to action, carrying your context with it the entire way. That's what we build starting in Pillar 2.

---

## Diagram 8: AWS Platform AI — Free Tier Deep Dive

**File:** `diagrams/08-aws-free-tier-map.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Two columns: "Free (do it in lab)" and "Paid (trainer demo)"
- Free column:
  - CloudWatch Basic Metrics (always free)
  - Cost Explorer Web UI (free console)
  - Q Developer via Builder ID (50 agentic req/month)
  - CloudWatch Alarms (10 free)
- Paid column:
  - CloudWatch Anomaly Detection ($0.30/alarm/month beyond 10)
  - DevOps Guru (3-month trial, then $$)
  - Datadog Watchdog (enterprise plan)
  - Grafana Sift (Cloud Pro+)
- Bottom: "You get hands-on with everything in the Free column. Trainer demos the Paid column."

**Narrator notes:**

Before we go into the lab, let me clarify what you'll do hands-on versus what I'll demonstrate.

On the left — the free column. CloudWatch basic metrics are always free — you can list metrics, view alarms, explore dashboards at zero cost. Cost Explorer's web console is free — unlimited browsing and analysis. Q Developer is free via an AWS Builder ID — no AWS account needed, no credit card, 50 agentic requests per month. And you get 10 CloudWatch alarms for free.

On the right — the paid column. CloudWatch Anomaly Detection costs $0.30 per alarm per month beyond the free 10. DevOps Guru has a 3-month trial but can be expensive after. Datadog Watchdog and Grafana Sift require enterprise plans.

For the paid tools, I'll demonstrate them live so you can see what they do. For the free tools, you'll get hands-on. If you don't have an AWS account, every exercise has a mock data fallback — you'll use the same JSON fixtures from the reference app.

The goal isn't to become an AWS AI expert. The goal is to understand what platform AI can and can't do — so you know where to draw the line between "enable a feature" and "build a custom agent."

---

## Diagram 9: The Observability Stack AI Features

**File:** `diagrams/09-observability-ai-landscape.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Horizontal timeline showing: Metric Collected → Anomaly Detected → Alert Fired → ??? → Incident Resolved
- Three tool logos mapped to the timeline:
  - Datadog Watchdog spans "Anomaly Detected" to "Alert Fired"
  - Grafana Sift spans "Alert Fired" to partial "Investigation"
  - CloudWatch Anomaly spans "Anomaly Detected" only
- The "???" section is labeled "The Gap"
- Below: "Where custom agents play: from alert to resolution"

**Narrator notes:**

Let me show you where each observability AI feature sits on the incident timeline.

It starts with a metric being collected — CPU, latency, error rate. Then an anomaly is detected — something deviates from normal. An alert fires. Then there's a gap — investigation, diagnosis, decision, action. And finally, the incident is resolved.

CloudWatch Anomaly Detection covers just the "anomaly detected" step. It learns baselines and spots deviations. That's it.

Datadog Watchdog is a step ahead — it detects anomalies AND can correlate them across services. So it covers "anomaly detected" through "alert fired" and adds some investigation context.

Grafana Sift is interesting — it's specifically designed for the investigation phase. When an alert fires, Sift automatically analyzes related metrics, recent changes, and correlated events. It gets partway into investigation.

But notice that gap. None of these tools get from "alert fired" to "incident resolved." None of them can follow your runbook. None of them can query your deployment pipeline. None can decide "this looks like the same issue we had last Tuesday — let's try the same fix."

That entire middle section — from alert to resolution — is where your custom agents operate. And they operate there effectively because they carry your domain context.

---

## Diagram 10: Q Developer — What It Can and Can't Do

**File:** `diagrams/10-q-developer-scope.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Central box: "Amazon Q Developer"
- Left side (green checkmarks): "Explain Terraform", "Spot Security Issues", "Generate Boilerplate", "Review IAM Policies", "Suggest Best Practices"
- Right side (red X marks): "Know Your Architecture", "Query Live Infrastructure", "Check Your Naming Conventions", "Test Against Your Environment", "Know Your SLAs"
- Bottom bridge: "What fills the right side? → Context Engineering (M06) + SKILL.md (M12)"

**Narrator notes:**

Let me zoom into Q Developer because it's the platform AI feature you'll interact with most directly in this lab.

On the left — what Q Developer does well. It can explain a Terraform configuration clearly. It spots common security misconfigurations — overly permissive IAM, missing encryption. It generates boilerplate from natural language descriptions. It reviews IAM policies for common issues. These are genuinely useful capabilities, and they're free with a Builder ID.

On the right — what it can't do. It doesn't know your architecture. If you ask "what alerts should I set up for this infrastructure?" it gives generic CloudWatch recommendations. It can't query your live infrastructure state — it only sees the code in front of it. It doesn't know your naming conventions, your approved AMI list, or your tagging strategy. It can't test against your actual environment.

Here's the bridge to the rest of the course: everything on the right side is what you fill in with context engineering and SKILL.md files. When you combine Q Developer's code understanding with YOUR context — your architecture, your conventions, your constraints — that's when AI code review goes from "generic suggestions" to "expert-level infrastructure review."

Module 06 teaches you context engineering. Module 12 teaches you to encode that context in reusable SKILL.md files. Platform AI is the starting point, not the destination.

---

## Diagram 11: Before/After — Manual Investigation vs Platform AI vs Custom Agent

**File:** `diagrams/11-three-way-comparison.png`
**Tool:** Gemini illustration
**Duration:** ~3 minutes

**Visual layout:**
- Three columns showing the same scenario: "CPU spike on production API server"
- Column 1: "Manual" — a stressed engineer with 5 terminal windows open, Slack messages, Grafana dashboards, Jira ticket. Time: 45 minutes. Caption: "Context is in your head."
- Column 2: "Platform AI" — CloudWatch anomaly alert fires, Cost Explorer shows no unusual spend, Q Developer says "check resource limits." Time: 15 minutes (still mostly manual). Caption: "Detection automated. Investigation still on you."
- Column 3: "Custom Agent" — Agent reads alarm, checks deployments, queries related metrics, follows runbook, proposes fix, creates Jira ticket. Time: 3 minutes. Caption: "Context is in SKILL.md. Investigation is automated."
- Bottom: "Same incident. Three responses. The difference? Context."

**Narrator notes:**

This three-way comparison is the big picture of why we're here.

Same incident — CPU spike on your production API server. Three different response approaches.

Manual: You get paged. You open five terminal windows — one for metrics, one for logs, one for deployments, one for Slack, one for the runbook. You cross-reference everything in your head. It takes 45 minutes and a lot of coffee. All the context — why this matters, what to check, what to do — it lives in YOUR head.

Platform AI: CloudWatch Anomaly Detection fires the alert automatically — you didn't have to set a threshold. Cost Explorer confirms no unusual spending pattern. Q Developer, if you ask, suggests "check resource limits." Total: you saved maybe 10 minutes on detection, but investigation is still on you. 15 minutes, still mostly manual.

Custom Agent: The agent reads the alarm, checks the deployment pipeline for recent changes, queries related metrics — database connections, request latency, error rates — follows your runbook steps, and proposes a fix. It creates a Jira ticket with the diagnosis, the evidence, and the recommended action. 3 minutes, mostly automated. The context isn't in your head — it's in SKILL.md. The investigation isn't manual — the agent follows your team's decision tree.

Same incident. The difference between 45 minutes and 3 minutes is context — encoded and automated. Platform AI gets you part of the way. Custom agents get you the rest.

---

## Diagram 12: The Bridge — From Platform AI to Custom Agents

**File:** `diagrams/12-bridge-to-custom.excalidraw`
**Tool:** Excalidraw
**Duration:** ~3 minutes

**Visual layout:**
- Left island: "Platform AI (Pillar 1)" — labeled features: Detection, Alerting, Basic Analysis
- Right island: "Custom Agents (Pillar 3)" — labeled features: Investigation, Action, Your Context
- Bridge connecting them: "Pillar 2 — Agentic Engineering"
- Bridge pillars labeled: "Context Engineering (M06)", "Harnesses (M07)", "IaC (M08)", "Skills (M12)", "Tools (M11)"
- Below: "What you learn in Pillar 2 is what makes Pillar 3 possible. Platform AI is your starting point."

**Narrator notes:**

Let me connect this module to the bigger course journey.

You're standing on the left island — Platform AI. Pillar 1, Augmented DevOps. You know what your tools already offer, and you know where they stop. Detection, alerting, basic analysis. This is valuable — don't dismiss it.

On the right island — Custom Agents. Pillar 3, Agentic DevOps. Agents that investigate, act, and carry your operational context. That's where we're headed.

The bridge between them is Pillar 2 — Agentic Engineering. And it has five pillars of its own. Context Engineering teaches you how to structure information for AI. Harnesses teach you structured workflows. IaC modules teach you to apply AI to real infrastructure work. Skills and Tools teach you to encode your expertise and wire capabilities.

Every skill you learn in Pillar 2 makes the agents in Pillar 3 more powerful. And the gap analysis you just did in this module — the list of things platform AI CAN'T do — that becomes your requirements list for what to build.

Your homework from this module isn't a lab exercise. It's a list. "Here's what platform AI does in my environment. Here's what's missing. And here's what I'm going to build." That list drives the rest of the course.

---

## Delivery Summary

### Diagram Sequence and Timing

| # | Title | Tool | Duration | Concept Beat |
|---|-------|------|----------|-------------|
| 1 | Title Card | Excalidraw | 1 min | Module framing — what we're discovering |
| 2 | Platform AI Landscape | Excalidraw | 4 min | Three categories of embedded AI |
| 3 | Mechanic Checking Toolkit | Gemini | 2 min | Driving analogy — know what you have |
| 4 | CloudWatch Anomaly in Action | Gemini | 3 min | Detection → gap → manual |
| 5 | Capabilities Matrix | Excalidraw | 4 min | Detect vs Investigate vs Act vs Context |
| 6 | Platform AI by Category | Excalidraw | 5 min | Four categories with ceiling for each |
| 7 | The Ceiling Illustration | Gemini | 3 min | Building metaphor — platform AI lives on ground floor |
| 8 | AWS Free Tier Map | Excalidraw | 3 min | What's hands-on vs trainer demo |
| 9 | Observability AI Landscape | Excalidraw | 3 min | Where tools sit on incident timeline |
| 10 | Q Developer Scope | Excalidraw | 3 min | Can vs can't — bridge to context engineering |
| 11 | Three-Way Comparison | Gemini | 3 min | Manual vs Platform AI vs Custom Agent |
| 12 | Bridge to Custom Agents | Excalidraw | 3 min | Connecting Pillar 1 to Pillar 2/3 |
| | **Total** | | **~37 min** | |

### Live Workshop Flow

1. Diagrams 1-3 (~7 min) — "What's Already in Your Stack"
2. Diagrams 4-5 (~7 min) — "Detection vs Investigation — The Gap"
3. Diagrams 6-7 (~8 min) — "Platform AI by Category and Its Ceiling"
4. Break (5 min)
5. Diagrams 8-10 (~9 min) — "AWS Free Tier, Observability Tools, Q Developer"
6. Diagrams 11-12 (~6 min) — "The Three-Way Comparison and The Bridge Forward"
7. Lab (~45 min) — Hands-on exploration of platform AI features
8. Quiz (~10 min)

### Udemy Self-Paced Flow

1. Video: "Platform AI — What's Already in Your Stack" (diagrams 1-3, ~7 min)
2. Video: "The Platform AI Gap — Detection vs Investigation" (diagrams 4-7, ~15 min)
3. Video: "AWS AI Features and Observability Tools" (diagrams 8-10, ~9 min)
4. Video: "Manual vs Platform AI vs Custom Agents" (diagrams 11-12, ~6 min)
5. Lab walkthrough video (separate recording)
6. Quiz (Udemy native quiz)
