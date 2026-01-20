{
  pkgs,
  username,
  ...
}: {
  # Enable ratbagd and piper for mouse configuration management (dpi, buttons, leds)
  services.ratbagd.enable = true;
  environment.systemPackages = with pkgs; [piper];

  hardware.maccel = {
    enable = true;
    enableCli = true; # Optional: for parameter discovery

    parameters = {
      inputDpi = 400.0;
      sensMultiplier = 1.0;
      yxRatio = 1.0;
      angleRotation = 0.0;

      mode = "natural";
      decayRate = 0.035;
      offset = 16.0;
      limit = 2.2;
    };
  };

  users.groups.maccel.members = [username];
}
