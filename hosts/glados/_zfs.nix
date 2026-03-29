{
  networking.hostId = "da286c9f"; # head -c4 /dev/urandom | od -A none -t x4

  boot = {
    supportedFilesystems = ["zfs"];

    zfs = {
      forceImportRoot = true;
      devNodes = "/dev/disk/by-id";
    };
  };
}
