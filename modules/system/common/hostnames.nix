{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.networking.hostnames;
in {
  options.mimonix.networking.hostnames = {
    enable = mkEnableOption "local hostnames configuration";
  };

  config = mkIf cfg.enable {
    networking.hosts = {
      "192.168.3.2" = ["glados"];
      "192.168.3.3" = ["pimox"];
      "192.168.3.4" = ["dryer"];
      "192.168.3.5" = ["samurai-tv"];
      "192.168.3.6" = ["walle"];
    };
  };
}
