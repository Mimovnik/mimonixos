{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/docker.nix
  ];
}
