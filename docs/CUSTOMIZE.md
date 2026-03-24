# Customizing Your Instance

After running `install.sh`, your identity files are at `~/clawd/`.
Edit these before starting the gateway:

## Required Edits

### IDENTITY.md
- Replace `[AI_NAME]` with your chosen name for this AI

### SOUL.md
- Replace `[AI_NAME]` and `[OWNER_NAME]` throughout
- Add any domain-specific rules (clinical guardrails, brand voice, etc.)

### USER.md
- Fill in owner's name, nickname, timezone, and role

### MEMORY.md
- Add the admin WhatsApp number
- Add any known blockers or context

## API Keys (after editing identity files)

Run `openclaw setup` and enter when prompted:
- Anthropic API key (required)
- OpenAI key (optional)
- ElevenLabs key (optional)

## Link WhatsApp

```bash
openclaw link whatsapp
```
Scan the QR code with the phone number dedicated to this instance.

## Start the Gateway

```bash
openclaw gateway start
openclaw gateway status
```

Send `/status` on WhatsApp to confirm the instance is live.

---

## Adding a New Instance Later

1. Copy `instances/_template/` to `instances/[name]/`
2. Fill in the placeholders
3. Run `install.sh` on the new machine
4. Replace `~/clawd/` files with your customized instance files
