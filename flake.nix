{
  description = "dblnz's system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:dblnz/nvim-dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      # Helper function to create home-manager configuration
      mkHome = { system, username, homeDirectory, extraModules ? [] }: 
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          modules = [
            ./home-manager/home.nix
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "24.05";
              };
              # Pass the nvim-config input to modules if it exists
              _module.args = {
                nvim-config = inputs.nvim-config;
              };
            }
          ] ++ extraModules;
        };
    in
    {
      # Home Manager configurations for different systems
      homeConfigurations = {
        # Linux configuration
        "dblnz@linux" = mkHome {
          system = "x86_64-linux";
          username = "azureuser";
          homeDirectory = "/home/azureuser";
          extraModules = [ ./home-manager/linux.nix ];
        };

        # macOS configuration
        "dblnz@darwin" = mkHome {
          system = "aarch64-darwin";  # Apple Silicon
          username = "dblnz";
          homeDirectory = "/Users/dblnz";
          extraModules = [ ./home-manager/darwin.nix ];
        };

        # macOS Intel configuration
        "dblnz@darwin-intel" = mkHome {
          system = "x86_64-darwin";  # Intel Mac
          username = "dblnz";
          homeDirectory = "/Users/dblnz";
          extraModules = [ ./home-manager/darwin.nix ];
        };
      };

      # Templates for project-specific development environments
      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust development environment";
        };
        
        c = {
          path = ./templates/c;
          description = "C/C++ development environment";
        };
        
        node = {
          path = ./templates/node;
          description = "Node.js development environment";
        };

        python = {
          path = ./templates/python;
          description = "Python development environment";
        };

        go = {
          path = ./templates/go;
          description = "Go development environment";
        };
      };
    };
}
