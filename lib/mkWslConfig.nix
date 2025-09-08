{
  nixpkgs,
  nixpkgs-unstable,
  nixos-wsl,
  system,
  hostname,
  username,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    nixos-wsl.nixosModules.default

    ../hosts/${hostname}/system.nix

    {
      _module.args = {
        inherit nixpkgs-unstable;
        inherit hostname;
        inherit username;
        inherit system;
      };
    }
  ];
}
