{
  config,
  lib,
  pkgs,
  ...
}: let
  niriCfg = config.defaults.niri;
in {
  config = lib.mkIf niriCfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${niriCfg.package}/bin/niri-session";
        user = "greeter";
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
