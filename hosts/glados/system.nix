{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base

    ../../modules/system/nvidia

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/docker.nix

    ../../modules/system/virtualisation/lxd.nix

    ../../modules/system/common/otd.nix
  ];
}
