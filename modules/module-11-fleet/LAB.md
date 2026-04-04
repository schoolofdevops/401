# Module 11 Lab: Fleet Orchestration — Cross-Domain Incident Response

**Duration:** 90 minutes (45 min guided + 45 min free explore)
**Track:** Fleet — Cross-Domain Incident Response
**Prerequisite:** Module 10 complete — all three track agents installed and responding in mock mode
**Outcome:** Running a full fleet coordinator scenario in mock mode, observing how cross-domain synthesis identifies a root cause that no single-domain agent can find alone

> You are the incident commander. Three alerts fired within 5 minutes of each other. Your three
> specialist agents each find domain-specific findings. The fleet coordinator's job — and the lesson
> of this module — is to find the single root cause that explains all three. By the end of this lab,
> you will have run Morgan (the fleet coordinator) against the cross-domain scenario and evaluated
> whether it identified the `memory-hog` analytics service as the common cause across all three domains.

---

> **SOLO LEARNER PATH (Udemy / self-paced)**
>
> You will install all 4 profiles yourself and run them all locally. This lab is designed for a
> single person running all agents on one machine. There is no team dependency.
>
> **Steps 1–7 are your complete path.** All agents run as Hermes profiles on your local machine:
> `fleet`, `track-a`, `track-b`, and `track-c`. The fleet coordinator routes to your locally
> installed specialist profiles.
>
> ---
>
> **LIVE WORKSHOP VARIANT (Teams of 3)**
>
> If you are in a live workshop where each participant has already built their own Module 10 agent:
>
> - Person 1 (Track A) runs `hermes -p track-a chat` on their machine
> - Person 2 (Track B) runs `hermes -p track-b chat` on their machine
> - Person 3 (Track C) runs `hermes -p track-c chat` on their machine
> - Any one person installs Morgan (`fleet` profile) per Step 2
> - Morgan routes to each person's agent — the team variant happens organically
>
> The lab steps are identical. Skip the individual track installs in Step 2 if your track agent
> is already installed from Module 10.

---

## GUIDED PHASE — 45 minutes

---

## Step 1: Prerequisites and Individual Agent Verification (10 min)

Before running the fleet coordinator, verify each specialist agent works independently. A broken
specialist gives the coordinator incomplete findings — and coordinator synthesis will silently miss
an entire domain.

Export the environment variables from the root of your course directory:

```bash
export HERMES_LAB_SCENARIO=messy
export HERMES_LAB_MODE=mock
export MOCK_DATA_DIR="$(pwd)/infrastructure/mock-data"
export PATH="$(pwd)/infrastructure/wrappers:$PATH"
```

> **Verify mock wrappers are on PATH:**
>
> ```bash
> which mock-psql
> # Expected: <course-dir>/infrastructure/wrappers/mock-psql
> ```
>
> If `which mock-psql` returns nothing, re-run the `export PATH=` line above.

Now verify each track agent against the messy scenario. Run each in a separate terminal tab and
paste the prompt shown — you want a one-line confirmation that each agent finds domain findings:

**Track A — Database:**

```bash
hermes -p track-a chat
```

Prompt:

```
Check RDS slow queries — HERMES_LAB_SCENARIO=messy
```

Expected: Aria confirms `[MOCK MODE]` and reports slow queries on the production RDS instance.

**Track B — FinOps:**

```bash
hermes -p track-b chat
```

Prompt:

```
Check for cost anomalies — HERMES_LAB_SCENARIO=messy
```

Expected: The Track B agent confirms `[MOCK MODE]` and reports the 2026-04-02 cost spike.

**Track C — Kubernetes:**

```bash
hermes -p track-c chat
```

Prompt:

```
Check pod health — HERMES_LAB_SCENARIO=messy
```

Expected: The Track C agent confirms `[MOCK MODE]` and reports the api-deployment CrashLoopBackOff.

> **If any agent fails here, fix it before Step 2.**
>
> A broken specialist gives the coordinator incomplete findings. Common causes:
> - Profile not installed: run the `cp -r` install command from Module 10 for that track
> - Mock wrappers not on PATH: re-run the `export PATH=` line above in the terminal running the agent
> - Wrong scenario: confirm `HERMES_LAB_SCENARIO=messy` is set in the current shell
>
> Reference `course/infrastructure/scenarios/cross-domain.md` for the full expected behavior per agent.

Exit each agent when done: type `exit` or press Ctrl+C.

---

## Step 2: Install the Fleet Coordinator (5 min)

Install Morgan, the fleet coordinator, into your Hermes profiles directory:

```bash
cp -r course/agents/fleet-coordinator/ ~/.hermes/profiles/fleet/
```

Solo learners — also confirm all three track agents are installed (they were installed in Module 10,
but verify):

```bash
hermes profiles list
```

Expected output shows all four profiles:

```
fleet
track-a
track-b
track-c
```

If any track profile is missing, install it:

```bash
cp -r course/agents/track-a-database/   ~/.hermes/profiles/track-a/
cp -r course/agents/track-b-finops/     ~/.hermes/profiles/track-b/
cp -r course/agents/track-c-kubernetes/ ~/.hermes/profiles/track-c/
```

> **Note: The coordinator has NO skills/ directory. Its only capability is delegation.**
>
> Compare the profile directories:
>
> ```bash
> ls ~/.hermes/profiles/fleet/
> # Expected: SOUL.md  config.yaml   (no skills/ directory)
>
> ls ~/.hermes/profiles/track-a/
> # Expected: SOUL.md  config.yaml  skills/
> ```
>
> The fleet coordinator's `config.yaml` uses the `delegation:` block instead of `skills/`.
> This is the key architectural difference: specialists have domain skills, coordinators have
> delegation configuration. A coordinator with skills would execute domain commands itself —
> defeating the purpose of delegation.

---

## Step 3: Read the Cross-Domain Incident Scenario (5 min)

Read the full scenario that Morgan will investigate:

```bash
cat course/infrastructure/scenarios/cross-domain.md
```

Read the **Context** section carefully. Three alerts fire within 5 minutes of each other:

```
[08:47 UTC]  PagerDuty:  api-deployment CrashLoopBackOff (OOMKilled, 8 restarts)
[08:51 UTC]  CloudWatch: rds-cpu-high — 97.3% CPU, 5 consecutive periods
[08:52 UTC]  FinOps:     cost spike — $52.34 today (4x normal), EC2 primary driver
```

> **Callout: What individual agents find vs. what the coordinator's job is**
>
> Each specialist agent investigates its own domain:
> - Track A finds: 5 slow queries on RDS. Cannot identify which service is generating them.
> - Track B finds: EC2 cost spike starting 2026-04-02. Correlates to analytics workload but
>   cannot confirm causation.
> - Track C finds: api-deployment CrashLoopBackOff + memory-hog pod with no memory limit.
>   Cannot confirm whether memory-hog is connected to the database load or cost spike.
>
> The fleet coordinator's job is NOT to add a fourth set of domain findings. Its job is to find
> the **common thread** across all three sets of findings — the single change that explains why
> all three alerts fired within 5 minutes of each other.

Consider: if you ran each agent separately and got three reports, what would you need to do
manually to find the root cause? That manual synthesis step is what Morgan does.

---

## Step 4: Understand the Coordinator's Delegation Rules (5 min)

Read Morgan's SOUL.md:

```bash
cat ~/.hermes/profiles/fleet/SOUL.md
```

Two rules are critical. Find them and understand why they exist:

**Anti-loop rule:**

```
NEVER spawn more than one delegation per domain per incident — avoid delegation loops
```

**Sequencing rule:**

```
Wait for specialist response before delegating the next task
```

> **Why these rules exist**
>
> Without the anti-loop rule, a coordinator receiving an incomplete response from a specialist
> might delegate to that specialist again — and again — creating an infinite delegation loop.
> The rule enforces a hard cap: one delegation per domain per incident.
>
> Without the sequencing rule, the coordinator might send all three delegations simultaneously
> before receiving any findings. If a specialist returns an error, the coordinator cannot adjust
> subsequent delegations based on that information. Sequential dispatch is the safe default.
>
> **What this means for the lab run:** You will see Morgan delegate to track-a first, wait for
> a response, then delegate to track-b, wait, then delegate to track-c, wait — then synthesize.
> This is sequential, not parallel, even though the scenario says "parallel investigation."
>
> Morgan's `config.yaml` sets `MAX_CONCURRENT_CHILDREN=3` — the architecture supports parallel
> dispatch. Sequential is the behavioral default from SOUL.md. The free explore challenges you
> to test what changes when you modify this behavior.

---

## Step 5: Run the Fleet Scenario (20 min)

Your environment variables are already set from Step 1. Launch the fleet coordinator:

```bash
hermes -p fleet chat
```

Verify Morgan introduces itself and confirms the model and mock mode. Then paste this full
incident prompt verbatim:

```
Three alerts fired at 08:47 UTC:
[08:47] PagerDuty: api-deployment CrashLoopBackOff (OOMKilled, 8 restarts)
[08:51] CloudWatch: rds-cpu-high — 97.3% CPU, 5 consecutive periods
[08:52] FinOps: cost spike — $52.34 today (4x normal), EC2 primary driver
Investigate and identify root cause.
```

Watch the coordinator behavior as it runs:

**Expected sequence:**

1. Morgan triages: identifies all three domains are involved
2. Morgan delegates to track-a (database): asks for RDS slow query investigation
3. Track-a responds with findings (5 slow queries, analytics-pattern query structure)
4. Morgan delegates to track-b (FinOps): asks for cost anomaly analysis with 2026-04-02 focus
5. Track-b responds with findings (EC2 launch on 2026-04-02, data transfer spike)
6. Morgan delegates to track-c (Kubernetes): asks for pod health and resource investigation
7. Track-c responds with findings (api CrashLoopBackOff, memory-hog with no memory limit)
8. Morgan synthesizes: identifies memory-hog deployed 2026-04-02 as the common root cause

> **Model note:** This lab uses `anthropic/claude-haiku-4` for all four agents. Expected cost
> for the full fleet run: < $0.10 total. If you hit rate limits, wait 60 seconds and retry.
>
> If Morgan delegates to all three simultaneously (not sequentially), check that
> `~/.hermes/profiles/fleet/SOUL.md` contains the sequencing rule. The delegation order
> should be visible in Morgan's response as it proceeds.

**Expected synthesis (root cause statement):**

Morgan should identify that:
- All three anomalies trace back to 2026-04-02 — the date of the `memory-hog` deployment
- The `memory-hog` analytics service has a memory leak causing cascading failures across all 3 domains
- A single corrective action (fix or rollback `memory-hog`) addresses all three alerts

> **If Morgan produces three separate recommendations (one per domain) without naming a unified root
> cause:** Prompt it:
>
> ```
> What is the single earliest change that could explain all three findings simultaneously?
> ```
>
> The fleet coordinator's value is the synthesis step. If it cannot cross-correlate the 2026-04-02
> date across all three domain findings, it has not completed its job.

---

## Step 6: Evaluate the Synthesis (10 min)

Answer these three evaluation questions in your lab notes:

**Question 1:** Did the coordinator identify 2026-04-02 as the common date across all three
specialist findings?

- Track A finding: analytics-pattern queries started accumulating around 2026-04-02
- Track B finding: EC2 m5.4xlarge launched manually on 2026-04-02
- Track C finding: memory-hog deployed (check pod age / deployment timestamp)

**Question 2:** Did the synthesis name `memory-hog` (the analytics service) as the single root
cause — not "three separate incidents"?

**Question 3:** Did Morgan recommend a single unified action (fix or rollback `memory-hog`) rather
than three separate remediation steps (one per domain)?

> **This is what fleet synthesis gives you that individual agents cannot: the common thread across
> simultaneous alerts.**
>
> If you ran each agent separately, you would get three domain reports:
> - Track A: "5 slow queries — recommend index review"
> - Track B: "Cost spike — EC2 launched 2026-04-02 not terminated"
> - Track C: "api CrashLoopBackOff — memory-hog has no memory limit"
>
> Each report is accurate. None of them names the root cause. A human incident commander
> reading all three would eventually see the 2026-04-02 pattern — but at 3 AM, under alert
> fatigue, that correlation is easy to miss.
>
> The fleet coordinator turns three domain reports into one causal chain. That is the "wow moment"
> of this module.
>
> **The 5-minute alert correlation window:** Three independent simultaneous incidents within
> 5 minutes of each other is statistically improbable. The coordinator should detect this
> temporal clustering and prioritize finding the common cause over treating each alert as
> independent. This is the key heuristic that distinguishes fleet synthesis from single-domain
> escalation.

---

## Step 7: Inspect the Delegation Trace (5 min)

Review Morgan's full response. Find these structural elements:

1. **Triage statement** — did Morgan identify all three domains before delegating?
2. **Delegation sequence** — can you see the order: track-a → track-b → track-c?
3. **Specialist findings embedded in synthesis** — does the final summary cite specific findings
   from each specialist (e.g., "track-a found 5 slow queries matching analytics batch pattern")?
4. **Cross-domain correlation** — where does Morgan state the 2026-04-02 connection across domains?
5. **Unified recommendation** — single action vs. three separate actions?

> **Note on sequential vs. parallel delegation**
>
> Morgan delegates sequentially per SOUL.md behavioral rules, even though the scenario describes
> "parallel investigation." This is intentional: sequential dispatch is the safe default because
> earlier findings can inform later delegations.
>
> The architectural capability (MAX_CONCURRENT_CHILDREN=3 in `config.yaml`) supports parallel
> dispatch — but SOUL.md rules override architecture defaults. The free explore challenges you
> to test what changes when you modify the sequencing rule directly.
>
> In the live workshop scenario, with three human-operated agents, delegation happens in parallel
> naturally — each person responds independently. The behavioral distinction between sequential
> and parallel is more visible in the solo path.

---

## Step 8: Workshop Team Variant (5 min — callout for live workshop teams)

> **This step is for live workshop teams only.** Solo Udemy learners have already completed the
> full lab in Steps 1–7. Your solo run IS the complete experience.

For live workshop teams where each of the 3 participants has already built their own Module 10 agent:

**Team setup:**

- Person 1 (Track A): Already has `track-a` installed from Module 10. Runs `hermes -p track-a chat`.
- Person 2 (Track B): Already has `track-b` installed from Module 10. Runs `hermes -p track-b chat`.
- Person 3 (Track C): Already has `track-c` installed from Module 10. Runs `hermes -p track-c chat`.
- Any one person installs Morgan (Step 2 above) and runs `hermes -p fleet chat`.

The team coordinator (whoever installed Morgan) pastes the incident prompt from Step 5. Morgan
routes to each person's installed track agent. Each person sees their agent get invoked by the
coordinator and responds with their domain findings. Morgan synthesizes across all three.

> The team variant is organic — it works because Hermes delegation routes to locally installed
> profiles by profile name. As long as `track-a`, `track-b`, and `track-c` profiles are installed
> (on the coordinator's machine or accessible remotely), Morgan will find them.
>
> The evaluation questions from Step 6 apply equally to the team run: did Morgan identify
> `2026-04-02` as the common date, name `memory-hog` as root cause, and recommend a single action?

---

## FREE EXPLORE PHASE — 45 minutes

---

## Challenge 1 — Starter (15 min): Modify the Incident Prompt

Remove one of the three alerts from the incident prompt and re-run the fleet scenario.

Try the 2-alert variant (remove the FinOps alert):

```
Two alerts fired at 08:47 UTC:
[08:47] PagerDuty: api-deployment CrashLoopBackOff (OOMKilled, 8 restarts)
[08:51] CloudWatch: rds-cpu-high — 97.3% CPU, 5 consecutive periods
Investigate and identify root cause.
```

Observe:

- Does Morgan still delegate to track-b (FinOps), or does it skip it?
- Does the synthesis still identify `memory-hog` and `2026-04-02` as the root cause — now with
  only 2 domain corroborations instead of 3?
- What changes in the synthesis confidence when only 2 domains are affected?

> **Reflection:** The root cause is the same regardless of which alerts fire. The fleet
> coordinator's synthesis quality depends on the information it receives. With 2 findings instead
> of 3, the coordinator has less corroborating evidence — does it flag this uncertainty?

---

## Challenge 2 — Intermediate (20 min): Modify Coordinator SOUL.md Delegation Behavior

Edit Morgan's SOUL.md to change the sequencing rule:

```bash
# Open the file in your editor
nano ~/.hermes/profiles/fleet/SOUL.md
```

Find this line:

```
Wait for specialist response before delegating the next task
```

Change it to:

```
Delegate to all specialists simultaneously with parallel context — do not wait between delegations
```

Save the file, start a new chat session, and re-run the fleet scenario with the original 3-alert prompt.

Observe:

- Does Morgan now delegate to all three specialists before receiving any responses?
- Does the synthesis quality change (better, worse, or same)?
- Does Morgan still correctly identify `memory-hog` and `2026-04-02` as the root cause?

> **Tradeoffs: Sequential vs. parallel delegation**
>
> Sequential (SOUL.md default):
> - Slower to complete (each delegation waits for previous response)
> - Later delegations can be informed by earlier findings (e.g., "track-a found analytics queries —
>   ask track-b to focus on EC2 launched 2026-04-02")
> - Safer: no delegation loop risk from simultaneous responses
>
> Parallel (your modified behavior):
> - Faster to complete (all specialists run simultaneously)
> - Earlier delegations cannot be informed by findings from parallel specialists
> - Requires the coordinator to synthesize without context from previous delegations
>
> Neither is universally better. Sequential is the safe default. Parallel is correct when
> domain investigations are truly independent and speed matters more than adaptive context.

Restore the original SOUL.md when done to avoid confusion in later labs:

```bash
cp course/agents/fleet-coordinator/SOUL.md ~/.hermes/profiles/fleet/SOUL.md
```

---

## Challenge 3 — Advanced (30 min): Create a 2-Domain Incident

Write a new incident prompt that only triggers Track A and Track C (no cost component). Then
observe whether the fleet coordinator correctly identifies the scope and skips Track B.

Suggested 2-domain prompt:

```
Two alerts fired at 08:47 UTC:
[08:47] PagerDuty: api-deployment CrashLoopBackOff (OOMKilled, 8 restarts) — service down
[08:51] CloudWatch: rds-cpu-high — 97.3% CPU, 5 consecutive periods — slow queries
Investigate. No cost anomalies have been reported.
```

Observe:

1. **Does Morgan delegate to track-b (FinOps)?** It should NOT — no cost signal in the prompt.
   If it does, examine Morgan's triage logic: is it defaulting to "all three" regardless of scope?

2. **Does the synthesis still identify memory-hog without the cost correlation?**
   With only 2 domain findings, the coordinator has:
   - Track A: analytics-pattern queries (but no cost data to confirm who launched EC2)
   - Track C: memory-hog pod with no memory limit
   The `memory-hog` identification should still work via Track C alone — the pod is named
   and its missing memory limit is the direct cause of Track A's query accumulation.

3. **Is the synthesis weaker without Track B?**
   The cost finding provides independent corroboration (EC2 launched 2026-04-02 to support
   analytics job). Without it, the coordinator has less evidence. Does it flag this?

> **Extension:** Add your own fourth alert type to the prompt — for example, a Slack notification
> about a deployment. Does Morgan attempt to delegate to a non-existent track-d specialist?
> What does it do when the delegated profile is not found?

---

## Closing

**What you demonstrated:**

- Individual specialist agents (Track A, B, C) each find accurate domain findings but cannot
  identify the cross-domain root cause
- The fleet coordinator (Morgan) delegates sequentially to each specialist, waits for findings,
  then synthesizes across all three domains
- The synthesis identifies the single root cause (`memory-hog` analytics service, deployed
  2026-04-02) that explains all three simultaneous alerts — something no single-domain agent
  can do alone
- The 5-minute alert correlation window is the key heuristic: three independent incidents within
  5 minutes is improbable; a common cause is far more likely
- Morgan's SOUL.md delegation rules (anti-loop, sequencing) are behavioral guardrails that prevent
  coordinator failure modes invisible at the architecture level

**What this pattern is:**

This is the hierarchical multi-agent pattern. Morgan is not the smartest agent — the specialists
have all the domain knowledge. Morgan's value is the synthesis step: combining outputs from
multiple specialists into a unified causal explanation. This is what humans do in incident war
rooms, and it is the hardest part to automate well.

**Next:** Module 12 adds triggers to this pattern — scheduled cron checks, webhook subscriptions
from PagerDuty, and Slack slash commands that invoke the fleet coordinator without a human
typing the incident prompt.

---

## Verification Checklist

Run these commands to confirm your lab completed successfully:

```bash
# 1. Fleet coordinator profile is installed
ls ~/.hermes/profiles/fleet/
# Expected: SOUL.md  config.yaml   (no skills/ directory)

# 2. All track agents are installed
hermes profiles list
# Expected output includes: fleet, track-a, track-b, track-c

# 3. Fleet coordinator has no skills directory
ls ~/.hermes/profiles/fleet/skills/ 2>&1
# Expected: No such file or directory

# 4. SOUL.md contains the delegation anti-loop rule
grep "NEVER spawn" ~/.hermes/profiles/fleet/SOUL.md
# Expected: NEVER spawn more than one delegation per domain per incident — avoid delegation loops

# 5. Incident prompt contains the cross-domain scenario markers
grep "CrashLoopBackOff\|08:47\|rds-cpu-high" course/infrastructure/scenarios/cross-domain.md | head -3
# Expected: lines matching each alert from the scenario file

# 6. Mock data files exist for all three tracks
ls infrastructure/mock-data/rds/ infrastructure/mock-data/cost-explorer/ infrastructure/mock-data/kubernetes/
# Expected: JSON files in each directory

# 7. Individual track agents respond in mock mode (from Step 1 verification)
# Re-run Step 1 verification if needed
```

---

## Appendix: Scenario Reference

**Root cause (for your debrief notes):**

The `memory-hog` analytics service was deployed on 2026-04-02 with a memory leak. It allocates
memory for each order batch it processes but does not release between batches. This single
service caused:

1. **Track C (direct):** Pod consuming 410Mi on node with no memory limit set. Linux OOM killer
   targets `api-deployment` (256Mi limit, lowest priority on node). Result: CrashLoopBackOff.

2. **Track A (secondary):** Analytics service makes excessive queries against OLTP production
   instance — 3+ slow queries per batch, accumulating because memory leak prevents clean batch
   termination. Result: 5 simultaneous slow queries, RDS CPU at 97%.

3. **Track B (tertiary):** Analytics team manually launched m5.4xlarge EC2 on 2026-04-02 to
   run analytics job at scale. Instance not terminated. Cross-AZ data transfer from RDS queries
   also elevated. Result: 4x daily cost spike.

**Deployment timeline:**

```
2026-04-02 06:00 UTC  memory-hog deployed to production
2026-04-02 06:18 UTC  m5.4xlarge EC2 launched manually (analytics team)
2026-04-02 08:30 UTC  RDS CPU starts climbing (analytics queries accumulating)
2026-04-04 08:47 UTC  api-deployment enters CrashLoopBackOff (node memory pressure peaks)
2026-04-04 08:51 UTC  RDS CPU alarm fires (elevated for 2 days)
2026-04-04 08:52 UTC  FinOps alert fires (day-7 cost still elevated)
```

**The correct fleet synthesis statement:**

> "The `memory-hog` analytics service deployed 2026-04-02 has a memory leak. This single service
> is causing: (1) `api-deployment` OOM kills due to node memory pressure (Track C), (2) excessive
> database queries causing RDS CPU spike (Track A), and (3) cost spike from manual EC2 scale-up
> to support the analytics workload (Track B). Recommended action: rollback or disable `memory-hog`
> pending memory leak fix. This single action will resolve all three alerts."
