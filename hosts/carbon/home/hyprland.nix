{lib, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = lib.mkForce "ALT";

      # monitor = [
      #   "eDP-1,preferred,auto,1.2"
      # ];
    };
  };
}
