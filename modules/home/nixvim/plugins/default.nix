{...}: {
  imports = [
    ./bufdelete.nix
    ./bufferline.nix
    ./cmp.nix
    ./conform-nvim.nix
    ./copilot.nix
    ./git-conflict.nix
    ./lsp.nix
    ./lspsaga.nix
    ./lualine.nix
    ./neogen.nix
    ./notify.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./toggleterm.nix
    ./treesitter.nix
  ];

  plugins = {
    web-devicons.enable = true;

    which-key.enable = true;

    nvim-autopairs.enable = true;

    comment.enable = true;

    gitsigns.enable = true;

    luasnip.enable = true;

    markdown-preview.enable = true;
  };
}
