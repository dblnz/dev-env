#!/usr/bin/env bash
# =============================================================================
# Devup Bootstrap
# Usage:
#   Fresh machine:  curl -sL https://github.com/dblnz/devup/releases/latest/download/devup.sh | bash
#   From clone:     ./devup.sh
# =============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO="dblnz/dev"
INSTALL_DIR="${DEVUP_DIR:-$HOME/.local/share/devup}"

info()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ---------------------------------------------------------------------------
# 1. Detect OS
# ---------------------------------------------------------------------------
detect_os() {
  case "$(uname -s)" in
    Darwin) OS="darwin" ;;
    Linux)  OS="linux" ;;
    *)      error "Unsupported OS: $(uname -s)" ;;
  esac
  info "Detected OS: $OS"
}

# ---------------------------------------------------------------------------
# 2. Install system prerequisites
# ---------------------------------------------------------------------------
install_prerequisites() {
  if [[ "$OS" == "darwin" ]]; then
    # Install Xcode CLI tools if needed
    if ! xcode-select -p &>/dev/null; then
      warn "Installing Xcode Command Line Tools..."
      xcode-select --install
      # Wait for installation
      until xcode-select -p &>/dev/null; do sleep 5; done
    fi

    # Install Homebrew if needed
    if ! command -v brew &>/dev/null; then
      warn "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Add brew to PATH for this session
      if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi
    info "Homebrew ready"

  elif [[ "$OS" == "linux" ]]; then
    # Ensure basic tools exist
    local missing=()
    for cmd in curl git jq rsync; do
      command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      warn "Installing missing tools: ${missing[*]}..."
      sudo apt-get update -qq
      sudo apt-get install -yqq "${missing[@]}"
    fi
    info "System prerequisites ready"
  fi
}

# ---------------------------------------------------------------------------
# 3. Install Ansible
# ---------------------------------------------------------------------------
install_ansible() {
  if command -v ansible-playbook &>/dev/null; then
    info "Ansible already installed"
    return
  fi

  warn "Installing Ansible..."
  if [[ "$OS" == "darwin" ]]; then
    brew install ansible
  elif [[ "$OS" == "linux" ]]; then
    # Use pipx to avoid PEP 668 externally-managed-environment errors
    if ! command -v pipx &>/dev/null; then
      sudo apt-get install -yqq pipx
    fi
    pipx install --include-deps ansible
    pipx ensurepath
    export PATH="$HOME/.local/bin:$PATH"
  fi
  info "Ansible installed"
}

# ---------------------------------------------------------------------------
# 4. Get devup (release-based or use local clone)
# ---------------------------------------------------------------------------
get_devup() {
  # If running from inside the repo, use it directly
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ -f "$script_dir/ansible/playbook.yml" ]]; then
    info "Running from local clone at $script_dir"
    # Copy to install dir so we have a stable installed copy
    mkdir -p "$INSTALL_DIR"
    rsync -a --delete \
      --exclude='.git' \
      "$script_dir/" "$INSTALL_DIR/"
    # Mark the version
    if command -v git &>/dev/null && git -C "$script_dir" rev-parse HEAD &>/dev/null; then
      git -C "$script_dir" describe --tags --always 2>/dev/null > "$INSTALL_DIR/.version" || \
        git -C "$script_dir" rev-parse --short HEAD > "$INSTALL_DIR/.version"
    else
      echo "local-$(date +%Y%m%d)" > "$INSTALL_DIR/.version"
    fi
    return
  fi

  # Otherwise, download latest release
  warn "Downloading latest devup release..."
  local api_url="https://api.github.com/repos/${REPO}/releases/latest"
  local latest_tag
  latest_tag=$(curl -sf "$api_url" | jq -r '.tag_name // empty')

  local tarball_url
  if [[ -n "$latest_tag" ]]; then
    tarball_url="https://github.com/${REPO}/archive/refs/tags/${latest_tag}.tar.gz"
  else
    warn "No releases found, using main branch..."
    latest_tag="main-$(date +%Y%m%d)"
    tarball_url="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"
  fi

  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap "rm -rf '$tmp_dir'" EXIT

  curl -sL "$tarball_url" | tar xz -C "$tmp_dir" --strip-components=1
  mkdir -p "$INSTALL_DIR"
  rsync -a --delete "$tmp_dir/" "$INSTALL_DIR/"
  echo "$latest_tag" > "$INSTALL_DIR/.version"
  info "Downloaded version: $latest_tag"
}

# ---------------------------------------------------------------------------
# 5. Run Ansible playbook
# ---------------------------------------------------------------------------
run_ansible() {
  info "Running Ansible playbook..."
  cd "$INSTALL_DIR"

  local ask_become=""
  if [[ "$OS" == "linux" ]]; then
    ask_become="--ask-become-pass"
  fi

  ansible-playbook \
    -i ansible/inventory/localhost.yml \
    ansible/playbook.yml \
    $ask_become

  info "Ansible playbook completed"
}

# ---------------------------------------------------------------------------
# 6. Finish
# ---------------------------------------------------------------------------
print_done() {
  echo ""
  info "Dev environment setup complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Restart your shell (or run: exec zsh)"
  echo "  2. Open nvim to let Mason install LSP servers"
  echo "  3. Run 'devup-update' anytime to update to the latest release"
  echo ""
  echo "Installed to: $INSTALL_DIR"
  echo "Version:      $(cat "$INSTALL_DIR/.version")"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  echo "====================================="
  echo "  Devup Bootstrap"
  echo "====================================="
  echo ""

  detect_os
  install_prerequisites
  install_ansible
  get_devup
  run_ansible
  print_done
}

main "$@"
