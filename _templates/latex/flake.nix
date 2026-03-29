{
  description = "Latex nix environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {system, ...}: let
        pkgs = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShellNoCC {
          # The Nix packages provided in the environment
          # Add any you need here
          buildInputs = with pkgs; [
            texliveFull
          ];

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
            echo "Welcome to the latex devshell"
            export PATH=$PATH:${pkgs.texliveFull}/bin

            lualatex --version | head -n 1
          '';
        };
      };
    };
}
