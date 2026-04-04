# Phase 2: Day 1 Modules - Context

**Gathered:** 2026-04-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Build all Day 1 module content (Modules 1-4) within a Docusaurus site: labs, reading materials, quizzes, and supporting assets. Module 1 (context engineering) is the critical foundation. Module 2 (platform AI), Module 3 (bridge to custom agents), and Module 4 (impact assessment) round out Day 1. All content formatted as MDX for Docusaurus with proper frontmatter and sidebar configuration.

</domain>

<decisions>
## Implementation Decisions

### Docusaurus Platform
- **D-17:** All course content delivered via **full Docusaurus project** — initialize project, configure sidebars, theme, all content as MDX with frontmatter. Deployable course website.
- **D-18:** This is a NEW requirement — Docusaurus setup must happen as part of Phase 2 before any content is written.

### Module 1 Lab — Context Engineering
- **D-19:** Progressive 4-layer structure on the SAME CloudWatch alarm data:
  1. Bare prompt (just the alarm JSON) → observe mediocre output
  2. Add SRE role context (system prompt) → observe improvement
  3. Add infrastructure topology context → observe significant improvement
  4. Add runbook context (decision tree, what to check) → observe expert-level output
- **D-20:** Side-by-side comparison at the end showing all 4 outputs together
- **D-21:** Works with **real CloudWatch alarms** (participants who have AWS accounts) AND mock data (Phase 1 files) as fallback. Instructions say "use your own alarm if you have one."
- **D-22:** Participants interact directly with **Claude Code or OpenCode** — paste context + alarm data, observe outputs. No scripts or API wrappers.
- **D-23:** Token economics lab (Part 3) shows cost estimation for each context layer — demonstrates the cost vs quality tradeoff practically.

### Content Depth
- **D-24:** **Solid foundation** for LLM theory — cover inference pipeline (prefill/decode), attention mechanism conceptually, token economics deeply. DevOps practitioners appreciate knowing HOW things work under the hood.
- **D-25:** DevOps analogies for **key concepts only** — major concepts get systematic analogies, minor ones get plain explanations. Avoid forced analogies that confuse more than help.
- **D-26:** Context engineering positioned as THE core skill throughout — not "prompt engineering." Use "context engineering" vocabulary consistently from Module 1 forward.

### Module 2 — Platform AI
- **D-27:** **Free tier = hands-on lab, paid = demo/walkthrough.** Cover CloudWatch anomaly detection, Cost Explorer, Q Developer, DevOps Guru — include whichever is free tier as lab exercise, show paid features as demo with screenshots.
- **D-28:** Real AWS connections first for participants with accounts. Mock data fallback clearly labeled for those without.

### Module 3 — Bridge Content
- **D-29:** **Facilitator demos first, then participants do hands-on labs.** Guided walkthrough format — install Hermes, run first agent, observe behavior. Participants learn by doing, not watching.
- **D-30:** Under 15 minutes for the facilitator demo portion. Participant lab portion separate.

### Module 4 — Impact Assessment
- **D-31:** **Spreadsheet/markdown table template** for scoring. Participants fill in their own operational tasks, score on frequency × complexity, plot on automation quadrant. Solo-completable (no team dependency for Udemy).

### Claude's Discretion
- Specific Docusaurus theme and configuration choices
- Sidebar organization structure
- Which DevOps concepts get analogies vs plain explanations
- Module 2: which specific AWS features are free tier vs paid (verify at build time)
- Module 3: specific Hermes commands and demo scenario

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 1 Outputs (consumed by this phase)
- `infrastructure/mock-data/cloudwatch/describe-alarms-clean.json` — Module 1 lab input (clean alarm scenario)
- `infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json` — Module 1 lab input (anomaly scenario)
- `infrastructure/mock-data/cloudwatch/describe-alarm-history.json` — Module 1 lab input (alarm history)
- `infrastructure/mock-data/cost-explorer/normal-spend.json` — Module 2 lab input
- `infrastructure/mock-data/cost-explorer/anomaly-spike.json` — Module 2 lab input
- `infrastructure/mock-data/ec2/describe-instances.json` — Module 2 lab input
- `setup/SETUP.md` — Participant environment setup (Claude Code + OpenCode paths)
- `setup/llm-access.md` — LLM provider configuration reference

### Course Context
- `.planning/PROJECT.md` — Project vision, constraints, core value
- `.planning/REQUIREMENTS.md` — MOD1-01 through MOD4-05 requirements
- `.planning/ROADMAP.md` — Phase 2 success criteria
- `CLAUDE.md` — Module structure template, tool split, constraints
- `HANDOFF.md` — Layer 1 and Layer 2 concept tables (reading material checklist)

### Hermes Reference (Module 3)
- Hermes codebase at `/Users/gshah/work/agentic/devops/hermes-agent/` — for Module 3 demo script

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `infrastructure/mock-data/cloudwatch/` — 3 CloudWatch alarm JSON files ready for Module 1 lab
- `infrastructure/mock-data/cost-explorer/` — 2 Cost Explorer JSON files ready for Module 2 lab
- `infrastructure/mock-data/ec2/describe-instances.json` — EC2 data for Module 2
- `infrastructure/wrappers/mock-aws` — Mock AWS CLI wrapper (can be used in labs)
- `setup/llm-access.md` — Provider setup reference (link from lab instructions)

### Established Patterns
- Phase 1 used standard directory structure from CLAUDE.md for reference-app
- Mock data files have `_metadata` blocks with source/date/scenario info
- Two equal paths (Claude Code + OpenCode) — all content must document both

### Integration Points
- Module 1 lab uses CloudWatch alarm data from `infrastructure/mock-data/cloudwatch/`
- Module 2 lab uses Cost Explorer + EC2 data from `infrastructure/mock-data/`
- Module 3 connects to Hermes repo at `/Users/gshah/work/agentic/devops/hermes-agent/`
- All content feeds into the Docusaurus site structure

</code_context>

<specifics>
## Specific Ideas

- Module 1 lab must make participants FEEL the difference — the progressive layers should produce visibly better output at each stage
- The HANDOFF.md has detailed Layer 1 and Layer 2 concept tables that should be used as the reading material checklist
- "Context engineering" vocabulary must be enforced from Module 1 forward — no "prompt engineering" language
- All content must be Docusaurus MDX with proper frontmatter

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 02-day-1-modules*
*Context gathered: 2026-04-04*
