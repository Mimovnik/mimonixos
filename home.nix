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
      youtube-music
      unityhub
      signal-desktop
      keychain
    ];

  };


  programs = {
    git = {
      enable = true;
      userName  = "mimovnik";
      userEmail = "jkwidzinski@gmail.com";
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
      ];
    };

    zsh = {
      enable = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      initExtra = ''
        eval $(keychain --eval --agents ssh);
      '';

      shellAliases = {
        mimonixos-upgrade = "sudo nixos-rebuild --flake /home/mimovnik/.mimonixos#mimonixos switch";
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
        theme = "powerlevel10k";
      };
    };

  };
}