# dotfiles

Personal configuration for a Linux (Ubuntu 24.04 / WSL2) development machine.
Currently contains a Neovim config; more tools get their own top-level folder.

Tested from scratch on two separate machines.

## Set up a new machine

### 0. Prerequisites (once per machine, before cloning)

**WSL only:** in PowerShell, install Ubuntu and create your Linux user.

```powershell
wsl --install -d Ubuntu-24.04
```

Also on Windows: install a Nerd Font and select it in Windows Terminal
(profile -> Appearance -> Font face). Needed for icons.

**In Ubuntu:** `bootstrap.sh` installs git, but you need git to fetch it.

```bash
sudo apt update && sudo apt install -y git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

**SSH key**: every machine gets its own key; never copy a private key.

```bash
ssh-keygen -t ed25519 -C "you@example.com"    # set a passphrase
cat ~/.ssh/id_ed25519.pub                     # add at GitHub -> Settings -> SSH and GPG keys
ssh -T git@github.com                         # expect: "Hi <user>! You've successfully authenticated"
```

### 1. Clone and run

```bash
git clone git@github.com:jol95/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh      # installs software (needs sudo)
exec bash           # reload the shell so the new PATH entries apply
./install.sh        # links configs into ~/.config
nvim                # first launch installs plugins; confirm the prompt
```

On first launch, give treesitter a minute to compile its parsers.

## What the scripts do

### `bootstrap.sh`: installs software
Installs what the configs depend on. Safe to re-run; each step is skipped if
already done.

- apt packages: `git curl unzip build-essential ripgrep fd-find python3-venv python3-pip nodejs npm tmux`
- `fd` symlink in `~/.local/bin` (Ubuntu ships the binary as `fdfind`)
- Neovim (latest release tarball) in `/opt/nvim`. Needs 0.12+ for `vim.pack`
- Go (latest release) in `/usr/local/go`
- Claude Code (native installer, `~/.local/bin/claude`, auto-updates)
- `tree-sitter` CLI (release binary) in `~/.local/bin`. Needs 0.26.1+ for nvim-treesitter
- catppuccin theme for tmux, cloned into `tmux/plugins/` (gitignored). It is cloned
  into the repo folder, not `~/.config/tmux`, because `bootstrap.sh` runs before
  `install.sh` creates the symlink
- Adds `/opt/nvim/bin`, `/usr/local/go/bin`, `~/go/bin` and `~/.local/bin`
  to `PATH` in `~/.bashrc` (only if missing)

### `install.sh`: links configs
Symlinks each folder in this repo to where the tool expects it, e.g.
`~/.config/nvim -> ~/dotfiles/nvim`. The repo is the single source of truth:
edit files in either place and `git diff` shows the change.
If a real file or directory already exists at the target, it is renamed to
`<name>.bak` first. Safe to re-run.

## Layout

```
dotfiles/
├── bootstrap.sh
├── install.sh
├── tmux/
│   └── tmux.conf            # plugins/ is cloned by bootstrap.sh, gitignored
└── nvim/
    ├── init.lua                 # entry point
    ├── nvim-pack-lock.json      # pinned plugin versions (commit this)
    └── lua/jenso/
        ├── core/                # options, keymaps
        ├── pack/                # plugins: init.lua lists them, one file each
        └── lsp/                 # language servers (planned)
```

Plugins are managed with Neovim's built-in `vim.pack` (requires Neovim 0.12+).
Current plugins: catppuccin, lualine, which-key, telescope (+ fzf-native),
treesitter, gitsigns, vim-tmux-navigator.

To add a plugin: add its URL in `pack/init.lua`, create `pack/<name>.lua` with
its setup, and `require` it at the bottom of `pack/init.lua`.

## Working across machines

Edit on any machine, then `git add -A && git commit && git push`.
On the others: `git pull` (the symlink means the change is live immediately).
Commit `nvim-pack-lock.json` too, so plugin versions stay identical.

## tmux cheat sheet

Prefix is `Ctrl-Space`.

| Keys | Does |
|---|---|
| prefix `\|` / `-` | split right / down |
| prefix `h j k l` | move between panes |
| `Ctrl-h/j/k/l` | move between panes AND Neovim splits (vim-tmux-navigator) |
| prefix `c`, `1`-`9` | new window, jump to window |
| prefix `d` | detach (session keeps running) |
| prefix `[` , `v`, `y` | copy mode: select and copy |
| prefix `r` | reload config |
| prefix `Ctrl-l` | clear screen (plain `Ctrl-l` is used for navigation) |

## Shell and SSH

`install.sh` does not symlink `~/.bashrc` or `~/.ssh`. Instead:

- It adds one line to `~/.bashrc` that sources `shell/bashrc` (shared ssh-agent,
  so you type the key passphrase once, not in every tab).
- It adds `Include <repo>/ssh/config` as the first line of `~/.ssh/config`
  (`AddKeysToAgent yes`). Keys are never stored in this repo.

## Known gaps (not automated yet)

- **Windows side**: Nerd Font and Windows Terminal settings are manual.

## Updating

- Neovim plugins: `:lua vim.pack.update()`
- Neovim itself: delete `/opt/nvim` and re-run `./bootstrap.sh`
