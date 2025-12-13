{pkgs, ...}: {
  imports = [
    ./git
    ./direnv
    ./kitty
    ./yazi.nix
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
    htop
    btop
    bluetui
    wifitui
  ];
}
