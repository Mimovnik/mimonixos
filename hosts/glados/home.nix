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
        value = "HDMI-A-1";
      }) [1 2 3 4 5]
      ++ map (ws: {
        name = toString ws;
        value = "DVI-I-1";
      }) [6 7 8 9 10]
    );
  };
}
