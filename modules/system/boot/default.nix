{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Plymouth boot splash - silent boot configuration
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  # Enable Plymouth in initrd for early boot splash
  boot.initrd.systemd.enable = true;

  # Silent boot - suppress kernel messages and boot text
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  # Hide systemd boot messages
  boot.initrd.verbose = false;
}
