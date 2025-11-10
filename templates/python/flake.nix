{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Python
            python
            
            # Development tools
            python311Packages.pip
            python311Packages.virtualenv
            
            # Linting and formatting
            python311Packages.black
            python311Packages.flake8
            python311Packages.pylint
            python311Packages.mypy
            
            # Language server
            python311Packages.python-lsp-server
            
            # Optional: Common packages
            # python311Packages.numpy
          ];

          shellHook = ''
            echo "Python development environment"
            echo "python: $(python --version)"
            echo "pip: $(pip --version)"
            
            # Create virtual environment if it doesn't exist
            if [ ! -d .venv ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            
            # Activate virtual environment
            source .venv/bin/activate
            
            export PYTHONPATH="$PWD:$PYTHONPATH"
          '';
        };
      }
    );
}
