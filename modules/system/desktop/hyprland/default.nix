{pkgs, ...}: {
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "${import ../../common/sddm-chili-theme.nix {inherit pkgs;}}";
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    egl-wayland
    xwayland
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
