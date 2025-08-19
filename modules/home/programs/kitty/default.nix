{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mimonix.programs.kitty;
in {
  options.mimonix.programs.kitty = {
    enable = mkEnableOption "Kitty terminal emulator";
    
    fontSize = mkOption {
      type = types.int;
      default = 10;
      description = "Font size for Kitty";
    };
    
    fontName = mkOption {
      type = types.str;
      default = "JetBrainsMono Nerd Font";
      description = "Font family for Kitty";
    };
    
    theme = mkOption {
      type = types.str;
      default = "OneDark";
      description = "Color theme for Kitty";
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/kitty/nvim-pager.sh" = {
      source = ./nvim-pager.sh;
    };

    programs.kitty = {
      enable = true;
      themeFile = cfg.theme;
      font = {
        name = cfg.fontName;
        size = cfg.fontSize;
      };

      keybindings = {
        "ctrl+1" = "goto_tab 1";
        "ctrl+2" = "goto_tab 2";
        "ctrl+3" = "goto_tab 3";
        "ctrl+4" = "goto_tab 4";
        "ctrl+5" = "goto_tab 5";
        "ctrl+6" = "goto_tab 6";
        "ctrl+7" = "goto_tab 7";
        "ctrl+8" = "goto_tab 8";
        "ctrl+9" = "goto_tab 9";
      };

      settings = {
        background_opacity = "0.99";
        enable_audio_bell = false;
        tab_bar_edge = "top";
        scrollback_pager = "~/.config/kitty/nvim-pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";
      };
    };
  };
}
