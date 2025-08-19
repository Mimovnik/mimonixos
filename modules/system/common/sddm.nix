{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.services.sddm;
in {
  options.mimonix.services.sddm = {
    enable = mkEnableOption "SDDM display manager with Chili theme";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
    ];

    services = {
      xserver.enable = true;

      # TODO: create custom sddm theme
      displayManager.sddm = {
        enable = true;
        theme = "${import ../../../pkgs/sddm-chili-theme-pkg.nix {inherit pkgs;}}";
      };
    };
  };
}
