#!/usr/bin/env bash

SFX=$HOME/.config/hypr/sfx/duck.wav

change_vol() {
  local delta=$1
  swayosd-client --output-volume $delta
  aplay $SFX
}

toggle_vol() {
  swayosd-client --output-volume mute-toggle
  aplay $SFX
}

toggle_mic() {
  swayosd-client --input-volume mute-toggle
}

if [[ "$1" == "--vol" ]]; then
  change_vol $2
elif [[ "$1" == "--mute-toggle" ]]; then
  toggle_vol
elif [[ "$1" == "--mic-toggle" ]]; then
	toggle_mic
else
  echo "error: no such argument $1"
  exit 1
fi
