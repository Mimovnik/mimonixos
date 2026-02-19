{lib, ...}: let
  physical = "enp2s0";
  bridge = "br0";
in {
  networking = {
    useNetworkd = true;
    networkmanager.enable = lib.mkForce false;

    bridges."${bridge}" = {
      interfaces = ["${physical}"];
    };

    interfaces = {
      "${physical}".useDHCP = false;
      "${bridge}".useDHCP = true;
    };

    firewall.checkReversePath = "loose";
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
