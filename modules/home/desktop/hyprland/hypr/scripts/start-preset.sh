#!/usr/bin/env bash

# Heavily inspired by wimpysworld's hyprActivity
# https://github.com/wimpysworld/nix-config/blob/b19c79a0cc88cd9db8ef7221e27f16101ab9aa0d/home-manager/_mixins/desktop/hyprland/default.nix#L10

set +e # Disable errexit
set +u # Disable nounset

function is_running() {
  local WIN_PARAM="$1"
  local type
  local value
  local jq_arg

  type=$(echo "$WIN_PARAM" | cut -d: -f1)
  value=$(echo "$WIN_PARAM" | cut -d: -f2)

  jq_arg=".[] | select(.$type == \"$value\")"

  if hyprctl clients -j | jq -e "$jq_arg" >/dev/null; then
    return 0
  fi
  return 1
}

function wait_for_app() {
  local COUNT=0
  local SLEEP="0.1"
  local LIMIT=100 # NOT SECONDS but number of sleeps
  local WIN_PARAM="$1"
  echo " - Waiting for $WIN_PARAM..."
  while ! is_running "$WIN_PARAM"; do
    sleep "$SLEEP"
    ((COUNT++))
    if [ "$COUNT" -ge "$LIMIT" ]; then
      echo " - Failed to find $WIN_PARAM"
      break
    fi
  done
}

function move_app() {
  local WIN_PARAM="$1"
  local WORKSPACE="$2"
  local type
  local value

  type=$(echo "$WIN_PARAM" | cut -d: -f1)
  value=$(echo "$WIN_PARAM" | cut -d: -f2)

  type=$(echo "$type" | tr '[:upper:]' '[:lower:]') # eg. initialtitle instead of initialTitle

  WIN_PARAM="$type:$value"

  echo -n " - Moving $WIN_PARAM to $WORKSPACE: "
  hyprctl dispatch movetoworkspacesilent "$WORKSPACE, $WIN_PARAM"
}

function start_app() {
  local APP="$1"
  local WORKSPACE="$2"
  local WIN_PARAM="$3"
  echo -n " - Starting $APP on workspace $WORKSPACE: "
  hyprctl dispatch exec "[workspace $WORKSPACE silent]" "$APP"
  wait_for_app "$WIN_PARAM"
  move_app "$WIN_PARAM" "$WORKSPACE"
}

function start_singleton_app() {
  local APP="$1"
  local WORKSPACE="$2"
  local WIN_PARAM="$3" # A parameter that will identify a window https://wiki.hyprland.org/Configuring/Dispatchers/
  if ! is_running "$WIN_PARAM"; then
    start_app "$APP" "$WORKSPACE" "$WIN_PARAM"
  else
    echo " - $APP is already running"
  fi
}

function preset_default() {
  start_singleton_app "brave --password-store=gnome" 1 "class:brave-browser"
  start_singleton_app kitty 2 "class:kitty"
  start_singleton_app signal-desktop 5 "class:signal"
  start_singleton_app vesktop 7 "initialTitle:Discord"
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
