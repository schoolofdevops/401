# Phase 4: Remaining Content — Research

**Researched:** 2026-04-04
**Domain:** Course content authoring — MDX/Docusaurus, module scaffolding, instructor guide conventions, Udemy structure
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**D-47:** For modules whose labs are in the Hermes repo (7, 8, 10, 11, 12, 13), create concepts.mdx, reference.mdx, QUIZ.mdx, PROJECTS.mdx, and README.mdx in this repo's Docusaurus site.

**D-48:** Content describes WHAT participants will learn/build without duplicating Hermes lab instructions. Reading materials provide conceptual foundation — participants read before doing the Hermes lab.

**D-49:** Use HANDOFF.md Layer 3-5 concept tables as the reading material checklist for these modules.

**D-50:** Pattern taxonomy: advisor, investigator, proposal, guardian — each mapped to Hermes capabilities with concrete examples.

**D-51:** Autonomy spectrum L1 (Assistive) → L4 (Semi-autonomous) with DevOps analogies and concrete promotion criteria.

**D-52:** No lab in this repo for Module 9 — reading/quiz only. Hermes repo has the examples.

**D-53:** Presentation template: what teams/individuals should cover in their demo (problem statement, agent design, live demo, governance spec, 30-day plan).

**D-54:** 30-day deployment roadmap template: post-workshop implementation plan with weekly milestones.

**D-55:** Evaluation rubric: scored criteria for capstone assessment. Solo-completable for Udemy.

**D-56:** Three guides: Day 1, Day 2, Day 3 — each with timing, module transitions, debrief prompts, common participant questions.

**D-57:** Format: separate Docusaurus section (e.g., `instructor/`) not visible in the participant sidebar. Or a clearly-marked `_instructor/` directory.

**D-58:** Fill gaps: every module (1-14) must have concepts.mdx, reference.mdx, QUIZ.mdx, PROJECTS.mdx, README.mdx. Modules 1-6 already have most — check for missing PROJECTS.mdx files.

**D-59:** Update stale README.mdx overview tables (Phase 2 verifier flagged "coming soon" placeholders).

**D-60:** Udemy section outline mapping modules to Udemy sections.

**D-61:** Solo fallbacks documented for all team exercises (Module 4 scoring, Module 11 fleet, Module 14 capstone).

**D-62:** Vocabulary audit: grep for "prompt engineering" across all content — zero positive instances after Module 1.

### Claude's Discretion
- Specific content depth for Modules 7-13 reading materials (constrained by HANDOFF.md concept tables)
- Instructor guide timing estimates per module
- Udemy section structure and naming
- PROJECTS.mdx stretch project ideas for each module
- Whether instructor guides go in Docusaurus sidebar or separate directory

### Deferred Ideas (OUT OF SCOPE)
None — this is the final phase.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| MOD9-01 | Reading — Pattern taxonomy: advisor, investigator, proposal, guardian mapped to Hermes capabilities | HANDOFF.md Layer 5 concept table + FEATURES.md multi-agent patterns |
| MOD9-02 | Reading — Autonomy spectrum L1→L4 with DevOps analogies and concrete promotion criteria | FEATURES.md governance features + HANDOFF.md Layer 5 |
| MOD9-03 | Quiz covering design patterns and autonomy levels | Pattern coverage from MOD9-01/02 content |
| MOD14-01 | Presentation template — what teams/individuals cover in their demo | HANDOFF.md Module 14 section + D-53 |
| MOD14-02 | 30-day deployment roadmap template | D-54 post-workshop plan format |
| MOD14-03 | Evaluation rubric — scored criteria for capstone | D-55 solo-completable rubric |
| CONTENT-01 | concepts.mdx for every module (1-14) | Modules 1-6 exist; 7-14 need creation based on HANDOFF.md concept tables |
| CONTENT-02 | reference.mdx for every module (1-14) | Same gap as CONTENT-01 |
| CONTENT-03 | QUIZ.mdx for every module (1-14) | Same gap; existing QUIZ.mdx pattern from Module 6 confirmed |
| CONTENT-04 | PROJECTS.mdx per module (1-14) | Modules 1-5a are missing; 5b/6 have examples |
| CONTENT-05 | README.mdx for every module (1-14) | Modules 1-6 exist; 7-14 need creation; 1-4 have stale "coming soon" tables |
| CONTENT-06 | Context engineering vocabulary enforced — zero "prompt engineering" after Module 1 | Grep confirms only Module 1 and explicit contrasts contain the phrase |
| FMT-01 | Instructor facilitator guides for Day 1/2/3 | D-56/57 decisions; separate from participant sidebar |
| FMT-02 | Udemy section outline | D-60; 14 modules → Udemy section mapping |
| FMT-03 | Solo fallback for all team exercises | Confirmed blockers: Module 11 requires pre-built reference agents |
| FMT-04 | Every lab step includes "Expected result:" validation | Enforcement/audit of existing labs; new modules per-step validation |
| FMT-05 | Lab deliverable stated at top of every LAB.md | Same audit pattern |
</phase_requirements>

---

## Summary

Phase 4 is a content-completeness phase: the infrastructure and Day 1/2 modules are done; this phase fills the remaining gaps across all 14 modules, adds delivery format artifacts, and runs final quality audits. The work falls into four natural buckets:

**Bucket 1 — New module scaffolding (Modules 7-14):** Eight new module directories need to be created under `course-site/docs/`. The pattern is fully established by Module 6 (the most complete module): README.mdx + reading/concepts.mdx + reading/reference.mdx + quiz/QUIZ.mdx + exploratory/PROJECTS.mdx, each with a `_category_.json`. The Docusaurus sidebar is autogenerated, so new directories appear automatically when the category config is present. Content for Modules 7-8 and 10-13 reads as "pre-lab conceptual foundation" — participants read before doing the Hermes lab. Content source for these modules is HANDOFF.md Layers 3-5 concept tables.

**Bucket 2 — Gap-fill for existing modules (1-6):** Five modules (1-4, 5a) are missing their `exploratory/` directory and PROJECTS.mdx. Four modules (1-4) have stale README.mdx tables with "coming soon" placeholders that must be updated to link to the content that now exists. The vocabulary audit can run as a final grep pass.

**Bucket 3 — Specific module artifacts:** Module 9 (design patterns) needs reading/quiz only (no lab). Module 14 (capstone) needs three templates: presentation structure, 30-day roadmap, and evaluation rubric.

**Bucket 4 — Format overlays:** Instructor facilitator guides (Day 1/2/3), Udemy section outline, and solo fallbacks for team exercises. The Module 11 solo fallback has a confirmed blocker: it requires three pre-built reference agent profiles from the Hermes repo that may or may not exist yet.

**Primary recommendation:** Execute in three plans: (1) Modules 9 + 14 specific content; (2) all-module content sweep for Modules 7-13 + gap-fill for 1-6; (3) format overlays + vocabulary audit.

---

## Standard Stack

### Core Technologies

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Docusaurus | 3.x (existing) | MDX site generation | Already installed; all existing content uses it |
| MDX | 3.x (via Docusaurus) | Markdown + JSX content format | All existing files are `.mdx` |
| Autogenerated sidebar | Docusaurus built-in | Navigation from `_category_.json` | Already configured in `sidebars.ts` |

### File Naming Conventions (from existing modules)

| File | Convention | Example |
|------|-----------|---------|
| README | `README.mdx` with frontmatter `id: module-NN-readme` | `module-07-agent-skills/README.mdx` |
| Concepts | `reading/concepts.mdx` with `id: module-NN-concepts` | `module-07-agent-skills/reading/concepts.mdx` |
| Reference | `reading/reference.mdx` with `id: module-NN-reference` | `module-07-agent-skills/reading/reference.mdx` |
| Quiz | `quiz/QUIZ.mdx` with `id: module-NN-quiz` | `module-07-agent-skills/quiz/QUIZ.mdx` |
| Projects | `exploratory/PROJECTS.mdx` with `id: module-NN-exploratory` | `module-07-agent-skills/exploratory/PROJECTS.mdx` |

### Frontmatter Pattern (from Module 6 as canonical reference)

```yaml
---
id: module-06-concepts
title: "Concepts: [Module Title]"
sidebar_label: "Concepts"
sidebar_position: 1
description: "[one-line description]"
---
```

### Category Config Pattern

Each subdirectory needs `_category_.json`:

```json
// reading/_category_.json
{"label": "Reading", "position": 2, "link": {"type": "generated-index"}}

// quiz/_category_.json
{"label": "Quiz", "position": 3}

// exploratory/_category_.json
{"label": "Exploratory", "position": 4, "link": {"type": "generated-index"}}
```

Module-level `_category_.json`:
```json
{
  "label": "Module 7: Agent Skills",
  "position": 8,
  "collapsed": false,
  "link": {"type": "doc", "id": "module-07-agent-skills/module-07-readme"}
}
```

**Note on sidebar positions:** Existing modules 1-7 occupy positions 1-7. Modules 7-14 should use positions 8-15 for module-level categories.

---

## Architecture Patterns

### Recommended Directory Structure for New Modules

```
course-site/docs/
├── module-07-agent-skills/
│   ├── README.mdx                  # sidebar_position: 0
│   ├── _category_.json             # label, position, collapsed, link
│   ├── reading/
│   │   ├── _category_.json         # position: 2
│   │   ├── concepts.mdx            # sidebar_position: 1
│   │   └── reference.mdx           # sidebar_position: 2
│   ├── quiz/
│   │   ├── _category_.json         # position: 3
│   │   └── QUIZ.mdx                # sidebar_position: 1
│   └── exploratory/
│       ├── _category_.json         # position: 4
│       └── PROJECTS.mdx            # sidebar_position: 1
├── module-08-tool-integration/
├── module-09-design-patterns/
├── module-10-domain-agent/
├── module-11-fleet/
├── module-12-triggers/
├── module-13-governance/
└── module-14-capstone/
    ├── README.mdx
    ├── _category_.json
    ├── reading/
    │   ├── concepts.mdx
    │   └── reference.mdx
    ├── quiz/
    │   └── QUIZ.mdx
    ├── capstone/                   # Module 14 specific
    │   ├── _category_.json
    │   ├── PRESENTATION.mdx        # MOD14-01
    │   ├── ROADMAP-TEMPLATE.mdx    # MOD14-02
    │   └── RUBRIC.mdx              # MOD14-03
    └── exploratory/
        └── PROJECTS.mdx
```

### Instructor Guide Pattern

Decision D-57 says separate directory not visible in participant sidebar. The cleanest approach: a top-level `instructor/` directory alongside `docs/` that is NOT referenced in sidebars.ts. Alternative: prefix with underscore for Docusaurus exclusion. Based on Docusaurus behavior, files outside `docs/` are not auto-included.

```
course-site/
├── docs/                           # participant-visible
└── instructor/                     # NOT in sidebar, standalone markdown
    ├── day-1-guide.md
    ├── day-2-guide.md
    └── day-3-guide.md
```

OR: keep them as plain markdown in the project root `instructor/` directory (not inside course-site at all), since they don't need to be in the Docusaurus build.

**Recommendation:** Place instructor guides at `/Users/gshah/work/agentic/devops/course/instructor/` as standalone markdown files — separate from the Docusaurus site entirely. Clean, simple, not accidentally published.

### Quiz Structure Pattern (from Module 6)

```mdx
---
id: module-NN-quiz
title: "Quiz: [Module Title]"
sidebar_label: "Quiz"
sidebar_position: 1
description: "..."
---

# Quiz: [Module Title]

[brief framing of what the quiz tests — not syntax, operational understanding]

---

### Question N: [Category]

[Question text]

A) ...
B) ...
C) ...
D) ...

<details>
<summary>Show Answer</summary>

**Correct answer: X)**

[2-4 line explanation connecting to reading/lab content. The explanation IS the teaching moment for Udemy learners.]

</details>
```

Aim for 5-8 questions per module. Mix of:
- Multiple choice (concepts)
- Scenario-based ("Which pattern would you use when...")
- Anti-pattern recognition ("What is wrong with this approach...")

### Concepts.mdx Content Pattern (from Modules 1-6)

Structure each concepts.mdx as:
1. **Brief callback to the lab** — "You just built X. Now let's understand WHY it works."
2. **Numbered sections** (typically 4-7 key concepts)
3. **DevOps analogy per concept** — every abstract concept gets a concrete ops parallel
4. **No "prompt engineering" language** after Module 1 — use "context engineering" throughout
5. **Progressive — references earlier modules** to show knowledge building

### PROJECTS.mdx Pattern (from Modules 5b and 6)

```mdx
---
id: module-NN-exploratory
title: "Exploratory: [Module Title] Projects"
sidebar_label: "Exploratory Projects"
sidebar_position: 1
description: "..."
---

# Exploratory: [Module Title] Projects

**These are stretch projects — not required for course completion.**

[1-2 sentence framing of who these are for]

---

## Project N: [Title]

**Estimated time:** [X] minutes
**Extends:** [what lab/track it builds on]
**Prerequisites:** [what must be complete]

### What You Will Build
[2-3 sentences describing the deliverable]

### Challenge
[The non-obvious difficulty that makes this a learning experience]

### Steps
[Numbered steps if warranted, or leave open-ended for truly exploratory projects]

### Expected Outcome
[What success looks like]
```

---

## Content Source Map (HANDOFF.md Layers → Module Reading)

The HANDOFF.md concept tables are the **authoritative checklist** for what each module's reading must cover.

### Layer 3 — Knowledge & Memory → Modules 7 (partial) + early Module 10 reading

| Concept | Module | Reading Type |
|---------|--------|-------------|
| RAG (retrieve → augment → generate) | 7 or 10 concepts | Core concept |
| Embeddings & semantic search | 7 concepts | Core concept |
| Vector databases | 7 concepts | Core concept |
| Agentic RAG (agent decides WHEN to retrieve) | 7/10 | Core concept |
| Graph RAG | 10 | Reading only |
| Memory types (short-term, long-term, procedural) | 7 concepts | Core concept |

### Layer 4 — Agentic Tools & Integration → Modules 7-8

| Concept | Module | Reading Type |
|---------|--------|-------------|
| Tool types (CLI/API/MCP) | 8 concepts | Core + Lab |
| MCP (Model Context Protocol) | 8 concepts | Core + Lab |
| Tool safety (allowed/blocked lists, sandboxing) | 8 concepts | Core + Lab |
| Skills as procedural memory | 7 concepts | Core + Lab |

### Layer 5 — Multi-Agent & Production → Modules 9-13

| Concept | Module | Reading Type |
|---------|--------|-------------|
| Agent design patterns (advisor/investigator/proposal/guardian) | 9 | Core |
| Delegation / sub-agents | 11 concepts | Core + Lab |
| Autonomy spectrum L1-L4 | 9 + 13 | Core |
| Human-in-the-loop | 13 concepts | Core + Lab |
| Governance triad (DO × APPROVE × LOG) | 13 concepts | Core + Lab |
| Production interfaces (cron/webhooks/chat/dashboards) | 12 concepts | Core + Lab |

---

## Module 9 Design Patterns — Detailed Content Spec

This module has no lab in this repo (D-52). Reading and quiz only.

### Four Pattern Taxonomy (D-50)

Each pattern needs: definition, DevOps role analogy, concrete Hermes example, when to use, anti-pattern warning.

| Pattern | Team Role Analogy | Core Behavior | Hermes Mapping |
|---------|------------------|---------------|----------------|
| **Advisor** | On-call SRE — always watching, tells you what's wrong | Observes → analyzes → recommends, never acts | Read-only toolset; L1 autonomy; all output advisory |
| **Investigator** | Root-cause analyst — digs until they find it | Receives incident → retrieves logs/metrics → traces to root cause | Terminal + web tools; multi-step reasoning; RAG-backed skill |
| **Proposal** | Change manager — prepares, waits for approval | Diagnoses → prepares action plan → presents for human approval | Approval workflow required before any mutation; Hermes `approval` tool |
| **Guardian** | Security reviewer — blocks dangerous changes | Reviews proposed actions → enforces allowed/blocked lists → rejects policy violations | Blocked command list; safety boundary enforcement; audit log |

### Autonomy Spectrum (D-51)

| Level | Name | Description | DevOps Analogy | Promotion Criteria |
|-------|------|-------------|----------------|-------------------|
| L1 | Assistive | Agent observes and reports; human decides and acts | Manual runbook — SRE reads, SRE executes | 100 correct diagnoses, zero false positives |
| L2 | Advisory | Agent recommends; human approves and acts | Canary deploy — metrics shown, human clicks proceed | 30-day track record at L1, team review |
| L3 | Proposal | Agent prepares execution plan; human approves and watches | Blue-green deploy — plan prepared, human approves activation | 90-day L2 track record; change management sign-off |
| L4 | Semi-autonomous | Agent executes with alerting; human can intervene | Auto-scaling — acts within defined thresholds, alerts on anomaly | 180-day L3 track record; SRE team confidence vote; incident response plan |

Note: Full autonomous (L5) is intentionally out of scope — the course teaches the reasoning for stopping at L4, which is a key governance concept.

---

## Module 14 Capstone — Detailed Content Spec

### Presentation Template (MOD14-01)

Five sections, each with guiding questions for solo and team tracks:

1. **Problem statement** — What operational pain are you solving? What does "before" look like?
2. **Agent design** — Which pattern (advisor/investigator/proposal/guardian)? What autonomy level? What tools and skills?
3. **Live demo** — Run the agent against real or simulated data (3-5 minute walkthrough)
4. **Governance spec** — What can the agent do alone vs. with approval? How will you audit it?
5. **30-day plan** — First week: test setup. Weeks 2-3: iterate on skills. Week 4: first production run. Month 2: expand scope.

### 30-Day Roadmap Template (MOD14-02)

```
Week 1: Foundation
  - Install Hermes in your work environment
  - Configure your chosen LLM provider
  - Wire the agent from your Module 10 lab to your real infrastructure

Week 2: First Real Run
  - Run the agent on one real operational task (read-only)
  - Document: what it got right, what it got wrong, what context was missing

Week 3: Skill Iteration
  - Refine your SKILL.md based on Week 2 observations
  - Add one new decision branch you discovered
  - Run against 5 real scenarios, track accuracy

Week 4: Production Trial
  - Schedule your first automated run (cron)
  - Set up audit logging
  - Share one output with a teammate for feedback

Month 2: Expansion
  - Add a second skill
  - Consider promoting from L1 → L2 (advisory mode)
  - Identify your next Module 10 track to add
```

### Evaluation Rubric (MOD14-03)

Scored 1-5 on each dimension. Self-scorable for Udemy learners.

| Dimension | 1 (Needs Work) | 3 (Meets Standard) | 5 (Excellent) |
|-----------|---------------|-------------------|---------------|
| Problem statement clarity | Vague pain, no metrics | Specific task, rough time savings | Specific task, measured frequency + time + error rate |
| Agent design quality | No pattern named, no autonomy level | Pattern named, level justified | Pattern + level + tradeoffs discussed, alternative patterns rejected with reasoning |
| Live demo quality | Agent errors or generic output | Agent produces useful output on real/mock data | Agent output is actionable, includes reasoning trace visibility |
| Governance spec completeness | No boundaries defined | Basic allowed/blocked list + one approval gate | Full DO × APPROVE × LOG with promotion criteria |
| 30-day plan realism | Vague or missing | Weekly milestones present | Milestones with success criteria, rollback plan if agent regresses |

---

## Exact Content Gaps Identified

### Confirmed Missing: Modules 1-6

| Module | Missing |
|--------|---------|
| 1: Foundations | `exploratory/` directory + `PROJECTS.mdx`; README.mdx has 2 stale "coming soon" table entries |
| 2: Platform AI | `exploratory/` directory + `PROJECTS.mdx`; README.mdx has 3 stale "coming soon" table entries |
| 3: Bridge | `exploratory/` directory + `PROJECTS.mdx`; README.mdx has 2 stale "coming soon" table entries |
| 4: Impact | `exploratory/` directory + `PROJECTS.mdx`; README.mdx has 3 stale "coming soon" table entries |
| 5a: Structured Coding | `exploratory/` directory + `PROJECTS.mdx` |
| 5b: AI Workflows | Nothing — PROJECTS.mdx exists |
| 6: AI-Assisted IaC | Nothing — PROJECTS.mdx exists |

**Stale "coming soon" locations (verified by grep):**
- `module-01-foundations/README.mdx` lines 46-47: "LLM Fundamentals for Operations (coming soon)" and "Module 1 Assessment (coming soon)"
- `module-02-platform-ai/README.mdx` lines 39-41: Lab, Reading, Quiz all "(coming soon)"
- `module-03-bridge/README.mdx` lines 38-39: Lab and Reading "(coming soon)"
- `module-04-impact/README.mdx` lines 38-40: Lab, Reading, Quiz all "(coming soon)"

All these now exist — the README tables just need their placeholder text replaced with real links.

### Confirmed Missing: Modules 7-14 (all content)

| Module | Directory Name | Full scaffold needed |
|--------|---------------|---------------------|
| 7 | `module-07-agent-skills` | README + reading + quiz + exploratory |
| 8 | `module-08-tool-integration` | README + reading + quiz + exploratory |
| 9 | `module-09-design-patterns` | README + reading + quiz + exploratory (no lab) |
| 10 | `module-10-domain-agent` | README + reading + quiz + exploratory |
| 11 | `module-11-fleet` | README + reading + quiz + exploratory |
| 12 | `module-12-triggers` | README + reading + quiz + exploratory |
| 13 | `module-13-governance` | README + reading + quiz + exploratory |
| 14 | `module-14-capstone` | README + reading + quiz + exploratory + capstone templates |

### Confirmed Missing: Format Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| Day 1 facilitator guide | `instructor/day-1-guide.md` | Not created |
| Day 2 facilitator guide | `instructor/day-2-guide.md` | Not created |
| Day 3 facilitator guide | `instructor/day-3-guide.md` | Not created |
| Udemy section outline | `instructor/udemy-outline.md` | Not created |

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Docusaurus sidebar navigation | Manual `sidebars.ts` entries | `_category_.json` in each directory | Already configured with `autogenerated` — adding a file with the right frontmatter is all that's needed |
| Quiz answer reveal | Custom React component | `<details>/<summary>` HTML elements | Already used in existing QUIZ.mdx files; works in MDX natively |
| Instructor guide visibility control | Docusaurus exclude patterns | Standalone markdown outside `docs/` directory | Simplest isolation: files not in `docs/` are not built into the Docusaurus site |
| Module 9 "no lab" explanation | Long apology | Brief `:::info` callout pointing to Hermes repo | Docusaurus admonitions are available in MDX |

**Key insight:** The full content authoring framework already exists — Docusaurus config, sidebar strategy, file patterns, content voice. Phase 4 is pure content writing within an established system. No new infrastructure decisions needed.

---

## Common Pitfalls

### Pitfall 1: MDX Frontmatter `id` Collisions
**What goes wrong:** Two files claim the same `id` in frontmatter — Docusaurus throws a build error.
**Why it happens:** Copy-paste from an existing module without updating the `id` field.
**How to avoid:** Every file's `id` must include the module number. Pattern: `module-NN-filename` (e.g., `module-07-concepts`).
**Warning signs:** Docusaurus build warnings about duplicate doc IDs.

### Pitfall 2: Cross-Links Using Relative Paths Instead of Doc IDs
**What goes wrong:** Link like `./module-07-reference` works in dev but throws broken link warnings.
**Why it happens:** Using file paths instead of document IDs.
**How to avoid:** Use document ID syntax: `[link text](./module-07-reference)` works because Docusaurus resolves by ID within the same directory. Confirmed pattern from STATE.md: "MDX cross-links use document id (e.g., ./module-01-reference) not relative path."
**Warning signs:** `onBrokenLinks: 'warn'` in docusaurus.config.ts will surface these.

### Pitfall 3: "Prompt Engineering" Vocabulary Leak
**What goes wrong:** Module 7-13 content uses "prompt engineering" naturally (it's common industry vocabulary), violating CONTENT-06.
**Why it happens:** Authors write naturally without vocabulary discipline.
**How to avoid:** The contrast framing from Module 1 is the safe pattern: "Unlike prompt engineering (which focuses on phrasing), context engineering focuses on what the model sees." Use this exact framing in Modules 7-13 when the concept arises — never use "prompt engineering" as the positive term.
**Warning signs:** `rg "prompt engineering" course-site/` — must return zero results after Module 1 content.

### Pitfall 4: Module 11 Solo Fallback Dependency on Hermes Reference Agents
**What goes wrong:** Module 11 reading/solo fallback describes using three pre-built reference agents that may not exist yet in the Hermes repo.
**Why it happens:** STATE.md explicitly flags this: "Module 11 solo fallback (fleet lab) requires three pre-built reference agents from hermes-agent repo — confirm availability before finalizing Module 11 content."
**How to avoid:** Check `hermes-agent/` for reference agent profiles before writing Module 11's solo fallback. If profiles don't exist, write the fallback using the `datagen-config-examples/` patterns as proxy, or frame the solo fallback as "build all three agents yourself across three sessions."
**Warning signs:** Solo fallback section describes agents by name that don't exist in the Hermes repo.

### Pitfall 5: Stale README Tables Not Fully Updated
**What goes wrong:** README update replaces "coming soon" in the table but the hyperlinks point to wrong document IDs or use incorrect relative paths.
**Why it happens:** Writing links without verifying the actual `id` frontmatter of the target file.
**How to avoid:** Check each target file's frontmatter `id` before writing the link. Pattern: `[Module N Assessment](./module-0N-foundations/quiz/module-0N-quiz)` using the doc ID.

### Pitfall 6: Module Sidebar Positions Conflict
**What goes wrong:** Two module `_category_.json` files use the same `position` value, causing unpredictable ordering.
**Why it happens:** Modules 1-7 use positions 1-7; new modules starting at position 8 must be sequential.
**How to avoid:** Assign positions 8-15 for Modules 7-14 respectively. Module 7 = position 8, Module 8 = position 9, Module 9 = position 10... Module 14 = position 15.

### Pitfall 7: Module 14 Capstone Not Solo-Completable
**What goes wrong:** Presentation template and rubric assume team of 3 — solo Udemy learner has no team.
**Why it happens:** The live workshop framing is natural but excludes online learners.
**How to avoid:** D-55 explicitly requires solo-completable rubric. Every team exercise must have a "Solo Learner" callout: "If completing this course independently, [adjusted instructions]." The rubric criteria should score individual work, not team output.

---

## Vocabulary Audit — Current State

**Grep result (verified):** "prompt engineering" appears in:
- `module-01-foundations/quiz/QUIZ.mdx` — as contrast term in Question 4 (CORRECT — allowed in Module 1)
- `module-01-foundations/reading/reference.mdx` — contrast table (CORRECT — Module 1 only)
- `module-03-bridge/reading/reference.mdx` — "context engineering matters more than prompt engineering" (BORDERLINE — acceptable contrast framing in early bridge module)
- `module-05b-ai-workflows/quiz/QUIZ.mdx` — Question 1 uses it as contrast term (BORDERLINE — could be reframed)
- `module-05b-ai-workflows/reading/concepts.mdx` — "Module 1 introduced context engineering as the alternative to prompt engineering" (BORDERLINE — transition reference)

**Assessment:** No outright violations. The three Module 5b occurrences are contrast references, not using "prompt engineering" as a positive term. However, CONTENT-06 says "zero instances after Module 1" — the planner should determine whether to leave Module 5b's contrast references (educational) or excise them (strict compliance). Recommend flagging this as a planner decision rather than a hard fix.

**For Modules 7-14 new content:** Use "context engineering" throughout. The only safe mention of "prompt engineering" is in negation: "This is not prompt engineering..." and even then, prefer avoiding it entirely.

---

## Instructor Guide — Content Spec

### Day 1 Guide Structure

Modules 1-4. Key facilitation moments:

| Time | Module | Facilitator Action |
|------|--------|-------------------|
| 9:00 | Intro | Icebreaker: "What's your most repetitive operational task?" — captures Module 4 input |
| 9:15 | Module 1 | Lab intro: demo Layer 1 yourself first, then participants Layer 1-4 |
| 10:15 | Module 1 | Debrief: "What changed between Layer 1 and Layer 4?" — surface the context engineering insight |
| 10:30 | Module 2 | Lab: participants with AWS explore; participants without use mock path |
| 11:30 | Module 3 | Live demo: Hermes first run — must be rehearsed, 15-minute max |
| 13:00 | Module 4 | Solo exercise first 20 minutes, then table share |
| 14:00 | Module 4 | Debrief: collect candidate tasks that will become Day 3 capstone |

### Day 2 Guide Structure

Modules 5-6. Key facilitation moments:

| Time | Module | Facilitator Action |
|------|--------|-------------------|
| 9:00 | Module 5a | Track selection: participants declare track (Helm vs CI/CD) |
| 9:15 | Module 5a | Step 0 (gap analysis) must complete before AI — enforce this |
| 11:00 | Module 5b | GSD workflow: live demo of /gsd:new-project first |
| 13:00 | Module 6 | Track selection: Terraform vs K8s |
| 14:00 | Module 6 | Common stall points: Terraform plan errors, ArgoCD sync failures |

### Day 3 Guide Structure

Modules 7-14. Key facilitation moments:

| Time | Module | Facilitator Action |
|------|--------|-------------------|
| 9:00 | Module 7 | Skill authoring: pairs review each other's SKILL.md decision trees |
| 10:30 | Module 8 | Tool safety: demonstrate a blocked command being rejected live |
| 13:00 | Module 9 | Patterns discussion: class vote on which pattern fits their Module 4 candidate |
| 14:00 | Module 10 | Track A/B/C split: largest group gets most facilitation time |
| 16:00 | Module 14 | Presentations: 5 min each, feedback structured around rubric |

---

## Udemy Section Outline

Recommended mapping from workshop modules to Udemy structure:

| Udemy Section | Workshop Module | Content Types |
|--------------|-----------------|---------------|
| Section 1: AI Foundations for Operations | Module 1 | Video intro + lab walkthrough + reading + quiz |
| Section 2: Platform AI — Know What You Already Have | Module 2 | Reading + lab walkthrough + quiz |
| Section 3: From Platform AI to Custom Agents | Module 3 | Demo video + reading + quiz |
| Section 4: Impact Assessment — Where to Start | Module 4 | Exercise template + reading + quiz |
| Section 5: Structured AI Coding | Module 5a | Lab walkthrough (2 tracks) + reading + quiz |
| Section 6: AI Workflows and Context Engineering | Module 5b | Lab walkthrough + reading + quiz |
| Section 7: AI-Assisted Infrastructure as Code | Module 6 | Lab walkthrough (2 tracks) + reading + quiz |
| Section 8: Teaching Agents Runbooks (Skills) | Module 7 | Reading + lab walkthrough + quiz |
| Section 9: Wiring Tools to Agents | Module 8 | Reading + lab walkthrough + quiz |
| Section 10: Agent Design Patterns | Module 9 | Reading + quiz |
| Section 11: Build Your Domain Agent | Module 10 | Lab walkthrough (3 tracks) |
| Section 12: Fleet Orchestration | Module 11 | Reading + lab walkthrough + quiz |
| Section 13: Triggers, Scheduling, and Interfaces | Module 12 | Reading + lab walkthrough + quiz |
| Section 14: Governance — Enterprise-Safe Agents | Module 13 | Reading + lab walkthrough + quiz |
| Section 15: Capstone — Your 30-Day Plan | Module 14 | Templates + rubric |

**Note:** Video production (V2-01 in REQUIREMENTS.md v2) is out of scope for Phase 4. The Udemy outline is a structural document for future video production planning.

---

## Environment Availability

Step 2.6: SKIPPED — Phase 4 is content authoring only (MDX files). No external services, databases, or CLIs are required for content creation. The Docusaurus build can be verified with `npm run build` in `course-site/`, but this is not a blocker for content authoring.

---

## Code Examples

### _category_.json for New Module Root

```json
{
  "label": "Module 7: Agent Skills",
  "position": 8,
  "collapsed": false,
  "link": {
    "type": "doc",
    "id": "module-07-agent-skills/module-07-readme"
  }
}
```

### README.mdx Frontmatter Template

```mdx
---
id: module-07-readme
title: "Module 7: Agent Skills — Teaching Agents Runbooks"
sidebar_label: "Overview"
sidebar_position: 0
---

# Module 7: Agent Skills — Teaching Agents Runbooks

**Duration:** 90 minutes
**Day:** Day 3, Session 1
```

### Updated README Table (replacing "coming soon")

Before:
```
| Reading | LLM Fundamentals for Operations (coming soon) | 20 min |
| Quiz | Module 1 Assessment (coming soon) | 10 min |
```

After:
```
| Reading | [LLM Fundamentals for Operations](./reading/module-01-concepts) | 20 min |
| Reading | [Reference: Context Engineering Vocabulary](./reading/module-01-reference) | 10 min |
| Quiz | [Module 1 Assessment](./quiz/module-01-quiz) | 10 min |
```

### Exploratory PROJECTS.mdx for a Hermes-Lab Module

```mdx
---
id: module-07-exploratory
title: "Exploratory: Agent Skills Projects"
sidebar_label: "Exploratory Projects"
sidebar_position: 1
description: "Stretch projects for participants who want to build additional domain skills"
---

# Exploratory: Agent Skills Projects

These are stretch projects for participants who finish the main Module 7 lab early
or want to apply SKILL.md authoring to their own operational domain.

---

## Project 1: Cross-Domain SKILL.md

**Estimated time:** 30 minutes
**Extends:** Any Module 7 track
**Prerequisites:** Module 7 lab complete, one SKILL.md created

### What You Will Build

Write a second SKILL.md that crosses domains...
```

---

## Open Questions

1. **Module 11 solo fallback — reference agents availability**
   - What we know: STATE.md flags this as a confirmed pre-condition: "Module 11 solo fallback requires three pre-built reference agents from hermes-agent repo"
   - What's unclear: Whether the Hermes repo currently has deployable reference agent profiles for DB health, FinOps, and K8s health agents (the three Module 10 tracks)
   - Recommendation: At the start of Plan 04-02 execution, check `hermes-agent/` for reference agent profiles. If absent, write Module 11's solo fallback as "build all three agents sequentially, then combine" rather than "use the pre-built reference implementations."

2. **Module 5b "prompt engineering" vocabulary — strict vs. contrast-allowed**
   - What we know: Three occurrences in Module 5b use "prompt engineering" as a contrast term, not a positive term. CONTENT-06 says "zero instances after Module 1."
   - What's unclear: Whether "Module 1" means "the Module 1 reading files" or "the Module 1 era of the course" (which could include Module 5b contrast callbacks).
   - Recommendation: Planner should decide: either flag Module 5b for revision in Plan 04-03, or document that contrast references in Modules 2-5 are intentional educational scaffolding.

3. **Instructor guide delivery location — in vs. outside Docusaurus**
   - What we know: D-57 says either `instructor/` in Docusaurus or `_instructor/` clearly marked. Docusaurus `autogenerated` sidebar picks up all directories in `docs/`.
   - What's unclear: Whether `_` prefix in Docusaurus 3.x reliably excludes directories from the sidebar.
   - Recommendation: Safest pattern is to place instructor guides outside `docs/` entirely, at project root `instructor/`. They're trainer-facing documents, not participant content.

---

## Sources

### Primary (HIGH confidence)
- Direct file inspection of `/Users/gshah/work/agentic/devops/course/course-site/docs/` — all existing module structures verified
- `HANDOFF.md` in this repo — authoritative concept checklist for Layers 1-5
- `.planning/REQUIREMENTS.md` — full requirements list with traceability
- `.planning/phases/04-remaining-content/04-CONTEXT.md` — locked decisions D-47 through D-62
- `.planning/STATE.md` — accumulated decisions and blockers including Module 11 pre-condition
- `.planning/research/FEATURES.md` in hermes-agent repo — verified feature landscape for Modules 7-13

### Secondary (MEDIUM confidence)
- `hermes-agent/.planning/codebase/ARCHITECTURE.md` — Hermes system structure confirms what Labs 7-13 use
- `hermes-agent/cli-config.yaml.example` — confirms Hermes profile configuration format for Module 8 reference
- `hermes-agent/optional-skills/devops/cli/SKILL.md` — verified SKILL.md format for Module 7 reference

### Tertiary (LOW confidence — training knowledge)
- Udemy course structure best practices — section count and naming conventions based on top-selling technical courses

---

## Metadata

**Confidence breakdown:**
- Existing content gaps: HIGH — verified by direct filesystem inspection
- File/frontmatter patterns: HIGH — extracted from six existing complete modules
- HANDOFF.md concept coverage: HIGH — direct read of authoritative source
- Module 9/14 content spec: HIGH — derived from locked decisions D-50 through D-55 plus FEATURES.md
- Instructor guide format: MEDIUM — based on common technical workshop facilitation patterns
- Udemy section structure: MEDIUM — general industry knowledge for course structure

**Research date:** 2026-04-04
**Valid until:** Indefinite — this is content research, not library/API research. Patterns won't change unless project decisions change.
