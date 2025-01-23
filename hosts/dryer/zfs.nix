{
  networking.hostId = "579a0114";

  boot = {
    supportedFilesystems = ["zfs"];

    zfs = {
      forceImportRoot = true;
      devNodes = "/dev/disk/by-id";
    };
  };
}
