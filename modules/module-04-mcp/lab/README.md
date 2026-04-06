# Module 04 Lab — Navigation Guide

Welcome to the Module 04 lab materials. Start here to understand the structure.

---

## Quick Navigation

### For Participants

**Start here:** [`LAB.md`](./LAB.md)
- Complete lab instructions (50 minutes)
- All four exercises with expected outputs
- Appendices A–D (configuration, troubleshooting, facilitator notes)

**During the lab:**
- Use [`starter/comparison-template.md`](./starter/comparison-template.md) to document your findings
- If using Crush, reference [`starter/crush-setup-guide.md`](./starter/crush-setup-guide.md) for MCP server setup

**After completing:**
- Compare your results against [`solution/example-exercise-outputs.md`](./solution/example-exercise-outputs.md)
- See [`solution/.mcp.json`](./solution/.mcp.json) for a complete multi-server configuration

### For Facilitators

**Run the lab:** [`LAB.md`](./LAB.md) — Appendix D contains live workshop facilitation notes

**Troubleshoot participants:**
- Section: Appendix C — Common troubleshooting
- Reference: [`solution/example-exercise-outputs.md`](./solution/example-exercise-outputs.md) — Shows what successful outputs look like

**Debrief questions:** [`LAB.md`](./LAB.md) — Appendix D includes suggested reflection questions

---

## Lab Structure

```
module-04-mcp/lab/
├── LAB.md                                    # Main lab instructions (start here)
├── README.md                                 # This file
├── starter/
│   ├── comparison-template.md                # Participant documentation template
│   └── crush-setup-guide.md                  # Alternative setup for Crush users
└── solution/
    ├── .mcp.json                             # Reference: Complete 4-server config
    └── example-exercise-outputs.md           # Reference: Example outputs from all 4 exercises
```

---

## Lab Overview

**Duration:** 50 minutes
**Difficulty:** Beginner
**Deliverables:** 4+ MCP servers connected, exercises completed, findings documented

**What you'll build:**
1. Verify existing Kubernetes MCP server
2. Add PostgreSQL MCP server (database context)
3. Add GitHub MCP server (code context)
4. Run 4 cross-platform query exercises (integration)
5. Document findings and reflect on the capabilities gap

---

## Key Learning Outcomes

By the end of this lab, you will understand:

1. **MCP is context engineering, not prompting.** You structure the tools and context; the agent integrates across them.

2. **Integration without manual context-switching.** One question reaches multiple tools. You don't copy-paste between terminals.

3. **The capabilities gap closes.** Platform AI + MCP lets you build agents that reason across infrastructure, databases, and code — something neither can do alone.

4. **Scaling pattern.** Adding a 4th or 5th MCP server adds minimal complexity. The architecture scales.

---

## Prerequisites Before Starting

Before opening `LAB.md`, verify:

- KIND cluster is running: `kind get clusters`
- PostgreSQL is accessible: `kubectl get pods | grep postgres`
- Node.js 18+ installed: `node --version`
- Claude Code OR Crush installed and working
- GitHub personal access token (if doing Exercise 4.4)

---

## File Descriptions

### LAB.md (Main Instructions)

**5 parts + 4 appendices:**

- **Part 1 (8 min):** Understand MCP configuration; test Kubernetes server
- **Part 2 (10 min):** Install and configure PostgreSQL MCP server
- **Part 3 (10 min):** Install and configure GitHub MCP server
- **Part 4 (15 min):** Run 4 cross-platform query exercises
- **Part 5 (7 min):** Document findings using the comparison template

**Appendices:**
- **A:** Claude Code `.mcp.json` reference
- **B:** Crush setup reference
- **C:** Troubleshooting common MCP issues
- **D:** Facilitator notes (live workshop)

### starter/comparison-template.md

**What it is:** Blank template for documenting lab findings

**How to use:**
1. Copy to your working directory: `cp starter/comparison-template.md my-findings.md`
2. Fill it in as you complete each exercise
3. Submit with your course deliverables

**Sections:**
- Exercise results (4.1–4.4 outputs)
- Manual vs. MCP workflow comparison
- Reflection on capabilities gap
- Key insights
- Extension ideas

### starter/crush-setup-guide.md

**What it is:** Parallel guide for Crush users (instead of Claude Code)

**When to use:** If your team is using Crush instead of Claude Code

**Sections:**
- Installation
- Getting started with Crush REPL
- Step-by-step server connection (`/connect` commands)
- Crush-specific commands (`/list`, `/disconnect`, `/config`)
- Troubleshooting for Crush
- Crush vs. Claude Code comparison

### solution/.mcp.json

**What it is:** Example of a complete `.mcp.json` with 3 servers

**Why reference it:** Shows correct syntax for Kubernetes, PostgreSQL (URL format), and GitHub

**Important:** Replace placeholder values:
- `KUBECONFIG` uses `${HOME}` — works as-is or replace with your full path
- `GITHUB_PERSONAL_ACCESS_TOKEN` (use your actual token, not the placeholder)
- PostgreSQL URL includes lab credentials — matches Module 01 setup

### solution/example-exercise-outputs.md

**What it is:** Reference outputs showing what successful exercise results look like

**Why reference it:**
- Validates that your outputs are in the right ballpark
- Shows cross-platform correlation examples
- Demonstrates the quality jump from single-tool to multi-tool queries
- Includes root-cause analysis walkthrough (Exercise 4.4)

**Important note:** Your actual outputs will differ based on:
- Your cluster's pod state
- Your database contents (events, items, timestamps)
- Your Git history (commit messages, authors, changes)

The *pattern* is what matters, not exact matches.

---

## Lab Flow (Quick Reference)

1. **Open LAB.md**
2. **Part 1:** Verify Kubernetes MCP (should already work from M01)
3. **Part 2:** Add PostgreSQL server
   - Test: `psql` query from the agent
4. **Part 3:** Add GitHub server
   - Test: Commit history query from the agent
5. **Part 4:** Run 4 exercises
   - Ex 1: Kubernetes only
   - Ex 2: PostgreSQL only
   - Ex 3: Kubernetes + PostgreSQL (integration)
   - Ex 4: Kubernetes + PostgreSQL + GitHub (full integration)
6. **Part 5:** Fill out `comparison-template.md`
7. **Check your work:** Compare outputs to `solution/example-exercise-outputs.md`

**Total time:** 50 minutes (+ 10 min buffer for troubleshooting)

---

## Common Questions

### Q: Do I have to use Claude Code? Can I use Crush?

**A:** Yes! Both work. If using Crush, follow `starter/crush-setup-guide.md` instead of Appendix B in LAB.md.

### Q: What if my cluster doesn't have a pod that restarted?

**A:** Adapt the query. Exercise 4.1 asks for "restarts > 1" but you can ask for "any pods" or "pods with restarts > 0". The pattern is the same.

### Q: Do I need Prometheus for this lab?

**A:** No, it's optional. Exercises 4.1–4.4 work with just Kubernetes, PostgreSQL, and GitHub. Prometheus adds value but isn't required.

### Q: What if I don't have a GitHub token yet?

**A:** Create one in Part 3, Step 3.1. Takes 2 minutes. You need `repo` scope (read-only).

### Q: How do I know if my MCP servers are connected?

**A:** Try a simple query. If the agent returns data without errors, the server is connected.
- Kubernetes: "List 3 pods in the app namespace"
- PostgreSQL: "Count rows in the events table"
- GitHub: "Show 3 recent commits"

### Q: What if a server disconnects mid-exercise?

**A:** Restart it. In Claude Code: restart the app. In Crush: `/disconnect serverName` then `/connect serverName`.

---

## Deliverables Checklist

Before finishing the lab, ensure you have:

- [ ] All 4 MCP servers connected (Kubernetes, PostgreSQL, GitHub, + optional Prometheus)
- [ ] Outputs from Exercise 4.1 (Kubernetes-only query)
- [ ] Outputs from Exercise 4.2 (PostgreSQL-only query)
- [ ] Outputs from Exercise 4.3 (Kubernetes + PostgreSQL)
- [ ] Outputs from Exercise 4.4 (Kubernetes + PostgreSQL + GitHub)
- [ ] Completed `comparison-template.md` with:
  - All 4 exercise outputs
  - Manual vs. MCP workflow comparison
  - Reflection on capabilities gap
  - Key insights

---

## Next Steps After This Lab

- **Module 05–06:** Use MCP servers in your own automation workflows
- **Module 07:** Build custom MCP servers (SKILL.md authoring) for proprietary tools
- **Module 10–13:** Chain MCP servers into autonomous agents for incident response, cost optimization, etc.

---

## Support

**Stuck?** Check:
1. LAB.md Appendix C (Troubleshooting)
2. `starter/crush-setup-guide.md` (if using Crush)
3. `solution/example-exercise-outputs.md` (validate your approach)

**For facilitators:** Appendix D in LAB.md has debrief questions and live workshop tips.

---

