{
  plugins.lsp = {
    enable = true;
    servers = {
      clangd = {
        enable = true;
        extraOptions.filetypes = ["cpp" "c" "arduino"];
      };

      nil_ls = {
        enable = true;
        settings.nil = {
          formatting.command = ["alejandra"];
        };
      };

      basedpyright.enable = true;

      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
        installRustfmt = true;
      };

      marksman.enable = true;

      jsonls.enable = true;

      bashls.enable = true;
    };
  };
}
