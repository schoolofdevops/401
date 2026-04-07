# Phase 5: Module Consolidation - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Restructure Modules 5 and 6 so participants experience Superpowers workflows (brainstorm, TDD, verification, debugging, code review) applied directly to IaC domains. Old Module 5a becomes new Module 5 (Superpowers for IaC). Old Module 5b becomes new Module 6 (AI Workflow Tools). Old Module 6 (AI-Assisted IaC) is absorbed into new Module 5 as project context.

</domain>

<decisions>
## Implementation Decisions

### Lab Track Structure
- **D-01:** 2 tracks in new Module 5: Track A (K8s: Helm chart for reference app) and Track B (Cloud IaC: Terraform EC2+CloudWatch+SNS module)
- **D-02:** Single 90-minute lab per track — continuous walkthrough of all Superpowers applied to the project
- **D-03:** ArgoCD and CI/CD pipeline content from old modules absorbed as supplementary reading or exploratory, not primary lab tracks

### Superpowers Depth
- **D-04:** Full Superpowers cycle in the lab: brainstorm → TDD (failing test first) → implement → debug (using AI generation errors, not planted failures) → verify + code review
- **D-05:** Each Superpowers phase gets 15-20 minutes within the 90-minute lab
- **D-06:** AI generation errors serve as the debugging exercise — natural and authentic rather than artificially planted bugs

### Content Migration
- **D-07:** Module 6 (was 5b: AI Workflow Tools) keeps existing reading/quiz content as-is — only rename and update module numbering
- **D-08:** Module 5 (Superpowers for IaC) gets completely new reading and quiz content based on the new lab
- **D-09:** Old Module 5a and old Module 6 reading/quiz content used as reference material only, not directly migrated

### Module 5 IaC Project
- **D-10:** No starter code in Module 5 labs — Superpowers workflows generate the IaC from scratch. The "starter" is the context (CLAUDE.md + requirements), not pre-written code. This IS the point of Superpowers.
- **D-11:** Track A builds a production Helm chart for the existing reference app (api-gateway, catalog, worker) from zero. TDD validates chart structure, then deploys to KIND.
- **D-12:** Track B builds a Terraform module (EC2 + CloudWatch + SNS) from zero using mock_provider for TDD. Free tier compatible.
- **D-13:** Solution files remain as reference for comparison — participants compare AI-generated output against solutions

### Claude's Discretion
- Exact TDD framework/approach for validating Helm chart structure (helm lint, kubeval, custom assertions)
- Exact TDD approach for Terraform (terraform test with mock_provider, tflint, custom validation)
- Reading material structure and quiz question design
- How to organize exploratory projects for the restructured module
- Sidebar positions and _category_.json configuration

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Superpowers Workflow Definitions
- `~/.claude/superpowers/tdd.md` — TDD workflow: RED/GREEN/REFACTOR cycle, when to skip
- `~/.claude/superpowers/debugging.md` — Systematic debugging: phases, 3-fix rule, root cause approach
- `~/.claude/superpowers/code-review.md` — Code review workflow: dispatch reviewer, handle feedback
- `~/.claude/superpowers/verification.md` — Verification before completion: evidence before assertions

### Existing Module Content (reference for migration)
- `course-site/docs/module-05a-structured-coding/` — Current 5a: README, 2 lab tracks (Helm/CI/CD), reading, quiz, exploratory
- `course-site/docs/module-05b-ai-workflows/` — Current 5b: README, composite lab (GSD), reading, quiz, exploratory (Superpowers projects)
- `course-site/docs/module-06-ai-iac/` — Current Module 6: README, 2 lab tracks (Terraform/ArgoCD), starter/solution, reading, quiz

### Reference App (lab target)
- `reference-app/` — Rust microservices (api-gateway, catalog, worker) + Svelte dashboard, deployable on KIND
- `reference-app/helm/` — Existing Helm chart for the reference app (baseline for Track A)

### Course Structure
- `CLAUDE.md` — Course conventions, module structure, constraints, tool split

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Module 5b content**: Reading (concepts.mdx, reference.mdx) and quiz (QUIZ.mdx) — reusable as-is for new Module 6 with minimal edits (rename, update cross-references)
- **Module 5b exploratory**: Already has Superpowers TDD/debug/review projects — good starting point but needs elevation from exploratory to primary lab content
- **Old Module 6 starter/solution**: Terraform and ArgoCD files exist in course-site/docs/module-06-ai-iac/lab/starter/ and solution/ — Track B can reference Terraform solution for comparison
- **Docusaurus sidebar**: Auto-generated from _category_.json — renaming directories and updating position values is sufficient for restructuring

### Established Patterns
- **Lab track pattern**: Track A/B with "Choose Your Track" section in README — both module 5a and old 6 use this pattern
- **Lab structure**: Step-by-step with numbered phases, estimated times, expected output blocks, verification checkpoints
- **Context engineering 4-layer model**: Task/Role/System/Procedure — established in 5a, reusable in new Module 5 as Superpowers context prep

### Integration Points
- **Sidebar ordering**: Modules 7-14 have sidebar_position values that must not shift — only 5a, 5b, and 6 directories change
- **Cross-references**: Other modules may link to 5a/5b/6 content — need to update or redirect
- **Docusaurus config**: No changes needed — auto-sidebar discovers new directory names

</code_context>

<specifics>
## Specific Ideas

- No starter code — the Superpowers workflow generates everything from scratch. The "starter" is structured context (CLAUDE.md with system state, constraints, vocabulary), not pre-written code.
- AI generation errors serve as natural debugging material — more authentic than planted bugs, and different every time
- Solution files kept for comparison — participant's AI-generated output vs reference solution, with diff analysis as a learning moment
- The Superpowers cycle mirrors real professional workflow: you don't start with templates, you start with context and let the tooling generate

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-module-consolidation*
*Context gathered: 2026-04-07*
