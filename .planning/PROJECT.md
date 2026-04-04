# Agentic DevOps Course — Content Development

## What This Is

Course content repository for "Agentic DevOps: Building Agentic Skills for Infrastructure Automation" — a 3-day advanced workshop (also published as a self-paced Udemy course) for DevOps practitioners who are completely new to AI/agentic systems. The course takes participants from zero AI knowledge through building production-grade domain agents, using their deep infrastructure expertise as the foundation.

## Core Value

DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering (not prompt tricks) is THE skill that makes agents useful.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Module 1: AI Foundations lab — progressive context engineering with CloudWatch alarm data
- [ ] Module 1: Reading materials — tokenization, context windows, inference, temperature, token economics
- [ ] Module 2: Platform AI lab — AWS AI features on free tier (CloudWatch anomaly, Cost Explorer, Q Developer)
- [ ] Module 3: Bridge content — platform AI → custom agents transition (partial, Hermes demo script)
- [ ] Module 4: Impact Assessment exercise — Automation Quadrant scoring template
- [ ] Module 5: Structured AI Coding lab — Ansible EC2 hardening via structured workflow
- [ ] Module 6: AI-Assisted IaC lab — 3 tracks (Terraform RDS, Ansible PostgreSQL, K8s deployment)
- [ ] Module 9: Agent Design Patterns — reading materials mapping patterns to Hermes capabilities (partial)
- [ ] Module 14: Capstone — presentation template, 30-day roadmap template, rubric (partial)
- [ ] All modules: Explainer slide notes and diagram descriptions (Excalidraw sources where feasible)
- [ ] All modules: Reading materials (concepts.md, reference.md) for every module (1-14)
- [ ] All modules: Quiz content (QUIZ.md) for every module
- [ ] Cross-module: Participant setup guide (environment provisioning, tool installation)
- [ ] Cross-module: Simulated infrastructure data (mock CloudWatch, Cost Explorer, EC2, RDS, kubectl outputs)
- [ ] Dual-format: All labs completable solo (Udemy) and in teams (live workshop)
- [ ] Multi-provider: Labs work with Claude Code (primary) or OpenCode (fallback), supporting Claude subscription, Google Gemini free, OpenRouter, Grok, and other free-tier providers

### Out of Scope

- Hermes-focused lab content (modules 7, 8, 10, 11, 12, 13) — built in hermes-agent repo
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
| Labs-first, then explainers | Hands-on content is the foundation; concepts derive from practice | — Pending |
| Claude Code primary, OpenCode fallback | Promote Claude Code but ensure accessibility for all participants | — Pending |
| Context engineering as core skill | Differentiates from generic "prompt engineering" courses; matches real agent-building needs | — Pending |
| Mock infra data for AWS services | Eliminates cloud cost/access barriers; ensures reproducible labs | — Pending |
| Multi-provider LLM access | No participant left behind due to subscription status | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
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

---
*Last updated: 2026-04-04 after initialization*
