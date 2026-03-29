{pkgs, ...}: {
  imports = [
    ../../modules/home/base
    ../../modules/home/shell
    ../../modules/home/nixvim
    ../../modules/home/programs

    ./home/git.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
