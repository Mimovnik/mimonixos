{
  config,
  lib,
  username,
  ...
}:
with lib; let
  cfg = config.mimonix.virtualisation.docker;
in {
  options.mimonix.virtualisation.docker = {
    enable = mkEnableOption "Docker containerization platform";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];
  };
}
