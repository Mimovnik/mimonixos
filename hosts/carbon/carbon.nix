{
  inputs,
  self,
  withSystem,
  ...
}: let
  hostname = "carbon";
  system = "x86_64-linux";
  username = "mimovnik";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit system hostname username;
    };

    modules = [
      self.nixosModules.systemLinuxBase
      self.nixosModules.systemBoot
      self.nixosModules.systemDesktopNiri
      self.nixosModules.systemCommonHostnames
      self.nixosModules.systemSteam
      self.nixosModules.systemVirtualisationDocker
      self.nixosModules.systemBinfmt
      self.nixosModules.systemCommonMouseAccel

      ./_hardware-configuration.nix
      ./_disko-config.nix
      ./_zfs.nix
      ./_nvidia.nix
      ./_adb-firewall.nix
      ./_auto-cpufreq

      inputs.disko.nixosModules.disko

      {
        defaults.niri = let
          # Obtain with `niri msg outputs` or `niri msg focused-output`
          mainMonitor = "eDP-1";
          scndMonitor = "DP-1";
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

          kanshi.profiles = {
            "00-laptop-external" = {
              config = ''
                output "${mainMonitor}" {
                    enable
                    position 0,0
                    scale 2
                }

                output "*" {
                    enable
                    position 1920,0
                    scale 1
                }
              '';
            };

            "99-laptop" = {
              config = ''
                output "${mainMonitor}" {
                    enable
                    position 0,0
                    scale 2
                }
              '';
            };
          };
        };

        hardware.bluetooth = {
          settings = {
            General = {
              ControllerMode = "dual";
              Experimental = true;
              FastConnectable = true;
            };
            Policy = {
              AutoEnable = true;
            };
          };
        };

        services.upower.enable = true;
      }
    ];
  };

  flake.homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);

    extraSpecialArgs = {
      inherit system username;
    };

    modules = [
      inputs.nixvim.homeModules.nixvim
      inputs.nix-index-database.homeModules.default

      self.homeModules.homeBase
      self.homeModules.homeShell
      self.homeModules.homeNixvim
      self.homeModules.homePrograms
      self.homeModules.homeDesktopApps

      ({pkgs, ...}: {
        home.packages = with pkgs; [
          pika-backup
        ];
      })
    ];
  };
}
