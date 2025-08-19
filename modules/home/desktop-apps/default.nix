{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.desktop.apps;
in {
  options.mimonix.desktop.apps = {
    enable = mkEnableOption "desktop applications for graphical environment";
  };

  config = mkIf cfg.enable {
    # Programs that are useful only in desktop environment (so not in wsl for example)
    home.packages = with pkgs; [
      pavucontrol
      playerctl

      godot
      # aseprite
      vorta
      obs-studio
      firefox
      kdePackages.kdenlive
      vesktop
      brave
      unstable.signal-desktop
      anki
      krita
      onlyoffice-bin
      nautilus
      gnome-disk-utility
      nextcloud-client
    ];
  };
}
