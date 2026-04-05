# Vocabulary Comparison Exercise

Send each prompt below (with the alarm JSON appended) to your AI agent.
Compare the outputs side by side.

---

## Prompt A — Generic IT Vocabulary

Hey, one of our servers is showing high CPU. The alarm says 92%.
What should I do?

[Paste alarm JSON here]

---

## Prompt B — Expert SRE Vocabulary

p99 latency on catalog-api is likely impacted — CPU at 92.3% on i-0abc123def456001,
27 points above our 65% peak baseline. No corresponding ALB RequestCount spike.
Suspect either a runaway process from the 02:30 UTC deployment or ElastiCache
hit rate degradation causing cache-miss storm. Need to confirm causation before
deciding between process kill, deployment rollback, or cache node restart.

[Paste alarm JSON here]

---

## Compare

| Aspect | Prompt A (Generic) | Prompt B (Expert) |
|--------|-------------------|-------------------|
| Specificity of diagnosis | | |
| Mentions baseline deviation | | |
| Considers multiple root causes | | |
| Provides actionable commands | | |
| Recommends escalation path | | |
| Would you trust at 3am? | | |
