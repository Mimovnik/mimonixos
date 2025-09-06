{pkgs}:
pkgs.writeShellApplication {
  name = "sway-battery-notify";
  runtimeInputs = [
    pkgs.libnotify
  ];
  text = let
    warn_threshold = "30";
    crit_threshold = "15";
  in ''
    warn_notified=0
    crit_notified=0

    while true; do
      BAT=$(cat /sys/class/power_supply/BAT0/capacity)
      STATUS=$(cat /sys/class/power_supply/BAT0/status)

      if [ "$BAT" -le "${warn_threshold}" ] && [ "$STATUS" != "Charging" ]; then
        if [ "$warn_notified" -eq 0 ]; then
          notify-send -u critical "Battery low" "Battery is at ''${BAT}%!"
          warn_notified=1
        fi
      else
        warn_notified=0
      fi

      if [ "$BAT" -le "${crit_threshold}" ] && [ "$STATUS" != "Charging" ]; then
        if [ "$crit_notified" -eq 0 ]; then
          notify-send -u critical "Battery low" "Battery is at ''${BAT}%!"
          crit_notified=1
        fi
      else
        crit_notified=0
      fi

      sleep 60
    done
  '';
}
