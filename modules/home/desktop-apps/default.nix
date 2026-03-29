{
  flake.homeModules.homeDesktopApps = {pkgs, ...}: {
    imports = [
      ./_webapps.nix
      ./_xdg-entries.nix

      ./_vscode
    ];

    # Programs that are useful only in desktop environment (so not in wsl for example)
    home.packages = with pkgs; [
      pavucontrol
      playerctl
      ffmpeg

      freecad
      unityhub
      godot
      vorta
      obs-studio
      firefox
      kdePackages.kdenlive
      discord
      brave
      signal-desktop
      anki
      krita
      onlyoffice-desktopeditors
      nautilus
      gnome-disk-utility
      nextcloud-client
      thunderbird
    ];
  };
}
