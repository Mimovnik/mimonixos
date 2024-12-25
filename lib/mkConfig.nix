{
  nixpkgs,
  home-manager,
  system,
  hostname,
  nixvim,
  username
}:
nixpkgs.lib.nixosSystem {
  modules = [
    ../hosts/${hostname}/system.nix
    {
      _module.args = {
        inherit hostname;
        inherit username;
      };
    }

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
