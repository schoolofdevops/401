# Project Research Summary

**Project:** Agentic DevOps: Building Agentic Skills for Infrastructure Automation
**Domain:** Technical training course — dual-format live workshop + Udemy self-paced
**Researched:** 2026-04-04
**Confidence:** HIGH

## Executive Summary

This is a professional technical training course targeting experienced DevOps practitioners who have zero AI/agentic systems background. The content spans a 3-day live workshop and a parallel Udemy self-paced distribution, covering the full DevOps spectrum (IaC, K8s, CI/CD, SRE, cloud) with Hermes as the primary agent framework for modules 7–13. Research confirms the right build strategy is labs-first: write LAB.md and starter/solution files before reading materials or explainers. The content format is plain Markdown in a structured Git repo — no Jupyter notebooks, no static site generator, no build step. The participant toolchain is Claude Code as primary agent (Claude Pro subscription), with Crush as the multi-provider fallback.

The course's single most important differentiator is context engineering positioned as a first-class operational skill, not a rebranding of prompt engineering. No competing Udemy course teaches context engineering by name, none combines DevOps domain specificity with YAML-only agent authoring, and none includes governance as a dedicated module. The progressive build chain (Module 1 CloudWatch data → Module 7 SKILL.md → Module 8 agent profile → Module 10 domain agent → Module 11 fleet) is the structural commitment that makes this course reusable post-workshop rather than disposable demo code.

The two critical risks are: (1) lab timing — every lab will take 2–3x the author's estimate in real delivery, requiring 50%-rule sizing and per-lab checkpoint artifacts; and (2) vocabulary drift — "prompt engineering" language will re-emerge in later modules if not enforced via vocabulary discipline in CLAUDE.md and a pre-publish grep audit. A secondary risk is free-tier provider fragmentation: Claude Code must be the one canonical lab path, with all others as documented alternatives with no instructor-support guarantees during workshop hours.

---

## Key Findings

### Recommended Stack

The content stack is intentionally minimal: plain Markdown for all participant-facing material, JSON fixtures for mock AWS data, Bash scripts for lab execution, YAML for K8s/Ansible/KIND configs, and HCL for Terraform labs. This stack requires no build tooling and produces files that are diff-friendly, offline-capable, and directly uploadable to Udemy as resources. The author-side toolchain adds markdownlint-cli2 in CI (hard gate) and Vale for terminology enforcement (soft advisory).

For participant tooling: Claude Code with Claude Pro subscription is the primary path — all screenshots, expected outputs, and troubleshooting are written against this path. Crush (charmbracelet/crush, successor to archived OpenCode) is the multi-provider fallback with Groq or Gemini 2.5 Flash backends. Two critical version notes: OpenCode was archived September 18, 2025 — all references must use "Crush"; LocalStack community edition EOL'd March 23, 2026 and now requires a free account for non-commercial use — treat as optional stretch, not a required lab dependency.

**Core technologies:**
- Markdown (CommonMark): all course content — native Git diff, renders on GitHub, works as Udemy downloadable
- JSON fixtures: mock AWS data (CloudWatch, Cost Explorer, RDS) — offline, reproducible, zero setup friction
- KIND v0.31+: local Kubernetes for Module 6 Track C — real cluster, zero cost, Docker-based
- Claude Code (Claude Pro): primary agent for all labs — no separate API key, agentic-first design
- Crush (charmbracelet/crush): multi-provider fallback via `/connect` — Groq (free/fast) or Gemini 2.5 Flash
- Terraform 1.7+: IaC labs including `mock_provider` for offline plan validation
- markdownlint-cli2 + GitHub Actions: CI quality gate for content PRs

### Expected Features

The course has a well-defined MVP boundary driven by the 2026-04-06 launch date. The progressive build chain is the non-negotiable structural spine — every module's deliverable feeds the next, and labs must enforce this while providing standalone fallback starters.

**Must have (table stakes — course fails without these):**
- Participant environment setup guide + verify.sh smoke test — blocks all Day 1 work if missing
- Realistic mock data set (CloudWatch, RDS Performance Insights, Cost Explorer, kubectl output) — determines whether simulated labs feel credible to DevOps engineers
- LAB.md + starter/ + solution/ for all in-scope modules (1, 2, 4, 5, 6, 9, 14) — non-negotiable per FEATURES.md MVP definition
- concepts.md + reference.md per module — ops engineers read before they execute
- QUIZ.md per module (5–8 questions) — required for Udemy quality badge algorithm
- Module 14 capstone templates and rubric — participants stall without scaffolded deliverables
- Module 4 Automation Quadrant scoring template (solo-compatible) — team exercise with a solo fallback
- Module 3 demo script — bridge module requires facilitator notes + participant observation guide
- Context engineering framing throughout all 14 modules — the core differentiator; must not appear only in Module 1 and disappear
- DevOps-first analogy system — every AI concept mapped to infrastructure vocabulary

**Should have (competitive differentiators):**
- Context engineering as the explicit named core skill — no competitor does this; separates course from 83,000-student Python-first Udemy bestsellers
- SKILL.md as a tangible artifact format participants take home — usable Monday at work regardless of agent framework
- Governance module (Module 13) as first-class content with L1–L4 maturity model — enterprise buyers require this; no competitor has it
- Tool-agnostic, framework-portable pattern vocabulary (ReAct, coordinator, human-in-the-loop)
- Three reference track implementations (Track A/B/C) deployable against participants' actual infrastructure
- Dual-variant labs with documented solo fallbacks — rare for workshop content
- Exploratory stretch projects (PROJECTS.md) per module — prevents boredom in expert audiences

**Defer (v2+):**
- Mission Control dashboard design and reference implementation — significant frontend scope
- Python extension labs — scope creep that excludes the non-Python target audience
- Additional domain tracks (security hardening agent, CI/CD health agent)
- Certification / completion badge program
- Post-course reference guide ("What to build in your first 30 days")

### Architecture Approach

The repo follows a self-contained module pattern with a shared assets foundation layer. Each `module-NN-name/` directory is independently operable (prerequisites documented, standalone starter files provided, no hard dependency on completing prior labs). Shared mock data lives in `shared-assets/mock-data/` as a single source of truth — individual labs reference by path rather than copying. Format-specific overlays (`_instructor/` for live workshop facilitation notes, `_udemy/` for Udemy section mapping and video scripts) are the only content that differs between the two delivery formats.

The critical build sequence is labs-first within each module, then reading materials extracted from lab content, then quiz questions derived from both. This prevents disconnected theory. The critical path across the full repo is: Phase 1 shared-assets/mock-data/ → Phase 2 Module 1 lab → Phase 2 Module 2 lab → Phase 3 Module 6 solution/ tracks. The cross-repo boundary (course/ → hermes-agent/) is cleanly defined: Modules 7, 8, 10–13 live in hermes-agent/course/; this repo owns Modules 1–6 plus Module 9 reading/explainer content and Module 14 templates.

**Major components:**
1. `shared-assets/mock-data/` — single-source mock JSON files consumed by Modules 1, 2, 6, and hermes-agent Module 10; realistic anomaly patterns are non-negotiable for DevOps audience credibility
2. `setup/SETUP.md + verify.sh` — the most critical single artifact; every minute of setup confusion during delivery costs 30-person cohort time
3. `module-NN-name/lab/` (LAB.md + starter/ + solution/) — the primary participant artifact per module; all other content is derived from labs
4. `module-NN-name/reading/` (concepts.md + reference.md) — learner-facing theory, derived from labs, not written before labs
5. `_instructor/` — live workshop facilitation guides, strictly separated from participant content to prevent Udemy leakage
6. `_udemy/` — section outline, video scripts, quiz learner versions (answers stripped)

### Critical Pitfalls

1. **Wrong mental model: teaching "context engineering" but delivering prompt tricks** — Lab 1 must show a side-by-side comparison (bare instruction vs. structured domain context with CloudWatch schema + vocabulary + constraints). Every lab after Module 2 must include a "what context does the agent have?" section. Never use the word "prompt" after Module 2 — enforce via CLAUDE.md vocabulary rules and pre-publish grep audit.

2. **Lab timing always 2–3x author's estimate** — Design every lab at 50% of its target slot. Every lab requires per-step time estimates and checkpoint artifacts (`solution/checkpoint-N/`) for mid-lab recovery. Never use author self-timing as the estimate — cold-test with a colleague first.

3. **Free-tier provider fragmentation collapses classroom time** — Claude Code with Claude Pro is the one canonical lab path. All screenshots, expected outputs, and troubleshooting are written against this path only. OpenCode/Crush and Google AI Studio are documented alternative paths with limited instructor support. The January 2026 Anthropic OAuth block (Claude subscriptions no longer work through third-party tools) must be documented explicitly in the setup guide.

4. **Audience mismatch: AI vocabulary without DevOps translation** — Every AI concept must have a validated DevOps-native analogy (e.g., context window = "CI job's workspace — everything the agent can see in one execution"; token = "unit of pipeline compute — you have a budget per call"). Broken analogies include "LLM is like a search engine" and "context window is like RAM." Validate each analogy with a DevOps practitioner before publishing.

5. **Simulated AWS data drifts from real AWS output format** — Every mock JSON file must include a `# Mock format: aws <command> as of YYYY-MM-DD SDK v2 response` comment with a documentation URL. Include a noisy scenario alongside the clean scenario for each track. Test one file per module against live `aws cli` output before delivery.

---

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Foundation Infrastructure
**Rationale:** The architecture research identifies a clear critical path: shared mock data and the participant setup guide are hard blockers for all other work. Nothing in modules 1–6 can be tested or delivered without these existing. Build these first, in parallel.
**Delivers:** `setup/SETUP.md`, `setup/verify.sh`, and all `shared-assets/mock-data/` files (cloudwatch-alarm.json, ec2-describe-instances.json, cost-explorer-30d.json, rds-performance-insights.json, kubectl output fixtures)
**Addresses:** Environment setup guide (P1 feature), realistic mock data set (P1 feature), free-tier provider chaos (Pitfall 3)
**Avoids:** Lab setup consuming module time (UX pitfall), mock data format drift (Pitfall 5), AWS account ID security leak (security pitfall)
**Research flag:** Standard patterns — well-documented file structure, no deeper research needed

### Phase 2: Day 1 Content (Modules 1–4)
**Rationale:** Module 1 establishes the context engineering mental model that every downstream module depends on. If the Lab 1 side-by-side comparison is wrong, the entire course's conceptual architecture is compromised. Modules 2–4 build on the Module 1 vocabulary and should be written in the same phase to enforce consistency.
**Delivers:** Modules 1, 2, 3, 4 — full lab/reading/quiz/explainer structure; Module 1 is the priority within this phase
**Addresses:** Context engineering curriculum (differentiator), DevOps analogy system (differentiator), Module 3 demo script (P1 MVP)
**Avoids:** Wrong mental model pitfall (Pitfall 1 — Module 1 lab must include side-by-side context comparison), audience mismatch (Pitfall 4), vocabulary relapse (Pitfall 8)
**Research flag:** Module 1 lab design needs careful review — the side-by-side bare-vs-structured context comparison is the most important single lab in the course; consider a dry-run test before finalizng

### Phase 3: Day 2 Content (Modules 5–6)
**Rationale:** Module 5 (Structured AI Coding with the Superpowers workflow) and Module 6 (AI-Assisted IaC with three tracks) are the technical depth anchor for the workshop. Module 6 Track A/C solution files are forward-referenced as optional starters for hermes-agent Module 10 — coordinate naming conventions with the hermes-agent repo during this phase.
**Delivers:** Modules 5 and 6 — full three-track lab structure (Track A: Terraform RDS, Track B: Ansible, Track C: Kubernetes manifests); solution files ready for cross-repo reference
**Addresses:** AI-assisted IaC labs with starter/solution per track (P1 MVP), KIND cluster config included in every lab
**Avoids:** Per-module copies of shared mock data (architecture anti-pattern 2), hard module prerequisite dependencies without starter fallbacks (architecture anti-pattern 4), Terraform provider requiring real AWS credentials for plan-only runs (integration gotcha)
**Research flag:** Module 6 tracks require cross-repo coordination with hermes-agent team — naming and structure of solution/track-a/ must match hermes-agent/course/modules/module-10/starter/track-a/

### Phase 4: Supporting Modules (9, 14) + Format Overlays
**Rationale:** Module 9 (Design Patterns) requires reading/explainer content only — no lab in this repo. Module 14 (Capstone) requires templates and rubric only. These can be built in parallel with Phases 2–3 but must exist before the first workshop dry-run. Format overlays (`_instructor/` facilitator guides, `_udemy/` section outline and quiz learner versions) are derived from all prior module content.
**Delivers:** Module 9 reading/explainer (pattern taxonomy: advisor, investigator, proposal, guardian), Module 14 capstone templates (presentation template, 30-day roadmap template, rubric), `_instructor/` day-1/2/3 facilitator guides, `_udemy/section-outline.md` and quiz learner versions
**Addresses:** Capstone templates and rubric (P1 MVP), dual-format solo completability (P2), instructor-only annotation separation (architecture pattern 4)
**Avoids:** Trainer notes leaking to Udemy participants (architecture anti-pattern 1), dual-format blindspot (Pitfall 7), capstone described but not scaffolded (UX pitfall)
**Research flag:** Facilitator guide for Module 11 fleet lab requires hermes-agent team coordination — solo fallback using three pre-built reference agents must be designed jointly

### Phase 5: Quality Assurance and Delivery Readiness
**Rationale:** Research identifies several cross-cutting quality requirements that cannot be done incrementally during module authoring: vocabulary audit grep, mock data security audit, cold-read testing of each lab with an independent colleague, provider compatibility matrix verification, and time estimate validation.
**Delivers:** All modules passing the "Looks Done But Isn't" checklist from PITFALLS.md; provider compatibility matrix for Claude Code + Crush + Google AI Studio; vocabulary audit results (zero "write a prompt / better prompt / adjust your prompt" hits across all modules); mock data security audit (no real account IDs); lab time estimates validated by cold-tester
**Addresses:** Solo completability check for all team exercises, expected output blocks for all lab steps, checkpoint artifacts for all labs
**Avoids:** Lab timing estimation failure (Pitfall 2), unclear lab instructions (Pitfall 6), prompt engineering vocabulary relapse (Pitfall 8), Udemy video quality issues affecting initial ratings
**Research flag:** Udemy-specific QA — first 5 video segments should be reviewed against Udemy quality standards before mass recording; this phase gates video production

### Phase Ordering Rationale

- Shared mock data and setup guide are strict prerequisites for every module lab — they go first with no exceptions
- Module 1 mental model is the foundation for all 14 modules — it cannot be written quickly or corrected late without cascading fixes
- Module 6 solutions are forward-referenced by hermes-agent Module 10 — cross-repo coordination must happen during Phase 3, not after
- Format overlays (instructor guides, Udemy section outline) are always derived content — they are last because they require all module content to exist first
- QA pass is a final phase, not an incremental activity, because vocabulary audit and cold-read testing require complete module content

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 2, Module 1 lab design:** The side-by-side bare-vs-structured context comparison is the single most critical lab in the course. Research does not specify the exact format of this comparison — it needs to be prototyped and tested with a DevOps practitioner before being written as final content.
- **Phase 3, Module 6 cross-repo coordination:** Naming conventions for starter/solution track directories must be synchronized with hermes-agent repo. This requires a direct check of the current hermes-agent module-10 structure before finalizing Module 6 solution file naming.
- **Phase 5, Google AI Studio rate limit verification:** Provider limits are flagged LOW confidence in STACK.md because they changed significantly in December 2025 and continue to change. Verify current Gemini 2.5 Flash free tier limits against aistudio.google.com/docs immediately before delivery, not at content authoring time.

Phases with standard patterns (skip research-phase):
- **Phase 1:** File structure and mock data format patterns are well-documented in ARCHITECTURE.md and STACK.md. AWS CLI output field names can be verified with a single read-only `aws` call.
- **Phase 4:** Facilitation guide format and Udemy section outline are standard course design artifacts. ARCHITECTURE.md provides the exact directory structure to follow.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM-HIGH | Core content format and tooling verified via official docs and direct project analysis. LLM provider rate limits are LOW confidence — they change without notice and must be re-verified before each delivery. |
| Features | HIGH | Feature research corroborated by Udemy platform docs, KodeKloud competitor analysis, hermes-agent existing research, and direct project docs. MVP scope and prioritization are clear and consistent across sources. |
| Architecture | HIGH | Derived from direct analysis of project documentation (CLAUDE.md, HANDOFF.md, PROJECT.md) and hermes-agent architecture research. The module directory structure is prescriptive and verified. |
| Pitfalls | HIGH (lab/dual-format) / MEDIUM (Udemy ratings) | Lab design pitfalls are verified against training industry standards (ATD 10:1 ratio, workshop failure analysis). Udemy algorithm specifics are MEDIUM confidence — ratings mechanics change. |

**Overall confidence:** HIGH

### Gaps to Address

- **LLM provider rate limits:** All free-tier rate limits (Gemini 2.5 Flash, Groq, OpenRouter) must be re-verified immediately before workshop delivery, not at content authoring time. Embed provider docs URLs into every lab that uses a non-Claude provider.
- **Module 11 solo fallback design:** The fleet orchestration solo fallback (one participant uses three pre-built reference agents instead of team-built agents) requires the three reference implementations to be complete and tested. This is a hermes-agent deliverable — confirm availability before Module 11 content is finalized in this repo.
- **Module 6 → Module 10 cross-repo naming:** The exact directory structure of hermes-agent/course/modules/module-10/starter/ must be confirmed before naming the Module 6 solution tracks. Check this at the start of Phase 3.
- **Crush provider setup UX:** The `/connect` flow in Crush for Groq and Gemini has not been cold-tested by an independent participant. The setup appendix needs a cold-read test with a participant who has no prior Crush experience.
- **Mock data quality threshold:** Research specifies mock data must include "noisy" scenarios with multiple potential root causes. The exact structure (how many scenarios, how much noise, what anomaly patterns) needs a subject matter review from a practicing SRE before authoring begins.

---

## Sources

### Primary (HIGH confidence)
- `/Users/gshah/work/agentic/devops/course/CLAUDE.md` — course structure, module directory template, dual-format constraints, tool split by module
- `/Users/gshah/work/agentic/devops/course/HANDOFF.md` — module-by-module content breakdown, cross-repo responsibility split, dependency chain
- `/Users/gshah/work/agentic/devops/hermes-agent/.planning/research/ARCHITECTURE.md` — Hermes-side course architecture
- KIND documentation — https://kind.sigs.k8s.io/
- Terraform mock provider — https://developer.hashicorp.com/terraform/language/tests/mocking
- LocalStack pricing changes — https://blog.localstack.cloud/2026-upcoming-pricing-changes/
- Udemy course structure best practices — https://teach.udemy.com/course-creation/
- Udemy practice activities guidance — https://teach.udemy.com/course-creation/plan-your-practice-activities/
- ATD training development time ratio — https://www.td.org/content/atd-blog/how-long-does-it-take-to-develop-one-hour-of-training-2017
- Anthropic: Effective Context Engineering for AI Agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

### Secondary (MEDIUM confidence)
- Context Engineering vs Prompt Engineering — https://www.promptingguide.ai/guides/context-engineering-guide
- OpenCode archive notice — https://github.com/opencode-ai/opencode (archived Sept 18, 2025)
- Crush successor repo — https://github.com/charmbracelet/crush
- Google AI Studio rate limits — https://ai.google.dev/gemini-api/docs/rate-limits (limits subject to change)
- LocalStack community EOL — https://www.infoq.com/news/2026/02/localstack-aws-community/
- Udemy agentic AI course competitive analysis — https://www.udemy.com/topic/ai-agents/
- KodeKloud DevOps course patterns — https://kodekloud.com/blog/hands-on-devops-cloud-ai-learning-2025/
- OpenCode January 2026 Anthropic OAuth block — https://thomas-wiegold.com/blog/i-switched-from-claude-code-to-opencode/

### Tertiary (LOW confidence — verify before delivery)
- Groq free tier rate limits — https://console.groq.com/docs/rate-limits (changes frequently)
- Google Gemini 2025 quota cut details — https://quasa.io/media/google-s-gemini-api-free-tier-fiasco-developers-hit-by-silent-rate-limit-purge (user reports, not official)
- OpenRouter free model stability — no official SLA; treat as last resort

---
*Research completed: 2026-04-04*
*Ready for roadmap: yes*
