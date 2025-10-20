{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mimo.sway;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  options.mimo.sway = {
    enable = lib.mkEnableOption "Sway window manager configuration";

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };

    browser = lib.mkOption {
      type = lib.types.str;
      default = "brave --password-store=gnome --ozone-platform=x11";
      description = "Default web browser";
    };

    menu = lib.mkOption {
      type = lib.types.str;
      default = "rofi -show drun";
      description = "Default application launcher";
    };

    mod = lib.mkOption {
      type = lib.types.str;
      default = "Mod4"; # Super key
      description = "Modifier key for keybindings";
    };

    workspaceOutputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "1" = "DP-1";
        "2" = "DP-2";
        "3" = "HDMI-A-1";
      };
      description = "Map workspaces to specific outputs/monitors. Keys are workspace numbers as strings, values are output names as recognized by `swaymsg -t get_outputs`.";
    };

    outputs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          position = lib.mkOption {
            type = lib.types.str;
            example = "1920 0";
            description = "Position of the output in the format 'x y'";
          };
          resolution = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "1920x1080";
            example = "1920x1080";
            description = "Resolution of the output";
          };
          scale = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "1.0";
            example = "1.5";
            description = "Scale factor for the output";
          };
        };
      });
      default = {};
      example = {
        "HDMI-A-1" = {
          position = "0 0";
          resolution = "1920x1080";
        };
        "DP-1" = {
          position = "1920 0";
          resolution = "2560x1440";
          scale = "1.5";
        };
      };
      description = "Configuration for outputs/monitors including position, resolution, and scale.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Packages needed for Sway setup
    home.packages = with pkgs; [
      # Base packages
      xdg-utils # for xdg-open etc.
      playerctl # for controlling media player apps
      wl-clipboard # wayland clipboard management
      sway-contrib.grimshot # screenshot script
      mimo.sway-battery-notify # battery level notifications

      # Audio/Volume control
      alsa-utils # aplay command for playing sound
      mimo.sway-volumectl # Shell script to extend play sound when controlling volume

      # Waybar packages
      unstable.wiremix # tui for pipewire volume control
    ];

    # GTK theme and cursor settings
    home.sessionVariables.GTK_THEME = "Materia-dark";

    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 22;
      };
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 22;
    };

    # MIME app associations
    xdg.mimeApps = let
      setForAll = mimeApp: mimeTypes: lib.attrsets.genAttrs mimeTypes (_: mimeApp);
      defaults = lib.attrsets.concatMapAttrs setForAll {
        "feh.desktop" = [
          "image/bmp"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/tiff"
          "image/webp"
          "image/heic"
          "image/x-sony-arw"
        ];
      };
    in {
      enable = true;
      associations.added = defaults;
      defaultApplications = defaults;
    };

    # Services
    services.swaync = {
      enable = true;
      settings = {
        "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
        notification-inline-replies = true;
        positionX = "right";
        positionY = "top";
        widgets = ["title" "dnd" "notifications" "mpris" "volume"];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "󰩹";
          };
          dnd.text = "Do Not Disturb";
          mpris.blur = true;
          volume = {
            label = "󰓃";
            show-per-app = false;
          };
        };
      };
    };

    services.swayosd = {
      enable = true;
      topMargin = 0.1;
    };

    services.udiskie.enable = true;
    services.playerctld.enable = true;

    # Sway window manager configuration
    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true; # enables sway-session.target

      swaynag = {
        enable = true;
        settings = {
          "<config>" = {
            font = "Raleway 12";
            dismiss-button = "⨯";
            button-border-size = "0";
            border-bottom-size = "0";
            details-border-size = "0";
            button-padding = "6";
            button-gap = "12";
          };
          "warning" = {
            background = "ffff0090";
            button-background = "A2620280";
            text = "ffffffff";
            button-text = "ffffffff";
          };
        };
      };

      config = {
        defaultWorkspace = "workspace number 1";
        modifier = cfg.mod;
        bars = []; # disable default bars

        window = {
          border = 2;
          titlebar = false;
        };

        floating = {
          border = 2;
          titlebar = true;
        };

        # Workspace output assignments
        workspaceOutputAssign = lib.mkIf (cfg.workspaceOutputs != {}) (
          lib.mapAttrsToList (workspace: output: {
            workspace = workspace;
            output = output;
          })
          cfg.workspaceOutputs
        );

        startup = let
          webapps = config.mimo.webapps;
          startupTime = 15; # seconds to wait for startup apps to open
          startAppOnWorkspace = {
            app,
            title,
            workspace,
          }: "${app} & sleep ${toString startupTime} && swaymsg '[title=\"${title}\"] move workspace ${toString workspace}'";
        in [
          {command = "waybar";}
          {command = "sway-battery-notify";}
          {command = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";}
          {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}

          {command = "${cfg.terminal} --app-id terminal & sleep ${toString startupTime} && swaymsg '[app_id=\"terminal\"] move scratchpad'";}
          {
            command = startAppOnWorkspace {
              app = cfg.browser;
              title = "Brave";
              workspace = 1;
            };
          }
          {
            command = startAppOnWorkspace {
              app = webapps.chatgpt.exec;
              title = "ChatGPT";
              workspace = 2;
            };
          }
          {
            command = startAppOnWorkspace {
              app = "signal-desktop";
              title = "Signal";
              workspace = 5;
            };
          }
          {
            command = startAppOnWorkspace {
              app = "discord";
              title = "Discord";
              workspace = 7;
            };
          }
          {
            command = startAppOnWorkspace {
              app = webapps.nextcloud-deck.exec;
              title = "Deck";
              workspace = 8;
            };
          }
        ];

        # Keybindings
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
                  name = "${cfg.mod}+${bind}";
                  value = "workspace number ${toString ws}";
                }
                {
                  name = "${cfg.mod}+Shift+${bind}";
                  value = "move container to workspace number ${toString ws}; workspace number ${toString ws}";
                }
              ]
            ) (builtins.genList (n: n + 1) 10)
          );
        in
          workspaceBinds
          // {
            # Apps
            "${cfg.mod}+t" = "exec ${cfg.terminal}";
            "${cfg.mod}+b" = "exec ${cfg.browser}";
            "${cfg.mod}+m" = "exec ${cfg.menu}";

            # Window control
            "${cfg.mod}+q" = "kill";
            "${cfg.mod}+v" = "floating toggle";
            "${cfg.mod}+f" = "fullscreen toggle";

            # Scratchpad
            "${cfg.mod}+i" = "scratchpad show";
            "${cfg.mod}+Shift+i" = "move scratchpad";

            # Resize mode
            "${cfg.mod}+r" = "mode resize";

            # Focus
            "${cfg.mod}+h" = "focus left";
            "${cfg.mod}+j" = "focus down";
            "${cfg.mod}+k" = "focus up";
            "${cfg.mod}+l" = "focus right";

            # Move windows
            "${cfg.mod}+Shift+h" = "move left";
            "${cfg.mod}+Shift+j" = "move down";
            "${cfg.mod}+Shift+k" = "move up";
            "${cfg.mod}+Shift+l" = "move right";

            # Move workspace between outputs
            "${cfg.mod}+Shift+y" = "move workspace to output left";
            "${cfg.mod}+Shift+u" = "move workspace to output right";

            # Screenshots
            "Print" = "exec grimshot savecopy area ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S')_area.png";
            "Ctrl+Print" = "exec grimshot savecopy window ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S')_window.png";
            "${cfg.mod}+Print" = "exec grimshot savecopy output ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S')_output.png";

            # Media control
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";

            # Volume control
            "XF86AudioRaiseVolume" = "exec sway-volumectl --vol +5";
            "XF86AudioLowerVolume" = "exec sway-volumectl --vol -5";
            "XF86AudioMute" = "exec sway-volumectl --mute-toggle";
            "XF86AudioMicMute" = "exec sway-volumectl --mic-toggle";

            # Brightness control
            "XF86MonBrightnessUp" = "exec swayosd-client --brightness +10";
            "XF86MonBrightnessDown" = "exec swayosd-client --brightness -10";

            # System
            "${cfg.mod}+Shift+c" = "reload";
            "${cfg.mod}+Shift+q" = "exec swaynag -t warning -m 'Are you sure you want to quit?' -b 'Yes, shutdown' 'shutdown now' -b 'No, cancel' ''";
          };

        modes.resize = {
          "h" = "resize shrink width 10px";
          "l" = "resize grow width 10px";
          "k" = "resize shrink height 10px";
          "j" = "resize grow height 10px";
          "${cfg.mod}+r" = "mode default";
          "Escape" = "mode default";
        };

        # Input configuration
        input = {
          "*" = {
            xkb_layout = "pl";
            xkb_options = "caps:escape";
          };

          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };

          "type:pointer" = {
            # -1.0 to 1.0, where -1.0 is slowest and 1.0 is fastest
            pointer_accel = "-0.5";
            # "adaptive" or "flat"
            accel_profile = "adaptive";
          };
        };

        # Output configuration
        output = cfg.outputs;
      };

      extraConfig = ''
        bindgesture swipe:3:left workspace next_on_output
        bindgesture swipe:3:right workspace prev_on_output
        bindgesture swipe:3:up scratchpad show
        bindgesture swipe:3:down scratchpad show
      '';
    };

    # Rofi configuration
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;

      extraConfig = {
        display-drun = "";
      };

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

    # Waybar configuration
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
            on-click-right = "${cfg.terminal} wiremix";
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
            interval = 1;
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

      # CSS styling from the separate files
      style = builtins.readFile ./colors.css + "\n" + builtins.readFile ./waybar.css;
    };
  };
}
