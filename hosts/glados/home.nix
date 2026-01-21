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
  mimo.sway = let
    leftMon = "DP-1";
    rightMon = "DVI-D-1";
  in {
    enable = true;
    workspaceOutputs = lib.listToAttrs (
      map (ws: {
        name = toString ws;
        value = leftMon;
      }) [1 2 3 4 5]
      ++ map (ws: {
        name = toString ws;
        value = rightMon;
      }) [6 7 8 9 10]
    );

    # Configure monitor positioning
    outputs = {
      "DP-1" = {
        position = "0 0";
        resolution = "2560x1440";
      };
      "DVI-D-1" = {
        position = "2560 0";
        resolution = "1920x1080";
      };
    };
  };
}
