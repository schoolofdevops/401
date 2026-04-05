# Module 03 Exploratory Projects — Platform AI Gap Analysis and Custom Agent Planning

These projects extend the core lab by deepening your understanding of platform AI gaps and sketching the custom agents you'll build in Modules 7-14.

**Prerequisites:** Core lab (Steps 1-6) completed. You have a Platform AI Assessment filled in.

**Why these projects matter:** The gaps you identify in the lab become the features you'll build into custom agents. These projects help you think like an agent architect — not just "what's missing?" but "what would a custom agent look like to fill this gap?"

---

## Project 1: Multi-Cloud Platform AI Comparison

**Goal:** Map platform AI features across cloud providers (AWS, Azure, GCP) to understand vendor lock-in risks and opportunities.

**Why:** Platform AI is not portable. CloudWatch Anomaly Detection is AWS-only. Cost Explorer is AWS-only. If you migrate clouds, your platform AI features migrate with you — or they don't. Understanding this now shapes how you design custom agents that might work across multiple clouds.

**Hints:**

- Start with a simple comparison matrix: service type (anomaly detection, cost intelligence, code assistance, correlation) vs provider. Fill in what each cloud offers.
- Use your cloud provider's official documentation. For example: AWS (CloudWatch docs), Azure (Azure Monitor + Azure AI Services), GCP (Cloud Monitoring + Vertex AI).
- Don't aim for exhaustive detail — focus on the four categories from the module: Anomaly Detection, Cost Intelligence, Cross-Service Correlation, Code Assistance.
- Note: some features exist under different names. Azure Monitor does anomaly detection, but it's not called "Anomaly Detection" like AWS's.

**Success criteria:**

- You have a completed matrix showing at least 3 providers and 4 feature categories
- You've identified at least 2 gaps where one cloud has a feature another doesn't
- You've written 1-2 sentences describing how these gaps would affect a multi-cloud organization (e.g., "If we use AWS and GCP, we lose cross-service correlation capability in GCP")
- **Bonus:** You've sketched how a custom agent could work across clouds despite these gaps (e.g., an agent that ingests metrics from any cloud and applies YOUR correlation logic)

**Deliverable:** Save as `module-03-platform-ai/exploratory/multi-cloud-comparison.md`

---

## Project 2: Build a Platform AI Audit for Your Organization

**Goal:** Inventory all platform AI features your team is currently using (or could be using) and assess adoption.

**Why:** Most organizations are using 10% of the platform AI available to them. This project forces you to check YOUR stack specifically. It turns abstract "what could we do?" into concrete "what are we actually doing right now?"

**Hints:**

- Interview 2-3 teammates (or think through your own team's practices if this is solo) about which platform AI features they currently use.
- Walk through each service you use: AWS (if applicable), your observability stack (Datadog? Datadog? Grafana?), your code editor (VS Code? JetBrains?). For each, list the AI features you're aware of.
- Build a simple audit table: Feature | Available? | Currently Used? | Cost | Blocker (if not used)
- The "Blocker" row is important — maybe Grafana Sift is available but requires Cloud Pro tier. Maybe Q Developer is free but your team doesn't have AWS Builder IDs. These blockers are real.
- Don't just list features — actually check if they're enabled. For example: "CloudWatch has 10 free alarms per account. How many are we using?"

**Success criteria:**

- You have a completed audit table for your primary tools
- You've identified at least 1 platform AI feature your team isn't using but could be (e.g., CloudWatch Anomaly Detection, Grafana Sift, Q Developer)
- You've documented at least 1 blocker preventing adoption
- You've estimated potential time/cost savings if that feature were adopted (e.g., "CloudWatch Anomaly Detection would save 2 hours/week in threshold tuning")
- **Bonus:** You've sketched a 2-week pilot plan to actually enable one feature and measure impact

**Deliverable:** Save as `module-03-platform-ai/exploratory/org-platform-ai-audit.md`

---

## Project 3: Grafana Sift vs Manual Investigation — Decision Tree Comparison

**Goal:** Sketch out how Grafana Sift handles metric investigation, then compare it to how YOUR team manually investigates similar issues.

**Why:** This project makes the "detection vs investigation" gap concrete. Grafana Sift is one of the few platform AI tools that tries to automate investigation. Understanding what it does (and doesn't do) shows you exactly where custom agents need to go deeper.

**Hints:**

- If you have Grafana Cloud Pro+ access (or a free trial), trigger an alert and observe how Sift investigates. If not, use the reference app's mock Grafana setup or watch Grafana's demo videos online.
- For a real incident (or a hypothetical one from your runbooks), sketch a decision tree: "When [alert type] fires, check [these metrics], then [these related services], then [decide on] action."
- Now compare: what does Sift do at each step? What does it miss? What does YOUR runbook include that Sift can't even see?
- Example: Sift can correlate metrics. Can it check your Slack #incidents channel for context? Can it query your deployment API? Can it know that "this exact pattern happened last Tuesday and we fixed it with command X"?

**Success criteria:**

- You've documented a realistic alert scenario (from your runbooks or the lab)
- You've sketched Grafana Sift's investigation approach (what it would check first, what correlations it looks for)
- You've sketched YOUR team's manual investigation approach (decision tree with 5+ steps)
- You've identified at least 3 steps in your decision tree that Sift can't handle (e.g., "check Jira for related tickets", "verify that the deployment was successful", "follow runbook step #3")
- **Bonus:** You've proposed how a custom agent would handle investigation better than Sift by incorporating those missing steps

**Deliverable:** Save as `module-03-platform-ai/exploratory/sift-vs-manual-investigation.md`

---

## Project 4: Design Your First Custom Agent Spec (Based on Gaps Found)

**Goal:** Write a 1-page specification for a custom agent that would address the Platform AI gaps you identified in the core lab.

**Why:** You're not ready to build agents yet (that's Modules 7-14). But you ARE ready to think about what they'd look like. This project bridges Module 03 (gap analysis) to Module 04 (connecting agents to tools via MCP). The spec you write here becomes your roadmap.

**Hints:**

- Pick ONE gap from your Platform AI Assessment (from the core lab). Don't try to design a full platform — focus.
- Example gaps: "CloudWatch detects anomalies but doesn't investigate", "Cost Explorer shows costs but doesn't explain why", "Q Developer suggests IaC but doesn't know our naming conventions", "No tool correlates deployment changes with metric anomalies."
- Use this template:

  ```
  Agent Name: [Simple, descriptive name]

  Problem: [The gap you identified — what platform AI can't do]

  Triggers: [When does this agent activate? What event starts it?]

  Inputs: [What information does the agent need to work?]
  - Example: CloudWatch alarm, recent deployment list, runbook for that alert type

  Decision-Making: [What logic does the agent follow?]
  - Step 1: [Decision point]
  - Step 2: [Decision point]
  - etc.

  Actions: [What can the agent do?]
  - Action 1: [Tool it would need to access]
  - Action 2: [Tool it would need to access]

  Success: [How do you know the agent worked?]

  Context You'd Encode (SKILL.md): [What operational knowledge would this agent need?]
  - Example: your team's escalation policy, approved remediation steps, SLAs
  ```

- Don't get bogged down in technical details. The point is to think: "If I automated this gap, what would the agent need to know and do?"

**Success criteria:**

- You have a 1-page spec (roughly 300-500 words) that describes a realistic agent
- The spec addresses one specific gap from the Platform AI Assessment
- The spec clearly states what problem the agent solves
- The spec includes at least 3 decision points (where the agent evaluates something and picks a direction)
- The spec identifies at least 2 tools/data sources the agent would need to access
- You've listed at least 3 pieces of operational context (your SKILL.md) the agent would need
- **Bonus:** Your spec mentions how this agent would fit into a larger system (e.g., "This agent runs when CloudWatch fires the 'High CPU' alarm, but hands off to the scaling agent if action is needed")

**Deliverable:** Save as `module-03-platform-ai/exploratory/custom-agent-spec.md`

---

## Connecting These Projects to the Course

After completing these projects:

- **Project 1** (Multi-Cloud Comparison) prepares you for Module 04 — when you wire agents to tools, you'll need to know which cloud services support those tools.
- **Project 2** (Org Audit) gives you a personal inventory of what you have and what to prioritize.
- **Project 3** (Sift vs Manual) makes the "investigation gap" concrete so you'll understand why custom agents are valuable.
- **Project 4** (Custom Agent Spec) is the bridge into Pillar 2. In Modules 06-12, you'll learn the techniques to build exactly what you spec'd here.

The custom agent spec you write in Project 4 becomes your north star for the rest of the course. When you learn context engineering (M06), skill authoring (M12), tool wiring (M11), you'll keep referring back to your spec: "Does this technique help me build the agent I designed?"

---

## How to Submit / Reflect

If you're in the live workshop:
- Bring Project 4 (your custom agent spec) to Day 2. We'll use it to brief the full team on the custom agent you want to build.
- Keep Projects 1-3 as reference material for yourself throughout the course.

If you're in the self-paced Udemy course:
- Complete at least Project 2 (Org Audit) and Project 4 (Custom Agent Spec).
- Save these to your course workspace — you'll refer back to them in Modules 06, 12, and the capstone.
- Project 4 becomes your capstone starting point in Module 14.
