{
  flake.homeModules.homePrograms = {pkgs, ...}: {
    imports = [
      ./_git
      ./_direnv
      ./_kitty
      ./_yazi.nix
      ./_ssh.nix
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
  };
}
