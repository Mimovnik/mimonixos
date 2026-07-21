{
  inputs,
  self,
  withSystem,
  ...
}: let
  hostname = "zibuk";
  system = "x86_64-linux";
  username = "mimovnik";
in {
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit system hostname username;
    };

    modules = [
      self.nixosModules.systemBase

      inputs.nixos-wsl.nixosModules.default

      ({lib, ...}: {
        wsl = {
          enable = true;
          defaultUser = username;
        };

        # WSL manages networking; desktop/audio services are pointless here.
        networking.networkmanager.enable = lib.mkForce false;
        services.printing.enable = lib.mkForce false;
        services.pipewire.enable = lib.mkForce false;
        services.avahi.enable = lib.mkForce false;
        hardware.bluetooth.enable = lib.mkForce false;
      })
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
    ];
  };
}
