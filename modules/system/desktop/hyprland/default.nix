{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.desktop.hyprland;
in {
  imports = [
    ../../common/sddm.nix
  ];

  options.mimonix.desktop.hyprland = {
    enable = mkEnableOption "Hyprland Wayland compositor";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty

      seahorse # gnome keyring gui manager
    ];

    programs.hyprland = {
      enable = true;
      systemd.setPath.enable = true;
      xwayland.enable = true;
    };

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

    security = {
      pam.services = {
        hyprlock = {};
        sddm.enableGnomeKeyring = true;
      };

      polkit = {
        enable = true;
      };
    };

    services = {
      dbus = {
        implementation = "broker";
        packages = with pkgs; [gcr];
      };
      gnome.gnome-keyring.enable = true;
    };
  };
}
