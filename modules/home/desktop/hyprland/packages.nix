{pkgs, ...}: {
  home.packages = with pkgs; [
    # Must-have https://wiki.hyprland.org/Useful-Utilities/Must-have/
    hyprpolkitagent
    # kdePackages.kwallet # brave uses that
    xdg-desktop-portal-hyprland
    wireplumber
    kdePackages.xwaylandvideobridge
    kdePackages.qtwayland
    kdePackages.kwallet

    # Status bar
    waybar
    networkmanagerapplet
    pwvucontrol
    wlogout

    # Application runner
    rofi-wayland

    # Wallpaper and cursor
    hyprpaper
    hyprcursor

    # Screen lock and idle
    hypridle
    hyprlock

    # Notifications
    mako
    swayosd
    libnotify # needed for notify-send

    # Utils
    wl-clipboard # copy/paste (also wl-copy cmd)
    brightnessctl # adjust brightness
    hyprshot # screen shot
    jq # json parser
    alsa-utils

    # Color picker
    hyprpicker
    imagemagick
  ];
}
