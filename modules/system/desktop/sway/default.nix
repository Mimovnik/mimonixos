{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sway
    wl-clipboard
  ];

  # NVIDIA-specific environment variables for Wayland
  environment.sessionVariables = {
    # NVIDIA Wayland support
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway --unsupported-gpu > /tmp/sway.log 2>&1";
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
