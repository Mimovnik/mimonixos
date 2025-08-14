{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/cosmic

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/docker.nix
  ];
}
