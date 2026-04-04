# Phase 2: Day 1 Modules - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-04
**Phase:** 02-day-1-modules
**Areas discussed:** Module 1 lab, Content depth, Module 2 scope, Module 3-4 format

---

## Module 1 Lab

### Aha Moment Structure
| Option | Description | Selected |
|--------|-------------|----------|
| Progressive layers | 4 iterations on same alarm: bare → SRE role → topology → runbook | ✓ |
| Before/after only | Two shots: bad vs good | |
| Participant builds | Give data, let participants construct own context | |

**User's choice:** Progressive layers — 4 iterations with side-by-side at end.
**Notes:** Must work with real CloudWatch alarms AND mock data. Real first, mock fallback.

### Lab Tool
| Option | Description | Selected |
|--------|-------------|----------|
| Claude Code / OpenCode | Paste context + alarm into AI tool directly | ✓ |
| Script-driven | Bash scripts calling LLM API | |
| Both paths | Hands-on primary, scripts backup | |

**User's choice:** Claude Code / OpenCode directly

---

## Content Depth

### Theory Depth
| Option | Description | Selected |
|--------|-------------|----------|
| Practical focus | Minimal theory | |
| Solid foundation | Inference pipeline, attention, token economics | ✓ |
| You decide | Claude calibrates | |

**User's choice:** Solid foundation — DevOps practitioners appreciate knowing HOW things work

### Analogy Density
| Option | Description | Selected |
|--------|-------------|----------|
| Every concept | Systematic mapping table | |
| Key concepts | Major concepts get analogies, minor get plain | ✓ |
| You decide | Claude uses where genuine | |

**User's choice:** Key concepts only — avoid forced analogies

### Content Platform
| Option | Description | Selected |
|--------|-------------|----------|
| Full Docusaurus | Initialize project, sidebars, MDX, deployable site | ✓ |
| Docusaurus-ready | MDX format but defer project setup | |
| You decide | Claude picks balance | |

**User's choice:** Full Docusaurus — NEW requirement added mid-discussion

---

## Module 2 Scope

### AWS Features
| Option | Description | Selected |
|--------|-------------|----------|
| CloudWatch anomaly | Free tier, lab exercise | ✓ |
| Cost Explorer | Mock fallback for those without billing history | ✓ |
| Q Developer | Platform AI comparison | ✓ |
| DevOps Guru | Operational insights | ✓ |

**User's choice:** All four — free tier as lab, paid as demo/walkthrough
**Notes:** "whatever is free tier, we include as lab, if its not free tier, we show as demo"

---

## Module 3-4 Format

### Module 3 Format
| Option | Description | Selected |
|--------|-------------|----------|
| Live demo script | Facilitator runs while participants watch | |
| Guided walkthrough | Participants install and run Hermes themselves | ✓ |
| Video + reading | Pre-recorded for Udemy, live for workshop | |

**User's choice:** Guided walkthrough — facilitator demos first, then participants do hands-on
**Notes:** "Facilitator first can do live demo. followed by that, participants do the labs and try it themselves, thats how they learn"

### Module 4 Scoring
| Option | Description | Selected |
|--------|-------------|----------|
| Spreadsheet template | CSV/markdown table, solo-completable | ✓ |
| Interactive exercise | Facilitated brainstorm + individual scoring | |
| You decide | Claude designs format | |

**User's choice:** Spreadsheet template — solo-completable

---

## Claude's Discretion

- Docusaurus theme and configuration
- Sidebar organization
- Which DevOps concepts get analogies
- Module 2 free tier verification
- Module 3 specific Hermes demo scenario

## Deferred Ideas

None — discussion stayed within phase scope.
