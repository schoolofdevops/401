# Completed Work Handoff — Agentic DevOps Course

**Date:** 2026-04-05
**Purpose:** Everything that's been built, what's left, and what the next session needs to know.

---

## What Was Built (Two Parallel Sessions)

### Session 1: Hermes-Focused Content (hermes-agent repo → course repo)

Built all Hermes-focused course content across 4 phases, 21 plans. All artifacts live in this course repo.

#### Skills (4 production-grade SKILL.md files)
| File | Track | Lines | Key Features |
|------|-------|-------|-------------|
| `skills/sre-ec2-health-check/SKILL.md` | SRE | 280 | 6 AWS CLI commands, 4 IF/THEN branches, prompt injection warning |
| `skills/devops-deployment-safety-check/SKILL.md` | DevOps | 276 | 3-phase gate (pre-deploy, canary, post-canary), 6 AWS commands |
| `skills/dba-rds-slow-query/SKILL.md` | DBA | 249 | pg_stat_statements + seq_scan ratio, 4-branch decision tree |
| `skills/observability-alert-noise-analyzer/SKILL.md` | Observability | 203 | Dedup detection, flapping analysis, noise score formula |

Plus: `skills/SKILL-TEMPLATE.md` (398 lines, canonical blank) and `skills/RUBRIC.md` (212 lines, 4-tier quality checklist)

#### Agent Profiles (4 complete profiles)
| Directory | Agent | Identity | Governance |
|-----------|-------|----------|------------|
| `agents/track-a-database/` | Aria (DBA) | Terse, data-driven | L2 Advisory, blocks ALTER/DROP |
| `agents/track-b-finops/` | Finley (FinOps) | Analytical, confidence-scored | L2 Advisory, blocks ec2 terminate |
| `agents/track-c-kubernetes/` | Kiran (K8s) | Operational, systematic | L2 Advisory, blocks kubectl delete/drain |
| `agents/fleet-coordinator/` | Morgan (Coordinator) | Delegation-only | No terminal, no skills, delegation config |

Plus: `agents/SOUL-TEMPLATE.md` (blank participant template with [placeholder] syntax)

#### Governance Templates (6 diffable YAML fragments)
| File | Level | Key Change |
|------|-------|------------|
| `governance/governance-L1.yaml` | Assistive | No terminal, manual approval |
| `governance/governance-L2.yaml` | Advisory | Terminal added, manual approval |
| `governance/governance-L3.yaml` | Proposal | Terminal, smart approval |
| `governance/governance-L4-track-a.yaml` | Semi-autonomous | Smart + Track A allowlist |
| `governance/governance-L4-track-b.yaml` | Semi-autonomous | Smart + Track B allowlist |
| `governance/governance-L4-track-c.yaml` | Semi-autonomous | Smart + Track C allowlist |

#### Mock Infrastructure (dual-mode: mock ↔ live)
| Category | Files | Notes |
|----------|-------|-------|
| RDS mock data | 5 JSON files in `infrastructure/mock-data/rds/` | Exact AWS API field names (PascalCase) |
| Cost Explorer mock data | 3 JSON files in `infrastructure/mock-data/cost-explorer/` | Matches `aws ce get-cost-and-usage` format |
| CloudWatch mock data | 3 JSON files in `infrastructure/mock-data/cloudwatch/` | Created by parallel session |
| EC2 mock data | 1 JSON file in `infrastructure/mock-data/ec2/` | Created by parallel session |
| Kubernetes mock data | 3 JSON files in `infrastructure/mock-data/kubernetes/` | Matches `kubectl get pods -o json` format |
| Shell wrappers | `infrastructure/wrappers/mock-aws`, `mock-kubectl`, `mock-psql` | Route via `HERMES_LAB_MODE=mock\|live`, [MOCK MODE] banner |
| Scenarios | 7 files in `infrastructure/scenarios/` | Clean + messy per track + cross-domain |

**Switching mechanism:** `HERMES_LAB_MODE=mock` (default) or `HERMES_LAB_MODE=live`. Same skills work against both. Zero config changes to switch.

#### Lab Guides (7 complete labs)
| Module | File | Lines | Steps | Time |
|--------|------|-------|-------|------|
| 7 — Agent Skills | `modules/module-07-skills/LAB.md` | ~400 | 7 (progressive reveal) | 60 min |
| 8 — Tool Wiring | `modules/module-08-tools/LAB.md` | ~350 | 8 | 75 min |
| 10 — Domain Agent (Track A) | `modules/module-10-agents/LAB-track-a-database.md` | ~500 | 10 | 90 min |
| 10 — Domain Agent (Track B) | `modules/module-10-agents/LAB-track-b-finops.md` | ~500 | 10 | 90 min |
| 10 — Domain Agent (Track C) | `modules/module-10-agents/LAB-track-c-kubernetes.md` | ~500 | 10 | 90 min |
| 11 — Fleet Orchestration | `modules/module-11-fleet/LAB.md` | 626 | 8 | 60 min |
| 12 — Triggers/Scheduling | `modules/module-12-triggers/LAB.md` | 657 | 8 | 60 min |
| 13 — Governance | `modules/module-13-governance/LAB.md` | 720 | 13 | 75 min |

Each lab has `starter/` and `solution/` directories where applicable.

#### Reading Materials (5 reference docs)
| File | Lines | Quick Ref | Topic |
|------|-------|-----------|-------|
| `reading/agent-anatomy.md` | 511 | Yes | Brain + Skills + Tools + Guardrails architecture |
| `reading/skills-guide.md` | 618 | Yes | SKILL.md format, two-zone design, RUBRIC walkthrough |
| `reading/tool-patterns.md` | 611 | Yes | CLI vs MCP vs wrappers, safety configuration |
| `reading/governance-ref.md` | 513 | Yes | Approval modes, L1-L4, audit logging, promotion |
| `reading/profile-guide.md` | 583 | Yes | Profiles as agent definitions, SOUL.md, config.yaml |

#### Setup Guides
| File | Purpose |
|------|---------|
| `setup/install-hermes.md` | Hermes install with 4 LLM provider paths (Claude Code OAuth, Google AI Studio, HF, OpenRouter) |
| `setup/setup-kind.md` | KIND v0.27+ cluster creation, cluster name `lab` |
| `setup/llm-access.md` | Model selection (Haiku default), cost estimation, HERMES_LAB_MODE explanation |
| `setup/verify.sh` | 23-check pre-workshop validation script (bash 3.2 compatible) |
| `setup/SETUP.md` | Master setup guide (created by parallel session) |

---

### Session 2: Parallel Session Content (Modules 1-4 + Course Site)

The parallel session built Day 1 content and course infrastructure:

#### Docusaurus Course Site
- `course-site/` — Full Docusaurus 3.9.2 site with 4 Day 1 module scaffolds
- Sidebar navigation, module README pages, lab embedding

#### Module 1 — AI Foundations
- `course-site/docs/module-01-foundations/lab/LAB.mdx` — Progressive context engineering lab with CloudWatch alarm data
- `course-site/docs/module-01-foundations/lab/starter/` — 3 context layers (layer 1-3) for progressive context building
- `course-site/docs/module-01-foundations/reading/` — concepts.md + reference.md
- `course-site/docs/module-01-foundations/quiz/` — 7-question quiz on LLM fundamentals

#### Module 2 — Platform AI
- Lab, reading, assessment template, quiz (in course-site/)

#### Module 3 — Bridge (Platform AI → Custom Agents)
- Hermes demo script, reading, quiz (in course-site/)

#### Module 4 — Impact Assessment
- Lab with templates, reading, quiz (in course-site/)

#### Reference App
- `reference-app/` — Rust workspace with Helm charts for KIND deployment
- Dashboard, API gateway, catalog, worker services
- Helm templates in `reference-app/helm/reference-app/`

---

## What's NOT Built Yet

### Content Gaps

| Module | What's Missing | Priority |
|--------|---------------|----------|
| 5 — Structured AI Coding | Lab (Ansible EC2 hardening with Superpowers workflow) | HIGH — Day 2 morning |
| 6 — AI-Assisted IaC | Lab (3 tracks: Terraform RDS, Ansible PostgreSQL, K8s deploy) | HIGH — Day 2 morning |
| 9 — Agent Design Patterns | Conceptual explainers (patterns diagrams), no lab needed | MEDIUM |
| 14 — Capstone | Presentation template, evaluation rubric, 30-day plan template | LOW |
| All modules | Excalidraw diagrams for conceptual explainers | HIGH for Udemy |
| All modules | Video scripts / recording | HIGH for Udemy |
| Modules 5-14 | Quizzes | MEDIUM |

### Integration Work

| Item | Description | Priority |
|------|-------------|----------|
| Docusaurus integration | Modules 7-13 content exists as standalone .md but NOT yet integrated into course-site/ | HIGH |
| Module 5-6 labs | Need to be built (Claude Code focused, IaC generation) | HIGH |
| Cross-module navigation | Ensure Docusaurus sidebar covers all 14 modules | MEDIUM |
| Participant setup guide | Unified SETUP.md that covers BOTH Claude Code + Hermes setup | MEDIUM |

### Human Testing Needed

| Phase | Items | Description |
|-------|-------|-------------|
| Phase 1 | INFR-06 | Live-mode validation (AWS account has no RDS/EC2 — schema validated only) |
| Phase 2 | 3 items | Profile identity injection, approval gate test, Module 7 usability walkthrough |
| Phase 3 | 6 items | Live Hermes agent execution for all 3 tracks (interactive + report + break-it) |
| Phase 4 | 4 items | Live fleet orchestration, cron execution, governance walk-through, reading review |

---

## Key Architecture Decisions (For Next Session)

These decisions are LOCKED — do not change without explicit discussion:

1. **Context engineering > prompt engineering** — THE core philosophy. Skills and SOUL.md are context engineering artifacts. Expert vocabulary matters.

2. **Hermes profiles = agent definitions** — No Python. Agents defined via SOUL.md + config.yaml + skills/ directory. Install via `cp -r`.

3. **HERMES_LAB_MODE=mock|live** — Env var switching. `[MOCK MODE]` banner on output. Same skills work against both modes.

4. **Haiku as default model** — All labs designed for Claude Haiku (cheapest). Sonnet only for complex reasoning.

5. **No paid API access** — Claude Code OAuth, Google AI Studio, HF free tier, OpenRouter. Document all equally.

6. **Two-zone skill design** — Scripts Zone (deterministic CLI commands) + Agents Zone (reasoning/decisions). Skills clearly separate these.

7. **Progressive reveal pedagogy** — Module 7 reveals skill sections one at a time. Established pattern for teaching.

8. **Diff-based governance** — L1-L4 as separate YAML files. `diff` to see what changes at each level.

9. **Track-specific safety boundaries** — Each track has its own allowed/blocked commands. Track A: SQL. Track B: AWS. Track C: kubectl.

10. **Dual format** — All content works for both live 3-day workshop AND self-paced Udemy. Labs are solo-completable.

11. **Audit trail is SQLite, not JSONL** — Module 13 discovered Hermes uses `~/.hermes/state.db` for audit logs, not flat files. Lab uses `sqlite3` queries.

12. **Track B/C have cross-domain skills** — This is intentional. SOUL.md identity drives domain behavior, not the skill domain. Taught as a teaching moment in Module 10.

---

## File Organization

```
course/
├── agents/                          # 4 complete agent profiles + SOUL template
│   ├── SOUL-TEMPLATE.md
│   ├── fleet-coordinator/           # Morgan — delegation only, no skills
│   ├── track-a-database/            # Aria — DBA, L2 governance
│   ├── track-b-finops/              # Finley — FinOps, L2 governance
│   └── track-c-kubernetes/          # Kiran — K8s, L2 governance
├── course-site/                     # Docusaurus 3.9.2 (Modules 1-4 integrated)
├── governance/                      # 6 diffable YAML fragments (L1-L4)
├── infrastructure/
│   ├── mock-data/                   # 15+ JSON files (RDS, CE, CW, EC2, K8s)
│   ├── wrappers/                    # mock-aws, mock-kubectl, mock-psql
│   ├── scenarios/                   # 7 scenario files (clean + messy + cross-domain)
│   ├── helm/                        # Prometheus lab values
│   └── kind/                        # Cluster config
├── modules/
│   ├── module-07-skills/            # LAB.md + starter/ + solution/ (4 tracks)
│   ├── module-08-tools/             # LAB.md + starter/ + solution/
│   ├── module-10-agents/            # 3 track LABs + starter/ + solution/ per track
│   ├── module-11-fleet/             # LAB.md (626 lines)
│   ├── module-12-triggers/          # LAB.md + starter/cron-job-starter.yaml
│   └── module-13-governance/        # LAB.md (720 lines)
├── reading/                         # 5 reference docs (500-620 lines each)
├── reference-app/                   # Rust workspace + Helm charts + dashboard
├── setup/                           # Install guides + verify.sh
└── skills/                          # 4 domain skills + SKILL-TEMPLATE + RUBRIC
```

---

## Hermes-Agent Reference

The agent framework lives at `/Users/gshah/work/agentic/devops/hermes-agent/`. Key things the next session should know:

- **Codebase maps** at `hermes-agent/.planning/codebase/` — 7 docs covering architecture, stack, integrations, structure, conventions, testing, concerns
- **Research** at `hermes-agent/.planning/research/` — STACK.md, FEATURES.md, ARCHITECTURE.md, PITFALLS.md, SUMMARY.md
- **Hermes skills system** — Skills loaded from `~/.hermes/skills/` or profile's `skills/` directory. YAML frontmatter + markdown body. Auto-loaded at startup.
- **Hermes profiles** — `~/.hermes/profiles/<name>/` with config.yaml + SOUL.md + skills/. Switch with `hermes -p <name> chat`.
- **Hermes approval** — `tools/approval.py` with DANGEROUS_PATTERNS mechanical gate + SOUL.md behavioral rules. Approval modes: manual, smart, off.
- **Hermes cron** — `cron/scheduler.py` with known silent failure on laptop sleep. Always run `hermes cron status` first.
- **Hermes webhooks** — `skills/devops/webhook-subscriptions/SKILL.md` has the full webhook management guide.

---

## Immediate Next Steps

1. **Build Module 5-6 labs** — Structured AI coding + IaC generation using Claude Code. These are Day 2 morning content.

2. **Integrate Modules 7-13 into Docusaurus** — The content exists as standalone .md files in `modules/`. Needs to be copied/adapted into `course-site/docs/` structure.

3. **Human testing** — Run through the Hermes labs with a live Hermes agent. See "Human Testing Needed" section above.

4. **Module 9 conceptual content** — Agent design patterns (no lab, just explainers and reading material).

5. **Module 14 capstone templates** — Presentation template, evaluation rubric, 30-day deployment plan template.

6. **Quizzes for Modules 5-14** — Derive from lab content and reading materials.

7. **Excalidraw diagrams** — Visual explainers for all conceptual content (needed for Udemy video recording).

---

## Course Outline Reference

Full course outline: `/Users/gshah/Downloads/Agentic DevOps.pdf`
Project context: `/Users/gshah/work/agentic/devops/hermes-agent/.planning/PROJECT.md`
Conceptual curriculum: See "Learner Profile" section in PROJECT.md (Layer 1-5 concepts)

---
*Handoff created: 2026-04-05*
