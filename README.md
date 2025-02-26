# Development Setup

This repository contains my personal development setup.

The setup is based on a container in which all the needed
tools are installed.

The tools configuration can be used to setup local machine or other hosts by
using `ansible`.

Development Tools:
- bash configuration
- Docker
- git configuration
- golang
- neovim - text editor with packer plugins
    - fugitive
    - harpoon    - bookmarks files for easy switch between files
    - lsp        - language server plugin
    - nvim-tree  - directory tree pane
    - telescope  - fuzzy finder
    - treesitter - syntax highlighter
    - undo-tree  - file history
- rust programming language with multiple tools
- tmux - terminal multiplexer
- zellij - terminal multiplexer
- zsh - shell
    - oh-my-zsh
    - zsh-autosuggestions
    - zsh-syntax-highlighting

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
