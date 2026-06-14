{
  flake.homeModules.homeNixvim = {pkgs, ...}: {
    programs.nixvim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      nixpkgs.pkgs = pkgs;

      imports = [
        ./_keymaps.nix
        ./_opts.nix
        ./_plugins
        ./_colorscheme.nix
      ];
    };
  };
}
