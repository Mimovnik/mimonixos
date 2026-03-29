{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        # Set any default values you want to keep here, e.g.:
        # forwardAgent = false;
      };
      "kw" = {
        hostname = "kw";
        user = "pi";
        forwardAgent = true;
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "no";
        };
      };
    };
  };
  services.ssh-agent.enable = true;
}
