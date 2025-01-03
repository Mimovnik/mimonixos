{
  nixvim,
  system,
  ...
}: let
  nixvim' = nixvim.packages.${system}.default;
  nvim = nixvim'.extend {
    config.vimAlias = true;
  };
in {
  home.packages = [nvim];
}
