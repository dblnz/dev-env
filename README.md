# Development Setup

This repository contains my personal development environment configuration using **Nix and Home Manager** for cross-platform compatibility (Linux and macOS).

## 🚀 Quick Start (New Nix Setup)

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
- ✅ Git configuration with aliases and GPG signing
- ✅ Zsh with Oh-My-Zsh, plugins, and modern tools
- ✅ Bash with custom prompt and aliases
- ✅ Tmux with vim-style navigation and themes
- ✅ Modern CLI tools (bat, eza, ripgrep, fd, fzf, etc.)
- ✅ Starship prompt
- ✅ Direnv for per-project environments

**Read [NIX_README.md](NIX_README.md) for detailed documentation.**  
**See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for command cheatsheet.**

---

## 📦 Development Tools Included

- **Shell**: zsh (with oh-my-zsh), bash
- **Terminal Multiplexers**: tmux, zellij
- **Editor**: neovim (configuration coming soon)
- **Version Control**: git with delta diff viewer
- **CLI Tools**: bat, eza, ripgrep, fd, fzf, htop, btop, jq, yq
- **Dev Environments**: Project templates for Rust, C/C++, Node.js, Python, Go

## 🎯 Project Templates

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

## 📚 Documentation

- **[NIX_README.md](NIX_README.md)** - Complete Nix setup guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheatsheet
- **[Makefile](Makefile)** - Common operations (`make help`)

---

## 🔧 Legacy Setup (Ansible + Docker)

> ⚠️ **Note**: The Ansible configuration in `configs/` is deprecated in favor of Nix.
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
