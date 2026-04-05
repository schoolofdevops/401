# Udemy Course Structure — Agentic DevOps

**Course title:** Agentic DevOps: Building Agentic Skills for Infrastructure Automation
**Format:** Self-paced online course
**Target:** Top-selling Agentic DevOps course on Udemy
**Learner:** DevOps practitioners with zero AI/LLM knowledge

> **Note on video production:** Video recording is out of scope for the initial content build (V2-01). This document maps the structural outline for future recording. Each section lists content types, estimated video length, and downloadable resources.

---

## Course Map: 14 Modules → 15 Udemy Sections

| Udemy Section | Module | Title | Lab Tracks |
|--------------|--------|-------|-----------|
| Section 1 | Module 1 | AI Foundations for Operations | Single track |
| Section 2 | Module 2 | Platform AI — Features in Your Stack | AWS or mock path |
| Section 3 | Module 3 | From Platform AI to Custom Agents | Demo + hands-on |
| Section 4 | Module 4 | Impact Assessment | Solo exercise |
| Section 5 | Module 5a | Structured AI Coding | Track A (Helm) or B (CI/CD) |
| Section 6 | Module 5b | AI Workflows and GSD | Single track |
| Section 7 | Module 6 | AI-Assisted IaC | Track A (Terraform) or B (GitOps) |
| Section 8 | Module 7 | Agent Skills — Teaching Agents Runbooks | 4 domain tracks |
| Section 9 | Module 8 | Wiring Tools to Agents | Single track |
| Section 10 | Module 9 | Agent Design Patterns | Reading + quiz only |
| Section 11 | Module 10 | Build Your Domain Agent | 3 tracks |
| Section 12 | Module 11 | Fleet Orchestration | Solo adaptation |
| Section 13 | Module 12 | Triggers, Scheduling, Interface | Single track |
| Section 14 | Module 13 | Governance — Enterprise-Safe | Single track |
| Section 15 | Module 14 | Capstone — Demo and 30-Day Plan | Solo completion |

---

## Section 1: AI Foundations for Operations (Module 1)

**Estimated video length:** 45-60 minutes total
**Content types:**
- [ ] Video: Course intro — who this is for, what you will build by Day 3 (5 min)
- [ ] Video: AI concepts intro — from chat to agents using DevOps analogies (15 min)
- [ ] Video: Lab walkthrough — Layers 1-4 context engineering with CloudWatch alarm data (20 min)
- [ ] Video: Module debrief — what changed between Layer 1 and Layer 4 (5 min)
- [ ] Reading: `module-01-foundations/reading/concepts.mdx` (tokenization, context windows, inference, temperature)
- [ ] Reading: `module-01-foundations/reading/reference.mdx` (context engineering vs prompt engineering reference table)
- [ ] Quiz: `module-01-foundations/quiz/QUIZ.mdx` (5 questions)
- [ ] Downloadable: CloudWatch alarm JSON files for the lab (from course-app/mock-aws/)

**Solo-completion note:** Lab is entirely self-paced. No live AWS required — mock JSON provided. Solo learner needs: Claude Code or Crush with any provider (Claude subscription, Google AI Studio free, OpenRouter free credits).

**Estimated completion time:** 90 minutes (30 min reading + 45 min lab + 15 min quiz)

---

## Section 2: Platform AI — Features in Your Stack (Module 2)

**Estimated video length:** 30-40 minutes total
**Content types:**
- [ ] Video: Platform AI overview — what AWS gives you out of the box (10 min)
- [ ] Video: Lab walkthrough — CloudWatch anomaly detection, Cost Explorer, Q Developer (20 min)
- [ ] Reading: `module-02-platform-ai/reading/concepts.mdx`
- [ ] Reading: `module-02-platform-ai/reading/reference.mdx`
- [ ] Quiz: `module-02-platform-ai/quiz/QUIZ.mdx`
- [ ] Downloadable: Mock AWS CLI output files for participants without live AWS access

**Solo-completion note:** AWS free-tier account recommended but not required. Mock path documented in lab with identical analysis steps. AWS free tier changed July 2025: new accounts get 6-month credits rather than perpetual free tier.

**Estimated completion time:** 75 minutes (20 min reading + 45 min lab + 10 min quiz)

---

## Section 3: From Platform AI to Custom Agents (Module 3)

**Estimated video length:** 35-40 minutes total
**Content types:**
- [ ] Video: Demo video — Hermes first run showing SKILL.md-backed agent responding to CloudWatch alarm (15 min)
- [ ] Video: Lab walkthrough — participants run the demo sequence on their own machine (15 min)
- [ ] Video: Bridge concept — why custom agents where platform AI ends (5 min)
- [ ] Reading: `module-03-bridge/reading/concepts.mdx` (tool calling, agent loop, structured output)
- [ ] Reading: `module-03-bridge/reading/reference.mdx` (Hermes install, ReAct pattern reference)
- [ ] Quiz: `module-03-bridge/quiz/QUIZ.mdx`

**Solo-completion note:** Hermes installation required. Lab is observational in Part 1, hands-on in Part 2. Solo learners are both facilitator and participant — this is documented explicitly in the lab file.

**Estimated completion time:** 60 minutes (15 min reading + 35 min lab + 10 min quiz)

---

## Section 4: Impact Assessment (Module 4)

**Estimated video length:** 25-30 minutes total
**Content types:**
- [ ] Video: Automation Quadrant explained (10 min)
- [ ] Video: Scoring exercise walkthrough — example tasks scored live (10 min)
- [ ] Video: Capstone candidate selection — how to pick your Day 3 project (5 min)
- [ ] Reading: `module-04-impact/reading/concepts.mdx`
- [ ] Reading: `module-04-impact/reading/reference.mdx`
- [ ] Quiz: `module-04-impact/quiz/QUIZ.mdx`
- [ ] Downloadable: Scoring template spreadsheet (from lab/starter/)

**Solo-completion note:** Designed for solo completion from day one. The scoring template works identically whether you're in a workshop team or learning independently. Bring your own list of 10 operational tasks OR use the provided example tasks.

**Estimated completion time:** 60 minutes (15 min video + 40 min exercise + 5 min quiz)

---

## Section 5: Structured AI Coding (Module 5a)

**Estimated video length:** 40-50 minutes per track
**Content types:**
- [ ] Video: Track A walkthrough — Helm chart generation with gap analysis + CLAUDE.md workflow (20 min)
- [ ] Video: Track B walkthrough — CI/CD pipeline generation with gap analysis + CLAUDE.md workflow (20 min)
- [ ] Video: Structured coding principles — the 5-phase workflow explained (10 min)
- [ ] Reading: `module-05a-structured-coding/reading/concepts.mdx`
- [ ] Reading: `module-05a-structured-coding/reading/reference.mdx`
- [ ] Quiz: `module-05a-structured-coding/quiz/QUIZ.mdx`
- [ ] Downloadable: Reference app Helm chart starter files (Track A), GitHub Actions starter config (Track B)

**Solo-completion note:** Pick Track A or Track B (not both initially). Both tracks are fully solo-completable with the reference app. Track A requires kubectl + helm. Track B requires git + GitHub account (or GitLab equivalent).

**Estimated completion time:** 90 minutes (20 min reading + 60 min lab + 10 min quiz)

---

## Section 6: AI Workflows and GSD (Module 5b)

**Estimated video length:** 45-55 minutes total
**Content types:**
- [ ] Video: GSD workflow demo — /gsd:new-project through plan execution on a real IaC task (25 min)
- [ ] Video: Memory systems — claude-mem vs Crush MCP memory side by side (10 min)
- [ ] Video: Context engineering at the workflow level — what goes in CLAUDE.md (10 min)
- [ ] Reading: `module-05b-ai-workflows/reading/concepts.mdx`
- [ ] Reading: `module-05b-ai-workflows/reading/reference.mdx`
- [ ] Quiz: `module-05b-ai-workflows/quiz/QUIZ.mdx`

**Solo-completion note:** GSD workflow is fully self-contained. Memory systems section: follow the Claude Code path or the Crush path based on your tool choice from Section 5.

**Estimated completion time:** 90 minutes (20 min reading + 60 min lab + 10 min quiz)

---

## Section 7: AI-Assisted IaC (Module 6)

**Estimated video length:** 45-55 minutes per track
**Content types:**
- [ ] Video: Track A walkthrough — Terraform VPC+EC2 generation with gap analysis and mock_provider (25 min)
- [ ] Video: Track B walkthrough — ArgoCD GitOps Application resource generation (25 min)
- [ ] Video: IaC generation principles — why gap analysis before AI is non-negotiable (5 min)
- [ ] Reading: `module-06-ai-iac/reading/concepts.mdx`
- [ ] Reading: `module-06-ai-iac/reading/reference.mdx`
- [ ] Quiz: `module-06-ai-iac/quiz/QUIZ.mdx`
- [ ] Downloadable: Track A Terraform starter (with mock_provider config), Track B ArgoCD starter

**Solo-completion note:** Track A: Terraform 1.7+ required; AWS credentials optional (mock_provider works without them). Track B: KIND cluster + ArgoCD required; memory patches mandatory for laptop clusters (documented in setup-argocd.sh).

**Estimated completion time:** 90 minutes (20 min reading + 60 min lab + 10 min quiz)

---

## Section 8: Agent Skills — Teaching Agents Runbooks (Module 7)

**Estimated video length:** 40-50 minutes total
**Content types:**
- [ ] Video: SKILL.md anatomy — walking through a complete EC2 health check skill (15 min)
- [ ] Video: Lab walkthrough — authoring a SKILL.md for your domain track (20 min)
- [ ] Video: Skills as procedural memory — why machine-readable runbooks beat chat prompts (5 min)
- [ ] Reading: `module-07-agent-skills/reading/concepts.mdx` (RAG, embeddings, memory types, procedural memory)
- [ ] Reading: `module-07-agent-skills/reading/reference.mdx` (annotated SKILL.md, skill lifecycle, anti-patterns)
- [ ] Quiz: `module-07-agent-skills/quiz/QUIZ.mdx`
- [ ] Downloadable: Complete SKILL.md examples for all 4 tracks (from Hermes repo lab/)

**Solo-completion note:** Pick one track (SRE, DevOps, DBA, or Observability) aligned with your capstone candidate from Section 4. The lab produces a SKILL.md you will use in Section 9.

**Hermes repo note:** The hands-on lab guide lives in the Hermes repository. The reading and quiz live here. Read Section 8 content first, then open the Hermes lab guide.

**Estimated completion time:** 90 minutes (25 min reading + 55 min lab + 10 min quiz)

---

## Section 9: Wiring Tools to Agents (Module 8)

**Estimated video length:** 35-45 minutes total
**Content types:**
- [ ] Video: Tool types and MCP — CLI vs API vs MCP with DevOps analogies (10 min)
- [ ] Video: Safety configuration demo — showing a blocked command rejection live (10 min)
- [ ] Video: Lab walkthrough — Hermes profile creation, SOUL.md, config.yaml (15 min)
- [ ] Reading: `module-08-tool-integration/reading/concepts.mdx` (tool patterns, MCP, safety, SOUL.md)
- [ ] Reading: `module-08-tool-integration/reading/reference.mdx` (config.yaml templates, safety tiers, SOUL.md examples)
- [ ] Quiz: `module-08-tool-integration/quiz/QUIZ.mdx`

**Solo-completion note:** Hermes required. Lab produces a working agent profile with your Module 7 skill attached. This is the agent you run in Section 11.

**Hermes repo note:** Lab guide in Hermes repository. Reading and quiz here.

**Estimated completion time:** 75 minutes (20 min reading + 45 min lab + 10 min quiz)

---

## Section 10: Agent Design Patterns (Module 9)

**Estimated video length:** 30-40 minutes total
**Content types:**
- [ ] Video: Four patterns explained — advisor, investigator, proposal, guardian with DevOps role analogies (15 min)
- [ ] Video: Autonomy spectrum — L1 through L4 with promotion criteria (10 min)
- [ ] Video: Choosing your capstone pattern — walkthrough decision framework (5 min)
- [ ] Reading: `module-09-design-patterns/reading/concepts.mdx`
- [ ] Reading: `module-09-design-patterns/reading/reference.mdx` (ASCII decision flowchart, Hermes config per pattern)
- [ ] Quiz: `module-09-design-patterns/quiz/QUIZ.mdx` (6 scenario-based questions)

**Solo-completion note:** No hands-on lab in this section — reading and pattern selection only. Apply the pattern selection framework to your capstone candidate before proceeding to Section 11.

**Estimated completion time:** 45 minutes (25 min reading + 20 min quiz)

---

## Section 11: Build Your Domain Agent (Module 10)

**Estimated video length:** 50-60 minutes per track
**Content types:**
- [ ] Video: Track A walkthrough — SRE agent build (EC2/CloudWatch) (25 min)
- [ ] Video: Track B walkthrough — FinOps agent build (cost anomaly) (25 min)
- [ ] Video: Track C walkthrough — Platform agent build (K8s deployment health) (25 min)
- [ ] Video: Testing with simulated data — why simulation-first matters (5 min)
- [ ] Reading: `module-10-domain-agent/reading/concepts.mdx`
- [ ] Reading: `module-10-domain-agent/reading/reference.mdx`
- [ ] Quiz: `module-10-domain-agent/quiz/QUIZ.mdx`

**Solo-completion note:** Pick one track aligned with your capstone candidate. Build that agent completely before considering other tracks. The agent produced here is your capstone demo.

**Hermes repo note:** Lab guide in Hermes repository. Reading and quiz here.

**Estimated completion time:** 120 minutes (25 min reading + 85 min lab + 10 min quiz)

---

## Section 12: Fleet Orchestration (Module 11)

**Estimated video length:** 30-40 minutes total
**Content types:**
- [ ] Video: Why single agents hit limits — the cross-domain incident scenario (10 min)
- [ ] Video: Fleet architecture demo — coordinator delegating to three specialists (15 min)
- [ ] Video: Solo learner adaptation — building all three tracks then wiring them (5 min)
- [ ] Reading: `module-11-fleet/reading/concepts.mdx` (fleet patterns, delegation, coordinator design)
- [ ] Reading: `module-11-fleet/reading/reference.mdx` (coordinator SOUL.md template, fleet config)
- [ ] Quiz: `module-11-fleet/quiz/QUIZ.mdx`

**Solo-completion note:** Team exercise adapted for solo completion. Build Track A, B, and C agents sequentially (you already built one in Section 11), then wire them with a coordinator using the template in the reference reading. Allow 90 minutes total. Detailed solo instructions in `module-11-fleet/reading/reference.mdx`.

**Hermes repo note:** Lab guide in Hermes repository. Reading and quiz here.

**Estimated completion time:** 90 minutes solo (25 min reading + 55 min lab + 10 min quiz)

---

## Section 13: Triggers, Scheduling, Interface (Module 12)

**Estimated video length:** 30-40 minutes total
**Content types:**
- [ ] Video: Four interface patterns — CLI, cron, webhook, Slack with use-case examples (10 min)
- [ ] Video: Webhook configuration demo — PagerDuty → Hermes agent (15 min)
- [ ] Video: Cron job setup — scheduled daily cost report (10 min)
- [ ] Reading: `module-12-triggers/reading/concepts.mdx` (four patterns, selection matrix, design guidelines)
- [ ] Reading: `module-12-triggers/reading/reference.mdx` (cron config, webhook setup, PagerDuty example)
- [ ] Quiz: `module-12-triggers/quiz/QUIZ.mdx`

**Solo-completion note:** Choose the trigger pattern that matches your capstone candidate. If alert triage: webhook. If reporting: cron. This configuration connects to your Section 11 agent.

**Hermes repo note:** Lab guide in Hermes repository. Reading and quiz here.

**Estimated completion time:** 75 minutes (20 min reading + 45 min lab + 10 min quiz)

---

## Section 14: Governance — Enterprise-Safe (Module 13)

**Estimated video length:** 35-45 minutes total
**Content types:**
- [ ] Video: Governance triad — DO × APPROVE × LOG explained (10 min)
- [ ] Video: Maturity levels — L1 through L4 with promotion and demotion criteria (10 min)
- [ ] Video: Enterprise governance configuration demo — approval gates, audit logs, RBAC (15 min)
- [ ] Reading: `module-13-governance/reading/concepts.mdx` (governance triad, maturity levels, approval design)
- [ ] Reading: `module-13-governance/reading/reference.mdx` (config templates per level, audit log format, checklists)
- [ ] Quiz: `module-13-governance/quiz/QUIZ.mdx`

**Solo-completion note:** Apply your agent's governance layer before recording your capstone demo. Section 15 rubric scores governance as one of five dimensions — it affects your readiness assessment.

**Hermes repo note:** Lab guide in Hermes repository. Reading and quiz here.

**Estimated completion time:** 75 minutes (25 min reading + 40 min lab + 10 min quiz)

---

## Section 15: Capstone — Demo and 30-Day Plan (Module 14)

**Estimated video length:** 20-30 minutes total
**Content types:**
- [ ] Video: Capstone structure explained — 5 sections, what each must show (10 min)
- [ ] Video: 30-day roadmap walkthrough — what realistic looks like vs wishful (10 min)
- [ ] Video: Rubric walkthrough — self-scoring your capstone (5 min)
- [ ] Template: `module-14-capstone/capstone/PRESENTATION.mdx` (5-section presentation template)
- [ ] Template: `module-14-capstone/capstone/ROADMAP-TEMPLATE.mdx` (30-day deployment plan)
- [ ] Template: `module-14-capstone/capstone/RUBRIC.mdx` (5-dimension self-scoring rubric)
- [ ] Reading: `module-14-capstone/reading/concepts.mdx`
- [ ] Reading: `module-14-capstone/reading/reference.mdx`
- [ ] Quiz: `module-14-capstone/quiz/QUIZ.mdx`

**Solo-completion note:** All capstone activities designed for solo completion. Where the template says "team," substitute your individual work. A screen recording or terminal log replaces a live demo. The rubric scores individual output — score honestly; it is a deployment readiness check.

**Estimated completion time:** 120 minutes (30 min reading + 60 min preparation + 20 min recording + 10 min self-assessment)

---

## Total Course Estimate

| Component | Sections | Estimated Time |
|-----------|----------|----------------|
| Reading (all sections) | 1-15 | ~6 hours |
| Lab work (all sections) | 1-9, 11-14 | ~15 hours |
| Quizzes (all sections) | 1-15 | ~2.5 hours |
| Capstone preparation | 15 | ~2 hours |
| **Total** | | **~25 hours** |

Video content is separate from total completion time — videos accompany the labs and reading.

---

## Production Notes (for video recording phase)

- Record labs in two-pass format: (1) fast-forward setup, (2) real-time key moments
- Each section video should be segmented by component (not one long video)
- Maximum video length per segment: 15 minutes (Udemy best practice)
- Downloadable resources should match exactly what is shown in the video
- All videos: show terminal and code side by side where possible
- Closed captions required for all video content (Udemy accessibility requirement)
- Screen recording resolution: minimum 1920x1080
