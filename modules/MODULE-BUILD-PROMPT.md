# Reusable Module Build Prompt

> **How to use:** Copy the prompt below into a new Cowork session. Replace `[FILL IN]` sections.
> **Prerequisite:** The new session must have access to the `course` folder (mount it if needed).
> **Skills required:** `/module-builder`, `/excalidraw-bw` (and optionally `/voiceover-video`)
> **MCP required:** Excalidraw MCP for diagram generation
> **Reference modules:** Read `modules/module-01-welcome/` and `modules/module-02-ai-foundations/` as quality benchmarks.

---

## THE PROMPT

```
I'm building Module [NN] — [Module Title] for the Agentic DevOps course.

## Course Context

This is a 5-day workshop (also a self-paced Udemy course) for DevOps practitioners who are STRONG in infrastructure (Docker, K8s, Terraform, Ansible, CI/CD, AWS, observability) but have ZERO AI/ML experience. The course teaches them to build AI agents that encode their operational expertise.

The course repo is at: /sessions/[session-id]/mnt/course/
Read CLAUDE.md and WORKSHOP-5DAY.md in the course repo for full context before starting.

## Story So Far

The course tells a cohesive story across modules. Here's where we are:

**Module 01 — Welcome + AgenticOps Trinity Framework + Setup** (COMPLETE)
- Introduced the AgenticOps Trinity Framework: Augmented DevOps (P1) → Agentic Engineering (P2) → Agentic DevOps (P3)
- Driving Analogy: Passenger → Mechanic → Driver
- Set up the complete lab environment: KIND cluster + reference app + MCP servers + AI coding agent
- Key message: "Your domain expertise matters MORE in the age of AI, not less"
- Ended with: environment verified, ready for first AI interaction

**Module 02 — AI Foundations for DevOps Teams** (COMPLETE)
- Opened the hood on how LLMs work — through DevOps analogies (log parsing for tokenization, container memory for context windows, terraform plan/apply for prefill/decode)
- Introduced the AI Spectrum: Chat → Copilot → Agent → Squad (mapped to Manual → Scripted → Orchestrated → Self-Healing ops)
- Agent Anatomy: Brain (LLM) + Skills (SKILL.md) + Tools (MCP) + Guardrails (approvals)
- Context Window as War Room Whiteboard — the model can ONLY see what's on the whiteboard
- Domain Expertise Chain: Expertise → Vocabulary → Context → Results (THE core insight)
- The 4-Layer Context Pattern: Raw Data → Role Context → Infrastructure Context → Procedural Context
- Lab: Progressive context engineering with CloudWatch alarm (proved context beats prompts)
- Key message: "Context engineering — not prompt engineering — is THE core skill"
- Ended with: participants have evidence that their expertise drives AI quality

[ADD SUBSEQUENT COMPLETED MODULES HERE AS THE COURSE BUILDS]

## Module [NN] — What It Should Cover

**Pillar:** [1 — Augmented DevOps / 2 — Agentic Engineering / 3 — Agentic DevOps]
**Day:** [N] — Session [N]
**Delivery:** [CORE / EXTENDED / OPTIONAL]
**Primary Tool:** [Claude Code / Crush / Hermes / AWS Console / Conceptual]
**Status:** [NEW / ADAPT (from existing content) / REUSE]

**Key concepts to teach:**
[List the 4-6 main ideas this module covers]

**Story bridge from previous module:**
[How does this module pick up where the last one left off? What question does the learner have at the end of the previous module that this module answers?]

**Story bridge to next module:**
[What question should the learner have at the END of this module that the next module answers?]

**Diagrams needed (from WORKSHOP-5DAY.md):**
[List the specific diagrams mentioned in the workshop plan]

**Lab focus:**
[What hands-on exercise do participants do? What's the deliverable?]

## Skills to Use

You have access to these skills. Invoke them in the order shown:

### Required Skills (invoke these FIRST before any writing):

1. **`/module-builder`** — The master skill for building course modules. It defines the complete directory structure, content standards, voice/tone, narrator notes format, lab patterns, quiz format, and the delivery checklist. Invoke this FIRST and follow its instructions exactly.

2. **`/excalidraw-bw`** — Black & white hand-drawn diagram generator. Use this for all Excalidraw diagrams. It defines the style rules (black strokes #1e1e1e, no fills, rounded corners, fontSize minimums, 4:3 camera ratios). Invoke this before generating any diagrams.

### Optional Skills (invoke if the module needs them):

3. **`/voiceover-video`** — If the module needs video lesson packages with transcripts alongside diagrams. Generates lesson plans, title cards, and plain-text narration scripts.

4. **`/pptx`** — If any content needs to be exported as a PowerPoint presentation.

5. **`/docx`** — If any content needs to be exported as a Word document.

6. **`/pdf`** — If any content needs to be exported as a PDF.

### MCP Tools Available:

- **Excalidraw MCP** (`create_view`) — Renders hand-drawn diagrams inline. Call `read_me` first to get the element format reference, then `create_view` with JSON element arrays.
- **File tools** (Read, Write, Edit) — For creating and editing module files.
- **Bash** — For directory creation, file operations, verification.
- **Agent** — For parallelizing large content creation tasks (e.g., writing concepts.md and LAB.md simultaneously).

## Build Instructions

### Step 0: Load Skills
```
/module-builder    ← invoke first, read the full skill instructions
/excalidraw-bw     ← invoke second, read the style rules
```
Then call the Excalidraw MCP `read_me` to get the element format reference.

### Step 1: Read Reference Materials
- Read CLAUDE.md in the course repo for conventions, tool split, and constraints
- Read WORKSHOP-5DAY.md for this module's detailed description
- Read the previous module's README.md and EXPLAINER.md to understand the story handoff
- If status is ADAPT/REUSE, read the existing content in course-site/docs/

### Step 2: Plan the Module (present for approval before building)
- Plan 12-16 diagrams with a tool split:
  - **Excalidraw** for: flows, architectures, spectrums, comparisons, process diagrams, layer cakes
  - **Gemini illustrations** for: visual metaphors, scenes, whimsical analogies, physical-world parallels
- Plan the lab structure (progressive, hands-on, solo-completable)
- Plan the story arc: how diagrams flow as a narrative (title → problem → concept → deep dives → lab bridge)

### Step 3: Build All Content

Create this complete directory structure:
```
module-[NN]-[name]/
├── README.md              # Overview, objectives, prerequisites, delivery guide
├── explainer/
│   ├── EXPLAINER.md       # Narrator notes for ALL diagrams (conversational voice)
│   └── diagrams/
│       └── GEMINI-BRIEFS.md  # Gemini image generation prompts for illustration diagrams
├── reading/
│   ├── concepts.md        # ~15 min standalone reading (prose, not bullets)
│   └── reference.md       # Quick-reference cheat sheet (tables, scannable)
├── lab/
│   ├── LAB.md             # Step-by-step hands-on instructions
│   ├── starter/           # Templates, sample data, config files
│   └── solution/          # Completed solutions, expected outputs
├── quiz/
│   └── QUIZ.md            # 7 questions (A/B/C/D with <details> answers)
└── exploratory/
    └── PROJECTS.md        # 5 optional stretch projects
```

### Step 4: Generate Excalidraw Diagrams
Use the Excalidraw MCP tool (`create_view`) to generate each Excalidraw diagram.
**Important:** You must call `read_me` on the Excalidraw MCP once before your first `create_view` call.
Follow the `/excalidraw-bw` skill rules:
- Black & white only (strokeColor #1e1e1e primary, #757575 secondary)
- No background fills, outlines only
- fontSize: 28-32 for titles, 18-22 for labels, 14-16 for annotations (never below 14)
- 4:3 camera ratios only (800×600 standard, 1200×900 for complex)
- Use progressive cameraUpdates to guide attention as elements stream in
- Labeled shapes (label property) preferred over separate text elements

### Step 5: Write Gemini Illustration Briefs
For visual metaphor diagrams (scenes, physical analogies, whimsical concepts), write detailed Gemini image generation prompts in `diagrams/GEMINI-BRIEFS.md`.

**When to use Gemini vs Excalidraw:**
| Use Excalidraw for | Use Gemini for |
|---|---|
| Flows and pipelines | Visual metaphors (war room, balance scale) |
| Architecture diagrams | Physical-world analogies (container overflowing) |
| Comparison tables/columns | Scenes with people/stick figures doing things |
| Spectrums and hierarchies | Whimsical illustrations (cute Docker whale) |
| Layer cakes and stacks | Anything requiring spatial depth/perspective |

**Gemini brief format:**
```
## Brief N: Diagram N — Title
**Filename:** `NN-slug.png`
**Gemini prompt:**
> [Detailed visual description, 100-200 words, specifying:
> - Layout (left/center/right sections)
> - All labels and captions that should appear
> - Style: "black and white, hand-drawn sketch, minimalistic, pen-on-whiteboard"
> - Specific annotations and bottom takeaway text]
```

**Style mandate (include in every Gemini prompt):**
"Style: clean black and white hand-drawn sketch, pen on white paper, no colors, no gradients, no fills. Minimalistic whiteboard aesthetic matching Excalidraw sketchy style."

## Content Standards (Non-Negotiable)

### Voice
- Conversational, "you" and "we" — like a trainer talking to peers
- Every AI concept gets a DevOps analogy (IaC, pipelines, runbooks, containers, SLOs)
- Follow abstract concept with concrete example from DevOps
- NEVER say "prompt engineering" — always "context engineering"
- Use the Domain Expertise Chain: Expertise → Vocabulary → Context → Results

### EXPLAINER.md Format
Each diagram gets:
```
## Diagram N: [Title]
**File:** `diagrams/NN-slug.excalidraw` or `.png`
**Tool:** Excalidraw | Gemini illustration
**Duration:** ~N minutes
**Visual layout:** [what the diagram shows]
**Narrator notes:** [150-300 words, conversational, includes analogy and transition to next]
```

End EXPLAINER.md with:
- Delivery Summary table (# | Title | Tool | Duration | Concept Beat)
- Live Workshop Flow (numbered sequence with timing)
- Udemy Self-Paced Flow (video segment groupings)

### README.md Format
```
# Module NN — [Full Title]
**Duration:** NN minutes (NN min explainer + NN min lab + NN min quiz)
**Day:** N — Session N
**Pillar:** [pillar]
**Delivery:** CORE / EXTENDED / OPTIONAL
```
Sections: Overview → Learning Objectives → Prerequisites → Module Structure → Delivery Guide → The "Aha Moment" → Key Terminology → What's Next

### LAB.md Format
```
# Module NN: [Title] — Hands-On Lab
**Duration:** NN minutes
**Difficulty:** [level]
**Prerequisites:** [dependencies]
**Deliverable:** [specific output]
```
- Every command copy-pasteable
- Include both Claude Code AND Crush paths where AI tool matters
- Solo-completable (Udemy learners are alone)
- No paid APIs — free tiers only
- Show expected output after important commands

### QUIZ.md Format
7 questions, A/B/C/D multiple choice with `<details><summary>Answer</summary>` blocks.
Mix: factual recall, concept application, scenario-based.

### PROJECTS.md Format
5 stretch projects with: Goal, Instructions (numbered), Deliverable.

### Constraints
- No paid APIs (Claude subscription, Google AI Studio free, Groq free, OpenRouter free)
- Free infrastructure (KIND for K8s, Docker, mock data for AWS services)
- Dual format: works for both live 3-5 day workshop AND self-paced Udemy
- Model name: "Claude Sonnet 4.6" (not Claude 3.5 Sonnet or other variants)
- Lab ports must match reference app configs

## Quality Checklist (verify before delivering)
- [ ] All 6 directories exist with required files
- [ ] EXPLAINER.md has narrator notes for every diagram with timing
- [ ] EXPLAINER.md has tool split table (Excalidraw vs Gemini)
- [ ] GEMINI-BRIEFS.md has ready-to-use prompts for all Gemini illustrations
- [ ] All Excalidraw diagrams generated via create_view tool
- [ ] LAB.md is copy-pasteable and solo-completable
- [ ] concepts.md is standalone readable (~15 min) without needing the lab
- [ ] reference.md is print-friendly cheat sheet
- [ ] QUIZ.md has 7 questions with collapsible answers
- [ ] PROJECTS.md has 5 stretch projects
- [ ] README.md has delivery guide for BOTH live and Udemy
- [ ] Story continuity: module picks up where previous left off
- [ ] Story bridge: module ends with a question the next module answers
- [ ] No references to "prompt engineering" except in contrast
- [ ] No paid API dependencies
- [ ] Model names are current (Claude Sonnet 4.6, Gemini 2.5 Flash)
```

---

## Example: Building Module 03

To build Module 03, you would fill in:

```
Module [03] — Platform AI — Features Already in Your Stack

Pillar: 1 — Augmented DevOps
Day: 1 — Session 3
Delivery: CORE
Primary Tool: AWS Console + CLI (with mock data fallback)
Status: REUSE (from course-site/docs/module-02-platform-ai/)

Key concepts:
1. Platform AI = AI features already built into tools you pay for
2. AWS services: CloudWatch Anomaly Detection, Cost Explorer, Q Developer, DevOps Guru
3. Observability AI: Datadog Watchdog, Grafana Sift
4. Capabilities matrix: Detects | Investigates | Executes | Knows Your Context
5. The Gap: Platform AI excels at detection, weak at investigation and action
6. Vendor lock-in vs portable SKILL.md knowledge

Story bridge from M02:
"You now know how LLMs work and that context engineering drives results. But before you build custom agents, let's see what's ALREADY available. What can platform AI do without any custom engineering? And more importantly — where does it fall short?"

Story bridge to M04:
"Platform AI can detect anomalies but can't investigate, can't follow your runbook, can't correlate across services. To close that gap, you need to CONNECT your AI agent to multiple tools. That's MCP — and that's Module 04."

Diagrams needed:
1. Platform AI Landscape (what's available in AWS, observability, coding)
2. Capabilities Matrix (Detects/Investigates/Executes/Knows Context)
3. The Gap (platform AI ceiling vs custom agent potential)

Lab focus:
- Explore CloudWatch metrics (real or mock data)
- Try Cost Explorer analysis
- Test Q Developer on IaC review
- Fill out Platform AI Assessment matrix
- Deliverable: Completed assessment identifying gaps
```
