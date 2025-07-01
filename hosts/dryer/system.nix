{
  imports = [
    ./hardware-configuration.nix

    ./disko-config.nix

    ./zfs.nix

    ../../modules/system/base
    ../../modules/system/boot

    ../../modules/system/common/hostnames.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPb0nrIl2mNjcXMmYWIMalZUGb9Kv/1htsLtqA8hYC/F mimovnik@walle"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdW1UbkbF0p1yTBh2CKv//RsDvot07/t7AtdNGeAsx/ mimo@glados"
  ];
}
