{
  nixpkgs,
  nixpkgs-unstable,
  lix-module,
  home-manager,
  system,
  hostname,
  nixvim,
  username,
  disko,
  ...
}:
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

        extraSpecialArgs = {
          inherit system;
          inherit username;
          inherit nixvim;
        };
      };
    }
  ];
}
