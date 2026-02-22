# =============================================================================
# Dev Environment Makefile
# =============================================================================

INSTALL_DIR ?= $(HOME)/.local/share/devup
ANSIBLE_DIR := ansible
INVENTORY   := $(ANSIBLE_DIR)/inventory/localhost.yml
PLAYBOOK    := $(ANSIBLE_DIR)/playbook.yml

# On Linux some tasks need sudo (apt install, chsh).
# Pass ASK_BECOME=--ask-become-pass explicitly when needed,
# or set ANSIBLE_BECOME_ASK_PASS=true in your env.
ASK_BECOME ?=

.PHONY: setup update tags help

## setup: Run the full Ansible playbook
setup:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ASK_BECOME)

## update: Pull latest release and re-run setup
update:
	@echo "Updating devup to latest version..."
	@if command -v zsh >/dev/null 2>&1; then \
		zsh -ic 'devup-update'; \
	else \
		bash -c 'source $(HOME)/.zshrc 2>/dev/null; devup-update'; \
	fi

## tags: Run only specific roles (e.g., make tags TAGS=dotfiles,shell)
tags:
ifndef TAGS
	@echo "Usage: make tags TAGS=base,shell,neovim,mise,rust,dotfiles"
	@exit 1
endif
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ASK_BECOME) --tags "$(TAGS)"

## dotfiles: Re-stow dotfiles only
dotfiles:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ASK_BECOME) --tags dotfiles

## shell: Re-apply shell config only
shell:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ASK_BECOME) --tags shell,dotfiles

## neovim: Re-apply neovim config only
neovim:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ASK_BECOME) --tags neovim

## help: Show this help
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## //' | column -t -s ':'
