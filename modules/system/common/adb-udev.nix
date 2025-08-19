{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.services.adb;
in {
  options.mimonix.services.adb = {
    enable = mkEnableOption "Android Debug Bridge udev rules";
  };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [android-udev-rules];
  };
}
