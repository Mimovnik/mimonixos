{
  inputs,
  system,
  hostname,
  username,
  ...
}: let
  overlays = import ../overlays inputs;

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  nix-index-database = inputs.nix-index-database;
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      inputs.nixvim.homeModules.nixvim
      ../hosts/${hostname}/home.nix
      {
        nix.package = pkgs.lixPackageSets.stable.lix;
      }

      nix-index-database.homeModules.default
    ];
    extraSpecialArgs = {
      inherit inputs system username;
    };
  }
