{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/programs
    ../../modules/home/desktop-apps
    ../../modules/home/desktop/sway

    # Custom
    ./home/programs.nix
  ];

  # Enable Sway window manager
  mimo.sway = {
    enable = true;
    mod = "Mod1"; # Alt key
  };
}
