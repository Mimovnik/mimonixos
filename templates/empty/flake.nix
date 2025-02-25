{
  description = "Empty development shell template";

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
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShellNoCC {
          # The Nix packages provided in the environment
          # Add any you need here
          packages = with pkgs; [];

          # Set any environment variables for your dev shell
          env = {};

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
            echo "Devshell activated"
          '';
        };
      };
    };
}
