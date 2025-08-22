{config, ...}: {
  # It says xserver but this setting is for both x11 and wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    prime = {
      offload.enable = false;
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.variables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
}
