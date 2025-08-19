{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.desktop.kde.home;
in {
  options.mimonix.desktop.kde.home = {
    enable = mkEnableOption "KDE Plasma user configuration";
    
    theme = mkOption {
      type = types.str;
      default = "org.kde.breezedark.desktop";
      description = "KDE look and feel theme";
    };
  };

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        lookAndFeel = cfg.theme;
      };
    };
  };
}
