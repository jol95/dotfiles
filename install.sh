#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "Backed up $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/tmux" "$HOME/.config/tmux"
link "$DOTFILES/tmux" "$HOME/.config/tmux"

# --- shell snippet: add one source line to ~/.bashrc (not a symlink)
if ! grep -qsF "$DOTFILES/shell/bashrc" "$HOME/.bashrc"; then
  printf '\n# dotfiles\n[ -f "%s/shell/bashrc" ] && . "%s/shell/bashrc"\n' "$DOTFILES" "$DOTFILES" >> "$HOME/.bashrc"
  echo "Added source line to ~/.bashrc"
fi

# --- ssh: Include the tracked config at the top of ~/.ssh/config
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
INC="Include $DOTFILES/ssh/config"
if ! grep -qsF "$INC" "$HOME/.ssh/config"; then
  { echo "$INC"; echo; cat "$HOME/.ssh/config" 2>/dev/null || true; } > "$HOME/.ssh/config.new"
  mv "$HOME/.ssh/config.new" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  echo "Added Include to ~/.ssh/config"
fi
