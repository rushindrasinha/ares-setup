#!/bin/bash
#
# ares-setup — Mac setup for OpenClaw instances
# https://github.com/rushindrasinha/ares-setup
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/master/install.sh)
#
# After install:
#   openclaw onboard --install-daemon
#

set -e

REPO_RAW="https://raw.githubusercontent.com/rushindrasinha/ares-setup/master"

fancy_echo() {
  printf "\n\033[1;34m▶ %s\033[0m\n" "$*"
}

success_echo() {
  printf "\033[1;32m✓ %s\033[0m\n" "$*"
}

warn_echo() {
  printf "\033[1;33m⚠ %s\033[0m\n" "$*"
}

# ── Detect arch ───────────────────────────────────────────────────────────────
arch="$(uname -m)"
if [ "$arch" = "arm64" ]; then
  HOMEBREW_PREFIX="/opt/homebrew"
  if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1; then
    fancy_echo "Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
  fi
else
  HOMEBREW_PREFIX="/usr/local"
fi

# ── zshrc helper ──────────────────────────────────────────────────────────────
append_to_zshrc() {
  local text="$1"
  local zshrc="$HOME/.zshrc"
  [ ! -f "$zshrc" ] && touch "$zshrc"
  grep -qF "$text" "$zshrc" 2>/dev/null || printf "\n%s\n" "$text" >> "$zshrc"
}

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  append_to_zshrc "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\""
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
else
  success_echo "Homebrew already installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"
brew update --quiet

# ── Core tools ────────────────────────────────────────────────────────────────
fancy_echo "Installing core tools..."
for pkg in git node python3 wget jq gh ffmpeg imagemagick poppler; do
  if brew list --formula "$pkg" &>/dev/null; then
    echo "  → $pkg already installed"
  else
    brew install "$pkg"
  fi
done
success_echo "Core tools installed"

# ── Node 24 ───────────────────────────────────────────────────────────────────
NODE_MAJOR=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -n "$NODE_MAJOR" ] && [ "$NODE_MAJOR" -lt 24 ]; then
  fancy_echo "Upgrading Node to v24 (recommended for OpenClaw)..."
  if brew list --formula node@24 &>/dev/null; then
    echo "  → node@24 already installed"
  else
    brew install node@24
  fi
  brew link --overwrite --force node@24 2>/dev/null || true
  append_to_zshrc "export PATH=\"${HOMEBREW_PREFIX}/opt/node@24/bin:\$PATH\""
  export PATH="${HOMEBREW_PREFIX}/opt/node@24/bin:$PATH"
fi
success_echo "Node $(node --version)"

# ── Python packages ───────────────────────────────────────────────────────────
fancy_echo "Installing Python packages..."
# macOS + Homebrew Python 3.12+ requires --break-system-packages (PEP 668)
PIP_FLAGS="--quiet --break-system-packages"
pip3 install $PIP_FLAGS --upgrade pip
pip3 install $PIP_FLAGS \
  requests reportlab pillow python-dotenv \
  google-auth google-auth-oauthlib google-api-python-client \
  openai anthropic
success_echo "Python packages installed"

# ── uv ────────────────────────────────────────────────────────────────────────
if ! command -v uv >/dev/null 2>&1; then
  fancy_echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # uv installs to ~/.local/bin
  append_to_zshrc "export PATH=\"\$HOME/.local/bin:\$PATH\""
  export PATH="$HOME/.local/bin:$PATH"
else
  success_echo "uv already installed"
fi

# ── OpenClaw ──────────────────────────────────────────────────────────────────
fancy_echo "Installing OpenClaw..."
npm install -g openclaw@latest
success_echo "OpenClaw $(openclaw --version 2>/dev/null || echo 'installed')"

# ── Workspace scaffold ────────────────────────────────────────────────────────
fancy_echo "Scaffolding workspace..."
WORKSPACE="${HOME}/.openclaw/workspace"
mkdir -p \
  "$WORKSPACE/memory" \
  "$WORKSPACE/skills" \
  "$HOME/.learnings"

# Download template identity files directly from repo (works via curl)
fancy_echo "Downloading identity templates..."
for f in SOUL.md AGENTS.md TOOLS.md; do
  if [ ! -f "$WORKSPACE/$f" ]; then
    curl -fsSL "${REPO_RAW}/instances/_template/${f}" -o "$WORKSPACE/$f" \
      && echo "  → $f" \
      || warn_echo "Could not fetch $f — add it manually from instances/_template/"
  else
    echo "  → $f already exists, skipping"
  fi
done

# Bootstrap .learnings
for f in ERRORS LEARNINGS DECISIONS REGRESSIONS; do
  touch "$HOME/.learnings/${f}.md"
done

# ── Done ──────────────────────────────────────────────────────────────────────
printf "\n"
printf "\033[1;32m╔════════════════════════════════════════════╗\033[0m\n"
printf "\033[1;32m║        Machine setup complete ✓            ║\033[0m\n"
printf "\033[1;32m╚════════════════════════════════════════════╝\033[0m\n"
printf "\n"
printf "Next steps:\n"
printf "  1. Restart terminal  →  source ~/.zshrc\n"
printf "  2. Edit identity     →  %s/\n" "$WORKSPACE"
printf "     SOUL.md, AGENTS.md, TOOLS.md\n"
printf "  3. Run onboarding    →  openclaw onboard --install-daemon\n"
printf "\n"
