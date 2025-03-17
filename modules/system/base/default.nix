{
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  ...
}: {
  imports = [
    ../common/authorized-keys.nix
    ../common/tailscale.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Services
  services = {
    printing.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    dbus.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    blueman.enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Variables
  environment.variables.EDITOR = "vim";

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = hostname;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Users
  ## Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "dialout"];
    initialHashedPassword = "$y$j9T$LbWJ5akVYZD726dlgAc0c1$cbVuR3O5.Hc7y5r49xIIMzK.T/1evgK0h3Zy719RBgD";
  };

  # Nix
  nix = {
    settings = {
      experimental-features = "nix-command flakes";

      max-jobs = "auto";

      # Make legacy nix commands use the XDG base directories instead of creating directories in $HOME.
      use-xdg-base-directories = true;

      # The maximum number of parallel TCP connections used to fetch files from binary caches and by other downloads.
      # It defaults to 25. 0 means no limit.
      http-connections = 128;

      # This option defines the maximum number of substitution jobs that Nix will try to run in
      # parallel. The default is 16. The minimum value one can choose is 1 and lower values will be
      # interpreted as 1.
      max-substitution-jobs = 128;

      # The number of lines of the tail of the log to show if a build fails.
      log-lines = 25;

      # When free disk space in /nix/store drops below min-free during a build, Nix performs a
      # garbage-collection until max-free bytes are available or there is no more garbage.
      # A value of 0 (the default) disables this feature.
      min-free = 128000000; # 128 MB
      max-free = 1000000000; # 1 GB

      # Prevent garbage collection from altering nix-shells managed by nix-direnv
      # https://github.com/nix-community/nix-direnv#installation
      keep-outputs = true;
      keep-derivations = true;

      # Automatically detect files in the store that have identical contents, and replaces
      # them with hard links to a single copy. This saves disk space.
      auto-optimise-store = true;

      # Whether to warn about dirty Git/Mercurial trees.
      warn-dirty = false;

      ################
      # Substituters #
      ################

      # The timeout (in seconds) for establishing connections in the binary cache substituter.
      # It corresponds to curl’s –connect-timeout option. A value of 0 means no limit.
      connect-timeout = 5;

      # Allow the use of cachix
      trusted-users = [
        "root"
        "mimovnik"
      ];

      builders-use-substitutes = true;

      # If set to true, Nix will fall back to building from source if a binary substitute
      # fails. This is equivalent to the –fallback flag. The default is false.
      fallback = true;

      substituters = [
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: _prev: {
      unstable = import nixpkgs-unstable {
        system = _prev.system;
        config.allowUnfree = true;
      };
    })
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    git
    nix-prefetch-git
    just
    ripgrep
    nix-tree
    unstable.devenv
    pulseaudio
  ];

  # Locale
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      # nerdfonts
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
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

  # For gtk apps
  programs.dconf.enable = true;

  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
