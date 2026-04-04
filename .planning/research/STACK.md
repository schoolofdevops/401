# Stack Research

**Domain:** Professional technical training course repository (DevOps/AI/agentic topics)
**Researched:** 2026-04-04
**Confidence:** MEDIUM-HIGH (most claims verified via web search or official docs; some LLM provider limits LOW due to frequent changes)

---

## Recommended Stack

### Core Content Format

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Markdown (.md) | CommonMark | All course content — labs, readings, quizzes, READMEs | Native Git diff, toolchain-agnostic, renders on GitHub, Udemy resource uploads accept markdown-sourced PDFs. No build step required for instructors. |
| Plain JSON fixtures | — | Simulated AWS service outputs (CloudWatch, Cost Explorer, kubectl) | No runtime dependency. Files live in `data/` subdirectories, checked in with the module. Zero participant setup friction. Reliable offline labs. |
| Bash lab scripts | sh/bash | Step-by-step executable lab instructions | DevOps learners are CLI-native. Scripts double as solution reference. Tested on macOS and Linux. |
| YAML | — | KIND cluster configs, Kubernetes manifests, Ansible playbooks | All target tooling uses YAML natively. No translation layer. |
| HCL (Terraform) | ~1.9+ | IaC lab files (Module 6) | Course teaches Terraform; must use native HCL. |

**Recommendation:** Plain Markdown + JSON fixtures is the right call for this course. Do NOT use Jupyter notebooks (see "What NOT to Use" below). Do NOT use MDX or a static site generator — the content lives in git and gets exported to Udemy as downloadable resources, not served as a website.

---

### AI Coding Agent Tooling (Participant Labs)

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Claude Code | Current (via Claude subscription) | Primary AI coding agent for labs | Participants likely already have Claude Pro/Team. Tightest integration with Anthropic models. Agentic-first design. |
| Crush (formerly OpenCode) | Latest (charmbracelet/crush) | Fallback multi-provider terminal agent | Successor to OpenCode after September 2025 name change; maintained by Charm team. Supports 75+ providers via `/connect`. Free tier via Groq or Gemini. |

**Note on OpenCode:** The `opencode-ai/opencode` repo was archived September 18, 2025. Development continues as `charmbracelet/crush`. All lab instructions that reference OpenCode must use the Crush name and repo URL. The workflow is identical — same TUI, same `/connect` flow.

---

### Local Kubernetes (K8s Lab Infrastructure)

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| KIND (Kubernetes in Docker) | v0.31+ | Local K8s cluster for Module 6 labs | Zero cloud cost. Multi-node clusters start in <60 seconds. Pure Docker nodes — familiar to DevOps learners. Official CNCF project. Ships with kubectl-compatible API. |
| kubectl | Matching cluster version | Cluster interaction | Standard CLI; participants already know it. |
| Helm | 3.x | Deploy lab workloads onto KIND cluster | Standard package manager; avoids raw YAML sprawl in lab files. |

**Why not Minikube or k3d?** KIND is the de-facto standard for CI and local testing (used in Kubernetes itself). k3d is a good alternative if Docker is unavailable, but KIND is simpler when Docker Desktop is already required. Minikube adds a VM layer and more moving parts — wrong tradeoff for a lab environment.

---

### AWS Simulation Strategy

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Static JSON fixtures | — | Mock CloudWatch alarms, Cost Explorer responses, EC2/RDS metadata | Fully offline. No account required. Perfectly reproducible outputs. Checked in alongside lab. |
| LocalStack Community (non-commercial) | Latest | Optional: live Terraform/Ansible `apply` against mock AWS endpoints | Free tier remains for non-commercial use (as of March 2026 pricing changes; community edition EOL March 23, 2026 → requires auth but stays free for non-commercial). |
| Terraform mock provider (`mock_provider`) | Terraform 1.7+ | Unit test Terraform configs without real AWS calls | Built into Terraform 1.7+. No additional tools. Validates plans, outputs, data sources offline. |

**Primary approach for this course: Static JSON fixtures.** LocalStack requires Docker and account creation; that friction is acceptable for advanced labs but the course should not depend on it for core labs. Modules 1–4 must work with zero cloud access.

**LocalStack caveat (verified 2026-04-04):** The free community Docker image is deprecated as of March 23, 2026. Free tier still exists but requires an account (non-commercial use only). If participants are using LocalStack on their own machines, they must create a free LocalStack account. Design labs to treat LocalStack as optional enhancement, not required.

---

### Free-Tier LLM Access (Multi-Provider Labs)

| Provider | Free Limits (as of early 2026) | Use In Course | Notes |
|----------|-------------------------------|---------------|-------|
| Google AI Studio (Gemini API) | Gemini 2.5 Flash: 10 RPM / 500 RPD; Flash-Lite: 15 RPM / 1,000 RPD | Modules where non-Claude provider needed | Limits reduced ~50-80% in Dec 2025. 500 req/day sufficient for lab work. API key from aistudio.google.com, no billing setup. |
| Groq | llama-3.1-8b-instant: 14,400 req/day, 6,000 TPM | Fast inference demo labs | Fastest inference. No credit card. Good for showing token throughput. |
| OpenRouter | Models with `:free` suffix | Flexible fallback with model variety | Free credits finite; `:free` models change. Use as last resort, not primary. |
| Hugging Face Inference API | Free tier (rate-limited) | Very low priority | Slowest, least reliable. Only for participants with zero other options. |
| Anthropic (Claude Pro/Team) | Unlimited within subscription | Primary for all labs | Most participants already have this. Claude Code requires it. |

**Confidence on LLM limits: LOW** — provider limits change frequently without notice. Lab instructions must include a note: "check current limits at [provider docs URL] — these change."

---

### Content Tooling (Author-Side)

| Tool | Purpose | Notes |
|------|---------|-------|
| Git + GitHub | Version control, collaboration, Udemy resource packaging | Standard. All content checked in. |
| markdownlint-cli2 | Markdown lint in CI | Catches broken links, heading hierarchy, code fence syntax. Run via GitHub Actions on PRs. |
| Vale | Prose style linting | Enforces consistent terminology (e.g., "context engineering" not "prompt engineering"). Configure with custom vocab. Optional — adds polish but not required for launch. |
| GitHub Actions | CI pipeline | Run markdownlint on push/PR. Optionally validate JSON fixtures are valid JSON. Simple — no build step. |

**Do NOT use MkDocs or Docusaurus.** This is a content repo, not a documentation website. Content gets exported to Udemy as downloadable files or embedded directly in Udemy sections. A static site adds build complexity with no student benefit. If a website is ever needed for the course, MkDocs Material is the right choice (Python-native, markdown-first, easy to theme).

---

### Udemy-Specific Considerations

| Concern | Approach |
|---------|----------|
| Video structure | Short videos (3-6 min) per concept. Lab walkthroughs recorded separately from concept explainers. |
| Downloadable resources | Export markdown labs as PDF (via Pandoc or GitHub PDF export). JSON fixtures and scripts as zip archives. |
| Quiz format | Udemy native quizzes. Quiz content authored in QUIZ.md then manually entered into Udemy (or via Udemy course API). |
| Section structure | One Udemy section per module. One lecture per major lab step or concept. |
| Solo completability | All labs written for solo completion. Team exercises in live workshop are noted as optional in Udemy version. |

---

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

---

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

---

## Stack Patterns by Variant

**If participant has Claude Pro/Team subscription:**
- Use Claude Code as primary agent
- Skip Crush setup entirely
- All labs work out of the box

**If participant has no Claude subscription:**
- Use Crush with Groq (free, fast, llama-based) for code-heavy labs
- Use Crush with Gemini 2.5 Flash for reasoning-heavy labs
- Provide `crush-setup.md` with `/connect` walkthrough for both providers
- Accept reduced context window compared to Claude Sonnet

**If participant cannot install Docker:**
- KIND labs are blocked — recommend Docker Desktop or Podman Desktop
- Module 6 K8s track falls back to manifest-only review (no apply)
- This is a known limitation; note in participant setup guide

**If participant is on Windows:**
- KIND works on Windows with Docker Desktop
- Bash scripts need WSL2 (note in setup guide)
- Claude Code works on Windows natively
- Crush works on Windows natively

---

## Version Compatibility

| Package | Compatible With | Notes |
|---------|-----------------|-------|
| KIND v0.31+ | Kubernetes 1.29-1.32 | KIND v0.31 ships with K8s 1.32 node image by default |
| Terraform 1.7+ | mock_provider feature | `mock_provider` block requires exactly 1.7.0 or later |
| Crush (Charm) latest | Groq, Gemini 2.5 Flash, Claude, OpenAI | Provider config via `/connect` — no version pinning needed |
| Google Gemini API | Gemini 2.5 Flash, Flash-Lite | Gemini 2.0 Flash deprecated; use 2.5 generation |
| LocalStack latest | Requires auth token since March 23, 2026 | Old pinned image tags (pre-3.x) run without auth but miss recent service support |

---

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

---

*Stack research for: Agentic DevOps training course content repository*
*Researched: 2026-04-04*
