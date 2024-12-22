{
  description = "Mimo's nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:Mimovnik/nixvim";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    mkConfig = import ./lib/mkConfig.nix;

    username = "mimovnik";
  in {
    nixosConfigurations = {
      glados-vm = mkConfig {
        system = "x86_64-linux";
        hostname = "glados-vm";
        inherit nixpkgs home-manager username;
      };
    };
  };
}
