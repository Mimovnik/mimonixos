{
  programs.git = {
    enable = true;
    userName = "mimovnik";
    userEmail = "mimovnik@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
