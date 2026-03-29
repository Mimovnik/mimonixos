{
  inputs,
  self,
  ...
}: {
  flake = let
    hostname = "glados";
    system = "x86_64-linux";
    username = "mimovnik";
  in {
    nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs self hostname username;
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
  };
}
