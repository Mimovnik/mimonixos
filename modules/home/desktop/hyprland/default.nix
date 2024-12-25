{
  imports = [
    ./packages.nix
    ../../common/gtk.nix
  ];

  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };

  home.file.".config/hypr/wallpapers" = {
    source = ../../../../assets/wallpapers;
    recursive = true;
  };
}
