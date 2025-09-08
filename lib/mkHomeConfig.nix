{
  inputs,
  system,
  hostname,
  username,
  ...
}: let
  home-manager = inputs.home-manager;
  nixpkgs = inputs.nixpkgs;
  nixpkgs-unstable = inputs.nixpkgs-unstable;
  nixvim = inputs.nixvim;

  overlays = import ../overlays {inherit nixpkgs-unstable;};

  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
in
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ../hosts/${hostname}/home.nix
      {
        nix.package = pkgs.lixPackageSets.stable.lix;
      }
    ];
    extraSpecialArgs = {
      inherit system username nixvim nixpkgs-unstable;
    };
  }
