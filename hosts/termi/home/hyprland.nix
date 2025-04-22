{lib, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = lib.mkForce "ALT";

      animations.enabled = lib.mkForce false;
    };
  };
}
