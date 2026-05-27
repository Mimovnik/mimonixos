{
  flake.nixosModules.systemCommonAuthorizedKeys = {username, ...}: {
    users.users.${username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmku0qaxDIbYb6MlZEMhqRC0KIdeQoNwIQi6/a4z3Fn mimovnik@glados"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnVkTng/GTwCjsC24ALN09Poarxct0npERMip/XttL9 mimovnik@carbon"
    ];
  };
}
