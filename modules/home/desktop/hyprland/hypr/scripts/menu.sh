#!/usr/bin/env bash

if [[ ! $(pidof rofi) ]]; then
  CONFIG="$HOME/.config/hypr/rofi/dmenu.rasi"
  rofi -modi drun -show drun -config $CONFIG
else
	pkill rofi
fi
