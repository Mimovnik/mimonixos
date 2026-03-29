{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [5555];
  networking.firewall.allowedUDPPorts = [];
}
