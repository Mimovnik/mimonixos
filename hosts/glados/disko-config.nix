{
  disko.devices = {
    disk = {
      ssd1 = {
        device = "/dev/disk/by-id/ata-SSDPR-CX400-256-G2_G2P015547";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              size = "18G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      ssd2 = {
        device = "/dev/disk/by-id/ata-SSDPR-CX400-256-G2_G2B124435";
        type = "disk";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
      mimodisk = {
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S4CNNG0KC1839F";
        type = "disk";
        content = {
          type = "gpt";
          partitions.main = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mimodisk";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#general-recommendations
        # some options from https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "lz4";
          mountpoint = "none";
          xattr = "sa";
        };
        options.ashift = "12";

        # Zfs with disko
        # https://discourse.nixos.org/t/disko-and-zfs-emergency-mode-during-boot/58138/4
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "storage" = {
            type = "zfs_fs";
            mountpoint = "/storage";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
