# Module 04 Quiz — Cross-Platform Intelligence with MCP

**Estimated time:** 10 minutes
**Format:** 8 questions, multiple choice
**Passing score:** 75% (6/8 correct)

---

### Question 1

**MCP is often described using the USB-C analogy. What problem does this analogy solve?**

A) How to charge multiple laptops at the same time using one power outlet

B) The complexity of integrating many AI agents with many infrastructure tools (N×M → N+M integrations)

C) How to prevent data loss when moving files between cloud providers

D) How to standardize Kubernetes manifests across different clusters

<details>
<summary>Answer</summary>

**B) The complexity of integrating many AI agents with many infrastructure tools (N×M → N+M integrations)**

Without MCP, each of 3 agents needs custom code for each of 8 tools: 3 × 8 = 24 integrations. With MCP, each tool builds one server, each agent supports the protocol: 3 + 8 = 11 integrations. MCP decouples agents from tools, just as USB-C decouples devices from proprietary charging cables. This is the core economics of why MCP matters for infrastructure automation.

</details>

---

### Question 2

**An MCP server has three internal components: Tools, Resources, and Prompts. Which statement best describes Tools?**

A) Tools are pre-written instructions that guide the agent toward recommended actions (e.g., "always check logs before restarting")

B) Tools are functions the agent can call with inputs and outputs; they translate MCP calls into CLI commands (e.g., "query_kubernetes_pods")

C) Tools are static files like Terraform state or documentation that the agent can read but not execute

D) Tools are the actual infrastructure (kubectl, psql, git) that the agent must learn to invoke directly

<details>
<summary>Answer</summary>

**B) Tools are functions the agent can call with inputs and outputs; they translate MCP calls into CLI commands (e.g., "query_kubernetes_pods")**

Tools are the executable interface. When an agent calls `query_kubernetes_pods(namespace="production")`, the MCP server translates this into `kubectl get pods -n production -o json`, executes it, parses the output, and returns clean JSON to the agent. Tools are the middleware that abstract CLI complexity away from the agent.

</details>

---

### Question 3

**According to the three-layer MCP architecture, what is the purpose of the Server layer?**

A) To authenticate the agent with each tool and enforce access control

B) To store copies of infrastructure data in a cache that the agent can query quickly

C) To translate MCP tool calls from the Client into CLI commands and return structured results from the Tool layer

D) To decide which tool the agent should call based on the agent's question

<details>
<summary>Answer</summary>

**C) To translate MCP tool calls from the Client into CLI commands and return structured results from the Tool layer**

The Server layer is the translator. The Client (Claude Code, Crush) sends standardized MCP calls. The Server takes those calls, figures out which CLI command to run, executes it, parses the messy output, and returns clean JSON back to the Client. The actual tool (kubectl, psql) doesn't know MCP exists—it just sees normal CLI invocations.

</details>

---

### Question 4

**You're designing an MCP server for a team-specific tool that tracks deployment history. The agent needs to:**

1. List all deployments from the past 7 days
2. Query details of a specific deployment by ID
3. Access a runbook document that explains your team's deployment safety gates

**Which of these would be Tools vs Resources?**

A) All three should be Tools—the agent needs to be able to call them

B) Items 1 and 2 should be Tools (they're functions); Item 3 should be a Resource (static, readable data)

C) Items 1 and 2 should be Resources; Item 3 should be a Tool (it contains your knowledge)

D) Item 1 should be a Resource; Items 2 and 3 should be Tools

<details>
<summary>Answer</summary>

**B) Items 1 and 2 should be Tools (they're functions); Item 3 should be a Resource (static, readable data)**

Tools are callable functions that take parameters and return dynamic data. Resources are static files or data that the agent can read without invoking a tool. "List deployments" and "query deployment by ID" are dynamic queries (Tools). A runbook document is static knowledge (Resource)—the agent reads it as context, but doesn't "call" it.

</details>

---

### Question 5

**In Module 03, you learned about the Platform AI Gap: detection happens, but investigation, action, and context are missing. How does MCP help close this gap?**

A) MCP replaces CloudWatch and other platform AI services with better detection algorithms

B) MCP connects agents to all your infrastructure tools so they can investigate (query logs, metrics, git, database) and take action (execute runbooks, deployments) using your operational context

C) MCP automatically writes runbooks based on alarm patterns without needing you to do the work

D) MCP removes the need for platform AI entirely—your infrastructure tools are smart enough on their own

<details>
<summary>Answer</summary>

**B) MCP connects agents to all your infrastructure tools so they can investigate (query logs, metrics, git, database) and take action (execute runbooks, deployments) using your operational context**

Platform AI detects the problem (CloudWatch Anomaly Detection, DevOps Guru). MCP lets the agent **investigate** (query Kubernetes, databases, git history), **act** (execute remediation steps, modify infrastructure), and apply **your context** (team-specific runbooks, SLAs, constraints). The agent becomes the investigator and executor that platform AI lacks. This is why custom agents matter.

</details>

---

### Question 6

**You're running a cross-platform incident investigation query using MCP. You ask: "A pod is using 85% memory. What changed in the code in the last 3 days, and what does the runbook say to do?"**

**Which MCP servers would the agent need to call in sequence?**

A) Only the Kubernetes server (to get pod metrics) — everything else is manual

B) Kubernetes server (pod metrics) → GitHub server (recent commits) → Documentation server (runbook)

C) GitHub server first (to blame the code change), then Kubernetes, then the runbook

D) Only the Documentation server (which should contain all the answers pre-written)

<details>
<summary>Answer</summary>

**B) Kubernetes server (pod metrics) → GitHub server (recent commits) → Documentation server (runbook)**

This is cross-platform intelligence. The agent gathers pod state from Kubernetes, correlates it with recent code changes from GitHub, and applies operational knowledge from the runbook server. Each server answers part of the question. Without MCP, you'd be context-switching manually between these three systems. With MCP, the agent does the integration for you—you structure the context (which servers matter), the agent does the correlation.

</details>

---

### Question 7

**Tool discovery is a key feature of MCP. What does "tool discovery" mean in this context?**

A) The agent searches the internet to find third-party tools it can use

B) The agent automatically learns what tools are available to it by reading the MCP server's schema, so it knows what it can call and what parameters each tool accepts

C) The agent discovers which tools are most popular based on how other teams use them

D) The agent interviews your team to understand which tools they prefer

<details>
<summary>Answer</summary>

**B) The agent automatically learns what tools are available to it by reading the MCP server's schema, so it knows what it can call and what parameters each tool accepts**

Tool discovery is automatic. When an MCP server connects, it announces all available tools with their names, descriptions, and input schemas. The agent reads this schema and knows exactly what it can call. This is similar to how OpenAPI specifications let API clients self-discover endpoints. Without tool discovery, the agent wouldn't know what's available, and you'd have to manually explain every tool to it.

</details>

---

### Question 8

**You're choosing between two approaches to help an agent troubleshoot infrastructure issues:**

**Approach A:** The agent can SSH to servers directly and run arbitrary CLI commands (no guardrails)

**Approach B:** The agent can only call MCP-exposed tools that your team has explicitly approved and wrapped (with input validation, rate limiting, and audit logging)

**Which approach is better from a security and auditability perspective, and why?**

A) Approach A is better because it's faster and doesn't add complexity

B) Approach B is better because it implements "defense in depth"—the MCP layer adds validation, the tool definitions restrict what's callable, and approved tools can be logged for compliance

C) Both approaches have equal security if you trust the agent

D) Approach A is better for security because it avoids adding extra layers that could be misconfigured

<details>
<summary>Answer</summary>

**B) Approach B is better because it implements "defense in depth"—the MCP layer adds validation, the tool definitions restrict what's callable, and approved tools can be logged for compliance**

MCP is a security boundary. By forcing the agent to go through MCP servers, you enforce guardrails: each tool can validate inputs, check permissions, rate-limit requests, and log calls for audit trails. In Approach A, the agent has unlimited access and is audit-invisible. This is why MCP is better for production — it's not just convenience, it's controlled, observable infrastructure access.

</details>

---

## Answer Key Summary

| Q | Answer | Topic |
|---|--------|-------|
| 1 | B | USB-C analogy: N×M → N+M |
| 2 | B | What are Tools in MCP |
| 3 | C | Server layer role (translation) |
| 4 | B | Tools vs Resources |
| 5 | B | MCP closes Platform AI Gap |
| 6 | B | Cross-platform queries |
| 7 | B | Tool discovery |
| 8 | B | Security & defense in depth |

## Passing Score

**Minimum:** 6/8 correct (75%)

**Interpretation:**
- **7-8 correct:** Excellent. You understand MCP architecture and how it bridges tools and agents.
- **6 correct:** Pass. You grasp the core concepts. Review any missed questions before moving to the lab.
- **5 or fewer:** Review Module 04 reading materials (concepts.md, reference.md) and re-take the quiz.

---
