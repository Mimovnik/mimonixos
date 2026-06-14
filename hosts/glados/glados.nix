{
  inputs,
  self,
  withSystem,
  ...
}: let
  hostname = "glados";
  system = "x86_64-linux";
  username = "mimovnik";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit system hostname username;
    };

    modules = [
      self.nixosModules.systemBase
      self.nixosModules.systemBoot
      self.nixosModules.systemAmdGpu
      self.nixosModules.systemDesktopNiri
      self.nixosModules.systemCommonHostnames
      self.nixosModules.systemSteam
      self.nixosModules.systemVirtualisationLibvirt
      self.nixosModules.systemVirtualisationBridge
      self.nixosModules.systemVirtualisationDocker
      self.nixosModules.systemVirtualisationIncus
      self.nixosModules.systemCommonOtd
      self.nixosModules.systemBinfmt

      ./_hardware-configuration.nix
      ./_disko-config.nix
      ./_zfs.nix

      inputs.disko.nixosModules.disko
      inputs.maccel.nixosModules.default

      {
        defaults.niri = let
          # Obtain with `niri msg outputs` or `niri msg focused-output`
          mainMonitor = "DP-1";
          scndMonitor = "DVI-D-1";
        in {
          enable = true;

          workspaces = {
            "1".output = mainMonitor;
            "2".output = mainMonitor;
            "3".output = mainMonitor;
            "4".output = mainMonitor;
            "5".output = mainMonitor;

            "6".output = scndMonitor;
            "7".output = scndMonitor;
            "8".output = scndMonitor;
            "9".output = scndMonitor;
            "10".output = scndMonitor;
          };

          extraConfig = ''
            output "${mainMonitor}" {
                mode "2560x1440"
                scale 1
                position x=0 y=0
            }

            output "${scndMonitor}" {
                mode "1920x1080"
                scale 1
                position x=2560 y=0
            }
          '';
        };

        powerManagement.cpuFreqGovernor = "performance";
      }
    ];
  };

  flake.homeConfigurations."${username}@${hostname}" =
    inputs.home-manager.lib.homeManagerConfiguration
    {
      pkgs = withSystem system ({pkgs, ...}: pkgs);

      extraSpecialArgs = {
        inherit system username;
      };

      modules = [
        inputs.nixvim.homeModules.nixvim
        inputs.nix-index-database.homeModules.default

        self.homeModules.homeBase
        self.homeModules.homePrograms
        self.homeModules.homeShell
        self.homeModules.homeDesktopApps
        self.homeModules.homeNixvim

        ({pkgs, ...}: {
          nix.package = pkgs.lixPackageSets.stable.lix;
        })
      ];
    };
}
