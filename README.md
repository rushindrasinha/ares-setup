# ares-setup

> One-command Mac setup for [OpenClaw](https://openclaw.ai) AI agent instances.

Inspired by [thoughtbot/laptop](https://github.com/thoughtbot/laptop). Installs a clean, reproducible foundation for running an OpenClaw AI agent on any Mac — no secrets, no identity baked in. Runs in ~5 minutes. Safe to re-run on an existing machine.

---

## Quick Start

Open Terminal on a fresh Mac and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
```

---

## What It Installs

### Tools

| Tool | Purpose |
|------|---------|
| Homebrew | Mac package manager |
| Node 24 | Runtime for OpenClaw |
| Python 3 + venv | Scripting + automation |
| OpenClaw | AI agent platform |
| Claude Code | Agentic coding CLI |
| uv | Fast Python package runner |
| git, jq, wget, gh | Core utilities |
| ffmpeg, imagemagick, poppler | Media processing |
| mas | Mac App Store CLI |
| Amphetamine | Keeps Mac awake (App Store) |

### Python packages (auto-installed into `~/.ares-venv`)

`requests` · `reportlab` · `pillow` · `python-dotenv` · `google-auth` · `google-auth-oauthlib` · `google-api-python-client` · `openai` · `anthropic`

---

## What It Configures

Beyond tool installs, `install.sh` also prepares the machine for headless operation:

| Setting | What it does |
|---------|-------------|
| Hostname | Prompts you to name the machine (e.g. `ares-mini`, `ge-mini`) |
| Display + system sleep | Disabled — machine stays on |
| SSH / Remote Login | Enabled — access from anywhere |
| Screen saver | Disabled |
| Auto-restart | Enabled after power failure |
| GitHub auth | `gh auth login` — needed to clone `ares-stack` |

---

## After Install

```bash
1. Restart terminal             →  source ~/.zshrc
2. Edit identity files          →  ~/.openclaw/workspace/
   - SOUL.md    ← AI personality + operating rules
   - AGENTS.md  ← Session startup, memory rules, red lines
   - TOOLS.md   ← Environment-specific notes (SSH, devices, TTS, etc.)
3. Run onboarding               →  openclaw onboard --install-daemon
4. Link WhatsApp                →  openclaw channels login
5. Clone ares-stack             →  git clone https://github.com/rushindrasinha/ares-stack.git
6. Run your profile             →  cd ares-stack && bash extend.sh --profile base
```

Full customization guide: [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)  
OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)

---

## Workspace

OpenClaw's workspace lives at `~/.openclaw/workspace/` (configurable via `agents.defaults.workspace`).

Three identity files are injected into every agent session:

| File | Purpose |
|------|---------|
| `SOUL.md` | AI personality, values, operating rules |
| `AGENTS.md` | Session startup behaviour, memory rules, red lines |
| `TOOLS.md` | Environment notes — SSH aliases, device names, TTS prefs |

`install.sh` downloads blank templates for all three from `instances/_template/`.

---

## Instance Templates

Pre-built identity files live in `instances/`:

```
instances/
  _template/       ← blank starter — copy this for each new Mac
    SOUL.md
    AGENTS.md
    TOOLS.md
  ge-mini/         ← GE Mini instance (Global Esports)
    SOUL.md
    AGENTS.md
    TOOLS.md
    users.json
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
