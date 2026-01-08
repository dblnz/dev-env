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
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      flatbuffersOverlay = final: prev: let
        version = "25.9.23";
      in {
          flatbuffers = prev.flatbuffers.overrideAttrs (old: {
          inherit version;
          src = prev.fetchFromGitHub {
              owner = "google";
              repo = "flatbuffers";
              rev = "v${version}";
              hash = "sha256-A9nWfgcuVW3x9MDFeviCUK/oGcWJQwadI8LqNR8BlQw=";
          };
          });
      };

      # Helper function to create home-manager configuration
      mkHome = { system, username, homeDirectory, extraModules ? [] }:
        let
          # Share the same pkgs for both module scope and inline usage
          pkgsForHome = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ flatbuffersOverlay ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsForHome;

          modules = [
            ./home-manager/home.nix
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "25.05";
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
      overlays.default = flatbuffersOverlay;

      # Home Manager configurations for different systems
      homeConfigurations = {
        # Linux configuration
        "dblnz@linux" = mkHome {
          system = "x86_64-linux";
          username = "dblnz";
          homeDirectory = "/home/dblnz";
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

      # Development shells
      devShells = lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          platformInfo = {
            "x86_64-linux" = {
              claudePlatform = "linux-x64";
              codexAsset = {
                name = "codex-x86_64-unknown-linux-gnu.tar.gz";
                hash = "sha256-qkoT2tww6m6ybalOe5LgGDTBwEtc9Fr4HJTW83PS+C0=";
              };
              copilotAsset = {
                name = "copilot-linux-x64.tar.gz";
                hash = "sha256-2kTBEpgq0rJkUHNQFagN2VBYySxZ35MmPwlIglLAHLU=";
              };
            };
            "aarch64-linux" = {
              claudePlatform = "linux-arm64";
              codexAsset = {
                name = "codex-aarch64-unknown-linux-gnu.tar.gz";
                hash = "sha256-VAY9+AcnH7XkSJHGR1gXVjv21qzVF/ngIzw7h04XTaE=";
              };
              copilotAsset = {
                name = "copilot-linux-arm64.tar.gz";
                hash = "sha256-ki6U3wy9ez/Wilp9oBJzta6eoVk+Gi26gaS1C+4x2lo=";
              };
            };
            "x86_64-darwin" = {
              claudePlatform = "darwin-x64";
              codexAsset = {
                name = "codex-x86_64-apple-darwin.tar.gz";
                hash = "sha256-j11kKOwjatRpytxhluAAqJg2ZHTBtUM9i1O8WIyfucA=";
              };
              copilotAsset = {
                name = "copilot-darwin-x64.tar.gz";
                hash = "sha256-jNnCexSg9JIbZJPFkuLEopo+yNQbwBBQTTdC+AsLyVM=";
              };
            };
            "aarch64-darwin" = {
              claudePlatform = "darwin-arm64";
              codexAsset = {
                name = "codex-aarch64-apple-darwin.tar.gz";
                hash = "sha256-fwHZr05y5HNVf6qjI936Bk0VBqdZ9CWYOoWqX6cJo+o=";
              };
              copilotAsset = {
                name = "copilot-darwin-arm64.tar.gz";
                hash = "sha256-1mBj9wZ3er1SDR+pfrDYeK0hny5r71aiy6E3ioKjAzQ=";
              };
            };
          }.${system} or (throw "Unsupported system: ${system}");

          claudePlatform = platformInfo.claudePlatform;
          codexArtifact = platformInfo.codexAsset;
          copilotArtifact = platformInfo.copilotAsset;

          codexInnerName = pkgs.lib.removeSuffix ".tar.gz" codexArtifact.name;

          opensslLib = pkgs.openssl.out;

          copilotRpath = pkgs.lib.makeLibraryPath [ pkgs.glibc pkgs.stdenv.cc.cc.lib ];

          # GitHub Copilot CLI (GitHub release binaries)
          copilot-cli = pkgs.stdenv.mkDerivation rec {
            pname = "copilot-cli";
            version = "0.0.376";

            src = pkgs.fetchurl {
              name = copilotArtifact.name;
              url = "https://github.com/github/copilot-cli/releases/download/v${version}/${copilotArtifact.name}";
              hash = copilotArtifact.hash;
            };

            dontUnpack = true;
            dontStrip = true;
            dontPatchELF = true;

            nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.patchelf ];
            buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.glibc pkgs.stdenv.cc.cc.lib ];

            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              tar -xzf $src -C $out/bin copilot
            '' + pkgs.lib.optionalString pkgs.stdenv.isLinux ''
              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                       --set-rpath "${copilotRpath}" \
                       $out/bin/copilot
            '' + ''
              chmod +x $out/bin/copilot
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "GitHub Copilot CLI";
              homepage = "https://github.com/github/copilot-cli";
              license = licenses.mit;
            };

            mainProgram = "copilot";
          };

          # Codex CLI (GitHub release binaries)
          codex-cli = pkgs.stdenv.mkDerivation rec {
            pname = "codex-cli";
            version = "0.79.0";

            src = pkgs.fetchurl {
              name = codexArtifact.name;
              url = "https://github.com/openai/codex/releases/download/rust-v${version}/${codexArtifact.name}";
              hash = codexArtifact.hash;
            };

            dontUnpack = true;
            dontStrip = true;
            dontPatchELF = true;

            nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.patchelf pkgs.makeWrapper ];
            buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.stdenv.cc.cc.lib opensslLib ];

            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              tar -xzf $src -C $out/bin ${codexInnerName}
              mv $out/bin/${codexInnerName} $out/bin/codex
            '' + pkgs.lib.optionalString pkgs.stdenv.isLinux ''
              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                       --set-rpath "${opensslLib}/lib:${pkgs.stdenv.cc.cc.lib}/lib" \
                       $out/bin/codex
              wrapProgram $out/bin/codex \
                --set LD_LIBRARY_PATH "${opensslLib}/lib:${pkgs.stdenv.cc.cc.lib}/lib"
            '' + ''
              chmod +x $out/bin/codex
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "OpenAI Codex CLI";
              homepage = "https://github.com/openai/codex";
              license = licenses.asl20;
            };

            mainProgram = "codex";
          };

          # Claude Code CLI - fetched directly and patched for NixOS
          # - The binary lives in /nix/store/... (immutable, cached)
          # - It's only available inside the shell
          # - Exits cleanly when you leave - no pollution to your environment
          claude-code = pkgs.stdenv.mkDerivation rec {
            pname = "claude-code";
            version = "2.1.1";

            src = pkgs.fetchurl {
              name = "claude-code-${version}-${claudePlatform}";
              url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${claudePlatform}/claude";
              sha256 = "sha256-fWMBJr1vqDcnIKSAVahYaXQbB2sUNEAEXIlWXPPGWig=";
            };

            dontUnpack = true;
            dontBuild = true;

            # Claude is a self-contained executable with an embedded Bun runtime and JS bundle.
            # The default fixup phase corrupts it:
            # - dontStrip: `strip` removes "debug symbols" but actually destroys embedded resources
            # - dontPatchELF: Automatic rpath shrinking breaks the binary's internal library resolution
            dontStrip = true;
            dontPatchELF = true;

            nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.patchelf ];
            buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.stdenv.cc.cc.lib ];

            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              install -m755 $src $out/bin/claude
            '' + pkgs.lib.optionalString pkgs.stdenv.isLinux ''
              # Only patch the interpreter for NixOS compatibility.
              # The binary expects /lib64/ld-linux-x86-64.so.2 which doesn't exist on NixOS.
              # Don't set rpath - the binary handles its own library resolution.
              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                       $out/bin/claude
            '' + ''
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Claude Code - AI-powered coding assistant CLI";
              homepage = "https://claude.ai/code";
              license = licenses.unfree;
              mainProgram = "claude";
            };
          };
        in
        {
          # Claude Code CLI shell
          claude = pkgs.mkShell {
            name = "claude-code-shell";

            packages = [
              claude-code
              pkgs.git
            ];

            shellHook = ''
              echo "Claude Code CLI ready (from nix store)"
              echo "Run 'claude' to start"
            '';
          };

          # Codex CLI shell (only exposes codex)
          codex = pkgs.mkShell {
            name = "codex-shell";

            packages = [
              codex-cli
              pkgs.git
            ];

            shellHook = ''
              echo "Codex CLI ready (from nix store)"
              echo "Run 'codex' to start"
            '';
          };

          # Copilot CLI shell
          copilot = pkgs.mkShell {
            name = "copilot-shell";

            packages = [
              copilot-cli
              pkgs.git
            ];

            shellHook = ''
              echo "Copilot CLI ready (from nix store)"
              echo "Run 'copilot' to start"
            '';
          };

          # Default shell
          default = pkgs.mkShell {
            name = "dev-shell";
            packages = with pkgs; [
              git
              nodejs_22
            ];
          };
        }
      );
    };
}
