{
  flake.nixosModules.systemBinfmt = {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
