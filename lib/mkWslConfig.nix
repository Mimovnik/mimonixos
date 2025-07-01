{
  nixpkgs,
  nixpkgs-unstable,
  lix-module,
  home-manager,
  nixos-wsl,
  system,
  hostname,
  nixvim,
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

    lix-module.nixosModules.default

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
