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

    # gui
    vesktop
    brave
    signal-desktop
    anki
    krita
    onlyoffice-bin
    obsidian
    nautilus
    nextcloud-client
  ];
}
