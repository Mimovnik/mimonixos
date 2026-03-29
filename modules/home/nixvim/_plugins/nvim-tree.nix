{
  plugins.nvim-tree = {
    enable = true;
    autoClose = true;
    settings = {
      hijack_cursor = true;
      update_focused_file.enable = true;
      git = {
        enable = true;
        ignore = true;
      };
    };
  };
}
