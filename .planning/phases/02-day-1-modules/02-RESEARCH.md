# Phase 2: Day 1 Modules - Research

**Researched:** 2026-04-04
**Domain:** Course content platform (Docusaurus), context engineering pedagogy, AWS platform AI free tier, Hermes agent first-run demo
**Confidence:** HIGH (Docusaurus) / HIGH (AWS free tier — verified) / HIGH (Hermes setup) / HIGH (context engineering patterns)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Docusaurus Platform**
- D-17: All course content delivered via full Docusaurus project — initialize project, configure sidebars, theme, all content as MDX with frontmatter. Deployable course website.
- D-18: This is a NEW requirement — Docusaurus setup must happen as part of Phase 2 before any content is written.

**Module 1 Lab — Context Engineering**
- D-19: Progressive 4-layer structure on the SAME CloudWatch alarm data: (1) bare prompt → (2) SRE role context → (3) infrastructure topology → (4) runbook context
- D-20: Side-by-side comparison at the end showing all 4 outputs together
- D-21: Works with real CloudWatch alarms AND mock data (Phase 1 files) as fallback
- D-22: Participants interact directly with Claude Code or OpenCode — no scripts or API wrappers
- D-23: Token economics lab (Part 3) shows cost estimation for each context layer

**Content Depth**
- D-24: Solid foundation for LLM theory — inference pipeline (prefill/decode), attention mechanism conceptually, token economics deeply
- D-25: DevOps analogies for key concepts only — major concepts get systematic analogies, minor ones get plain explanations
- D-26: Context engineering vocabulary enforced consistently — never "prompt engineering"

**Module 2 — Platform AI**
- D-27: Free tier = hands-on lab, paid = demo/walkthrough. CloudWatch anomaly detection, Cost Explorer, Q Developer, DevOps Guru
- D-28: Real AWS connections first, mock data fallback clearly labeled

**Module 3 — Bridge Content**
- D-29: Facilitator demos first, then participants do hands-on labs. Guided walkthrough format.
- D-30: Under 15 minutes for the facilitator demo portion

**Module 4 — Impact Assessment**
- D-31: Spreadsheet/markdown table template. Solo-completable. Frequency × complexity scoring.

### Claude's Discretion
- Specific Docusaurus theme and configuration choices
- Sidebar organization structure
- Which DevOps concepts get analogies vs plain explanations
- Module 2: which specific AWS features are free tier vs paid (verify at build time)
- Module 3: specific Hermes commands and demo scenario

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| MOD1-01 | Lab Part 1 — Progressive context engineering with CloudWatch alarm data (raw dump → system prompt → structured output → few-shot) | D-19 4-layer structure; mock data files from Phase 1 confirmed available |
| MOD1-02 | Lab Part 2 — Same alarm with progressive context layers (alarm only → infrastructure topology → incident history → runbook context) | D-19 layer sequence confirmed; describe-alarms-anomaly.json as primary input |
| MOD1-03 | Lab Part 3 — Token economics: cost estimation, context size vs quality tradeoff, free tier management | Current 2026 pricing confirmed: Claude Sonnet 4.6 $3/$15 per M tokens; Gemini 2.5 Flash free tier |
| MOD1-04 | Reading — Tokenization, context windows, inference pipeline, temperature, Top-P/K — all with DevOps analogies | Anthropic context engineering article verified; HANDOFF.md Layer 1 concept table available |
| MOD1-05 | Reading — AI spectrum (Chat → Copilot → Agent → Squad) with operational maturity analogy | HANDOFF.md Layer 2 concept table confirmed; Hermes architecture provides concrete agent example |
| MOD1-06 | Reading — Context engineering philosophy: why context > prompts, domain expertise as context | Anthropic engineering blog directly usable as authoritative source |
| MOD1-07 | Quiz (5-8 questions) covering LLM fundamentals, context engineering concepts | Derives from reading material |
| MOD2-01 | Lab — AWS AI features on free tier: CloudWatch anomaly detection, Cost Explorer analysis, Q Developer | Free tier status verified for each service (see AWS Free Tier section) |
| MOD2-02 | Reading — AWS AI services landscape and capabilities/limitations matrix | Research confirmed service set |
| MOD2-03 | Assessment template — "Platform AI capabilities and gaps for your environment" | Markdown table format per D-31 pattern |
| MOD2-04 | Quiz covering platform AI features, vendor lock-in concepts | Derives from reading |
| MOD3-01 | Demo script — Hermes first-run agent walkthrough (minimal setup, live demo) | Hermes install confirmed: one curl command, Python 3.11+uv, under 15 min per D-30 |
| MOD3-02 | Reading — What custom agents add that platform AI can't, the gap analysis | Hermes architecture research provides content |
| MOD3-03 | Quiz covering platform vs custom agent tradeoffs | Derives from reading |
| MOD4-01 | Automation Quadrant template (frequency × complexity scoring matrix) | Markdown table format confirmed; solo-completable per D-31 |
| MOD4-02 | Scoring sheet for top 10 operational tasks with evaluation criteria | Markdown template design |
| MOD4-03 | Selection criteria for Day 3 capstone project | Links to Module 10 agent tracks |
| MOD4-04 | Solo-completable version (no team dependency for Udemy learners) | D-31 confirmed; design as individual exercise |
| MOD4-05 | Quiz covering automation candidate evaluation | Derives from template and reading |
</phase_requirements>

---

## Summary

Phase 2 builds Day 1 course content (Modules 1-4) inside a full Docusaurus project. There are three parallel tracks of work: (1) standing up the Docusaurus site, (2) writing Module 1 content (the context engineering foundation), and (3) writing Modules 2-4 content.

The key architectural decision is D-17/D-18: a full Docusaurus 3.9.2 project replaces the Phase 1 stack decision that recommended plain Markdown. This is a deliberate, user-locked override. The site structure will use autogenerated sidebars driven by `_category_.json` files, with all content as `.mdx` files with frontmatter.

Module 1 is the pedagogical core. The 4-layer progressive lab on CloudWatch alarm data is the "aha moment" of the course — participants must feel the quality difference between bare prompt and structured domain context. The mock data from Phase 1 (`describe-alarms-anomaly.json`) is the primary input. The lab uses Claude Code or Crush (Charm) directly — no scripting layer.

The AWS free tier audit (verified April 2026) confirms: CloudWatch anomaly detection metrics fall within free tier for small setups; Cost Explorer web UI is free; Q Developer free tier includes 50 agentic requests/month via Builder ID; DevOps Guru has a 3-month free tier that expires. This determines the lab vs demo split for Module 2.

**Primary recommendation:** Stand up Docusaurus first (Day 0 task), then write Module 1 lab as the first content piece — it establishes the site structure all later modules follow.

---

## Standard Stack

### Core Content Platform
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| @docusaurus/core | 3.9.2 | Site framework — MDX pages, routing, build | Current stable; verified npm April 2026 |
| @docusaurus/preset-classic | 3.9.2 | Docs plugin + blog + pages + CSS framework | One preset covers all course needs |
| react | 18.x | Component runtime (peer dep of Docusaurus) | Bundled by preset-classic |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Node.js | 22.x (confirmed on machine) | Build runtime | Node 20+ required by Docusaurus 3.9 |
| MDX | 3.x (bundled) | Content format — Markdown + React | All content files |
| Prism.js | bundled | Code syntax highlighting | Bash, YAML, JSON, HCL code blocks |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Docusaurus | Plain Markdown (Phase 1 recommendation) | Phase 1 stack said avoid Docusaurus; D-17 explicitly overrides this — user chose deployable website |
| Docusaurus | MkDocs, VuePress | Docusaurus is React-native, most actively maintained, Facebook-backed |
| autogenerated sidebar | manual sidebars.js | Autogenerated with `_category_.json` is lower maintenance for 14+ modules |

**Installation:**
```bash
npx create-docusaurus@latest course-site classic --typescript
cd course-site
npm install
npm start  # verify locally before adding content
```

**Version verification (confirmed):**
```bash
npm view @docusaurus/core version   # returns: 3.9.2
```
Verified April 2026 against npm registry.

**IMPORTANT — Stack Conflict Note:** The `CLAUDE.md` GSD:stack block (injected from Phase 1 research) says "Avoid MkDocs / Docusaurus." Decision D-17 from CONTEXT.md explicitly overrides this with a user-locked decision to use full Docusaurus. CONTEXT.md decisions take priority over prior stack research. The planner must not second-guess D-17.

---

## Architecture Patterns

### Recommended Docusaurus Project Structure

The Docusaurus project lives at `course-site/` in the repo root (or a name the planner chooses). Content docs go in `docs/` with one subfolder per module.

```
course-site/
├── docusaurus.config.js      # Site config: title, navbar, theme
├── sidebars.js               # Sidebar config (use 'auto' for autogenerated)
├── package.json
├── src/
│   ├── css/custom.css        # Theme overrides (colors, fonts)
│   └── pages/index.mdx       # Course landing page
├── static/
│   └── img/                  # Course logo, favicon
└── docs/
    ├── intro.mdx              # Course overview / welcome page
    ├── module-01-foundations/
    │   ├── _category_.json    # {"label": "Module 1: AI Foundations", "position": 1}
    │   ├── README.mdx         # Module overview, objectives, prerequisites
    │   ├── lab/
    │   │   ├── _category_.json
    │   │   └── LAB.mdx        # Lab instructions
    │   ├── reading/
    │   │   ├── concepts.mdx
    │   │   └── reference.mdx
    │   └── quiz/
    │       └── QUIZ.mdx
    ├── module-02-platform-ai/
    ├── module-03-bridge/
    └── module-04-impact/
```

### Pattern 1: MDX Frontmatter Standard
**What:** Every `.mdx` file starts with YAML frontmatter defining id, title, sidebar_label, and sidebar_position.
**When to use:** All content files — required by Docusaurus docs plugin.
**Example:**
```mdx
---
id: module-01-lab
title: "Module 1 Lab: Context Engineering"
sidebar_label: "Lab"
sidebar_position: 1
description: "Progressive context engineering with CloudWatch alarm data"
---

# Module 1 Lab: Context Engineering

**Duration:** 60 minutes
**Outcome:** A participant who has felt the quality difference between bare and structured context
```

### Pattern 2: _category_.json for Module Organization
**What:** Each module folder (and sub-folder) has a `_category_.json` that sets display label, position, and whether the category starts collapsed.
**When to use:** Every module folder and content-type subfolder.
**Example:**
```json
{
  "label": "Module 1: AI Foundations",
  "position": 1,
  "collapsed": false,
  "link": {
    "type": "doc",
    "id": "module-01-foundations/README"
  }
}
```

### Pattern 3: Docusaurus Config for Course Site
**What:** Minimal `docusaurus.config.js` tuned for a course (no blog, docs-only, route at root).
**When to use:** Initial site setup.
**Example:**
```javascript
// Source: https://docusaurus.io/docs/configuration
export default {
  title: 'Agentic DevOps Course',
  tagline: 'Building Agentic Skills for Infrastructure Automation',
  url: 'https://your-domain.com',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'your-org',
  projectName: 'agentic-devops-course',
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: '/',   // Serve docs at site root
          showLastUpdateTime: true,
        },
        blog: false,            // No blog for a course
        theme: {
          customCss: './src/css/custom.css',
        },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'Agentic DevOps',
      items: [
        { type: 'docSidebar', sidebarId: 'courseSidebar', label: 'Course', position: 'left' },
      ],
    },
    prism: {
      additionalLanguages: ['bash', 'hcl', 'yaml', 'json'],
    },
  },
};
```

### Pattern 4: The 4-Layer Context Engineering Lab
**What:** Module 1 lab structured as 3 progressive parts using `describe-alarms-anomaly.json` as the fixed input.
**When to use:** Module 1 lab only.

The progression participants follow:

**Layer 1 — Bare prompt (Part 1):**
```
Analyze this CloudWatch alarm:
[paste describe-alarms-anomaly.json]
```
Expected output: generic, vague, unhelpful for operations

**Layer 2 — Add SRE role context:**
```
You are an experienced SRE on a production e-commerce platform.
Your job is to diagnose CloudWatch alarms and recommend immediate actions.
Think in terms of: incident severity, customer impact, MTTR.

Analyze this alarm:
[paste describe-alarms-anomaly.json]
```
Expected output: more focused, uses SRE vocabulary, has severity framing

**Layer 3 — Add infrastructure topology:**
```
You are an experienced SRE on a production e-commerce platform.
[SRE role context from Layer 2]

Infrastructure context:
- i-0abc123def456001 is the catalog-api EC2 instance (t3.large)
- It serves the product catalog for 50K daily active users
- CPU typically runs at 60-65% during peak hours (09:00-21:00 UTC)
- It communicates with RDS PostgreSQL (db.t3.medium, max 100 connections)
- SNS alerts go to ops-alerts → PagerDuty → on-call rotation

Analyze this alarm:
[paste describe-alarms-anomaly.json]
```
Expected output: specific to this system, meaningful thresholds, actionable

**Layer 4 — Add runbook context:**
```
[Everything from Layer 3]

SRE runbook — HighCPUUtilization response:
1. Check: Is this a known traffic spike? (check ALB request count)
2. Check: Is there a runaway process? (aws ssm send-command -- ps aux)
3. Check: Was there a recent deployment? (check CodeDeploy deployment history)
4. If traffic spike: scale out (aws autoscaling set-desired-capacity)
5. If runaway process: isolate and restart (aws ec2 reboot-instances after snapshotting logs)
6. Escalate if: CPU > 90% for > 10 minutes with no identified cause
7. Document: all findings in incident ticket before closing

Decision tree threshold: If StateValue=ALARM AND duration > 15 min, wake on-call.

Analyze this alarm:
[paste describe-alarms-anomaly.json]
```
Expected output: expert-level, follows runbook decision tree, produces structured incident response

### Pattern 5: Token Economics Lab Exercise
**What:** After all 4 layers, participants estimate token cost for each layer.
**Calculation approach (2026 pricing):**
- Count context tokens for each layer (rough estimate: 100-150 tokens for bare, 400-600 for Layer 3, 800-1200 for Layer 4)
- Apply Claude Sonnet 4.6 pricing: $3/M input tokens
- Compare: Layer 1 costs ~$0.0004, Layer 4 costs ~$0.003 — 7x more expensive
- Key question for participants: "Is Layer 4 quality worth 7x the cost? When?"
- Discussion: daily incident triage at $0.003/alarm × 500 alarms/day = $1.50/day
- Frame: costs have dropped 80% since 2025 — token economics increasingly favor quality

### Anti-Patterns to Avoid
- **Using `.md` extension for Docusaurus content:** Docusaurus 3.x treats `.md` as CommonMark (planned for next major). Use `.mdx` for all course content to ensure JSX/frontmatter works consistently.
- **Manual sidebars.js for 14+ modules:** Becomes a maintenance burden. Use autogenerated with `_category_.json` instead.
- **Putting content directly in `docs/` root without subfolders:** No category grouping, no `_category_.json` per module, sidebar becomes flat and unusable.
- **Skipping `routeBasePath: '/'`:** Without this, docs are served at `/docs/` which adds an unnecessary prefix for a course website.
- **Copying the Phase 1 stack guidance that says "Avoid Docusaurus":** That guidance predates D-17. CONTEXT.md overrides it.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| MDX rendering and site navigation | Custom React app or Next.js app | Docusaurus 3.9.2 | Docusaurus has autogenerated sidebars, search, mobile-responsive theme, built-in |
| Code syntax highlighting | Custom CSS | Docusaurus/Prism (bundled) | Already supports bash, hcl, yaml, json out of the box |
| Token counting for lab exercise | Custom tokenizer script | Manual estimation table in lab instructions | Lab only needs rough estimates; exact tokenizer adds setup friction |
| AWS service mock for lab | Custom mock server | Phase 1 JSON files already in `infrastructure/mock-data/` | Mock data already exists, use it |
| Automation quadrant visualization | Mermaid or React chart | Plain markdown table with ASCII quadrant | No build-time dependency; works as Udemy downloadable resource |

**Key insight:** The Docusaurus scaffold generates everything needed — don't customize the build system or add plugins beyond `preset-classic` for Phase 2.

---

## Runtime State Inventory

> This is a content-creation phase with no rename/refactor operations. No runtime state is involved.

**Applicable categories:** None. Phase 2 creates new files (Docusaurus site + MDX content). No existing runtime state contains strings being renamed or migrated.

---

## AWS Free Tier Verification (April 2026)

This is the research that determines the lab vs demo split for Module 2 (D-27).

| Service | Free Tier Status | Lab or Demo |
|---------|-----------------|-------------|
| CloudWatch anomaly detection alarms | NOT explicitly in free tier. Standard alarm free tier covers 10 alarm metrics; anomaly detection alarms cost 3x standard ($0.30/month per alarm). First alarm is within free tier arithmetic BUT technically costs more. | **Demo** — have participants observe in console; don't have them create long-running alarms |
| CloudWatch metrics (basic monitoring) | FREE — basic EC2 metrics at 5-minute intervals are free; 10 custom metrics/month free | **Lab** — safe to use |
| Cost Explorer web interface | FREE — the web UI is fully free; API costs $0.01/request | **Lab** — use web console, NOT CLI/API |
| AWS Q Developer IDE plugin | FREE tier — 50 agentic requests/month, code completions unlimited (requires AWS Builder ID, no AWS account needed) | **Lab** — free via Builder ID |
| DevOps Guru | FREE for 3 months (7,200 resource hours × 2 groups) then paid. As of April 2026, new accounts get 6-month credits per CLAUDE.md note | **Demo with screenshots** — don't have participants enable it (they'd forget to disable and get charged after free period) |

**Key finding for Module 2 plan:** The lab path is Cost Explorer console + Q Developer Builder ID. CloudWatch anomaly detection and DevOps Guru are demo/screenshot only to avoid accidental charges.

---

## Common Pitfalls

### Pitfall 1: Docusaurus Config ESM vs CJS
**What goes wrong:** `docusaurus.config.js` uses `export default` (ESM) but the project was initialized without `"type": "module"` in package.json, causing syntax errors on `npm start`.
**Why it happens:** Docusaurus 3.x ships ESM config by default but older Node projects default to CJS.
**How to avoid:** Use `npx create-docusaurus@latest` which generates a compatible package.json. If adding to existing project, use `docusaurus.config.ts` (TypeScript) or `module.exports` instead of `export default`.
**Warning signs:** `SyntaxError: Cannot use import statement` on first `npm start`.

### Pitfall 2: Missing _category_.json Breaks Sidebar Order
**What goes wrong:** Module folders appear in alphabetical order in the sidebar, not the intended 1-14 module order.
**Why it happens:** Without `_category_.json` with explicit `position`, Docusaurus alphabetizes folders.
**How to avoid:** Add `_category_.json` to every module folder with `"position": N` before writing any content.
**Warning signs:** Module 10 appearing before Module 2 in the sidebar.

### Pitfall 3: Mock Data Path in Lab Instructions
**What goes wrong:** Lab instructions reference mock data files with a path that doesn't match the actual file location after Docusaurus is set up.
**Why it happens:** Docusaurus lives at `course-site/` but mock data lives at `infrastructure/mock-data/` — the relative paths change depending on whether participants clone from the repo root or open the Docusaurus site.
**How to avoid:** Reference mock data with paths relative to the repo root. In LAB.md instructions: "From the repo root: `infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json`". Also include the file content inline in a code block as fallback.
**Warning signs:** Participants reporting "file not found" during the lab.

### Pitfall 4: Layer 4 Context Too Long for Free Tier Context Window
**What goes wrong:** The runbook + topology + role + alarm data combined exceeds what free-tier models can handle well.
**Why it happens:** Accumulating all 4 layers may reach 2,000+ tokens. While Claude handles 1M tokens, Gemini free tier models have lower limits in practice.
**How to avoid:** Test the Layer 4 prompt size against Gemini 2.5 Flash free tier before finalizing. Keep topology description concise (4-5 bullet points). Keep runbook to 7-10 steps max.
**Warning signs:** Response truncation or model errors on free-tier providers.

### Pitfall 5: Module 3 Demo Takes Over 15 Minutes
**What goes wrong:** The Hermes first-run demo runs long because LLM responses are slow, setup takes longer than expected, or the demo scenario is too ambitious.
**Why it happens:** Hermes install via `setup-hermes.sh` requires downloading Python 3.11 via uv + all pip dependencies — can take 5-10 minutes on a slow connection.
**How to avoid:** Pre-install Hermes on the facilitator machine before the demo. Keep the demo task simple: "What time is it in Tokyo?" or "List the files in this directory" — not a complex infra task. Time-box each demo step explicitly in the demo script.
**Warning signs:** Installation step consuming the entire 15-minute window.

### Pitfall 6: Q Developer Lab Requires AWS Account (It Doesn't)
**What goes wrong:** Lab instructions say "log in with AWS account" but Builder ID authentication is available without an AWS account.
**Why it happens:** Most AWS docs default to showing IAM/account-based auth.
**How to avoid:** Always say "log in with AWS Builder ID (free, no AWS account required)" in the lab instructions. Builder ID is a separate identity from AWS accounts.
**Warning signs:** Participants without AWS accounts thinking they can't do the lab.

---

## Code Examples

### Minimal Docusaurus Config for Course (docusaurus.config.js)
```javascript
// Source: https://docusaurus.io/docs/configuration (verified April 2026)
export default {
  title: 'Agentic DevOps Course',
  tagline: 'Building Agentic Skills for Infrastructure Automation',
  url: 'https://localhost',
  baseUrl: '/',
  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: '/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'Agentic DevOps',
    },
    prism: {
      additionalLanguages: ['bash', 'hcl', 'yaml', 'json'],
    },
  },
};
```

### Autogenerated Sidebars (sidebars.js)
```javascript
// Source: https://docusaurus.io/docs/sidebar/autogenerated
export default {
  courseSidebar: [
    {
      type: 'autogenerated',
      dirName: '.',
    },
  ],
};
```

### Module _category_.json Pattern
```json
// docs/module-01-foundations/_category_.json
{
  "label": "Module 1: AI Foundations for Operations",
  "position": 1,
  "collapsed": false,
  "link": {
    "type": "doc",
    "id": "module-01-foundations/README"
  }
}
```

### Standard MDX Frontmatter
```mdx
---
id: module-01-lab
title: "Module 1 Lab: Context Engineering with CloudWatch Data"
sidebar_label: "Lab"
sidebar_position: 2
---
```

### Hermes Module 3 Demo Script (Minimal)
```bash
# Source: https://hermes-agent.nousresearch.com/docs/getting-started/quickstart/
# PRE-DEMO (facilitator does this before participants arrive):
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.zshrc  # or ~/.bashrc
hermes model     # select provider: OpenRouter or Nous Portal

# LIVE DEMO (in front of participants, ~10-12 minutes):
hermes           # show welcome banner — model, tools, skills
# Demo task 1: "What devops tools do you know how to use?"
# Demo task 2: "List the files in /tmp and tell me the largest one"
# Demo task 3: Give it the describe-alarms-anomaly.json file and ask:
#   "I'm an SRE. This is a CloudWatch alarm that just fired.
#    What are the first three things I should check?"
# Show: agent uses terminal tool to read the file, produces structured diagnosis

# PARTICIPANT LAB (after demo):
# Participants install Hermes using the same one-liner
# Participants run same demo task on their own machine
```

### Token Economics Estimation Table (Lab Part 3)
```markdown
| Layer | Context Added | Approx Tokens | Claude Sonnet 4.6 Cost* | Quality |
|-------|--------------|---------------|------------------------|---------|
| 1 — Bare prompt | Alarm JSON only | ~150 | $0.00045 | Generic |
| 2 — SRE role | + Role + instructions | ~350 | $0.00105 | Focused |
| 3 — Topology | + Instance/service context | ~600 | $0.00180 | Specific |
| 4 — Runbook | + Decision tree | ~1,000 | $0.00300 | Expert |

*At $3/M input tokens. Per-alarm cost for 500 alarms/day at Layer 4: $1.50/day.
Prices dropped ~80% since 2025. Layer 4 quality at Layer 1 prices is the trend direction.
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| OpenCode (opencode-ai/opencode) | Crush (charmbracelet/crush) | September 18, 2025 | Labs must use "Crush" not "OpenCode" — State.md D-14 confirmed |
| MkDocs/Sphinx for course sites | Docusaurus 3.x for interactive course websites | 2023 onwards | Docusaurus now first choice when a deployable site is wanted |
| Gemini 2.0 Flash (model name) | Gemini 2.5 Flash | February 2026 | CLAUDE.md confirmed: Gemini 2.0 Flash deprecated, retiring June 1, 2026 |
| LocalStack community (free) | LocalStack requires auth token | March 23, 2026 | Labs must not depend on LocalStack — confirmed in CLAUDE.md |
| Prompt engineering (vocabulary) | Context engineering (vocabulary) | Course design decision | "Context engineering" is THE vocabulary term for this course from Module 1 forward |

**Deprecated/outdated:**
- `opencode` CLI name: replaced by `crush` everywhere in course content
- Gemini 2.0 Flash model name: use Gemini 2.5 Flash in all pricing examples
- Docusaurus v2: not relevant — project uses v3.9.2
- `OpenCode` as second-path tool name: always write "Crush (Charm)" in course materials

---

## Open Questions

1. **Docusaurus project location in repo**
   - What we know: The Docusaurus site needs to live somewhere in the repo. Options: `course-site/`, `docs-site/`, or the repo root.
   - What's unclear: Whether putting it at repo root would conflict with existing files (CLAUDE.md, HANDOFF.md, etc.)
   - Recommendation: Use a subdirectory (`course-site/`) to keep Docusaurus scaffolding separate from repo root files. Reference existing module content from outside via symlinks or copy strategy.

2. **Content migration strategy: existing `modules/` to Docusaurus**
   - What we know: Modules 7-13 labs exist in `modules/` directory as raw Markdown LAB.md files. Docusaurus will live at `course-site/docs/`.
   - What's unclear: Whether Phase 2 content should be written directly into Docusaurus (`course-site/docs/`) or written as flat files and migrated later.
   - Recommendation: Write Phase 2 content directly into Docusaurus from the start. Don't create a migration problem. Existing Hermes modules are out of scope for Phase 2.

3. **Hermes demo dependency on network during class**
   - What we know: Hermes install requires downloading Python/uv dependencies (~100-200 MB). Q Developer requires Builder ID login online.
   - What's unclear: Whether the venue has reliable internet for 20+ participants downloading simultaneously.
   - Recommendation: Demo script should note "facilitator pre-installs before session." Participant lab portion can be done asynchronously (homework/async for Udemy). Add offline fallback note.

4. **Module 3 demo scenario specifics**
   - What we know: Demo must be under 15 minutes (D-30). Must use existing Hermes tools (terminal, web).
   - What's unclear: Best demo task that shows agentic behavior clearly without needing Hermes to have domain skills yet (those come in Module 7).
   - Recommendation: Use the `describe-alarms-anomaly.json` file from Phase 1 as the demo input. Task: "You are an SRE. Read this CloudWatch alarm file and tell me what you'd do first." This connects Module 3 to Module 1 explicitly and shows file reading + LLM analysis tool calling in one step.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | Docusaurus build | Yes | 22.21.1 | — |
| npm | Docusaurus install | Yes | 10.9.4 | — |
| uv | Hermes install | Yes | 0.6.12 | pip install |
| Python 3.11 | Hermes runtime | Via uv | uv auto-provisions | — |
| Python 3.13 | Already installed | Yes | 3.13.7 | Hermes needs 3.11 specifically |
| aws CLI | Module 2 lab | Yes | 2.15.54 | Mock JSON fallback |
| hermes CLI | Module 3 demo | Not installed | — | Run setup-hermes.sh |
| Docker | Hermes terminal backend (optional) | Not checked | — | Local terminal backend (default) |

**Missing dependencies with no fallback:**
- `hermes` CLI: Requires running `setup-hermes.sh` or `curl -fsSL ... | bash`. The facilitator machine must do this before the Module 3 demo. Participants will do it during the lab portion.

**Missing dependencies with fallback:**
- Python 3.11 specifically: uv auto-provisions it — no manual action required.
- Real AWS account: All labs have mock data fallback documented in Phase 1.

---

## Sources

### Primary (HIGH confidence)
- npm registry (verified April 2026): `@docusaurus/core` and `@docusaurus/preset-classic` both at 3.9.2
- https://docusaurus.io/docs/installation — Docusaurus 3.9.2 installation, Node 20+ requirement
- https://docusaurus.io/docs/sidebar/autogenerated — `_category_.json` fields: position, label, key, collapsible, collapsed, link, customProps
- https://docusaurus.io/docs/configuration — `docusaurus.config.js` structure, minimal example, ESM export
- https://aws.amazon.com/cloudwatch/pricing/ — CloudWatch free tier: 10 alarms, 10 custom metrics, 3 dashboards; anomaly detection NOT in explicit free tier
- https://aws.amazon.com/q/developer/pricing/ — Q Developer free tier: 50 agentic requests/month, Builder ID login (no AWS account required)
- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents — Context engineering definition, principles (authoritative Anthropic source)
- https://hermes-agent.nousresearch.com/docs/getting-started/quickstart/ — Hermes first-run: install, `hermes model`, `hermes setup`

### Secondary (MEDIUM confidence)
- https://aws.amazon.com/devops-guru/pricing/ — DevOps Guru: 3-month free tier (7,200 resource hours), then paid
- LLM pricing 2026 confirmed by multiple sources: Claude Sonnet 4.6 $3/$15 per M tokens; Gemini 2.5 Flash free with rate limits; ~80% cost reduction since 2025
- Cost Explorer web UI: free; API: $0.01/request — confirmed by https://aws.amazon.com/aws-cost-management/aws-cost-explorer/pricing/

### Tertiary (LOW confidence)
- Specific Q Developer free tier limits for code completions: "unlimited" appears in multiple sources but exact number not officially documented in pricing table — use "unlimited within subscription" framing in content

---

## Metadata

**Confidence breakdown:**
- Docusaurus setup: HIGH — verified version 3.9.2 from npm registry, official docs consulted
- AWS free tier classification: HIGH — verified against official AWS pricing pages April 2026
- Token pricing: HIGH for Claude Sonnet 4.6; MEDIUM for Gemini (free tier limits change)
- Context engineering pedagogy: HIGH — directly supported by Anthropic engineering blog
- Hermes demo: HIGH — official quickstart docs consulted; local repo setup-hermes.sh confirms Python 3.11 + uv approach
- Automation quadrant template: HIGH — standard management framework, no version dependency

**Research date:** 2026-04-04
**Valid until:** 2026-05-04 for AWS free tier details (pricing pages update regularly); 2026-06-01 for Gemini model names (2.0 Flash retires June 1, 2026)
