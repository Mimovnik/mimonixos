{lib, ...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/desktop/sway
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/programs
    ../../modules/home/desktop-apps
  ];

  # Enable Sway window manager
  mimo.sway = {
    enable = true;
    workspaceOutputs = lib.listToAttrs (
      map (ws: {
        name = toString ws;
        value = "HDMI-A-2";
      }) [1 2 3 4 5]
      ++ map (ws: {
        name = toString ws;
        value = "DVI-D-1";
      }) [6 7 8 9 10]
    );

    # Configure monitor positioning
    outputs = {
      "HDMI-A-2" = {
        # Left monitor (2560x1440)
        position = "0 0";
        resolution = "2560x1440";
      };
      "DVI-D-1" = {
        # Right monitor (1920x1080) - positioned after HDMI-A-2's 2560px width
        position = "2560 0";
        resolution = "1920x1080";
      };
    };
  };
}
