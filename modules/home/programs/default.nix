{pkgs, ...}: {
  imports = [
    ./git
    ./direnv
    ./kitty
    ./vscode
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
    obs-studio
    firefox
    kdenlive
    vesktop
    brave
    signal-desktop
    anki
    krita
    onlyoffice-bin
    nautilus
    gnome-disk-utility
    nextcloud-client
  ];
}
