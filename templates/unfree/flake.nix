{
  description = "Unfree development shell template";

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
      perSystem = {
        config,
        lib,
        system,
        pkgs,
        ...
      }: let
        pkgs = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShellNoCC {
          # The Nix packages provided in the environment
          # Add any you need here
          buildInputs = with pkgs; [
            hello
          ];

          # Set any environment variables for your dev shell
          env = {
            HELLO = "Hello world!";
          };

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
            echo "Welcome to the devshell"
          '';
        };
      };
    };
}
