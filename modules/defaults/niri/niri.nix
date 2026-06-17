{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.systemDesktopNiri = {
    config,
    lib,
    pkgs,
    username,
    ...
  }: let
    cfg = config.defaults.niri;
  in {
    imports = [
      ./_login.nix
      ./_gtk.nix
    ];

    options.defaults.niri = {
      enable = lib.mkEnableOption "niri desktop";

      package = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        readOnly = true;
        description = "Wrapped niri package used by this desktop module.";
      };

      workspaces = lib.mkOption {
        type = lib.types.submodule {
          options = lib.genAttrs (map toString (lib.range 1 10)) (number: {
            output = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Output for workspace ${number}.";
            };
          });
        };
        default = {};
        description = "Named niri workspace placement.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Host-specific niri KDL appended to the generated config.";
      };
    };

    config = lib.mkIf cfg.enable {
      programs.niri = {
        enable = true;
        package = cfg.package.wrap {
          "config.kdl".content = lib.mkAfter ''
            ${cfg.extraConfig}

            // Workspaces
            ${lib.concatStringsSep "\n" (
              map (
                number: let
                  output = cfg.workspaces.${number}.output;
                in
                  if output == null
                  then ''
                    workspace "${number}"
                  ''
                  else ''
                    workspace "${number}" {
                        open-on-output "${output}"
                    }
                  ''
              ) (map toString (lib.range 1 10))
            )}
          '';
        };
      };

      environment.systemPackages = [
        cfg.package
        pkgs.bibata-cursors
        pkgs.xwayland-satellite
        pkgs.tuigreet
      ];

      services.seatd.enable = true;
      users.users.${username}.extraGroups = ["seat"];

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gnome];
        config.common.default = ["gnome"];
      };
    };
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    terminal = "${lib.getExe pkgs.kitty}";

    noctalia = "${noctalia-shell}/bin/noctalia-shell";
    noctalia-shell = inputs.nix-wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      settings = lib.fromJSON (lib.readFile ./noctalia-settings.json);
    };

    niri = inputs.nix-wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      "config.kdl".content = ''
        layout {
            background-color "#000000"

            gaps 12
            center-focused-column "never"

            focus-ring {
                width 3
                active-color "#7fc8ff"
                inactive-color "#505050"
            }

            border {
                off
            }
        }

        prefer-no-csd

        cursor {
            xcursor-theme "Bibata-Modern-Ice"
            xcursor-size 24
        }

        input {
            keyboard {
                xkb {
                    layout "pl"
                    options "caps:escape"
                }
            }

            mouse {
                accel-speed -0.5
                accel-profile "flat"
            }
        }

        clipboard {
            disable-primary
        }

        environment {
            NIXOS_OZONE_WL "1"
            ELECTRON_OZONE_PLATFORM_HINT "auto"
        }

        spawn-at-startup "${noctalia}"
        spawn-sh-at-startup "sleep 2 && ${lib.getExe pkgs.brave}"
        spawn-sh-at-startup "sleep 2 && ${lib.getExe pkgs.discord}"
        spawn-sh-at-startup "sleep 2 && ${lib.getExe pkgs.signal-desktop}"

        xwayland-satellite {
            path "${lib.getExe pkgs.xwayland-satellite}"
        }

        hotkey-overlay {
            skip-at-startup
        }

        window-rule {
            open-maximized true
        }

        window-rule {
            match app-id=r#"^kitty$"#
            open-maximized false
            default-column-width { proportion 0.5; }
        }

        window-rule {
            // Match bitwarden extenstion
            // <brave prefix>-<extension id>-<profile name>
            match app-id=r#"^brave-nngceckbapebfimnlniiiahkandclblb-.*$"#

            open-focused true
            open-floating true
            default-column-width { fixed 448; }
            default-window-height { fixed 620; }
        }

        window-rule {
            match at-startup=true app-id=r#"^brave-browser$"#
            open-on-workspace "1"
        }

        window-rule {
            match at-startup=true app-id=r#"^discord$"#
            match at-startup=true app-id=r#"^signal$"#
            open-on-workspace "6"
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+1 { focus-workspace "1"; }
            Mod+2 { focus-workspace "2"; }
            Mod+3 { focus-workspace "3"; }
            Mod+4 { focus-workspace "4"; }
            Mod+5 { focus-workspace "5"; }
            Mod+6 { focus-workspace "6"; }
            Mod+7 { focus-workspace "7"; }
            Mod+8 { focus-workspace "8"; }
            Mod+9 { focus-workspace "9"; }
            Mod+0 { focus-workspace "10"; }

            Mod+Ctrl+1 { move-column-to-workspace "1"; }
            Mod+Ctrl+2 { move-column-to-workspace "2"; }
            Mod+Ctrl+3 { move-column-to-workspace "3"; }
            Mod+Ctrl+4 { move-column-to-workspace "4"; }
            Mod+Ctrl+5 { move-column-to-workspace "5"; }
            Mod+Ctrl+6 { move-column-to-workspace "6"; }
            Mod+Ctrl+7 { move-column-to-workspace "7"; }
            Mod+Ctrl+8 { move-column-to-workspace "8"; }
            Mod+Ctrl+9 { move-column-to-workspace "9"; }
            Mod+Ctrl+0 { move-column-to-workspace "10"; }


            Mod+T hotkey-overlay-title="Open a Terminal" { spawn "${terminal}"; }
            Mod+D hotkey-overlay-title="Run an Application" { spawn "${noctalia}" "ipc" "call" "launcher" "toggle"; }
            Mod+Shift+O repeat=false { toggle-overview; }

            XF86AudioPlay { spawn "${noctalia}" "ipc" "call" "media" "playPause"; }
            XF86AudioStop { spawn "${noctalia}" "ipc" "call" "media" "stop"; }
            XF86AudioNext { spawn "${noctalia}" "ipc" "call" "media" "next"; }
            XF86AudioPrev { spawn "${noctalia}" "ipc" "call" "media" "previous"; }
            XF86AudioForward { spawn "${noctalia}" "ipc" "call" "media" "seekRelative" "10"; }
            XF86AudioRewind { spawn "${noctalia}" "ipc" "call" "media" "seekRelative" "-10"; }

            XF86AudioRaiseVolume { spawn "${noctalia}" "ipc" "call" "volume" "increase"; }
            XF86AudioLowerVolume { spawn "${noctalia}" "ipc" "call" "volume" "decrease"; }
            XF86AudioMute { spawn "${noctalia}" "ipc" "call" "volume" "muteOutput"; }
            XF86AudioMicMute { spawn "${noctalia}" "ipc" "call" "volume" "muteInput"; }

            XF86MonBrightnessUp { spawn "${noctalia}" "ipc" "call" "brightness" "increase"; }
            XF86MonBrightnessDown { spawn "${noctalia}" "ipc" "call" "brightness" "decrease"; }

            Print { screenshot; }
            Alt+Print { screenshot-window; }
            Ctrl+Print { screenshot-screen; }

            Mod+Shift+Q repeat=false { close-window; }
            Mod+V { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }
            Mod+M { maximize-column; }
            Mod+Shift+F { fullscreen-window; }

            Mod+Left { focus-column-left; }
            Mod+Down { focus-window-down; }
            Mod+Up { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+H { focus-column-left; }
            Mod+J { focus-window-down; }
            Mod+K { focus-window-up; }
            Mod+L { focus-column-right; }

            Mod+Ctrl+Left { move-column-left; }
            Mod+Ctrl+Down { move-window-down; }
            Mod+Ctrl+Up { move-window-up; }
            Mod+Ctrl+Right { move-column-right; }
            Mod+Ctrl+H { move-column-left; }
            Mod+Ctrl+J { move-window-down; }
            Mod+Ctrl+K { move-window-up; }
            Mod+Ctrl+L { move-column-right; }

            Mod+Shift+Left { focus-monitor-left; }
            Mod+Shift+Down { focus-monitor-down; }
            Mod+Shift+Up { focus-monitor-up; }
            Mod+Shift+Right { focus-monitor-right; }
            Mod+Shift+H { focus-monitor-left; }
            Mod+Shift+J { focus-monitor-down; }
            Mod+Shift+K { focus-monitor-up; }
            Mod+Shift+L { focus-monitor-right; }

            Mod+Ctrl+Shift+Left { move-column-to-monitor-left; }
            Mod+Ctrl+Shift+Down { move-column-to-monitor-down; }
            Mod+Ctrl+Shift+Up { move-column-to-monitor-up; }
            Mod+Ctrl+Shift+Right { move-column-to-monitor-right; }
            Mod+Ctrl+Shift+H { move-column-to-monitor-left; }
            Mod+Ctrl+Shift+J { move-column-to-monitor-down; }
            Mod+Ctrl+Shift+K { move-column-to-monitor-up; }
            Mod+Ctrl+Shift+L { move-column-to-monitor-right; }

            Mod+U { focus-workspace-down; }
            Mod+I { focus-workspace-up; }
            Mod+Ctrl+U { move-column-to-workspace-down; }
            Mod+Ctrl+I { move-column-to-workspace-up; }
            Mod+Shift+U { move-workspace-down; }
            Mod+Shift+I { move-workspace-up; }

            Mod+O { consume-or-expel-window-left; }
            Mod+P { consume-or-expel-window-right; }
            Mod+BracketLeft { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-column-width-back; }
            Mod+C { center-column; }
            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }
            Mod+Ctrl+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }

            Mod+Shift+E { quit; }
            Ctrl+Alt+Delete { quit; }
        }
      '';
    };
  in {
    packages.noctalia-shell = noctalia-shell;
    packages.niri = niri;
  };
}
