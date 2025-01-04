{lib, ...}: {
  # Startup
  "$startup" = "~/.config/hypr/scripts/startup.sh";
  exec-once = [
    "$startup"
  ];

  # Main mod
  "$mainMod" = lib.mkDefault "SUPER";

  # Programs
  "$terminal" = "kitty";
  "$menu" = "~/.config/hypr/scripts/menu.sh";
  "$logout" = "~/.config/hypr/scripts/logout.sh";
  "$colorpicker" = "~/.config/hypr/scripts/colorpicker.sh";
  "$keyhint" = "~/.config/hypr/scripts/keyhint.sh";
  "$volumectl" = "~/.config/hypr/scripts/volumectl.sh";
  "$brightctl" = "swayosd-client --brightness";
  "$browser" = "brave";

  bind =
    [
      # Program binds
      "$mainMod, T, exec, $terminal"
      "$mainMod, O, exec, $logout"
      "$mainMod, R, exec, $startup"
      "$mainMod, M, exec, $menu"
      "$mainMod, SPACE, exec, $menu"
      "$mainMod, B, exec, $browser"
      "$mainMod, C, exec, $colorpicker"
      "$mainMod, G, exec, $keyhint"

      # Window control
      "$mainMod, Q, killactive, "
      "$mainMod, V, togglefloating, "
      "$mainMod, F, Fullscreen, "
      "$mainMod, S, togglesplit," # dwindle
      "$mainMod, P, pseudo," # dwindle

      # Move focus
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"

      # Cycle focus through floating windows
      "$mainMod, Tab, cyclenext"
      "$mainMod, Tab, alterzorder, top"

      # Move current window
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod SHIFT, J, movewindow, d"

      # Move current workspace to different monitor
      "$mainMod SHIFT, Y, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT, U, movecurrentworkspacetomonitor, r"

      # Screenshot
      ",Print,exec,hyprshot -m region -o ~/Pictures/Screenshots -- imv"
      "CTRL,Print,exec,hyprshot -m window -o ~/Pictures/Screenshots -- imv"
      "SUPER,Print,exec,hyprshot -m output -o ~/Pictures/Screenshots -- imv"

      # Special workspace (scratchpad)
      "$mainMod, I, focusmonitor, l"
      "$mainMod, I, togglespecialworkspace, magic"
      "$mainMod SHIFT, I, movetoworkspace, special:magic"
    ]
    # Switch workspaces with mainMod + [0-9]
    # and
    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    ++ (
      builtins.concatLists (builtins.genList (i: let
          # 1,2,3..9 or 0 for tenth workspace
          ws = i + 1;
          bind =
            if ws == 10
            then 0
            else ws;
        in [
          "$mainMod, ${toString bind}, workspace, ${toString ws}"
          # and
          "$mainMod SHIFT, ${toString bind}, movetoworkspace, ${toString ws}"
        ])
        10)
    );

  bindl = [
    # Volume mute
    ",XF86AudioMute,exec, $volumectl --mute-toggle"
    ",XF86AudioMicMute,exec, $volumectl --mic-toggle"

    # Media control
    ",XF86AudioForward,exec, playerctl position 10+"
    ",XF86AudioPlay,exec, playerctl play-pause"
    ",XF86AudioRewind,exec, playerctl position 10-"
  ];

  bindel = [
    # Volume control
    ",XF86AudioRaiseVolume,exec, $volumectl --vol 5"
    ",XF86AudioLowerVolume,exec, $volumectl --vol -5"

    # Brightness control
    ",XF86MonBrightnessUp,exec, $brightctl +10"
    ",XF86MonBrightnessDown,exec, $brightctl -10"
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  xwayland = {
    use_nearest_neighbor = false;
  };

  env = [
    # TODO: move to system config
    "QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that"
    "ELECTRON_OZONE_PLATFORM_HINT,auto"

    # Cursor
    # TODO: move to system config
    "XCURSOR_SIZE,24"
    "XCURSOR_THEME,Bibata-Modern-Ice"
    "HYPRCURSOR_THEME,Bibata-Modern-Ice"
    "HYPRCURSOR_SIZE,24"
  ];

  input = {
    kb_layout = "pl";
    kb_options = "caps:escape";

    follow_mouse = 1;

    touchpad = {
      natural_scroll = true;
      scroll_factor = 0.2;
    };

    sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
    accel_profile = "adaptive"; # TODO: look into custom profiles
  };

  general = {
    gaps_in = 5;
    gaps_out = 5;
    border_size = 2;
    "col.active_border" = "rgba(61afefee) rgba(365e82ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
    allow_tearing = true;
  };

  decoration = {
    rounding = 5;
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };
  };

  animations = {
    enabled = true;

    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = true; # master switch for pseudotiling.
    preserve_split = true;
    force_split = 2; # split right
  };

  gestures = {
    workspace_swipe = true;
  };

  misc = {
    force_default_wallpaper = 0;
    disable_splash_rendering = true;
    key_press_enables_dpms = true;
    middle_click_paste = false;
  };

  binds = {
    workspace_center_on = 1;
  };
  # Window Rules
  windowrulev2 = [
    "suppressevent maximize, class:.*"

    # TODO: move to other file
    "immediate, class:^(Factorio)$" # Tearing related
  ];

  windowrule = [
    "suppressevent maximize, class:.*"

    "float,pwvucontrol"
    "size 30% 50%,pwvucontrol"

    "float,nm-connection-editor"
    "size 30% 50%,nm-connection-editor"

    "float,imv"

    "float,logout"
    "move 0 0,logout"
    "size 100% 100%,logout"
    "animation slide,logout"
  ];

  # Workspace Rules
  workspace = [
    "special:magic, on-created-empty:[size 60% 60%; float;] $terminal"
  ];
}
