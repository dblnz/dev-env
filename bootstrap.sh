#!/usr/bin/env bash
# Bootstrap script for setting up Nix and Home Manager

set -e

echo "🚀 Bootstrapping Nix development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    PROFILE="dblnz@linux"
    PROFILE="azureuser"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
    if [[ $(uname -m) == "arm64" ]]; then
        PROFILE="dblnz@darwin"
    else
        PROFILE="dblnz@darwin-intel"
    fi
else
    echo -e "${RED}Unsupported operating system: $OSTYPE${NC}"
    exit 1
fi

echo -e "${GREEN}Detected OS: $OS${NC}"
echo -e "${GREEN}Using profile: $PROFILE${NC}"

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${YELLOW}Nix is not installed. Installing Nix...${NC}"
    
    if [[ "$OS" == "darwin" ]]; then
        # macOS installation
        sh <(curl -L https://nixos.org/nix/install)
    else
        # Linux installation (multi-user)
        sh <(curl -L https://nixos.org/nix/install) --daemon
    fi
    
    # Source Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo -e "${GREEN}Nix is already installed${NC}"
fi

# Enable flakes
echo -e "${YELLOW}Enabling Nix flakes...${NC}"
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    echo -e "${GREEN}Flakes enabled${NC}"
else
    echo -e "${GREEN}Flakes already enabled${NC}"
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${YELLOW}Building and activating Home Manager configuration...${NC}"
cd "$SCRIPT_DIR"

# Initial Home Manager activation
nix run home-manager/master -- switch --flake ".#$PROFILE" -b backup

echo -e "${GREEN}✨ Bootstrap complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your shell or run: source ~/.nix-profile/etc/profile.d/hm-session-vars.sh"
echo "2. To apply future changes: home-manager switch --flake ."
echo "3. To create a project: nix flake init -t .#rust (or c, node, python, go)"
echo ""
echo "Read NIX_README.md for more information."
