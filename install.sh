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
