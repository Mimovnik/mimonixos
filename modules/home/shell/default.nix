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
    fzf
    keychain
    bitwarden-cli
    sshpass
    bc
    (pkgs.fetchgit {
      url = "https://github.com/Mimovnik/NeedSsh.git";
      sha256 = "sha256-ElwaE7C8MlVhwgnzyIbkl2fCqfWBe6CtmgzYHdZgeNU=";
    })
    lsof
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
    };

    zsh = {
      enable = true;

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignorePatterns = [
          "rm*"
          "sudo rm*"
        ];
      };

      defaultKeymap = "emacs";

      autosuggestion.enable = true;

      sessionVariables = {
        MANPAGER = "nvim +Man!";
      };

      initContent = ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;

        unset SSH_ASKPASS;

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char

        eval $(keychain --eval --quiet --agents ssh);

        calc() {
          if [[ $# -lt 1 ]]; then
            echo "Error: Too many args. Usage: `calc "2 * 2"`. Remember to use double quotes."
            return 1
          fi
          echo "scale=2; $1" | bc
        }

        deploy-nixos() {
          local config_dir=$1

          if [ -z $2 ]; then
            echo "usage: mimdeploy <host> [address=host]"
            return 1
          fi

          local host=$2
          local address=$3
          if [ -z $3 ]; then
            address=$host
          fi
          nixos-rebuild switch --flake $config_dir#$host --target-host root@$address
        }
      '';

      shellAliases = let
        configDir = "~/.mimonixos";
      in {
        gs = "git status";
        gd = "git diff";
        gds = "git diff --staged";
        ga = "git add";
        gap = "git add --patch";
        gA = "git add -A";
        gc = "git commit";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gl = "git log --all --decorate --oneline --graph";
        gsw = "git switch";
        grs = "git restore";
        grss = "git restore --staged";
        grb = "git rebase -i";
        grbm = "git rebase -i origin/main";
        grbc = "git rebase --continue";

        trash = "mv ~/Trash";

        ssh = "kitten ssh";

        mimv = "cd ${configDir} && vim";
        mimvim = "cd ${configDir} && vim";

        mimd = "deploy-nixos ${configDir}";
        mimdeploy = "deploy-nixos ${configDir}";

        mimup = "sudo nix flake update --flake ${configDir}";
        mimupdate = "sudo nix flake update --flake ${configDir}";

        flet = "flutter";
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

    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
