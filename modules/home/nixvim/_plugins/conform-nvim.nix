{pkgs, ...}: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      formatters_by_ft = {
        nix = ["alejandra"];
        python = ["black" "isort"];
        rust = ["rustfmt"];
        json = ["jq"];
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        c = ["clang-format"];
        cpp = ["clang-format"];
        ino = ["clang-format"];
        "_" = ["trim_whitespace"];
      };
      default_format_opts.lsp_format = "first";
    };
  };
  extraPackages = with pkgs; [
    alejandra
    black
    isort
    jq
    shellcheck
    shellharden
    shfmt
    rustfmt
  ];
}
