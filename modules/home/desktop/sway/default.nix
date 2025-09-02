{
  pkgs,
  lib,
  ...
} @ args: let
  terminal = "kitty";
  browser = "brave --password-store=gnome";
  menu = "rofi -show drun";
in {
  imports = [
    (import ./base.nix (args // {inherit terminal browser;}))
    (import ./keybindings.nix (args // {inherit terminal browser menu;}))
    (import ./waybar.nix (args // {inherit terminal;}))
    ./rofi.nix
  ];
}
