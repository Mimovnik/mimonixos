{
  flake.nixosModules.systemBoot = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;

      # Plymouth boot splash - silent boot configuration
      plymouth = {
        enable = true;
        theme = "breeze";
      };

      # Enable Plymouth in initrd for early boot splash
      initrd.systemd.enable = true;

      # Silent boot - suppress kernel messages and boot text
      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

      # Hide systemd boot messages
      initrd.verbose = false;
    };
  };
}
