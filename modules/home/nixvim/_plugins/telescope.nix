{
  plugins.telescope = {
    enable = true;
    settings.pickers = {
      find_files = {
        hidden = true;
        file_ignore_patterns = [
          "^%.git/"
        ];
      };

      live_grep.additional_args = [
        "--hidden"
        "--glob"
        "!.git/**"
      ];
    };
    settings.defaults = {
      # layout_config = {
      #   prompt_position = "top";
      # };
    };
  };

  extraConfigLua = ''
    local telescope_actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<Esc>"] = telescope_actions.close,
          },
          n = {
            ["<Esc>"] = telescope_actions.close,
          },
        },
      },
    })
  '';
}
