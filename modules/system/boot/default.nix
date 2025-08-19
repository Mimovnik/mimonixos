{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.system.boot;
in {
  options.mimonix.system.boot = {
    enable = mkEnableOption "systemd-boot configuration";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.tmp.cleanOnBoot = true;
  };
}
