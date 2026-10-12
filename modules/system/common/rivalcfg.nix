{
  flake.nixosModules.systemCommonRivalcfg = {
    pkgs,
    username,
    ...
  }: let
    rivalcfg = pkgs.unstable.rivalcfg;
  in {
    environment.systemPackages = [rivalcfg];
    services.udev.packages = [rivalcfg];
    users.users.${username}.extraGroups = ["input"];

    systemd.services.rivalcfg = {
      description = "Configure SteelSeries Rival 5";
      wantedBy = ["multi-user.target"];
      after = ["systemd-udev-settle.service"];
      wants = ["systemd-udev-settle.service"];

      serviceConfig.Type = "oneshot";
      script = ''
        ${rivalcfg}/bin/rivalcfg \
          --sensitivity 800 \
          --led-brightness 50 \
          --wheel-color yellow \
          --left-strip-top-color yellow \
          --right-strip-top-color yellow \
          --left-strip-middle-top-color yellow \
          --right-strip-middle-top-color yellow \
          --left-strip-middle-bottom-color yellow \
          --right-strip-middle-bottom-color yellow \
          --left-strip-bottom-color yellow \
          --right-strip-bottom-color yellow \
          --logo-color yellow \
          --buttons "buttons(layout=QWERTY; button1=button1; button2=button2; button3=button3; button4=button4; button5=button5; button6=F9; button7=F10; button8=F8; button9=F11; scrollup=scrollup; scrolldown=scrolldown)"
      '';
    };
  };
}
