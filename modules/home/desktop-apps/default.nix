{pkgs, ...}: {
  imports = [
    ./vscode
  ];

  # Programs that are useful only in desktop environment (so not in wsl for example)
  home.packages = with pkgs; [
    pavucontrol
    playerctl

    unityhub
    godot
    vorta
    obs-studio
    firefox
    kdePackages.kdenlive
    vesktop
    brave
    unstable.signal-desktop
    anki
    krita
    onlyoffice-bin
    nautilus
    gnome-disk-utility
    nextcloud-client
  ];
}
