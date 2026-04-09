# Mock Wrapper Scripts -- Deprecated

**Status:** Deprecated as of Phase 10 (v1.1 Labs Refactor)

This directory contains the wrapper scripts used for mock-mode labs in earlier course iterations:
- `mock-kubectl` -- Intercepted kubectl calls and returned pre-baked JSON responses
- `mock-aws` -- Intercepted aws CLI calls and returned mock AWS API responses
- `mock-psql` -- Intercepted PostgreSQL CLI calls

## Why Deprecated?

Starting in v1.1, all Track C (Kubernetes) labs use a real KIND cluster instead of mock fixtures. This eliminates:
- Environment variable complexity (HERMES_LAB_MODE, HERMES_LAB_SCENARIO, etc.)
- Wrapper script PATH manipulation
- Mock data maintenance burden
- "Is this real or simulated?" cognitive overhead

## Why Keep These Files?

These scripts are retained for:
- **Historical reference** -- Understanding how mock-mode was implemented
- **Potential rollback** -- If a future release needs mock mode again
- **Troubleshooting** -- Examining wrapper behavior if needed

## Current Usage in Course Labs

**None.** No current course labs depend on these wrapper scripts. Learners use real KIND clusters directly.

If you're building a new feature that needs mocking, consult these scripts as a reference, but do not activate them in the critical path.

## Related

- See `.planning/analysis_labs_7_8_10_revision.md` for the full mock-mode removal analysis
- See `infrastructure/mock-data/README.md` for mock data deprecation notice
