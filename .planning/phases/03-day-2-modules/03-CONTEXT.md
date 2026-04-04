# Phase 3: Day 2 Modules - Context

**Gathered:** 2026-04-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Build all Day 2 module content (Modules 5a, 5b, and 6) within the Docusaurus site: labs, reading materials, quizzes, and starter/solution files. Module 5 is split into 5a (Structured AI Coding with track choice) and 5b (AI Workflow Tools). Module 6 has two IaC tracks. All content formatted as MDX for Docusaurus.

</domain>

<decisions>
## Implementation Decisions

### Module 5 Organization
- **D-32:** Split Module 5 into two sub-modules:
  - **Module 5a: Structured AI Coding** — Track A (Helm chart) OR Track B (CI/CD pipeline). Participant picks one.
  - **Module 5b: AI Workflow Tools** — GSD workflow lab, context engineering practical, memory systems, plan modes. Superpowers as exploratory.
- **D-33:** Participants choose ONE track per module, not all. Different tracks for different DevOps specializations.

### Module 5a — Structured AI Coding Tracks
- **D-34:** Track A: Build a production Helm chart for the reference app via structured AI workflow (Brainstorm → Design → Blueprint → Implement → Validate)
- **D-35:** Track B: Build a CI/CD pipeline (GitHub Actions) for the reference app via structured AI workflow

### Module 5b — AI Workflow Tools
- **D-36:** GSD Workflow lab: Full cycle (new-project → discuss → plan → execute → verify) building a **monitoring stack** (Prometheus alerting rules + Grafana dashboard config) for the reference app (api-gateway, catalog, worker)
- **D-37:** Context engineering practical: CLAUDE.md files, context window management, selective injection
- **D-38:** Memory systems lab: claude-mem for Claude Code, MCP-based memory for OpenCode
- **D-39:** Plan modes lab: Claude Code plan mode, GSD plan-phase
- **D-40:** Superpowers workflow: TDD, debugging, code review as exploratory content

### Module 6 — AI-Assisted IaC (2 tracks, not 3)
- **D-41:** **Skip Argo Workflows track entirely** — only Track A and Track B remain
- **D-42:** Track A: Terraform module for real AWS resources (free tier) with CloudWatch alarms + SNS. Mock fallback documented.
- **D-43:** Track B: K8s + Helm + **ArgoCD** GitOps on KIND — override D-06 for this specific lab. ArgoCD is appropriate when participants are actively learning GitOps (vs too heavy for Day 1 foundation).
- **D-44:** Participants choose ONE track.

### Lab Approach
- **D-45:** **Guided generation** — Lab gives specific prompts/context to feed the AI tool at each step. Participants see how structured AI input produces quality IaC. Solution files provided for comparison.
- **D-46:** Every lab step includes "Expected result:" block so participants know if they succeeded.

### Claude's Discretion
- Specific Prometheus alerting rules and Grafana dashboard configs for the GSD lab
- How to structure the guided generation prompts for each track
- Memory systems MCP server recommendation for OpenCode
- Superpowers exploratory depth and format

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 1 Outputs (reference app)
- `reference-app/services/api-gateway/src/main.rs` — API gateway service (port 8080, health endpoints)
- `reference-app/services/catalog/src/main.rs` — Catalog service (port 8081, PostgreSQL reads)
- `reference-app/services/worker/src/main.rs` — Worker service (port 8082, PostgreSQL writes)
- `reference-app/helm/reference-app/` — Existing Helm chart for the reference app
- `reference-app/Makefile` — Deploy workflow
- `.github/workflows/ci.yml` — Existing CI/CD pipeline
- `infrastructure/kind/cluster-config.yaml` — KIND config
- `infrastructure/helm/prometheus-lab-values.yaml` — Prometheus lab values

### Phase 2 Outputs (Docusaurus site)
- `course-site/` — Docusaurus 3.9.2 project (all content goes here as MDX)
- `course-site/docs/module-01-foundations/lab/LAB.mdx` — Module 1 lab (pattern reference for lab format)

### Course Context
- `.planning/PROJECT.md` — Project vision, constraints
- `.planning/REQUIREMENTS.md` — MOD5-01 through MOD6-06 requirements
- `.planning/ROADMAP.md` — Phase 3 success criteria
- `CLAUDE.md` — Module structure template, tool split
- `HANDOFF.md` — Module 5-6 content specifications

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Existing Helm chart at `reference-app/helm/` — Module 5a Track A lab builds on this as a teaching example
- Existing CI/CD at `.github/workflows/ci.yml` — Module 5a Track B lab uses as reference
- Existing Prometheus values at `infrastructure/helm/prometheus-lab-values.yaml` — GSD lab extends this
- Phase 2 Docusaurus structure — all new content follows the same MDX + _category_.json pattern

### Established Patterns
- MDX with frontmatter for sidebar positioning
- Collapsible `<details>` blocks for expected outputs and answers
- "Context engineering" vocabulary (no "prompt engineering")
- Real systems first, mock as labeled fallback

### Integration Points
- Module 5a labs use the reference app as the target for Helm chart / CI/CD pipeline
- Module 5b GSD lab builds monitoring for the reference app on KIND
- Module 6 Track A needs AWS free-tier Terraform against real or mock resources
- Module 6 Track B installs ArgoCD on KIND and deploys the reference app via GitOps

</code_context>

<specifics>
## Specific Ideas

- The GSD lab builds monitoring for the SAME reference app from Phase 1 — participants already know the system they're monitoring
- Guided generation means the lab provides the context/prompts that participants feed to Claude Code/OpenCode — they see how structured input produces quality IaC
- ArgoCD is back for Module 6 Track B specifically — this is the one place where GitOps tooling is taught hands-on
- Module 5b covers the "meta-skills" — how to use AI tools effectively (GSD, memory, plans, context engineering). These are the skills participants use for the rest of the course.

</specifics>

<deferred>
## Deferred Ideas

- Argo Workflows track (D-41) — explicitly dropped from Module 6
- Advanced multi-model orchestration — v2 content

</deferred>

---

*Phase: 03-day-2-modules*
*Context gathered: 2026-04-04*
