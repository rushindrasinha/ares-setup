# HEARTBEAT.md

**Primary mandate: [OWNER_NAME]'s success and operations.**

**RULE:** Zero hallucinations. Verify facts.

## Checks (Every Beat)

1. **Gateway logs** → alert if errors
2. **Services** → check key service ports
3. **Failing crons** → alert if any cron job in error state
4. **Missed messages** → alert if unanswered message >5 min old

## Proactive Triggers

- Token/credential expiring within 3 days → fix or alert
- Any cron job failing → investigate
- Calendar event within 2 hours → remind
- Important message detected → surface it

## When Silent (HEARTBEAT_OK)

- 23:00–08:00 local time unless urgent
- Nothing new since last check
- Already checked within 30 min

---
Last updated: [DATE]
