{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      indent.enable = true;
      highlight.enable = true;
    };

    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };
}
