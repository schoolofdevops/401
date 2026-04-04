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

<!-- GSD:project-start source:PROJECT.md -->
## Project

**Agentic DevOps Course — Content Development**

Course content repository for "Agentic DevOps: Building Agentic Skills for Infrastructure Automation" — a 3-day advanced workshop (also published as a self-paced Udemy course) for DevOps practitioners who are completely new to AI/agentic systems. The course takes participants from zero AI knowledge through building production-grade domain agents, using their deep infrastructure expertise as the foundation.

**Core Value:** DevOps practitioners learn to build AI agents that encode their operational expertise — context engineering (not prompt tricks) is THE skill that makes agents useful.

### Constraints

- **Timeline**: Content must be complete by 2026-04-05 (course starts 2026-04-06)
- **No paid APIs**: Participants use existing Claude subscription, Google Gemini free, OpenRouter, Grok, or other free-tier providers
- **Free infra**: AWS free tier, KIND for K8s, mock data for services not on free tier
- **Dual format**: Content must work for both live 3-day workshop AND self-paced Udemy learners
- **Tool flexibility**: Claude Code primary, OpenCode fallback — labs must include provider setup instructions for multiple backends
- **Module structure**: Every module follows standard structure (README.md, explainer/, reading/, lab/, quiz/, exploratory/)
<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->
## Technology Stack

## Recommended Stack
### Core Content Format
| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Markdown (.md) | CommonMark | All course content — labs, readings, quizzes, READMEs | Native Git diff, toolchain-agnostic, renders on GitHub, Udemy resource uploads accept markdown-sourced PDFs. No build step required for instructors. |
| Plain JSON fixtures | — | Simulated AWS service outputs (CloudWatch, Cost Explorer, kubectl) | No runtime dependency. Files live in `data/` subdirectories, checked in with the module. Zero participant setup friction. Reliable offline labs. |
| Bash lab scripts | sh/bash | Step-by-step executable lab instructions | DevOps learners are CLI-native. Scripts double as solution reference. Tested on macOS and Linux. |
| YAML | — | KIND cluster configs, Kubernetes manifests, Ansible playbooks | All target tooling uses YAML natively. No translation layer. |
| HCL (Terraform) | ~1.9+ | IaC lab files (Module 6) | Course teaches Terraform; must use native HCL. |
### AI Coding Agent Tooling (Participant Labs)
| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Claude Code | Current (via Claude subscription) | Primary AI coding agent for labs | Participants likely already have Claude Pro/Team. Tightest integration with Anthropic models. Agentic-first design. |
| Crush (formerly OpenCode) | Latest (charmbracelet/crush) | Fallback multi-provider terminal agent | Successor to OpenCode after September 2025 name change; maintained by Charm team. Supports 75+ providers via `/connect`. Free tier via Groq or Gemini. |
### Local Kubernetes (K8s Lab Infrastructure)
| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| KIND (Kubernetes in Docker) | v0.31+ | Local K8s cluster for Module 6 labs | Zero cloud cost. Multi-node clusters start in <60 seconds. Pure Docker nodes — familiar to DevOps learners. Official CNCF project. Ships with kubectl-compatible API. |
| kubectl | Matching cluster version | Cluster interaction | Standard CLI; participants already know it. |
| Helm | 3.x | Deploy lab workloads onto KIND cluster | Standard package manager; avoids raw YAML sprawl in lab files. |
### AWS Simulation Strategy
| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Static JSON fixtures | — | Mock CloudWatch alarms, Cost Explorer responses, EC2/RDS metadata | Fully offline. No account required. Perfectly reproducible outputs. Checked in alongside lab. |
| LocalStack Community (non-commercial) | Latest | Optional: live Terraform/Ansible `apply` against mock AWS endpoints | Free tier remains for non-commercial use (as of March 2026 pricing changes; community edition EOL March 23, 2026 → requires auth but stays free for non-commercial). |
| Terraform mock provider (`mock_provider`) | Terraform 1.7+ | Unit test Terraform configs without real AWS calls | Built into Terraform 1.7+. No additional tools. Validates plans, outputs, data sources offline. |
### Free-Tier LLM Access (Multi-Provider Labs)
| Provider | Free Limits (as of early 2026) | Use In Course | Notes |
|----------|-------------------------------|---------------|-------|
| Google AI Studio (Gemini API) | Gemini 2.5 Flash: 10 RPM / 500 RPD; Flash-Lite: 15 RPM / 1,000 RPD | Modules where non-Claude provider needed | Limits reduced ~50-80% in Dec 2025. 500 req/day sufficient for lab work. API key from aistudio.google.com, no billing setup. |
| Groq | llama-3.1-8b-instant: 14,400 req/day, 6,000 TPM | Fast inference demo labs | Fastest inference. No credit card. Good for showing token throughput. |
| OpenRouter | Models with `:free` suffix | Flexible fallback with model variety | Free credits finite; `:free` models change. Use as last resort, not primary. |
| Hugging Face Inference API | Free tier (rate-limited) | Very low priority | Slowest, least reliable. Only for participants with zero other options. |
| Anthropic (Claude Pro/Team) | Unlimited within subscription | Primary for all labs | Most participants already have this. Claude Code requires it. |
### Content Tooling (Author-Side)
| Tool | Purpose | Notes |
|------|---------|-------|
| Git + GitHub | Version control, collaboration, Udemy resource packaging | Standard. All content checked in. |
| markdownlint-cli2 | Markdown lint in CI | Catches broken links, heading hierarchy, code fence syntax. Run via GitHub Actions on PRs. |
| Vale | Prose style linting | Enforces consistent terminology (e.g., "context engineering" not "prompt engineering"). Configure with custom vocab. Optional — adds polish but not required for launch. |
| GitHub Actions | CI pipeline | Run markdownlint on push/PR. Optionally validate JSON fixtures are valid JSON. Simple — no build step. |
### Udemy-Specific Considerations
| Concern | Approach |
|---------|----------|
| Video structure | Short videos (3-6 min) per concept. Lab walkthroughs recorded separately from concept explainers. |
| Downloadable resources | Export markdown labs as PDF (via Pandoc or GitHub PDF export). JSON fixtures and scripts as zip archives. |
| Quiz format | Udemy native quizzes. Quiz content authored in QUIZ.md then manually entered into Udemy (or via Udemy course API). |
| Section structure | One Udemy section per module. One lecture per major lab step or concept. |
| Solo completability | All labs written for solo completion. Team exercises in live workshop are noted as optional in Udemy version. |
## Alternatives Considered
| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Plain Markdown | MDX | Only if building an interactive course website with React components. Not relevant here. |
| Plain Markdown | Jupyter Notebooks | Only for data science / ML courses where live kernel execution is the point. Wrong for DevOps CLI labs. |
| KIND | Minikube | If participants cannot install Docker. Rare — Docker is a stated prerequisite for DevOps learners. |
| KIND | k3d | Acceptable substitution if KIND has issues on Windows. k3d is slightly lighter. |
| Static JSON fixtures | LocalStack | When a module specifically teaches Terraform against real-ish AWS endpoints (Module 6 optional stretch). |
| LocalStack | Mockoon | If you need HTTP-level mock (REST endpoint), not CLI-level. Mockoon is better for API mocking labs, not AWS CLI simulation. |
| Crush (Charm) | Aider | Aider is good for pure code editing. Crush/Claude Code are better for infrastructure and multi-file agentic work. |
| Google AI Studio free | OpenRouter :free | Use AI Studio first — limits are more stable and documented. OpenRouter free models change without notice. |
## What NOT to Use
| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Jupyter Notebooks for DevOps labs | Notebooks require a running kernel server, are awkward for CLI-heavy workflows, and don't reflect how DevOps practitioners work. Shell-based labs are more authentic and need less setup. | Markdown LAB.md with bash code blocks |
| OpenCode (opencode-ai/opencode) by name | Archived September 18, 2025. Outdated. | Crush (charmbracelet/crush) |
| LocalStack as a required lab dependency | Community edition EOL March 2026; free tier now requires account creation; non-commercial restriction. Lab blocking on account setup is bad UX. | Static JSON fixtures for required labs; LocalStack only for optional stretch exercises |
| MkDocs / Docusaurus | Adds a build/deploy layer for content that doesn't need it. Udemy expects downloadable files, not web URLs. | Raw Markdown files in a well-structured Git repo |
| Paid LLM APIs | Violates the explicit constraint — no paid APIs. Participants use subscriptions or free tiers. | Claude Pro subscription + Google AI Studio free + Groq free |
| Gemini 2.0 Flash model name | Deprecated February 2026, retiring June 1, 2026. | Gemini 2.5 Flash |
| Vale as a hard CI gate at launch | Vale requires style guide configuration work. If misconfigured, it blocks content merges unnecessarily. | Use markdownlint as hard gate; Vale as soft advisory check |
## Stack Patterns by Variant
- Use Claude Code as primary agent
- Skip Crush setup entirely
- All labs work out of the box
- Use Crush with Groq (free, fast, llama-based) for code-heavy labs
- Use Crush with Gemini 2.5 Flash for reasoning-heavy labs
- Provide `crush-setup.md` with `/connect` walkthrough for both providers
- Accept reduced context window compared to Claude Sonnet
- KIND labs are blocked — recommend Docker Desktop or Podman Desktop
- Module 6 K8s track falls back to manifest-only review (no apply)
- This is a known limitation; note in participant setup guide
- KIND works on Windows with Docker Desktop
- Bash scripts need WSL2 (note in setup guide)
- Claude Code works on Windows natively
- Crush works on Windows natively
## Version Compatibility
| Package | Compatible With | Notes |
|---------|-----------------|-------|
| KIND v0.31+ | Kubernetes 1.29-1.32 | KIND v0.31 ships with K8s 1.32 node image by default |
| Terraform 1.7+ | mock_provider feature | `mock_provider` block requires exactly 1.7.0 or later |
| Crush (Charm) latest | Groq, Gemini 2.5 Flash, Claude, OpenAI | Provider config via `/connect` — no version pinning needed |
| Google Gemini API | Gemini 2.5 Flash, Flash-Lite | Gemini 2.0 Flash deprecated; use 2.5 generation |
| LocalStack latest | Requires auth token since March 23, 2026 | Old pinned image tags (pre-3.x) run without auth but miss recent service support |
## Sources
- OpenCode archive notice and Crush successor — https://github.com/opencode-ai/opencode (archived Sept 18, 2025); https://github.com/charmbracelet/crush
- OpenCode provider list — https://opencode.ai/docs/providers/ (MEDIUM confidence — page visited April 2026)
- KIND documentation — https://kind.sigs.k8s.io/ (HIGH confidence — official CNCF project)
- LocalStack pricing changes — https://blog.localstack.cloud/2026-upcoming-pricing-changes/ (HIGH confidence — official blog, March 2026)
- LocalStack community EOL — https://www.infoq.com/news/2026/02/localstack-aws-community/ (MEDIUM confidence — verified against official blog)
- Google AI Studio rate limits — https://ai.google.dev/gemini-api/docs/rate-limits (MEDIUM confidence — limits subject to change; Dec 2025 reductions confirmed)
- Groq free tier limits — https://console.groq.com/docs/rate-limits (LOW confidence — limits change; verify before course delivery)
- Terraform mock provider — https://developer.hashicorp.com/terraform/language/tests/mocking (HIGH confidence — official HashiCorp docs, requires Terraform 1.7+)
- Crush + Groq integration — https://console.groq.com/docs/coding-with-groq/opencode (MEDIUM confidence — may reference old OpenCode name)
- Udemy course structure best practices — https://teach.udemy.com/course-creation/ (HIGH confidence — official Udemy instructor docs)
- Markdownlint CI integration — https://github.com/DavidAnson/markdownlint-cli2-action (HIGH confidence — official action)
- Vale prose linting — https://vale.sh (HIGH confidence — official docs)
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->

<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
