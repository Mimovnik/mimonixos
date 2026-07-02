{
  flake.nixosModules.systemCommonAudioPriority = {
    services.pipewire.wireplumber.extraConfig."audio-priority" = {
      "wireplumber.settings" = {
        # Pick defaults from priority.session instead of remembered fallback history.
        "node.restore-default-targets" = false;
      };

      "monitor.bluez.rules" = [
        # Headphones as the highest priority output
        {
          matches = [
            {
              "node.name" = "~bluez_output.*";
              "node.description" = "PXC 550";
            }
          ];
          actions.update-props."priority.session" = 4000;
        }
      ];

      "monitor.alsa.rules" = [
        # Speakers as the second highest priority output
        {
          matches = [
            {
              "media.class" = "Audio/Sink";
              "node.description" = "Built-in Audio Analog Stereo";
            }
          ];
          actions.update-props."priority.session" = 3000;
        }
        # Fifine microphone as the highest priority input
        {
          matches = [
            {
              "media.class" = "Audio/Source";
              "node.description" = "fifine Microphone Analog Stereo";
            }
          ];
          actions.update-props."priority.session" = 3000;
        }
      ];
    };
  };
}
