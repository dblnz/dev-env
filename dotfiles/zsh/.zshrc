# =============================================================================
# Zsh Configuration
# =============================================================================

# ----- Oh My Zsh -----------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  sudo
  docker
  kubectl
  rust
  golang
  python
  tmux
  colored-man-pages
  command-not-found
  history-substring-search
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ----- Environment ----------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ----- PATH -----------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"

# ----- History --------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.local/share/zsh/history"
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# ----- Aliases --------------------------------------------------------------
alias grep="grep --color"
alias egrep="egrep --color"
alias tree="tree -C"
alias ll="ls -l"
alias la="ls -la"
alias ..="cd .."
alias ...="cd ../.."

# Git shortcuts
alias g="git"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Dev environment
alias dev-apply='cd "${DEVUP_DIR:-$HOME/.local/share/devup}" && make setup'

# ----- Key Bindings ---------------------------------------------------------
# Ctrl-Space to accept autosuggestion
bindkey '^ ' autosuggest-accept

# Better history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Edit command line in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Colors
autoload -U colors && colors

# ----- Tool Integrations ----------------------------------------------------

# FZF
if command -v fzf >/dev/null 2>&1; then
  # Source fzf keybindings and completion
  if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    source /opt/homebrew/opt/fzf/shell/completion.zsh
  elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

# Zoxide (smarter cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# mise (runtime version manager)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# ----- Devup Update Check ---------------------------------------------------
DEVUP_DIR="${DEVUP_DIR:-$HOME/.local/share/devup}"
DEVUP_REPO="${DEVUP_REPO:-dblnz/dev}"

devup-update() {
  local install_dir="${DEVUP_DIR}"
  local repo="${DEVUP_REPO}"
  local api_url="https://api.github.com/repos/${repo}/releases/latest"

  echo "Fetching latest release..."
  local latest_tag
  latest_tag=$(curl -sf "$api_url" | jq -r '.tag_name // empty')

  if [[ -z "$latest_tag" ]]; then
    echo "Could not fetch latest release. Trying latest commit on main..."
    latest_tag=$(curl -sf "https://api.github.com/repos/${repo}/commits/main" | jq -r '.sha[:8] // empty')
    if [[ -z "$latest_tag" ]]; then
      echo "Error: Could not reach GitHub API."
      return 1
    fi
    local tarball_url="https://github.com/${repo}/archive/refs/heads/main.tar.gz"
  else
    local tarball_url="https://github.com/${repo}/archive/refs/tags/${latest_tag}.tar.gz"
  fi

  echo "Downloading ${latest_tag}..."
  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap "rm -rf '$tmp_dir'" EXIT

  curl -sL "$tarball_url" | tar xz -C "$tmp_dir" --strip-components=1

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download release."
    return 1
  fi

  # Sync to install dir
  mkdir -p "$install_dir"
  rsync -a --delete "$tmp_dir/" "$install_dir/"
  echo "$latest_tag" > "$install_dir/.version"

  echo "Applying configuration..."
  cd "$install_dir" && make setup

  echo "Updated to ${latest_tag}."
}

__devup_check_update() {
  local version_file="${DEVUP_DIR}/.version"
  local repo="${DEVUP_REPO}"

  # Skip if no install dir
  [[ -d "$DEVUP_DIR" ]] || return

  # Only check once per day (cache in /tmp)
  local cache_file="/tmp/.devup-check-$(id -u)"
  local now
  now=$(date +%s)

  if [[ -f "$cache_file" ]]; then
    local last_check
    last_check=$(cat "$cache_file" 2>/dev/null || echo 0)
    local age=$(( now - last_check ))
    # Skip if checked less than 24 hours ago
    (( age < 86400 )) && return
  fi

  # Run check in background to avoid slowing terminal startup
  (
    local current_version=""
    [[ -f "$version_file" ]] && current_version=$(cat "$version_file")

    local latest_tag
    latest_tag=$(curl -sf --connect-timeout 2 "https://api.github.com/repos/${repo}/releases/latest" | jq -r '.tag_name // empty' 2>/dev/null)

    # Fall back to commit SHA if no releases
    if [[ -z "$latest_tag" ]]; then
      latest_tag=$(curl -sf --connect-timeout 2 "https://api.github.com/repos/${repo}/commits/main" | jq -r '.sha[:8] // empty' 2>/dev/null)
    fi

    echo "$now" > "$cache_file"

    if [[ -n "$latest_tag" && "$latest_tag" != "$current_version" ]]; then
      echo "$latest_tag" > "/tmp/.devup-latest-$(id -u)"
    else
      rm -f "/tmp/.devup-latest-$(id -u)"
    fi
  ) &>/dev/null &!

  # Show notification from previous check
  local latest_file="/tmp/.devup-latest-$(id -u)"
  if [[ -f "$latest_file" ]]; then
    local latest
    latest=$(cat "$latest_file")
    echo "\033[1;33m⚡ devup update available (${latest}). Run \`devup-update\` to apply.\033[0m"
  fi
}

__devup_check_update
