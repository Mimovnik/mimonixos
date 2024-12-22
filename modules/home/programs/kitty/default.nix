{
  programs.kitty = {
    enable = true;
    themeFile = "OneDark";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
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
    };
  };
}
