{...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/desktop/hyprland
    ../../modules/home/programs
    ../../modules/home/desktop-apps
    ./home/hyprland.nix
  ];
}
