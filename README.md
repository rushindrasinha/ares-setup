# ares-setup

One-line Mac setup for OpenClaw instances.

## Quick Start

On a fresh Mac, open Terminal and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/main/install.sh)
```

That's it. The script handles everything:
- Homebrew
- Node 22+
- Python 3 + required packages
- OpenClaw (global)
- uv
- Directory structure

No API keys. No identity. Just the foundation.

## After Install

1. **Restart terminal** (or `source ~/.zshrc`)
2. **Edit identity files** at `~/clawd/` — see [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)
3. **Configure API keys:** `openclaw setup`
4. **Link WhatsApp:** `openclaw link whatsapp`
5. **Start:** `openclaw gateway start`

## Structure

```
install.sh              ← run this on new machines
instances/
  _template/            ← blank identity files (SOUL, MEMORY, AGENTS, etc.)
docs/
  CUSTOMIZE.md          ← post-install customization guide
```

## Adding a New Instance

Copy `instances/_template/`, fill in the placeholders, deploy.
See [docs/CUSTOMIZE.md](docs/CUSTOMIZE.md).

---

Inspired by [thoughtbot/laptop](https://github.com/thoughtbot/laptop).
