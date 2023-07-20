{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "mimovnik";
    homeDirectory = "/home/mimovnik";
    stateVersion = "23.05";

    packages = with pkgs; [
      yakuake
      vscode.fhs
      rnix-lsp
      youtube-music
      unityhub
      signal-desktop
      keychain
      xclip
      bitwarden-cli
      steam
      discord

      (buildEnv { name = "bwcopy"; paths = [ ./bwcopy ]; })
    ];


  };

  programs = {

    git = {
      enable = true;
      userName = "mimovnik";
      userEmail = "jkwidzinski@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    zsh = {
      enable = true;

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignorePatterns = [
          "rm"
          "rm *"
        ];
      };

      defaultKeymap = "emacs";

      initExtra = ''
        eval $(keychain --eval --agents ssh);
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
        unset SSH_ASKPASS;
      '';

      shellAliases = {
        mimonixos-upgrade = "sudo nixos-rebuild --flake /home/mimovnik/.mimonixos#mimonixos switch";
        mimonixos-test = "sudo nixos-rebuild --flake /home/mimovnik/.mimonixos#mimonixos test";
        mimonixos-update = "nix flake update /home/mimovnik/.mimonixos";

        need-ssh = "eval $(keychain --eval --agents ssh id_ed25519)";
      };

      sessionVariables = {
        MIMONIXOS = "/home/mimovnik/.mimonixos";
      };

      enableAutosuggestions = true;

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k-config;
          file = ".p10k.zsh";
        }
      ];
    };

  };
}
