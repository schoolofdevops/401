# Phase 1: Foundation - Context

**Gathered:** 2026-04-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the reference microservices application and all shared infrastructure that unblocks every module lab in the course. This includes: the app itself (Svelte dashboard + Rust backend services + PostgreSQL on KIND), participant setup guide with environment verification, mock data for AWS services (fallback only), and multi-provider LLM setup documentation for both Claude Code and OpenCode paths.

</domain>

<decisions>
## Implementation Decisions

### Reference Application Design
- **D-01:** The app is a microservices system with a **Svelte dashboard frontend** and **Rust backend services** + PostgreSQL, all running on KIND.
- **D-02:** The dashboard must show: service health/connectivity status, version info for each service, and graceful degradation when backends are unavailable (show degraded state, not crash).
- **D-03:** The app must include **tests** (unit + integration) to power the CI/CD pipeline labs in Modules 5-6.
- **D-04:** Version display must update visibly on deploy — participants can SEE when their CI/CD pipeline works.
- **D-05:** Participants do NOT modify Rust code directly — they interact via APIs, Helm charts, K8s manifests, CI/CD pipelines.

### Claude's Discretion: Service Architecture
- Claude designs the specific 2-3 Rust backend services. Optimize for:
  - Demonstrating K8s patterns (health checks, inter-service dependencies, scaling, graceful degradation)
  - Generating real PostgreSQL queries that database agents can investigate
  - Natural scaling challenges and failure modes for observability labs

### Kubernetes Topology
- **D-06:** KIND cluster with the reference app deployed. No ArgoCD — too heavy for local setup. GitOps concepts taught without it.
- **D-07:** **Prometheus + Grafana** pre-installed on KIND as the default observability stack. Agents can query Prometheus API directly.
- **D-08:** **Datadog free tier** documented as an alternative observability path for participants who want SaaS experience. Both paths supported.
- **D-09:** Basic KIND config for Day 1. Module 5-6 labs may add complexity (monitoring, scaling) as part of the learning progression.

### Mock Data
- **D-10:** Mock data for AWS services as **fallback only** — clearly labeled, realistic format matching current AWS CLI output.
- **D-11:** Three AWS services get mock data: **CloudWatch alarms**, **Cost Explorer**, **EC2 instances**.
- **D-12:** NO mock RDS data — real PostgreSQL on KIND replaces this. Database agents query the live DB.
- **D-13:** Format: **static JSON files** with source-and-date comments. Both clean and noisy/anomaly scenarios included.

### Provider Setup
- **D-14:** Two equal paths documented with full setup guides: **Claude Code** (Claude Pro/Team subscription) and **OpenCode** (with free providers: Gemini, Groq, OpenRouter, Grok).
- **D-15:** NO Crush — the course uses Claude Code and OpenCode only. Override research finding about OpenCode being archived.
- **D-16:** Labs show expected outputs for BOTH paths. Not Claude Code screenshots only.

### Folded Todos
None.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project Context
- `.planning/PROJECT.md` — Project vision, constraints, core value
- `.planning/REQUIREMENTS.md` — FOUND-01 through FOUND-08 requirements for this phase
- `.planning/ROADMAP.md` — Phase 1 success criteria and plan breakdown

### Research
- `.planning/research/STACK.md` — Technology stack recommendations (note: Crush recommendation overridden — use OpenCode instead)
- `.planning/research/ARCHITECTURE.md` — Repo structure, build order, component boundaries
- `.planning/research/PITFALLS.md` — Setup guide and mock data pitfalls to avoid
- `.planning/research/SUMMARY.md` — Synthesized research findings

### Course Structure
- `CLAUDE.md` — Module structure template, tool split, constraints
- `HANDOFF.md` — Module-by-module content breakdown, cross-repo responsibilities

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `setup/install-hermes.md` — Existing Hermes install guide (for later modules, not Phase 1)
- `skills/sre-ec2-health-check/SKILL.md` — Existing SRE skill example (for Module 7 reference)

### Established Patterns
- No established code patterns yet — this is the first phase, greenfield

### Integration Points
- The reference app deployed here will be used in: Module 5 (Helm/CI/CD labs), Module 6 (IaC tracks), and hermes-agent Module 10 (agent builds against the app's PostgreSQL)
- Mock data created here will be consumed by: Module 1 (CloudWatch alarm for context engineering), Module 2 (Cost Explorer, EC2 exploration)
- Setup guide created here gates ALL subsequent module labs

</code_context>

<specifics>
## Specific Ideas

- Dashboard should be "nice looking" — not a bare HTML page. The UI itself is a teaching tool showing that the system is working.
- Version info visible from the frontend — when a new version deploys, it's immediately visible. This is the proof that CI/CD works.
- Graceful degradation is important — when a backend service is down, the dashboard shows degraded state, not a crash. This connects to the agent patterns (agents detect and respond to degradation).
- The app is built with learning in mind, not production complexity. It should be realistic but not overwhelming.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-foundation*
*Context gathered: 2026-04-04*
