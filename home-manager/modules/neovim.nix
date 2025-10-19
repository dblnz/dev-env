{ config, pkgs, lib, nvim-config, ... }:

{
  programs.neovim = {
    enable = true;

    # Use neovim as the default editor
    defaultEditor = true;

    # Enable vi/vim aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Enable common remote providers for plugin ecosystems
    withNodeJs = true;
    withPython3 = true;

    extraLuaConfig = ''
      -- The lua config will be loaded from ~/.config/nvim
      -- This is just a placeholder for any additional Nix-managed config
    '';

    # Neovim plugins managed by Nix (optional)
    # The plugins are managed using lazy.nvim
    plugins = with pkgs.vimPlugins; [
      # Example: Core plugins
      # plenary-nvim
    ];

    # Additional packages available to Neovim
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil  # Nix LSP

      # Formatters
      stylua
      nixpkgs-fmt

      # Other tools
      ripgrep
      fd
      tree-sitter
    ];
  };

  # Configuration comes from:
  # - Git repository (via flake input 'nvim-config')
  xdg.configFile."nvim" = {
    source = nvim-config;
    recursive = true;
  };
}
