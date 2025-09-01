{
  pkgs,
  lib,
  ...
} @ args: let
  terminal = "kitty";
  browser = "brave --password-store=gnome";
  menu = "rofi -show drun -show-icons -theme-str 'window {background-color: #1e1e2e;} listview {background-color: #181825;} element {background-color: #181825;} element-icon {background-color: #181825;} element-text {background-color: #cdd6f4;} scrollbar {background-color: #181825;} scrollbar-handle {background-color: #313244;}';";
in {
  imports = [
    (import ./base.nix (args // {inherit terminal browser;}))
    (import ./keybindings.nix (args // {inherit terminal browser menu;}))
    ./style.nix
  ];
}
