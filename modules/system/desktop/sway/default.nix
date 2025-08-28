{
  pkgs,
  username,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "${username}";
      };
      default_session = initial_session;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    dconf.enable = true;
    ydotool.enable = true;
    seahorse.enable = true;
  };

  xdg.portal = {
    enable = true;
    # there is some weirdness happening here
    # https://github.com/NixOS/nixpkgs/issues/160923
    #xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
  };

  security = {
    polkit.enable = true;

    pam.services.swaylock = {};
  };
}
