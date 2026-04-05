# Instructor Guide: Day 2 — Structured AI Coding and IaC

**Modules:** 5a (Structured AI Coding), 5b (AI Workflows), 6 (AI-Assisted IaC)
**Day Duration:** ~6 hours (9:00 AM – 5:00 PM with breaks)
**Prerequisite:** Day 1 complete — participants have a Module 4 capstone candidate and understand context engineering basics

---

## Pre-Day Setup Checklist

- [ ] Reference application running in KIND cluster on your machine (for demo purposes)
- [ ] Claude Code and/or Crush installed and configured (at least one LLM provider active)
- [ ] `/gsd:new-project` command tested in a scratch directory — this is the live demo centerpiece
- [ ] Terraform mock_provider tested if demonstrating Track A fallback
- [ ] kubectl + helm installed for Track A helpers
- [ ] ArgoCD installed in KIND with memory patches applied (pitfall prevention — see Module 6 lab)
- [ ] `setup-argocd.sh` tested end-to-end on your demo machine

---

## 9:00 AM — Day 2 Open and Track Selection (15 min)

**Before splitting tracks, do a 5-minute re-anchor:**

"Yesterday you learned context engineering. Today you apply it at the coding level — using AI as your pair programmer for infrastructure work, then generating full IaC artifacts."

"Module 5a has two tracks: **Track A (Helm chart generation)** or **Track B (CI/CD pipeline generation)**. Pick the one closest to your current work. You'll follow one track for the morning. Both tracks teach the same workflow — the choice is just which infrastructure domain you're more fluent in."

**Ask participants to declare their track:** Have them write it on a card or chat message. Count: Track A vs Track B. Groups of 3-4 on the same track will naturally collaborate — encourage this.

---

## 9:15 AM — Module 5a: Structured AI Coding (120 min)

**Duration:** 9:15 AM – 11:15 AM
**Tool:** Claude Code or Crush
**Tracks:** A (Helm chart) and B (CI/CD pipeline) — both tracked in the same lab guide

### Setup requirements

- Track A: kubectl, helm installed; reference app available (KIND cluster or provided YAML)
- Track B: GitHub Actions syntax knowledge helpful; any CI/CD config in participants' existing repos is useful context

### CRITICAL: Enforce Step 0 as a gate

Step 0 is the gap analysis — participants analyze their existing infrastructure BEFORE using AI. This is the hardest facilitation challenge of Day 2. Participants want to skip ahead to "let the AI write it." Enforce the gate:

**Say this:** "Before you open Claude Code, do Step 0. Understand what you're about to generate. If you don't understand the target output, you can't validate what the AI produces. This is not optional."

**Why it matters:** The structured coding workflow teaches that AI assistance requires engineering judgment, not just prompting. Step 0 establishes that judgment before the AI produces anything.

### Facilitator flow

**9:15 — Track selection confirmed (5 min)**

Confirm groups are formed. Direct Track A to one side of the room (or one breakout) and Track B to another. You can split facilitation if you have a co-trainer.

**9:20 — Step 0 execution (20 min)**

Walk the room aggressively during Step 0. For Track A: "What does this service actually need from Helm? What are the required values? What are the optional ones?" For Track B: "What are the trigger conditions for this pipeline? What's the expected branch protection behavior?"

Participants who skip Step 0 will struggle with validation in Step 4. Reinforce: "Document your gap analysis. You'll refer to it when the AI misses something."

**9:40 — Steps 1-5 with AI (60 min)**

Participants work through the 5-phase workflow: Brainstorm → Design → Blueprint → Implement → Validate. This is self-directed with facilitation. Key moments:

- **Brainstorm phase:** Watch for participants who are too vague with the AI. Prompt: "Add your specific service constraints — what are the resource limits, what's the replica strategy, what namespace?"
- **Blueprint phase:** This is where the CLAUDE.md file is written. Common confusion: "What goes in CLAUDE.md vs what goes in the prompt?" Answer: "CLAUDE.md is standing context — your project-level constraints. The prompt is the task."
- **Implement phase:** Remind participants to commit before asking AI to make changes. Version control discipline applies even in AI-assisted coding.
- **Validate phase:** "Run the output against your Step 0 analysis. What did the AI produce that wasn't in your spec? What did it miss?"

**10:40 — Module 5a Cross-track debrief (20 min)**

Bring both tracks together. Ask:
- Track A: "What did the AI include in your Helm chart that you didn't ask for?"
- Track B: "Where did the AI make a security assumption you wouldn't have made?"
- Both: "What did you have to correct?"

Key message: "AI-assisted coding is not 'AI writes it, you paste it.' It's 'you specify precisely, AI generates a draft, you validate against your specification.' The engineering judgment is yours."

### Common participant questions

**Q: "The AI generated a Helm chart with default values that don't match our production config."**
A: "That's exactly what Step 0 is for. Your gap analysis should have captured those production values. Add them to your CLAUDE.md as project constraints — they'll persist across all AI interactions in this project."

**Q: "Should we use --dangerously-skip-permissions in Claude Code?"**
A: "Not in production environments. For this lab, the reference app is isolated in KIND. In your real infra, define an allowed commands list and work within it. Module 8 covers the safety boundary configuration."

**Q: "Track B: GitHub Actions syntax keeps changing. The AI generated deprecated syntax."**
A: "Add your GitHub Actions version constraint to CLAUDE.md. Also useful: paste the GitHub Actions runner version from a recent successful workflow run as context. The AI generated from its training data — give it your actual version requirements."

---

## 11:15 AM — Break (15 min)

---

## 11:30 AM — Module 5b: AI Workflows and GSD (90 min)

**Duration:** 11:30 AM – 1:00 PM
**Tool:** Claude Code (GSD workflow) and/or Crush
**This module has no track split — everyone does the same workflow**

### Facilitator flow

**11:30 — Live demo of /gsd:new-project (15 min)**

This is the centerpiece of Module 5b. Do the demo yourself on a scratch project before participants follow along.

```bash
mkdir scratch-demo && cd scratch-demo
# In Claude Code:
/gsd:new-project
```

Walk through the GSD initialization sequence live. Key narration moments:
- When it asks for requirements: "This is context engineering at the workflow level — you're structuring what the planning agent needs to know before it plans anything."
- When it generates the roadmap: "Notice it generated phases, not just tasks. It's thinking about dependencies."
- When it generates a plan: "This is a PLAN.md file — structured execution spec. The agent will execute this plan step by step, committing each task."

Say: "GSD is the structured workflow for using AI on real projects. You're not chatting with AI — you're directing an agent with a formal specification."

**11:45 — Memory systems section (30 min)**

This section splits by tool choice:
- Claude Code users: claude-mem path (`.claude/` directory, memory bank pattern)
- Crush users: MCP memory server path

Say: "Follow the path for your tool. The concept is the same — persistent context that survives session boundaries. The implementation is tool-specific."

Walk the room and assist with setup. Common issues:
- Claude Code: memory bank not initializing (check `.claude/` directory permissions)
- Crush: MCP memory server not starting (check node version, mcp config syntax)

**12:15 — Plan modes lab (15 min)**

Participants run a real GSD plan on a small real project (or the reference app lab task). Key facilitation:
- "This is not a demo anymore — this is your actual workflow. After today, you can use this on real infrastructure work."
- Show how the agent commits each task separately. "This is your audit trail. Every change is a commit. Every commit has a message explaining what was done and why."

**12:30 — Debrief and context engineering deep dive (15 min)**

"What did you put in your CLAUDE.md? What was the most important context to include?" Collect answers. Common best-in-class answers: team conventions, deployment constraints, tool versions, escalation paths.

Preview Module 6: "This afternoon you apply the same workflow to full infrastructure as code. Terraform (Track A) or K8s+ArgoCD GitOps (Track B)."

### Common participant questions

**Q: "How does GSD compare to GitHub Copilot Workspace?"**
A: "GSD is explicitly structured around infrastructure work — it has built-in concepts for phases, plans, verification steps, and commit discipline. Copilot Workspace is more general coding. The workflow pattern is similar, the IaC specialization is different."

**Q: "The agent diverged from the plan — it added stuff I didn't ask for."**
A: "That's the deviation system working. Check the SUMMARY.md it generates — it documents every deviation. If a deviation is wrong, you can revert it. If it's right, you've learned something about your own spec. The deviations are data."

**Q: "My memory bank isn't persisting between Claude Code sessions."**
A: "Check that claude-mem is initialized in the project root. The `.claude/` directory must exist. Also confirm you're running Claude Code from the project directory, not a parent directory."

---

## 1:00 PM — Lunch Break (60 min)

---

## 2:00 PM — Module 6 Track Selection and Lab Intro (15 min)

**Duration:** 2:00 – 2:15 PM

Second track selection of the day. Options:
- **Track A (Terraform):** Real AWS infrastructure generation with mock_provider fallback. Generates VPC + EC2 + security group configuration.
- **Track B (K8s + Helm + ArgoCD):** GitOps pattern for the reference app. Deploys via ArgoCD with Argo CD Application resource.

Note: Track C (Argo Workflows + GitHub Actions) was descoped per D-41. If participants ask, acknowledge: "Track C is planned for a future module update — the CI/CD material is covered in Module 5a Track B."

Selection guidance: "If you're primarily infrastructure/cloud, Track A. If you're primarily container/platform, Track B. If you did Module 5a Track B (CI/CD), consider Track A to get variety."

---

## 2:15 PM — Module 6: AI-Assisted Infrastructure as Code (120 min)

**Duration:** 2:15 – 4:15 PM
**Tool:** Claude Code with Terraform (Track A) or kubectl + ArgoCD (Track B)

### Setup requirements

**Track A:**
- Terraform 1.7+ installed (`terraform --version`)
- AWS credentials configured (or mock_provider as fallback — documented in lab Step 0)
- Note: If using real AWS, participants should have free-tier accounts. mock_provider generates valid Terraform HCL without making real API calls.

**Track B:**
- KIND cluster running with ArgoCD installed
- ArgoCD memory patches applied (CRITICAL — standard install requests 1.3GB total, causes OOM on laptop clusters)
- Confirm: `kubectl get pods -n argocd` shows all pods Running
- If ArgoCD pods are in OOM state: run `setup-argocd.sh --memory-patches` from the lab starter/

### Stall points and troubleshooting

These are the most common places participants get stuck:

**Track A stall points:**
1. **Terraform version mismatch:** The lab uses Terraform 1.7+ for mock_provider. If participants have 1.5.x, the mock_provider block will fail. Fix: update Terraform or use `required_version = ">= 1.7"` to surface the error clearly.
2. **AWS provider authentication:** Even with mock_provider, the aws provider block needs a region. Add `region = "us-east-1"` if participants see auth errors.
3. **AI-generated Terraform referencing deprecated syntax:** Common with older training data. The AI may generate `aws_instance` with `ami` attribute issues. Solution: add your Terraform version constraint to CLAUDE.md before generation.

**Track B stall points:**
1. **ArgoCD sync failure:** Most common cause is namespace mismatch between the Application resource and the actual deployment namespace. Check `kubectl describe application -n argocd` for sync errors.
2. **ArgoCD memory patches missing:** If pods are CrashLooping or OOMKilled, the patches were not applied. Run the memory patch commands from the lab. This is the most common Track B failure mode.
3. **Helm chart not found by ArgoCD:** ArgoCD pulls from the chart repo URL. If using a local chart, the path must be relative to the repo root and ArgoCD must have access to the repo.

### Facilitator flow

**2:15 — Step 0 gap analysis (30 min)**

Same enforcement as Module 5a. Participants document their target IaC output before touching Claude Code. For Track A: "What resources does this service need? VPC? Subnets? Security group rules?" For Track B: "What applications need ArgoCD management? What's the target sync policy?"

**2:45 — AI-assisted generation (60 min)**

Participants run the structured workflow with Claude Code. Key facilitation:
- "Apply the same CLAUDE.md discipline from Module 5. Add your provider version constraints, your region, your naming conventions."
- "When the AI generates a plan block, run `terraform plan` before `terraform apply`. The plan output is your validation step."

For Track B: "When ArgoCD creates the Application resource, check sync status immediately. If it shows Degraded, that's your feedback loop — understand WHY before asking the AI to fix it."

**3:45 — Validation and debrief (30 min)**

Bring both tracks together:
- "Show me your CLAUDE.md. What context made the AI's output more accurate?"
- "What did the AI generate that you would have written differently? Why?"
- "What does your Step 0 gap analysis say vs what the AI actually produced?"

### Common participant questions

**Q: "Track A: The AI generated Terraform for resources I don't have permissions to create in free-tier AWS."**
A: "Use mock_provider for the generation step. Add a comment in your CLAUDE.md: 'Use mock_provider — no live AWS credentials.' The generated HCL is still valid and reviewable. Switch to real provider when you have the permissions."

**Q: "Track B: ArgoCD keeps trying to sync but the app never becomes Healthy."**
A: "Check two things: (1) Is the app actually deployed? `kubectl get pods -n <your-namespace>`. (2) Is the ArgoCD Application resource pointing to the correct path and revision? Common issue: main vs master branch mismatch."

**Q: "How do I handle secrets in Terraform? The AI generated them as variables."**
A: "Good catch. Terraform variables for secrets should be marked `sensitive = true` and passed via environment variables or a secrets manager, never committed. This is a governance pattern — we cover secure IaC patterns in the Module 6 reference reading."

---

## 4:15 PM — Afternoon Break (15 min)

---

## 4:30 PM — Day 2 Wrap (30 min)

### Recap what was covered

1. **Structured AI coding** — the 5-phase workflow (Brainstorm/Design/Blueprint/Implement/Validate) with gap analysis as the gate
2. **GSD workflow** — formal AI project execution with plans, commits, and memory systems
3. **AI-Assisted IaC** — generating and validating Terraform or K8s+ArgoCD GitOps from structured specifications

### Save artifacts reminder

Remind participants to save:
- Their CLAUDE.md files (these are reusable context templates)
- Generated IaC artifacts (Helm charts, Terraform, ArgoCD Application resources)
- Gap analysis documents from Steps 0 in both modules
- These become reference material for Day 3 agent skill authoring

### Preview Day 3

"Tomorrow is when the course comes together. You'll build the agent for your Module 4 capstone candidate. Everything you've built so far — the IaC artifacts, the context patterns, the structured workflow — becomes input to your domain agent.

Day 3 starts with SKILL.md authoring (Module 7): encoding your operational expertise as machine-readable runbooks. Then you wire tools to the agent (Module 8), apply the patterns we discussed (Module 9), build your domain agent for your capstone candidate (Module 10), and connect it to your team's fleet (Module 11). By 4:00 PM you'll present your working agent."

---

## Facilitation Notes

### The speed gap is largest on Day 2

Module 6 in particular has wide variance — some participants will complete both tracks; others will still be in gap analysis at 4:00 PM. For fast finishers: "Complete the exploratory projects in Module 6 or refine your Module 5a CLAUDE.md based on what you learned from Module 6."

### Terraform vs ArgoCD: don't mix tracks mid-session

Participants sometimes switch tracks mid-lab because they hit a stall. This derails their learning — they lose the validation context from their Step 0 analysis. Encourage sticking with the chosen track and ask for help instead of switching.

### "The AI is not generating what I expected"

Redirect: "Add more context to CLAUDE.md. What constraint is the AI missing?" This reinforces the core learning: output quality is proportional to context quality. Vague context → vague output.
