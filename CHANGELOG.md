# Changelog

All notable changes to ares-setup will be documented here.  
Format: [Semantic Versioning](https://semver.org)

---

## [1.1.0] — 2026-03-24

### Fixed
- Workspace path corrected to `~/.openclaw/workspace/` (standard OpenClaw location)
- Removed non-standard directory scaffolding (`~/clawd/`, `~/Desktop/Ares/` etc.)
- Identity template reduced to the three files OpenClaw actually injects: `SOUL.md`, `AGENTS.md`, `TOOLS.md`
- Post-install command corrected to `openclaw onboard --install-daemon`
- Node version updated to 24 (recommended by OpenClaw)
- Template files rewritten to match the official OpenClaw template format

### Removed
- `IDENTITY.md`, `MEMORY.md`, `USER.md`, `HEARTBEAT.md`, `COMMANDS.md` from template — not standard OpenClaw files

---

## [1.0.0] — 2026-03-24

### Added
- `install.sh` — base Mac setup script (Homebrew, Node, Python, OpenClaw, uv, core tools)
- `instances/_template/` — blank identity file set
- `docs/CUSTOMIZE.md` — post-install customization guide
- `.gitignore` — blocks secrets, tokens, keys from ever being committed
- Idempotent installs — safe to re-run on an existing machine

---

<!-- Add new entries at the top in reverse chronological order -->
