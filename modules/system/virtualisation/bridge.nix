{
  networking = let
    physical = "enp2s0";
    bridge = "br0";
  in {
    networkmanager.unmanaged = ["interface-name:${physical}"];

    bridges."${bridge}" = {
      interfaces = ["${physical}"];
    };

    interfaces = {
      "${physical}".useDHCP = false; # or set static IP if not using bridge IP
      "${bridge}".useDHCP = true; # or set static IP for the bridge
    };
  };
}
