{
  inputs,
  hostname,
  username,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  disko = inputs.disko;
in
  nixpkgs.lib.nixosSystem {
    modules = [
      ../hosts/${hostname}/system.nix
      {
        _module.args = {
          inherit inputs;
          inherit hostname;
          inherit username;
        };
      }

      disko.nixosModules.disko
    ];
  }
