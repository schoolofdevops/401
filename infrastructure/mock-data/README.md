# Mock Data Fixtures -- Deprecated

**Status:** Deprecated as of Phase 10 (v1.1 Labs Refactor)

This directory contains the mock JSON responses and fixtures used in earlier course iterations:
- `kubernetes/` -- Baked kubectl output (get pods, describe pod, logs, etc.) for 6 failure scenarios
- `aws/` -- Baked AWS API responses for EC2, CloudWatch, etc.
- Other service fixtures

## Why Deprecated?

Starting in v1.1, all Track C (Kubernetes) labs use a real KIND cluster instead of mock fixtures. This means:
- Real kubectl commands return real Kubernetes state
- Learners diagnose actual pod failures they inject themselves
- No divergence between mock and live behavior

## Why Keep These Files?

These fixtures are retained for:
- **Historical reference** -- Understanding what mock data was used
- **Comparison** -- Checking if real Kubernetes API responses match old mocks
- **Troubleshooting** -- Examining mock data structure if debugging wrapper script behavior

## Current Usage in Course Labs

**None.** No current course labs depend on these mock fixtures. Learners use real KIND clusters and real kubectl output.

If you're rebuilding mock-mode support or comparing live vs. mock behavior, consult these files as a reference.

## Related

- See `.planning/analysis_labs_7_8_10_revision.md` for the full mock-mode removal analysis
- See `infrastructure/wrappers/README.md` for wrapper script deprecation notice
- See `infrastructure/scenarios/k8s/` for the actual failure scenario manifests that learners apply
