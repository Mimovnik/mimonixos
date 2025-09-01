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

        # Shell script to extend  play sound when controlling volume
        volumectlPkg = pkgs.writeShellApplication {
          name = "volumectl";
          runtimeInputs = [pkgs.alsa-utils]; # these will be in PATH
          text = ''
            SFX="${pkgs.mimo.assets}/sfx/bubble_pop.wav"

            change_vol() {
              local delta=$1
              swayosd-client --output-volume "$delta"
              aplay -D default $SFX
            }

            toggle_vol() {
              swayosd-client --output-volume mute-toggle
              aplay -D default $SFX
            }

            toggle_mic() {
              swayosd-client --input-volume mute-toggle
            }

            if [[ "$1" == "--vol" ]]; then
              change_vol "$2"
            elif [[ "$1" == "--mute-toggle" ]]; then
              toggle_vol
            elif [[ "$1" == "--mic-toggle" ]]; then
            	toggle_mic
            else
              echo "error: no such argument $1"
              exit 1
            fi

          '';
        };
        volumectl = "${volumectlPkg}/bin/volumectl";
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

          "XF86AudioRaiseVolume" = "exec ${volumectl} --vol +5";
          "XF86AudioLowerVolume" = "exec ${volumectl} --vol -5";
          "XF86AudioMute" = "exec ${volumectl} --mute-toggle";
          "XF86AudioMicMute" = "exec ${volumectl} --mic-toggle";

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
