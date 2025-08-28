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
}
