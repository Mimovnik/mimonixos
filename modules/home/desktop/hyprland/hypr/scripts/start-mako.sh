#!/usr/bin/env bash

# Kill already running process
pid=$(pidof mako)
if [[ pid ]]; then
  kill -9 ${pid}
fi

CONFIG="$HOME/.config/hypr/mako/config"

mako --config ${CONFIG} &
