{
  description = "Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Node.js
            nodejs_22  # or nodejs_20, nodejs_18
            
            # Package managers
            yarn
            pnpm
            
            # Development tools
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages.eslint
            nodePackages.prettier
            nodePackages.npm-check-updates
            
            # Build tools (if needed for native modules)
            python3
            gcc
            gnumake
          ];

          shellHook = ''
            echo "Node.js development environment"
            echo "node: $(node --version)"
            echo "npm: $(npm --version)"
            
            # Create .npmrc if it doesn't exist
            if [ ! -f .npmrc ]; then
              echo "prefix=\''${PWD}/.npm-packages" > .npmrc
            fi
            
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      }
    );
}
