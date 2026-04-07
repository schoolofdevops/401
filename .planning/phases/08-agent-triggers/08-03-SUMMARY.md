---
phase: 08-agent-triggers
plan: "03"
subsystem: course-content
tags: [lab-extension, module-12, alertmanager, k8s-cronjob, github-webhook, telegram-bot, triggers, quiz, reference]

# Dependency graph
requires:
  - phase: 08-agent-triggers
    plan: 01
    provides: "AlertManager/CronJob infrastructure files (prometheus-rules.yaml, alertmanager-config.yaml, Dockerfile, agent-health-check.yaml)"
  - phase: 08-agent-triggers
    plan: 02
    provides: "GitHub/Telegram infrastructure files (smee-setup.sh, sample-pr-payload.json, agent-prompt-template.txt, slash-command-spec.md)"
  - phase: 07-guardrails-governance
    provides: "HERMES_LAB_GOVERNANCE env var pattern, wrapper enforcement"
provides:
  - "Module 12 lab with 8 new GUIDED steps (Steps 9-16) covering all 4 Phase 8 trigger types"
  - "Module 12 reference.mdx with 6-row trigger comparison table and Phase 8 env var documentation"
  - "Module 12 quiz with 3 new questions on cron tradeoffs, AlertManager flow, and governance inheritance"
affects: [09-multi-agent]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Lab extend-over-rewrite pattern (same as Phase 5/6/7)"
    - "MDX admonitions vs MD blockquotes dual-mirror sync"
    - "Complete export block in every new step (Phase 7 D-05 extended for Phase 8)"
    - "Solo Learner callout pattern for external service dependencies"
    - "Per-track variant callouts (Track A/B/C) for slash commands and CronJob"

key-files:
  modified:
    - course-site/docs/module-12-triggers/lab/LAB.mdx
    - modules/module-12-triggers/LAB.md
    - course-site/docs/module-12-triggers/reading/reference.mdx
    - course-site/docs/module-12-triggers/quiz/QUIZ.mdx

key-decisions:
  - "Steps 9-16 inserted before FREE EXPLORE PHASE per D-21 exact ordering"
  - "Lab duration header updated to 145 min (120 guided + 25 free explore)"
  - "GUIDED PHASE header bumped from 50 to 120 minutes"
  - "Closing and Verification Checklist extended (not rewritten) with Phase 8 additions"
  - "reference.mdx gets Section 6 (comparison table) and Section 7 (env vars) appended after existing Section 5"
  - "Quiz question numbers 7/8/9 (file had 6 existing questions)"
  - "Solo Learner callouts present for TRIG-01 (no KIND), TRIG-03 (no GitHub repo), and TRIG-04 (@BotFather setup)"
  - "Telegram polling conflict WARNING admonition in Step 14 per RESEARCH Pitfall 4"

requirements-completed:
  - TRIG-01
  - TRIG-02
  - TRIG-03
  - TRIG-04

# Metrics
duration: 10min
completed: 2026-04-07T13:59:30Z
---

# Phase 8 Plan 03: Module 12 Lab Extension (Steps 9-16) Summary

**Module 12 lab extended from 8 to 16 GUIDED steps — all 4 Phase 8 trigger types now have participant-facing walkthroughs: AlertManager webhook, K8s CronJob, GitHub webhook via smee.io, and Telegram bot slash commands**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-04-07T13:49:32Z
- **Completed:** 2026-04-07T13:59:30Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments

- Extended `course-site/docs/module-12-triggers/lab/LAB.mdx` from 685 to 1307 lines (8 new GUIDED steps + Closing/Checklist extensions)
- Extended `modules/module-12-triggers/LAB.md` from 657 to 1249 lines (same 8 steps, plain markdown mirror)
- All existing Steps 1-8 untouched; FREE EXPLORE Challenges 1-3 untouched
- Every new step includes complete Phase 7 + Phase 8 export block per D-05/D-26
- Solo Learner callouts for all three external-service-dependent steps (KIND/AlertManager, GitHub PAT, Telegram)
- Step 11 includes "Use Hermes cron when / Use K8s CronJob when" comparison callout per D-10
- Step 14 includes Telegram polling conflict WARNING per RESEARCH Pitfall 4
- Step 16 demonstrates per-process governance (L4 restart) and explains why per-message escalation is not possible
- Updated `course-site/docs/module-12-triggers/reading/reference.mdx` with 2 new sections (6-row trigger comparison table + Phase 8 env var table with acquisition notes)
- Appended 3 new questions to `course-site/docs/module-12-triggers/quiz/QUIZ.mdx` (Q7: cron tradeoffs, Q8: AlertManager troubleshooting, Q9: governance inheritance)

## Task Commits

1. **Task 1: Module 12 lab extension (Steps 9-16)** — `aea68a3` (feat)
2. **Task 2: reference.mdx and QUIZ.mdx updates** — `383b2e9` (feat)

## Files Modified

- `course-site/docs/module-12-triggers/lab/LAB.mdx` — 685 → 1307 lines (+622 net); 8 new GUIDED steps + Closing/Checklist updates
- `modules/module-12-triggers/LAB.md` — 657 → 1249 lines (+592 net); same 8 steps as mirror
- `course-site/docs/module-12-triggers/reading/reference.mdx` — 224 → 291 lines (+67); Sections 6 and 7 appended
- `course-site/docs/module-12-triggers/quiz/QUIZ.mdx` — 201 → 309 lines (+108); Questions 7-9 appended

## Decisions Made

- **Step ordering exactly as D-21:** 9=AlertManager setup, 10=AlertManager fire+observe, 11=K8s CronJob comparison, 12=GitHub webhook setup, 13=GitHub agent comment back, 14=Telegram bot setup, 15=Telegram /diagnose, 16=Telegram governance escalation
- **Solo Learner callouts:** Step 9 (no KIND → skip to Step 12), Step 12 (no GitHub → use bundled payload fallback), Step 14 (2 min setup time, no payment needed)
- **{alerts} not {alerts[0]}:** All new lab text uses `{alerts}` (full JSON array) — anti-pattern absent in all 4 modified files
- **Quiz numbering:** Existing file had Questions 1-6; new questions are 7, 8, 9 (not renumbered)
- **Reference sections:** Existing file had 5 sections; Phase 8 appends Sections 6 and 7 (no renumbering of existing sections)
- **Closing extended not rewritten:** Added 4 bullets to "What you built" and 6 commands to "Key commands reference"
- **Verification Checklist extended:** Added checks 7-13 for Phase 8 artifacts (AlertManager pods, PrometheusRule, CronJob image, smee-setup.sh, JSON validity, telegram dep)

## Deviations from Plan

None — plan executed exactly as written. All content from the task action blocks was implemented verbatim. The only discretionary choices made were:

1. Used `:::tip` (MDX) / `> **Tip:**` (MD) for the "Use Hermes cron when / K8s CronJob when" callout per D-10 — tip admonition fits better than info for an advisory comparison.
2. Step 9 Prometheus UI URL is `http://localhost:30091` (from Phase 1 NodePort) and AlertManager UI URL is `http://localhost:30093` (from Phase 8 Plan 01 addition) — referenced the exact ports that infrastructure plans established.
3. Section 6 in reference.mdx uses "Yes" / "No" instead of checkmarks for the comparison table rows, since plain text is more portable than Unicode.

## Known Stubs

None — all new lab steps reference real files shipped by Plans 08-01 and 08-02. No placeholder content or hardcoded empty values.

## Self-Check: PASSED

Files verified on disk:
- course-site/docs/module-12-triggers/lab/LAB.mdx — FOUND (1307 lines)
- modules/module-12-triggers/LAB.md — FOUND (1249 lines)
- course-site/docs/module-12-triggers/reading/reference.mdx — FOUND (291 lines)
- course-site/docs/module-12-triggers/quiz/QUIZ.mdx — FOUND (309 lines)

Commits verified:
- aea68a3 — feat(08-03): extend Module 12 lab with 8 new GUIDED steps 9-16 for Phase 8 triggers
- 383b2e9 — feat(08-03): update Module 12 reference and quiz for Phase 8 triggers

Key invariants confirmed:
- 16 GUIDED steps in both lab mirrors
- Steps 1-8 intact in both files
- FREE EXPLORE PHASE present in both files
- 3 challenges present in both files
- {alerts[0]} anti-pattern absent in all 4 files
- GITHUB_TOKEN, TELEGRAM_BOT_TOKEN, TELEGRAM_ALLOWED_USERS, SMEE_URL present in both lab files and reference.mdx
- @BotFather and @userinfobot referenced in both lab mirrors and reference.mdx
- Use Hermes cron when / Use K8s CronJob when present in LAB.mdx
- github_comment delivery type referenced in LAB.mdx
- 9 total quiz questions (6 original + 3 new)
