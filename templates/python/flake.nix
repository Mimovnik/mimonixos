{
  description = "Python development shell template";

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
      perSystem = {pkgs, ...}: let
        python = pkgs.python312;
        pythonPackages = pkgs.python312Packages;
      in {
        devShells.default = pkgs.mkShellNoCC {
          buildInputs =
            [
              python
            ]
            ++ (with pythonPackages; [
              pip
              venvShellHook
            ]);
          venvDir = "venv";

          shellHook = ''
            runHook venvShellHook
            export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH

            echo "Welcome to Python devshell!"
          '';

          NIX_LD_LIBRARY_PATH = with pkgs;
            lib.makeLibraryPath [
              stdenv.cc.cc
              zlib
            ];
          NIX_LD = with pkgs; lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
        };
      };
    };
}
