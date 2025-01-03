{config, pkgs, ...}: {
  imports = [
    ./packages.nix
    ../../common/gtk.nix
    ./swayosd.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    xwayland.enable = true;

    settings = import ./config.nix;
  };

  home.file = {
    ".config/hypr" = {
      source = ./hypr;
      recursive = true;
    };

    ".config/hypr/wallpapers" = {
      source = ../../../../assets/wallpapers;
      recursive = true;
    };

    ".config/hypr/sfx" = {
      source = ../../../../assets/sfx;
      recursive = true;
    };
  };

  # https://github.com/hyprwm/hyprland-wiki/issues/409
  # https://github.com/nix-community/home-manager/pull/4707
  xdg.portal = {
    config = {
      common = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };
    configPackages = [config.wayland.windowManager.hyprland.package];
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    xdgOpenUsePortal = true;
  };
}
