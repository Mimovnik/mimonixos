{
  description = "Mimo's nix configs";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    {
      imports = [
        (inputs.import-tree ./hosts)
        (inputs.import-tree ./modules)
      ];

      systems = import inputs.systems;

      flake.templates = import ./_templates;

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          default_stages = ["pre-commit" "pre-push"];
          hooks = {
            # Common
            check-added-large-files.enable = true;
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            end-of-file-fixer.enable = true;
            mixed-line-endings.enable = true;
            trim-trailing-whitespace.enable = true;
            # Data serialization formats
            check-toml.enable = true;
            check-yaml = {
              enable = true;
              excludes = ["^(.*\\.j2\\.yml)$"];
            };
            check-json.enable = true;
            pretty-format-json = {
              enable = true;
              args = ["--autofix" "--top-keys=version,metadata"];
            };
            # Git
            check-merge-conflicts.enable = true;
            commitizen.enable = true;
            # Nix
            alejandra.enable = true;
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          buildInputs = config.checks.pre-commit-check.enabledPackages;
          inherit (config.checks.pre-commit-check) shellHook;
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wifitui = {
      url = "github:shazow/wifitui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    maccel.url = "github:Gnarus-G/maccel";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  #       homeConfigurations = {
  #         "${username}@glados" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "glados";
  #           inherit inputs username;
  #         };
  #         "${username}@walle" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "walle";
  #           inherit inputs username;
  #         };
  #         "${username}@dryer" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "dryer";
  #           inherit inputs username;
  #         };
  #         "${username}@carbon" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "carbon";
  #           inherit inputs username;
  #         };
  #         "${username}@termi" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "termi";
  #           inherit inputs username;
  #         };
  #         "nixos@zibuk" = mkHomeConfig {
  #           system = "x86_64-linux";
  #           hostname = "zibuk";
  #           username = "nixos";
  #           inherit inputs;
  #         };
  #       };
  #
  #       templates = import ./templates;
  #     };
  # }
}
