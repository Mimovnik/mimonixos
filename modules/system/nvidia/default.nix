{config, ...}: {
  # Nvidia GPU
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  # It says xserver but this setting is for both x11 and wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
