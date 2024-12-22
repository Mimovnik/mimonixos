#!/usr/bin/env bash

color=$(hyprpicker)
image=/tmp/${color}.png

# copy color code to clipboard
echo $color | tr -d "\n" | wl-copy
# generate preview
convert -size 48x48 xc:$color ${image}
# notify about it
notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i ${image} "$color, copied to clipboard."
