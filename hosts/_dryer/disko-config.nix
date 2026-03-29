{
  disko.devices = {
    disk = {
      diskA = {
        # 232GB
        device = "/dev/disk/by-id/ata-ST3250312AS_5VMHP3H2";
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
              size = "12G";
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
      diskB = {
        # Western digital 465GB
        device = "/dev/disk/by-id/ata-WDC_WD5000BEVT-24A0RT0_WD-WX91A5079693";
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
      diskC = {
        # 232GB
        device = "/dev/disk/by-id/ata-WDC_WD2500BEKT-75PVMT0_WD-WXJ1A61M9719";
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
    };
    zpool = {
      zroot = {
        type = "zpool";
        # mode = {
        #   topology = {
        #     type = "topology";
        #     vdev = [
        #       {
        #         members = ["diskB"];
        #       }
        #       {
        #         mode = "mirror";
        #         members = ["dataA" "dataC"];
        #       }
        #     ];
        #   };
        # };
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
