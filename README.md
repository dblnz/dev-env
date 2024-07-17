# Purpose
This repository contains a development setup from scratch.

The setup is based on a container in which all the needed
tools are installed.

The tools configuration can be used to setup local machine or other hosts by
using `ansible`.

Development Tools:
- Docker
- Nvim - text editor
    - fugitive
    - harpoon    - bookmarks files for easy switch between files
    - lsp        - language server plugin
    - nvim-tree  - directory tree pane
    - telescope  - fuzzy finder
    - treesitter - syntax highlighter
    - undo-tree  - file history
- zellij - terminal multiplexer

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

The following command will build the container and install all needed
tools on it.
```
$ ./build-ctr.sh
```

Run the following command to start a container and ssh into it.
```
$ ./run.sh
```

One can provide the `-v <src_dir>:<dest_dir>` parameter for a local
directory to be mapped on the container.

## Configurations

### Fonts

Requires nerd-fonts-hack intallation

```powershell
$ choco install nerd-fonts-hack
```

### GIT Configuration
The git configuration is set to use the ED25519 key generated during the
container build.

The user and email are set to the following:
```bash
git config --global user.email "email"
git config --global user.name "name"

# For signing commits
git config --global gpg.format ssh
git config --global user.signingkey /PATH/TO/.SSH/KEY.PUB
```

## Key configuration

When running the build step, the script will generate a RSA key for use
inside the container.

One can configure that key to be used for a wide range of scenarios:
- git ssh key
- login key to other hosts

## Git signature setup

A major part of the configuration of git commit signoff is already done,
however, the only steps needed to run are:
```
$ eval $(ssh-agent)
$ ssh-add ~/.ssh/id_rsa
```

This will use the generated key to sign the commits. The corresponding
public key `~/.ssh/id_rsa.pub` needs to be configured in Github for
correct verification.

Test to see if it works:
```
$ git commit -S --allow-empty -m "Test"
$ git show --show-signature
```

The signature should be shown as verified correctly.

