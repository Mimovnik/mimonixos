{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    file
    which
    tree
    ripgrep
    bat
    fzf
    keychain
    bitwarden-cli
    sshpass
    (pkgs.fetchgit {
      url = "https://github.com/Mimovnik/NeedSsh.git";
      sha256 = "sha256-ElwaE7C8MlVhwgnzyIbkl2fCqfWBe6CtmgzYHdZgeNU=";
    })
  ];

  programs = {
    zsh = {
      enable = true;

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignorePatterns = [
          "*rm*"
        ];
      };

      defaultKeymap = "emacs";

      initExtra = ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;

        unset SSH_ASKPASS;

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char

        eval $(keychain --eval --quiet --agents ssh);
      '';

      autosuggestion.enable = true;

      shellAliases = {
        gits = "git status";
        gitd = "git diff";
        gita = "git add";
        gitA = "git add -A";
        gitc = "git commit";
        gitl = "git log";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./.; # Current directory
          file = ".p10k.zsh";
        }
      ];
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
  };
}
