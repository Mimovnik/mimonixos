#!/usr/bin/env bash

# Find JetBrains Mono font path
FONT_PATH=$(fc-list | grep -i 'jetbrains.*mono' | head -n 1 | cut -d: -f1)

if [ -z "$FONT_PATH" ]; then
  echo "JetBrains Mono font not found!" >&2
  exit 1
fi

# Create splash image
magick assets/wallpapers/blue_desert.png \
  -gravity south \
  -fill black \
  -draw "roundrectangle 710,815 1200,900 16,16" \
  -font "$FONT_PATH" \
  -pointsize 32 \
  -fill white \
  -annotate +0+200 'Setting up MimoNixOS...' \
  assets/wallpapers/blue_desert_splash.png
