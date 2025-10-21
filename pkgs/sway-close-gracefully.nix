{pkgs}:
pkgs.writeShellApplication {
  name = "sway-close-gracefully";
  runtimeInputs = [pkgs.sway pkgs.jq pkgs.coreutils pkgs.systemd];
  text = ''
    LOG_FILE=/tmp/sway/gracefully.log
    if [ ! -d /tmp/sway ]; then
      mkdir /tmp/sway
    fi

    usage() {
      echo "Usage: sway-close-gracefully <shutdown|reboot|logout|cancel> [sleep_duration]"
      echo "  shutdown       Gracefully close windows and power off"
      echo "  reboot         Gracefully close windows and reboot"
      echo "  logout         Gracefully close windows and exit sway"
      echo "  cancel         Kill other running sway-close-gracefully script instances"
      echo "  sleep_duration Optional, seconds to wait before action (default: 2)"
      echo "Example: sway-close-gracefully shutdown 5"
    }

    sleep_duration="''${2:-2}"

    close() {
      for id in $(swaymsg -t get_tree | jq '.. | select(.type? == "con") | .id'); do
        swaymsg "[con_id=$id] kill" >> $LOG_FILE 2>&1
      done
    }

    if [[ "$1" == "" || "$1" == "-h" || "$1" == "--help" ]]; then
      usage
      exit 0
    fi

    if [[ "$1" == "shutdown" ]]; then
      close
      sleep "$sleep_duration"
      systemctl poweroff >> $LOG_FILE 2>&1
    elif [[ "$1" == "reboot" ]]; then
      close
      sleep "$sleep_duration"
      systemctl reboot >> $LOG_FILE 2>&1
    elif [[ "$1" == "logout" ]]; then
      close
      sleep "$sleep_duration"
      swaymsg exit >> $LOG_FILE 2>&1
    elif [[ "$1" == "cancel" ]]; then
      echo "Cancelling other sway-close-gracefully instances..." >> $LOG_FILE
      # Find and kill other running instances except self
      self_pid=$$
      pgrep -f "sway-close-gracefully" | grep -v "^$self_pid$" | while read -r pid; do
        kill "$pid" && echo "Killed sway-close-gracefully PID $pid" >> $LOG_FILE
      done
      exit 0
    else
      echo "No such command: $1" >&2
      usage
      exit 1
    fi
  '';
}
