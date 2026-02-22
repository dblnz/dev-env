# Dev Environment (Ansible + Stow)

Portable terminal development environment for macOS and Linux. Single-command setup, release-based updates.

## Quick Start

**Fresh machine (no clone needed):**
```sh
curl -sL https://raw.githubusercontent.com/dblnz/dev/main/devup.sh | bash
```

**From a local clone:**
```sh
git clone https://github.com/dblnz/devup.git ~/workspace/dev
cd ~/workspace/dev
./devup.sh
```

The bootstrap script installs Homebrew/apt prerequisites, Ansible, downloads the latest release to `~/.local/share/devup/`, and runs the full playbook.

## What Gets Installed

| Layer | Tool | Managed By |
|---|---|---|
| System packages | ripgrep, fd, bat, fzf, jq, etc. | Ansible (brew/apt) |
| Compilers | clang, cmake, make, go, node | Ansible (brew/apt) |
| Rust | rustup + stable toolchain | Ansible + rustup |
| Neovim | nvim + LazyVim config | Ansible + Mason.nvim |
| Dotfiles | zsh, bash, tmux, git, starship | GNU Stow |
| Version switching | Per-project node/python/go | mise |

## Day-to-Day Usage

```sh
# Apply configuration after editing dotfiles or vars
make setup

# Apply only dotfiles
make dotfiles

# Apply specific roles
make tags TAGS=shell,neovim

# Update to latest release from GitHub
devup-update

# Show all make targets
make help
```

## Updates

On every new terminal session, the shell checks GitHub for new releases. If an update is available, you'll see:

```
⚡ devup update available (v1.2.0). Run `devup-update` to apply.
```

Run `devup-update` to download the latest release and re-apply the playbook. Your working clone is never touched — the installed copy lives at `~/.local/share/devup/`.

## Project Templates

Use `mise` for per-project language versions:

```sh
# In a project directory
echo '[tools]\nnode = "20"' > .mise.toml
mise install
```

## Structure

```
├── devup.sh                   # Entry point for fresh machines
├── Makefile                   # make setup, make update, etc.
├── ansible/
│   ├── playbook.yml           # Main playbook
│   ├── inventory/             # Local connection config
│   ├── group_vars/            # Package lists (all, darwin, linux)
│   └── roles/                 # base, shell, neovim, mise, rust, dotfiles
└── dotfiles/                  # Stow-managed dotfiles
    ├── zsh/.zshrc
    ├── bash/.bashrc
    ├── tmux/.tmux.conf
    ├── git/.gitconfig
    ├── starship/.config/starship.toml
    └── mise/.config/mise/config.toml
```

## Adding a Package

1. Edit `ansible/group_vars/darwin.yml` and/or `ansible/group_vars/linux.yml`
2. Add the package name to the appropriate list
3. Run `make setup`

## Adding a Dotfile

1. Create `dotfiles/<app>/` mirroring `$HOME` structure
2. Add the directory name to `stow_packages` in `ansible/group_vars/all.yml`
3. Run `make dotfiles`
