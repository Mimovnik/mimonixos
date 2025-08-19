{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam
  ];

  # Enable mimonix modules using the new options system
  mimonix = {
    system.base.enable = true;
    system.boot.enable = true;
    desktop.hyprland.enable = true;
    programs.steam.enable = true;
    networking.hostnames.enable = true;
  };
}
