{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = import ./_overlays.nix inputs;
      config = {
        allowUnfree = true;
      };
    };
  };
}
