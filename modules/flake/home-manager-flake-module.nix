{inputs, ...}: {
  # This makes flake.homeModules and flake.homeConfigurations available to other modules.
  imports = [
    inputs.home-manager.flakeModules.default
  ];
}
