{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ./nvidia.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/sway

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/docker.nix

    ./adb-firewall.nix
  ];
}
