{
  description = "Mimo's nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:Mimovnik/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    disko,
    home-manager,
    nixvim,
    systems,
    pre-commit-hooks,
    ...
  } @ inputs: let
    mkConfig = import ./lib/mkConfig.nix;

    forAllSystems = nixpkgs.lib.genAttrs (import systems);

    username = "mimovnik";
  in {
    nixosConfigurations = {
      glados = mkConfig {
        system = "x86_64-linux";
        hostname = "glados";
        inherit nixpkgs disko home-manager nixvim username;
      };

      glados-vm = mkConfig {
        system = "x86_64-linux";
        hostname = "glados-vm";
        inherit nixpkgs disko home-manager nixvim username;
      };

      walle = mkConfig {
        system = "x86_64-linux";
        hostname = "walle";
        inherit nixpkgs disko home-manager nixvim username;
      };

      samurai-tv = mkConfig {
        system = "x86_64-linux";
        hostname = "samurai-tv";
        inherit nixpkgs disko home-manager nixvim username;
      };
    };

    checks = forAllSystems (system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
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
            excludes = ["^(.*\.j2\.yml)$"];
          };
          check-json.enable = true;
          pretty-format-json = {
            enable = true;
            args = ["--autofix" "--top-keys=version,metadata"];
          };

          # Git
          check-merge-conflicts.enable = true;

          # Nix
          alejandra.enable = true;
        };
      };
    });

    devShells = forAllSystems (system: {
      default = let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.mkShellNoCC {
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
    });
  };
}
