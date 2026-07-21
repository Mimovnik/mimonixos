{self, ...}: {
  # Shared by bare-metal / desktop Linux configs (carbon, glados).
  # Extends systemBase with the graphical, audio, printing and networking
  # bits that make no sense under WSL.
  flake.nixosModules.systemLinuxBase = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.systemBase
      self.nixosModules.systemCommonAudioPriority
    ];

    # Services
    services = {
      printing.enable = true;

      dbus.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
      };

      udisks2 = {
        enable = true;
      };

      gvfs.enable = true;
      pulseaudio.enable = false;

      avahi = {
        enable = true;
        nssmdns4 = true;

        ipv6 = false;
        nssmdns6 = true;

        openFirewall = true;
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
        };
      };
    };

    systemd.services."getty@tty5".enable = true;

    # Enable sound with pipewire.
    security.rtkit.enable = true;

    programs = {
      # For gtk apps
      dconf.enable = true;
    };

    # Networking
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth = lib.mkDefault {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          ControllerMode = "dual";
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Graphics tooling
    environment.systemPackages = with pkgs; [
      pulseaudio
      mesa-demos
      vulkan-tools
    ];

    # Fonts
    fonts = {
      packages = with pkgs; [
        # icon fonts
        material-design-icons
        # normal fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        # nerdfonts
        nerd-fonts.jetbrains-mono
      ];
      enableDefaultPackages = false;
      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };

    # Security
    security.polkit.enable = true;
  };
}
