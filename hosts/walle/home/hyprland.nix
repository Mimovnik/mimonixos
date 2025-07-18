{lib, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = let
      builtinMonitor = "eDP-1";
      tv = "HDMI-A-1";
    in {
      "$mainMod" = lib.mkForce "ALT";

      monitor = [
        "${builtinMonitor}, disable"
        "${tv},preferred,auto,1.2"
      ];
      workspace =
        [
          "1, on-created-empty: $browser"
        ]
        ++ (builtins.concatLists (builtins.genList (i: let
            ws = i + 1;
          in [
            "${toString ws}, monitor:${tv}"
          ])
          10));
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "hyprctl dispatch dpms off";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          # Screen off
          {
            timeout = 3600; # 1 hour
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
