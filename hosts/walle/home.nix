{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/desktop/hyprland
    ../../modules/home/programs

    # Custom
    ./home/hyprland.nix
  ];

  # Enable mimonix home modules using the new options system
  mimonix = {
    home.base.enable = true;
    shell.enable = true;
    programs = {
      nixvim.enable = true;
      enable = true;
      git.enable = true;
      direnv.enable = true;
      kitty.enable = true;
    };
    desktop.hyprland.home.enable = true;
  };
}
