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
    go
    nodejs_24
    typescript

    # Development tools
    git
    git-lfs
    gh  # GitHub CLI
 
    # Editors

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

    # System monitoring
    duf        # Better df
    dust       # Better du

    # Terminal enhancements
    tmux
    zellij     # Modern terminal multiplexer

    # Multiplexer plugin managers
    # (tmux plugins will be managed by home-manager)
  ];
}
