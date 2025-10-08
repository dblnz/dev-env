{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        # Rust toolchain
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust toolchain
            rustToolchain
            
            # Build tools
            pkg-config
            
            # Development tools
            cargo-watch
            cargo-edit
            cargo-outdated
            cargo-audit
            cargo-tarpaulin  # Code coverage
            
            # Optional: useful libraries
            openssl
            
            # Debugging
            gdb
            lldb
          ];

          shellHook = ''
            echo "Rust development environment"
            echo "rustc: $(rustc --version)"
            echo "cargo: $(cargo --version)"
          '';
        };
      }
    );
}
