# Module 04 — Exploratory Projects

> These are optional stretch exercises for participants who finish the lab early
> or want to go deeper. Each is self-contained and can be done independently.

---

## Project 1: Build a Custom .mcp.json for Your Team (~45 min)

**Goal:** Design and document a production-ready MCP configuration that your team could use to connect an agent to your actual infrastructure tools.

**Why this matters:**

The `.mcp.json` file is your team's contract with the agent. It says: "Here are the tools you're allowed to use, here's how to authenticate, here's where the servers live, and here are the constraints." A well-designed config scales to multiple agents and tools without reinventing the wheel.

**Instructions:**

1. **Choose your domain** — pick ONE operational area your team owns:
   - Incident response and diagnostics
   - Deployment and canary analysis
   - Cost optimization and rightsizing
   - Capacity planning and forecasting
   - Security posture and compliance checking

2. **Map your tools** — list 4-6 tools your team uses for this domain:
   - Infrastructure query tools (kubectl, Terraform, Ansible, cloud CLI)
   - Data tools (databases, observability — Prometheus, CloudWatch, Datadog)
   - Knowledge tools (Git repos, runbooks, documentation)
   - Operational tools (deployment pipelines, cost explorers)

3. **Design the MCP servers** — for each tool, decide:
   - **Which tools should be MCP servers?** (Not all need MCP—only those the agent will query repeatedly)
   - **What tools should each server expose?** (Don't wrap everything; expose only what the agent needs)
   - **How should authentication work?** (API keys, IAM roles, service accounts, local CLI creds)
   - **What rate limits or guardrails are needed?** (Prevent the agent from running expensive queries or dangerous commands)

4. **Structure your .mcp.json** — create a JSON document with:
   ```json
   {
     "domain": "[Your domain]",
     "purpose": "[Why your team needs this]",
     "servers": [
       {
         "name": "kubernetes",
         "description": "[What queries the agent can run]",
         "command": "node /path/to/server.js",
         "auth": "[How to authenticate]",
         "tools_exposed": ["list_pods", "get_pod_logs", "describe_deployment"],
         "guardrails": "[Any restrictions — e.g., read-only, no prod namespace changes]"
       },
       { "...": "..." }
     ],
     "usage_pattern": "[Example: Agent receives alert → queries Kubernetes for state → checks Git for recent deploys → suggests remediation]",
     "team_constraints": "[Compliance, approval processes, escalation rules]"
   }
   ```

5. **Document the handoff** — write a brief guide (README.md style) that explains:
   - When and how your team would use this agent (what triggers it, what questions it answers)
   - Which team members need to review/approve changes to the MCP config
   - How to onboard a new team member to use the agent
   - How to rotate API keys or credentials without breaking the config

**Deliverable:**

A `.mcp.json` file (or YAML equivalent) with 4-6 servers fully specified, plus a `MCP_DESIGN.md` document covering:
- Domain, purpose, and team constraints
- Diagram or table showing tool → MCP server mapping
- Authentication strategy (how keys are stored/rotated)
- Guardrails and safety considerations
- Example query and cross-platform flow

**Success criteria:**

- Your config is specific to your actual environment (real tool names, real auth methods, real team constraints)
- Another DevOps engineer could read it and set it up without asking you questions
- You've thought about guardrails, not just connectivity

**Hints:**

- Start with tools your team already uses daily. Don't invent new servers for theoretical future use.
- Review the Lab 04 solution `.mcp.json` for structure and patterns.
- Consider: What would your team need at 2am during an incident? Those are the tools that matter.
- Look at `mcp.run` or `smithery.ai` for examples of well-designed MCP servers in the ecosystem.

---

## Project 2: MCP Server Evaluation Matrix (~50 min)

**Goal:** Evaluate 6+ existing MCP servers from the ecosystem, test them in your lab, and rate them on reliability, output quality, and safety. This becomes your team's "MCP server decision guide."

**Why this matters:**

The MCP ecosystem is growing fast. Not all servers are production-ready. Building an evaluation matrix helps you make informed choices about which servers to adopt and which to skip (or replace with custom servers). It's the DevOps version of evaluating monitoring tools—you need standards.

**Instructions:**

1. **Choose 6-8 MCP servers** from the ecosystem. Consider these categories:
   - **Kubernetes/Container:** kubernetes, docker (if available)
   - **Cloud:** aws-cli, gcloud (if available)
   - **Database:** postgresql, mysql (if available)
   - **Version control:** github, gitlab (if available)
   - **Infrastructure:** terraform, ansible (if available)
   - **Observability:** prometheus (if available)
   - Or use `mcp.run` or `smithery.ai` to browse available servers

2. **Set up a test environment:**
   - Use your existing KIND cluster, PostgreSQL, and GitHub repo from Module 04 lab
   - For cloud tools (AWS, GCP), use static mock data or free-tier sandbox accounts
   - Document which servers you tested and where (local vs. cloud)

3. **Build a test plan** — for each server, test:
   - **Installation:** Easy to install? Dependencies clear? Docs helpful?
   - **Authentication:** Simple or complex? Secure? Easy to rotate credentials?
   - **Tool discovery:** Can you figure out what tools are available without reading source code?
   - **Output quality:** Are results well-formatted? Do they include useful metadata?
   - **Reliability:** Does it work 100% of the time or do you hit errors/edge cases?
   - **Performance:** How fast are queries? Does it handle large result sets?
   - **Safety:** Does it have guardrails (input validation, rate limiting, command restrictions)?

4. **Create a comparison table:**
   ```markdown
   | Server | Category | Install | Auth | Discovery | Output | Reliability | Speed | Safety | Notes |
   |--------|----------|---------|------|-----------|--------|-------------|-------|--------|-------|
   | kubernetes | Kubernetes | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Solid, production-ready |
   | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |
   ```

5. **Run one deep-dive test** — pick your top 2-3 servers and:
   - Run a realistic multi-step query (similar to the cross-platform query in Lab 04)
   - Document the exact commands, outputs, and response times
   - Note any gotchas or surprises
   - Assess whether you'd use it in production

6. **Draft a decision guide:**
   - For each server, write a 1-sentence recommendation (e.g., "Use for Kubernetes queries. Mature, fast, safe.")
   - Identify gaps (e.g., "No good Docker server yet; consider wrapping docker CLI manually")
   - Suggest a priority order for adoption (which should your team integrate first?)

**Deliverable:**

An `MCP_SERVER_EVALUATION.md` document containing:
- Evaluation criteria and methodology
- Comparison table (6+ servers, 9+ attributes, 1-5 star ratings)
- Deep-dive test results for top 2-3 servers (commands, outputs, timing)
- Decision guide and adoption priority recommendations
- Known gaps and custom server ideas

**Success criteria:**

- You've actually tested servers, not just read docs
- Ratings are justified with evidence (not opinion)
- Your guide could inform your team's real MCP adoption decisions
- You've identified at least one gap where a custom server would be valuable

**Hints:**

- Start with the most commonly-used servers (Kubernetes, GitHub). Get those working first.
- Use `mcp.run` as a registry to discover servers and their ratings/feedback.
- Check `smithery.ai` for MCP servers built by the community and Anthropic.
- Document versions tested (MCP servers change; your evaluation is only current as of today).
- Test both "happy path" (normal queries) and "error path" (malformed inputs, edge cases).
- Consider security: Does a server allow command injection? Does it validate inputs? Rate accordingly.

---

## Project 3: Cross-Platform Incident Investigation (~40 min)

**Goal:** Simulate a production incident and investigate it using ONLY MCP queries—no manual CLI work. This forces you to think about what your agent needs to see and discover potential gaps in your MCP setup.

**Why this matters:**

A good agent should be able to investigate incidents end-to-end without you jumping between tools. This project surfaces whether your MCP servers expose the right tools, in the right order, to solve real problems.

**Instructions:**

1. **Pick a realistic incident scenario** from your team's history or from this list:
   - **High memory pod:** A critical pod is using 85% of node memory. What changed in code? What's the baseline? Can we safely restart it?
   - **Database connection spike:** Application connections to the database spiked 3x. Are there connection leaks? Did a deployment change the pool size? What's the app's error log saying?
   - **Deployment rollback needed:** Recent deploy broke the API (5xx errors spike). Did it really break, or is there a transient issue? What was the previous working version? What config changed?
   - **Cost spike:** Your AWS bill jumped 40% this month. Which service is responsible? Did a new workload appear? Is something running longer than it should?
   - **Slow query:** Application latency increased 10x. Are slow queries blocking? Did indexes get dropped? What changed in the code or DB config?

2. **Set up your investigation context:**
   - Use your existing lab environment (KIND cluster, PostgreSQL, GitHub repo)
   - Create simulated data for the incident (e.g., a high-memory pod, a recent commit, an alert)
   - Document the "ground truth"—you know what the problem actually is (for later verification)

3. **Disable manual CLI access** — for this exercise, pretend you can ONLY ask questions via MCP. No `kubectl`, no `psql`, no `git` commands directly. Everything goes through the agent.

4. **Run your investigation as a structured MCP conversation:**
   - Step 1: Ask the agent what it sees (Kubernetes state, metrics)
   - Step 2: Ask it to correlate with recent changes (GitHub commits, deployments)
   - Step 3: Ask it to check baselines and runbooks (are we in trouble?)
   - Step 4: Ask it to recommend or execute remediation

5. **Document the investigation flow:**
   ```markdown
   ## Incident: [Title]

   **Initial Signal:** [Alert or symptom]

   ### Query 1: What does Kubernetes show?
   - Agent calls: `list_pods`, `describe_pod`, `get_pod_metrics`
   - Results: [Actual output or mock data]
   - Agent observation: [What did it learn?]

   ### Query 2: What changed in code?
   - Agent calls: `get_recent_commits`, `list_deployments`
   - Results: [Actual output or mock data]
   - Agent correlation: [Connection between code change and incident]

   ### Query 3: What's the baseline?
   - Agent calls: `get_metric_history`, `read_runbook`
   - Results: [Actual output or mock data]
   - Agent assessment: [Is this normal? What should we do?]

   ### Remediation
   - Recommended action: [What the agent suggests]
   - Safety check: [Did the agent verify it's safe? Did it ask for approval?]
   - Outcome: [Would this have resolved the incident?]
   ```

6. **Identify gaps:**
   - Did the agent get stuck waiting for a tool it didn't have?
   - Were any MCP servers missing critical tools?
   - Did output from one server lack context needed for the next query?
   - Would you add/remove/modify any MCP servers based on this investigation?

**Deliverable:**

An `INCIDENT_INVESTIGATION.md` document containing:
- Incident scenario (title, initial signal, ground truth)
- Step-by-step investigation flow (4-6 query steps)
- Agent's actual responses (or realistic simulations if using mock data)
- Agent's final diagnosis and remediation recommendation
- Gap analysis: What MCP servers/tools were missing?
- Lessons learned: How would you improve your MCP setup for next time?

**Success criteria:**

- The investigation is realistic—you're solving a real problem, not a toy exercise
- You used at least 3 different MCP servers (Kubernetes, database, git, metrics, etc.)
- You identified at least one gap or improvement for your MCP setup
- The agent's diagnosis was correct (matched the ground truth you set up)
- You documented which MCP tools were crucial and which were nice-to-have

**Hints:**

- Use your real lab environment (reference app on KIND, PostgreSQL, GitHub repo with actual commits)
- If you don't have realistic metrics/data, create mock JSON files that simulate alerts or metric spikes
- Focus on correlation: The magic moment is when the agent connects a code change to an infrastructure problem
- Time yourself: How many minutes did the MCP investigation take vs. manual CLI investigation?
- Consider: Could a new team member do this investigation if they only had access to the MCP agent?

---

## Project 4: Design Your Ideal MCP Server (~35 min)

**Goal:** Design (but don't build) an MCP server for a tool your team uses that doesn't have an official MCP server yet. This exercise teaches you to think like a server builder and understand what makes a good MCP abstraction.

**Why this matters:**

Not all tools will have MCP servers. Eventually, you'll need to wrap or build one. This project teaches you what makes a good server design: what tools to expose, what inputs to accept, what safety guardrails to include. It's the architectural thinking behind MCP.

**Instructions:**

1. **Choose a tool your team uses that lacks an MCP server:**
   - A custom internal tool or CLI
   - A SaaS platform (e.g., PagerDuty, LaunchDarkly, Datadog, New Relic)
   - An obscure tool that's critical for your workflow (e.g., a custom deployment tool, cost attribution system, configuration management system)
   - A tool you've been meaning to integrate but haven't

2. **Document the tool's current workflow:**
   - How does your team currently use this tool? (Manual CLI? Web UI? Scripts?)
   - What are the top 3-5 operations your team does with it daily?
   - What data does it output? (JSON? CSV? Plain text? Complex nested structures?)
   - How would you like an agent to interact with it?

3. **Design the MCP server's contract:**

   ```markdown
   # MCP Server Design: [Tool Name]

   ## Overview
   - Tool: [Name and purpose]
   - Current workflow: [How team uses it today]
   - MCP goal: [What the agent should be able to do with it]

   ## Tools (Callable Operations)

   ### Tool 1: [operation_name]
   - Description: [What it does in plain language]
   - Inputs: [JSON schema with required/optional fields]
   - Outputs: [Sample JSON response]
   - Safety: [Input validation, rate limits, restrictions]

   ### Tool 2: [operation_name]
   - Description: [...]
   - Inputs: [...]
   - Outputs: [...]
   - Safety: [...]

   ## Resources (Readable Data)

   ### Resource 1: [name]
   - Description: [What it contains]
   - Format: [JSON, YAML, Markdown, CSV]
   - Sample: [First 20 lines]

   ## Prompts (Agent Guidance)

   ### Prompt 1: [situation]
   - Trigger: [When the agent should use this prompt]
   - Guidance: [How to use the tools in this server]

   ## Safety & Guardrails
   - Authentication: [How to prove identity]
   - Authorization: [Who can call what]
   - Rate limits: [Prevent abuse]
   - Input validation: [What's allowed]
   - Audit logging: [What gets logged]

   ## Example Queries
   - "What's the status of [resource]?"
   - "Has [metric] changed since [date]?"
   - "Update [config] to [value]."
   ```

4. **Design the Tools section** — for each tool, specify:
   - **Name:** Clear, verb-based (e.g., `get_status`, `list_deployments`, `trigger_workflow`)
   - **Description:** What the tool does, in one sentence
   - **Input schema:** JSON schema with all parameters, descriptions, required vs. optional
   - **Output format:** Sample JSON showing what the agent gets back
   - **Safety:** How to prevent misuse (e.g., "Only allow read operations, no writes")

5. **Design the Resources section** — identify static data the agent should read:
   - Documentation or runbooks
   - Configuration files
   - API references
   - Recent activity logs

6. **Design the Prompts section** — write 2-3 guiding prompts:
   - Tell the agent when/how to use this server
   - Suggest safe patterns (e.g., "Always check prerequisites before triggering a deploy")
   - Warn about gotchas (e.g., "This tool has a 10-second timeout; use sparingly")

7. **Consider implementation** — briefly sketch how you'd build this server:
   - What command-line tool or API would it wrap? (e.g., `curl`, a Python SDK, a CLI binary)
   - How would it authenticate?
   - How would it parse output into clean JSON?
   - What error handling is needed?

**Deliverable:**

A `MCP_SERVER_DESIGN.md` document containing:
- Tool overview and current workflow
- 4-6 designed Tools with full schemas and safety rules
- 2-3 Resources with descriptions and samples
- 2-3 guiding Prompts with triggers and advice
- Safety & guardrails strategy
- 2-3 example queries showing the server in action
- (Optional) Brief implementation sketch: "I'd wrap [CLI/API] and parse [output format]"

**Success criteria:**

- Your design is specific to a real tool, not hypothetical
- You've thought about safety (input validation, rate limits, guardrails)
- Another engineer could implement your design without asking questions
- Your Tools and Resources cover the actual workflows your team uses daily
- You've identified at least one safety risk and how you'd mitigate it

**Hints:**

- Don't try to expose every feature of the tool. Focus on the 5-10 operations the agent will actually use.
- Think about inputs carefully: What parameters does the agent need to pass? Make them explicit.
- Think about outputs carefully: Can the agent parse what it gets back? Is it actionable?
- Consider user experience: Would an agent understand this tool without reading source code? That's your gold standard.
- Look at existing MCP servers (on `mcp.run` or `smithery.ai`) for design patterns and inspiration.
- Remember: A good MCP server is a good API. It documents itself and handles errors gracefully.

---
