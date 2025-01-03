#!/usr/bin/env bash

# This startup script runs on hyprland load

start() {
  # Prevent from starting a program if it's running
  pidof $1 || $1 &
}

start hyprpaper
start hypridle

start nm-applet
start signal-desktop

~/.config/hypr/scripts/start-mako.sh &

~/.config/hypr/scripts/start-waybar.sh &

