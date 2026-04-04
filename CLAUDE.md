# Agentic DevOps Course — Content Development

## What This Is

Course content repository for "Agentic DevOps: Building Agentic Skills for Infrastructure Automation" — a 3-day advanced workshop for DevOps practitioners who are completely new to AI/agentic systems.

**DevOps scope is BROAD:** Infrastructure automation, containerization (Docker/K8s), CI/CD pipelines, GitOps, observability/monitoring, SRE practices, cloud (AWS), IaC (Terraform/Ansible), and everything in between. Labs and examples should draw from the full DevOps spectrum, not just one slice.

## Distribution

**Dual format:**
1. **Live 3-day workshop** — instructor-led, hands-on, team exercises
2. **Udemy course** — self-paced online version, targeting top-selling Agentic DevOps course

Content must work for BOTH: structured enough for self-paced Udemy learners, rich enough for live delivery. Labs must be completable solo (no team exercise dependencies for online version).

## Build Strategy

**Labs/projects FIRST, then explainers/concepts derived from the hands-on content.**

1. Build hands-on labs and projects for each module
2. Use Claude Cowork to generate conceptual explainers and reading materials based on the lab content
3. Create quizzes derived from both
4. Record video lessons for Udemy using explainers + live lab walkthroughs

## Learner Profile

- **Strong:** Full DevOps spectrum — IaC (Terraform/Ansible), containerization (Docker/K8s), CI/CD pipelines, GitOps, observability/monitoring, SRE, cloud (AWS), git workflows, CLI tools
- **Zero:** AI, LLMs, agents, prompt engineering, context engineering
- Must build their AI mental model from scratch using DevOps analogies

## Course Structure Per Module

```
module-NN-name/
├── README.md              # Module overview, objectives, prerequisites
├── explainer/             # Conceptual content (Excalidraw sources, slide notes)
│   └── diagrams/          # PNG exports
├── reading/               # Markdown reading materials
│   ├── concepts.md        # Core concepts
│   └── reference.md       # Reference material
├── lab/                   # Hands-on lab
│   ├── LAB.md             # Step-by-step instructions
│   ├── starter/           # Starting files
│   └── solution/          # Complete solution
├── quiz/                  # Assessment
│   └── QUIZ.md            # Questions + answers
└── exploratory/           # Optional stretch projects
    └── PROJECTS.md
```

## Tool Split

| Modules | Primary Tool | Purpose |
|---------|-------------|---------|
| 1 (AI Foundations) | Claude Code / OpenCode | Prompt engineering, context engineering labs |
| 2 (Platform AI) | AWS Console + CLI | Explore built-in AI features |
| 3 (Platform → Custom) | Hermes demo | Bridge content — live walkthrough |
| 4 (Impact Assessment) | Facilitation exercise | Team scoring, no code |
| 5 (Structured Coding) | Claude Code | Superpowers workflow for IaC |
| 6 (AI-Assisted IaC) | Claude Code | Terraform/Ansible/K8s generation |
| 7-8 (Skills + Tools) | **Hermes** | SKILL.md authoring, tool wiring |
| 9 (Design Patterns) | Conceptual + Hermes examples | Pattern teaching |
| 10 (Domain Agents) | **Hermes** | Full agent builds (3 tracks) |
| 11-13 (Fleet/Triggers/Gov) | **Hermes** | Advanced agent systems |
| 14 (Capstone) | Participant-driven | Presentations + 30-day plan |

## What's Built HERE vs in Hermes Repo

| This Repo (course/) | Hermes Repo (hermes-agent/) |
|---|---|
| Modules 1, 2, 4, 5, 6 labs | Modules 7, 8, 10, 11, 12, 13 labs |
| All conceptual explainers | DevOps agent skills (SKILL.md) |
| All reading materials | Sample agent profiles |
| All quizzes | Simulated infra data |
| Module 3, 9, 14 content | Hermes governance extensions |
| Participant setup guide | Hermes-specific setup |

## Key Constraint: No Paid API Access

Participants use existing subscriptions or free tiers only:
- Claude Pro/Team subscription (via Claude Code)
- Google AI Studio (free)
- Hugging Face Inference (free tier)
- OpenRouter free credits
- Design all labs to minimize token usage

## Key Constraint: Free Tier Infrastructure

- AWS free tier (note: changed July 2025 to 6-month credits for new accounts)
- KIND for Kubernetes (local, free)
- Simulated/mock data for RDS, Cost Explorer
- No paid observability required

## Context Engineering > Prompt Engineering

The course emphasizes **context engineering** as THE core skill for building agentic systems. It's not about writing clever prompts — it's about:
1. Structuring the right context (domain knowledge, system state, constraints)
2. Using expert vocabulary that gives AI the right frame
3. Building SKILL.md files that encode operational knowledge
4. Designing SOUL.md identity files that set the right behavioral context
5. Managing what the LLM sees (context window management, compression, selective injection)

This philosophy should pervade all content — labs teach context construction, not prompt tricks.

## References

- Course outline: `/Users/gshah/Downloads/Agentic DevOps.pdf`
- Hermes codebase: `/Users/gshah/work/agentic/devops/hermes-agent/`
- Hermes codebase map: `/Users/gshah/work/agentic/devops/hermes-agent/.planning/codebase/`
- Research findings: `/Users/gshah/work/agentic/devops/hermes-agent/.planning/research/`
- Handoff doc: See `HANDOFF.md` in this repo (copied from hermes-agent)
- Project context: `/Users/gshah/work/agentic/devops/hermes-agent/.planning/PROJECT.md`
