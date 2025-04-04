#!/usr/bin/env bash

CMD_PIPE="/tmp/timer_cmd.pipe"
OUT_FILE="/tmp/timer_out.txt"
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
  $RESET | $PAUSE)
    echo $cmd >"$CMD_PIPE"
    ;;
  $INC | $DEC)
    local delta=$2
    echo "$cmd $delta" >"$CMD_PIPE"
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
  if [[ -e "$PIDFILE" ]]; then
    if kill -0 $(cat "$PIDFILE"); then
      kill -SIGKILL $(cat "$PIDFILE")
    fi
    rm -f "$PIDFILE"
    rm -f "$CMD_PIPE"
  fi
  ;;
"print")
  cat "$OUT_FILE"
  ;;
*)
  echo "error: no such argument $1" >&2
  echo "usage: $0 {reset|pause-toggle|inc|dec|kill|print}" >&2
  echo "  reset: Reset the timer" >&2
  echo "  pause-toggle: Toggle pause state" >&2
  echo "  inc <seconds>: Increase timer by <seconds>" >&2
  echo "  dec <seconds>: Decrease timer by <seconds>" >&2
  echo "  kill: Kill the timer process" >&2
  echo "  print: Print the timer output" >&2
  exit 1
  ;;
esac
