{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ../../modules/system/base

    ../../modules/system/nvidia

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/libvirt.nix

    ../../modules/system/virtualisation/bridge.nix

    ../../modules/system/virtualisation/docker.nix

    ../../modules/system/virtualisation/lxd.nix

    ../../modules/system/common/otd.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
