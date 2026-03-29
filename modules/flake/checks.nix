{inputs, ...}: {
  perSystem = {system, ...}: {
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
  };
}
