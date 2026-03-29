{
  flake.nixosModules.systemCommonTailscale = {
    services.tailscale.enable = true;
  };
}
