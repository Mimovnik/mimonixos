#!/usr/bin/env bash

# Notifcations after time is up
# in format of "title@message" where @ is the delimeter
NOTIFY_MSGS=(
  "⏱️ Ultradian cycle complete!@Mental stamina isn’t just about grinding - it’s about recovery too. Step back and refresh 🧠"
  "⏱️ Cycle complete.@Don’t skip the break — that’s where the brain upgrades happen. 🧩"
  "🧠 Mental cooldown activated.@You’ve earned this break. Step away, no guilt. You’re building momentum the smart way. 🚶‍♂️☕"
  "💥 FOCUS BEAST MODE: DEACTIVATED@Recovery protocol engaged. Get up, breathe, and don’t even think about skipping that break."
  "💥 FOCUS BEAST MODE: DEACTIVATED@You just rode the peak of your brain’s ultradian wave. Now it needs that break to refuel. Step away and reload. 🧠🔋"
  "🔥 ULTRADIAN CYCLE: COMPLETE@Your brain’s run out of high-octane fuel — and no, more coffee isn’t the answer. Recharge now to come back sharper. ☕⚡"
  "🔥 PEAK PERFORMANCE WINDOW CLOSED@That 90-minute flow was no accident — it’s biology. Ignore the break and you’re working on fumes. Move it! 🧠💨"
  "🧠 COGNITIVE POWER DIPPING@That focus streak? Ultradian rhythm magic. Time to rest so the next wave hits hard. Don’t stall the comeback. 🌊"
)

CMD_PIPE="/tmp/timer_cmd.pipe"
OUT_FILE="/tmp/timer_out.txt"
PIDFILE="/tmp/timer.pid"

# Commands
RESET="res"
PAUSE="pause"
INC="inc"
DEC="dec"

INIT_SECONDS=$((90 * 60))

total_seconds=$INIT_SECONDS
paused=false

print() {
  local seconds=$1
  minutes=$((total_seconds / 60))
  seconds=$((total_seconds % 60))

  printf '%02d:%02d' $minutes $seconds >$OUT_FILE
}

start() {
  while true; do
    total_seconds=$INIT_SECONDS
    print $total_seconds
    while [ $total_seconds -gt 0 ]; do
      print $total_seconds
      if ! $paused; then
        sleep 1
        total_seconds=$((total_seconds - 1))
      else
        sleep 0.1
      fi
    done
    paused=true
    alarm
  done
}

alarm() {
  random_notify_msg=${NOTIFY_MSGS[RANDOM % ${#NOTIFY_MSGS[@]}]}
  title=$(echo "$random_notify_msg" | cut -d@ -f1)
  message=$(echo "$random_notify_msg" | cut -d@ -f2)
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "$title" "$message"
}

cleanup() {
  rm -f $PIDFILE
  rm -f $CMD_PIPE
  rm -f $OUT_FILE
}

handle_signal() {
  case $1 in
  USR1)
    if read -r cmd arg <"$CMD_PIPE"; then
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
  TERM | INT)
    cleanup
    exit 0
    ;;
  esac
}

guard() {
  if [[ -e "$PIDFILE" ]]; then
    echo "Timer already running with pid $(cat "$PIDFILE")" >&2
    echo "Exiting" >&2
    exit 0
  fi
}

guard

echo $$ >"$PIDFILE"
mkfifo "$CMD_PIPE"
touch "$OUT_FILE"

# Trap signals
trap 'handle_signal USR1' USR1
trap 'handle_signal INT' INT
trap 'handle_signal TERM' TERM

start
