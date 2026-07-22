{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    shellWrapperName = "y";

    keymap.mgr.prepend_keymap = [
      {
        on = ["q"];
        run = "quit";
      }
      {
        on = ["<Esc>"];
        run = "quit";
      }
    ];
  };
}
