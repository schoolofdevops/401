# Progressive Context Engineering — Expected Comparison

This is a reference showing typical output quality at each layer.
Your exact results will vary by model and phrasing.

| Aspect | Layer 1 (Bare) | Layer 2 (Role) | Layer 3 (Topology) | Layer 4 (Runbook) |
|--------|---------------|----------------|-------------------|-------------------|
| Severity assessment | "Might be serious" | "High — production impact" | "Critical — 50K users affected, 27% above baseline" | "P1 — catalog-api serving 50K users, escalation in 15 min" |
| Specific to your infra? | No — generic EC2 | No — generic SRE | Yes — names instances, services | Yes — uses your runbook steps |
| Mentions 60-65% baseline? | No | No | Yes — calculates deviation | Yes — uses in decision tree |
| Actionable next steps? | "Check metrics" | "Investigate CPU, check scaling" | "Check ALB traffic, check RDS connections" | "Step 1: ALB RequestCount, Step 2: SSM top, Step 3: CodeDeploy history" |
| Mentions cache or database? | No | Maybe (generic) | Yes — RDS + ElastiCache | Yes — cache hit rate check at step 4 |
| Correlation analysis? | No | Minimal | Yes — connects services | Yes — decision tree for each cause |
| Would you trust at 3am? | No | Maybe for triage | For investigation, yes | For full response, yes |

## Key Insight

The biggest quality jump is Layer 2 → Layer 3 (adding infrastructure topology).
This is where the response shifts from "generic best practices" to "specific to YOUR system."

Layer 3 → Layer 4 adds procedural rigor (following YOUR runbook), but Layer 3 is the
inflection point where the cost-quality tradeoff pays off most clearly.
