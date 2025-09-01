{
  pkgs,
  lib,
  ...
} @ args: let
  terminal = "kitty";
  browser = "brave --password-store=gnome";
in {
  imports = [
    (import ./base.nix (args // {inherit terminal browser;}))
    (import ./keybindings.nix (args // {inherit terminal browser;}))
    ./style.nix
  ];
}
