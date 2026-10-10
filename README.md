# dotfiles

Personal configuration for a Linux (Ubuntu / WSL2) development machine.
Currently contains a Neovim config; more tools get their own top-level folder.

## Set up a new machine

```bash
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh      # installs software (needs sudo)
exec bash           # reload the shell so the new PATH entries apply
./install.sh        # links configs into ~/.config
nvim                # first launch installs plugins; confirm the prompt
```

Then do the manual steps below.

## What the scripts do

### `bootstrap.sh`: installs software
Installs what the configs depend on. Safe to re-run; each step is skipped if
already done.

- apt packages: `git curl unzip build-essential ripgrep fd-find python3-venv python3-pip nodejs npm`
- `fd` symlink in `~/.local/bin` (Ubuntu ships the binary as `fdfind`)
- Neovim (latest release tarball) in `/opt/nvim`
- Go (latest release) in `/usr/local/go`
- Adds `/opt/nvim/bin`, `/usr/local/go/bin`, `~/go/bin` and `~/.local/bin`
  to `PATH` in `~/.bashrc` (only if missing)

### `install.sh`: links configs
Symlinks each folder in this repo to where the tool expects it, e.g.
`~/.config/nvim -> ~/dotfiles/nvim`. The repo is the single source of truth:
edit files in either place and `git diff` shows the change.
If a real file or directory already exists at the target, it is renamed to
`<name>.bak` first. Safe to re-run.

## Layout

dotfiles/
├── bootstrap.sh
├── install.sh
└── nvim/
├── init.lua # entry point
├── nvim-pack-lock.json # pinned plugin versions (commit this)
└── lua/jenso/
├── core/ # options, keymaps
├── pack/ # plugins: init.lua lists them, one file each
└── lsp/ # language servers (planned)

Plugins are managed with Neovim's built-in `vim.pack` (requires Neovim 0.12+).
To add a plugin: add its URL in `pack/init.lua`, create `pack/<name>.lua` with
its setup, and `require` it at the bottom of `pack/init.lua`.

## Manual steps (not automated)

- **Git identity**: `git config --global user.name "…"` and `user.email "…"`
- **Nerd Font** (WSL): install one on Windows and select it in
  Windows Terminal -> profile -> Appearance. Needed for icons.
- **SSH agent**: shared-agent snippet in `~/.bashrc` and `AddKeysToAgent yes`
  in `~/.ssh/config` (not yet tracked in this repo).

## Updating

- Neovim plugins: `:lua vim.pack.update()`
- Neovim itself: delete `/opt/nvim` and re-run `./bootstrap.sh`
