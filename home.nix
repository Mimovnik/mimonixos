{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "mimovnik";
    homeDirectory = "/home/mimovnik";
    stateVersion = "23.05";

    packages = with pkgs; [
      yakuake
      vscode
      rnix-lsp
      youtube-music
      unityhub
      signal-desktop
      keychain
      xclip
      bitwarden-cli

      (buildEnv { name = "bwcopy"; paths = [ ./bwcopy ]; })
    ];


  };

  programs = {
    git = {
      enable = true;
      userName = "mimovnik";
      userEmail = "jkwidzinski@gmail.com";
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
      ];
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
      };

      initExtra = ''
        eval $(keychain --eval --agents ssh);
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
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

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };

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
