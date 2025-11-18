{
  username,
  config,
  ...
}: {
  home.file.".nix-profile" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.xdg.stateHome}/nix/profiles/home-manager/home-path";
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
