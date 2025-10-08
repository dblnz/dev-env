{
  description = "Go development environment";

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
            # Go
            go
            
            # Development tools
            gopls          # Language server
            gotools        # Various Go tools
            go-tools       # staticcheck and other tools
            golangci-lint  # Linter
            delve          # Debugger
            
            # Additional tools
            gomodifytags   # Modify struct tags
            gotests        # Generate tests
            impl           # Generate interface implementations
          ];

          shellHook = ''
            echo "Go development environment"
            echo "go: $(go version)"
            
            # Set up Go environment
            export GOPATH="$HOME/go"
            export PATH="$GOPATH/bin:$PATH"
          '';
        };
      }
    );
}
