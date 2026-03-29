{
  plugins.git-conflict = {
    enable = true;
    settings = {
      default_commands = true;

      default_mappings = {
        both = "<leader>b";
        next = "<leader>n";
        none = "<leader>0";
        ours = "<leader>o";
        prev = "<leader>p";
        theirs = "<leader>t";
      };

      disable_diagnostics = false;
      highlights = {
        ancestor = "DiffChange";
        current = "DiffText";
        incoming = "DiffAdd";
      };
      list_opener = "copen";
    };
  };
}
