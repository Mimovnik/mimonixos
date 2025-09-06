{
  pkgs,
  lib,
  browser,
  terminal,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils # for xdg-open etc.
    playerctl # for controlling media player apps
    wl-clipboard # wayland clipboard management
    sway-contrib.grimshot # screenshot script
    mimo.sway-battery-notify # battery level notifications
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true; # enables sway-session.target

    swaynag = {
      enable = true;
      settings = {
        "<config>" = {
          font = "Raleway 12";
          dismiss-button = "⨯";

          button-border-size = "0";
          border-bottom-size = "0";
          details-border-size = "0";
          button-padding = "6";
          button-gap = "12";
        };
        "warning" = {
          background = "ffff0090";
          button-background = "A2620280";
          text = "ffffffff";
          button-text = "ffffffff";
        };
      };
    };

    config = {
      defaultWorkspace = "workspace number 1";

      bars = []; # disable default bars
      startup = [
        # Start waybar
        {command = "waybar";}

        # Battery notification script
        {command = "sway-battery-notify";}

        /*
        by default in Wayland, copy-paste only happens *on pasting*
        so if you copy, close the source application, and try to paste, it's not there
        wl-clip-persist acts as a middleman, persisting the clipboard contents
        */
        {command = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";}

        /*
        Polkit agent, Gnome edition. Allows authentication via graphical dialog through polkit
        service.

        See: https://wiki.archlinux.org/title/Polkit
        */
        {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}

        # Autostart apps on specific workspaces
        {command = "${terminal} --app-id terminal & sleep 2 && swaymsg '[app_id=\"terminal\"] move scratchpad'";}

        {command = "${browser}     & sleep 10 && swaymsg '[title=\"Brave\"]   move workspace 1'";}
        {command = "signal-desktop & sleep 10 && swaymsg '[title=\"Signal\"]  move workspace 5'";}
        {command = "vesktop        & sleep 10 && swaymsg '[title=\"Discord\"] move workspace 7'";}
      ];
      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = true;
      };
    };
  };

  # GTK theme
  home.sessionVariables.GTK_THEME = "Materia-dark";

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 22;
  };

  # MIME app associatons only make sense on graphical systems, as they use .desktop files as base
  xdg.mimeApps = let
    # helpers for easier setting of a program as default for multiple MIME types
    setForAll = mimeApp: mimeTypes: lib.attrsets.genAttrs mimeTypes (_: mimeApp);
    defaults = lib.attrsets.concatMapAttrs setForAll {
      "feh.desktop" = [
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/tiff"
        "image/webp"
        "image/heic"
        "image/x-sony-arw"
      ];
    };
  in {
    enable = true;
    # set all defaults as added assiociations, because it can't hurt in case one isn't there already
    associations.added = defaults;
    # this is what actually sets the default apps
    defaultApplications = defaults;
  };

  # desktop notifications
  services.swaync = {
    enable = true;
    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      notification-inline-replies = true;
      positionX = "right";
      positionY = "top";
      widgets = [
        "title"
        "dnd"
        "notifications"
        "mpris"
        "volume"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰩹";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          blur = true;
        };
        volume = {
          label = "󰓃";
          show-per-app = false;
        };
      };
    };
  };

  # on-screen displays like volume control and brightness
  services.swayosd = {
    enable = true;
    topMargin = 0.1;
  };

  # for automounting USB sticks etc.
  services.udiskie.enable = true;

  # for controlling media playback, e.g. via hotkeys
  services.playerctld.enable = true;
}
