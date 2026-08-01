{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    shellWrapperName = "y";

    plugins.git = {
      package = pkgs.yaziPlugins.git;
      setup = true;
      settings.order = 1500;
    };
    plugins.vcs-files = pkgs.yaziPlugins.vcs-files;

    settings.plugin.prepend_fetchers = [
      {
        id = "git";
        url = "*";
        run = "git";
        group = "git";
      }
      {
        id = "git";
        url = "*/";
        run = "git";
        group = "git";
      }
    ];

    keymap.mgr.prepend_keymap = [
      {
        on = ["q"];
        run = "quit";
      }
      {
        on = ["<Esc>"];
        run = "quit";
      }
      {
        on = ["g" "c"];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      }
    ];
  };
}
