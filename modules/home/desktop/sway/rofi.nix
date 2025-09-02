{
  pkgs,
  config,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = {
      "*" = {
        background = mkLiteral "#000000";
        background-color = mkLiteral "#000000";
        text-color = mkLiteral "#ffffff";
        color = mkLiteral "#ffffff";
        border-color = mkLiteral "#222222";
        selected-normal-background = mkLiteral "#222222";
        selected-normal-foreground = mkLiteral "#ffffff";
        normal-foreground = mkLiteral "#ffffff";
        normal-background = mkLiteral "#000000";
        alternate-normal-background = mkLiteral "#111111";
        alternate-normal-foreground = mkLiteral "#ffffff";
        urgent-foreground = mkLiteral "#ffffff";
        urgent-background = mkLiteral "#be5046";
        active-foreground = mkLiteral "#ffffff";
        active-background = mkLiteral "#111111";
        separatorcolor = mkLiteral "#222222";
        highlight = mkLiteral "#61afef";
      };

      element = {
        orientation = mkLiteral "horizontal";
        children = map mkLiteral ["element-icon" "element-text"];
      };

      "element-icon" = {
        size = mkLiteral "24px";
        vertical-align = "0.5";
        margin = mkLiteral "0px 10px 0px 0px";
      };
    };
  };
}
