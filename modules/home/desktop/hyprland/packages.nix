{pkgs, ...}: {
  home.packages = with pkgs; [
    # Must-have https://wiki.hyprland.org/Useful-Utilities/Must-have/
    libsForQt5.polkit-kde-agent # hyprpolkitagent doesnt work with brave???
    xdg-desktop-portal-hyprland
    libsForQt5.qt5.qtwayland

    # Status bar
    waybar
    networkmanagerapplet
    pwvucontrol
    wlogout
    alsa-utils

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
    libnotify # needed for notify-send

    # Utils
    wl-clipboard # copy/paste (also wl-copy cmd)
    brightnessctl # adjust brightness
    hyprshot # screen shot
    jq # json parser

    # Color picker
    hyprpicker
    imagemagick
  ];
}
