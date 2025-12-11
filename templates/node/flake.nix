{
  description = "Node.js devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_22
            # pkgs.chromium
            # pkgs.yaak # run it with 'yaak-app'
          ];

          shellHook = ''
            echo "Node.js: $(node --version)"
          '';
        };
      };
    };
}
