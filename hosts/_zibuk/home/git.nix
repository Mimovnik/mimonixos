{
  programs.git = {
    enable = true;
    userName = "Jakub Kwidzinski";
    userEmail = "jakub.kwidzynski@navtor.com";

    extraConfig = {
      # Windows compatible
      core.autocrlf = true;
      core.filemode = false;
    };
  };
}
