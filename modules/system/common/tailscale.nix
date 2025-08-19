{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.services.tailscale;
in {
  options.mimonix.services.tailscale = {
    enable = mkEnableOption "Tailscale VPN service";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
