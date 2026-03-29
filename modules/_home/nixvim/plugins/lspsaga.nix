{
  plugins.lspsaga = {
    enable = true;
    settings = {
      beacon = {
        enable = true;
      };

      ui = {
        border = "rounded"; # One of none, single, double, rounded, solid, shadow
        code_action = "💡";
      };

      hover = {
        open_cmd = "!brave"; # Choose your browser
        open_link = "gx";
      };

      diagnostic = {
        border_follow = true;
        diagnostic_only_current = false;
        show_code_action = true;
      };

      symbol_in_winbar = {
        enable = true; # Breadcrumbs
      };

      code_action = {
        extend_git_signs = false;
        show_server_name = true;
        only_in_cursor = true;
        num_shortcut = true;
        keys = {
          exec = "<CR>";
          quit = ["<Esc>" "q"];
        };
      };

      lightbulb = {
        enable = true;
        sign = false;
        virtual_text = true;
      };

      implement = {
        enable = false;
      };

      rename = {
        auto_save = false;
        keys = {
          exec = "<CR>";
          quit = ["<C-k>" "<Esc>"];
          select = "x";
        };
      };

      outline = {
        auto_close = true;
        auto_preview = true;
        close_after_jump = true;
        layout = "normal"; # normal or float
        win_position = "right"; # left or right
        keys = {
          jump = "e";
          quit = "q";
          toggle_or_jump = "o";
        };
      };

      scroll_preview = {
        scroll_down = "<C-f>";
        scroll_up = "<C-b>";
      };
    };
  };
}
