{
  config,
  lib,
  username,
  ...
}:
with lib; let
  cfg = config.mimonix.home.base;
in {
  options.mimonix.home.base = {
    enable = mkEnableOption "base home-manager configuration";
  };

  config = mkIf cfg.enable {
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

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
