{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = config.pre-commit.devShell;
    formatter = pkgs.alejandra;
  };
}
