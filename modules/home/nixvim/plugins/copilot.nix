{
  plugins = {
    copilot-lua = {
      enable = true;
      settings = {
        panel = {
          enabled = true;
          auto_refresh = true;
          layout.position = "right";
        };
        suggestions.enabled = false;

        filetypes = {
          markdown = true;
          gitcommit = true;
          "*" = true;
        };
      };
    };
  };
}
