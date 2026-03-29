{
  inputs,
  nixpkgs,
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
        inherit inputs;
        inherit hostname;
        inherit username;
        inherit system;
      };
    }
  ];
}
