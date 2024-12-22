#!/usr/bin/env bash
LOG_FILE=/tmp/hypr/gracefully.log
if [ ! -d /tmp/hypr ]; then
  mkdir /tmp/hypr
fi

close() {
  HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
  hyprctl --batch "$HYPRCMDS" >> $LOG_FILE 2>&1
}

if [[ $1 = "shutdown" ]]; then
  close
  sleep 5
  systemctl poweroff >> $LOG_FILE 2>&1
elif [[ $1 = "reboot" ]]; then
  close
  sleep 5
  systemctl reboot >> $LOG_FILE 2>&1
elif [[ $1 = "logout" ]]; then
  close
  hyprctl dispatch exit >> $LOG_FILE 2>&1
else
  echo "No such command $1" >> $LOG_FILE
fi
