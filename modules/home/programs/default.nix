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
    alejandra
    tealdeer
    socat
    pciutils

    # tui
    yazi
    htop
    btop
    bluetui
    impala
  ];
}
