# Changelog

All notable changes to ares-setup will be documented here.

Format: [Semantic Versioning](https://semver.org) — `MAJOR.MINOR.PATCH`

---

## [1.0.0] — 2026-03-24

### Added
- `install.sh` — base Mac setup script (Homebrew, Node 22, Python 3, OpenClaw, uv, core tools)
- `instances/_template/` — blank identity file set (SOUL, IDENTITY, USER, MEMORY, AGENTS, HEARTBEAT, COMMANDS)
- `docs/CUSTOMIZE.md` — post-install customization guide
- `.gitignore` — blocks secrets, tokens, keys, and OS noise from ever being committed
- Full workspace directory structure bootstrapped on install (`~/clawd/`, `~/Desktop/Ares/`, `~/.learnings/`)

### Design decisions
- Zero secrets in repo — API keys and identity entered per device after install
- No instance-specific files committed — templates only, placeholders throughout
- Idempotent installs — safe to re-run on an existing machine
- Inspired by thoughtbot/laptop pattern: single shell script, readable, extensible

---

<!-- Add new entries at the top in reverse chronological order -->
<!-- Format: ## [X.Y.Z] — YYYY-MM-DD -->
