{...}: {
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    imports = [
      ./keymaps.nix
      ./opts.nix
      ./plugins
      ./colorscheme.nix
    ];
  };
}
