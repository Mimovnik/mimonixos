{lib, ...}: {
  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };

    settings = {
      user = {
        name = lib.mkDefault "mimovnik";
        email = lib.mkDefault "mimovnik@protonmail.com";
      };

      gpg.format = "ssh";
      commit.gpgsign = true;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    ignores = [
      ".envrc"
      ".direnv/"
      "flake.nix"
      "flake.lock"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
      line-numbers = true;
      features = "villsau";
      # author: https://github.com/torarnv
      villsau = {
        dark = true;
        line-numbers = true;
        file-style = "omit";
        hunk-header-decoration-style = "omit";
        hunk-header-file-style = "magenta";
        hunk-header-line-number-style = "dim magenta";
        hunk-header-style = "file line-number syntax";
        minus-emph-style = "bold red 52";
        minus-empty-line-marker-style = "normal \"#3f0001\"";
        minus-non-emph-style = "dim red";
        minus-style = "bold red";
        plus-emph-style = "bold green 22";
        plus-empty-line-marker-style = "normal \"#002800\"";
        plus-non-emph-style = "dim green";
        plus-style = "bold green";
        syntax-theme = "OneHalfDark";
        whitespace-error-style = "reverse red";
        zero-style = "dim syntax";
      };
    };
  };

  # TODO: move the keys to a module
  home.file.".ssh/allowed_signers".text = ''
    mimovnik@protonmail.com  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmku0qaxDIbYb6MlZEMhqRC0KIdeQoNwIQi6/a4z3Fn mimovnik@glados
  '';
}
