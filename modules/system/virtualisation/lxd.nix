{username, ...}: {
  virtualisation.lxd.enable = true;
  users.users.${username}.extraGroups = ["lxd"];
}
