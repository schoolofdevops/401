# Capstone Project Selection Criteria

Evaluate your top 3 automation candidates for the Day 3 capstone.

Rate each criterion: **Yes** (fully meets), **Partial** (meets with workarounds), or **No** (does not meet).

| Criterion | Candidate 1: ___ | Candidate 2: ___ | Candidate 3: ___ |
|-----------|------------------|------------------|------------------|
| Decomposable into discrete steps? | Yes / Partial / No | Yes / Partial / No | Yes / Partial / No |
| Tools accessible via CLI/API? | Yes / Partial / No | Yes / Partial / No | Yes / Partial / No |
| Clear success/failure criteria? | Yes / Partial / No | Yes / Partial / No | Yes / Partial / No |
| Safe with approval gates? | Yes / Partial / No | Yes / Partial / No | Yes / Partial / No |
| Testable with mock data? | Yes / Partial / No | Yes / Partial / No | Yes / Partial / No |

**Scoring:** 3 pts for Yes, 1 pt for Partial, 0 pts for No. Max = 15.

| | Candidate 1 | Candidate 2 | Candidate 3 |
|--|-------------|-------------|-------------|
| Total (out of 15) | | | |

---

## Selected Capstone Task

**Task name:** _______________

**Score on selection criteria:** ___ / 15

**Why this task:** (3 sentences — what the task is, why it scores well, and what the agent would deliver)

1. _______________
2. _______________
3. _______________

---

## Agent Design (Draft)

**Tools the agent would need:**
- Tool 1: _______ (e.g., `aws cloudwatch describe-alarms`)
- Tool 2: _______ (e.g., `git log`)
- Tool 3: _______ (e.g., Jira API - create issue)

**Domain context the agent would need (future SKILL.md):**
- Runbook: _______
- Infrastructure topology: _______
- Decision criteria: _______

**Governance — what requires human approval:**
- _______

**Mock data needed for lab testing:**
- _______

---

## Criteria Reference

| Criterion | Good Example | Bad Example |
|-----------|-------------|-------------|
| Decomposable | "Triage alert: read alarm → check deployments → follow runbook → create ticket" | "Use good judgment about the infrastructure" |
| Tool accessible | AWS CLI, kubectl, git, REST API | Data locked in GUI-only tool with no API |
| Clear success/failure | "Alert is resolved / no new SEV-1 created" | "Infrastructure is healthy" |
| Safe with approval gates | "Agent drafts rollback command, engineer approves" | "Agent has unrestricted production access" |
| Testable with mock data | CloudWatch JSON fixtures, mock kubectl output | Requires live prod queries to function at all |
