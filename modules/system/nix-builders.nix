{
  flake.nixosModules.nixBuilders = {lib, ...}: let
    linuxBuilderUser = "builder";
    linuxBuilderHostName = "szymons-mac-mini.deer-bangus.ts.net";
    linuxBuilderPort = 31022;
    macBuilderHostName = "szymons-mac-mini.deer-bangus.ts.net";
    identityFile = "/home/mimovnik/.ssh/id_ed25519";
    protocol = "ssh-ng";
    linuxBuilderMaxJobs = 1;
    macBuilderMaxJobs = 2;
    speedFactor = 100;
  in {
    programs.ssh.extraConfig = lib.mkBefore ''
      Host ${linuxBuilderHostName}
        ControlMaster no
        ControlPath none
        ControlPersist no
    '';

    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          inherit protocol speedFactor;
          hostName = "${linuxBuilderHostName}?port=${toString linuxBuilderPort}";
          sshUser = linuxBuilderUser;
          sshKey = identityFile;
          maxJobs = linuxBuilderMaxJobs;
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
          systems = ["aarch64-linux"];
          supportedFeatures = [
            "kvm"
            "benchmark"
            "big-parallel"
            "nixos-test"
            "uid-range"
          ];
        }
        {
          inherit protocol speedFactor;
          hostName = macBuilderHostName;
          sshUser = "szymongrrr";
          sshKey = identityFile;
          maxJobs = macBuilderMaxJobs;
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdKelJ2cVVqN1czcUdaM0VWWURHZ2VGU3dQM1lZK0ZVUDZZMTExUldqdXkK";
          systems = ["aarch64-darwin"];
          supportedFeatures = [
            "apple-virt"
            "benchmark"
            "big-parallel"
            "nixos-test"
          ];
        }
      ];

      settings.builders-use-substitutes = lib.mkDefault true;
    };
  };
}
