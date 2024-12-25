#!/usr/bin/env bash

INTERVAL=0.1
while true; do
  CLASS=$(hyprctl activewindow -j | jq -r '.initialClass')
  TITLE=$(hyprctl activewindow -j | jq -r '.title')

  if [[ "$CLASS" = "null" || "$TITLE" = "null" ]]; then
    echo ""
  else
    echo "$CLASS - $TITLE"
  fi
  sleep $INTERVAL
done

