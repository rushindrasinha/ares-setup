#!/bin/sh
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

fancy_echo() {
  printf "\n\033[1;34m▶ %s\033[0m\n" "$*"
}

success_echo() {
  printf "\033[1;32m✓ %s\033[0m\n" "$*"
}

warn_echo() {
  printf "\033[1;33m⚠ %s\033[0m\n" "$*"
}

# ── Detect arch ──────────────────────────────────────────────────────────────
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

# ── zshrc helper ─────────────────────────────────────────────────────────────
append_to_zshrc() {
  local text="$1"
  local zshrc="$HOME/.zshrc"
  [ ! -f "$zshrc" ] && touch "$zshrc"
  grep -qF "$text" "$zshrc" 2>/dev/null || printf "\n%s\n" "$text" >> "$zshrc"
}

# ── Homebrew ─────────────────────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  append_to_zshrc "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\""
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
else
  success_echo "Homebrew already installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"
brew update --force --quiet

# ── Core tools ────────────────────────────────────────────────────────────────
fancy_echo "Installing core tools..."
brew bundle --quiet --no-lock --file=- <<EOF
brew "git"
brew "node"
brew "python3"
brew "wget"
brew "jq"
brew "gh"
brew "ffmpeg"
brew "imagemagick"
brew "poppler"
EOF
success_echo "Core tools installed"

# ── Node 24 ───────────────────────────────────────────────────────────────────
NODE_VERSION=$(node --version | cut -d. -f1 | tr -d 'v')
if [ "$NODE_VERSION" -lt 24 ] 2>/dev/null; then
  fancy_echo "Upgrading Node to v24 (recommended for OpenClaw)..."
  brew install node@24 2>/dev/null || brew upgrade node 2>/dev/null || true
  brew link --overwrite --force node@24 2>/dev/null || true
  append_to_zshrc "export PATH=\"${HOMEBREW_PREFIX}/opt/node@24/bin:\$PATH\""
  export PATH="${HOMEBREW_PREFIX}/opt/node@24/bin:$PATH"
fi
success_echo "Node $(node --version)"

# ── Python packages ───────────────────────────────────────────────────────────
fancy_echo "Installing Python packages..."
pip3 install --quiet --upgrade pip
pip3 install --quiet \
  requests \
  reportlab \
  pillow \
  python-dotenv \
  google-auth \
  google-auth-oauthlib \
  google-api-python-client \
  openai \
  anthropic
success_echo "Python packages installed"

# ── uv ────────────────────────────────────────────────────────────────────────
if ! command -v uv >/dev/null 2>&1; then
  fancy_echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  append_to_zshrc "export PATH=\"$HOME/.cargo/bin:\$PATH\""
  export PATH="$HOME/.cargo/bin:$PATH"
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
  "$WORKSPACE" \
  "$WORKSPACE/memory" \
  "$WORKSPACE/skills" \
  "$HOME/.openclaw" \
  "$HOME/.learnings"

# Drop template identity files if workspace is empty
TEMPLATE_DIR="$(dirname "$0")/instances/_template"
if [ -d "$TEMPLATE_DIR" ]; then
  for f in SOUL.md AGENTS.md TOOLS.md; do
    [ ! -f "$WORKSPACE/$f" ] && cp "$TEMPLATE_DIR/$f" "$WORKSPACE/$f" && echo "  → $f"
  done
  success_echo "Template files placed in $WORKSPACE"
else
  warn_echo "Template dir not found — run from repo root or re-clone to get identity files"
fi

# Bootstrap .learnings
for f in ERRORS LEARNINGS DECISIONS REGRESSIONS; do
  touch "$HOME/.learnings/${f}.md"
done

# ── Done ─────────────────────────────────────────────────────────────────────
printf "\n"
printf "\033[1;32m╔════════════════════════════════════════════╗\033[0m\n"
printf "\033[1;32m║        Machine setup complete ✓            ║\033[0m\n"
printf "\033[1;32m╚════════════════════════════════════════════╝\033[0m\n"
printf "\n"
printf "Next steps:\n"
printf "  1. Restart terminal  →  source ~/.zshrc\n"
printf "  2. Edit identity     →  %s/SOUL.md + AGENTS.md + TOOLS.md\n" "$WORKSPACE"
printf "  3. Run onboarding    →  openclaw onboard --install-daemon\n"
printf "\n"
printf "See docs/CUSTOMIZE.md for identity file guidance.\n"
printf "\n"
