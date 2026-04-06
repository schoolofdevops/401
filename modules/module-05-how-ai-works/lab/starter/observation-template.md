# Module 05 Lab — AI Processing Observation Sheet

**Participant Name:** _________________________________
**Date:** _________________________________
**Agent Used:** (Claude Code / Crush + provider) _________________________________

---

## Exercise 1: TTFT Measurement

**The Question:**
"How would you diagnose a CPU spike on the catalog service?"

### Version A (Minimal Context — ~50 tokens)

**TTFT-A:** _________ seconds

**Notes (what you observed):**
_________________________________________________________________________
_________________________________________________________________________

### Version B (Rich Context — ~500 tokens)

**TTFT-B:** _________ seconds

**Notes (what you observed):**
_________________________________________________________________________
_________________________________________________________________________

### Analysis

**Ratio (TTFT-B / TTFT-A):** _________ x

**Expected range:** 2-10x (longer pause with more context)

**Did your measurement match the hypothesis?** (Yes / No / Partial)

**Observation — What does this tell you?**
_________________________________________________________________________
_________________________________________________________________________

**Why this matters for DevOps agents:**
- TTFT is the "thinking pause" before the first response
- More context (bigger SKILL.md) = longer pause for users
- Design consideration: encode only essential context in SKILL.md files

---

## Exercise 2: Tokenization Patterns

### Test A: Common English Phrase

**Phrase:** _________________________________________________________________________

**Token Count:** _________

**Tokens per character:** _________ (divide token count by character length)

### Test B: DevOps-Heavy Phrase

**Phrase:** _________________________________________________________________________

**Token Count:** _________

**Tokens per character:** _________

### Test C: Infrastructure Specification (Optional)

**Phrase:** _________________________________________________________________________

**Token Count:** _________

**Tokens per character:** _________

### Analysis

**Which phrase used tokens most efficiently?** (A / B / C)

**Observation — Do DevOps terms tokenize differently?**
_________________________________________________________________________
_________________________________________________________________________

**Why this matters for DevOps agents:**
- Specialized vocabulary consumes tokens
- SKILL.md files loaded with "Kubernetes," "PostgreSQL," "Terraform" add overhead
- Design consideration: compress specialist knowledge or use domain-specific shorthand

---

## Exercise 3: Temperature Experiment

### Setup Notes

**Agent Supports Temperature Control?** (Yes / No)

If no, explain why:
_________________________________________________________________________

### Temperature 0.0 (Deterministic / Consistent)

**Question:** "What's the most important thing to monitor on a Kubernetes cluster?"

**Response:**
_________________________________________________________________________
_________________________________________________________________________
_________________________________________________________________________

### Temperature 1.0 (Creative / Varied)

**Response:**
_________________________________________________________________________
_________________________________________________________________________
_________________________________________________________________________

### Analysis

**Key differences between 0.0 and 1.0:**

- Same core idea? (Yes / No)
- Different emphasis? (Yes / No)
- Different examples? (Yes / No)
- Different tone? (Yes / No)

**Observation — Why does temperature matter for operations?**
_________________________________________________________________________
_________________________________________________________________________

**Why this matters for DevOps agents:**
- Low temperature (0.0) = predictable, repeatable runbooks (preferred for SRE)
- High temperature (1.0) = creative brainstorming (useful for design thinking, not for critical ops)
- Design consideration: set temperature low for production agent skills

---

## Exercise 4: Agent Pipeline Observation

### Single-Tool Query (Kubernetes Only)

**Query:**
"List all pods in the app namespace and their current status in the KIND cluster."

**Total Time:** _________ seconds

**Tools Called:** 1 (Kubernetes MCP)

**Notes:**
_________________________________________________________________________

### Multi-Tool Query (Kubernetes + PostgreSQL + GitHub)

**Query:**
"Show me current memory usage (from Kubernetes), recent database queries (from PostgreSQL), and recent commits (from GitHub). Synthesize to assess if the app needs a restart, DB optimization, or rollback."

**Total Time:** _________ seconds

**Tools Called:** 3 (Kubernetes + PostgreSQL + GitHub)

**Notes:**
_________________________________________________________________________

### Analysis

**Slowdown Ratio (Multi-Tool Time / Single-Tool Time):** _________ x

**Expected range:** 2-4x slower

**Where was the extra time spent?** (tool decision / tool call overhead / waiting for responses / synthesis / integration)
_________________________________________________________________________

**Observation — Why are multi-tool queries slower?**
_________________________________________________________________________
_________________________________________________________________________

**Why this matters for DevOps agents:**
- Every MCP tool adds latency
- Agent must decide which tools to use, call them, wait for responses, integrate results
- Design consideration: don't wire ALL tools into one agent. Be selective.

---

## Exercise 5: Synthesis & Insights

### Question 1: Which exercise surprised you most?

(Circle one or add your own)

- TTFT grows significantly with context
- DevOps terms tokenize inefficiently
- Temperature changes answer quality
- Multi-tool queries are noticeably slower
- Other: _________________________________

**Why did this surprise you?**
_________________________________________________________________________
_________________________________________________________________________

### Question 2: If you were designing a SKILL.md file (Module 07), what would you optimize for?

Based on what you learned, which would you prioritize?
- Minimize token count (reduce Prefill time)
- Use deterministic temperature (predictable responses)
- Keep tool calls minimal (avoid pipeline slowdown)
- Include rich context (provide better answers despite slower TTFT)
- Something else: _________________________________

**Justify your choice:**
_________________________________________________________________________
_________________________________________________________________________

### Question 3: Reflect on Module 04's cross-platform queries

You ran multi-tool MCP queries in Module 04. Now that you understand agent pipelines, what bottlenecks could slow them down?

_________________________________________________________________________
_________________________________________________________________________

### Question 4: Explain TTFT to a skeptical colleague

Imagine a colleague says: "If AI is so smart, why does it pause before responding? That's not how a human expert works."

How would you answer them?

_________________________________________________________________________
_________________________________________________________________________

---

## Overall Reflection (1 Paragraph)

**What's the single most important thing you learned about how AI actually works?**

_________________________________________________________________________
_________________________________________________________________________
_________________________________________________________________________
_________________________________________________________________________

---

## Submission Checklist

- [ ] All five exercises completed with measurements
- [ ] Exercise 5 synthesis questions answered
- [ ] Overall reflection written
- [ ] Submitted to instructor / uploaded to course portal

---

## Reference: Key Concepts From Module 05 Explainer

| Concept | Learned? | Will Use In? |
|---------|----------|------------|
| Prefill Phase (reads all input at once) | [ ] | Module 07 (SKILL.md design) |
| Decode Phase (generates output token by token) | [ ] | Module 10 (agent speed optimization) |
| TTFT grows with input size | [ ] | Module 07-08 (context engineering) |
| Tokenization affects token count | [ ] | Module 07 (efficient skill writing) |
| Temperature controls consistency | [ ] | Module 08 (agent configuration) |
| Agent pipelines have multi-tool overhead | [ ] | Module 10-13 (agent design) |

---

## Notes for Instructors (Facilitators)

If delivering live:
- Have students compare their TTFT measurements on a shared board (you may see 0.5-4 second variation due to network / server load)
- Discuss tokenization patterns: Ask "Why might 'Kubernetes' tokenize as 2 tokens, but 'the' as 1?"
- Temperature experiment: If time limited, demonstrate this yourself rather than having each student run it
- Agent pipeline: Use the pre-recorded scenario if most students don't have KIND running

Expected learning outcomes:
- Students understand that context engineering trades off TTFT for quality
- Students understand tokenization inefficiency in specialist domains
- Students understand temperature as a knob for consistency vs. creativity
- Students understand that agent pipelines have real latency costs
