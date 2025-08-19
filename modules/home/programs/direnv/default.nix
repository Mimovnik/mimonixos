{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.programs.direnv;
in {
  options.mimonix.programs.direnv = {
    enable = mkEnableOption "direnv environment management";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = fromTOML (builtins.readFile ./direnv.toml);
    };
  };
}
