# ares-setup

> One-line Mac setup for OpenClaw AI instances.

Inspired by [thoughtbot/laptop](https://github.com/thoughtbot/laptop). Installs a clean, reproducible foundation for running an OpenClaw-powered AI agent on any Mac — no secrets, no identity baked in. Customize per device after install.

---

## Quick Start

Open Terminal on a fresh Mac and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
```

That's it. Grab a coffee. Takes ~5 minutes.

---

## What It Installs

| Tool | Purpose |
|------|---------|
| Homebrew | Mac package manager |
| Node 22+ | Runtime for OpenClaw |
| Python 3 | Scripting + automation |
| OpenClaw | AI agent platform |
| uv | Fast Python runner |
| Git, jq, wget | Core utilities |
| ffmpeg, imagemagick | Media processing |
| gh | GitHub CLI |
| Python packages | requests, reportlab, pillow, google-auth, openai, anthropic, and more |

**Zero API keys. Zero identity. Zero secrets.**  
Everything above is safe to install on any machine.

---

## After Install

```
1. Restart terminal        →  source ~/.zshrc
2. Edit identity files     →  ~/clawd/   (SOUL.md, USER.md, IDENTITY.md, MEMORY.md)
3. Configure API key       →  openclaw setup
4. Link WhatsApp           →  openclaw link whatsapp
5. Start the agent         →  openclaw gateway start
```

Full customization guide: [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)

---

## Directory Structure Created

```
~/clawd/                        ← agent workspace
  memory/                       ← daily session logs
  scripts/                      ← automation scripts
  vault/                        ← secrets (local only, never committed)
  docs/                         ← documentation
  brain/                        ← working memory

~/Desktop/Ares/
  media/openclaw_media/         ← WhatsApp media output
  media/archives/               ← data archives
  scripts/                      ← ops scripts
  memory/                       ← domain memory files
  docs/                         ← full docs

~/.learnings/                   ← ERRORS, LEARNINGS, DECISIONS, REGRESSIONS logs
~/.config/ares/google/          ← Google OAuth credentials
```

---

## Identity Templates

Blank identity files live in `instances/_template/`.  
Copy, fill in the placeholders, drop into `~/clawd/` on the target machine.

```
instances/
  _template/
    SOUL.md        ← AI personality + operating rules
    IDENTITY.md    ← Name, vibe, emoji
    USER.md        ← Owner name, timezone, role
    MEMORY.md      ← Long-term memory index
    AGENTS.md      ← Execution doctrine
    HEARTBEAT.md   ← Background monitoring rules
    COMMANDS.md    ← Slash command reference
```

---

## Adding a New Instance

1. Copy `instances/_template/` → `instances/[name]/`
2. Fill in all `[PLACEHOLDER]` values
3. Run `install.sh` on the new Mac
4. Copy your instance files to `~/clawd/`
5. `openclaw setup` → `openclaw link whatsapp` → `openclaw gateway start`

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

---

## License

MIT
