{
  flake.nixosModules.systemVirtualisationLibvirt = {
    username,
    pkgs,
    ...
  }: {
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = ["${username}"];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.vhostUserPackages = [pkgs.virtiofsd];
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
