{
  networking.hostId = "57e76d17";

  boot = {
    supportedFilesystems = ["zfs"];

    zfs = {
      forceImportRoot = true;
      devNodes = "/dev/disk/by-id";
    };
  };
}
