{
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
  };

  imports = [../../common/fprintd.nix];
  security.pam.services = {
    sddm.fprintAuth = true;
    kscreenlocker.fprintAuth = true;
    sudo.fprintAuth = false;
  };
}
