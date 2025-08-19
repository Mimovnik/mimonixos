{
  config,
  lib,
  nixvim,
  system,
  ...
}:
with lib; let
  cfg = config.mimonix.programs.nixvim;
  nixvim' = nixvim.packages.${system}.default;
  nvim = nixvim'.extend {
    config.vimAlias = true;
  };
in {
  options.mimonix.programs.nixvim = {
    enable = mkEnableOption "Nixvim - Neovim configuration in Nix";
  };

  config = mkIf cfg.enable {
    home.packages = [nvim];
  };
}
