{
  lib,
  system,
  ...
}: {
  imports = [
    ../../modules/system/base

    ../../modules/system/common/hostnames.nix

    ../../modules/system/virtualisation/docker.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    # defaultUser = config._module.args.username;
  };
}
