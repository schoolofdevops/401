# Instructor Guide: Day 1 — AI Foundations and Impact Assessment

**Modules:** 1, 2, 3, 4
**Day Duration:** ~6 hours (9:00 AM – 5:00 PM with breaks)
**Audience:** DevOps practitioners with zero AI/LLM knowledge
**Tone:** Treat them as experts. They know infrastructure deeply — your job is to translate AI concepts into that vocabulary.

---

## Pre-Day Setup Checklist

Before participants arrive:

- [ ] Hermes installed and tested on your machine (`hermes --version`)
- [ ] At least one provider configured in Hermes (OpenRouter recommended for live demo)
- [ ] Module 1 CloudWatch alarm JSON files accessible from your terminal
- [ ] AWS CLI configured (or mock-aws available as fallback)
- [ ] Module 4 scoring template printed or in a shareable doc
- [ ] Breakout room configuration ready if virtual
- [ ] Whiteboard or screen space for Automation Quadrant diagram (Module 4)

---

## 9:00 AM — Welcome and Icebreaker (15 min)

**Facilitator action:**

Open with: "Before we get into AI, I want to understand your world. Go around the table — what's your most repetitive operational task? The one you do so often you could do it in your sleep?"

Take notes. These responses are gold: you will reference them throughout the day, and they become live data for the Module 4 scoring exercise. The goal is to capture candidate tasks early so participants have personal examples during the Automation Quadrant discussion.

**Expected responses:** alert triage, deployment health checks, on-call response to known errors, routine certificate rotations, log parsing for known patterns, cost report generation.

**Transition:** "Every one of those is a candidate for an AI agent. By 4:00 PM today, you'll have scored your top 10 and picked your capstone project for Day 3."

---

## 9:15 AM — Module 1: AI Foundations for Operations (90 min)

**Duration:** 9:15 – 10:45 AM
**Tool:** Claude Code or Crush

### Setup requirements

- Participants need Claude Code or Crush installed (see SETUP.md, Day 1 prerequisites)
- Module 1 lab uses CloudWatch alarm JSON from `course-app/mock-aws/cloudwatch/` — confirm path is accessible
- No AWS account required for Module 1

### Facilitator flow

**9:15 — Demo Layer 1 yourself first (5 min)**

Do not let participants start the lab immediately. Do Layer 1 yourself on the projector:

```
Paste the CloudWatch alarm JSON into Claude Code and ask: "What's wrong with this system?"
```

Show what an unstructured query produces — Claude will give a generic, somewhat vague answer. This sets up the contrast.

Say: "Notice what it said. It gave you something useful, but it doesn't know your system, your team, your runbook, or your SLOs. That's Layer 1. By Layer 4, you'll see what changes."

**9:20 — Participants do Layers 1-4 (50 min)**

Send participants to the lab. Walk the room. Common assistance needed:
- Claude Code first-run authentication (OAuth token setup)
- Crush provider setup (Google AI Studio API key for free-tier users)
- JSON file location (it's in the reference app directory, not the docs site)

**Key facilitation moment at Layer 3:**
Watch for the moment participants realize they can inject the alert's full context (runbook section, SLO thresholds, escalation rules) and get dramatically better output. This is the "aha" moment. If groups are quiet, prompt: "What changed between your Layer 2 and Layer 3 prompt?"

**10:15 — Module 1 Debrief (15 min)**

Ask the room: **"What changed between Layer 1 and Layer 4?"**

Capture answers. Drive toward: "You didn't change the AI. You changed what information the AI had. That's context engineering — it's the same skill you already use when writing good runbooks, tickets, or post-mortems. The AI just needs the same structured information you'd give a new SRE."

Key contrast to draw: "This is NOT prompt engineering — tweaking magic words to trick the AI. Context engineering is deciding WHAT information the model needs to give you a useful answer."

### Common participant questions

**Q: "Can it read my live CloudWatch data directly?"**
A: "Not yet — that's what tool calling enables. We get there in Module 8. Today we're working with exported JSON to understand the core concept without needing live AWS access."

**Q: "What's the difference between system prompt and user message?"**
A: "Treat it like a contract vs a request. The system prompt is your standing operating procedure — it tells the AI who it is and what rules apply. The user message is the specific task. You'd write your SOP once and the individual alerts go in the user message."

**Q: "Our environment is air-gapped. Can we use self-hosted models?"**
A: "Yes. Crush supports Ollama for local model hosting. The lab works identically — just a different provider in the config. We cover the full provider setup in SETUP.md."

**Q: "How do we handle sensitive data? I can't paste production logs into a chat interface."**
A: "Good question — this is a Day 3 governance topic. The short answer: use self-hosted models for sensitive data, use mock data for learning, and design your agent to retrieve only what it needs rather than dumping everything into context."

---

## 10:45 AM — Break (15 min)

---

## 11:00 AM — Module 2: Platform AI — Features in Your Stack (60 min)

**Duration:** 11:00 AM – 12:00 PM
**Tool:** AWS Console + CLI (or mock-aws for participants without AWS access)

### Setup requirements

- Participants with AWS accounts: need CloudWatch, Cost Explorer, Q Developer access
- Participants without AWS: use mock-aws path documented in the lab
- Call out the two paths at the start — no one should feel left behind

### Facilitator flow

**11:00 — Dual path setup (5 min)**

Say: "Raise your hand if you have an active AWS account with free-tier access." Count. For those without: "You're using the mock data path — it simulates the same CLI output. You'll complete the same analysis steps, just with local JSON files instead of live API calls."

**11:05 — Participants work through the lab (45 min)**

This module is self-directed. Walk the room and watch for:
- CloudWatch anomaly detection setup (common issue: metrics not yet populating for new accounts)
- Cost Explorer date range selection (use the provided mock month if live data is sparse)
- Q Developer recommendations — show the "explain this code" function as a demo if participants have sparse results

**11:50 — Quick debrief (10 min)**

Ask: "What did the platform AI features give you that you didn't have before?" Then: "What did they NOT give you?" Drive toward: "Platform AI is opt-in, one service at a time, with no memory between services. That's the gap Module 3 addresses."

### Common participant questions

**Q: "We're not on AWS — we use GCP/Azure."**
A: "The pattern is the same across clouds. GCP has Cloud Operations AI features; Azure has Monitor Insights. Module 2's framework applies: what AI is built into your managed services vs what requires custom integration? The AWS examples teach the detection pattern — apply it to your stack."

**Q: "CloudWatch anomaly detection takes time to learn baselines. How do I evaluate it in a training?"**
A: "Use the mock data path — the mock JSON shows what a mature anomaly detection result looks like. The concept is what matters. Real evaluation requires 2 weeks of baseline data before the anomaly detection becomes accurate."

---

## 12:00 PM — Lunch Break (60 min)

---

## 1:00 PM — Module 3: From Platform AI to Custom Agents (30 min)

**Duration:** 1:00 – 1:30 PM
**Tool:** Hermes (facilitator demo — participants observe)
**CRITICAL:** This is a live demo. Rehearse it. If Hermes breaks live, the course breaks live.

### Pre-demo requirements

- Hermes fully installed and configured on YOUR machine before the session
- Provider configured and tested: `hermes model` shows your selected provider
- Test the exact demo sequence the morning of delivery
- Have fallback: a screen recording of the demo if live fails

### Facilitator flow

**1:00 — Live demo (15 min max)**

Scenario: "I'm going to run the same CloudWatch alarm from Module 1 through a Hermes agent that has a SKILL.md file describing our runbook."

Run the demo sequence from Module 3 LAB.mdx Part 1. Key moments to narrate:
1. Show the agent loading the skill file: "This is not a prompt — this is a machine-readable runbook."
2. Show the agent deciding which tool to call: "Notice it chose to check EC2 instance state before looking at CloudWatch metrics. That's the decision tree from the skill."
3. Show the output format: "Structured JSON response, not a paragraph. This is what your ticketing system can parse."

**1:15 — Observation cues for participants**

While running the demo, prompt the room to watch for:
- "When does it call a tool vs reason from context?"
- "How is this different from the Layer 4 prompt from Module 1?"
- "What would you need to add to make this handle your actual alerts?"

**1:20 — Bridge statement (5 min)**

"Platform AI (Module 2) gives you AI inside existing services. This (Module 3) is what it looks like when you build your own. Day 2 is how you build it with structure. Day 3 is how you build it production-safe."

### Common participant questions

**Q: "Does the agent actually run AWS commands, or just pretend to?"**
A: "In this demo, it's using mock data. In your production environment, it can run real AWS CLI commands — we configure the tool safety boundaries in Module 8 to control exactly what it can and cannot execute."

**Q: "What model is Hermes using?"**
A: "The model is configurable — I have it pointed at OpenRouter Claude right now. The framework is model-agnostic. You can point it at Gemini, Grok, or a local Ollama model. The agent behavior stays the same."

---

## 1:30 PM — Module 4: Impact Assessment — Where to Automate First (90 min)

**Duration:** 1:30 – 3:00 PM
**Tool:** None — this is a structured exercise
**Solo-completable:** Yes. The exercise is designed for individual completion and works identically for workshop participants and Udemy learners.

### Setup requirements

- Module 4 scoring template accessible (lab file or printed copy)
- Whiteboard or screen for drawing the Automation Quadrant diagram
- Participants' icebreaker task lists from 9:00 AM (they should have noted them)

### Facilitator flow

**1:30 — Draw the Automation Quadrant (5 min)**

Draw the 2x2 matrix on the whiteboard. Label axes: Frequency (vertical) and Complexity (horizontal). Label quadrants A, B, C, D. This is a teaching moment — participants should be drawing their own version.

"Quadrant B is where you start. High-frequency, lower-complexity tasks. These are your alert triage workflows, standard deployment health checks, routine cost anomalies. The AI gets repetitions, the human gets time back."

"Quadrant A is augmentation territory — the AI assists, the human decides. Complex incidents, novel failure modes, architectural judgment calls."

**1:35 — Solo scoring exercise (20 min)**

"Take your list from this morning — your top 10 repetitive tasks. Score each one: frequency (1-5) and complexity (1-5). Place each on the quadrant."

Walk the room. Assist with scoring if stuck. Encourage specificity: "Don't write 'incident response' — write 'P2 alert triage for known patterns.'"

**1:55 — Table share (20 min)**

"Share your top 3 Quadrant B candidates with your table. Find the one that's clearest — high frequency, well-defined output, repeatble pattern. That's your capstone candidate."

For virtual sessions: breakout rooms of 3-4.

**2:15 — Full-room debrief (15 min)**

Ask tables to share their top candidates. Key facilitation moves:
- When someone picks a high-complexity task: "That's a strong Quadrant A candidate — where would the AI assist vs. decide?"
- When someone picks a vague task: "What does 'done' look like for that task? If you can't describe the output, the agent can't produce it."
- Connect to Module 10: "Remember this candidate. On Day 3, it becomes your agent."

**2:30 — Problem statement drafting (20 min)**

"Draft a one-paragraph problem statement for your capstone candidate. It should capture:
1. The operational task (specific, not vague)
2. What 'manual' looks like today — how long it takes, what errors happen
3. What the agent would do — what it sees, what it does, what it outputs"

Collect these problem statements. They become the starting point for Module 10.

**2:50 — Close (10 min)**

"Keep this scoring sheet. Day 3 starts with your Module 4 candidate. If your organization has standardized on a different framework for automation decisions, use that — but do the scoring exercise with whatever framework you use."

Preview Day 2: "Tomorrow you'll learn how to code with AI assistance (Module 5) and how to generate infrastructure-as-code (Module 6). Those skills are the mechanics of building your Day 3 agent."

### Common participant questions

**Q: "What about tasks we're not allowed to automate for compliance reasons?"**
A: "Put them in the scoring, then add a governance flag. Day 3 covers governance boundaries — those tasks can still benefit from an advisory-mode agent that makes recommendations but never acts. Quadrant A is your compliance-safe zone."

**Q: "What if my top candidates are all Quadrant A?"**
A: "That's a signal your current infrastructure is complex, which is common. Pick the Quadrant A task with the clearest human decision point — that's where augmentation adds the most value. The agent handles the analysis; you make the call."

**Q: "Can the agent score be wrong? What if I picked the wrong quadrant?"**
A: "The quadrant placement is a starting hypothesis, not a permanent assignment. Agents typically start at L1 (advisory) regardless of quadrant — they prove themselves before getting more autonomy. We cover the promotion criteria in Module 9."

---

## 3:00 PM — Afternoon Break (15 min)

---

## 3:15 PM — Module 4 Wrap and Day 1 Close (45 min)

**Duration:** 3:15 – 4:00 PM

### Capstone candidate collection

Before wrapping, collect each participant's:
- Top capstone candidate task (name and one-line description)
- Module 4 scoring sheet (photo or digital copy)
- Draft problem statement

If running a live workshop with multiple facilitators, pool these for Day 3 team assignment. Teams with complementary domains (SRE + DBA + DevOps) make the richest capstone outputs.

### End-of-day wrap

**Recap what was covered:**
1. Context engineering — the core skill (Module 1)
2. Platform AI — what your cloud already provides (Module 2)
3. Custom agents — what you build when the platform isn't enough (Module 3)
4. Impact assessment — where to start (Module 4)

**Preview Day 2:**
"Tomorrow is about building with AI assistance — not talking to AI, building WITH it. Module 5 is structured AI coding: using Claude Code or Crush to generate infrastructure artifacts (Helm charts, CI/CD pipelines) using a disciplined workflow. Module 6 takes that further with full Terraform and GitOps automation. By end of Day 2 you'll have generated and validated real IaC from your own infrastructure domain."

**Reminder:** "Keep your Module 4 scoring sheet. Day 3 starts from your capstone candidate."

---

## Facilitation Notes

### Managing the two-speed room

Some participants will finish Module 1 layers quickly. Have a ready prompt for them: "Try adding your team's actual SLO thresholds to Layer 3. What changes in the output? How would you structure a Layer 4 prompt that a new SRE could use for their first on-call shift?"

### Handling "we already do this with scripts"

Common pushback: "We have Python scripts that do alert triage." Acknowledge it: "Scripts are deterministic — they handle cases you anticipated. What happens with the cases you didn't anticipate? That's where context engineering and AI assistance add value. It's not replacing your scripts; it's adding judgment for the edge cases."

### Handling "our security team won't allow this"

Acknowledge this seriously: "Governance is Module 13, and it's not an afterthought. The course teaches you to design agents with governance from day one — approval gates, audit logs, allowed/blocked command lists. We'll address the security architecture explicitly. For now, assume read-only access and advisory mode."
