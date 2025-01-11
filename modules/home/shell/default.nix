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
            exit 1
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
          local host=$2
          nixos-rebuild switch --flake $config_dir#$host --target-host root@$host
        }
      '';

      shellAliases = let
        configDir = "~/.mimonixos";
      in {
        gs = "git status";
        gd = "git diff --staged";
        gds = "git diff";
        ga = "git add";
        gap = "git add --patch";
        gA = "git add -A";
        gc = "git commit";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gl = "git log --all --decorate --oneline --graph";

        trash = "mv ~/Trash";

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

        mimc = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d";
        mimclean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d";

        mimgc = "sudo nix-collect-garbage --delete-old";
        mimgarbagecollect = "sudo nix-collect-garbage --delete-old";
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
