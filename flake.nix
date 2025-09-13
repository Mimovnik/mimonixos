{
  description = "Mimo's nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixvim.url = "github:Mimovnik/nixvim";

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
    plasma-manager,
    nixvim,
    systems,
    pre-commit-hooks,
    nixos-wsl,
    ...
  } @ inputs: let
    mkConfig = import ./lib/mkConfig.nix;

    mkWslConfig = import ./lib/mkWslConfig.nix;

    mkHomeConfig = import ./lib/mkHomeConfig.nix;

    forAllSystems = nixpkgs.lib.genAttrs (import systems);

    username = "mimovnik";
  in {
    nixosConfigurations = {
      glados = mkConfig {
        system = "x86_64-linux";
        hostname = "glados";
        inherit inputs username;
      };

      glados-vm = mkConfig {
        system = "x86_64-linux";
        hostname = "glados-vm";
        inherit inputs username;
      };

      walle = mkConfig {
        system = "x86_64-linux";
        hostname = "walle";
        inherit inputs username;
      };

      samurai-tv = mkConfig {
        system = "x86_64-linux";
        hostname = "samurai-tv";
        inherit inputs username;
      };

      dryer = mkConfig {
        system = "x86_64-linux";
        hostname = "dryer";
        inherit inputs username;
      };

      carbon = mkConfig {
        system = "x86_64-linux";
        hostname = "carbon";
        inherit inputs username;
      };

      termi = mkConfig {
        system = "x86_64-linux";
        hostname = "termi";
        inherit inputs username;
      };

      zibuk = mkWslConfig {
        system = "x86_64-linux";
        hostname = "zibuk";
        username = "nixos";
        inherit nixpkgs nixpkgs-unstable nixos-wsl;
      };
    };

    homeConfigurations = {
      "${username}@glados" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "glados";
        inherit inputs username;
      };

      "${username}@glados-vm" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "glados-vm";
        inherit inputs username;
      };

      "${username}@walle" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "walle";
        inherit inputs username;
      };

      "${username}@samurai-tv" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "samurai-tv";
        inherit inputs username;
      };

      "${username}@dryer" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "dryer";
        inherit inputs username;
      };

      "${username}@carbon" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "carbon";
        inherit inputs username;
      };

      "${username}@termi" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "termi";
        inherit inputs username;
      };

      "nixos@zibuk" = mkHomeConfig {
        system = "x86_64-linux";
        hostname = "zibuk";
        username = "nixos";
        inherit inputs;
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
          commitizen.enable = true;

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

    templates = import ./templates;
  };
}
