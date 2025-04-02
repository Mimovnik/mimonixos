#!/usr/bin/env bash

# This startup script runs on hyprland load

start() {
  # Prevent from starting a program if it's running
  pidof "$1" || $1 &
}

start hyprpaper

start nm-applet

~/.config/hypr/scripts/start-waybar.sh &

~/.config/hypr/scripts/preset.sh default &
