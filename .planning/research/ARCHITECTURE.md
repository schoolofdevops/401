# Architecture Research

**Domain:** Multi-module technical training course repository (dual-format: live workshop + Udemy self-paced)
**Researched:** 2026-04-04
**Confidence:** HIGH (derived from direct project documentation analysis + verified against established course repo patterns)

## Standard Architecture

### System Overview

```
┌───────────────────────────────────────────────────────────────────────────┐
│                        CROSS-MODULE FOUNDATION LAYER                       │
│        (shared-assets/, setup/, simulated-infra/, course-nav/)             │
├──────────────────────┬───────────────────────────────────────────────────  ┤
│  Shared Mock Data    │  Environment Setup   │  Navigation/Index            │
│  (CloudWatch JSON,   │  (install scripts,   │  (README, day schedules,     │
│   EC2 outputs, etc.) │   verify.sh)         │   Udemy outline mapping)     │
└──────────┬───────────┴──────────────────────┴──────────────────────────────┘
           │ consumed by
           ▼
┌───────────────────────────────────────────────────────────────────────────┐
│                         MODULE CONTENT LAYER                               │
│                   (module-01/ through module-14/)                          │
├──────────────┬──────────────┬──────────────┬───────────────┬──────────────┤
│  explainer/  │  reading/    │  lab/        │  quiz/        │  exploratory/│
│  (diagrams,  │  (concepts,  │  (LAB.md,    │  (QUIZ.md     │  (PROJECTS   │
│   slide      │   reference) │   starter/,  │   trainer +   │   stretch     │
│   notes)     │              │   solution/) │   learner ver)│   ideas)     │
└──────────────┴──────────────┴──────────┬───┴───────────────┴──────────────┘
                                          │ references back to
                                          ▼
┌───────────────────────────────────────────────────────────────────────────┐
│                      CROSS-REPO BOUNDARY (Module 7+)                       │
│              course/ repo → hermes-agent/ repo handoff                     │
├───────────────────────────────────────────────────────────────────────────┤
│  Modules 7, 8, 10-13 labs live in hermes-agent/course/                     │
│  Module 3 (bridge), 9 (patterns), 14 (capstone) split across both repos    │
│  Simulated infra data shared (referenced from both via git clone)          │
└───────────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Location |
|-----------|----------------|----------|
| Module directories | Self-contained unit of learning: all content types for one module | `module-NN-name/` |
| `explainer/` | Conceptual content: Excalidraw sources, slide notes, diagram PNG exports | per module |
| `reading/` | Learner-consumed markdown: `concepts.md` (new ideas) + `reference.md` (look-up material) | per module |
| `lab/` | Hands-on work: `LAB.md` instructions, `starter/` scaffold, `solution/` answer key | per module |
| `quiz/` | Assessment: `QUIZ.md` with trainer version (answers inline) and learner version (answers hidden) | per module |
| `exploratory/` | Optional stretch: `PROJECTS.md` with self-directed project ideas for advanced learners | per module |
| `shared-assets/` | Cross-module reusable content: CloudWatch alarm JSON, shared diagram templates | repo root |
| `simulated-infra/` | Mock CLI response files used across modules 1, 6, 10 | repo root |
| `setup/` | Participant environment provisioning: install guides, `verify.sh` smoke test | repo root |
| `_instructor/` | Live-only materials: facilitation notes, timing guides, team exercise variants | repo root |
| `_udemy/` | Udemy-specific metadata: section/lecture outline mapping, video script notes | repo root |

## Recommended Project Structure

```
course/                                  # This repo — modules 1-6 + shared assets
├── README.md                            # Course overview, module map, day schedule
├── setup/
│   ├── SETUP.md                         # Participant env setup: AWS CLI, KIND, Claude Code, OpenCode
│   └── verify.sh                        # Smoke test: checks all tooling works before Day 1
│
├── shared-assets/                       # Content reused across multiple modules
│   ├── mock-data/
│   │   ├── cloudwatch-alarm.json        # Used: Module 1 lab, Module 2 lab
│   │   ├── ec2-describe-instances.json  # Used: Module 2 lab, Module 6 starter
│   │   └── cost-explorer-30d.json       # Used: Module 2 lab
│   ├── diagrams/
│   │   └── ai-spectrum.excalidraw       # Used: Module 1 explainer, Module 3 explainer
│   └── templates/
│       ├── assessment-quadrant.md       # Module 4 exercise template
│       └── lab-report-template.md       # Optional: structured lab submission
│
├── module-01-ai-foundations/
│   ├── README.md                        # Objectives, prerequisites, time estimate (Day 1 / Udemy Section 1)
│   ├── explainer/
│   │   ├── slide-notes.md               # Notes for each visual/slide
│   │   └── diagrams/
│   │       ├── tokenization.excalidraw
│   │       ├── tokenization.png         # Export for reading materials
│   │       ├── context-window.excalidraw
│   │       ├── context-window.png
│   │       ├── inference-pipeline.excalidraw
│   │       └── inference-pipeline.png
│   ├── reading/
│   │   ├── concepts.md                  # Tokenization, context windows, temperature, inference
│   │   └── reference.md                 # Token economics table, parameter quick-ref
│   ├── lab/
│   │   ├── LAB.md                       # Progressive context engineering with CloudWatch JSON
│   │   ├── starter/
│   │   │   └── alarm-data.json          # Symlink or copy of shared-assets/mock-data/cloudwatch-alarm.json
│   │   └── solution/
│   │       └── optimized-prompt.md      # Reference answer: structured prompt template
│   ├── quiz/
│   │   └── QUIZ.md                      # 10 questions; answers in <!-- comment --> blocks (stripped for Udemy)
│   └── exploratory/
│       └── PROJECTS.md
│
├── module-02-platform-ai/
│   ├── README.md
│   ├── explainer/
│   ├── reading/
│   │   ├── concepts.md                  # AWS AI services landscape
│   │   └── reference.md                 # Platform AI capabilities matrix
│   ├── lab/
│   │   ├── LAB.md                       # AWS Console: anomaly detection, Cost Explorer, Q Developer
│   │   ├── starter/
│   │   │   └── assessment-template.md   # Gap analysis worksheet participants fill in
│   │   └── solution/
│   │       └── sample-assessment.md     # Completed example assessment
│   ├── quiz/
│   └── exploratory/
│
├── module-03-platform-to-agents/        # Bridge module — split with hermes-agent repo
│   ├── README.md
│   ├── explainer/                       # Built HERE: Excalidraw platform vs custom comparison
│   ├── reading/                         # Built HERE: what custom agents add
│   ├── lab/
│   │   └── LAB.md                       # References hermes-agent repo for demo setup
│   ├── quiz/
│   └── exploratory/
│
├── module-04-impact-assessment/
│   ├── README.md
│   ├── explainer/
│   │   └── diagrams/
│   │       └── automation-quadrant.excalidraw
│   ├── reading/
│   ├── lab/
│   │   ├── LAB.md                       # Team exercise variant (live) + solo variant (Udemy)
│   │   ├── starter/
│   │   │   └── automation-quadrant-worksheet.md
│   │   └── solution/
│   │       └── sample-completed-quadrant.md
│   ├── quiz/
│   └── exploratory/
│
├── module-05-structured-ai-coding/
│   ├── README.md
│   ├── explainer/
│   ├── reading/
│   │   ├── concepts.md                  # Superpowers workflow
│   │   └── reference.md                 # Phase checklist quick-ref
│   ├── lab/
│   │   ├── LAB.md                       # Ansible EC2 hardening via structured workflow
│   │   ├── starter/
│   │   │   └── hardening-brief.md       # Problem brief: requirements, constraints
│   │   └── solution/
│   │       └── ec2-hardening.yml        # Completed Ansible playbook
│   ├── quiz/
│   └── exploratory/
│
├── module-06-ai-assisted-iac/
│   ├── README.md
│   ├── explainer/
│   ├── reading/
│   │   ├── concepts.md                  # AI failure modes in IaC generation
│   │   └── reference.md                 # IaC review checklist
│   ├── lab/
│   │   ├── LAB.md                       # Multi-track lab (track selection in preamble)
│   │   ├── starter/
│   │   │   ├── track-a-terraform/       # RDS PostgreSQL: brief + partial module skeleton
│   │   │   ├── track-b-ansible/         # PostgreSQL client: role skeleton
│   │   │   └── track-c-kubernetes/      # Deployment: incomplete manifests
│   │   └── solution/
│   │       ├── track-a-terraform/       # Complete Terraform RDS module
│   │       ├── track-b-ansible/         # Complete Ansible role
│   │       └── track-c-kubernetes/      # Complete K8s manifests with HPA, PDB
│   ├── quiz/
│   └── exploratory/
│
├── module-09-design-patterns/           # Partial — reading/explainer only; lab in hermes-agent repo
│   ├── README.md
│   ├── explainer/
│   ├── reading/
│   │   ├── concepts.md                  # 4 patterns: advisor, investigator, proposal, guardian
│   │   └── reference.md                 # Pattern selection framework
│   ├── quiz/
│   └── exploratory/
│
├── module-14-capstone/                  # Templates only
│   ├── README.md
│   ├── lab/
│   │   ├── LAB.md                       # Facilitation guide + self-paced instructions
│   │   └── starter/
│   │       ├── presentation-template.md
│   │       └── 30-day-roadmap-template.md
│   └── quiz/
│       └── RUBRIC.md                    # Evaluation rubric (replaces quiz for capstone)
│
├── _instructor/                         # Live workshop only — NOT part of Udemy course
│   ├── day-1-facilitator-guide.md       # Timing, transitions, discussion prompts
│   ├── day-2-facilitator-guide.md
│   ├── day-3-facilitator-guide.md
│   ├── team-exercise-variants.md        # Module 4, 11 team exercise instructions
│   └── troubleshooting-guide.md         # Common setup issues + fixes during live delivery
│
└── _udemy/                              # Udemy-specific — NOT part of live workshop docs
    ├── section-outline.md               # Maps modules to Udemy sections/lectures
    ├── video-scripts/                   # Per-lecture talking points for recording
    │   ├── module-01-script.md
    │   └── ...
    └── quiz-learner-versions/           # QUIZ.md with answers stripped
        ├── module-01-quiz-learner.md
        └── ...
```

### Structure Rationale

- **`module-NN-name/`:** Numbered prefix enforces ordering in directory listings. Name component makes content findable without knowing numbers. Self-contained per module means a trainer can extract any single module without breaking others.

- **`explainer/` separate from `reading/`:** Explainers are trainer-facing production artifacts (Excalidraw source files + slide notes). Reading materials are learner-facing markdown. Keeping them separate prevents accidentally shipping trainer notes to Udemy.

- **`lab/starter/` + `lab/solution/`:** The starter directory is what participants receive. The solution directory is the trainer's answer key and also the input for modules that build on prior outputs (e.g., Module 6 solutions may seed Module 10 IaC environments). Separation makes grading and forward-referencing explicit.

- **`shared-assets/`:** Mock data files used by multiple modules live here, not duplicated per module. Reference by path from lab instructions. Modules 1, 2, and 6 all reference the same CloudWatch alarm JSON — single source of truth for data realism.

- **`_instructor/` + `_udemy/`:** The underscore prefix causes these directories to sort last in most file browsers and signals "meta content, not learner content." These are the only content types that differ between the two delivery formats. Everything else works for both.

- **`simulated-infra/`:** Flat collection of mock CLI response files. Referenced from multiple labs. Not inside any single module because Track A/B data from Module 6 feeds Module 10 in the hermes-agent repo as well.

## Architectural Patterns

### Pattern 1: Module Self-Containment with Shared Asset References

**What:** Each module directory can be opened in isolation and understood without reading other modules. Lab instructions are self-contained (prerequisites documented in README.md, not assumed). Shared data files are referenced by relative path from the repo root — paths documented in each lab's setup section.

**When to use:** All content creation. This is the foundational discipline.

**Trade-offs:**
- Pro: Any module can be extracted for standalone delivery or Udemy section
- Pro: Participants can resume from any module without completing prior ones (self-paced critical)
- Con: Module-local setup steps repeat across modules (acceptable — each LAB.md must be runnable standalone)
- Con: Cross-module narrative ("remember what we built in module 5") must be optional context, not a prerequisite

**Example structure for a self-contained lab header:**
```markdown
# Lab: AI-Assisted IaC Generation

## Prerequisites
- Claude Code installed (see /setup/SETUP.md)
- AWS CLI configured (see /setup/SETUP.md)
- No prior modules required — this lab is standalone

## What You'll Build
A Terraform RDS module using AI-assisted generation, then validate it.

## Lab Data
Mock infrastructure data used in this lab: `shared-assets/mock-data/ec2-describe-instances.json`
```

### Pattern 2: Dual-Variant Labs (Team + Solo)

**What:** Labs that involve team dynamics in the live workshop (Module 4, Module 11 fleet orchestration) include two instruction variants in the same LAB.md — a "Live Workshop" section and a "Self-Paced (Udemy)" section. The core exercise is identical; the variant is whether "your team" or "your simulated multi-track agent collection" provides the team members.

**When to use:** Module 4 (impact assessment team scoring), Module 11 (fleet requires 3 agents from 3 participants).

**Trade-offs:**
- Pro: Single LAB.md maintained; no duplication
- Pro: Udemy learner gets complete equivalent experience
- Con: LAB.md is slightly longer due to branching instructions
- Con: Self-paced fleet exercise is less realistic (one person plays all three tracks)

**Example LAB.md variant section:**
```markdown
## Running the Exercise

### If you are in a live workshop
Form a team of 3. Each member picks a different track (A, B, or C) from Module 6.
Your team completes the scoring together, then presents to the group.

### If you are self-paced (Udemy)
Complete all three tracks yourself, or pick two tracks and simulate the third
using the sample-completed-quadrant.md from the solution/ directory as the third
team member's output.
```

### Pattern 3: Progressive Build with Explicit Forward References

**What:** When a module's lab output feeds a later module, the LAB.md explicitly documents the downstream usage. This creates a "you will use this in Module X" note at the solution section, and Module X's lab includes a "if you completed Module Y, use your output; otherwise use the starter/" note.

**When to use:** Module 1 → 2 (CloudWatch data), Module 5 → 6 (structured workflow applied to IaC), Module 6 → 10 in hermes-agent repo (IaC modules feed agent environments).

**Trade-offs:**
- Pro: Participants understand the arc; isolated completions still work
- Pro: Reduces re-work (participant brings their artifact forward)
- Con: Requires maintaining cross-module notes as content evolves
- Con: Solution quality variation (participant-built vs reference starter) must be handled gracefully in downstream labs

**Forward reference notation (in LAB.md solution section):**
```markdown
## Using Your Output

Save your completed `ec2-hardening.yml` — you'll reference the Ansible structure
again in Module 6 (AI-Assisted IaC), Track B.

If you skip directly to Module 6, use `module-06/lab/starter/track-b-ansible/`
as your starting point instead.
```

### Pattern 4: Instructor-Only Annotation Separation

**What:** Trainer-only information (facilitation timing, discussion prompts, "what to watch for," troubleshooting during live delivery) is NOT embedded in participant-facing markdown. It lives in `_instructor/` directory files that reference module numbers. This keeps participant-facing content clean for Udemy.

**When to use:** All modules. Discipline must be maintained from the start to prevent "trainer notes leak" onto Udemy.

**Trade-offs:**
- Pro: Udemy course content is clean; no "tell participants X" instructions leaking to learners
- Pro: Facilitator guide can be updated without touching participant content files
- Con: Trainer must read two documents (module README.md + facilitator guide) for each module
- Con: Facilitator guide and LAB.md can drift if not maintained together

## Data Flow

### Content Creation Flow (Build-Time)

```
Labs (LAB.md + starter/ + solution/)      [built first per module]
         ↓ derived from
Reading materials (concepts.md, reference.md)
         ↓ derived from
Quiz questions (QUIZ.md)
         ↓ both flow into
Explainer content (slide-notes.md + diagram descriptions)
         ↓ used for
Udemy video recording (external production step)
```

**Rationale:** Labs define what actually happens. Concepts are extracted from lab experience, not written in isolation. This avoids theory-without-practice and ensures reading materials are grounded in what participants will do.

### Participant Content Flow (Runtime — Live Workshop)

```
Day 1 Morning:
  setup/SETUP.md + verify.sh
       ↓
  module-01 (explainer → reading → lab) → CloudWatch JSON
       ↓
  module-02 (explainer → reading → lab) → AWS Console/CLI
       ↓ [participant writes assessment]
  module-03 (explainer → reading → demo) → Hermes demo (hermes-agent repo)

Day 1 Afternoon:
  module-04 (exercise) → team output: top automation candidate
       ↓ [team decision feeds Day 3 build target]

Day 2:
  module-05 (lab) → Ansible playbook output
       ↓ [optional: use as Module 6 input]
  module-06 (lab, track choice) → IaC artifact
       ↓ [optional: feeds Module 10 track environment]
  [hermes-agent repo] module-07 → SKILL.md
  [hermes-agent repo] module-08 → configured agent profile

Day 3:
  [hermes-agent repo] module-09 → pattern recognition
  [hermes-agent repo] module-10 → complete domain agent
       ↓ [builds on Day 2 output or uses starter/]
  [hermes-agent repo] module-11 → fleet (team combines Day 3 agents)
  [hermes-agent repo] module-12 → triggers + scheduling
  [hermes-agent repo] module-13 → governance layer
  module-14 → capstone presentation
```

### Participant Content Flow (Runtime — Udemy Self-Paced)

```
Section 1: setup/ → verify.sh
Section 2: module-01 (async video + lab solo)
Section 3: module-02 (async video + lab solo)
Section 4: module-03 (async video + demo video)
Section 5: module-04 (solo variant of team exercise)
Section 6: module-05 (async video + lab solo)
Section 7: module-06 (async video + lab solo, pick one track)
Section 8-13: [hermes-agent repo / separate Udemy section or course]
Section 14: module-14 (solo 30-day plan, no team presentation)
```

### Mock Data Flow

```
shared-assets/mock-data/cloudwatch-alarm.json
    ↓ referenced by
module-01/lab/starter/alarm-data.json (symlink or copy)
    ↓ same data, different context
module-02/lab/starter/sample-cloudwatch-output.json
    ↓ content basis for
[hermes-agent repo] simulated-infra/cloudwatch/alarm-history.json
```

```
module-06/lab/solution/track-a-terraform/   (RDS Terraform module)
    ↓ optional forward reference to
[hermes-agent repo] course/modules/module-10/starter/track-a/ (RDS environment)
```

### Cross-Repo Integration Flow

```
course/ (this repo)                    hermes-agent/course/
    ↓                                          ↑
module-06 solution/track-a → feeds → module-10 starter/track-a
module-06 solution/track-c → feeds → module-10 starter/track-c (K8s manifests)

module-03 reading/ + explainer/
    ↓ references live demo using →
[hermes-agent repo] setup + profile for demo agent

module-09 reading/
    ↓ describes patterns implemented by →
[hermes-agent repo] course/agents/ reference implementations
```

**The repos are siblings — participants clone both.** Cross-references in LAB.md use relative paths from the clone root with a `[hermes-agent repo]` prefix annotation so participants know which clone to look in.

### Key Data Flows Summary

1. **Lab-first derivation:** Labs are written before reading materials. Concepts, quiz questions, and explainer notes are derived from the lab content — not authored in isolation. This prevents disconnected theory.

2. **Starter-to-solution path:** `starter/` contains scaffolding (partial files, TODO markers). `solution/` contains the complete reference implementation. Participants work in starter/; trainers reference solution/ for grading and forward references.

3. **Mock data single-source:** Mock data files live in `shared-assets/mock-data/`. Individual module labs reference them by path rather than duplicating. The hermes-agent repo's `simulated-infra/` is the authoritative source for Hermes-specific mock data; this repo's `shared-assets/` is the authoritative source for pre-Hermes labs (modules 1-6).

4. **Udemy stripping:** `_instructor/` and `_udemy/quiz-learner-versions/` are the only directories that differ between formats. Everything in `module-NN/` is format-agnostic. The Udemy build process (manual) copies `module-NN/` trees and `_udemy/` content; excludes `_instructor/`.

## Scaling Considerations

| Scale | Content Architecture Adjustments |
|-------|----------------------------------|
| Single cohort (20-30 participants) | Monorepo as described. Participants clone both repos. No automation needed. |
| Multiple cohorts (100+ participants) | Tag releases per workshop run. Module updates tracked in CHANGELOG.md. Participant forks create natural snapshot isolation. |
| Udemy distribution | Modules compile to standalone sections. Quiz learner versions pre-stripped and committed to `_udemy/`. Video scripts in `_udemy/video-scripts/`. No LMS integration needed from this repo. |
| Community contributions | Add `CONTRIBUTING.md` with module structure conventions. New tracks added as directories in `lab/starter/` and `lab/solution/` without breaking existing tracks. |

### Scaling Priorities

1. **First bottleneck (lab setup friction):** The `setup/verify.sh` script is the most critical single file. Every minute of setup confusion during live workshop delivery costs 30 people × 1 minute = 30 minutes of cohort time. Invest in making this script comprehensive and catch all failure modes.

2. **Second bottleneck (content drift between formats):** The biggest maintenance risk for dual-format content is trainer annotations leaking into participant files as the course evolves. Enforce the `_instructor/` boundary rigorously from the first commit.

## Anti-Patterns

### Anti-Pattern 1: Format-Specific Content Embedded in Module Files

**What people do:** Write "if you're in the live workshop, ask your instructor" or "Udemy students: skip this team exercise" inline in LAB.md.

**Why it's wrong:** It doubles the cognitive load for every reader. Udemy learners see workshop instructions that don't apply. Workshop participants see Udemy-specific notes. Content becomes cluttered and harder to maintain.

**Do this instead:** Use the dual-variant section pattern (Pattern 2). Clearly delimit "Live Workshop" and "Self-Paced (Udemy)" sub-sections only when the exercise structure genuinely differs. For content that is identical (most content), write it once with no format label.

### Anti-Pattern 2: Module-Local Copies of Shared Mock Data

**What people do:** Copy `cloudwatch-alarm.json` into each module's `lab/starter/` directory that needs it.

**Why it's wrong:** Three modules with slightly different copies diverge over time. Realistic scenario updates must be applied to each copy. The data loses its identity as "the same CloudWatch alarm" across the progressive narrative.

**Do this instead:** `shared-assets/mock-data/` is the single source. Module lab instructions reference it by path. If a module needs a local copy for participant isolation, use a symlink — not a file copy.

### Anti-Pattern 3: Reading Materials Written Before Labs

**What people do:** Write `concepts.md` first (it feels like "natural" starting point), then write the lab to illustrate the concepts.

**Why it's wrong:** Concepts written without reference to a concrete lab tend toward abstract theory. The lab must then conform to the theory rather than demonstrating real technique. Participants read about tokenization theoretically, then do a lab that doesn't connect the concept to hands-on behavior.

**Do this instead:** Draft the lab (what will participants actually do?). Then extract the concepts that the lab requires participants to understand. The reading material teaches exactly what is needed to understand and succeed in the lab — no more, no less.

### Anti-Pattern 4: Per-Module Dependency on Completing Prior Labs

**What people do:** Module 5 lab starts with "open the artifact you built in Module 3." Module 6 starts with "use your Module 5 output."

**Why it's wrong:** Udemy self-paced learners may skip modules, resume from where they left off, or take modules out of order. A hard dependency on a prior lab output excludes these participants and creates a fragile progressive state that breaks if any lab goes wrong.

**Do this instead:** Always provide a `starter/` that works standalone. Forward-reference previous outputs as optional ("if you completed Module 5, you can use your `ec2-hardening.yml` here; otherwise use the provided starter file"). The starter/ is the fallback for all cases.

### Anti-Pattern 5: Hermes-Specific Content in Modules 1-6

**What people do:** Reference Hermes concepts, SOUL.md, SKILL.md in early modules to "prime" participants for Day 2-3 content.

**Why it's wrong:** Modules 1-6 use Claude Code and AWS Console — not Hermes. Mixing frameworks in early modules creates confusion about which tool does what, especially for Udemy learners who may not be taking the full course.

**Do this instead:** Module 3 (bridge module) is the single point where custom agents are introduced. Modules 1-6 reference only Claude Code, OpenCode, AWS CLI, and Terraform/Ansible/K8s. The Hermes ecosystem is a Module 7+ concern.

## Integration Points

### Cross-Repo Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Module 3 (bridge) | Reading materials here reference demo script in hermes-agent repo | LAB.md points to `[hermes-agent repo]/course/modules/module-03-demo/` |
| Module 6 solutions → Module 10 starters | File copy by participant or trainer pre-workshop | Document exact copy command in module-10 LAB.md |
| Module 9 patterns reading | References Hermes profile examples in hermes-agent repo | Links to specific files with `[hermes-agent repo]` prefix |
| Module 14 capstone | Combines outputs from both repos | LAB.md in this repo; facilitation uses both tool chains |
| Shared mock data | `shared-assets/mock-data/` here; `simulated-infra/` in hermes-agent | Both repos cloned locally; no network dependency |

### External Tool Integration Points

| Tool | Integration Pattern | Lab Approach |
|------|---------------------|-------------|
| Claude Code | Participants use their own installation | Setup guide covers install + OAuth; no API keys needed |
| OpenCode | Alternative to Claude Code | Setup guide covers install; supports multiple LLM backends |
| AWS CLI | Configured to participant's account or free tier | Mock data fallback for labs requiring live AWS responses |
| KIND (Kubernetes) | Local cluster, no cloud dependency | Module 6 Track C and referenced by Module 10 Track C |
| Google AI Studio | Free-tier LLM backend for OpenCode | Documented as alternative provider in setup guide |

## Build Order (Content Creation Sequence)

The following sequence unblocks downstream work as fast as possible. Within each phase, tasks can be parallelized.

```
Phase 1 — Foundation (unblocks everything)
├── setup/SETUP.md + verify.sh
│   Reason: Referenced in every module README as prerequisite.
│   Blocks: All lab content.
└── shared-assets/mock-data/ files
    Reason: Module 1, 2, 6 labs depend on specific JSON structures.
    Blocks: Module 1 lab, Module 2 lab, Module 6 starter Track A/B.

Phase 2 — Day 1 Content (unblocks workshop dry-run)
├── module-01: lab/ first, then reading/, then quiz/, then explainer/
├── module-02: lab/ first, then reading/, then quiz/, then explainer/
├── module-03: reading/ + explainer/ (no lab here; lab is in hermes-agent repo)
└── module-04: lab/ (assessment worksheet) first, then reading/, then quiz/
    Note: Module 4 reading/ can be written in parallel with lab/ since it's
    a facilitation exercise, not a technical lab with prerequisites.

Phase 3 — Day 2 Content  [depends on Phase 1]
├── module-05: lab/ (Ansible playbook starter + solution) first, then reading/
└── module-06: lab/ starters + solutions per track, then reading/
    Note: Module 06 solution/track-a and track-c output files are
    referenced as optional starters for hermes-agent module-10.
    Coordinate naming conventions with hermes-agent repo.

Phase 4 — Supporting Content  [can be parallelized with Phase 2-3]
├── module-09: reading/concepts.md + reading/reference.md
│   (no lab in this repo — hermes-agent repo builds the pattern demos)
└── module-14: lab/starter/ templates + quiz/RUBRIC.md

Phase 5 — Format-Specific Overlays  [depends on Phases 2-4]
├── _instructor/: facilitation guides per day
├── _udemy/: section-outline.md, video-scripts/, quiz learner versions
└── All QUIZ.md files (quiz content is last — derived from reading + lab)
```

**Critical path:** Phase 1 shared-assets/mock-data/ → Phase 2 module-01 lab → Phase 2 module-02 lab → Phase 3 module-06 solution/. Everything else can be built in parallel once mock data exists.

## Sources

- Direct analysis: `/Users/gshah/work/agentic/devops/course/HANDOFF.md` — module-by-module content breakdown, cross-repo responsibility split, dependency chain diagram, simulated infra strategy, priority order
- Direct analysis: `/Users/gshah/work/agentic/devops/course/.planning/PROJECT.md` — active requirements, constraints, key decisions
- Direct analysis: `/Users/gshah/work/agentic/devops/course/CLAUDE.md` — course structure standard, module directory template, dual-format constraints
- Direct analysis: `/Users/gshah/work/agentic/devops/hermes-agent/.planning/research/ARCHITECTURE.md` — Hermes-side course architecture, profile-as-agent-definition pattern, simulated infra file-based mocking pattern, build order for hermes modules
- Pattern reference: [courselabs/kubernetes](https://github.com/courselabs/kubernetes) — labs/ + setup/ + scripts/ separation pattern for technical course repos
- Pattern reference: [MinhHungPhan/aws-hands-on-labs](https://github.com/MinhHungPhan/aws-hands-on-labs) — service-scoped, tier-based lab organization with README-per-lab
- Industry context: [Self-paced vs instructor-led blended design](https://www.arlo.co/blog/self-paced-learning-vs-instructor-led) — blended format best practice: shared core content, format-specific overlays

---
*Architecture research for: Agentic DevOps Course — Content Development (modules 1-6 + shared assets)*
*Researched: 2026-04-04*
