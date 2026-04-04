# Phase 3: Day 2 Modules - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.

**Date:** 2026-04-04
**Phase:** 03-day-2-modules
**Areas discussed:** Module 5 scope, Module 6 tracks, GSD lab design, Lab complexity

---

## Module 5 Scope

| Option | Description | Selected |
|--------|-------------|----------|
| One big module | All 7 topics in Module 5 | |
| Split Module 5 | 5a (Structured Coding tracks) + 5b (AI Workflows) | ✓ |
| You decide | Claude organizes | |

**User's choice:** Split into 5a and 5b

---

## Module 6 Tracks

### Track model
| Option | Description | Selected |
|--------|-------------|----------|
| Choose one | Participant picks one track per module | ✓ |
| Do all tracks | Complete all sequentially | |
| Required + elective | One mandatory + electives | |

**User's choice:** Choose one. Skip Argo Workflows entirely. Module 5: Track A (Helm) or Track B (CI/CD). Module 6: Track A (Terraform) or Track B (K8s+GitOps).

### ArgoCD for Track B
| Option | Description | Selected |
|--------|-------------|----------|
| ArgoCD for Track B | Override D-06 for this specific lab | ✓ |
| Flux CD | Lighter alternative | |
| No GitOps tool | kubectl + kustomize via CI | |

**User's choice:** ArgoCD back for Module 6 Track B specifically

---

## GSD Lab Design

### Project
| Option | Description | Selected |
|--------|-------------|----------|
| Monitoring stack | Prometheus alerts + Grafana dashboards for the reference app | ✓ |
| K8s network policy | Security-focused, K8s manifests | |
| You decide | Claude picks | |

**User's choice:** Monitoring stack for the reference app
**Notes:** "you can use the sample app created earlier and build monitoring for that"

### Depth
| Option | Description | Selected |
|--------|-------------|----------|
| Full cycle | new-project → discuss → plan → execute → verify | ✓ |
| Plan + execute | Skip new-project/discuss, give pre-built context | |
| You decide | Claude balances | |

**User's choice:** Full GSD cycle

---

## Lab Complexity

| Option | Description | Selected |
|--------|-------------|----------|
| Starter + solution | Partially filled with TODOs | |
| From scratch + AI | Generate from scratch using AI | |
| Guided generation | Lab gives specific prompts/context, AI produces output | ✓ |

**User's choice:** Guided generation with solution files for comparison

---

## Claude's Discretion
- Prometheus alerting rules + Grafana configs for GSD lab
- Guided generation prompt structure per track
- Memory systems MCP recommendation for OpenCode
- Superpowers exploratory depth

## Deferred Ideas
- Argo Workflows track (explicitly dropped)
