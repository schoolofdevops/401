# Phase 1: Foundation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-04
**Phase:** 01-foundation
**Areas discussed:** App design, K8s topology, Mock data scope, Provider setup

---

## App Design

### App Domain
| Option | Description | Selected |
|--------|-------------|----------|
| Order system | API gateway + order service + inventory service + PostgreSQL | |
| Observability app | Metrics collector + alert processor + dashboard API + PostgreSQL | |
| Task/ticket system | API + worker + notification service + PostgreSQL | |
| Other (user) | Dashboard app with health/version display, graceful degradation, tests for CI/CD | ✓ |

**User's choice:** Custom — dashboard showing service health, connectivity, version info. Graceful degradation. Tests for CI/CD. Learning-focused but realistic.

### Tech Stack
| Option | Description | Selected |
|--------|-------------|----------|
| Go + React | Go backends, React dashboard | |
| Python + React | FastAPI/Flask backends, React dashboard | |
| Node + React | Express/Fastify backends, React dashboard | |
| Other (user) | Svelte + Rust | ✓ |

**User's choice:** Svelte frontend + Rust backend services

### Frontend Framework
| Option | Description | Selected |
|--------|-------------|----------|
| Svelte | Lighter, faster builds, simpler | ✓ |
| React | Larger ecosystem, more recognized | |

**User's choice:** Svelte

### Service Architecture
| Option | Description | Selected |
|--------|-------------|----------|
| API + Worker + DB | Classic 3-tier with async patterns | |
| API + Catalog + Orders | E-commerce-flavored | |
| You decide | Claude picks services for K8s teaching value | ✓ |

**User's choice:** Claude's discretion — optimize for K8s patterns

---

## K8s Topology

### Infrastructure Scope
| Option | Description | Selected |
|--------|-------------|----------|
| Full stack | Multi-node KIND + ArgoCD + Argo Workflows + monitoring | |
| Progressive | Basic KIND, add tools in Module 5-6 labs | |
| Two configs | Minimal for Day 1, full for Day 2 | |
| Other (user) | Skip ArgoCD (too heavy). Prometheus + Datadog both as options. | ✓ |

**User's choice:** Skip ArgoCD entirely. Prometheus+Grafana on KIND as default. Datadog free tier as documented alternative.
**Notes:** User explicitly said ArgoCD makes infra too heavy for a training course.

### Observability
| Option | Description | Selected |
|--------|-------------|----------|
| Both options | Prometheus+Grafana default, Datadog alternative | ✓ |
| Prometheus only | No SaaS dependency | |
| You decide | Claude picks | |

**User's choice:** Both options — Prometheus+Grafana pre-installed, Datadog documented as alternative.

---

## Mock Data Scope

### AWS Services Needing Mock Data
| Option | Description | Selected |
|--------|-------------|----------|
| CloudWatch alarms | Module 1 context engineering exercises | ✓ |
| Cost Explorer | Module 2 cost analysis lab | ✓ |
| RDS Perf Insights | Database agent labs — but real PostgreSQL on KIND may replace | |
| EC2 instances | Module 2 EC2 metadata exploration | ✓ |

**User's choice:** CloudWatch, Cost Explorer, EC2. Skip RDS mock — real PostgreSQL on KIND replaces it.

### Mock Data Format
| Option | Description | Selected |
|--------|-------------|----------|
| Static JSON files | Pre-built JSON matching AWS CLI output | ✓ |
| Generator scripts | Bash/Python generating configurable scenarios | |
| Both | Static default, generators optional | |

**User's choice:** Static JSON files

---

## Provider Setup

### Documentation Depth
| Option | Description | Selected |
|--------|-------------|----------|
| Claude Code deep | Full Claude Code, brief others | |
| Two paths equal | Full guides for both primary tools | ✓ |
| Minimal | Claude Code only, alternatives in appendix | |
| Other (user) | Two equal paths: Claude Code and OpenCode. No Crush. | ✓ |

**User's choice:** Two equal paths — Claude Code and OpenCode. Explicitly NO Crush. Override research finding about OpenCode being archived.
**Notes:** User made a deliberate decision to use OpenCode despite research suggesting it was archived. The course uses Claude Code vs OpenCode as the two options.

---

## Claude's Discretion

- Specific Rust backend service architecture (optimized for K8s teaching patterns)

## Deferred Ideas

None — discussion stayed within phase scope.
