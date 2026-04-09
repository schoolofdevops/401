---
phase: 12-new-module-11-track-c-triggers-lab
plan: 01
subsystem: module-11-triggers/lab
tags: [track-c, triggers, kubernetes, cron, alertmanager, cronjob, github-webhook, telegram]
dependency_graph:
  requires: []
  provides: [LAB-track-c-kubernetes.mdx]
  affects: [module-11-triggers]
tech_stack:
  added: []
  patterns: [track-specific-lab, real-infrastructure-only, self-contained-setup]
key_files:
  created:
    - course-site/docs/module-11-triggers/lab/LAB-track-c-kubernetes.mdx
  modified: []
decisions:
  - "AlertManager setup self-contained within lab (Helm upgrade + PrometheusRule apply) rather than assumed from prior module"
  - "Zero mock-mode references -- all commands run against real KIND cluster"
  - "Solo Learner fallback for GitHub webhook uses bundled sample-pr-payload.json with --deliver local"
metrics:
  duration: "4 minutes"
  completed: "2026-04-09T17:24:46Z"
---

# Phase 12 Plan 01: Create LAB-track-c-kubernetes.mdx Summary

Dedicated Track C triggers lab covering 5 trigger types (Hermes cron, AlertManager webhook, K8s CronJob, GitHub webhook, Telegram bot) using real KIND infrastructure with zero mock-mode references.

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | Create LAB-track-c-kubernetes.mdx with all 5 trigger types | fedb432 | course-site/docs/module-11-triggers/lab/LAB-track-c-kubernetes.mdx |

## What Was Built

The new Track C triggers lab (826 lines) provides a complete 90-minute hands-on experience:

**Guided Phase (70 min):**
- **Step 1: Hermes Cron (10 min)** -- Daily K8s health check with create, trigger, pause, resume lifecycle
- **Step 2: AlertManager (20 min)** -- Self-contained Prometheus stack setup, PrometheusRule for PodCrashLooping, gateway subscription, live crashloop scenario with expected timeline
- **Step 3: K8s CronJob (15 min)** -- Docker build, KIND load, CronJob manifest apply, log viewing, with "Hermes cron when vs K8s CronJob when" teaching point
- **Step 4: GitHub Webhook (15 min)** -- smee.io channel, GitHub PAT, gateway+smee-client, webhook subscription with github_comment delivery, Solo Learner fallback
- **Step 5: Telegram Bot (10 min)** -- @BotFather setup, @userinfobot ID, gateway with Telegram adapter, /help and /diagnose commands

**Free Explore Phase (20 min):**
- Challenge 1: Cross-namespace cron (kube-system + default)
- Challenge 2: AlertManager to Telegram notification chain
- Challenge 3: GitHub PR triggers full diagnosis and posts report

## Critical Constraints Enforced

All zero-count constraints verified:
- 0 `HERMES_LAB_MODE` references
- 0 `MOCK_DATA_DIR` references
- 0 `HERMES_LAB_TRACK` references
- 0 `HERMES_LAB_SCENARIO` references
- 0 `HERMES_LAB_GOVERNANCE` references
- 0 `infrastructure/wrappers` references
- 0 `[MOCK MODE]` output references

## Deviations from Plan

None -- plan executed exactly as written.

## Known Stubs

None -- all content is complete and functional.

## Self-Check: PASSED
