{
  description = "dotnet development environment";

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
          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            dotnet-sdk
            dotnet-runtime

            git
            curl
            unzip
            jq
          ];

          shellHook = ''
            # Configure .NET environment
            export DOTNET_ROOT="${pkgs.dotnet-sdk}"
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
            export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            export DOTNET_NOLOGO=1

            # Add .NET tools to PATH
            export PATH="$HOME/.dotnet/tools:$PATH"

            # Set up NuGet config to use system packages when possible
            export NUGET_PACKAGES="$HOME/.nuget/packages"

            echo ".NET SDK version:"
            dotnet --version
            echo ""
            echo "PATH includes .NET tools: $HOME/.dotnet/tools"
            echo ""
          '';
        };
      };
    };
}
