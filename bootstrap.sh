#!/usr/bin/env bash
set -euo pipefail

echo "== apt packages =="
sudo apt update
sudo apt install -y git curl unzip build-essential ripgrep fd-find \
  python3-venv python3-pip nodejs npm tmux tmux

mkdir -p "$HOME/.local/bin"
command -v fd >/dev/null || ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"

echo "== Neovim =="
if [ ! -x /opt/nvim/bin/nvim ]; then
  curl -fL -o /tmp/nvim.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo mkdir -p /opt/nvim
  sudo tar -C /opt/nvim --strip-components=1 -xzf /tmp/nvim.tar.gz
fi

echo "== Go =="
if [ ! -x /usr/local/go/bin/go ]; then
  GO_VERSION="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)"
  curl -fL -o /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
fi

echo "== tree-sitter CLI =="
if ! command -v tree-sitter >/dev/null; then
  curl -fL -o /tmp/ts.gz \
    https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
  gunzip -f /tmp/ts.gz
  install -m 755 /tmp/ts "$HOME/.local/bin/tree-sitter"
fi

echo "== tmux theme =="
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAT="$DOTFILES/tmux/plugins/catppuccin/tmux"
[ -d "$CAT" ] || git clone --depth 1 https://github.com/catppuccin/tmux "$CAT"

echo "== PATH entries in ~/.bashrc =="
add_path() {
  grep -qsF "$1" "$HOME/.bashrc" || printf 'export PATH="$PATH:%s"\n' "$1" >> "$HOME/.bashrc"
}
add_path /opt/nvim/bin
add_path /usr/local/go/bin
add_path '$HOME/go/bin'
add_path '$HOME/.local/bin'

echo "Done. Run: exec bash && ~/dotfiles/install.sh"
