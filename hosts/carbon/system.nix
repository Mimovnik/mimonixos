{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/kde

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam

    ../../modules/system/virtualisation/docker.nix
  ];

  # Enable mimonix modules using the new options system
  mimonix = {
    system.base.enable = true;
    system.boot.enable = true;
    desktop.kde.system.enable = true;
    programs.steam.enable = true;
    virtualisation.docker.enable = true;
  };
}
