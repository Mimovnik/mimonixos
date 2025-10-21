{pkgs}:
pkgs.writeShellApplication {
  name = "sway-splash";
  runtimeInputs = [pkgs.swayimg pkgs.sway pkgs.procps pkgs.mimo.assets];
  text = ''
    IMG="${pkgs.mimo.assets}/wallpapers/blue_desert_splash.png"

    swayimg --fullscreen --scale=fill \
      --config='general.decoration=no' \
      --config='info.show=no' \
      --config='info.viewer.top_left=none' \
      --config='info.viewer.top_right=none' \
      --config='info.viewer.bottom_left=none' \
      --config='info.viewer.bottom_right=none' \
      $IMG &

    sleep_duration="''${1:-15}"
    sleep "$sleep_duration"

    pkill -f "swayimg"
  '';
}
