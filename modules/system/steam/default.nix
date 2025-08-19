{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.programs.steam;
in {
  options.mimonix.programs.steam = {
    enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
