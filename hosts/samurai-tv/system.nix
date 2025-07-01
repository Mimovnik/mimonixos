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

  disko.devices.disk.main.device = "/dev/sda";
}
