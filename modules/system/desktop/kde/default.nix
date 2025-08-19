{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.desktop.kde.system;
in {
  imports = [../../common/fprintd.nix];
  
  options.mimonix.desktop.kde.system = {
    enable = mkEnableOption "KDE Plasma 6 desktop environment";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      desktopManager.plasma6.enable = true;
    };

    security.pam.services = {
      sddm.fprintAuth = true;
      kscreenlocker.fprintAuth = true;
      sudo.fprintAuth = false;
    };
  };
}
