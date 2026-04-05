# Module 01 — Quiz

**7 questions.** Test your understanding of the AgenticOps Trinity Framework and key course concepts.

---

### Question 1

**What are the four eras of operations, in order?**

A) Manual → Automated → Scripted → Agentic
B) Manual → Scripted → Automated → Agentic
C) Scripted → Manual → Automated → Agentic
D) Manual → Scripted → Agentic → Automated

<details>
<summary>Answer</summary>

**B) Manual → Scripted → Automated → Agentic**

The progression follows the historical timeline: Manual operations (~2000s), Scripted automation with bash/cron (~2010s), Automated with IaC/CI-CD/GitOps (~2015s), and Agentic with AI agents that reason and use tools (2025+). Each era absorbed the previous one rather than replacing it.
</details>

---

### Question 2

**What makes an "agentic" system fundamentally different from automation?**

A) It runs faster than traditional scripts
B) It uses more expensive cloud infrastructure
C) It reasons about goals, adapts to new situations, and chains tools
D) It replaces all human involvement in operations

<details>
<summary>Answer</summary>

**C) It reasons about goals, adapts to new situations, and chains tools**

The key difference is reasoning. Automation follows predefined steps and breaks on unexpected input. An agentic system looks at the situation, decides what to do, uses available tools, and adapts when things don't go as expected. It doesn't replace automation — it adds a reasoning layer on top of your existing pipelines and scripts.
</details>

---

### Question 3

**Match each pillar of the AgenticOps Trinity Framework to its driving analogy:**

- Pillar 1: Augmented DevOps = ?
- Pillar 2: Agentic Engineering = ?
- Pillar 3: Agentic DevOps = ?

A) Driver, Mechanic, Passenger
B) Mechanic, Driver, Passenger
C) Passenger, Mechanic, Driver
D) Passenger, Driver, Mechanic

<details>
<summary>Answer</summary>

**C) Passenger, Mechanic, Driver**

Pillar 1 (Augmented DevOps) = Passenger — you benefit from AI features others built. Pillar 2 (Agentic Engineering) = Mechanic — you open the hood and understand how it works. Pillar 3 (Agentic DevOps) = Driver — you're in control, building agents that encode your expertise.
</details>

---

### Question 4

**In the context engineering chain "Domain Expertise → Better Vocabulary → Better Context → Better Results," why does a DevOps engineer get better AI output than a generalist?**

A) DevOps engineers use more expensive AI models
B) DevOps engineers have domain vocabulary that translates into precise, structured context
C) AI models are specifically trained on DevOps data
D) DevOps engineers write longer prompts

<details>
<summary>Answer</summary>

**B) DevOps engineers have domain vocabulary that translates into precise, structured context**

When a DevOps engineer says "Create a Deployment with HPA, PDB, resource limits, and liveness/readiness probes," every term maps to a specific Kubernetes resource with specific configuration. A generalist saying "deploy my app" gives the AI nothing to work with. Same model, same cost — the difference is vocabulary from expertise. This is why context engineering matters more than prompt tricks.
</details>

---

### Question 5

**Which of the following is NOT something agents are designed to replace?**

A) Log correlation across multiple services at 3am
B) Architecture decisions for a new microservices system
C) First-pass triage on monitoring alerts
D) Boilerplate IaC generation

<details>
<summary>Answer</summary>

**B) Architecture decisions for a new microservices system**

Agents replace toil — repetitive investigation, log correlation, initial triage, boilerplate generation. They do NOT replace judgment — architecture decisions, production change approval, incident commander decisions, compliance sign-offs. These require human accountability and remain in the human domain.
</details>

---

### Question 6

**What does MCP (Model Context Protocol) enable for an AI coding agent?**

A) It makes the AI model run faster
B) It lets the agent connect to external tools like kubectl, databases, and APIs
C) It replaces the need for Kubernetes
D) It provides a graphical interface for the agent

<details>
<summary>Answer</summary>

**B) It lets the agent connect to external tools like kubectl, databases, and APIs**

MCP is an open standard that acts as a universal plug for AI agents. Without MCP, your agent is a chatbot that can only generate text. With MCP, it can run kubectl commands, query PostgreSQL, read GitHub repos, and reason across multiple data sources in a single response.
</details>

---

### Question 7

**Why does this course use the term "context engineering" instead of "prompt engineering"?**

A) They mean the same thing — it's just branding
B) Context engineering focuses on structuring the right information, not on crafting clever sentences
C) Prompt engineering is too advanced for this course
D) Context engineering only applies to agent systems, not chat interfaces

<details>
<summary>Answer</summary>

**B) Context engineering focuses on structuring the right information, not on crafting clever sentences**

"Prompt engineering" implies the skill is in phrasing — finding magic words. That's a misconception. The real skill is structuring the right context: domain knowledge, system state, constraints, and vocabulary. Context engineering includes writing SKILL.md files, designing tool connections, managing context windows, and using domain-specific terminology. It's a discipline, not a trick.
</details>
