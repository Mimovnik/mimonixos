{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sway
    wl-clipboard
  ];

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway > /tmp/sway.log 2>&1";
          user = "${username}";
        };
      };
    };

    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
  };

  programs = {
    dconf.enable = true;
    ydotool.enable = true;
    seahorse.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  security = {
    polkit.enable = true;
    pam = {
      services = {
        swaylock = {};
        greetd.enableGnomeKeyring = true;
      };
    };
  };

  # Enable seat management
  services.seatd.enable = true;
  users.users.${username}.extraGroups = ["seat"];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["wlr" "gtk"];
  };
}
