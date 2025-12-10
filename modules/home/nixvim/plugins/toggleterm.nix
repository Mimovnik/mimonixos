{
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<A-i>]]";
      hide_numbers = true;
      start_in_insert = true;
      terminal_mappings = true;
      persist_mode = true;
      insert_mappings = true;
      close_on_exit = true;
      shell = "zsh";
      direction = "float";
      auto_scroll = true;
      float_opts = {
        border = "curved";
        width = 120;
        height = 30;
        winblend = 0;
      };
    };
  };
}
