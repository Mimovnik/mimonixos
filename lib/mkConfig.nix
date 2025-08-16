{
  inputs,
  system,
  hostname,
  username,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  nixpkgs-unstable = inputs.nixpkgs-unstable;
  lix-module = inputs.lix-module;
  disko = inputs.disko;
  home-manager = inputs.home-manager;
  plasma-manager = inputs.plasma-manager;
  nixvim = inputs.nixvim;
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

      lix-module.nixosModules.default

      disko.nixosModules.disko

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ../hosts/${hostname}/home.nix;
          sharedModules = [plasma-manager.homeManagerModules.plasma-manager];

          extraSpecialArgs = {
            inherit system;
            inherit username;
            inherit nixvim;
          };
        };
      }
    ];
  }
