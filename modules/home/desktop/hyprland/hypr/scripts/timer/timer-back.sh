#!/usr/bin/env bash

TIME_IS_UP_MSG="Timer: The time is up!"

PIPE="/tmp/timer.pipe"
PIDFILE="/tmp/timer.pid"

# Commands
RESET="res"
PAUSE="pause"
INC="inc"
DEC="dec"

INIT_SECONDS=$((90 * 60))

total_seconds=$INIT_SECONDS
paused=true

print() {
  local seconds=$1
  minutes=$((total_seconds / 60))
  seconds=$((total_seconds % 60))

  echo "$(printf '%02d:%02d' $minutes $seconds)"
}

start() {
  while true;
  do
    total_seconds=$INIT_SECONDS
    paused=true
    print $total_seconds
    while [ $total_seconds -gt 0 ]
    do
      print $total_seconds
      if ! $paused; then
        sleep 1
        total_seconds=$((total_seconds - 1))
      else
        sleep 0.1
      fi
    done

    alarm
  done
}

alarm() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "$TIME_IS_UP_MSG"
}

cleanup() {
  rm -f $PIDFILE
  rm -f $PIPE
}

handle_signal() {
  case $1 in
    USR1)
      if read -r cmd arg < "$PIPE"; then
        case "$cmd" in
          $RESET)
            echo "Resetting: $(print $INIT_SECONDS)" >&2
            total_seconds=$INIT_SECONDS
            paused=true
            ;;
          $PAUSE)
            if $paused; then
              paused=false
            else
              paused=true
            fi
            echo "Paused: $paused" >&2
            ;;
          $INC)
            echo "Increasing timer: +$arg seconds" >&2
            total_seconds=$((total_seconds + arg))
            ;;
          $DEC)
            echo "Decreasing timer: -$arg seconds" >&2
            total_seconds=$((total_seconds - arg))
            if [[ $total_seconds -lt 0 ]]; then
              total_seconds=0
            fi
            ;;
          *)
            echo "Unknown command: $cmd with args: $arg" >&2
            ;;
        esac
      fi
      ;;
    TERM|INT)
      cleanup
      exit 0
      ;;
  esac
}

guard() {
  if [[ -e "$PIDFILE" ]]; then
    echo "Timer already running with pid $(cat "$PIDFILE")" >&2
    echo "Killing it and taking over" >&2
    kill -SIGKILL $(cat "$PIDFILE")
    cleanup
  fi
}

guard

echo $$ > "$PIDFILE"
mkfifo "$PIPE"

# Trap signals
trap 'handle_signal USR1' USR1
trap 'handle_signal INT' INT
trap 'handle_signal TERM' TERM

start
