# Agentic DevOps Course — Content Development

## What This Is

Course content repository for "Agentic DevOps: Building Agentic Skills for Infrastructure Automation" — a 3-day advanced workshop (also published as a self-paced Udemy course) for DevOps practitioners who are completely new to AI/agentic systems. The course takes participants from zero AI knowledge through building production-grade domain agents, using their deep infrastructure expertise as the foundation.

## Core Value

DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering (not prompt tricks) is THE skill that makes agents useful.

## Requirements

### Validated (v1.0)

- ✓ Module 1: AI Foundations lab — progressive context engineering with CloudWatch alarm data
- ✓ Module 1: Reading materials — tokenization, context windows, inference, temperature, token economics
- ✓ Module 2: Platform AI lab — AWS AI features on free tier (CloudWatch anomaly, Cost Explorer, Q Developer)
- ✓ Module 3: Bridge content — platform AI → custom agents transition (Hermes demo script with timings)
- ✓ Module 4: Impact Assessment exercise — Automation Quadrant scoring template, solo-completable
- ✓ Module 5: Structured AI Coding — Track A: Helm chart + HPA, Track B: GitHub Actions pipeline with matrix testing
- ✓ Module 5: GSD Workflow lab — complete 5-phase cycle building Prometheus alerting rules + Grafana dashboard
- ✓ Module 5: Context engineering practical — CLAUDE.md before/after comparison with multi-file analysis
- ✓ Module 5: Memory systems lab — claude-mem (Claude Code) and MCP memory architecture comparison
- ✓ Module 5: Plan modes lab — decision framework for when to plan vs execute
- ✓ Module 5: Superpowers workflow — TDD, systematic debugging, code review, verification examples
- ✓ Module 6: AI-Assisted IaC — Track A: Terraform EC2/CloudWatch/SNS (free tier), Track B: ArgoCD GitOps on KIND (shipped); Track C: descoped (Argo Workflows — out of scope per MOD6-03)
- ✓ Reference microservices app — Rust API (Axum 0.8) + Svelte 5 dashboard + PostgreSQL, deployable on KIND, GitHub Actions pipeline
- ✓ Module 9: Agent Design Patterns — reading: advisor/investigator/proposal/guardian patterns with Hermes mappings, L1-L4 autonomy spectrum
- ✓ Module 14: Capstone — presentation template, 30-day roadmap template, evaluation rubric (5-dimension assessment)
- ✓ All modules: Reading materials (concepts.md, reference.md) for all 14 modules
- ✓ All modules: Quiz content (QUIZ.md) for all 14 modules with collapsible answers
- ✓ All modules: Module README.md with objectives and prerequisites
- ✓ Cross-module: Participant setup guide (SETUP.md, verify.sh, llm-access.md) with 4+ free providers documented
- ✓ Real systems first: All labs connect to KIND, PostgreSQL, AWS free tier, with mock JSON fallbacks clearly labeled
- ✓ Dual-format: All team exercises have solo-completable versions (Module 4, 11, 14)
- ✓ Multi-provider: Labs support Claude Code, Crush, with setup for Gemini 2.5 Flash, OpenRouter, Groq

### Active (v1.1)

- ✓ Module 5/6 consolidation: 5a→Module 5 (Superpowers for IaC), 5b→Module 6 (AI Workflow Tools), old Module 6 absorbed (Phase 5 complete)
- [ ] K8s diagnostic SKILL.md with real kubectl commands (replace EC2 skill in Track C across Modules 7, 10)
- [ ] kube-troublesim integration — broken pods on KIND as lab scenarios for agent diagnosis
- [ ] Hermes command allowlist/blocklist guardrails (kubectl get allowed, kubectl delete blocked) in Modules 10 and 13
- [ ] Agent trigger patterns: AlertManager webhook → triage agent, K8s CronJob scheduled agent, chat bot interaction, GitHub event PR review bot (Module 12)
- [ ] K8s Agent Sandbox exploratory lab — productionizing agents on Kubernetes (new K8s SIG)
- [ ] Deeper Hermes multi-agent workflows — end-to-end: alert → triage → diagnose → propose fix → human approval → apply
- [ ] Rebuild all Hermes module labs (7, 8, 10, 11, 12, 13) with working, relevant K8s-first content

### Deferred (v1.2+)

- [ ] Video walkthroughs for structured AI workflow (5-phase cycle recording)
- [ ] Module 6: Lab Track C — Argo Workflows + GitHub Actions pipeline (deferred from v1.0)
- [ ] Explainer slide notes and Excalidraw diagram sources (design author creates visuals from notes)
- [ ] Udemy video production (concept explainers + lab walkthroughs)

### Out of Scope

- Video recording/editing — separate production step after content is written
- Excalidraw diagram creation (visual design) — trainer creates these from diagram descriptions
- LMS/Udemy platform setup — separate from content creation
- Paid API integrations — all labs must work on free tiers only

## Context

- **Hermes agent framework** is the primary tool for modules 7-13, built in a separate repo at `/Users/gshah/work/agentic/devops/hermes-agent/`
- **Course outline** available at `/Users/gshah/Downloads/Agentic DevOps.pdf`
- **Learner profile:** Strong DevOps/SRE practitioners (Terraform, Ansible, K8s, CI/CD, git, AWS) with ZERO AI/LLM knowledge. All concepts must use operational analogies.
- **Content philosophy:** Labs/projects FIRST, then derive explainers and reading materials from hands-on content. Context engineering > prompt engineering throughout.
- **14 modules across 3 days:** Day 1 (foundations + platform AI + assessment), Day 2 (structured coding + IaC + skills + tools), Day 3 (patterns + agent build + fleet + governance + capstone)
- **Simulated infra strategy:** Mock JSON data for AWS services, real KIND clusters for K8s labs
- **Dependency chain:** Module 1 → 2 → 3 → 5 → 6 → 7 (Hermes enters) → 8 → 9 → 10 → 11 → 12 → 13 → 14, with Module 4 branching from Module 2

## Constraints

- **Timeline**: Content must be complete by 2026-04-05 (course starts 2026-04-06)
- **No paid APIs**: Participants use existing Claude subscription, Google Gemini free, OpenRouter, Grok, or other free-tier providers
- **Free infra**: AWS free tier, KIND for K8s, mock data for services not on free tier
- **Dual format**: Content must work for both live 3-day workshop AND self-paced Udemy learners
- **Tool flexibility**: Claude Code primary, OpenCode fallback — labs must include provider setup instructions for multiple backends
- **Module structure**: Every module follows standard structure (README.md, explainer/, reading/, lab/, quiz/, exploratory/)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Labs-first, then explainers | Hands-on content is the foundation; concepts derive from practice | ✓ Validated: All 14 modules have working labs first; reading/concepts authored after implementation |
| Claude Code primary, Crush fallback | Promote Claude Code but ensure accessibility for all participants | ✓ Validated: Labs primary path is Claude Code; setup guide includes Crush + Groq for offline/budget constraints |
| Context engineering as core skill | Differentiates from generic "prompt engineering" courses; matches real agent-building needs | ✓ Validated: Vocabulary audit passed (zero "prompt engineering" uses in Modules 7-14); CLAUDE.md practical demonstrates context > prompts |
| Mock infra data for AWS services | Eliminates cloud cost/access barriers; ensures reproducible labs | ✓ Validated: All AWS labs have JSON mock data fallbacks; Module 1, 2, 6 docs clearly label real vs mock paths |
| Multi-provider LLM access | No participant left behind due to subscription status | ✓ Validated: llm-access.md documents 4+ free-tier providers; Crush integration enables Gemini 2.5 Flash + Groq |
| Track selection in Module 5 & 6 | Accommodate different participant interests (IaC tools vary by team) | ✓ Validated: Helm (Track A) and CI/CD (Track B) completed; Terraform (6-A) and K8s+ArgoCD (6-B) completed |
| Scope v1.0 to core (descope Hermes + Track C) | Ensure ship on deadline; Hermes labs and CI/CD orchestration deferred to v1.1 | ✓ Validated: v1.0 ships 14 modules (1-6, 9, 14 complete; 7-8, 10-13 documented for Hermes integration); MOD6-03 deferred |
| Consolidate Module 5/6 (v1.1) | 5a too basic, old Module 6 repetitive with 5a — Superpowers adds real value | ✓ Validated (Phase 5): 13/13 must-haves verified, 4/4 requirements met, no broken module-5/6 links |
| K8s-first agent rebuild (v1.1) | EC2 skill on K8s agent undermines course credibility; kube-troublesim provides real scenarios | — Pending |
| Command allowlist/blocklist guardrails (v1.1) | Empty allowlists miss key governance teaching opportunity | — Pending |

## Current Milestone: v1.1 Realistic Agents & Production Workflows

**Goal:** Rebuild modules 5-13 with working K8s-first agents, real skills, Superpowers integration, agent triggers, and production deployment patterns.

**Target features:**
- Module 5/6 consolidation with Superpowers workflow as centerpiece
- K8s diagnostic skills with real kubectl commands (replacing EC2 skill mismatch)
- kube-troublesim broken-pod scenarios on KIND for agent diagnosis labs
- Hermes command allowlist/blocklist guardrails
- Agent trigger patterns (AlertManager, CronJob, chat bots)
- K8s Agent Sandbox exploratory content
- End-to-end multi-agent workflows that actually execute

## Current State (v1.0 Shipped)

**What shipped:** 14-module course with labs, reading, quizzes for Modules 1-6, 9, 14. Modules 7-8, 10-13 have design documents and external references pointing to Hermes repo.

**Codebase:** ~100K lines across 605 files (Docusaurus site, reference app, instructor guides, labs, reading materials).

**User feedback themes (April 6-8 workshop):**
- Module 5a too basic, repetitive with Module 6 — needs Superpowers integration
- K8s skills not relevant (EC2 skill on K8s agent), Hermes agents incomplete
- Need working agent triggers and interaction patterns (AlertManager, chat bots)
- Want to see agent productionization on K8s (Agent Sandbox)
- Need concrete guardrails demo (command allowlist/blocklist)

**Known issues:**
- Track C K8s agent ships with EC2 health check skill (sre-ec2-health-check) — completely wrong domain
- Module 7 Track C solution is also the EC2 skill — no K8s diagnostic skill exists anywhere
- Hermes repo has ~100 skills, zero are K8s/DevOps/SRE relevant
- All L4 governance configs have empty command_allowlist — no guardrails demonstrated
- Module 14 capstone templates referenced but files incomplete

**Deployment:** Docusaurus site auto-deploys to GitHub Pages at https://schoolofdevops.github.io/401/ on pushes affecting course-site/**

**Tech debt:** EC2→K8s skill replacement, Module 14 template completion, empty governance allowlists.

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via phase completion):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state
5. Move all shipped requirements to Validated
6. Log key decisions with outcomes

---
*Last updated: 2026-04-07 after Phase 5 (Module Consolidation) complete*
