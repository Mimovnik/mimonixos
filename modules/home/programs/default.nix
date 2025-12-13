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
    just
    imv # simple image viewer
    tealdeer
    socat
    pciutils
    gh

    # tui
    yazi
    htop
    btop
    bluetui
    wifitui
  ];
}
