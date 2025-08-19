{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

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
  };

  disko.devices.disk.main.device = "/dev/sda";
}
