{ config, pkgs, lib, nvim-config ? null, ... }:

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

    # Neovim configuration:
    # - Point to your existing lua config (current approach below)
    
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
      # Add more as needed from your Mason setup
      
      # Formatters
      stylua
      nixpkgs-fmt
      
      # Other tools
      ripgrep
      fd
      tree-sitter
    ];
  };

  # Copy your existing neovim configuration
  # This preserves your LazyVim setup
  # 
  # Configuration can come from:
  # 1. Git repository (via flake input 'nvim-config') - preferred for version control
  # 2. Local path (../../configs/nvim/files/nvim) - fallback for local development
  #
  # To use a git repository:
  # 1. Uncomment the 'nvim-config' input in flake.nix
  # 2. Update the URL to point to your nvim config repository
  # 3. The repository should contain your nvim config at the root (init.lua, lua/, etc.)
  xdg.configFile."nvim" = {
    source = if nvim-config != null 
      then nvim-config 
      else ../../configs/nvim/files/nvim;
    recursive = true;
  };
}