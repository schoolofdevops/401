# GitHub Webhook → Hermes Agent → PR Comment

**Phase 8 / TRIG-03** — A real GitHub webhook fires on PR events, smee.io relays the event to a local Hermes gateway, the agent reviews the PR, and posts a comment back via `gh pr comment`.

## Why smee.io

GitHub webhooks need a public HTTPS endpoint to POST to. Your laptop running Hermes on localhost:8644 is not public. **smee.io** is the Probot team's free public webhook proxy: you get a unique channel URL, GitHub POSTs to that URL, and a smee-client running on your laptop forwards events to your local gateway.

No account, no credit card, no ngrok session timeout. Sessionless and stable.

## Files

- `README.md` — This file
- `smee-setup.sh` — Helper script that runs `npx smee-client` with the correct target URL
- `sample-pr-payload.json` — A valid GitHub PR webhook payload for the Solo Learner fallback (`hermes webhook test github --payload @sample-pr-payload.json`)
- `agent-prompt-template.txt` — Reference prompt showing dot-notation field interpolation

## Prerequisites

- **gh CLI** installed and authenticated. Test: `gh auth status`. If missing: `brew install gh` (macOS) or `https://cli.github.com/`.
- **GitHub Personal Access Token (classic) with `repo` scope.** Or fine-grained PAT with "Pull requests: Read and Write" on the target repo. See "Get a GitHub PAT" section below.
- **Node.js + npm.** Verify: `node --version && npm --version`. Required for `npx smee-client`.
- **Hermes gateway running.** `hermes gateway run` in a separate terminal.
- **A test repo** you control. Can be a public personal sandbox repo.

## Get a GitHub PAT

1. Open https://github.com/settings/tokens (Personal access tokens → Tokens (classic))
2. Click "Generate new token" → "Generate new token (classic)"
3. Note: `hermes-lab-trig03`
4. Expiration: 30 days (course window)
5. Scopes: check **`repo`** (this includes read+write to PRs and comments)
6. Click "Generate token"
7. Copy the `ghp_...` value into `~/.hermes/.env` or export it:
   ```bash
   export GITHUB_TOKEN="ghp_..."
   gh auth login --with-token <<< "$GITHUB_TOKEN"
   gh auth status   # Should show "Logged in to github.com as <you>"
   ```

**Why classic PAT instead of fine-grained?** Both work, but classic with `repo` scope is the simplest path for the lab. Fine-grained PATs require selecting the specific repo AND choosing the "Pull requests: Read and Write" permission, which has tripped up participants in the past (see 08-RESEARCH.md Pitfall 7).

## Setup walkthrough — primary path

```bash
# 1. Get a smee.io channel URL
#    Visit https://smee.io/
#    Click "Start a new channel"
#    Copy the URL — looks like https://smee.io/abc123XYZ

export SMEE_URL="https://smee.io/abc123XYZ"   # Replace with your channel
export GITHUB_TOKEN="ghp_..."                  # Your PAT from above

# 2. Run smee-client to forward events from smee.io to your local gateway
./infrastructure/scenarios/k8s/github-webhook/smee-setup.sh
# (This is a foreground process — leave it running in this terminal.)

# 3. In a NEW terminal — start the Hermes gateway
hermes gateway run

# 4. In a THIRD terminal — subscribe the GitHub webhook
hermes webhook subscribe github \
  --events "pull_request" \
  --prompt "$(cat infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt)" \
  --deliver github_comment \
  --deliver-chat-id "{repository.full_name}:{pull_request.number}"

# 5. Add the smee.io URL as a webhook on your test GitHub repo:
#    Repo Settings → Webhooks → Add webhook
#      Payload URL:    $SMEE_URL  (the smee.io channel URL)
#      Content type:   application/json
#      Secret:         (leave blank for the lab)
#      Events:         "Let me select individual events" → Pull requests
#      Active:         checked
#    → Add webhook

# 6. Trigger an event
#    Open a PR on your test repo (or push a commit to a branch with an open PR)

# 7. Watch the flow
#    smee terminal: "Forwarding event to localhost:8644/webhooks/github"
#    gateway terminal: "Received github webhook event"
#    The agent runs, drafts a comment, and gh CLI posts it to the PR

# 8. Cleanup
#    On the GitHub repo: Settings → Webhooks → delete the smee URL webhook
#    Hit Ctrl+C in the smee terminal
#    Hit Ctrl+C in the gateway terminal
```

## Solo Learner fallback (no GitHub repo, no smee.io)

If you don't have a personal repo to attach a webhook to (or you're working through this lab on a laptop without external network access), use the Solo Learner fallback:

```bash
# 1. Start the gateway
hermes gateway run

# 2. Subscribe the webhook
hermes webhook subscribe github \
  --events "pull_request" \
  --prompt "$(cat infrastructure/scenarios/k8s/github-webhook/agent-prompt-template.txt)" \
  --deliver local

#    Note: --deliver local instead of --deliver github_comment.
#    The agent's review goes to your terminal, not back to GitHub.

# 3. Inject a synthetic event using the bundled sample payload
hermes webhook test github \
  --payload @infrastructure/scenarios/k8s/github-webhook/sample-pr-payload.json

# 4. Watch the agent run in the gateway terminal
```

This fallback mirrors what real GitHub events look like (the JSON payload is a real GitHub PR webhook structure) but doesn't require any external service.

## Why `--deliver github_comment` instead of `curl`

Hermes webhook adapter (`gateway/platforms/webhook.py` lines 525-558) ships a built-in `github_comment` delivery type that internally calls `gh pr comment`. You don't write any HTTP code, you don't manage retries, you don't parse the response. The trade-off: you must have `gh` CLI installed and authenticated.

## Common pitfalls

| Pitfall | Symptom | Fix |
|---|---|---|
| smee target URL mismatch | smee logs "Forwarding to localhost:8644/webhooks/github" but gateway never receives | Make sure your `hermes webhook subscribe` name matches the route — name `github` → route `/webhooks/github` |
| Fine-grained PAT scope too narrow | `gh pr comment` returns 403 Unauthorized | Use classic PAT with `repo` scope OR fine-grained with "Pull requests: Read and Write" |
| smee-client not installed | `npx smee-client` hangs forever or "command not found" | `npx smee-client@5.0.0 --help` to verify, install Node.js if missing |
| GitHub webhook secret mismatch | Hermes returns 401 on POST | Either set the webhook secret to match `HERMES_WEBHOOK_SECRET` env var OR leave both empty for lab |

## Cleanup

```bash
hermes webhook unsubscribe github
# Stop smee-setup.sh process (Ctrl+C in the terminal where it runs)
# Stop gateway (Ctrl+C in the gateway terminal)
# On GitHub repo: Settings → Webhooks → delete the smee URL entry
```
