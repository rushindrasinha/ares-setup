# ares-setup

> Public, one-command Mac setup for OpenClaw AI agent instances.

`ares-setup` is the clean base layer for turning a fresh Mac into an OpenClaw-ready agent machine. It installs the operating-system dependencies, OpenClaw runtime, Claude Code, Python tooling, headless-safe Mac settings, and starter identity templates — without shipping secrets, API keys, personal memory, or private skills.

This repo is intentionally public and reusable. The private/personal layer lives in [`rushindrasinha/ares-stack`](https://github.com/rushindrasinha/ares-stack), which is run after this repo finishes.

---

## Table of Contents

- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [What This Repo Is For](#what-this-repo-is-for)
- [What It Installs](#what-it-installs)
- [What It Configures](#what-it-configures)
- [Install Flow](#install-flow)
- [After Install](#after-install)
- [Workspace Layout](#workspace-layout)
- [Identity Files](#identity-files)
- [Instance Templates](#instance-templates)
- [Adding a New Instance](#adding-a-new-instance)
- [Security Model](#security-model)
- [Re-running Safely](#re-running-safely)
- [Troubleshooting](#troubleshooting)
- [Repo Structure](#repo-structure)

---

## Architecture

Ares-style machines are built in two layers:

| Layer | Repo | Visibility | Purpose |
|---|---|---:|---|
| 1 | `ares-setup` | Public | Fresh Mac bootstrap: Homebrew, Node, Python, OpenClaw, Claude Code, starter workspace, headless-safe settings |
| 2 | `ares-stack` | Private | Personal/operator layer: profiles, private skills, advanced tooling, Nova upgrades, machine-specific extensions |

Canonical sequence:

```bash
# 1. Public base layer
bash <(curl -H "Cache-Control: no-cache" -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)

# 2. Private stack layer, after GitHub auth
cd ~
gh repo clone rushindrasinha/ares-stack ~/ares-stack
cd ~/ares-stack
bash extend.sh --profile base
```

Use `ares-setup` to get any Mac to a known-good baseline. Use `ares-stack` only after the machine is authenticated and ready for private repo access.

---

## Quick Start

Open Terminal on a fresh Mac and run:

```bash
bash <(curl -H "Cache-Control: no-cache" -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
```

You will be prompted for a hostname such as:

- `ares-mini`
- `ge-mini`
- `hospital-mini`
- `creatoros-mini`

The script is designed to be idempotent: it checks for existing installs before installing most tools and will skip identity templates that already exist.

---

## What This Repo Is For

Use this repo when you need to:

- Bootstrap a fresh Mac Mini or MacBook into an OpenClaw agent machine.
- Standardize Node, Python, OpenClaw, Claude Code, and common CLI tools.
- Prepare a Mac for headless / remote operation.
- Create a clean OpenClaw workspace at `~/.openclaw/workspace/`.
- Install only public, non-secret templates.
- Prepare GitHub CLI auth so the private stack can be cloned next.

Do **not** put personal memory, API keys, private automation logic, machine secrets, private skills, or client data in this repo.

---

## What It Installs

### Core runtime

| Tool | Why it exists |
|---|---|
| Homebrew | macOS package manager |
| Node 24+ | Runtime required/recommended for OpenClaw and agent CLIs |
| Python 3 | Local scripts and automation |
| `~/.ares-venv` | Isolated Python environment for common packages |
| OpenClaw | Agent gateway/runtime |
| Claude Code | Agentic coding CLI (`claude`) |
| `uv` | Fast Python package/tool runner |
| GitHub CLI (`gh`) | GitHub auth and private repo clone flow |

### Homebrew packages

| Package | Purpose |
|---|---|
| `git` | Version control |
| `node` | JavaScript runtime / npm |
| `python3` | Python runtime |
| `wget` | HTTP downloads |
| `jq` | JSON parsing |
| `gh` | GitHub auth + repo operations |
| `ffmpeg` | Audio/video processing |
| `imagemagick` | Image processing |
| `poppler` | PDF utilities |
| `mas` | Mac App Store CLI |

### Python packages in `~/.ares-venv`

| Package | Purpose |
|---|---|
| `requests` | HTTP client |
| `reportlab` | PDF generation |
| `pillow` | Image processing |
| `python-dotenv` | `.env` loading |
| `google-auth` | Google auth primitives |
| `google-auth-oauthlib` | Google OAuth browser flow |
| `google-api-python-client` | Google Workspace APIs |
| `openai` | OpenAI SDK |
| `anthropic` | Anthropic SDK |

### Optional / best-effort

| Tool | Install method | Notes |
|---|---|---|
| Amphetamine | Mac App Store via `mas` | Keeps the Mac awake. If App Store install fails, install manually. |
| Rosetta 2 | `softwareupdate` | Installed automatically on Apple Silicon when missing. |

---

## What It Configures

### macOS headless-safe settings

| Setting | Why |
|---|---|
| Hostname / ComputerName / LocalHostName | Makes machines identifiable on the network |
| Display sleep off | Prevents remote sessions from going dark |
| System sleep off | Keeps agent available |
| Disk sleep off | Avoids I/O interruption |
| SSH / Remote Login on | Enables remote administration |
| Screen saver disabled | Avoids interruption during unattended sessions |
| Auto-restart after power failure | Recovers after outages |

### Shell paths written to `~/.zshrc`

The script appends path setup only if missing:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
# or /usr/local/bin/brew shellenv on Intel
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH="$HOME/.ares-venv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
```

---

## Install Flow

`install.sh` runs roughly in this order:

1. Detects architecture: Apple Silicon (`arm64`) vs Intel.
2. Installs Rosetta 2 on Apple Silicon if missing.
3. Prompts for machine hostname.
4. Applies headless-safe macOS settings.
5. Installs Homebrew if missing.
6. Installs core Homebrew packages.
7. Attempts Amphetamine install via Mac App Store CLI.
8. Ensures Node 24+ is available.
9. Creates Python venv at `~/.ares-venv`.
10. Installs common Python packages into that venv.
11. Installs `uv` if missing.
12. Installs OpenClaw globally with npm.
13. Installs Claude Code globally with npm.
14. Creates workspace directories.
15. Downloads starter identity templates into the workspace.
16. Creates governed learning files under `~/.learnings/`.
17. Runs GitHub web auth if `gh` is not authenticated.
18. Prints the next-step checklist.

---

## After Install

Run these steps after the script completes:

```bash
# 1. Reload shell paths
source ~/.zshrc

# 2. Review/edit starter identity files
nano ~/.openclaw/workspace/SOUL.md
nano ~/.openclaw/workspace/AGENTS.md
nano ~/.openclaw/workspace/TOOLS.md

# 3. Run OpenClaw onboarding and install daemon
openclaw onboard --install-daemon

# 4. Start gateway
openclaw gateway start

# 5. Link WhatsApp or configured channel
openclaw wa link
# If your OpenClaw version uses the channel login command instead:
# openclaw channels login

# 6. Clone private stack
cd ~
gh repo clone rushindrasinha/ares-stack ~/ares-stack
# or: git clone https://github.com/rushindrasinha/ares-stack.git ~/ares-stack

# 7. Run private extension layer
cd ~/ares-stack
bash extend.sh --profile base

# 8. Verify
openclaw gateway status
```

For Anthropic Max token auth / Claude Code token setup, install Claude Code first, then run:

```bash
openclaw models auth setup-token
```

---

## Workspace Layout

After install:

```text
~/.openclaw/workspace/
├── SOUL.md              # Agent identity, tone, principles, operating stance
├── AGENTS.md            # Session rules, memory protocol, red lines
├── TOOLS.md             # Machine-specific tool notes and environment facts
├── memory/              # Long-lived memory files created/maintained over time
└── skills/              # Legacy/simple skills dir; private stack uses .agents/skills too

~/.learnings/
├── ERRORS.md            # Raw incidents and mistakes
├── LEARNINGS.md         # Validated patterns promoted from incidents
├── DECISIONS.md         # Deliberate architecture / behavior choices
└── REGRESSIONS.md       # Things that broke after previously working
```

OpenClaw’s standard injected workspace files are:

- `SOUL.md`
- `AGENTS.md`
- `TOOLS.md`

Other files such as `USER.md`, `IDENTITY.md`, `MEMORY.md`, and `HEARTBEAT.md` can exist in personal stacks, but they are not part of the clean public baseline.

---

## Identity Files

### `SOUL.md`

Defines who the agent is:

- name
- owner
- tone
- values
- operating stance
- red lines
- communication style
- autonomy boundaries

Fill placeholders such as:

- `[AI_NAME]`
- `[OWNER_NAME]`
- `[TIMEZONE]`

### `AGENTS.md`

Defines how the agent works:

- what to read on startup
- memory rules
- verification rules
- execution behavior
- tool usage constraints
- never-do rules

This is more operational than `SOUL.md`.

### `TOOLS.md`

Machine/environment cheat sheet:

- SSH hosts
- device names
- camera/microphone names
- preferred TTS voices
- local paths
- service ports
- API endpoint nicknames

Keep reusable skill instructions in actual skills. Keep environment-specific facts in `TOOLS.md`.

---

## Instance Templates

Templates live in `instances/`:

```text
instances/
├── _template/
│   ├── SOUL.md
│   ├── AGENTS.md
│   └── TOOLS.md
└── ge-mini/
    ├── SOUL.md
    ├── AGENTS.md
    ├── TOOLS.md
    └── users.json
```

`install.sh` downloads from `instances/_template/` by default.

If `~/.openclaw/workspace/SOUL.md`, `AGENTS.md`, or `TOOLS.md` already exists, the script does **not** overwrite it.

---

## Adding a New Instance

Recommended flow:

1. Copy `instances/_template/` to `instances/<machine-name>/`.
2. Fill all placeholders.
3. Keep secrets out of the repo.
4. Run `install.sh` on the target Mac.
5. Copy the finalized identity files to `~/.openclaw/workspace/`.
6. Run `openclaw onboard --install-daemon`.
7. Start gateway and link channel.
8. Clone `ares-stack`.
9. Run `bash extend.sh --profile <base|ge|hospital>`.
10. Send `/status` to the linked channel and verify response.

Example:

```bash
cp -R instances/_template instances/hospital-mini
# edit instances/hospital-mini/SOUL.md, AGENTS.md, TOOLS.md
```

---

## Security Model

This repo must remain safe to publish.

### Allowed in `ares-setup`

- public setup scripts
- generic identity templates
- non-secret docs
- public machine bootstrap commands
- placeholder values

### Not allowed in `ares-setup`

- API keys
- OAuth tokens
- `.env` files
- private memory
- private skills
- customer data
- hardcoded personal credentials
- machine-specific private paths
- client-specific operating doctrine

### Credential handling

- Use OpenClaw auth flows for model/provider credentials.
- Use `gh auth login` or SSH keys for private GitHub repo access.
- Use the private stack or vault tooling for private operational material.
- Never embed secrets in `install.sh`, README examples, or templates.

The `.gitignore` blocks common credential patterns, but do not rely on `.gitignore` as the only guardrail.

---

## Re-running Safely

`install.sh` is designed to be safe to re-run:

- Existing Homebrew packages are skipped.
- Existing identity files are not overwritten.
- `~/.zshrc` additions are appended only when missing.
- Existing GitHub auth is reused.
- Existing Python venv is reused/updated.

Be careful with hostname changes: if you enter a new hostname, macOS names will be updated.

---

## Troubleshooting

### `openclaw: command not found`

Reload shell paths:

```bash
source ~/.zshrc
```

Then check:

```bash
npm list -g --depth=0 | grep openclaw
```

### `gh repo clone rushindrasinha/ares-stack` fails

Authenticate first:

```bash
gh auth login --web --git-protocol https
gh auth status
```

If using SSH instead:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add this key to GitHub, then clone with git@github.com:rushindrasinha/ares-stack.git
```

### Amphetamine install fails

Amphetamine is a Mac App Store app. Install manually if `mas install 937984704` fails:

- Open the Mac App Store.
- Search `Amphetamine`.
- Install and configure it to keep the Mac awake.

### Homebrew install hangs

Homebrew can take a few minutes on fresh machines. If it fails, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then re-run `install.sh`.

### Node version is still old

Check:

```bash
node --version
which node
```

Reload shell:

```bash
source ~/.zshrc
```

If needed:

```bash
brew install node@24
brew link --overwrite --force node@24
```

### OpenClaw onboarding command

Use:

```bash
openclaw onboard --install-daemon
```

Do not use older/nonexistent commands such as `openclaw setup`.

---

## Repo Structure

```text
.
├── README.md
├── CHANGELOG.md
├── install.sh
├── docs/
│   └── CUSTOMIZE.md
└── instances/
    ├── _template/
    │   ├── SOUL.md
    │   ├── AGENTS.md
    │   └── TOOLS.md
    └── ge-mini/
        ├── SOUL.md
        ├── AGENTS.md
        ├── TOOLS.md
        └── users.json
```

---

## Design Principles

1. Public base, private stack.
2. No secrets in public repos.
3. Use `$HOME`, not hardcoded user paths.
4. Make installs idempotent.
5. Keep identity templates minimal and portable.
6. Prefer explicit post-install verification over silent assumptions.
7. Keep machine-specific detail in `TOOLS.md`, not generic scripts.

---

## License

Private/internal unless explicitly relicensed.
