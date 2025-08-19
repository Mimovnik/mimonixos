{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/programs
    ../../modules/home/desktop-apps
    ../../modules/home/desktop/kde

    # Custom
    ./home/programs.nix
  ];

  # Enable mimonix home modules using the new options system
  mimonix = {
    home.base.enable = true;
    shell.enable = true;
    programs = {
      nixvim.enable = true;
      enable = true;  # for basic CLI programs
      git.enable = true;
      direnv.enable = true;
      kitty.enable = true;
    };
    desktop = {
      apps.enable = true;
      kde.home.enable = true;
    };
  };
}
