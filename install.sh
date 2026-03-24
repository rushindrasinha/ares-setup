#!/bin/sh
#
# ares-setup — Mac setup script
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/rushindrasinha/ares-setup/main/install.sh)
#
# After install, run: openclaw setup
# to configure API keys and identity for this instance.
#

set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

fancy_echo() {
  printf "\n\033[1;34m▶ %s\033[0m\n" "$*"
}

success_echo() {
  printf "\033[1;32m✓ %s\033[0m\n" "$*"
}

warn_echo() {
  printf "\033[1;33m⚠ %s\033[0m\n" "$*"
}

# ── Arch + Rosetta ──────────────────────────────────────────────────────────
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

# ── Zsh ─────────────────────────────────────────────────────────────────────
append_to_zshrc() {
  local text="$1"
  local zshrc="$HOME/.zshrc"
  [ -w "$HOME/.zshrc.local" ] && zshrc="$HOME/.zshrc.local"
  grep -qF "$text" "$zshrc" 2>/dev/null || printf "\n%s\n" "$text" >> "$zshrc"
}

[ ! -f "$HOME/.zshrc" ] && touch "$HOME/.zshrc"

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

fancy_echo "Updating Homebrew..."
brew update --force --quiet

# ── Core tools ───────────────────────────────────────────────────────────────
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

# ── Node version check ────────────────────────────────────────────────────────
NODE_VERSION=$(node --version | cut -d. -f1 | tr -d 'v')
if [ "$NODE_VERSION" -lt 22 ] 2>/dev/null; then
  fancy_echo "Upgrading Node to v22+..."
  brew install node@22
  brew link --overwrite --force node@22
  append_to_zshrc "export PATH=\"${HOMEBREW_PREFIX}/opt/node@22/bin:\$PATH\""
  export PATH="${HOMEBREW_PREFIX}/opt/node@22/bin:$PATH"
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

# ── OpenClaw ─────────────────────────────────────────────────────────────────
fancy_echo "Installing OpenClaw..."
npm install -g openclaw 2>/dev/null || warn_echo "OpenClaw install had warnings — check manually"
success_echo "OpenClaw $(openclaw --version 2>/dev/null || echo 'installed')"

# ── uv (fast Python runner) ───────────────────────────────────────────────────
if ! command -v uv >/dev/null 2>&1; then
  fancy_echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  append_to_zshrc "export PATH=\"$HOME/.cargo/bin:\$PATH\""
  export PATH="$HOME/.cargo/bin:$PATH"
else
  success_echo "uv already installed"
fi

# ── Directory structure ───────────────────────────────────────────────────────
fancy_echo "Creating workspace directories..."
mkdir -p \
  "$HOME/clawd" \
  "$HOME/clawd/memory" \
  "$HOME/clawd/scripts" \
  "$HOME/clawd/vault" \
  "$HOME/clawd/docs" \
  "$HOME/clawd/brain" \
  "$HOME/Desktop/Ares/media/openclaw_media" \
  "$HOME/Desktop/Ares/media/archives" \
  "$HOME/Desktop/Ares/scripts" \
  "$HOME/Desktop/Ares/memory" \
  "$HOME/Desktop/Ares/docs" \
  "$HOME/Desktop/Ares/reports" \
  "$HOME/.config/ares/google" \
  "$HOME/.learnings"
success_echo "Directories created"

# ── Copy instance template files ─────────────────────────────────────────────
fancy_echo "Copying instance template files..."
TEMPLATE_DIR="$(dirname "$0")/instances/_template"
if [ -d "$TEMPLATE_DIR" ]; then
  cp -n "$TEMPLATE_DIR"/*.md "$HOME/clawd/" 2>/dev/null || true
  success_echo "Template files copied to ~/clawd/"
else
  warn_echo "Template dir not found — skipping. Run from repo root or re-clone."
fi

# ── .learnings bootstrap ─────────────────────────────────────────────────────
for f in ERRORS LEARNINGS DECISIONS REGRESSIONS; do
  touch "$HOME/.learnings/${f}.md"
done

# ── Done ─────────────────────────────────────────────────────────────────────
printf "\n"
printf "\033[1;32m╔══════════════════════════════════════════════════════╗\033[0m\n"
printf "\033[1;32m║           Machine setup complete ✓                  ║\033[0m\n"
printf "\033[1;32m╚══════════════════════════════════════════════════════╝\033[0m\n"
printf "\n"
printf "Next steps:\n"
printf "  1. Restart your terminal (or: source ~/.zshrc)\n"
printf "  2. Run: \033[1mopenclaw setup\033[0m  ← configure API keys + identity\n"
printf "  3. Run: \033[1mopenclaw link whatsapp\033[0m  ← link your WhatsApp number\n"
printf "  4. Run: \033[1mopenclaw gateway start\033[0m  ← start the agent\n"
printf "\n"
printf "Identity files are at ~/clawd/ — edit SOUL.md, IDENTITY.md,\n"
printf "USER.md, and MEMORY.md to customize this instance.\n"
printf "\n"
