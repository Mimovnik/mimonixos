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
      self.nixosModules.systemBase
      self.nixosModules.systemBoot
      self.nixosModules.systemDesktopSway
      self.nixosModules.systemCommonHostnames
      self.nixosModules.systemSteam
      self.nixosModules.systemVirtualisationDocker
      self.nixosModules.systemBinfmt

      ./_hardware-configuration.nix
      ./_disko-config.nix
      ./_zfs.nix
      ./_nvidia.nix
      ./_adb-firewall.nix

      inputs.disko.nixosModules.disko
      inputs.maccel.nixosModules.default

      {
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
      self.homeModules.homeDesktopSway

      ({pkgs, ...}: {
        home.packages = with pkgs; [
          auto-cpufreq
          pika-backup
        ];

        mimo.sway = {
          enable = true;
          mod = "Mod1"; # Alt key
        };
      })
    ];
  };
}
