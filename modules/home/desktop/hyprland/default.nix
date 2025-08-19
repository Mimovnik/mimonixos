{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.desktop.hyprland.home;
in {
  imports = [
    ./packages.nix
    ../../common/gtk.nix
    ./swayosd.nix
    ./swaync.nix
  ];

  options.mimonix.desktop.hyprland.home = {
    enable = mkEnableOption "Hyprland Wayland compositor configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };

      xwayland.enable = true;

      settings = import ./config.nix {inherit lib;};

      # The submap is in extraConfig and not in config.nix due to:
      # https://github.com/nix-community/home-manager/issues/6062
      extraConfig = ''
        submap = resize
        binde = , right, resizeactive, 10 0
      binde = , l, resizeactive, 10 0

      binde = , left, resizeactive, -10 0
      binde = , h, resizeactive, -10 0

      binde = , up, resizeactive, 0 -10
      binde = , k, resizeactive, 0 -10

      binde = , down, resizeactive, 0 10
      binde = , j, resizeactive, 0 10

      bind = , escape, submap, reset
      bind = $mainMod, R, submap, reset
      submap = reset
    '';
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

  services = {
    hypridle = lib.mkDefault {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
          before_sleep_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # Dim
          {
            timeout = 150; # 2.5min.
            on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 10";
            on-resume = "${lib.getExe pkgs.brightnessctl} -r";
          }
          # Lock
          {
            timeout = 900; # 15min
            on-timeout = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
          }
          # Screen off
          {
            timeout = 990; # 16.5min
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
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
  };
}
