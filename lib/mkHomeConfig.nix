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
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      inputs.nixvim.homeModules.nixvim
      ../hosts/${hostname}/home.nix
      {
        nix.package = pkgs.lixPackageSets.stable.lix;
      }
    ];
    extraSpecialArgs = {
      inherit inputs system username;
    };
  }
