{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    pre-commit = {
      check.enable = system == "x86_64-linux";

      settings.hooks = {
        # Common
        check-added-large-files.enable = true;
        check-case-conflicts.enable = true;
        check-executables-have-shebangs.enable = true;
        end-of-file-fixer.enable = true;
        mixed-line-endings.enable = true;
        trim-trailing-whitespace.enable = true;

        # Data serialization formats
        taplo.enable = true;
        yamlfmt = {
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

        commitizen = {
          enable = true;
          stages = ["commit-msg"];
        };

        flake-check = {
          enable = true;
          name = "flake check";
          entry = "${pkgs.nix}/bin/nix flake check --all-systems";
          pass_filenames = false;
          stages = ["pre-push"];
        };

        # Nix
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
      };
    };
  };

  imports = [
    inputs.pre-commit-hooks.flakeModule
  ];
}
