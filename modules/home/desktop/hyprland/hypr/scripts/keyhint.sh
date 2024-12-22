#!/bin/bash

HYPR_CONFIG=$HOME/.config/hypr/hyprland.conf
mod_key=$(sed -nre 's/^bind = \$\(.*\), (.*)/\1/p' ${HYPR_CONFIG} | head -n 1)

grep "^bind = " ${HYPR_CONFIG} \
    | sed "s/-\(-\w\+\)\+//g;s/\$mod/${mod_key}/g;s/Alt/Alt/g;s/bind = //;s/exec //;s/^\s\+//;s/,/ /;s/^\([^ ]\+\) \(.\+\)$/\2: \1/;s/^\s\+//" \
    | tr -s ' ' \
    | rofi -dmenu -theme ~/.config/rofi/keyhint.rasi
