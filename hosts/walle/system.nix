{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/desktop/sway

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam
  ];
}
