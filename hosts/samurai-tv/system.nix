{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ../../modules/system/base

    ../../modules/system/desktop/hyprland

    ../../modules/system/common/hostnames.nix

    ../../modules/system/steam
  ];

  disko.devices.disk.main.device = "/dev/sda";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPb0nrIl2mNjcXMmYWIMalZUGb9Kv/1htsLtqA8hYC/F mimovnik@walle"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdW1UbkbF0p1yTBh2CKv//RsDvot07/t7AtdNGeAsx/ mimo@glados"
  ];
}
