{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = fromTOML (builtins.readFile ./direnv.toml);
  };
}
