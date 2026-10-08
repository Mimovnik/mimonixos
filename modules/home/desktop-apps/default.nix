{
  flake.homeModules.homeDesktopApps = {pkgs, ...}: {
    imports = [
      ./_webapps.nix
      ./_xdg-entries.nix

      ./_vscode
    ];

    # Make the cursor theme visible to sandboxed desktop applications such as Steam.
    xdg.dataFile = {
      "icons/Bibata-Modern-Ice".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
      "icons/default/index.theme".text = ''
        [Icon Theme]
        Inherits=Bibata-Modern-Ice
      '';
    };

    # Programs that are useful only in desktop environment (so not in wsl for example)
    home.packages = with pkgs; [
      pavucontrol
      playerctl
      ffmpeg

      freecad
      unityhub
      unstable.godot
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
      orca-slicer
      vlc
    ];
  };
}
