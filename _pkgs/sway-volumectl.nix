{pkgs}:
pkgs.writeShellApplication {
  name = "sway-volumectl";
  runtimeInputs = [
    pkgs.alsa-utils
    pkgs.swayosd
    pkgs.mimo.assets
  ];
  text = ''
    SFX="${pkgs.mimo.assets}/sfx/bubble_pop.wav"

    change_vol() {
      local delta=$1
      swayosd-client --output-volume "$delta"
      aplay -D default $SFX
    }

    toggle_vol() {
      swayosd-client --output-volume mute-toggle
      aplay -D default $SFX
    }

    toggle_mic() {
      swayosd-client --input-volume mute-toggle
    }

    if [[ "$1" == "--vol" ]]; then
      change_vol "$2"
    elif [[ "$1" == "--mute-toggle" ]]; then
      toggle_vol
    elif [[ "$1" == "--mic-toggle" ]]; then
      toggle_mic
    else
      echo "error: no such argument $1"
      exit 1
    fi
  '';
}
