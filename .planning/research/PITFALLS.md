# Pitfalls Research

**Domain:** Technical training course content development — Agentic DevOps workshop (live 3-day + Udemy self-paced)
**Researched:** 2026-04-04
**Confidence:** HIGH (lab design, dual-format, environment issues) / MEDIUM (Udemy rating mechanics) / LOW where flagged

---

## Critical Pitfalls

### Pitfall 1: Wrong Mental Model — Teaching "Context Engineering" But Delivering Prompt Tricks

**What goes wrong:**
The course claims context engineering is the core skill, but lab exercises are written as "write a better prompt" exercises in disguise. Participants learn to tweak instruction phrasing rather than construct information architecture (domain knowledge files, context window management, selective injection, SKILL.md as domain encoding). By Module 6 they're "prompt engineers" who think they understand context engineering because they got a better Terraform output by rephrasing a question.

**Why it happens:**
Content authors default to the simpler, more demonstrable skill. "Here's a prompt that generates a Terraform module" is easy to show; "here's how we structure domain state + vocabulary + constraints into the context the agent sees" requires more setup and a less immediately satisfying demo. The temptation to optimize for demo wow-factor defeats the conceptual goal.

**How to avoid:**
- Lab 1 must explicitly show the DIFFERENCE: run the same task with a bare instruction vs. with structured domain context (CloudWatch alarm schema + expert vocabulary + operational constraints). The delta in output quality IS the lesson.
- Every lab after Module 1 must include a "what context does the agent have?" section in the lab guide — explicitly naming the context components, not just the instructions
- SKILL.md authoring labs (Module 7+) are the payoff of Module 1 — draw the explicit connection: "SKILL.md is the context engineering artifact"
- Avoid calling anything a "prompt" in lab instructions after Module 2. Use "context block," "domain knowledge file," "system state," "constraint specification"

**Warning signs:**
- Lab steps say "try prompting the AI with X" more than "construct the context with X"
- Module 1 lab doesn't include a side-by-side comparison of bare vs. structured context
- Participants completing Module 3 can't explain what goes INSIDE a SKILL.md and why it differs from a system prompt

**Phase to address:** Module 1 (AI Foundations) lab design — establish the correct mental model before any other module builds on it

---

### Pitfall 2: Lab Timing Estimation Is Always Too Optimistic

**What goes wrong:**
A lab designed as "45 minutes" takes 90+ in delivery. The module schedule breaks down by Module 5. Day 3 is a death march. The capstone gets 20 minutes instead of 2 hours. Participants leave without experiencing the agent build that was the whole point of the workshop.

**Why it happens:**
Lab authors time themselves executing steps they designed, on hardware they know, with no debugging, on their first perfect attempt. Real participants hit environment issues (5-15 minutes), read instructions more slowly (2-3x author time), make wrong turns the lab didn't anticipate (add 10-15 minutes per wrong turn), and ask questions (add 5 minutes per question per person). Industry standard: developer training hands-on exercises take 2-3x their designed length in classroom delivery.

**How to avoid:**
- Design every lab at 50% of its target slot. If you have a 60-minute block, the lab should be completable in 30 minutes. The extra 30 is for environment issues, questions, and a stretch exercise for fast finishers.
- Label each lab step with an estimated time and build in explicit checkpoints: "If you're past 20 minutes and haven't completed Step 3, move to the checkpoint solution."
- Every lab needs a "fast forward" artifact: a pre-completed state participants can load when they fall behind (e.g., pre-written SKILL.md, pre-configured profile) that lets them continue participating without abandoning the lab entirely
- Time the lab with a test group (or a colleague doing it cold) before finalizing estimates. Never use author self-timing as the estimate.

**Warning signs:**
- Lab guide has no time estimates per step
- No "checkpoint solution" files for mid-lab recovery
- Module schedule has no buffer time between labs
- The capstone (Module 14) is scheduled at the end of a full day without contingency

**Phase to address:** Every module lab design — time estimates and checkpoint artifacts are required fields in the lab template; also Day 1-3 schedule construction

---

### Pitfall 3: Free-Tier API Provider Chaos — Multiple Providers, Zero Consistency

**What goes wrong:**
The course supports Claude Code + OpenCode + Google Gemini + OpenRouter. In a classroom of 20, 8 use Claude Code, 5 use Google AI Studio (free tier), 4 use OpenRouter, 3 have OpenCode. Each tool has different auth flows, different output formatting, different rate limits, and different failure modes. The instructor troubleshoots 4 different tool environments simultaneously. Lab time collapses.

Critical provider-specific traps:
- Google AI Studio cut free tier quotas by 50-92% in December 2025. Current free tier is approximately 10-50 RPM with actual limits lower than documented (MEDIUM confidence — confirmed from multiple user reports but not official announcement)
- Anthropic blocked third-party OAuth token use for Claude subscriptions in January 2026. OpenCode users cannot route Claude Max subscriptions through OpenCode — they need separate API keys with pre-purchased credits
- OpenRouter free models exist but are rate-limited by third-party providers unpredictably

**How to avoid:**
- Designate ONE primary path (Claude Code with Claude Pro subscription) as the canonical lab path. All screenshots, expected outputs, and troubleshooting guides are written against this path.
- OpenCode and other providers are explicitly "alternative paths" with a separate setup appendix and the explicit note: "instructor support is limited for alternative provider setups during workshop hours"
- Test EVERY lab on EVERY supported provider before delivery. Build a provider compatibility matrix in the setup guide
- For Google AI Studio labs (Module 2), use only `gemini-flash` or `gemini-flash-lite` (lowest rate limit consumption), not `gemini-pro`
- Include explicit rate limit warnings in the setup guide: "If using Google Gemini free tier, pace your requests to under 10 per minute"

**Warning signs:**
- Lab guide says "or use your preferred AI tool" without specifying expected output format differences
- No provider compatibility test results in the lab guide
- Google AI Studio used for multi-turn labs that require 20+ API calls per session
- Participant setup guide doesn't document the January 2026 OpenCode/Anthropic OAuth change

**Phase to address:** Cross-module participant setup guide (built in Phase 1) AND Module 2 AWS Platform AI lab (Google AI Studio is primary here)

---

### Pitfall 4: Audience Mismatch — Writing for AI Practitioners Instead of DevOps Practitioners

**What goes wrong:**
Explainers use AI-native vocabulary without DevOps translation: "attention mechanism," "embedding space," "inference endpoint," "temperature sampling." The reading materials recommend "think of it like a neural network" — which means nothing to someone who programs infrastructure, not models. Participants who are expert Terraform engineers feel stupid in Module 1. They disengage. Evaluations say "too theoretical," "not relevant to my work."

This is the inverse problem too: over-correcting by dumbing down AI concepts to the point where the DevOps analogy is wrong. "The context window is like a config file" is inaccurate enough to cause problems when participants try to apply the mental model in Module 7.

**How to avoid:**
- Every AI concept must have a DevOps-native translation. Validated translations:
  - Context window → "like a running CI job's workspace — everything the agent can 'see' in one execution"
  - Token → "like a unit of pipeline compute — you have a budget per call"
  - Temperature → "like the randomness dial on a canary deployment — 0 is deterministic, 1 is chaotic"
  - System prompt → "like a Dockerfile CMD — what the container does when it starts"
  - SKILL.md → "like an Ansible role's tasks/ directory — encoded operational knowledge"
- Validate analogies with a DevOps practitioner who hasn't seen LLM concepts before. If they misapply the analogy in a follow-up exercise, the analogy is wrong.
- Avoid these broken analogies: "LLM is like a search engine" (breaks when participants expect deterministic results), "prompt is like a SQL query" (breaks when participants expect exact-match behavior), "context window is like RAM" (breaks because LLM attention isn't uniform access)

**Warning signs:**
- Reading material introduces "embeddings" before the learner has built their first context-engineering lab
- Explainer slides use the phrase "neural network" without a DevOps analogy immediately following
- A DevOps practitioner reading Module 1 concepts can't pass the quiz without prior AI knowledge

**Phase to address:** All Module 1 content (reading/, explainer/) AND every subsequent module's concepts.md where AI terms are introduced

---

### Pitfall 5: Simulated AWS Data Drifts From Real AWS Output Formats

**What goes wrong:**
Mock CloudWatch alarm JSON is authored against the AWS SDK v2 response format. By the time participants use it in Module 6 with real AWS CLI (for those who have real accounts), the actual output format has changed slightly — field names, nested structure, date formats. The agent's SKILL.md was written against the mock format. It fails on real data with cryptic key errors. Participants who use real AWS feel the course is broken; participants using mock data don't discover this until the capstone.

Separately: mock data that is too clean fails the "production credibility" test. If every simulated alert has exactly one root cause, no noise, and a clean resolution path, participants leave thinking agents are more reliable than they are.

**How to avoid:**
- All mock JSON must include the exact field names from current AWS SDK/CLI documentation. Source each mock file against the real API documentation URL with the version date noted in a comment at the top of each file.
- Include one "noisy" scenario for every track where the agent must ask for clarification or identify multiple potential causes. The clean scenario is for learning; the noisy scenario is for validation.
- Test mock data against actual AWS CLI output once before delivery. Run `aws cloudwatch describe-alarms` (free call, read-only), compare field names to mock.
- Document the mock data version: `# Mock format: aws cloudwatch describe-alarms as of 2026-03-01 SDK v2 response`

**Warning signs:**
- Mock JSON files have no version/date comment at the top
- All mock scenarios have exactly one root cause and one clear resolution step
- Mock data was authored from memory rather than against actual API documentation
- No test confirming mock format matches real AWS CLI output

**Phase to address:** Module 6 (AI-Assisted IaC) and the cross-module simulated infrastructure data creation task

---

### Pitfall 6: Lab Instructions Written for Authors, Not Participants

**What goes wrong:**
Lab steps say "configure the agent" without specifying which file to edit, where it lives, what the current value is, what value to change it to, and how to verify the change took effect. A participant who encounters an error has no recovery path because the lab guide assumed zero ambiguity. Steps like "set up your environment variables" with no example of what the variables look like, their required format, or where to put them. Expert participants get through it; everyone else falls behind and stays behind.

**Why it happens:**
Lab authors know their own setup intimately. The knowledge gap between author and participant is invisible to the author. What takes 30 seconds to "just configure" for the author represents 5-15 minutes of trial-and-error for a participant seeing it for the first time.

**How to avoid:**
- Every configuration step must include: exact file path, current default value (if applicable), example target value, and a one-command verification step ("verify with: `cat .env | grep ANTHROPIC`")
- Write labs using the "stranger test": hand the lab guide to a colleague who doesn't know the project. If they get stuck anywhere, that step needs more detail.
- Expected output blocks for every step that produces output. Format: `Expected output:` block showing actual sample output, not just "you should see the agent respond." Include the first 2-3 lines of expected output verbatim.
- Distinguish between: commands to run (code block), files to edit (file path + exact diff), things to observe (expected output block), decisions to make (explicit decision callout)

**Warning signs:**
- Lab steps use verbs like "configure," "set up," "install" without a code block immediately following
- Expected output sections say "you should see the agent working" without showing what that looks like
- Lab was only tested by the author, not an independent reviewer seeing it fresh

**Phase to address:** Every lab module — build the clarity checklist into the lab review process before any lab is considered complete

---

### Pitfall 7: Dual-Format Blindspot — Live Workshop Content That Breaks in Self-Paced Udemy

**What goes wrong:**
Labs designed for live workshops include team exercises ("pair with a neighbor," "discuss in groups of 3") that become dead ends in Udemy. Concepts explained verbally by the instructor ("I'll show you what this looks like now") are referenced in labs but not in reading materials — Udemy learners have no explanation. Timing references ("we spent the morning on this") confuse asynchronous learners who may complete modules in any order over days or weeks.

Conversely: content over-engineered for Udemy self-paced (extremely detailed text walkthroughs of every step) bores live workshop participants who can ask questions and doesn't leave room for the instructor to respond dynamically.

**How to avoid:**
- All team exercises must have a solo fallback clearly documented. Example: "Team exercise: Automation Quadrant scoring — Solo fallback: score a hypothetical 5-person team using the provided scoring sheet, then compare against the reference scoring in `solution/reference-scoring.md`"
- No instruction or explanation may live only in a video or in the instructor's verbal delivery. If the concept is needed to complete the lab, it must be in `reading/concepts.md`.
- Strip all temporal references ("as we saw this morning," "from the previous session") from all written materials. Replace with module references ("as covered in Module 4").
- Content audit checklist before publishing: every lab completable by a participant working alone with no external context beyond the module materials

**Warning signs:**
- Lab guide says "as the instructor demonstrated..." anywhere
- Any exercise says "find a partner" without a solo alternative
- Reading materials reference video timestamps instead of having the content inline
- The Module 14 capstone presentation requires a team submission with no solo path

**Phase to address:** During the dual-format review pass after each module is written — every module needs a solo-completability check before it's marked done

---

### Pitfall 8: The "Prompt Engineering Relapse" Teaching Mistake

**What goes wrong:**
The course correctly introduces context engineering as the superior mental model. But in later modules, the lab language quietly reverts to prompt engineering framing — "try a different prompt," "adjust your prompt," "prompt the agent to..." By Module 8, participants have been subtly retrained back to the mental model the course was trying to replace. The vocabulary decay undermines the conceptual architecture of the entire course.

**Why it happens:**
"Prompt" is the default vocabulary used everywhere in the AI ecosystem. Course content written quickly (especially by AI-assisted generation) defaults to industry-standard vocabulary. Without explicit editorial discipline, "prompt engineering" vocabulary creeps back in.

**How to avoid:**
- Establish a course vocabulary glossary in `CLAUDE.md` and enforce it: "prompt" → "instruction block" or "query"; "prompt engineer" → "context engineer"; "write a prompt" → "construct the context"
- Run a vocabulary audit grep across all module content before publishing: `grep -r "prompt" --include="*.md" | grep -v "system prompt"` — review every hit
- Add the vocabulary drift check to the per-module review checklist
- In Module 9 (Design Patterns), explicitly name the vocabulary shift as a design pattern: "The Vocabulary Discipline pattern — why naming matters for mental model integrity"

**Warning signs:**
- Any lab guide after Module 2 uses the phrase "write a better prompt" as a fix for poor agent behavior
- Reading materials reference external resources (articles, docs) that use "prompt engineering" vocabulary without translation note
- Quiz questions use "prompt" where they should use "context" or "instruction"

**Phase to address:** Content vocabulary audit is a cross-cutting concern — enforce at creation time via CLAUDE.md and verify at content review time

---

## Technical Debt Patterns

Shortcuts that seem reasonable during content development but create problems at delivery time.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Write lab against one OS/environment, note "should work on all" | Faster to write | Participants on different environments hit unexplained failures; debugging eats lab time | Never — test on macOS arm64, macOS x86, and Linux before any lab ships |
| Use "latest" when specifying tool versions in setup guide | Always current | Version skew breaks labs mid-course; participants on different days have different tool behavior | Never — pin all versions explicitly |
| Copy module structure without customizing for module content | Consistent structure fast | README.md that says "[Module Name] objectives" with placeholder text; participants can't tell what a module covers | Never — each README must reflect actual module content |
| Skip the "solo fallback" for team exercises in first draft | Faster draft | Udemy learners hit dead ends; live workshop participants without partners are blocked | Never — write solo path at same time as team path |
| Use AI-generated mock CloudWatch data without validation | Fast data creation | Format diverges from real AWS output; agent fails when real accounts used | Acceptable only if mock is clearly labeled "illustrative only, not format-accurate" with real format docs linked |
| Auto-generate quiz questions from module content without expert review | Fast quiz creation | Questions test recall of terminology rather than ability to apply concepts; AI hallucinations in quiz answers | Never for questions — AI-assisted drafting acceptable if all questions reviewed and tested by a practitioner |

---

## Integration Gotchas

Common mistakes when course labs connect to external services and tools.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Google AI Studio (Module 2) | Use for all demos without testing rate limits | Test with free tier account only, not a paid account. Document the 10-50 RPM limit explicitly. Use `gemini-2.5-flash-lite` not `gemini-2.5-pro` for all lab exercises |
| Claude Code + AWS CLI (Modules 5, 6) | Assume Claude Code has access to AWS credentials automatically | Document explicit credential setup: `aws configure --profile lab` and verify with `aws sts get-caller-identity` before any lab starts |
| KIND cluster (Module 6) | Create cluster without specifying KIND config file | All labs needing a specific cluster topology must include a `kind-config.yaml` in `lab/starter/`. Never assume default single-node cluster is sufficient |
| OpenCode with Anthropic models | Assume Claude subscription works with OpenCode | Since January 2026, Anthropic OAuth tokens are blocked in third-party tools. OpenCode users need a separate API key. Document this explicitly in setup guide |
| Terraform with mock RDS (Module 6) | Use real Terraform provider that calls AWS even for plan-only runs | Provider initialization requires AWS credentials even for plan. Either use `terraform plan -lock=false` with mock provider or use localstack. Document the required workaround |
| AWS Cost Explorer mock data (Module 2) | Use mock data formatted against old Cost Explorer API | Cost Explorer response format changed in SDK v3. Verify mock format matches current `aws ce get-cost-and-usage` output structure before using |

---

## Performance Traps

Patterns that work in solo testing but fail under workshop conditions.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| All module 2 participants hit Google AI Studio simultaneously | 429 rate limit errors within 5 minutes of class exercise start | Stagger exercise start by 3-5 minutes per group, OR use a cached response mode for the demo portion | Any time 10+ participants run the same Google AI Studio lab simultaneously |
| Lab exercises not tested on arm64 Mac | `kubectl` output has different column widths on arm64; grep patterns fail; labs assume x86 line endings | Test all labs on M-series Mac before delivery | First time an arm64 participant runs a lab with expected-output comparison |
| Udemy learner completes modules out of sequence | Module 6 lab fails because Module 5 Ansible setup is a prerequisite | Add explicit prerequisite check at top of each lab: "Prerequisites: complete Module 5 lab, confirm `ansible --version` works" | Any Udemy learner who skips around |
| Free OpenRouter models switch without notice | Lab using `mistral/mistral-7b-instruct:free` gets a 404 because the free model was retired | Use only models with documented stability guarantees, or add retry logic in lab instructions | When OpenRouter retires or changes free model availability |
| Mock data loaded into agent causes context size explosion | Agent enters a very long reasoning loop, response takes 5+ minutes, context window fills | Cap mock data files at 50 records max for learning scenarios. Include explicit instruction: "If agent hasn't responded in 90 seconds, kill and reload with smaller scenario" | Any lab that loads a "realistic" large mock file without context size guidance |

---

## Security Mistakes

Content-level security issues specific to this course domain.

| Mistake | Risk | Prevention |
|---------|------|------------|
| Lab starter files contain author's real AWS account ID or region | Participants unknowingly use real account references; if they have real AWS access, operations run against real infrastructure | Sanitize all mock files: account IDs → `123456789012`, regions → `us-east-1` (generic), ARNs → `arn:aws:iam::123456789012:role/example` |
| Instructor's API key committed in any lab config file | Participants find and use instructor's Anthropic/AWS API key; billing impact, potential abuse | All API key fields in starter configs must use placeholder: `ANTHROPIC_API_KEY=your_key_here`. Git history must be audited before any public publish |
| Lab teaches "follow instructions in the alert description" as an agent pattern | Participants build production agents that are vulnerable to prompt injection via alert payloads | Module 8 must explicitly teach prompt injection as a threat. Labs must show agents that VERIFY before acting on external data. Never ship a lab whose SKILL.md says "follow the remediation steps in the alert" |
| Participants commit real credentials during lab exercises | Credential exposure in public GitHub if participants push their lab work | Setup guide must include: `echo "*.env" >> .gitignore`, pre-lab credential check: `git-secrets` or manual review. Warn explicitly: "never commit files with API keys" |
| KIND cluster exposed on all interfaces by default | Other participants on workshop network can access each other's clusters | KIND labs must include explicit networking config: `networking.apiServerAddress: "127.0.0.1"` in kind-config.yaml |

---

## UX Pitfalls

Common experience problems for participants trying to learn from this content.

| Pitfall | Participant Impact | Better Approach |
|---------|-------------|-----------------|
| Lab starts with setup steps that consume 30% of the lab time | Participants spend most of Module 1 installing tools, not learning | Pre-workshop setup guide does ALL environment setup. Module 1 lab starts with everything already installed — zero setup in-module |
| Difficulty curve is flat across all modules | Expert participants are bored in Modules 1-2; newer practitioners are overwhelmed in Modules 10-11 | Label each lab with difficulty indicator and include explicit "stretch" exercises for fast participants. Core lab is for everyone; stretch is for the fastest 20% |
| Quiz questions test recall of definitions, not application of concepts | Participants memorize vocabulary without understanding usage | All quiz questions should be scenario-based: "Given this CloudWatch output, what context would you provide to the agent?" not "Define context engineering" |
| Reading materials are comprehensive but have no scannable structure | Participants doing self-paced Udemy reading spend too long on concepts, not enough on labs | Each concepts.md must have: TL;DR (3 bullets) at the top, key terms glossary at the bottom, all headers linking to a table of contents. Dense prose only in middle sections |
| Module 14 capstone is described but not scaffolded | Participants stare at a blank 30-day plan template with no guidance | Capstone materials must include: example 30-day plan (annotated), presentation template with slide notes, rubric with concrete examples of what "good" looks like |

---

## Udemy-Specific Pitfalls

Issues that hurt ratings and discoverability specific to the Udemy distribution format.

### Video Production Issues That Tank Ratings
- **Poor audio:** Background noise, inconsistent volume, echoey room. Udemy learners cite audio quality as the top reason for 1-star reviews on technical courses. Invest in a USB condenser microphone, record in a treated room.
- **Talking heads without screen:** Technical content needs screen recording. Learners can't follow along without seeing the commands being run.
- **Reading from slides:** Udemy learners notice and resent this. Demo live, then reference the slide summary.
- **Long videos with one topic:** Udemy engagement data shows drop-off after 8-12 minutes per video. Break long demonstrations into discrete focused segments.

### Content Currency Issues
- Udemy's Content Quality Dashboard now flags courses where learner feedback signals outdated content. In a rapidly changing field (AI tools change monthly), outdated labs = 1-star reviews within weeks of release.
- Prevention: build an explicit content update calendar. Every module that touches a versioned external tool (Claude Code, Google AI Studio, OpenCode) needs a quarterly review checkpoint.

### Rating Timing Vulnerability
- Udemy prompts ratings after 12-15 minutes, which is before learners can evaluate lab quality. Early ratings reflect video production quality, not lab correctness.
- Prevention: ensure the first 15 minutes of Module 1 video is exceptionally polished. First impressions drive the initial rating cohort.

---

## "Looks Done But Isn't" Checklist

Things that appear complete but are missing critical pieces.

- [ ] **Module written:** Does it have a solo-completable version? Verify every team exercise has a solo fallback documented in the lab guide.
- [ ] **Lab tested:** Was it tested by someone OTHER than the author? Verify with a "cold read" — give to a colleague and time them.
- [ ] **Mock data created:** Does it include a noisy scenario? Verify there are at least 2 scenario files per track: `scenario-clean.json` and `scenario-realistic.json`.
- [ ] **Provider instructions included:** Are ALL supported providers documented? Verify Claude Code, OpenCode (with January 2026 caveat), Google AI Studio free tier, OpenRouter — each with a setup section.
- [ ] **Expected outputs documented:** Does every lab step with command output have an "Expected output" block? Verify no step says "you should see X" without showing X.
- [ ] **Checkpoint artifacts exist:** Can a participant who falls behind rejoin at a checkpoint? Verify each lab has a `solution/checkpoint-N/` directory for mid-lab recovery.
- [ ] **Time estimates included:** Does every lab section have a time estimate? Verify estimates were tested with someone other than the author.
- [ ] **Quiz validated:** Do all quiz answers actually reflect module content? Verify no AI-generated quiz question has been published without practitioner review.
- [ ] **Context engineering framing maintained:** Does the module avoid "prompt engineering" vocabulary? Verify with grep: `grep -ri "write a prompt\|better prompt\|adjust your prompt" module-*/`.
- [ ] **AWS data format current:** Was mock data verified against live AWS CLI output? Verify each mock file has a date comment and a documentation URL.

---

## Recovery Strategies

When pitfalls occur despite prevention, how to recover during delivery.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Lab timing catastrophe (running 2x over) | HIGH | Load checkpoint artifact for all participants; instructor live-demos the remaining steps while participants watch; defer stretch exercises entirely. Adjust Day 2/3 schedule to compress earlier modules |
| Rate limit cascade during cohort exercise | MEDIUM | Switch to mock/cached response mode immediately; stagger restarts; note in real-time which participants are on which provider and group them by provider for the remainder of the exercise |
| Multiple participants stuck on environment divergence | HIGH | Pair blocked participants with working participants; distribute devcontainer backup image via USB if no internet-based recovery works; instructor continues main cohort, TA assists blocked group |
| Wrong mental model entrenched by Module 3 | MEDIUM | Module 4 (Impact Assessment) provides a reset opportunity — use it to explicitly contrast "what a prompt engineer does" vs "what a context engineer does" as a facilitated discussion |
| Udemy learner leaves 1-star review citing broken lab | MEDIUM | Monitor Q&A daily in first month. Respond publicly within 24 hours with fix or workaround. Patch the lab and republish. A fast public response converts many 1-star reviewers to updated ratings. |
| Mock data format mismatch discovered during delivery | LOW | Replace the mock data file from the backup that was pre-verified. If no backup exists, have participants use only the Module 2 simulated path and skip real AWS comparison for that exercise |
| Google AI Studio rate limit during Module 2 lab | LOW | Switch participants to pre-recorded demo mode for the rate-limited portion; continue with cached API response files that produce valid output without hitting the API |

---

## Pitfall-to-Phase Mapping

How roadmap phases should prevent these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Wrong mental model (prompt vs. context engineering) | Module 1 lab design — side-by-side comparison exercise is the foundation | After Module 1 lab, participants can explain what goes inside a SKILL.md and why it's different from a prompt |
| Lab timing estimation | Every module lab design — enforce time estimates + checkpoint artifacts as required fields | Cold-test every lab with a colleague; verify 50% rule (lab fits in half its time slot) |
| Free-tier provider chaos | Phase 1 cross-module setup guide — provider compatibility matrix built and tested first | Verify every lab runs end-to-end on Google AI Studio free tier and Claude Pro before publishing |
| Audience mismatch (AI vs. DevOps vocabulary) | Module 1 reading materials — establish DevOps-native vocabulary map | A DevOps practitioner with zero AI knowledge can read Module 1 concepts.md and pass the quiz |
| Simulated data format drift | Module 6 data creation + pre-publish audit | All mock JSON files have date comment and API documentation URL; one file verified against live CLI |
| Unclear lab instructions | Every lab module — "stranger test" before lab is marked complete | Independent colleague cold-reads lab; no steps require clarification |
| Dual-format blindspot (team exercises) | Every module — solo fallback written at creation time, not as afterthought | Every team exercise has a solo alternative in the same lab guide; capstone has solo submission path |
| Prompt engineering vocabulary relapse | Cross-cutting — vocabulary discipline in CLAUDE.md + audit grep before publish | `grep -ri "write a prompt\|better prompt" module-*/` returns zero results |
| Udemy video quality | Pre-recording production setup — audio equipment, recording environment, segment length discipline | First 5 video segments reviewed against Udemy's quality standards before mass recording begins |
| Mock data security (real account IDs) | Pre-publish security audit — grep all files for real-looking account IDs and ARNs | `grep -r "aws_account_id\|[0-9]\{12\}" --include="*.json" .` returns only `123456789012` |

---

## Sources

- Anthropic Engineering: Effective Context Engineering for AI Agents — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- DEV Community: Thinking Clearly with LLMs — Mental Models and Cognitive Pitfalls — https://dev.to/puritanic/thinking-clearly-with-llms-mental-models-and-cognitive-pitfalls-in-prompt-engineering-3dmm
- DEV Community: Read This Before Building AI Agents (Lessons From The Trenches) — https://dev.to/isaachagoel/read-this-before-building-ai-agents-lessons-from-the-trenches-333i
- Planes Studio: The Mistakes Everyone Makes When Running a Workshop — https://www.planes.studio/learn/the-mistakes-everyone-makes-when-running-a-workshop
- Udemy: Course Quality Checklist Use of AI — https://support.udemy.com/hc/en-us/articles/30999984483607-Course-Quality-Checklist-Use-of-AI
- Udemy: Creating High-Quality Course Content Best Practices — https://teach.udemy.com/publishing/high-quality-course-content-best-practices/
- Google AI Studio Free Tier Rate Limits 2026 — https://www.aifreeapi.com/en/posts/google-gemini-api-free-tier
- Google Gemini API Free Tier Fiasco (December 2025 quota cuts) — https://quasa.io/media/google-s-gemini-api-free-tier-fiasco-developers-hit-by-silent-rate-limit-purge
- AWS Free Tier Changes July 15 2025 ($200 credits, 6-month plan) — https://aws.amazon.com/blogs/aws/aws-free-tier-update-new-customers-can-get-started-and-explore-aws-with-up-to-200-in-credits/
- Infralovers: Claude Code vs OpenCode 2026 — https://www.infralovers.com/blog/2026-01-29-claude-code-vs-opencode/
- OpenCode January 2026 Anthropic OAuth Block — https://thomas-wiegold.com/blog/i-switched-from-claude-code-to-opencode/
- ATD: How Long Does It Take to Develop One Hour of Training (10:1 ratio) — https://www.td.org/content/atd-blog/how-long-does-it-take-to-develop-one-hour-of-training-2017
- Hermes Agent PITFALLS.md (same project ecosystem, complementary pitfalls for Hermes-specific labs) — `/Users/gshah/work/agentic/devops/hermes-agent/.planning/research/PITFALLS.md`
- Context Engineering vs Prompt Engineering (Towards Agentic AI, 2025) — https://towardsagenticai.com/context-engineering-vs-prompt-engineering-the-2025-ai-shift/
- Medium: LLM Context Window Misunderstanding (90% of developers) — https://medium.com/@sohail_saifi/your-llm-prompt-engineering-is-wrong-why-90-of-developers-misunderstand-ai-context-windows-8af090c78083

---
*Pitfalls research for: Agentic DevOps Course — Content Development (live 3-day workshop + Udemy)*
*Researched: 2026-04-04*
