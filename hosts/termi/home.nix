{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/desktop/hyprland
    ../../modules/home/programs
    ../../modules/home/desktop-apps

    # Custom
    ./home/hyprland.nix
    ./home/programs.nix
  ];
}
