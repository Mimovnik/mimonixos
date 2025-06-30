{pkgs, ...}: {
  imports = [
    ./git
    ./direnv
    ./kitty
  ];

  home.packages = with pkgs; [
    # cli
    zip
    unzip
    wget
    curl
    dig
    htop
    btop
    just
    playerctl
    imv # simple image viewer
    pavucontrol
    yazi
    alejandra
    tealdeer
    socat

    # gui
    godot
    aseprite
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
