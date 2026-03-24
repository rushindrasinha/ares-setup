# ares-setup

> One-line Mac setup for [OpenClaw](https://openclaw.ai) instances.

Inspired by [thoughtbot/laptop](https://github.com/thoughtbot/laptop). Installs a clean, reproducible foundation for running an OpenClaw AI agent on any Mac — no secrets, no identity baked in. Customize per device after install.

---

## Quick Start

Open Terminal on a fresh Mac and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
```

Takes ~5 minutes. Grab a coffee.

---

## What It Installs

| Tool | Purpose |
|------|---------|
| Homebrew | Mac package manager |
| Node 24 | Runtime for OpenClaw |
| Python 3 | Scripting + automation |
| OpenClaw | AI agent platform |
| uv | Fast Python runner |
| Git, jq, wget | Core utilities |
| ffmpeg, imagemagick, poppler | Media processing |
| gh | GitHub CLI |
| Python packages | requests, reportlab, pillow, google-auth, openai, anthropic, and more |

**Zero API keys. Zero identity. Zero secrets.**

---

## After Install

```
1. Restart terminal                 →  source ~/.zshrc
2. Edit identity files              →  ~/.openclaw/workspace/
   - SOUL.md    ← AI personality + rules
   - AGENTS.md  ← Workspace behaviour
   - TOOLS.md   ← Environment-specific notes
3. Run onboarding                   →  openclaw onboard --install-daemon
```

Full customization guide: [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)  
OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)

---

## Workspace

OpenClaw's workspace lives at `~/.openclaw/workspace/` (configurable via `agents.defaults.workspace`).  
The three injected identity files are `SOUL.md`, `AGENTS.md`, and `TOOLS.md`.

---

## Identity Templates

Blank identity files in `instances/_template/`:

```
instances/
  _template/
    SOUL.md      ← AI personality, values, operating rules
    AGENTS.md    ← Session startup, memory rules, red lines
    TOOLS.md     ← Environment-specific notes (SSH, cameras, TTS, etc.)
```

---

## Adding a New Instance

1. Copy `instances/_template/` → `instances/[name]/`
2. Fill in all `[PLACEHOLDER]` values
3. Run `install.sh` on the new Mac
4. Copy your instance files to `~/.openclaw/workspace/`
5. `openclaw onboard --install-daemon`

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

---

## License

MIT
