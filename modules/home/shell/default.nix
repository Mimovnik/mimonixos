{
  flake.homeModules.homeShell = {
    config,
    lib,
    pkgs,
    ...
  }: let
    zshPerProjectHistory = pkgs.fetchFromGitHub {
      owner = "ivan-cukic";
      repo = "zsh-per-project-history";
      rev = "c7009249fb37f4e5c207e8f2348567756b522ec0";
      hash = "sha256-HQ3EvNGTS5zZrO+UwP0jXh/ogyllpF2VQ14cmKtNJx4=";
    };
  in {
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
      lsof
      nix-output-monitor
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

        initContent = lib.mkMerge [
          (lib.mkOrder 500 ''
            HISTORY_BASE="''${XDG_STATE_HOME:-$HOME/.local/state}/zsh/project-history"
            PER_PROJECT_HISTORY_TAGS=(.git .envrc .per_project_history)
            PER_PROJECT_HISTORY_TOGGLE='^G'
          '')
          (lib.mkOrder 1000 ''
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;

            unset SSH_ASKPASS;

            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

            if [ -n "$SSH_AUTH_SOCK" ] && ! ssh-add -l >/dev/null 2>&1; then
              ssh-add ~/.ssh/id_ed25519
            fi

            bindkey -M emacs "^[[H" beginning-of-line
            bindkey -M emacs "^[OH" beginning-of-line
            bindkey -M emacs "^[[1~" beginning-of-line
            bindkey -M emacs "^[[F" end-of-line
            bindkey -M emacs "^[OF" end-of-line
            bindkey -M emacs "^[[4~" end-of-line
            bindkey -M emacs "^[[1;5D" backward-word
            bindkey -M emacs "^[Od" backward-word
            bindkey -M emacs "^[[1;5C" forward-word
            bindkey -M emacs "^[Oc" forward-word
            bindkey -M emacs "^[[3~" delete-char

            calc() {
              if [[ $# -lt 1 ]]; then
                echo "Error: Too many args. Usage: `calc "2 * 2"`. Remember to use double quotes."
                return 1
              fi
              echo "scale=2; $1" | bc
            }

            grev() {
              local branch="$1"
              local selected commit

              if [[ -z "$branch" ]]; then
                echo "usage: grev <branch>"
                return 1
              fi

              git rev-parse --is-inside-work-tree >/dev/null || return 1

              if [[ -n "$(git status --porcelain)" ]]; then
                echo "grev requires a clean worktree and staging area"
                return 1
              fi

              git switch "$branch" || return 1

              selected="$(
                git log --reverse --format='%h %s' "origin/main..$branch" |
                  fzf --prompt='Review commit: '
              )" || return 1

              commit="''${selected%% *}"

              git switch --detach "$commit^" &&
                git cherry-pick --no-commit "$commit"
            }
          '')
        ];

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
          glo = "git log --decorate --oneline --graph origin/main...@";
          gsw = "git switch";
          grs = "git restore";
          grss = "git restore --staged";
          grb = "git rebase -i";
          grbm = "git rebase -i origin/main";
          grbc = "git rebase --continue";

          ssh = "kitten ssh";

          mimv = "cd ${configDir} && vim";
          mimvim = "cd ${configDir} && vim";
        };

        plugins = [
          {
            name = "zsh-per-project-history";
            src = zshPerProjectHistory;
            file = "per-project-history.zsh";
          }
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

      nix-index.enable = false;
      nix-index-database.comma.enable = true;
    };
  };
}
