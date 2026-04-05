# Module 01 — Exploratory Projects

> Optional stretch projects for participants who finish the lab early or want to go deeper.
> These are self-directed — no step-by-step guide, just a goal and hints.

---

## Project 1: Add a Filesystem MCP Server

**Goal:** Connect a filesystem MCP server so your AI agent can read and write files in the course directory.

**Why:** Several later modules benefit from the agent being able to read lab files, SKILL.md files, and configuration directly. Setting this up now saves time later.

**Hints:**

- The MCP server package is `@modelcontextprotocol/server-filesystem`
- Add it to your `.mcp.json` (Claude Code) or Crush MCP config
- Constrain it to the course directory only (security best practice)
- Test by asking your agent: "Read the README.md in the module-01-welcome directory and summarize it"

**Success criteria:** Your agent can read any file in the course repo by path.

---

## Project 2: Deploy with Docker Compose Instead of KIND

**Goal:** Deploy the reference application using Docker Compose instead of KIND, and compare the experience.

**Why:** Understanding both deployment paths helps you appreciate what Kubernetes adds (and what it costs in complexity). Some participants may also prefer the Compose path for simpler local development.

**Hints:**

- The Makefile has Compose targets: `make compose-up`, `make compose-down`, `make compose-logs`
- Compose exposes different ports (dashboard at :3000, API at :8080)
- The MCP postgres connection string stays the same (port 5432)
- The kubectl MCP server won't work with Compose — you'll need to skip kubernetes MCP

**Success criteria:** Reference app running via Compose. Dashboard accessible. Postgres MCP connected.

**Reflection question:** What do you gain with KIND that Compose doesn't give you? When would you choose each?

---

## Project 3: Explore Your Agent's Boundaries

**Goal:** Discover what your AI coding agent can and can't do with the current MCP setup by asking it progressively harder questions.

**Why:** Understanding the boundaries of your tools is the first step to extending them. This exercise builds intuition for what MCP enables and where you'll need custom tools later.

**Try these prompts (in order of difficulty):**

1. "List all pods in the app namespace and their resource usage"
2. "Show me the Helm values used to deploy the reference app"
3. "What Prometheus alerting rules are configured in the monitoring namespace?"
4. "Compare the current database schema with what the catalog service expects"
5. "Find any pods that restarted in the last hour and correlate with recent deployments"

**Document:**

- Which prompts succeeded? Which failed?
- Where did the agent use MCP tools vs. general knowledge?
- What additional MCP servers or tools would help with the failed prompts?

**Success criteria:** A written list of 3-5 things your agent can't currently do that you'd want it to do. (You'll build some of these capabilities in later modules.)

---

## Project 4: Set Up a Second Provider (Multi-Provider Testing)

**Goal:** If you're using Claude Code, also set up Crush with a free provider (or vice versa). Run the same smoke test prompts on both and compare.

**Why:** Different models have different strengths. Understanding how the same context produces different results across models is a practical context engineering lesson.

**Steps:**

1. Install the second tool (see SETUP.md Step 4)
2. Configure the same MCP servers
3. Run the three smoke test prompts from the lab
4. Note differences in response quality, speed, and tool usage

**Compare:**

- Did both agents successfully use MCP tools?
- Were the responses equally accurate?
- Which agent provided more actionable information?
- How did response time compare?

**Success criteria:** Both tools running with MCP connected. A written comparison of results.

---

## Project 5: Pre-Read on Context Engineering

**Goal:** Read ahead and start thinking about context engineering before Module 02.

**Why:** Context engineering is THE core skill of this course. Getting a head start gives you more time to practice in the labs.

**Exercise:**

Take the CloudWatch alarm JSON from `infrastructure/mock-data/cloudwatch/describe-alarms-anomaly.json` and send it to your AI agent four different ways:

1. **Bare:** Just paste the JSON with "What's this?"
2. **Named:** "This is a CloudWatch alarm from our production RDS instance. Analyze it."
3. **Contextual:** "This is a CloudWatch alarm for our RDS PostgreSQL db.r5.large instance (Multi-AZ, us-east-1). Our SLO is p99 latency under 200ms. A deploy went out 2 hours ago. Analyze this alarm."
4. **Expert:** Same as #3, but add: "Check for connection pool exhaustion, query plan regression, and lock contention. Recommend whether to rollback the recent deploy."

**Compare the four responses.** Notice how the quality improves with each level of context — same data, same model, dramatically different results. This is the foundation of Module 02's lab.

**Success criteria:** Four responses saved. A reflection on how context quality affected output quality.
