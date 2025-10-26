{
  description = "C/C++ development environment";

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
            # Compilers
            gcc
            clang
            
            # Build systems
            cmake
            gnumake
            ninja
            meson
            
            # Development tools
            ccache
            clang-tools  # clangd, clang-format, clang-tidy
            
            # Debugging
            gdb
            lldb
            valgrind
            
            # Libraries
            pkg-config
            
            # Optional: Common libraries
            # openssl
            # zlib
            # libxml2
          ];

          shellHook = ''
            echo "C/C++ development environment"
            echo "gcc: $(gcc --version | head -n1)"
            echo "clang: $(clang --version | head -n1)"
          '';
        };
      }
    );
}
