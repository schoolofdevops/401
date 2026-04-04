# Feature Research

**Domain:** Agentic DevOps Training Course — Content and Delivery Features
**Researched:** 2026-04-04
**Confidence:** HIGH (primary claims corroborated across Udemy platform docs, KodeKloud analysis,
competitor course analysis, and hermes-agent research already done for this project)

---

## Overview

This research maps five feature dimensions for the course content:

1. **Content types** — what format of material every module must include
2. **Lab design** — what makes hands-on exercises work for both live and self-paced delivery
3. **Assessment approach** — how to validate learning without alienating ops engineers
4. **Context engineering curriculum** — what that subject actually covers vs prompt engineering
5. **Dual-format operation** — what content properties let one course serve two delivery modes

The existing hermes-agent FEATURES.md covers agent-specific skill/governance/orchestration features
and is the authoritative source for those. This file covers the course-as-product feature layer that
wraps all of those.

---

## Feature Landscape

### Table Stakes (Learners Leave Without These)

Features that technical learners on Udemy and in live workshops expect. Missing any of these signals
an amateurish or incomplete course.

#### Dimension 1: Content Format Per Module

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Step-by-step lab guide (LAB.md) | Every top-rated DevOps course (KodeKloud, A Cloud Guru) provides explicit guided steps, not "figure it out" | LOW | Each step needs "Expected result:" validation — learners stall without this |
| Starter files + solution files | Industry standard: KodeKloud, Coursera all scaffold; learners need something to work from | LOW | `starter/` has scaffolded blanks; `solution/` has reference — do not skip either |
| Module overview README with objectives | Learners want to know what they're getting into before they start; Udemy algorithms reward clear objectives | LOW | 3-5 learning objectives max; link to prerequisites clearly |
| Concept reading material (concepts.md) | Ops engineers read before they execute; they won't run commands they don't understand | LOW | Explain the "why" with DevOps analogies — not AI theory jargon |
| Reference material (reference.md) | Engineers return to courses for reference; "cheat sheet" value drives reviews and repeat visits | LOW | Command reference, YAML templates, config options — scannable not prose |
| Per-module quiz (QUIZ.md) | Udemy algorithms explicitly reward practice activities; Udemy research shows learners choose courses with interactive elements | LOW | 5-8 questions per module; focus on concepts not syntax trivia |
| Deliverable per lab | Every lab in the outline defines a deliverable; this is the right model — learners need a concrete "done" signal | LOW | State deliverable at top of LAB.md, not buried at the end |

#### Dimension 2: Lab Mechanics

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Real infrastructure or credible simulation | DevOps engineers won't trust toy data; mock data must have realistic anomaly patterns | HIGH | KIND is real; RDS/Cost Explorer need structured JSON that reflects genuine production patterns |
| Observable output at every step | Without visible feedback, learners don't know if their agent is working; black-box outputs fail | LOW | Terminal output, log files, agent reasoning traces must be called out in lab guides |
| Clear success criteria per step | Learners stall when they don't know if a step succeeded; good labs say "you should see X" | LOW | Required for every substantive step — not just at the end |
| Self-sufficient lab guides | Udemy learners have no instructor to ask; live workshop guides assume no verbal instruction | MEDIUM | Every lab guide must stand alone: setup, steps, expected outputs, troubleshooting tips |
| Multi-provider tool setup instructions | Participants use Claude Code, OpenCode, or Google AI Studio — labs must work with all three | MEDIUM | Provider setup section at start of Day 1 lab; flag provider-specific differences inline |
| Environment setup guide (participant setup doc) | Without pre-configured environments, Day 1 is lost to install problems | MEDIUM | Must cover: Claude Code install, OpenCode install, KIND setup, AWS CLI config, mock data placement |

#### Dimension 3: Assessment Design

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Deliverable-based validation (not just quiz) | Ops engineers trust "does it run" over "did you answer correctly" — the course outline already correctly uses deliverables | LOW | "Your agent runs the health check" validates more than 10 MCQs about health checks |
| Conceptual quizzes (5-8 questions per module) | Udemy requires practice activities for quality badge; reinforces retention; not the primary assessment vehicle | LOW | Focus on "why" questions, not "which flag does X" trivia |
| Peer review for skill artifacts (Module 7) | The outline specifies peer review for SKILL.md — this is the right call; forces participants to read other designs | LOW | Provide a review rubric (criteria checklist) so peer feedback is structured |
| Capstone presentation rubric (Module 14) | Teams need explicit scoring criteria; ambiguous rubrics generate complaints | LOW | Score: problem statement, agent design quality, live demo success, governance spec, 30-day plan realism |

#### Dimension 4: Participant Engagement (Live Workshop)

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Team exercises with defined team roles | Module 11 fleet lab requires teams of 3; team composition instructions needed | LOW | Assign tracks before Day 3 starts; don't let teams self-sort during lab time |
| Cross-track integration scenario (Module 11) | Teams combining DB + Cost + K8s agents need a shared incident narrative to integrate against | MEDIUM | A pre-built "JangoMart incident" scenario provides shared context |
| Structured debriefs between labs | Ops engineers learn from seeing what colleagues built differently; debrief format matters | LOW | 10-min debrief per major lab: "show your deliverable, what was hard?" — 3 volunteers max |
| Module transitions with "why this next" framing | Adult learners disengage when sequence feels arbitrary; each module intro must motivate the next one | LOW | 2-3 slides per module: here's what you built, here's what's missing, here's what this next module adds |

---

### Differentiators (Competitive Advantage)

These are the features that separate this course from every other "AI for DevOps" course on Udemy.
The top Udemy competitors (LLM Engineering Masterclass, Complete Agentic AI Engineering Course)
teach Python-first, generic agent frameworks, no DevOps domain specificity, no governance.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Context engineering as the explicit core skill | No competing course teaches context engineering by name for DevOps; prompt engineering courses are everywhere; this is the differentiation | MEDIUM | Frame it early (Module 1): "You're not writing prompts, you're engineering context — domain knowledge + system state + constraints" |
| DevOps-first analogy system | Ops engineers learn AI concepts through what they already know; generic AI courses lose them at "transformer architecture" | LOW | Token/context window = message bus with backpressure; temperature = jitter; agent = runbook executor — every concept needs a DevOps mapping |
| SKILL.md as a tangible artifact format | No other course teaches a specific, opinionated machine-readable runbook format that participants can actually author | MEDIUM | Participants leave with a format they can use on Monday at work, regardless of which agent framework they choose |
| Tool-agnostic, framework-portable patterns | Top Udemy agentic courses are LangChain-specific or CrewAI-specific; this course teaches patterns (ReAct, human-in-the-loop, coordinator-specialist) that survive framework churn | LOW | Explicitly name each pattern; say "Hermes calls this X, LangChain calls it Y, but it's the same pattern" |
| Governance module as first-class content (Module 13) | No competitor includes governance as a dedicated module; enterprise buyers won't approve agent deployment without this | MEDIUM | L1-L4 maturity model gives teams a promotion conversation; makes course sellable to enterprise training budgets |
| Participants take home a working agent system | Competitors produce "portfolio" projects; this course produces systems that run against participants' actual infrastructure | HIGH | The three reference implementations (Track A/B/C) must be deployable post-workshop — not demo code |
| Progressive build chain across 14 modules | Most courses have isolated labs; progressive chains mean every artifact matters and the final capstone is genuinely earned | MEDIUM | Module 1 CloudWatch data → Module 7 skill → Module 8 agent → Module 10 domain agent → Module 11 fleet → Module 13 governance |
| Exploratory stretch projects per module | Advanced participants get extension challenges; prevents boredom in expert audiences without slowing the main track | LOW | PROJECTS.md in each `exploratory/` dir; 2-3 ideas per module with no starter files |
| Dual-format structural discipline | Every lab guide written to be instructor-free; every team exercise has a solo fallback; this is rare for workshop content | MEDIUM | Solo fallback for Module 11: use three pre-built reference agents instead of team-built agents |

---

### Anti-Features (Deliberately Excluded)

Features that seem valuable but would damage the course or participant experience.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Python coding labs for agent implementation | "Real engineering is code" | Excludes DBAs, FinOps analysts, SREs who are the target audience; violates the no-Python constraint in CLAUDE.md | SKILL.md + YAML profiles give full agent definition power without Python; note Python as optional extension in PROJECTS.md |
| Live paid AWS RDS / Cost Explorer in labs | "More realistic" | Fails participants without AWS account; creates billing anxiety; blocks offline work; intro complexity before labs even start | Realistic JSON mock data with genuine anomaly patterns; KIND cluster for K8s is real and free |
| Framework comparison module (LangChain vs CrewAI vs Hermes) | "We should evaluate our options" | Creates analysis paralysis; not actionable in 3 days; risks dates poorly as ecosystem evolves rapidly | Teach transferable pattern vocabulary (ReAct, coordinator, human-in-the-loop); participants can map patterns to any framework post-course |
| Quiz-heavy certification model | "Certification requires assessments" | Cognitive load competes with lab work; ops engineers resist quiz culture; deliverable-based validation is more credible for this audience | Deliverable-based: "your agent runs the health check" + short conceptual quizzes (5-8 questions) for Udemy algorithm requirements |
| Real-time Mission Control dashboard (frontend build) | "Agents need monitoring UI" | Significant frontend engineering scope; not the point of a 3-day workshop; Streamlit dashboard in competitors' courses is not reused after class | Describe Mission Control conceptually in Module 12 reading; show config examples; call it a v2 capability |
| Slack integration as a hands-on lab | "Agents should respond in Slack where ops teams live" | Most participants lack Slack admin access to create apps; blocks lab progress for entire class | Demo walkthrough only; provide trigger YAML config examples participants adapt post-course |
| Extensive theory sections before hands-on | "Participants need to understand before they build" | Adult technical learners have low tolerance for theory-before-practice; this audience already did 10+ years in operations | Concepts.md provides theory for those who want it; lab comes first in delivery order |
| Local-only LLM support (Ollama, TinyLlama) | "Free and private" | Insufficient reasoning capability for complex DevOps agent tasks; creates inconsistent results that confuse learners | Require hosted LLM (Claude, Gemini free tier, OpenRouter) per course prerequisites |
| Comprehensive AI ethics and safety theory | "Responsible AI must be covered" | Generic ethics content adds no value for experienced DevOps engineers who care about operational safety, not philosophical AI risk | Governance module (13) covers operational safety concretely: audit trails, approval workflows, RBAC, credential protection |
| Video production within content dev scope | "Udemy needs video" | Content writing and video production are separate disciplines on separate timelines | All modules written to support video recording later; explainer/ dir holds slide notes; lab walkthroughs are natural video scripts |

---

## Feature Dependencies

```
Environment setup guide
    └──required before──> All Day 1 labs
                              └──required before──> Module 1 lab (CloudWatch data)
                                                         └──feeds into──> Module 7 SKILL.md
                                                                              └──feeds into──> Module 8 agent YAML
                                                                                                   └──feeds into──> Module 10 domain agent
                                                                                                                        └──feeds into──> Module 11 fleet lab

Module 11 fleet lab
    └──requires──> Three completed domain agents (Tracks A, B, C)
    └──requires──> Cross-domain incident scenario (JangoMart or equivalent)
    └──solo fallback──> Three pre-built reference agents replace team-built agents (Udemy path)

Context engineering curriculum
    └──introduced in──> Module 1 (foundations)
    └──deepened in──> Module 7 (SKILL.md as context artifact)
    └──deepened in──> Module 8 (SOUL.md as identity context)
    └──culminates in──> Module 13 (governance as context boundary definition)

Realistic mock data
    └──required for──> Module 1 lab (CloudWatch JSON)
    └──required for──> Module 2 lab (RDS Performance Insights, Cost Explorer data)
    └──required for──> Module 10 Track A (RDS health patterns)
    └──required for──> Module 10 Track B (Cost Explorer anomaly patterns)
    └──required for──> Module 10 Track C (kubectl output patterns)

Dual-format discipline
    └──requires──> Every team exercise has a defined solo fallback
    └──requires──> Every lab guide is instructor-free (no verbal instruction assumed)
    └──conflicts with──> Labs that require live discussion for interpretation
```

### Dependency Notes

- **Environment setup is a hard blocker for Day 1.** If participants arrive without working tools,
  the entire workshop collapses. The setup guide must be distributed and validated by participants
  before the first day. For Udemy, Module 0 (setup) should be a standalone section.

- **Progressive build chain means no lab is disposable.** Every deliverable feeds the next module.
  Facilitators must enforce this: "do not proceed to Module 8 without a working SKILL.md from
  Module 7." Udemy self-paced learners must be warned in the Module 7 outro.

- **Realistic mock data quality determines whether simulated labs feel credible.** If the mock
  CloudWatch JSON looks like invented data, ops engineers will disengage. Invest in mock data that
  mirrors real production patterns — actual anomaly shapes, realistic metric names, plausible values.

- **Dual-format discipline conflicts with team-dependent labs.** Module 11 is the hardest to
  convert: fleet orchestration is inherently team-based in live format. The solo fallback (use
  three pre-built reference track agents) must be built and tested before launch.

- **Context engineering curriculum requires consistent framing across all 14 modules.** The risk
  is it appears only in Module 1 and disappears. Modules 7, 8, and 13 must explicitly reinforce
  the language: "This SKILL.md is an act of context engineering. You are giving the agent the
  operational knowledge it needs to reason correctly."

---

## MVP Definition

### Launch With (v1 — Course Starts 2026-04-06)

Minimum content required for a functioning 3-day workshop that delivers on the course promise.

- [ ] Participant environment setup guide — blocks all other work if missing
- [ ] Realistic mock data set: CloudWatch alarm JSON, RDS Performance Insights JSON, Cost Explorer
      anomaly JSON, kubectl describe/get output — required for Modules 1, 2, 6, 10
- [ ] Module README + LAB.md for all 6 in-scope modules (1, 2, 4, 5, 6, 9, 14) with
      starter/solution structure
- [ ] concepts.md + reference.md for all in-scope modules
- [ ] QUIZ.md for all in-scope modules (5-8 questions each)
- [ ] Capstone presentation template + 30-day roadmap template + rubric (Module 14)
- [ ] Automation Quadrant scoring template (Module 4) — solo-compatible, not just team format
- [ ] Module 3 demo script (Hermes walkthrough) — facilitator notes + participant observation guide

### Add After Validation (v1.x)

Add once the first cohort completes and pacing is validated.

- [ ] Exploratory stretch projects (PROJECTS.md) per module
- [ ] Udemy-specific module organization (shorter videos, tighter section breaks)
- [ ] Post-course reference guide: "What to build in your first 30 days"
- [ ] Cross-platform lab variants (OpenCode path documented alongside Claude Code path)

### Future Consideration (v2+)

Defer until the course has run at least twice.

- [ ] Mission Control dashboard design and reference implementation
- [ ] Python extension labs for participants who want to go deeper
- [ ] Additional domain tracks: Security hardening agent, CI/CD pipeline health agent
- [ ] Certification / completion badge program

---

## Feature Prioritization Matrix

| Feature | Learner Value | Build Cost | Priority |
|---------|---------------|------------|----------|
| Participant environment setup guide | HIGH | LOW | P1 |
| Realistic mock data (CloudWatch, RDS, Cost, K8s) | HIGH | MEDIUM | P1 |
| LAB.md guides with starter/solution (all modules) | HIGH | HIGH | P1 |
| concepts.md + reference.md (all modules) | HIGH | MEDIUM | P1 |
| QUIZ.md (all modules, 5-8 questions) | MEDIUM | LOW | P1 |
| Module 14 capstone templates and rubric | HIGH | LOW | P1 |
| Module 4 Automation Quadrant scoring template | HIGH | LOW | P1 |
| Context engineering framing throughout | HIGH | LOW | P1 |
| Module 3 demo script | MEDIUM | LOW | P1 |
| Progressive build chain discipline | HIGH | LOW | P1 |
| DevOps-first analogy system | HIGH | LOW | P1 |
| Dual-format solo fallbacks | MEDIUM | MEDIUM | P2 |
| Exploratory stretch projects (PROJECTS.md) | MEDIUM | LOW | P2 |
| Udemy-specific section structure | MEDIUM | LOW | P2 |
| Post-course reference guide | LOW | LOW | P3 |
| Mission Control design | LOW | HIGH | P3 |

**Priority key:**
- P1: Must have for 2026-04-06 launch — course fails without it
- P2: Should have — enhances experience, not blocking
- P3: Nice to have — defer until after first cohort

---

## Competitor Feature Analysis

Context: The most relevant competitors are KodeKloud DevOps courses, the Udemy agentic AI
engineering courses, and Coursera's IBM multi-agent specialization. None combines DevOps domain
specificity with agentic skills and governance.

| Feature | KodeKloud DevSecOps | Udemy Agentic AI Masterclass | Coursera IBM Multi-Agent | This Course |
|---------|---------------------|------------------------------|--------------------------|-------------|
| DevOps domain specificity | HIGH — purpose-built | NONE — generic tech | LOW — generic | HIGH — IaC, K8s, RDS, Cost |
| Context engineering as explicit concept | NONE | NONE | NONE | YES — core framing |
| YAML/no-code agent authoring | NO — Python required | NO — Python required | NO — Python required | YES — SKILL.md + Hermes YAML |
| Governance as dedicated module | NO | NO | NO | YES — Module 13, L1-L4 |
| Fleet orchestration lab | NO | Partial (conceptual) | Partial (conceptual) | YES — team exercise, Module 11 |
| Real infrastructure target | Cloud sandbox | Demo environments | Cloud sandbox | KIND (real) + mock data |
| Progressive build across modules | Partial | Partial | Full specialization | Full chain Mod 1→14 |
| Deliverable-based assessment | NO — quiz-heavy | NO — quiz-heavy | PARTIAL | YES — working agent per module |
| Domain-specific tracks (DB/Cost/K8s) | DevSecOps only | Generic | Generic | Three specialized tracks |
| Reference implementations to take home | NO | YES (GitHub repos) | NO | YES — deployable per track |
| Dual-format (live + Udemy) | Udemy only | Udemy only | Udemy/Coursera | YES — both formats supported |
| DevOps analogy system for AI concepts | PARTIAL | NONE | NONE | YES — every concept mapped |

**Key gap this course fills:** No existing course combines enterprise governance, fleet
orchestration, context engineering as a first-class skill, and YAML-only authoring in a
domain-specific DevOps context with simulation fallback for the free-tier constraint.

---

## Context Engineering Curriculum Specifics

This is the most important differentiator to get right. The course claims context engineering
as its core skill — here is what that means concretely across modules:

### What Context Engineering Is (vs Prompt Engineering)

**Prompt engineering** = crafting individual requests to get better single outputs. The skill is
linguistic: phrasing, examples, chain-of-thought instructions.

**Context engineering** = designing the full information architecture an agent operates within.
The skill is structural: what knowledge goes in, in what format, managed how, at what point in
the workflow.

Components of context to teach:
1. **System context** (SOUL.md) — agent identity, role, tone, scope of responsibility
2. **Domain knowledge context** (SKILL.md) — operational procedures, decision trees, expected
   outputs, escalation rules
3. **State context** — current infrastructure state injected at query time (CloudWatch data,
   kubectl describe output, RDS metrics)
4. **Constraint context** — what the agent is allowed to do, blocked from doing, must escalate
4. **Memory context** — conversation history, prior action outcomes, audit trail

### How It Appears Per Module

| Module | Context Engineering Lesson |
|--------|---------------------------|
| 1 | Comparing bare prompts vs prompts with CloudWatch context — same question, very different answer quality |
| 2 | Platform AI context: what AWS services inject automatically vs what is your responsibility to provide |
| 5 | Structured workflow as context scaffolding: Brainstorm → Blueprint tells the agent what phase it is in |
| 7 | SKILL.md is a context artifact: you are encoding your operational expertise into a reusable format |
| 8 | SOUL.md as identity context: the agent's behavior is determined by the context it has about itself |
| 9 | Design patterns are context management strategies: ReAct structures reasoning context; coordinator distributes context across specialists |
| 13 | Governance = context boundaries: defining what context the agent should never have (blocked commands, redacted credentials) |

### What NOT to Teach in This Course

- RAG (retrieval-augmented generation) — this is v2 content after agents work
- Embeddings and vector databases — too infrastructure-heavy, outside scope
- Fine-tuning — not applicable to the operational domain
- Prompt injection defenses — mention in governance reading, not a lab topic

---

## Sources

- [Udemy: Enhancing learning with practice and assessment](https://teach.udemy.com/course-creation/plan-your-practice-activities/) — Udemy's own guidance on practice activity standards; learners value interactive activities and courses with them receive higher satisfaction scores
- [Udemy: Understanding Curriculum Items](https://support.udemy.com/hc/en-us/articles/229606188-Understanding-Curriculum-Items-for-Your-Course) — Official Udemy curriculum item types: lectures, quizzes, coding exercises, assignments, labs
- [KodeKloud: Hands-On DevOps, Cloud & AI Learning 2025](https://kodekloud.com/blog/hands-on-devops-cloud-ai-learning-2025/) — Progressive labs, scenario-based learning, browser-based environments; the gold standard for DevOps hands-on training
- [KodeKloud: Best DevOps Courses 2025](https://kodekloud.com/blog/best-devops-courses-in-2025/) — What top-rated DevOps courses include; emphasis on real environments and certification-aligned labs
- [Context Engineering vs Prompt Engineering — Prompting Guide](https://www.promptingguide.ai/guides/context-engineering-guide) — Authoritative definition: context engineering manages the entire information architecture, not single prompts
- [Context Engineering — DataCamp](https://www.datacamp.com/blog/context-engineering) — System prompts, message history, episodic/semantic memory as context components; emerged mid-2025 with Andrej Karpathy and Tobi Lütke endorsement
- [Context Engineering is the New Prompt Engineering — KDnuggets](https://www.kdnuggets.com/context-engineering-is-the-new-prompt-engineering) — Why context engineering represents a genuine architectural shift, not rebranding
- [Udemy: Complete Agentic AI Engineering Course](https://www.udemy.com/course/the-complete-agentic-ai-engineering-course/) — 83,000+ students, bestseller; Python-first, 8 projects, multi-framework; the direct competitor on Udemy's AI agents topic page
- [Top AI Agents Courses — Udemy](https://www.udemy.com/topic/ai-agents/) — Current Udemy AI agents landscape; confirms Python dominance and absence of DevOps-specific governance content
- [Top DevOps Courses — Udemy](https://www.udemy.com/topic/devops/) — Current top DevOps courses structure; confirms hands-on labs and progressive builds drive ratings
- [Instructor-Led vs Self-Paced: UMBC Training Centers](https://www.umbctraining.com/instructor-led-training-vs-self-paced-elearning/) — Self-paced works for theory; ILT works for practical skills; blended approach is the standard for technical training
- [Agentic AI governance as enterprise requirement — Udacity Nanodegree](https://www.udacity.com/course/agentic-ai--nd900) — Enterprise governance is now a course differentiator; courses without it are seen as incomplete for professional audiences
- Hermes-agent FEATURES.md (this project) — agent-specific features (SKILL.md format, L1-L4 governance, fleet patterns, tool safety) verified HIGH confidence against official sources

---

*Feature research for: Agentic DevOps Training Course — Content and Delivery*
*Researched: 2026-04-04*
