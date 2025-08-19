{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mimonix.programs;
in {
  imports = [
    ./git
    ./direnv
    ./kitty
  ];

  options.mimonix.programs = {
    enable = mkEnableOption "basic command line programs and tools";
  };

  config = mkIf cfg.enable {
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
      imv # simple image viewer
      yazi
      alejandra
      tealdeer
      socat
    ];
  };
}
