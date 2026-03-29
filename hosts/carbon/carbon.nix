{
  inputs,
  self,
  ...
}: let
  hostname = "carbon";
  system = "x86_64-linux";
  username = "mimovnik";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs self hostname username;
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
}
