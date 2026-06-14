{
  config,
  lib,
  pkgs,
  ...
}: let
  niriCfg = config.defaults.niri;
in {
  config = lib.mkIf niriCfg.enable {
    environment = {
      systemPackages = [
        pkgs.bibata-cursors
        pkgs.materia-theme
        pkgs.papirus-icon-theme
      ];

      sessionVariables = {
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        GTK_THEME = "Materia-dark";
      };

      etc = {
        "xdg/gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=Materia-dark
          gtk-icon-theme-name=Papirus
          gtk-cursor-theme-name=Bibata-Modern-Ice
          gtk-cursor-theme-size=24
          gtk-application-prefer-dark-theme=1
        '';

        "xdg/gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=Materia-dark
          gtk-icon-theme-name=Papirus
          gtk-cursor-theme-name=Bibata-Modern-Ice
          gtk-cursor-theme-size=24
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            gtk-theme = "Materia-dark";
            icon-theme = "Papirus";
            cursor-theme = "Bibata-Modern-Ice";
            cursor-size = lib.gvariant.mkUint32 24;
            color-scheme = "prefer-dark";
          };
        }
      ];
    };
  };
}
