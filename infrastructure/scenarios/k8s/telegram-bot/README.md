# Telegram Bot → Hermes Agent → Reply in Same Chat

**Phase 8 / TRIG-04** — A real Telegram bot connected to Hermes via the existing `gateway/platforms/telegram.py` adapter. Participants send slash commands from Telegram and receive agent responses in the same chat thread.

## Why Telegram (not Slack)

Telegram is the right primary chat platform for the course because:

- **Free, no admin approval, no workspace.** Anyone with a Telegram account can create a bot via @BotFather in 2 minutes.
- **Works for solo learners.** Slack requires workspace admin to add a bot — that's a hard blocker for Udemy participants who don't have admin in their org's workspace.
- **Long-polling out of the box.** No public HTTPS URL needed. Works behind NAT and firewalls (correct for laptops).
- **Hermes adapter exists.** `gateway/platforms/telegram.py` (2145 lines) ships with full slash command support, message threading, and 4096-char auto-splitting.

Slack is documented as a production reference (not hands-on) — see Module 12 lab Step 8 (existing) for the Slack overview.

## Files

- `README.md` — This file
- `bot-config.example.yaml` — Bot configuration example using env var references (NEVER commit real tokens)
- `admin-allowlist.example.yaml` — Admin user allowlist YAML for governance escalation
- `slash-command-spec.md` — Spec for the three commands (`/diagnose`, `/status`, `/help`) with per-track examples

## Prerequisites

- **Telegram account** — install Telegram on your phone or open https://web.telegram.org
- **Hermes installed with `[messaging]` extra** — `pip install -e ".[all]"` or `pip install -e ".[messaging]"`. Verify: `python3 -c "from telegram import Bot; print('telegram OK')"`
- **Hermes gateway** — `hermes gateway run` or `hermes gateway install`

## Get a bot token from @BotFather

1. Open Telegram → search for **@BotFather** (the official bot creation bot — has a verified blue checkmark)
2. Send `/start` to get the introduction
3. Send `/newbot`
4. Choose a display name (e.g., `Hermes Lab Bot` for your account)
5. Choose a username — must end in `bot` (e.g., `hermes_lab_yourname_bot`)
6. BotFather responds with: "Done! Congratulations on your new bot." and the **token** — looks like `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`
7. Copy the token. Treat it like a password — anyone with this token can impersonate your bot.

## Get your own Telegram user ID (for the admin allowlist)

The Telegram adapter restricts bot interactions to user IDs listed in `TELEGRAM_ALLOWED_USERS`. To find your own user ID:

1. In Telegram, search for **@userinfobot** (a public utility bot)
2. Send `/start`
3. The bot replies with your numeric user ID (e.g., `987654321`)
4. Copy this number — you'll set it as `TELEGRAM_ALLOWED_USERS`

**Why restrict?** Without `TELEGRAM_ALLOWED_USERS` set, anyone who finds your bot username can issue commands. Restricting to your own user ID makes the bot a personal assistant.

## Configure Hermes gateway

Add to `~/.hermes/.env` (gitignored):

```bash
TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_ALLOWED_USERS=987654321
TELEGRAM_HOME_CHANNEL=987654321   # Same as user ID for private bot, or chat ID for group
```

**Or** export them inline before running the gateway:

```bash
export TELEGRAM_BOT_TOKEN="123456:ABC..."
export TELEGRAM_ALLOWED_USERS="987654321"
hermes gateway run
```

> **Security note:** Never commit `~/.hermes/.env` or any file containing a real bot token. Add `~/.hermes/` and `.hermes/` to your `.gitignore`. If you accidentally commit a token, revoke it via @BotFather immediately: send `/mybots` → select your bot → API Token → Revoke current token.

## Start the gateway

```bash
hermes gateway run
```

Look for the line "Telegram adapter started, polling..." in the gateway output. If you see "telegram_polling_conflict", another gateway instance is already polling — stop it first (`hermes gateway stop`, wait 30 seconds, retry).

> **WARNING: Long-polling conflict.** The Telegram adapter uses long polling. Only ONE gateway instance can poll with a given token at a time. If you previously ran `hermes gateway run` in another terminal, stop it first with `hermes gateway stop` and wait 30 seconds before starting a new instance, or you'll get 409 Conflict errors (`telegram_polling_conflict` fatal error after 3 retries). This is a Telegram API restriction, not a Hermes bug.

## Test in Telegram

1. In Telegram, search for your bot's username (the one you chose with @BotFather)
2. Open the chat and send: `/help`
3. The bot replies with the command list (driven by your agent's prompt — see slash-command-spec.md)
4. Send: `/diagnose <argument>` (use a track-appropriate argument — see slash-command-spec.md per-track examples)
5. The bot runs the diagnostic agent and replies in the same chat thread

## Slash command behavior

The Telegram adapter's `_handle_command` method (line 1549 of `gateway/platforms/telegram.py`) handles ALL slash commands by passing the full message text (including the `/` and arguments) through to the agent as the prompt. The agent's SOUL.md and skills determine the response — there is no per-command Python registration needed.

This means **any** slash command works, not just the three documented in slash-command-spec.md. The three documented commands are just the conventional set the course teaches.

## Message length limit (4096 chars)

Telegram enforces a 4096-character limit per message. The Hermes adapter (`TelegramAdapter.MAX_MESSAGE_LENGTH = 4096`) automatically splits longer agent responses into multiple messages. If you want more control, configure your agent's skill prompt to keep responses concise (under 2000 chars). Long kubectl/SQL output blocks are the most common cause of truncation.

## Governance

The bot inherits `HERMES_LAB_GOVERNANCE` from the gateway process environment (per CONTEXT.md D-02 and D-19). To run the bot at L4:

```bash
export HERMES_LAB_GOVERNANCE=L4
export HERMES_LAB_TRACK=track-c
export TELEGRAM_BOT_TOKEN="..."
export TELEGRAM_ALLOWED_USERS="..."
hermes gateway run
```

The Phase 7 wrappers (`infrastructure/wrappers/mock-kubectl`, etc.) read these env vars when the agent invokes them. A Telegram-triggered agent at L2 cannot run `kubectl delete` for the same reason an interactive L2 agent cannot.

**Per-command governance escalation** (D-19): governance is per-process, not per-message. To escalate, the operator must restart the gateway with a higher `HERMES_LAB_GOVERNANCE` env var. The `TELEGRAM_ALLOWED_USERS` allowlist serves as the "admin user" gate — only listed users can interact with the bot at all.

## Common pitfalls

| Pitfall | Symptom | Fix |
|---|---|---|
| Polling conflict | `telegram_polling_conflict` fatal error after 3 retries | Run `hermes gateway stop`, wait 30 seconds, retry. Telegram holds the long-poll session for ~30s after disconnect. |
| Bot doesn't respond | Bot is online but silent | Check `TELEGRAM_ALLOWED_USERS` includes your user ID (from @userinfobot). Bot ignores users not in this list. |
| Token leaked | Random commands appearing from unknown user IDs | Revoke and regenerate via @BotFather: `/revoke` → select bot. Update env var. |
| 4096 char limit | Agent's reply gets truncated | Adapter auto-splits at 4096. Long replies arrive as multiple messages. Reduce verbosity in skill prompt. |
| Token committed to git | GitHub secret-scanning emails you | `git rm --cached ~/.hermes/.env` → revoke token via @BotFather → regenerate → add `.hermes/` to `.gitignore` |
| Missing [messaging] extra | `ModuleNotFoundError: No module named 'telegram'` | `pip install -e ".[messaging]"` or `pip install -e ".[all]"` |

## Cleanup

```bash
# Stop the gateway
hermes gateway stop

# Optionally revoke the bot token (in @BotFather)
# /mybots → select bot → Revoke current token

# Or delete the bot entirely
# /mybots → select bot → Delete bot → confirm
```
