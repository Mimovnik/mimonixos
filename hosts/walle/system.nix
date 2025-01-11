{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam
  ];
}
