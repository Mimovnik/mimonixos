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
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
      };
    };

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

        calc() {
          if [[ $# -lt 1 ]]; then
            echo "Error: Too many args. Usage: `calc "2 * 2"`. Remember to use double quotes."
            exit 1
          fi
          echo "scale=2; $1" | bc
        }
      '';

      autosuggestion.enable = true;

      shellAliases = let
        configDir = "~/.mimonixos";
      in {
        gs = "git status";
        gd = "git diff";
        ga = "git add";
        gaa = "git add -A";
        gA = "git add -A";
        gc = "git commit";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gl = "git log";

        trash = "mv ~/Trash";

        mimvim = "cd ${configDir} && vim";
        mimbld = "sudo nixos-rebuild switch --flake ${configDir}";
        mimtest = "sudo nixos-rebuild test --show-trace --flake ${configDir}";
        mimup = "sudo nix flake update ${configDir}";
        mimclean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d";
        mimgc = "sudo nix-collect-garbage --delete-old";
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
