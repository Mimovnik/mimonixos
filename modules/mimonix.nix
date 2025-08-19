# Main Mimonix module that imports all sub-modules and exposes the mimonix namespace
{
  imports = [
    # System modules
    ./system/base
    ./system/boot
    ./system/nvidia
    ./system/steam
    ./system/desktop/hyprland
    ./system/desktop/kde
    ./system/common/tailscale.nix
    ./system/common/adb-udev.nix
    ./system/common/sddm.nix
    ./system/common/authorized-keys.nix
    ./system/common/hostnames.nix
    ./system/common/fprintd.nix
    ./system/virtualisation/docker.nix

    # Home modules
    ./home/base
    ./home/shell
    ./home/programs
    ./home/nixvim
    ./home/desktop-apps
    ./home/desktop/hyprland
    ./home/desktop/kde
  ];
}