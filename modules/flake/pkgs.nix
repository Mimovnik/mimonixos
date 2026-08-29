{
  inputs,
  flakeRoot,
  ...
}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = import ./_overlays.nix {inherit inputs flakeRoot;};
      config = {
        allowUnfree = true;
      };
    };
  };
}
