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
          "*rm*"
        ];
      };

      defaultKeymap = "emacs";

      autosuggestion.enable = true;

      sessionVariables = {
        MANPAGER = "nvim +Man!";
      };

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
            return 1
          fi
          echo "scale=2; $1" | bc
        }

        find-nixpkgs() {
          local query
          query=$(printf ".*%s.*" "$@")
          nix search nixpkgs "$query"
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

        tmux-run() {
          if [[ $# -eq 0 ]]; then
              echo "Usage: tmux-run <command> [args...]"
              return 1
          fi

          local command_name="$1"
          local session_name="$command_name"
          local suffix=0

          # Handle name collisions by appending a suffix
          while tmux has-session -t "$session_name" 2>/dev/null; do
              session_name="''${command_name}_$((++suffix))"
          done

          tmux new-session -d -s "$session_name"

          tmux send-keys -t "$session_name" "$*" C-m
        }

        run-nixpkgs() {
          if [[ $# -eq 0 ]]; then
              echo "Usage: tmux-run <command> [args...]"
              return 1
          fi

          local cmd="$1"
          local args="''${@:2}"
          nix run nixpkgs#$cmd -- $args
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

        trash = "mv ~/Trash";

        ssh = "kitten ssh";

        mimv = "cd ${configDir} && vim";
        mimvim = "cd ${configDir} && vim";

        mims = "find-nixpkgs";
        mimsearch = "find-nixpkgs";

        mimb = "sudo nixos-rebuild switch --flake ${configDir}";
        mimbuild = "sudo nixos-rebuild switch --flake ${configDir}";

        mimt = "sudo nixos-rebuild test --show-trace --flake ${configDir}";
        mimtest = "sudo nixos-rebuild test --show-trace --flake ${configDir}";

        mimd = "deploy-nixos ${configDir}";
        mimdeploy = "deploy-nixos ${configDir}";

        mimup = "sudo nix flake update --flake ${configDir}";
        mimupdate = "sudo nix flake update --flake ${configDir}";

        mimclean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d";

        mimgc = "sudo nix-collect-garbage --delete-old";
        mimgarbagecollect = "sudo nix-collect-garbage --delete-old";

        mimrun = "run-nixpkgs";

        mimpreset = "~/.config/hypr/scripts/preset.sh";
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

    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
