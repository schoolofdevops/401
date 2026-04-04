---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: milestone
status: Ready to plan
stopped_at: Completed 01-foundation/01-04-PLAN.md
last_updated: "2026-04-04T17:14:56.176Z"
progress:
  total_phases: 4
  completed_phases: 1
  total_plans: 4
  completed_plans: 4
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-04)

**Core value:** DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering is THE skill that makes agents useful.
**Current focus:** Phase 01 — foundation

## Current Position

Phase: 2
Plan: Not started

## Performance Metrics

**Velocity:**

- Total plans completed: 0
- Average duration: -
- Total execution time: 0.0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| - | - | - | - |

**Recent Trend:**

- Last 5 plans: none yet
- Trend: -

*Updated after each plan completion*
| Phase 01 P02 | 3 | 2 tasks | 5 files |
| Phase 01-foundation P01 | 11 | 2 tasks | 13 files |
| Phase 01-foundation P03 | 8min | 3 tasks | 30 files |
| Phase 01-foundation P04 | 6min | 3 tasks | 3 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- [Roadmap]: Labs-first strategy confirmed — every module: LAB.md + starter/solution before reading or quiz
- [Roadmap]: FOUND-01 through FOUND-04 (reference app, Helm chart, CI/CD, ArgoCD) all land in Phase 1 because they are prerequisites for Module 5 and 6 labs
- [Roadmap]: OpenCode replaced by Crush (charmbracelet/crush) everywhere — OpenCode archived Sept 18, 2025
- [Roadmap]: LocalStack treated as optional stretch only — community edition EOL'd March 2026
- [Phase 01]: _metadata pattern established for mock JSON files: source, format_date, aws_cli_version, note fields required
- [Phase 01]: Banner output moved to stderr in mock-aws — diagnostic output belongs on stderr so stdout JSON is pipeable
- [Phase 01]: EC2 mock data given own ec2/ directory instead of cost-explorer/ for service-based organization
- [Phase 01-foundation]: Runtime sqlx::query (not macros) chosen to avoid DATABASE_URL at compile time — lower setup friction for course
- [Phase 01-foundation]: axum 0.8 path syntax is {id} not :id — updated in catalog route
- [Phase 01-foundation]: PgPool::connect_lazy for unit test fake pools — services testable without live database
- [Phase 01-foundation]: No ArgoCD in CI/CD — pipeline does direct helm upgrade; GitOps taught conceptually in later modules (D-06)
- [Phase 01-foundation]: Svelte 5 runes pattern: polling in $effect with cleanup, AbortSignal.timeout(3000) mandatory for health dashboard
- [Phase 01-foundation]: nginx proxy pattern: /api-gateway/*, /catalog/*, /worker/* map to K8s service DNS hostnames
- [Phase 01-foundation]: D-14 honored: Claude Code and OpenCode documented as two equal paths in SETUP.md, verify.sh, and llm-access.md
- [Phase 01-foundation]: D-15 honored: OpenCode refers to sst/opencode from opencode.ai, not archived opencode-ai/opencode
- [Phase 01-foundation]: D-08 honored: Datadog free tier documented as optional alternative observability in SETUP.md Step 7
- [Phase 01-foundation]: January 2026 Anthropic OAuth block documented in SETUP.md and llm-access.md per ROADMAP success criteria 4

### Pending Todos

None yet.

### Blockers/Concerns

- [Phase 3] Module 6 Track A/C solution file naming must be coordinated with hermes-agent/course/modules/module-10/starter/ before finalizing — check hermes-agent repo at start of Phase 3
- [Phase 1] Mock data format must match real AWS CLI output — verify one file per service against live aws cli before delivery
- [Phase 4] Module 11 solo fallback (fleet lab) requires three pre-built reference agents from hermes-agent repo — confirm availability before finalizing Module 11 content

## Session Continuity

Last session: 2026-04-04T16:59:35.341Z
Stopped at: Completed 01-foundation/01-04-PLAN.md
Resume file: None
