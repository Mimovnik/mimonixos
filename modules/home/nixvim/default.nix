{
  flake.homeModules.homeNixvim = {
    programs.nixvim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      imports = [
        ./_keymaps.nix
        ./_opts.nix
        ./_plugins
        ./_colorscheme.nix
      ];
    };
  };
}
