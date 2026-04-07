# Phase 5: Module Consolidation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-07
**Phase:** 05-module-consolidation
**Areas discussed:** Lab track structure, Superpowers depth, Content migration, Module 5 IaC project

---

## Lab Track Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Keep all 4 tracks | Participants choose one of Helm, CI/CD, Terraform, or ArgoCD | |
| 2 tracks (K8s + IaC) | Track A: K8s (Helm+ArgoCD), Track B: Cloud IaC (Terraform+CI/CD) | ✓ |
| 1 unified project | Everyone does the same IaC project | |

**User's choice:** 2 tracks (K8s + IaC)

| Option | Description | Selected |
|--------|-------------|----------|
| Single 90-min lab per track | One continuous lab walking through all Superpowers | ✓ |
| 2 x 45-min labs per track | Part 1: Brainstorm+TDD, Part 2: Debug+Verify+Review | |

**User's choice:** Single 90-min lab per track

---

## Superpowers Depth

| Option | Description | Selected |
|--------|-------------|----------|
| Full cycle in lab | ALL 5 Superpowers in sequence: brainstorm → TDD → implement → debug → verify+review. 15-20 min each. | ✓ |
| Core 3 + optional 2 | Brainstorm, TDD, verification required. Debugging and code review exploratory. | |
| Showcase approach | Brief demo of each, then deep application of 1-2 | |

**User's choice:** Full cycle in lab

| Option | Description | Selected |
|--------|-------------|----------|
| Plant a real failure | Intentional bug in starter code for debugging exercise | |
| Use generation errors | AI-generated IaC naturally has errors — use those as debugging material | ✓ |
| Both | Plant + generation errors | |

**User's choice:** Use generation errors
**Notes:** User also noted: "we may not even need starter code and let superpowers write it?" — this led to D-10 (no starter code).

---

## Content Migration

| Option | Description | Selected |
|--------|-------------|----------|
| Rewrite from scratch | New reading + quiz for both modules | |
| Merge + edit | Take best from 5a, 5b, old 6. Restructure. | |
| Keep 5b as-is, rewrite 5 | Module 6 (was 5b) keeps existing content. Only Module 5 rewritten. | ✓ |

**User's choice:** Keep 5b as-is, rewrite 5

---

## Module 5 IaC Project

| Option | Description | Selected |
|--------|-------------|----------|
| Helm chart for reference app | Build production Helm chart from scratch using Superpowers. Deploy to KIND. | ✓ |
| ArgoCD GitOps setup | Set up ArgoCD Application CRDs | |
| Helm + ArgoCD combined | Both Helm chart and ArgoCD Application CRD | |

**User's choice:** Helm chart for reference app (Track A)

| Option | Description | Selected |
|--------|-------------|----------|
| Terraform module (EC2+monitoring) | Build EC2+CloudWatch+SNS from scratch. TDD with mock_provider. | ✓ |
| GitHub Actions pipeline | Build CI/CD pipeline from scratch | |
| Terraform + CI/CD combined | Both Terraform module and pipeline | |

**User's choice:** Terraform module (Track B)

---

## Claude's Discretion

- TDD framework choices for Helm and Terraform validation
- Reading material structure and quiz design
- Exploratory project organization
- Sidebar configuration

## Deferred Ideas

None — discussion stayed within phase scope
