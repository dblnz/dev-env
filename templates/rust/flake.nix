# This nix flake follows the example from:
# https://github.com/hyperlight-dev/hyperlight/blob/main/flake.nix
{
  description = "Rust development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla/master";
  outputs = { self, nixpkgs, nixpkgs-mozilla, ... } @ inputs:
    {
      devShells.x86_64-linux.default =
        let pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [ (import (nixpkgs-mozilla + "/rust-overlay.nix")) ];
            };
        in with pkgs; let
          # Work around the nixpkgs-mozilla equivalent of
          # https://github.com/NixOS/nixpkgs/issues/278508 and an
          # incompatibility between nixpkgs-mozilla and makeRustPlatform
          rustChannelOf = args: let
            orig = pkgs.rustChannelOf args;
            patchRustPkg = pkg: (pkg.overrideAttrs (oA: {
              buildCommand = builtins.replaceStrings
                [ "rustc,rustdoc" ]
                [ "rustc,rustdoc,clippy-driver,cargo-clippy" ]
                oA.buildCommand;
            })) // {
              targetPlatforms = [ "x86_64-linux" ];
              badTargetPlatforms = [ ];
            };
            overrideRustPkg = pkg: lib.makeOverridable (origArgs:
              patchRustPkg (pkg.override origArgs)
            ) {};
          in builtins.mapAttrs (_: overrideRustPkg) orig;

          customisedRustChannelOf = args:
            lib.flip builtins.mapAttrs (rustChannelOf args) (_: pkg: pkg.override {
              targets = [
                "x86_64-unknown-linux-gnu"
                "x86_64-pc-windows-msvc" "x86_64-unknown-none"
                "wasm32-wasip1" "wasm32-wasip2" "wasm32-unknown-unknown"
              ];
              extensions = [ "rust-src" ];
            });

          # Use specific toolchain
          # To add another one you need to get the release date for the specific version,
          # and then use:
          # ```bash
          # date="2025-08-07"
          # channel="stable" # or "nightly"
          # url="https://static.rust-lang.org/dist/$date/channel-rust-$channel.toml"
          # nix store prefetch-file "$url" --hash-type sha256 --json | jq -r '.hash' 
          # ```
          # to get the sha256 for that version's channel file.
          toolchains = lib.mapAttrs (_: customisedRustChannelOf) {
              # Stay on 1.89
            stable = {
              date = "2025-08-07";
              channel = "stable";
              sha256 = "sha256-+9FmLhAOezBZCOziO0Qct1NOrfpjNsXxc/8I0c7BdKE=";
            };
            nightly = {
              date = "2025-08-07";
              channel = "nightly";
              sha256 = "sha256-jX+pQa3zzuCnR1fRZ0Z4L2hXLP3JoGOcpbL4vI853EA=";
            };
            "1.91.1" = {
              date = "2025-11-10";
              channel = "stable";
              sha256 = "sha256-SDu4snEWjuZU475PERvu+iO50Mi39KVjqCeJeNvpguU=";
            };
          };

          rust-platform = makeRustPlatform {
            cargo = toolchains.stable.rust;
            rustc = toolchains.stable.rust;
          };

          # Cargo can be used in a number of ways that don't
          # make sense for Nix cargo, including the `rustup +toolchain`
          # syntax to use a specific toolchain and `cargo install`.
          # So we build wrappers for rustc and cargo that enable this.
          # Using `rustup toolchain install` needs to work, so we provide
          # a fake rustup that does nothing as well.
          rustup-like-wrapper = name: pkgs.writeShellScriptBin name
            (let
              clause = name: toolchain:
                "+${name}) base=\"${toolchain.rust}\"; shift 1; ;;";
              clauses = lib.strings.concatStringsSep "\n"
                (lib.mapAttrsToList clause toolchains);
            in ''
          base="${toolchains.stable.rust}"
          case "$1" in
            ${clauses}
            install) exit 0; ;;
          esac
          export PATH="$base/bin:$PATH"
          exec "$base/bin/${name}" "$@"
        '');
          fake-rustup = pkgs.symlinkJoin {
            name = "fake-rustup";
            paths = [
              (pkgs.writeShellScriptBin "rustup" "")
              (rustup-like-wrapper "rustc")
              (rustup-like-wrapper "cargo")
            ];
          };

          buildRustPackageClang = rust-platform.buildRustPackage.override { stdenv = clangStdenv; };
        in (buildRustPackageClang rec {
          pname = "rust-template";
          version = "0.0.0";
          src = lib.cleanSource ./.;
          cargoHash = "sha256-7Op6f0MWTAM4ElARNnypz72BxUnKcvrUafKDKGaxqL8=";

          nativeBuildInputs = [
            just
            jaq
            jq
            lld
            llvmPackages_18.llvm
            pkg-config
            valgrind
          ];
          buildInputs = [
            pango
            cairo
            openssl
          ];

          auditable = false;

          LIBCLANG_PATH = "${pkgs.llvmPackages_18.libclang.lib}/lib";

          RUST_NIGHTLY = "${toolchains.nightly.rust}";
          # Set this through shellHook rather than nativeBuildInputs
          # to ensure that it overrides the real cargo.
          shellHook = ''
            export PATH="${fake-rustup}/bin:$PATH"
          '';
        }).overrideAttrs(oA: {
          hardeningDisable = [ "all" ];
        });
    };
}
