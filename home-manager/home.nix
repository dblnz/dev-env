{ config, pkgs, lib, ... }:

{
  # Import all module configurations
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/bash.nix
    ./modules/tmux.nix
    ./modules/common-packages.nix
    ./modules/cli-tools.nix
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic home configuration
  home = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    stateVersion = "24.05";

    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    # Session path additions
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable XDG base directories
  xdg.enable = true;
}
