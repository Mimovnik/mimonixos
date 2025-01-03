{pkgs, ...}: {
  imports = [
    ../../common/sddm.nix
  ];

  environment.systemPackages = with pkgs; [
    kitty
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
    pam.services.hyprlock = {};
    polkit = {
      enable = true;
    };
  };

  services = {
    dbus = {
      implementation = "broker";
      packages = with pkgs; [gcr];
    };
    gnome = {
      gnome-keyring.enable = true;
    };
  };
}
