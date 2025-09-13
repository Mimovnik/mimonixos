{
  description = "Unity development environment with .NET 6 support";

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
        system,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          config.permittedInsecurePackages = [
            "dotnet-sdk-6.0.428"
            "dotnet-runtime-6.0.36"
          ];

          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET 6 SDK and runtime
            dotnet-sdk_6
            dotnet-runtime_6

            # Common Unity development dependencies
            mono
            msbuild

            # Additional tools for Unity development
            git
            git-lfs
            curl
            unzip

            # Graphics and audio libraries often needed by Unity
            libGL
            libGLU
            mesa
            xorg.libX11
            xorg.libXext
            xorg.libXrandr
            xorg.libXi
            xorg.libXcursor
            xorg.libXinerama
            alsa-lib
            pulseaudio
          ];

          # Environment variables for Unity and .NET
          DOTNET_ROOT = "${pkgs.dotnet-sdk_6}";

          shellHook = ''
            echo "Unity Development Environment"
            echo "============================="
            echo "Unity Hub is not included in this environment."
            echo ""
            echo ".NET SDK version:"
            dotnet --version
            echo ""
            echo "Mono version:"
            mono --version | head -1
            echo ""
          '';
        };
      };
    };
}
