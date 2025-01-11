{lib, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = let
      monitor = "HDMI-A-1";
    in {
      "$mainMod" = lib.mkForce "ALT";

      monitor = [
        "${monitor},preferred,auto,1.2"
      ];
      workspace =
        [
          "1, on-created-empty: $browser"
        ]
        ++ (builtins.concatLists (builtins.genList (i: let
            ws = i + 1;
          in [
            "${toString ws}, monitor:${monitor}"
          ])
          10));
    };
  };
}
