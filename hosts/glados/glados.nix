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
      self.nixosModules.systemDesktopSway
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
        powerManagement.cpuFreqGovernor = "performance";
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
      self.homeModules.homePrograms
      self.homeModules.homeShell
      self.homeModules.homeDesktopSway
      self.homeModules.homeDesktopApps
      self.homeModules.homeNixvim

      ({
        lib,
        pkgs,
        ...
      }: {
        nix.package = pkgs.lixPackageSets.stable.lix;

        mimo.sway = let
          leftMon = "DP-1";
          rightMon = "DVI-D-1";
        in {
          enable = true;
          workspaceOutputs = lib.listToAttrs (
            map (ws: {
              name = toString ws;
              value = leftMon;
            }) [1 2 3 4 5]
            ++ map (ws: {
              name = toString ws;
              value = rightMon;
            }) [6 7 8 9 10]
          );

          # Configure monitor positioning
          outputs = {
            "DP-1" = {
              position = "0 0";
              resolution = "2560x1440";
            };
            "DVI-D-1" = {
              position = "2560 0";
              resolution = "1920x1080";
            };
          };
        };
      })
    ];
  };
}
