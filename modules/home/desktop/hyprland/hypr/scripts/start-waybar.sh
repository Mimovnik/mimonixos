#!/usr/bin/env bash

# Kill already running process
pid=$(pidof waybar)
if [[ $pid ]]; then
  kill -9 "${pid}"
fi

CONFIG="$HOME/.config/hypr/waybar/config.jsonc"
STYLE="$HOME/.config/hypr/waybar/style.css"

waybar --bar main-bar --log-level error --config "${CONFIG}" --style "${STYLE}" &
