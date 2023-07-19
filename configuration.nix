{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "mimonixos";
  };

  time.timeZone = "Europe/Warsaw";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    layout = "pl";
    xkbVariant = "";
  };
  
  hardware.opengl = {
     enable = true;
     driSupport = true;
     driSupport32Bit = true;
  };

  console.keyMap = "pl2";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users= {
    mimovnik = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
    };
    root = {
      extraGroups = [ "wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
   # cli utilis
    git
    curl
    wget
    htop
    vim
    zsh
    inxi

   # desktop stuff
    firefox
    
  ];

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  environment.shells = with pkgs; [ zsh ];

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "23.05";
}
