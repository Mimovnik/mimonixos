{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      device = {
        name = "steelseries-steelseries-rival-300-gaming-mouse";
        sensitivity = -1.0;
      };

      monitor = [
        "HDMI-A-1,preferred,0x0,1.25"
        "DVI-I-1,preferred,auto,1.2"
      ];

      workspace =
        builtins.concatLists (builtins.genList (i: let
            ws = i + 1;
            gladosLeftMon = "HDMI-A-1";
            gladosRightMon = "DVI-I-1";
          in [
            "${toString ws}, monitor:${
              if ws <= 5
              then toString gladosLeftMon
              else toString gladosRightMon
            }"
          ])
          10);

      env = [
        # Nvidia
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
    };
  };
}
