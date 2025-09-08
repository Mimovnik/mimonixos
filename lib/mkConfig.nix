{
  inputs,
  system,
  hostname,
  username,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  nixpkgs-unstable = inputs.nixpkgs-unstable;
  disko = inputs.disko;
in
  nixpkgs.lib.nixosSystem {
    modules = [
      ../hosts/${hostname}/system.nix
      {
        _module.args = {
          inherit nixpkgs-unstable;
          inherit hostname;
          inherit username;
        };
      }

      disko.nixosModules.disko
    ];
  }
