{
  username,
  pkgs,
  ...
}: {
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["${username}"];

  virtualisation.libvirtd.enable = true;

  virtualisation.libvirtd.qemu.vhostUserPackages = [pkgs.virtiofsd];

  virtualisation.spiceUSBRedirection.enable = true;
}
