{username, ...}: {
  virtualisation.incus.enable = true;
  networking.nftables.enable = true;
  users.users.${username}.extraGroups = ["incus-admin"];
}
