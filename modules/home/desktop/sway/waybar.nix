{
  lib,
  pkgs,
  terminal,
  ...
}: {
  home.packages = with pkgs; [
    mimo.sway-volumectl
    # TODO: move to stable when available
    unstable.wiremix # tui for pipewire volume control
  ];

  programs.waybar = {
    enable = true;
    settings = [
      {
        position = "top";
        layer = "top";
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "custom/swaync"
          "pulseaudio"
          "battery"
        ];

        "sway/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };
        clock = {
          interval = 1;
          align = 0;
          rotate = 0;
          format = " {:%H:%M:%S}";
          tooltip-format = "<big> {:%a %b %d, %G}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "sway/mode" = {
          format = "{}";
          max-length = 10;
        };
        "custom/swaync" = {
          format = "<big>{icon}</big>";
          format-icons = {
            none = "";
            notification = "<span foreground='#f5c2e7'>󱅫</span>";
            "dnd-none" = "󰂠";
            "dnd-notification" = "󱅫";
            "inhibited-none" = "";
            "inhibited-notification" = "<span foreground='#f5c2e7'>󰅸</span>";
            "dnd-inhibited-none" = "󰪓";
            "dnd-inhibited-notification" = "󰅸";
          };
          max-length = 3;
          return-type = "json";
          escape = true;
          exec-if = "which swaync-client";
          exec = "swaync-client --subscribe-waybar";
          on-click = "swaync-client --toggle-panel --skip-wait";
          on-click-right = "swaync-client --toggle-dnd --skip-wait";
          tooltip-format = "󰵚  {} notification(s)";
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = " Mute";
          format-bluetooth = " {volume}% {format_source}";
          format-bluetooth-muted = " Mute";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            default = ["" "" ""];
          };
          scroll-step = 5.0;
          on-click = "sway-volumectl --mute-toggle";
          on-click-right = "${terminal} wiremix";
          on-scroll-up = "sway-volumectl --vol 5";
          on-scroll-down = "sway-volumectl --vol -5";
          smooth-scrolling-threshold = 1;
        };
        tray = {
          icon-size = 20;
          spacing = 5;
        };
        battery = {
          bat = "BAT0";
          adapter = "ADP0";
          interval = 5;
          states = {
            warning = 30;
            critical = 15;
          };
          max-length = 20;
          format = "{icon} {capacity}%";
          format-warning = "{icon} {capacity}%";
          format-critical = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-full = " {capacity}%";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
      }
    ];
    style = builtins.readFile ./colors.css + "\n" + builtins.readFile ./waybar.css;
  };
}
