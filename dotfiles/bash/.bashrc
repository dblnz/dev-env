# =============================================================================
# Bash Configuration
# =============================================================================

# ----- Environment ----------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ----- PATH -----------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"

# ----- History --------------------------------------------------------------
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s cmdhist

# ----- Shell Options --------------------------------------------------------
shopt -s checkwinsize
shopt -s autocd 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

# ----- Prompt ---------------------------------------------------------------
__PS1_BLUE="\[$(tput setaf 4)\]"
__PS1_CYAN="\[$(tput setaf 6)\]"
__PS1_GREEN="\[$(tput setaf 2)\]"
__PS1_RED="\[$(tput setaf 1)\]"
__PS1_YELLOW="\[$(tput setaf 3)\]"
__PS1_CLEAR="\[$(tput sgr0)\]"
export PS1="${__PS1_RED}[\A]${__PS1_GREEN} \u@\h:${__PS1_CLEAR}[${__PS1_CYAN}\W${__PS1_CLEAR}]# "

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

# ----- Completion -----------------------------------------------------------
if [[ -r /etc/bash_completion ]]; then
  source /etc/bash_completion
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

# ----- Tool Integrations ----------------------------------------------------

# Starship prompt (overrides PS1 above)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi
