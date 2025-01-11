#!/usr/bin/env bash

PIPE="/tmp/timer.pipe"
PIDFILE="/tmp/timer.pid"

# Commands
RESET="res"
PAUSE="pause"
INC="inc"
DEC="dec"

guard() {
  if [[ ! -e "$PIDFILE" ]] || ! kill -0 $(cat "$PIDFILE"); then
    echo "timer-back.sh is not running." >&2
    exit 1
  fi
}

send_cmd() {
  guard

  kill -USR1 $(cat "$PIDFILE")

  local cmd=$1
  case $cmd in
    $RESET|$PAUSE)
      echo $cmd > "$PIPE"
      ;;
    $INC|$DEC)
      local delta=$2
      echo "$cmd $delta" > "$PIPE"
      ;;
  esac
}

case $1 in
  "reset")
    send_cmd $RESET
    ;;
  "pause-toggle")
    send_cmd $PAUSE
    ;;
  "inc")
    send_cmd $INC "$2"
    ;;
  "dec")
    send_cmd $DEC "$2"
    ;;
  "kill")
    if [[ -e "$PIDFILE" ]];then
      if kill -0 $(cat "$PIDFILE"); then
        kill -SIGKILL $(cat "$PIDFILE")
      fi
      rm -f "$PIDFILE"
      rm -f "$PIPE"
    fi
    ;;
  *)
    echo "error: no such argument $1" >&2
    exit 1
    ;;
esac
