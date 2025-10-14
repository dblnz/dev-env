# Development Setup

This repository contains my personal development environment configuration using **Nix and Home Manager** for cross-platform compatibility (Linux and macOS).

## Quick Start (New Nix Setup)

```bash
# Clone this repo
git clone <your-repo> ~/dotfiles
cd ~/dotfiles

# Bootstrap everything (installs Nix if needed)
./bootstrap.sh

# Or use Makefile
make bootstrap
```

That's it! Your environment is now configured with:
- Git configuration with aliases and GPG signing
- Zsh with Oh-My-Zsh, plugins, and modern tools
- Bash with custom prompt and aliases
- Tmux with vim-style navigation and themes
- Modern CLI tools (bat, eza, ripgrep, fd, fzf, etc.)
- Starship prompt
- Direnv for per-project environments

**Read [NIX_README.md](NIX_README.md) for detailed documentation.**  
**See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for command cheatsheet.**

---

## Development Tools Included

- **Shell**: zsh (with oh-my-zsh), bash
- **Terminal Multiplexers**: tmux, zellij
- **Editor**: neovim (LazyVim-based config via Home Manager)
- **Version Control**: git with delta diff viewer
- **CLI Tools**: bat, eza, ripgrep, fd, fzf, htop, btop, jq, yq
- **Dev Environments**: Project templates for Rust, C/C++, Node.js, Python, Go

## Project Templates

Create language-specific development environments:

```bash
# Initialize a new project
make init-rust DIR=my-rust-project
make init-node DIR=my-node-app
make init-python DIR=my-python-project

# Or manually
nix flake init -t .#rust
nix develop  # Enter dev environment
```

Available templates: `rust`, `c`, `node`, `python`, `go`

---

## Documentation

- **[NIX_README.md](NIX_README.md)** - Complete Nix setup guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheatsheet
- **[Makefile](Makefile)** - Common operations (`make help`)

---

## Home Manager: activate and update (azureuser)

Use these commands if you want to manage your local user environment directly with Home Manager and this flake.

### Initial setup on Linux (azureuser)

Recommended (bootstrap script):

```sh
git clone <repo-url> ~/dev-env
cd ~/dev-env
./bootstrap.sh
```

Manual (if you prefer explicit steps):

```sh
# 1) Install Nix (multi-user on Linux)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2) Enable flakes (once)
mkdir -p ~/.config/nix
grep -q 'experimental-features' ~/.config/nix/nix.conf || echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# 3) Activate the Home Manager profile for azureuser
cd ~/dev-env
nix run home-manager/master -- switch --flake .#azureuser -b backup

# 4) Load session vars for the current shell (or open a new shell)
source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
```

### Update this machine from the repo

```sh
cd ~/dev-env
git pull
home-manager switch --flake .#azureuser
```

### Update inputs (nixpkgs, etc.), commit, and apply

```sh
cd ~/dev-env
nix flake update
git commit -am "flake: update"
home-manager switch --flake .#azureuser
```

### Useful commands

```sh
# Build without switching (dry run for evaluation/build)
home-manager build --flake .#azureuser

# Roll back to previous generation
home-manager switch --rollback
```

### Optional: apply directly from Git without cloning

```sh
nix run home-manager/master -- switch --flake github:dblnz/dev-env#azureuser
```

## Legacy Setup (Ansible + Docker)

> Note: The Ansible configuration in `configs/` is deprecated in favor of Nix.
> It's kept for reference during migration.

### Old Method: Configure localhost using Ansible

## Configure localhost using ansible

```bash
$ cd configs
$ ansible-playbook playbook.yml --ask-become-pass
```

Vim commands:
- :PackerSync
- :MasonUpdate
- :TsUpdate

## Build/Run in docker container

The following command will build the container locally and install all needed
tools on it.
```
$ ./build-ctr.sh
```

Run the following command to start the remote container:
```
$ ./run.sh
```

Set the following environment variables to configure the container:
- `LOCAL` - set to `1` to use the locally built container instead of the
  remote one

One can provide the `<src_dir>:<dest_dir>` parameter for a local
directory to be mapped on the container. Otherwise, the current directory
will be mapped to `/src` container directory.

## Configurations

### Fonts

Requires nerd-fonts-hack intallation

```powershell
$ choco install nerd-fonts-hack
```
