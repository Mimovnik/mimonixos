{
  flake.nixosModules.systemCommonHostnames = {
    networking.hosts = {
      "192.168.3.2" = ["glados"];
      "192.168.3.3" = ["pimox"];
      "192.168.3.5" = ["samurai-tv"];
    };
  };
}
