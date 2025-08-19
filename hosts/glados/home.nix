{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/programs
    ../../modules/home/desktop-apps
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
    desktop.apps.enable = true;
  };
}
