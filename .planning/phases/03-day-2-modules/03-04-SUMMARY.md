---
phase: 03-day-2-modules
plan: "04"
subsystem: course-content
tags: [terraform, argocd, gitops, kubernetes, cloudwatch, sns, helm, kind, module-06, iac]

requires:
  - phase: 03-day-2-modules
    provides: Docusaurus site at course-site/ and reference app Helm chart at reference-app/helm/

provides:
  - Module 6 Docusaurus scaffolding (_category_.json at position 7, README.mdx)
  - Track A Terraform lab (LAB-track-a-terraform.mdx) with 5 guided generation steps
  - Track A starter files: ec2-monitored module skeleton (main.tf TODO, partial variables.tf, empty outputs.tf, complete versions.tf >= 1.7)
  - Track A starter environment: environments/lab/main.tf + terraform.tfvars
  - Track A solution files: complete ec2-monitored module (aws_instance t2.micro + aws_cloudwatch_metric_alarm + aws_sns_topic + aws_sns_topic_subscription + aws_ami data source)
  - Track A solution tests/unit.tftest.hcl with mock_provider "aws" (no AWS credentials required)
  - Track B ArgoCD GitOps lab (LAB-track-b-gitops.mdx) with 7 guided steps
  - Track B starter: argocd-app.yaml skeleton with TODO comments, setup-argocd.sh install script with 256Mi/512Mi memory patches
  - Track B solution: complete argocd-app.yaml (syncPolicy automated prune+selfHeal, CreateNamespace=true), values-override.yaml for push-to-sync demo

affects:
  - Module 9 (design patterns) — ArgoCD GitOps pattern taught here
  - Module 10 (domain agents) — Terraform and IaC context engineering pattern established here
  - Hermes repo modules 7-8 — SKILL.md authoring builds on guided generation pattern

tech-stack:
  added:
    - Terraform 1.7+ (mock_provider for unit tests without AWS credentials)
    - ArgoCD v3.x (stable manifests install on KIND)
    - HCL (Terraform module: aws_instance, aws_cloudwatch_metric_alarm, aws_sns_topic, aws_sns_topic_subscription)
    - ArgoCD Application CRD (syncPolicy automated prune+selfHeal)
  patterns:
    - Guided generation pattern: CLAUDE.md context first, then step-by-step AI prompts with explicit resource types
    - Starter skeleton pattern: TODO comments + partial files as machine-readable AI input context
    - mock_provider pattern: terraform test without AWS credentials for CI/CD unit testing
    - Memory patch pattern: kubectl patch deployments immediately after ArgoCD install (pitfall 2 prevention)
    - GitOps demo pattern: push-to-sync with apiGateway.replicaCount change as teaching moment

key-files:
  created:
    - course-site/docs/module-06-ai-iac/_category_.json
    - course-site/docs/module-06-ai-iac/README.mdx
    - course-site/docs/module-06-ai-iac/lab/_category_.json
    - course-site/docs/module-06-ai-iac/lab/LAB-track-a-terraform.mdx
    - course-site/docs/module-06-ai-iac/lab/LAB-track-b-gitops.mdx
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/main.tf
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/variables.tf
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/outputs.tf
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/versions.tf
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/environments/lab/main.tf
    - course-site/docs/module-06-ai-iac/lab/starter/terraform/environments/lab/terraform.tfvars
    - course-site/docs/module-06-ai-iac/lab/starter/gitops/argocd-app.yaml
    - course-site/docs/module-06-ai-iac/lab/starter/gitops/setup-argocd.sh
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/main.tf
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/variables.tf
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/outputs.tf
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/versions.tf
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/environments/lab/main.tf
    - course-site/docs/module-06-ai-iac/lab/solution/terraform/tests/unit.tftest.hcl
    - course-site/docs/module-06-ai-iac/lab/solution/gitops/argocd-app.yaml
    - course-site/docs/module-06-ai-iac/lab/solution/gitops/values-override.yaml
  modified: []

key-decisions:
  - "D-41 honored: No Track C (Argo Workflows) content exists — README.mdx mentions descoping explicitly by name"
  - "D-42 honored: Track A is EC2 + CloudWatch + SNS only — RDS excluded, free-tier constraint documented in CLAUDE.md template and lab steps"
  - "D-43 honored: ArgoCD restored for Track B — correct tool for teaching GitOps hands-on"
  - "D-45 honored: Guided generation pattern applied — every generation step has explicit context prompt and comparison to solution"
  - "D-46 honored: Expected result blocks at every step — 7 in Track A, 8 in Track B (15 total, exceeds 12+ requirement)"
  - "mock_provider chosen over LocalStack for Track A fallback — LocalStack community EOL March 2026, mock_provider built into Terraform 1.7+"
  - "Memory patches mandatory in setup-argocd.sh, not optional — pitfall 2 prevention, prevents OOM eviction on 8GB laptops"
  - "GitHub fork prerequisite made mandatory/prominent in Track B — pitfall 3 prevention, local file paths will fail ArgoCD"

patterns-established:
  - "CLAUDE.md-first pattern: Create project CLAUDE.md before any AI generation — established in both tracks as Step 2"
  - "Skeleton starter pattern: TODO comments as AI generation hooks, not empty files"
  - "4-resource module pattern for Track A: data source + aws_instance + aws_cloudwatch_metric_alarm + aws_sns_topic + aws_sns_topic_subscription"

requirements-completed: [MOD6-01, MOD6-02, MOD6-04]

duration: 17min
completed: 2026-04-04
---

# Phase 3 Plan 04: Module 6 AI-Assisted IaC Summary

**Module 6 complete: Terraform module for EC2 + CloudWatch + SNS (Track A) and ArgoCD GitOps deployment on KIND (Track B), both with guided context engineering, starter skeletons, complete solutions, and mock/offline fallbacks**

## Performance

- **Duration:** 17 minutes
- **Started:** 2026-04-04T20:01:48Z
- **Completed:** 2026-04-04T20:19:00Z
- **Tasks:** 2 of 2
- **Files modified:** 21 created, 0 modified

## Accomplishments

- Module 6 Docusaurus scaffolding with two-track structure (position 7, _category_.json, README.mdx explaining the guided generation approach)
- Track A: Complete Terraform lab (5 guided steps, EC2 + CloudWatch + SNS, starter skeleton, solution with validation, mock_provider tests for offline path)
- Track B: Complete ArgoCD GitOps lab (7 guided steps, APPLICATION CRD generation, memory-patched install script, push-to-sync demo with api-gateway scale change)
- 15 "Expected result" blocks across both labs (7 Track A + 8 Track B), exceeding the 12+ requirement

## Task Commits

Each task was committed atomically:

1. **Task 1: Module 6 scaffolding + Track A Terraform lab** - `c2d0fb8` (feat)
2. **Task 2: Track B ArgoCD GitOps lab** - `cfe1797` (feat)

**Plan metadata:** *(final commit — see below)*

## Files Created/Modified

- `course-site/docs/module-06-ai-iac/_category_.json` — Docusaurus category config at position 7
- `course-site/docs/module-06-ai-iac/README.mdx` — Module overview, track selection guide, context engineering teaching framing
- `course-site/docs/module-06-ai-iac/lab/_category_.json` — Lab section label
- `course-site/docs/module-06-ai-iac/lab/LAB-track-a-terraform.mdx` — Track A lab: 5 guided steps, mock fallback in collapsible details
- `course-site/docs/module-06-ai-iac/lab/LAB-track-b-gitops.mdx` — Track B lab: 7 guided steps, fork prerequisite, push-to-sync demo
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/main.tf` — Skeleton with TODO comments
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/variables.tf` — Partial (instance_name defined, 3 TODOs)
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/outputs.tf` — Empty with TODO comments
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/modules/ec2-monitored/versions.tf` — Complete: >= 1.7, AWS >= 5.0
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/environments/lab/main.tf` — Module call + variable declarations
- `course-site/docs/module-06-ai-iac/lab/starter/terraform/environments/lab/terraform.tfvars` — Example values
- `course-site/docs/module-06-ai-iac/lab/starter/gitops/argocd-app.yaml` — Skeleton CRD with 5 TODO markers
- `course-site/docs/module-06-ai-iac/lab/starter/gitops/setup-argocd.sh` — Complete install script with 256Mi/512Mi memory patches
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/main.tf` — Complete: data source + 4 resources + tags
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/variables.tf` — All 4 vars with validation
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/outputs.tf` — All 4 outputs
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/modules/ec2-monitored/versions.tf` — Same as starter
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/environments/lab/main.tf` — Module call + outputs
- `course-site/docs/module-06-ai-iac/lab/solution/terraform/tests/unit.tftest.hcl` — mock_provider with 3 assertions
- `course-site/docs/module-06-ai-iac/lab/solution/gitops/argocd-app.yaml` — Complete CRD with syncPolicy automated
- `course-site/docs/module-06-ai-iac/lab/solution/gitops/values-override.yaml` — api-gateway replicaCount: 2 for demo

## Decisions Made

- D-41 honored: Argo Workflows descoped — README.mdx explicitly names the descoping with rationale
- D-42 honored: Track A is EC2 + CloudWatch + SNS only, RDS excluded per free-tier simplicity decision
- D-43 honored: ArgoCD restored for Track B — the one place GitOps tooling is taught hands-on
- mock_provider chosen over LocalStack: LocalStack community edition EOL'd March 2026, mock_provider is built into Terraform 1.7+
- Memory patches mandatory in setup-argocd.sh: pitfall 2 from research — standard ArgoCD install requests 1.3GB total, causes OOM on laptop KIND clusters
- GitHub fork prerequisite made step 0 in Track B: pitfall 3 from research — ArgoCD cannot sync from local filesystem

## Deviations from Plan

None — plan executed exactly as written. All acceptance criteria met:
- Track A: 7 Expected result blocks (required 6+), starter has TODO comments, solution has aws_cloudwatch_metric_alarm and t2.micro, tests have mock_provider, _category_.json has "Module 6", README mentions Track A and Track B but not Track C
- Track B: 8 Expected result blocks (required 6+), ArgoCD count 46 (required 5+), GitOps count 14 (required 3+), no "Argo Workflows" in lab, starter has TODO, solution has syncPolicy and automated, setup script has kubectl apply and 256Mi, values-override.yaml exists, fork mentioned 11 times

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Self-Check: PASSED

All 12 key files verified present on disk. Both task commits (c2d0fb8, cfe1797) confirmed in git log.

## Next Phase Readiness

- Module 6 complete: Track A and Track B labs with full starter/solution file trees
- Combined "Expected result" count: 15 (Track A: 7, Track B: 8) — exceeds 12+ success criterion
- No Track C content exists anywhere per D-41
- Ready for Phase 3 remaining plans (Module 5a, 5b, reading materials, quizzes)

---
*Phase: 03-day-2-modules*
*Completed: 2026-04-04*
