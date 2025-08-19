{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.services.fprintd;
in {
  options.mimonix.services.fprintd = {
    enable = mkEnableOption "fingerprint authentication service";
  };

  config = mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
