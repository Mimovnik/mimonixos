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
}
