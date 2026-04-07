# Phase 5: Module Consolidation - Research

**Researched:** 2026-04-07
**Domain:** Course content restructuring — Docusaurus module rename, Superpowers-for-IaC lab authoring, TDD tooling for Helm/Terraform
**Confidence:** HIGH (direct file inspection of all affected content)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Lab Track Structure**
- D-01: 2 tracks in new Module 5: Track A (K8s: Helm chart for reference app) and Track B (Cloud IaC: Terraform EC2+CloudWatch+SNS module)
- D-02: Single 90-minute lab per track — continuous walkthrough of all Superpowers applied to the project
- D-03: ArgoCD and CI/CD pipeline content from old modules absorbed as supplementary reading or exploratory, not primary lab tracks

**Superpowers Depth**
- D-04: Full Superpowers cycle in the lab: brainstorm → TDD (failing test first) → implement → debug (using AI generation errors, not planted failures) → verify + code review
- D-05: Each Superpowers phase gets 15-20 minutes within the 90-minute lab
- D-06: AI generation errors serve as the debugging exercise — natural and authentic rather than artificially planted bugs

**Content Migration**
- D-07: Module 6 (was 5b: AI Workflow Tools) keeps existing reading/quiz content as-is — only rename and update module numbering
- D-08: Module 5 (Superpowers for IaC) gets completely new reading and quiz content based on the new lab
- D-09: Old Module 5a and old Module 6 reading/quiz content used as reference material only, not directly migrated

**Module 5 IaC Project**
- D-10: No starter code in Module 5 labs — Superpowers workflows generate the IaC from scratch. The "starter" is the context (CLAUDE.md + requirements), not pre-written code.
- D-11: Track A builds a production Helm chart for the existing reference app (api-gateway, catalog, worker) from zero. TDD validates chart structure, then deploys to KIND.
- D-12: Track B builds a Terraform module (EC2 + CloudWatch + SNS) from zero using mock_provider for TDD. Free tier compatible.
- D-13: Solution files remain as reference for comparison — participants compare AI-generated output against solutions

### Claude's Discretion

- Exact TDD framework/approach for validating Helm chart structure (helm lint, kubeval, custom assertions)
- Exact TDD approach for Terraform (terraform test with mock_provider, tflint, custom validation)
- Reading material structure and quiz question design
- How to organize exploratory projects for the restructured module
- Sidebar positions and _category_.json configuration

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope

</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| CONS-01 | Module 5 rebuilt as "Superpowers for IaC" with brainstorm, TDD, verification, debugging, and code review workflows applied to Terraform/Helm/GitOps tracks | Superpowers files read; TDD tooling for Helm/Terraform researched; existing lab patterns inspected |
| CONS-02 | Module 6 renamed from "5b" to "AI Workflow Tools" — GSD + CLAUDE.md + claude-mem + plan modes (content preserved, numbering updated) | Full file inventory of module-05b-ai-workflows; _category_.json rename pattern confirmed; cross-reference map built |
| CONS-03 | Old Module 6 (AI-Assisted IaC) content absorbed into new Module 5 as project context — Terraform/Helm/GitOps become the domain for Superpowers exercises | module-06-ai-iac file inventory complete; Terraform solution files inspected; Helm chart baseline inspected |
| CONS-04 | Reading materials and quizzes updated to match restructured Module 5 and 6 content | Cross-reference audit complete; stale links identified; content derivation strategy confirmed |

</phase_requirements>

---

## Summary

Phase 5 is a content restructuring operation, not a technology buildout. Three existing directories (`module-05a-structured-coding`, `module-05b-ai-workflows`, `module-06-ai-iac`) are reorganized into two new ones. The mechanical rename work (directory rename + _category_.json updates) is low-risk. The substantive work is authoring new lab content for the new Module 5 — two 90-minute tracks that run the full Superpowers cycle on IaC artifacts.

The key content insight: Module 5a already has a Helm lab track (Track A) that runs the 5-phase structured workflow on the reference app chart. Module 06 has the Terraform track. The new Module 5 takes those IaC artifacts as the *project domain* and wraps the Superpowers cycle (brainstorm → TDD → implement → debug → verify → code review) around them instead of the 5-phase structured generation workflow. This is not reusing the old lab content — it is writing a new lab with a different pedagogical structure applied to the same IaC problems.

The biggest environment finding: **Terraform v1.4.6 is installed locally — below the 1.7 threshold required for `mock_provider`.** The CLAUDE.md already accounts for this with the mock_provider fallback pattern, but the lab must be explicit about the version requirement and alternative for participants on older Terraform installs. Helm v3.18.4 and KIND v0.27.0 are available and sufficient.

**Primary recommendation:** Sequence the work as (1) directory renames for Module 6, (2) cross-reference updates, (3) new Module 5 lab authoring, (4) new Module 5 reading/quiz. Renaming Module 6 first isolates the low-risk mechanical work before the high-effort new content authoring begins.

---

## Current State Inventory (Runtime State for Rename)

This is a content rename/restructure, so a runtime state inventory is required.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | None — no databases, no persistent state | None |
| Live service config | None — Docusaurus is a static site, no running services store module names | None |
| OS-registered state | None — no cron jobs or OS tasks reference module names | None |
| Secrets/env vars | None — no env vars reference module directory names | None |
| Build artifacts | `.docusaurus/` cache directory — Docusaurus caches sidebar/route data from directory names | Run `npm run build` or clear `.docusaurus/` after rename to force regeneration |

**The main rename surface is files, not runtime state.** The rename affects:
1. Directory names on disk
2. `_category_.json` `label` and `id` fields
3. MDX frontmatter `id` and `title` fields
4. Cross-reference links in MDX files (document IDs used by Docusaurus autogenerated sidebar)
5. `intro.mdx` module overview table (two rows need updating)
6. Udemy-facing module numbering in `STATE.md` decision: `[Phase 04-remaining-content]: Udemy uses 15 sections for 14 modules — Module 5a and 5b separate into sections 5 and 6 for self-paced pacing` — the consolidation changes this to 14 sections for 14 modules (or 15 for a differently split Day 2).

---

## Cross-Reference Audit (Full Map of Stale Links After Rename)

This is the complete map of every file that contains a reference to `module-05a`, `module-05b`, or `module-06` (identified by direct grep). Each entry shows the file, what it references, and the required update.

### Files requiring update after rename

| File | Current Reference | Required Update |
|------|-------------------|-----------------|
| `course-site/docs/intro.mdx` | `module-05a-structured-coding/module-05a-readme` | New Module 5 readme link |
| `course-site/docs/intro.mdx` | `module-05b-ai-workflows/module-05b-readme` | New Module 6 readme link |
| `course-site/docs/intro.mdx` | `module-06-ai-iac/module-06-readme` | Remove (module absorbed into 5) |
| `course-site/docs/intro.mdx` | "Module 5a: Structured AI Coding" description | Update to "Module 5: Superpowers for IaC" |
| `course-site/docs/intro.mdx` | "Module 5b: AI Workflows" description | Update to "Module 6: AI Workflow Tools" |
| `course-site/docs/intro.mdx` | "Module 6: AI-Assisted IaC" row | Remove or fold into Module 5 description |
| `course-site/docs/module-03-bridge/reading/reference.mdx` | "Module 6 \| AI-assisted Terraform/Ansible/K8s generation" | Update to reference new Module 5 |
| `course-site/docs/module-05b-ai-workflows/quiz/QUIZ.mdx` | "Continue to: Module 6 — AI-Assisted IaC" link | Update to new Module 6 (was 5b) content |
| `course-site/docs/module-05b-ai-workflows/lab/LAB.mdx` | "Module 5a setup" in prerequisites | Update to new Module 5 or setup page |
| `course-site/docs/module-05b-ai-workflows/lab/LAB.mdx` | "Module 6: AI-Assisted IaC" in next steps | Update to new module numbering |
| `course-site/docs/module-05b-ai-workflows/README.mdx` | "KIND cluster with Prometheus and Grafana deployed (from Module 5a setup)" | Update prerequisite wording |
| `course-site/docs/module-05a-structured-coding/quiz/QUIZ.mdx` | "Continue to: Module 5b — AI Workflow Tools" link | Update to new Module 6 |
| `course-site/docs/module-05a-structured-coding/quiz/QUIZ.mdx` | "Module 5b deepens the workflow side" | Update module name |
| `course-site/docs/module-06-ai-iac/README.mdx` | "Module 5a or 5b completed" prerequisite | N/A — module is being absorbed |
| `course-site/docs/module-01-foundations/reading/reference.mdx` | "Infrastructure Generation (Module 6)" heading | Update to new Module 5 |

**Note on doc IDs:** Docusaurus autogenerated sidebar uses MDX frontmatter `id` field for links (not directory path), so a link like `../../module-06-iac/` may break even if the `id` field is preserved in the new location. All relative path links in `quiz/QUIZ.mdx` files that use `../../module-XX-*` must be verified after rename.

**Broken link discovered:** `module-05b/quiz/QUIZ.mdx` line 255 references `../../module-06-iac/` (without `ai-`). This is already a broken link — the actual directory is `module-06-ai-iac`. Flag this for cleanup during the cross-reference update pass.

---

## Architecture Patterns

### Docusaurus Directory Rename Pattern

The site uses `autogenerated` sidebar from `_category_.json` files. Renaming a directory requires:

1. Rename the directory itself (e.g., `module-05a-structured-coding/` → `module-05-superpowers-iac/`)
2. Update `_category_.json` inside:
   - `"label"` — display name in sidebar
   - `"position"` — sidebar ordering (integer, lower = higher)
   - `"link.id"` — must match the MDX `id` frontmatter in the README file
3. Update MDX frontmatter in every file inside the renamed directory — the `id` field must be updated if any other file references it by that ID
4. Clear `.docusaurus/` cache or run `npm run build` to regenerate routes

**Confirmed:** The sidebar is fully `autogenerated` (sidebars.ts: `type: 'autogenerated', dirName: '.'`). No manual sidebar entries exist. Renaming directories + updating _category_.json is sufficient.

### Current Sidebar Position Map

| Directory | position | label |
|-----------|----------|-------|
| `module-05a-structured-coding/` | 5 | Module 5a: Structured AI Coding |
| `module-05b-ai-workflows/` | 6 | Module 5b: AI Workflow Tools |
| `module-06-ai-iac/` | 7 | Module 6: AI-Assisted IaC |
| `module-07-agent-skills/` | 8 | Module 7: Agent Skills |

After restructuring, the desired outcome is:
- New Module 5 (Superpowers for IaC) at position 5
- New Module 6 (AI Workflow Tools, was 5b) at position 6
- Module 7 remains at position 8 (no change)
- Old Module 6 (AI-Assisted IaC) directory deleted

Modules 7-14 have positions 8-15. They are unaffected — positions 5 and 6 are the only ones changing meaning.

### Lab Structure Pattern (Established)

Both `module-05a` and `module-06-ai-iac` use the Track A/B pattern with a "Choose Your Track" README section. New Module 5 must follow this same pattern:

```
module-05-superpowers-iac/
├── _category_.json          # label: "Module 5: Superpowers for IaC", position: 5
├── README.mdx               # id: module-05-readme, overview, Choose Your Track table
├── lab/
│   ├── _category_.json
│   ├── LAB-track-a-helm.mdx    # Track A: Helm chart (90 min Superpowers cycle)
│   └── LAB-track-b-terraform.mdx  # Track B: Terraform EC2+CloudWatch+SNS (90 min)
├── reading/
│   ├── _category_.json
│   ├── concepts.mdx         # New content — Superpowers applied to IaC
│   └── reference.mdx        # Cheat sheet: Superpowers phases + IaC commands
├── quiz/
│   ├── _category_.json
│   └── QUIZ.mdx             # New questions tied to new lab content
└── exploratory/
    ├── _category_.json
    └── PROJECTS.mdx         # ArgoCD, CI/CD, second-track work
```

**No `starter/` or `solution/` subdirectory in lab/ for new Module 5.** Per D-10, participants generate from scratch. Solution files (Terraform and Helm) already exist in `module-06-ai-iac/lab/solution/` and `reference-app/helm/`. Those are referenced by path, not duplicated.

---

## Superpowers Workflow — Verified Definitions

Read directly from `~/.claude/superpowers/` files. These are the authoritative definitions the lab must teach.

### TDD (RED-GREEN-REFACTOR)
- **Iron Law:** No production code without a failing test first. Code before test? Delete it. Start over.
- **RED:** Write one minimal failing test. Verify it fails for the right reason (missing feature, not a typo).
- **GREEN:** Write the minimum code to pass. Do not add unrequested behavior.
- **REFACTOR:** Remove duplication, improve names. Keep tests green. Do not add behavior.
- **Bug fix flow:** Write failing test reproducing the bug → verify it fails → minimal fix → verify all pass.

### Systematic Debugging (4 Phases)
- **Phase 1 (Investigation):** Read errors carefully, reproduce consistently, check recent changes, trace data flow backward to source.
- **Phase 2 (Pattern Analysis):** Find working examples, compare what's different.
- **Phase 3 (Hypothesis):** Form single hypothesis. Test with smallest possible change. One variable at a time.
- **Phase 4 (Implementation):** Failing test first (TDD), single targeted fix, verify.
- **3-Fix Rule:** After 3 failed attempts, STOP. Question the architecture.

### Code Review (5 Dimensions)
- Code Quality: separation of concerns, error handling, type safety, DRY, edge cases
- Architecture: design soundness, scalability, performance, security
- Testing: validates real logic (not mocks), edge cases, integration tests pass
- Requirements: all planned features exist, specs met, scope controlled
- Production Readiness: migrations, backward compatibility, documentation

### Verification Before Completion
- **Iron Law:** No completion claims without fresh verification evidence.
- **Gate Function:** Identify → Run → Read → Verify → Claim (skip any step = invalid claim)
- "Should work now", "Probably passes" are red flags without having run the command.

---

## TDD Tooling for IaC (Claude's Discretion Area)

### Track A: Helm Chart TDD

**Tools available on participant machines (high probability):**
- `helm lint` — syntax and schema validation; catches API version mismatches, missing required fields, YAML errors. **Available on instructor machine: v3.18.4**
- `helm template` — renders chart to stdout without deploying; output piped to `kubectl apply --dry-run=client -f -` validates Kubernetes manifests against local schema
- `kubectl apply --dry-run=server -f -` — server-side dry run; validates against live cluster's API server including custom resources (requires KIND cluster running)

**Tools NOT available on instructor machine (may or may not be on participant machines):**
- `kubeval` — not installed; validates rendered manifests against Kubernetes JSON schemas (offline)
- `kubeconform` — not installed; successor to kubeval; more actively maintained
- `helm-unittest` — no Helm plugins installed; plugin-based YAML unit test framework for Helm charts

**Recommended TDD approach for Track A (no extra installs required):**

The TDD cycle for Helm chart uses `helm lint` as the RED test and `helm lint` + `helm template | kubectl apply --dry-run=client` as the GREEN verification. This requires zero additional tools and maps directly to the RED-GREEN-REFACTOR pattern:

```bash
# RED: Write the test (define what the template should contain)
# For Helm, the "test" is a helm lint run on the skeleton chart
helm lint reference-app/helm/reference-app/
# Expected: lint FAILS or warns because required resources are missing

# GREEN: Generate the template via AI, then verify
helm lint reference-app/helm/reference-app/
helm template reference-app/helm/reference-app/ | kubectl apply --dry-run=client -f -
# Expected: lint passes, dry-run shows resources that would be created

# REFACTOR: AI review pass on generated templates
# Then: helm lint must still pass
```

For per-template TDD (the Superpowers spirit): each new template file (HPA, PDB, ServiceMonitor, NOTES.txt) is a separate RED-GREEN cycle:
1. RED: `helm lint` before adding the template — chart is incomplete/missing resource
2. AI generates the template
3. GREEN: `helm lint` + `helm template ... | kubectl apply --dry-run=client -f -`

**`helm unittest` alternative (if participants want it):**
```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```
Provides YAML-based test files under `tests/` directory with assertions like `hasDocuments`, `matchSnapshot`, `equal`. More expressive than lint but adds installation friction. Recommend as exploratory stretch, not primary lab tool.

**Confidence:** HIGH — verified by reading existing Module 5a lab which already uses helm lint + dry-run pattern.

### Track B: Terraform TDD

**Critical finding — version mismatch:**

The course CLAUDE.md specifies Terraform 1.7+ for `mock_provider`. The instructor machine has Terraform **v1.4.6**, which does NOT support `mock_provider`. The existing `module-06-ai-iac` lab already documented this requirement (`Step 0: Version Check`) and required 1.7+.

**Participants must have Terraform 1.7+ for the TDD track to work.** The lab must include a version check step (identical to the existing Module 6 lab pattern) and a clear install instruction.

**TDD approach for Track B (Terraform 1.7+):**

The `terraform test` command with `mock_provider "aws" {}` is the established pattern in this codebase. The existing solution file at `module-06-ai-iac/lab/solution/terraform/tests/unit.tftest.hcl` is the reference implementation.

RED-GREEN-REFACTOR for Terraform:
```hcl
# RED: Write test before implementing resources
# unit.tftest.hcl — create this BEFORE generating main.tf
mock_provider "aws" {}

run "ec2_instance_exists" {
  variables { notification_email = "test@example.com" }
  assert {
    condition     = module.app.instance_id != ""
    error_message = "EC2 instance should be created"
  }
}

# Run: terraform test → FAILS (no resources defined yet)
```

```bash
# GREEN: After AI generates main.tf
terraform validate    # Schema validation (no AWS creds needed)
terraform test        # mock_provider runs tests without AWS calls
```

**Alternative for Terraform <1.7 (fallback path):**
- `terraform validate` only (no test framework, just schema validation)
- Reduces TDD to "validate the syntax passes" rather than "verify the resource structure"
- Document this as a degraded experience with clear messaging

**tflint note:** Not installed on instructor machine. tflint provides provider-specific rule validation (e.g., correct instance types, deprecated arguments). Valuable but optional — recommend as exploratory stretch only.

**Confidence:** HIGH — existing unit.tftest.hcl in codebase is directly reusable; terraform validate confirmed available.

---

## Content Migration Map

### What moves where

| Source | Destination | Action |
|--------|-------------|--------|
| `module-05a-structured-coding/` | `module-05-superpowers-iac/` (NEW) | Deleted; old content used as reference only (D-09) |
| `module-05b-ai-workflows/` | `module-06-ai-workflow-tools/` | Rename directory; update _category_.json + frontmatter IDs |
| `module-06-ai-iac/` | Absorbed | Delete directory; Terraform/Helm solution files referenced from their existing paths |
| `module-06-ai-iac/lab/solution/terraform/` | Keep in place OR move to new Module 5 solution | Accessible at existing path for reference; no duplication needed |
| `reference-app/helm/reference-app/` | Keep in place | Already the baseline for Track A |

### Module 6 rename specifics (D-07: content as-is, only rename/renumber)

Files to update inside `module-05b-ai-workflows/` (after directory rename to `module-06-ai-workflow-tools/`):

| File | Change |
|------|--------|
| `_category_.json` | `label`: "Module 6: AI Workflow Tools", `position`: 6, `link.id`: "module-06-ai-workflow-tools/module-06-readme" |
| `README.mdx` | frontmatter `id`, `title` ("Module 6"), heading, prerequisites (remove "from Module 5a setup") |
| `lab/LAB.mdx` | frontmatter `id`, title, prerequisite references, next-steps references |
| `reading/concepts.mdx` | frontmatter `id`, all "Module 5b" self-references updated to "Module 6" |
| `reading/reference.mdx` | frontmatter `id`, "Module 5b Lab Example" heading updated |
| `quiz/QUIZ.mdx` | frontmatter `id`, "Continue to" link updated to new Module 7 (not Module 6 IaC) |
| `exploratory/PROJECTS.mdx` | frontmatter `id`, module name references |
| All `_category_.json` files in subdirectories | No changes needed (they only control sub-labels) |

### New Module 5 content to author (D-08: completely new)

| File | From Scratch | Key Sources |
|------|-------------|-------------|
| `module-05-superpowers-iac/README.mdx` | Yes | Superpowers workflow definitions + Track A/B pattern from 5a/06 READMEs |
| `lab/LAB-track-a-helm.mdx` | Yes | 5-phase pattern from 5a Track A + Superpowers cycle; helm lint + dry-run TDD |
| `lab/LAB-track-b-terraform.mdx` | Yes | mock_provider pattern from module-06 solution + Superpowers cycle |
| `reading/concepts.mdx` | Yes | Superpowers workflow files as primary source |
| `reading/reference.mdx` | Yes | Helm/Terraform command cheat sheet |
| `quiz/QUIZ.mdx` | Yes | Derived from new reading/lab content |
| `exploratory/PROJECTS.mdx` | Yes | ArgoCD GitOps, CI/CD pipeline as stretch tracks |

---

## Existing Reference App Baseline (Track A context)

The Helm chart at `reference-app/helm/reference-app/` is the Track A starting point:
- **Chart.yaml:** apiVersion: v2, name: reference-app, version: 1.0.0
- **values.yaml:** 4 services (api-gateway:8080, catalog:8081, worker:8082, dashboard:3000/NodePort:30080)
- **templates/:** 13 files — Deployments + Services + ConfigMaps + db-secret, migrations-configmap, dashboard-nginx-configmap, _helpers.tpl
- **Has:** resource requests (`cpu: 50m`, `memory: 64Mi`), liveness/readiness probes (documented in existing 5a lab)
- **Missing (production gaps — these are the TDD targets):** resource limits, HPA, PDB, ServiceMonitor, NOTES.txt

Module 5a's Track A lab (which is being superseded) already mapped these 6 gaps. The new Module 5 lab reuses this same gap list as the Superpowers TDD target — but now participants arrive at the gap list via a structured brainstorm + TDD phase rather than manual inspection.

---

## Existing Terraform Baseline (Track B context)

The Terraform solution at `module-06-ai-iac/lab/solution/terraform/` is the Track B comparison reference:
- **Module:** `ec2-monitored/` — EC2 (t2.micro), CloudWatch CPU alarm, SNS topic + email subscription
- **Structure:** data source (`aws_ami`), 4 resources, 4 variables (instance_name, alarm_threshold, notification_email, vpc_id)
- **Tests:** `unit.tftest.hcl` — 3 tests using `mock_provider "aws" {}` (existence checks on ARNs/IDs)
- **Free tier:** t2.micro, basic monitoring (not detailed), SNS email only (no SMS)

Per D-12, Track B builds this FROM SCRATCH via Superpowers. The solution files are the comparison reference (D-13). Participants DO NOT get starter files — they generate using CLAUDE.md context + requirements as their "starter."

The existing starter files at `module-06-ai-iac/lab/starter/terraform/` (skeleton with TODO comments) serve as a design reference for what a "complete context" looks like, but the Superpowers approach is different: context is provided via CLAUDE.md, not via pre-filled TODO placeholders.

---

## Superpowers Lab Time Budget (D-05: 15-20 min per phase)

90-minute single-track lab allocation:

| Phase | Superpowers Step | Time | Helm (Track A) Activity | Terraform (Track B) Activity |
|-------|-----------------|------|--------------------------|------------------------------|
| 0 | Setup + Context | 10 min | Create project CLAUDE.md with system state | Create project CLAUDE.md with AWS constraints |
| 1 | Brainstorm | 15 min | AI gap analysis on existing chart | AI requirements list for EC2+CloudWatch+SNS module |
| 2 | TDD (RED) | 20 min | Write helm lint expectations; confirm chart fails without target resources | Write unit.tftest.hcl before main.tf; `terraform test` fails |
| 3 | Implement (GREEN) | 20 min | AI generates templates; `helm lint` + `helm template --dry-run` passes | AI generates main.tf; `terraform validate` + `terraform test` passes |
| 4 | Debug | 10 min | Fix AI generation errors (wrong API version, wrong matchLabels selector) | Fix AI generation errors (wrong attribute names, wrong AMI filter) |
| 5 | Verify + Code Review | 15 min | `helm lint` clean; `kubectl apply --dry-run=server`; AI code review on generated YAML | `terraform validate`; `terraform test` all pass; AI code review on generated HCL |

---

## Common Pitfalls

### Pitfall 1: Docusaurus doc ID collision after rename
**What goes wrong:** After renaming a directory, the MDX frontmatter `id` still uses the old module name. Docusaurus logs "duplicate id" warnings or broken link warnings if the old ID is referenced elsewhere.
**Why it happens:** The `id` in frontmatter is Docusaurus's routing key — it must be unique across the site and must match all cross-references to that file.
**How to avoid:** Update `id` frontmatter in ALL files inside renamed directories AND update every cross-reference link using `../../old-module-name/` patterns.
**Warning signs:** Docusaurus build output shows "docs with id X not found" or broken link warnings. Run `npm run build` after rename to surface all issues.

### Pitfall 2: ArgoCD memory exhaustion on KIND (already documented)
**What goes wrong:** Standard ArgoCD install requests ~1.3GB total RAM; laptop KIND clusters OOM.
**How to avoid:** The ArgoCD setup-argocd.sh already patches memory limits. If ArgoCD is moved to exploratory content (D-03), this pitfall moves to the exploratory section. Flag it there.
**Warning signs:** KIND node `kubectl describe` shows OOMKilled for argocd pods.

### Pitfall 3: Terraform mock_provider requires exactly 1.7+
**What goes wrong:** Participant has Terraform 1.4.x or 1.5.x. `mock_provider` block causes parse error.
**Why it happens:** `mock_provider` was introduced in Terraform 1.7.0. Common to have older installs.
**How to avoid:** Lab must open with version check step and explicit upgrade instructions (identical to existing Module 6 lab Step 0).
**Warning signs:** `Error: Unsupported argument. An argument named "mock_provider" is not expected here.`

### Pitfall 4: helm template outputs break with custom values
**What goes wrong:** `helm template | kubectl apply --dry-run=client -f -` fails because `helm template` defaults generate manifests referencing `example.com` images or missing required values.
**How to avoid:** Always pass explicit values: `helm template <release-name> <chart-path> -f values.yaml`. Instruct participants to use the existing `reference-app/helm/reference-app/values.yaml`.
**Warning signs:** kubectl dry-run output shows `Error: ImagePullBackOff` or validation errors referencing missing fields.

### Pitfall 5: Frontmatter `id` mismatch breaks Docusaurus links
**What goes wrong:** A quiz file has `id: module-05b-quiz` in frontmatter but the cross-reference in another file uses the old directory-relative path. After rename, Docusaurus cannot resolve the link.
**Why it happens:** Docusaurus resolves links by document `id`, not by file path. If the `id` is kept but the directory changed, relative path links `../../module-05b-ai-workflows/` now point to a nonexistent location.
**How to avoid:** Use `id`-based links (the Docusaurus recommended approach, already noted in STATE.md decisions) rather than relative paths. Audit all `../../` links in quiz and lab files before deleting old directories.
**Warning signs:** `[Phase 02-day-1-modules]: MDX cross-links use document id (e.g., ./module-01-reference) not relative path` — the codebase pattern is already established; ensure new content follows it.

### Pitfall 6: The existing `module-06-iac/` link is already broken
**What goes wrong:** `module-05b-ai-workflows/quiz/QUIZ.mdx` line 255 references `../../module-06-iac/` (without `-ai-`). The actual directory is `module-06-ai-iac`. This is a pre-existing broken link.
**How to avoid:** Fix this during the cross-reference update pass — it will become the correct `module-06-ai-workflow-tools/` link after restructuring.

---

## Code Examples

### _category_.json — New Module 5
```json
{
  "label": "Module 5: Superpowers for IaC",
  "position": 5,
  "collapsed": false,
  "link": {
    "type": "doc",
    "id": "module-05-superpowers-iac/module-05-readme"
  }
}
```

### _category_.json — New Module 6 (renamed from 5b)
```json
{
  "label": "Module 6: AI Workflow Tools",
  "position": 6,
  "collapsed": false,
  "link": {
    "type": "doc",
    "id": "module-06-ai-workflow-tools/module-06-readme"
  }
}
```

### Helm TDD cycle (Track A — no extra tools)
```bash
# Step 0: Version check
helm version --short  # Must show v3.x

# RED: Chart is incomplete (missing HPA, PDB, ServiceMonitor)
helm lint reference-app/helm/reference-app/
# Expected: 0 errors but 0 HPAs — the "test" is explicit absence

# AI generates hpa.yaml, pdb.yaml, servicemonitor.yaml, NOTES.txt

# GREEN: Lint + dry-run validation
helm lint reference-app/helm/reference-app/
helm template course-app reference-app/helm/reference-app/ \
  -f reference-app/helm/reference-app/values.yaml \
  | kubectl apply --dry-run=client -f -

# REFACTOR: AI code review pass
# Then re-run helm lint to confirm clean
```

### Terraform TDD cycle (Track B — requires Terraform 1.7+)
```bash
# Step 0: Version check (REQUIRED — mock_provider needs 1.7+)
terraform version  # Must show 1.7.0 or higher

# RED: Write tests FIRST, before main.tf exists
# Create tests/unit.tftest.hcl with mock_provider + assertions
# Run:
terraform test  # FAILS: no resources defined

# AI generates main.tf, variables.tf, outputs.tf, versions.tf

# GREEN: Validate + test
terraform validate  # Schema check (no AWS creds needed)
terraform test      # mock_provider runs without AWS

# REFACTOR: AI code review on generated HCL
# Then re-run terraform test to confirm still green
```

### Terraform mock_provider test file (Track B baseline)
```hcl
# Source: module-06-ai-iac/lab/solution/terraform/tests/unit.tftest.hcl
# Verified: existing file in codebase
mock_provider "aws" {}

run "ec2_instance_exists" {
  variables { notification_email = "test@example.com" }
  assert {
    condition     = module.app.instance_id != ""
    error_message = "EC2 instance ID should not be empty"
  }
}

run "alarm_configured" {
  variables { notification_email = "test@example.com" }
  assert {
    condition     = module.app.alarm_arn != ""
    error_message = "CloudWatch alarm ARN should not be empty"
  }
}
```

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Terraform schema validation without AWS credentials | Custom Python/bash validation script | `terraform validate` | Built-in, provider-schema-aware, zero setup |
| Terraform resource existence testing without AWS | `curl` to mock endpoints, manual checks | `terraform test` with `mock_provider "aws" {}` | Native to Terraform 1.7+; already in codebase |
| Helm chart structure validation | Custom YAML parser or bash grep | `helm lint` + `helm template \| kubectl apply --dry-run` | Standard Helm toolchain; zero extra install |
| Helm YAML unit tests | Custom bash diff scripts | `helm-unittest` plugin (exploratory only) | Plugin exists; but adds install friction — use only for exploratory |
| Sidebar ordering | Manual `sidebars.ts` entries | `_category_.json` position field | Already established pattern; autogenerated sidebar |

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Helm | Track A lab | Yes | v3.18.4 | None needed |
| kubectl | Track A dry-run validation | Yes | (installed, version output suppressed) | Skip server-side dry-run, use client-only |
| KIND | Track A server-side validate | Yes | v0.27.0 | Use `--dry-run=client` only |
| Terraform | Track B lab | Yes | v1.4.6 — BELOW 1.7 minimum | See note below |
| terraform test / mock_provider | Track B TDD | No (v1.4.6) | Requires 1.7+ | `terraform validate` only (degraded) |
| tflint | Track B stretch | No | — | Skip — not required for core lab |
| kubeval | Track A stretch | No | — | Skip — helm lint covers core validation |
| kubeconform | Track A stretch | No | — | Skip — helm lint covers core validation |
| helm-unittest | Track A stretch | No | — | Skip — exploratory only |

**Terraform version gap — critical for lab authoring:**
- Instructor machine: v1.4.6 (does not support mock_provider)
- Course requires: v1.7+ (per CLAUDE.md and existing Module 6 lab)
- Lab must include Step 0 version check with upgrade instructions (already written in existing Module 6 Track A lab)
- Participants who cannot upgrade: fallback to `terraform validate` only — lose the TDD test step but can still follow the workflow conceptually

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Terraform manual testing / LocalStack | `terraform test` with `mock_provider` | Terraform 1.7 (2024) | Free offline testing; no AWS creds needed |
| OpenCode (opencode-ai/opencode) | Crush (charmbracelet/crush) | Sept 18, 2025 | OpenCode archived; Crush is active successor |
| Gemini 2.0 Flash | Gemini 2.5 Flash | Feb 2026 | 2.0 deprecated, retiring June 1, 2026 |
| LocalStack as required lab dep | Static JSON fixtures / terraform mock_provider | March 2026 | Community EOL requires auth token |
| kubeval | kubeconform | 2022+ (kubeval unmaintained) | kubeconform actively maintained; kubeval stale |

**Deprecated/outdated in context of this phase:**
- `module-05a-structured-coding/` directory: being superseded — content becomes reference only
- `module-06-ai-iac/` directory: being absorbed — solution files remain as reference, directory deleted
- "Module 5a", "Module 5b", "Module 6" naming in all cross-reference links — all stale after restructuring

---

## Open Questions

1. **New Module 5 directory name**
   - What we know: current pattern is `module-NN-slug/`; existing slugs are descriptive
   - What's unclear: should the new directory be `module-05-superpowers-iac/` or `module-05-structured-iac/` or something else?
   - Recommendation: Use `module-05-superpowers-iac/` — "superpowers" is the unique differentiator vs the old 5a content

2. **New Module 6 directory name**
   - What we know: content is unchanged (D-07); was `module-05b-ai-workflows/`
   - What's unclear: should it be `module-06-ai-workflow-tools/` or `module-06-ai-workflows/`?
   - Recommendation: `module-06-ai-workflow-tools/` — matches the REQUIREMENTS.md name "AI Workflow Tools"

3. **Fate of `module-06-ai-iac/lab/solution/` after directory deletion**
   - What we know: Terraform solution files are referenced in Track B for comparison (D-13)
   - What's unclear: Should the solution files move into new Module 5, or be referenced from a `solutions/` directory at repo root?
   - Recommendation: Move to `module-05-superpowers-iac/lab/solution/terraform/` and `module-05-superpowers-iac/lab/solution/helm/` — keeps solution files co-located with the module that uses them

4. **Helm solution files — do they exist?**
   - What we know: Track A builds a Helm chart; D-13 says solution files remain for comparison
   - What's unclear: There is no solution Helm chart in the existing Module 5a or Module 6 — only the baseline chart in `reference-app/helm/`
   - Recommendation: The baseline chart IS the "before." The "solution" is the baseline chart plus the AI-generated additions (HPA, PDB, ServiceMonitor, NOTES.txt). Author a solution `values.yaml` and template files for comparison.

---

## Sources

### Primary (HIGH confidence)
- Direct file inspection — all `module-05a-structured-coding/`, `module-05b-ai-workflows/`, `module-06-ai-iac/` files read
- Direct file inspection — `~/.claude/superpowers/tdd.md`, `debugging.md`, `code-review.md`, `verification.md` read
- Direct file inspection — `reference-app/helm/reference-app/` Chart.yaml, values.yaml, templates/ listing
- Direct file inspection — `module-06-ai-iac/lab/solution/terraform/tests/unit.tftest.hcl` — verified mock_provider pattern
- Direct tool version check — `helm version`, `terraform version`, `kind --version`, `kubectl` present/absent

### Secondary (MEDIUM confidence)
- `course-site/docs/intro.mdx` — confirmed Module table structure and all cross-reference links
- `course-site/sidebars.ts` — confirmed autogenerated sidebar, no manual entries
- `course-site/docs/module-05b-ai-workflows/quiz/QUIZ.mdx` — confirmed broken link to `module-06-iac/` (pre-existing)

### Tertiary (LOW confidence)
- Helm unittest plugin: `https://github.com/helm-unittest/helm-unittest` — verified by name but not locally installed; install path assumed standard

---

## Metadata

**Confidence breakdown:**
- Cross-reference audit: HIGH — complete grep of all MDX files, all links identified
- Superpowers workflow definitions: HIGH — read directly from source files
- TDD tooling for Helm: HIGH — helm available, lint/dry-run pattern already in codebase
- TDD tooling for Terraform: HIGH — terraform validate confirmed; mock_provider pattern in existing solution
- Docusaurus rename pattern: HIGH — sidebars.ts confirms autogenerated; _category_.json pattern confirmed
- Terraform version gap: HIGH — v1.4.6 confirmed on instructor machine; 1.7 requirement confirmed in CLAUDE.md

**Research date:** 2026-04-07
**Valid until:** 2026-05-07 (stable content domain)
