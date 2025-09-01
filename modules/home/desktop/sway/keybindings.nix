{
  pkgs,
  browser,
  terminal,
  menu,
  ...
}: let
  mod = "Mod1"; # ALt
in {
  home.packages = with pkgs; [
    alsa-utils # aplay command for playing sound
    # Shell script to extend  play sound when controlling volume
    mimo.sway-volumectl
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      keybindings = let
        # Function to generate workspace binds
        workspaceBinds = builtins.listToAttrs (
          builtins.concatMap (
            ws: let
              bind =
                if ws == 10
                then "0"
                else toString ws;
            in [
              {
                name = "${mod}+${bind}";
                value = "workspace number ${toString ws}";
              }
              {
                name = "${mod}+Shift+${bind}";
                value = "move container to workspace number ${toString ws}; workspace number ${toString ws}";
              }
            ]
          ) (builtins.genList (n: n + 1) 10)
        );
      in
        workspaceBinds
        // {
          # Apps
          "${mod}+t" = "exec ${terminal}";
          "${mod}+b" = "exec ${browser}";
          "${mod}+m" = "exec ${menu}";

          # Window control
          "${mod}+q" = "kill";
          "${mod}+v" = "floating toggle";
          "${mod}+f" = "fullscreen toggle";

          # Scratchpad
          "${mod}+i" = "scratchpad show";
          "${mod}+Shift+i" = "move scratchpad";

          # Resize mode
          "${mod}+r" = "mode resize";

          # Focus
          "${mod}+h" = "focus left";
          "${mod}+l" = "focus right";
          "${mod}+k" = "focus up";
          "${mod}+j" = "focus down";

          # Move windows
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+j" = "move down";

          # Move workspace between outputs
          "${mod}+Shift+y" = "move workspace to output left";
          "${mod}+Shift+u" = "move workspace to output right";

          # Screenshots
          "Print" = "exec grimshot save area ~/Pictures/Screenshots";
          "Ctrl+Print" = "exec grimshot save window ~/Pictures/Screenshots";
          "${mod}+Print" = "exec grimshot save output ~/Pictures/Screenshots";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          "XF86AudioRaiseVolume" = "exec sway-volumectl --vol +5";
          "XF86AudioLowerVolume" = "exec sway-volumectl --vol -5";
          "XF86AudioMute" = "exec sway-volumectl --mute-toggle";
          "XF86AudioMicMute" = "exec sway-volumectl --mic-toggle";

          "XF86MonBrightnessUp" = "exec swayosd-client --brightness +10";
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness -10";
        };

      modes.resize = {
        "h" = "resize shrink width 10px";
        "l" = "resize grow width 10px";
        "k" = "resize shrink height 10px";
        "j" = "resize grow height 10px";
        "${mod}+r" = "mode default";
        "Escape" = "mode default";
      };

      input = {
        "*" = {
          xkb_layout = "pl";
          xkb_options = "caps:escape";
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
    };

    extraConfig = ''
      bindgesture swipe:3:right workspace next
      bindgesture swipe:3:left workspace prev
    '';
  };
}
