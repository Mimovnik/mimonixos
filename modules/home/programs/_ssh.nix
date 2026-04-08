{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
      };
    };
  };
  # Conflicts with gnome-keyring
  services.ssh-agent.enable = false;

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
  };
}
