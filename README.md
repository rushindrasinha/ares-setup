# ares-setup

> One-command Mac setup for [OpenClaw](https://openclaw.ai) AI agent instances.

Inspired by [thoughtbot/laptop](https://github.com/thoughtbot/laptop). Installs a clean, reproducible foundation for running an OpenClaw AI agent on any Mac — no API keys, no identity, no secrets baked in. Safe to re-run on an existing machine (all installs are idempotent).

**This is step 1 of 2.** After this, run [ares-stack](https://github.com/rushindrasinha/ares-stack) to add skills and profile-specific tools.

---

## Quick Start

Open Terminal on a fresh Mac and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
```

Takes ~5 minutes. You'll be prompted once for a hostname.

---

## What It Does (Step by Step)

`install.sh` runs in this order:

1. **Detects architecture** — Apple Silicon (M-series) or Intel. On Apple Silicon, installs Rosetta 2 automatically.
2. **Sets hostname** — prompts you to name the machine (`ares-mini`, `ge-mini`, `hospital-mini`, etc.). Sets ComputerName, HostName, and LocalHostName.
3. **Configures for headless operation** — disables sleep, enables SSH, disables screen saver, enables auto-restart after power failure.
4. **Installs Homebrew** — skips if already present.
5. **Installs core tools** via Homebrew — git, node, python3, wget, jq, gh, ffmpeg, imagemagick, poppler, mas.
6. **Installs Amphetamine** via mas (Mac App Store) — keeps the Mac awake during remote sessions.
7. **Upgrades Node to v24** if current version is below 24 (minimum required for OpenClaw).
8. **Creates a Python venv** at `~/.ares-venv` and installs packages.
9. **Installs uv** — fast Python runner, used by some agent scripts.
10. **Installs OpenClaw** via npm (`npm install -g openclaw@latest`).
11. **Installs Claude Code** via npm (`npm install -g @anthropic-ai/claude-code`).
12. **Scaffolds workspace** at `~/.openclaw/workspace/` — creates `memory/`, `skills/`, and `~/.learnings/`.
13. **Downloads identity templates** — pulls `SOUL.md`, `AGENTS.md`, `TOOLS.md` from `instances/_template/` into `~/.openclaw/workspace/`.
14. **Creates learnings files** — blank `ERRORS.md`, `LEARNINGS.md`, `DECISIONS.md`, `REGRESSIONS.md` in `~/.learnings/`.
15. **Authenticates GitHub** via `gh auth login --web` — needed to clone the private `ares-stack` repo in the next step.

---

## What It Installs

### Core tools

| Tool | Purpose |
|------|---------|
| Homebrew | Mac package manager |
| Node 24 | Runtime for OpenClaw |
| Python 3 + venv | Scripting + automation |
| OpenClaw | AI agent platform |
| Claude Code | Agentic coding CLI (`claude` command) |
| uv | Fast Python package runner |
| git | Version control |
| jq | JSON parsing in shell scripts |
| wget | HTTP downloads |
| gh | GitHub CLI (for cloning private repos) |
| ffmpeg | Video/audio processing |
| imagemagick | Image manipulation |
| poppler | PDF utilities |
| mas | Mac App Store CLI |
| Amphetamine | Keeps Mac awake during remote sessions |

### Python packages (installed into `~/.ares-venv`)

| Package | Purpose |
|---------|---------|
| requests | HTTP client |
| reportlab | PDF generation |
| pillow | Image processing |
| python-dotenv | `.env` file loading |
| google-auth | Google OAuth2 |
| google-auth-oauthlib | Google OAuth2 flow |
| google-api-python-client | Google APIs (Drive, Sheets, etc.) |
| openai | OpenAI SDK |
| anthropic | Anthropic SDK |

---

## What It Configures

### Headless operation (all settings are system-level)

| Setting | Command | Why |
|---------|---------|-----|
| Hostname | `scutil --set ComputerName/HostName/LocalHostName` | Identify the machine on the network |
| Display sleep | `pmset -a displaysleep 0` | Don't go dark mid-session |
| System sleep | `pmset -a sleep 0` | Stay on between connections |
| Disk sleep | `pmset -a disksleep 0` | Stay accessible during heavy I/O |
| SSH / Remote Login | `systemsetup -setremotelogin on` | SSH access from anywhere |
| Screen saver | `defaults write idleTime 0` | No interruptions |
| Auto-restart | `pmset -a autorestart 1` | Comes back after power outage |

### PATH additions (written to `~/.zshrc`)

- Homebrew shellenv
- `node@24` bin path (if upgraded)
- `~/.ares-venv/bin` (Python venv)
- `~/.local/bin` (uv)

---

## After Install

```bash
# Step 1 — Reload shell
source ~/.zshrc

# Step 2 — Edit your identity files
nano ~/.openclaw/workspace/SOUL.md    # AI personality + operating rules
nano ~/.openclaw/workspace/AGENTS.md  # Session behavior, memory rules, red lines
nano ~/.openclaw/workspace/TOOLS.md   # Environment notes (SSH, devices, TTS)

# Step 3 — Run OpenClaw onboarding (installs daemon + walks through API key setup)
openclaw onboard --install-daemon

# Step 4 — Link WhatsApp (or your messaging channel)
openclaw channels login

# Step 5 — Clone and run ares-stack (skills + profile tools)
git clone https://github.com/rushindrasinha/ares-stack.git
cd ares-stack && bash extend.sh --profile base

# Step 6 — Verify
openclaw gateway status
```

Full customization guide: [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)  
OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)

---

## Workspace Layout

After install, your workspace looks like this:

```
~/.openclaw/workspace/
  SOUL.md              ← AI personality, values, operating rules
  AGENTS.md            ← Session startup, memory rules, red lines
  TOOLS.md             ← Environment-specific notes
  memory/              ← Agent memory files (created by agent over time)
  skills/              ← Skill modules (populated by ares-stack)

~/.learnings/
  ERRORS.md            ← Raw incidents: what went wrong + root cause
  LEARNINGS.md         ← Validated patterns promoted from ERRORS
  DECISIONS.md         ← Deliberate architectural/behavioral choices
  REGRESSIONS.md       ← Things that broke after working correctly
```

The three identity files are injected into every agent session at startup. They are your agent's memory across reboots.

---

## The Identity Files

### SOUL.md — Who the agent is

Personality, values, operating rules, tone, and red lines. The agent reads this at the start of every session.

Key things to fill in after install:
- `[AI_NAME]` — what to call the agent (e.g. Ares, Nova, Hermes)
- `[OWNER_NAME]` — your name
- `[TIMEZONE]` — e.g. `Asia/Kolkata`
- Any domain-specific rules, communication style preferences, or off-limits behaviors

### AGENTS.md — How the agent behaves

Session startup sequence, memory read/write rules, how the agent handles uncertainty, what it must never do. More operational than SOUL.md.

### TOOLS.md — What's on this machine

SSH host aliases, camera/microphone device names, TTS preferences, API endpoint nicknames, local tool paths. Specific to the hardware this instance is running on. Fill this in as you configure the machine — nothing goes here until you know what's installed.

---

## Instance Templates

Pre-built identity file sets live in `instances/`:

```
instances/
  _template/          ← blank starter with [PLACEHOLDER] values
    SOUL.md
    AGENTS.md
    TOOLS.md
  ge-mini/            ← GE Mac Mini (Global Esports — Twitch, stream, YouTube)
    SOUL.md
    AGENTS.md
    TOOLS.md
    users.json        ← multi-user config for GE instance
```

`install.sh` automatically downloads the `_template/` files into `~/.openclaw/workspace/` on a fresh install. If those files already exist, they are not overwritten.

---

## Adding a New Instance

1. Copy `instances/_template/` → `instances/[machine-name]/`
2. Fill in all `[PLACEHOLDER]` values in the three files
3. Run `install.sh` on the new Mac
4. Copy your instance files to `~/.openclaw/workspace/` on that machine
5. `openclaw onboard --install-daemon`
6. Clone and run ares-stack: `bash extend.sh --profile base` (or your profile)

---

## Architecture Notes

- **Apple Silicon (M1/M2/M4+):** Homebrew installs to `/opt/homebrew`. Rosetta 2 is installed automatically.
- **Intel:** Homebrew installs to `/usr/local`. No Rosetta needed.
- The script detects arch via `uname -m` and sets `HOMEBREW_PREFIX` accordingly.
- All installs check if the tool is already present before installing — safe to re-run.

---

## Security Notes

- **No secrets are injected** — zero API keys, tokens, or credentials written to disk by `install.sh`.
- API keys are added later via `openclaw auth login` per provider.
- The `.gitignore` in this repo blocks `*.env`, `*.pem`, `*.key`, and other credential file patterns from being committed.
- GitHub auth (`gh auth login`) is done via browser OAuth — no credentials are stored in plaintext.

---

## Troubleshooting

**Homebrew install hangs:** Check your internet connection. Homebrew installation can take 1–2 minutes.

**`openclaw: command not found` after install:** Run `source ~/.zshrc` to reload PATH. If still missing, check that `npm install -g openclaw` succeeded (scroll up in the install output).

**GitHub auth fails:** Run `gh auth login --web` manually after install.

**`mas` can't install Amphetamine:** You need to be signed into the Mac App Store before running the script. If it fails, install [Amphetamine](https://apps.apple.com/app/id937984704) manually.

**Node version still old after upgrade:** Run `source ~/.zshrc` and check `node --version`. If still wrong, check if another node manager (nvm, volta) is overriding the PATH.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

---

## License

MIT
