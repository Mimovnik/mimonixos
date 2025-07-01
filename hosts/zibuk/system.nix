{
  lib,
  system,
  ...
}: {
  imports = [
    ../../modules/system/base

    ../../modules/system/common/hostnames.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault system;

  wsl = {
    enable = true;
    defaultUser = "nixos";
    # defaultUser = config._module.args.username;
  };
}
