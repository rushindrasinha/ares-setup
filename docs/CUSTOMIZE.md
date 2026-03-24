# Customizing Your Instance

After running `install.sh`, your identity files land at `~/.openclaw/workspace/`.  
Edit these three files before running onboarding:

## The Three Files

### SOUL.md
Your AI's personality, values, and operating rules.  
Replace `[AI_NAME]`, `[OWNER_NAME]`, `[TIMEZONE]` and add any domain-specific rules.

### AGENTS.md
Workspace behaviour — session startup, memory rules, red lines.  
Add instance-specific execution rules at the bottom.

### TOOLS.md
Environment-specific notes — SSH aliases, camera names, device nicknames, TTS preferences.  
Fill in as you configure the instance. Nothing goes here until you know what's on the machine.

---

## Run Onboarding

Once you've edited the identity files:

```bash
openclaw onboard --install-daemon
```

This installs the Gateway as a launchd service (stays running after reboot),  
walks you through API key setup, and links your messaging channel.

---

## Link a Messaging Channel

During onboarding or after:

```bash
# WhatsApp
openclaw channels login

# Or follow the interactive onboarding prompts
```

---

## Verify

```bash
openclaw gateway status
```

Send `/status` on your linked channel — the agent should respond.

---

## Adding a New Instance Later

1. Copy `instances/_template/` to `instances/[name]/`
2. Fill in the placeholders
3. Run `install.sh` on the new machine
4. Edit `~/.openclaw/workspace/` files on that machine
5. `openclaw onboard --install-daemon`
