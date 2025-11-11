{ config, pkgs, lib, ... }:

{
  # Common packages available across all systems
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnused
    gnugrep
    gawk

    # Compilers/Interpretors
    # These should be installed via project flakes to avoid version conflicts

    # Development tools
    cmake           # Build system generator
    gnumake         # Make build tool
    git
    git-lfs
    gh  # GitHub CLI
 
    # Editors
    # Nvim is set up via the neovim module

    # Shell utilities
    bat        # Better cat
    eza        # Better ls
    fd         # Better find
    ripgrep    # Better grep
    fzf        # Fuzzy finder
    tree       # Directory tree
    htop       # Process viewer
    btop       # Better htop

    # File management
    rsync
    wget
    curl

    # Compression tools
    gzip
    bzip2
    xz
    zip
    unzip

    # Network tools
    dig
    nmap

    # JSON/YAML tools
    jq         # JSON processor
    yq-go      # YAML processor

    # Shells
    bash
    zsh

    # System monitoring
    duf        # Better df
    dust       # Better du

    # Wasm for use with wasm modules
    wasm-tools
    wkg

    # Terminal enhancements
    tmux

    # Multiplexer plugin managers
    # (tmux plugins will be managed by home-manager)
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-powerlevel10k
  ];
}
