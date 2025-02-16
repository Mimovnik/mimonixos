#!/usr/bin/env bash

# Heavily inspired by wimpysworld's hyprActivity
# https://github.com/wimpysworld/nix-config/blob/b19c79a0cc88cd9db8ef7221e27f16101ab9aa0d/home-manager/_mixins/desktop/hyprland/default.nix#L10

set +e # Disable errexit
set +u # Disable nounset

function app_is_running() {
  # Check if there is a window with $CLASS
  local CLASS="$1"
  local jq_cmd=".[] | select(.class == \"$CLASS\")"
  if hyprctl clients -j | jq -e "$jq_cmd" > /dev/null; then
    return 0
  fi
  return 1
}

function wait_for_app() {
  local COUNT=0
  local SLEEP="0.1"
  local LIMIT=50 # NOT SECONDS but number of sleeps
  local CLASS="$1"
  echo " - Waiting for $CLASS..."
  while ! app_is_running "$CLASS"; do
    sleep "$SLEEP"
    ((COUNT++))
    if [ "$COUNT" -ge "$LIMIT" ]; then
      echo " - Failed to find $CLASS"
      break
    fi
  done
}

function move_app() {
  local CLASS="$1"
  local WORKSPACE="$2"
  echo -n " - Moving $CLASS to $WORKSPACE: "
  hyprctl dispatch movetoworkspacesilent "$WORKSPACE, class:$CLASS"
}

function start_app() {
  local APP="$1"
  local WORKSPACE="$2"
  local CLASS="$3"
  echo -n " - Starting $APP on workspace $WORKSPACE: "
  hyprctl dispatch exec "[workspace $WORKSPACE silent]" "$APP"
  wait_for_app "$CLASS"
  move_app "$CLASS" "$WORKSPACE"
}

function start_singleton_app() {
  local APP="$1"
  local WORKSPACE="$2"
  local CLASS="$3"
  if ! app_is_running "$CLASS"; then
    start_app "$APP" "$WORKSPACE" "$CLASS"
  else
    echo " - $APP is already running"
  fi
}

function preset_default() {
  start_singleton_app "brave --password-store=gnome" 1 "brave-browser"
  start_singleton_app kitty 2 "kitty"
  start_singleton_app signal-desktop 5 "signal"
  start_singleton_app vesktop 7 "vesktop"
  hyprctl dispatch forcerendererreload
}

function preset_clear() {
  hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl dispatch closewindow address:{}
  sleep 0.75
  hyprctl dispatch workspace 1 &>/dev/null
}

OPT="help"
if [ -n "$1" ]; then
  OPT="$1"
fi

case "$OPT" in
default) preset_default ;;
clear) preset_clear ;;
*)
  echo "Usage: $(basename "$0") {default|clear}"
  exit 1
  ;;
esac
