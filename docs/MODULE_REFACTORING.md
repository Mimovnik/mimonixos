# Mimonix NixOS Modules Refactoring

This document describes the refactoring of the Mimonix NixOS configuration from direct `imports = []` pattern to a proper NixOS module system with options and configuration.

## What Changed

### Before (Old Pattern)
Host configurations used direct imports:

```nix
{
  imports = [
    ../../modules/system/base
    ../../modules/system/boot
    ../../modules/system/steam
  ];
}
```

Modules were simple configuration files without options:

```nix
{pkgs, ...}: {
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [protonup-qt];
}
```

### After (New Pattern) 
Host configurations use options-based configuration:

```nix
{
  imports = [
    # Module imports remain for importing the module definitions
    ../../modules/system/base
    ../../modules/system/boot
    ../../modules/system/steam
  ];

  # New: Options-based configuration
  mimonix = {
    system.base.enable = true;
    system.boot.enable = true;
    programs.steam.enable = true;
  };
}
```

Modules now follow proper NixOS module pattern:

```nix
{config, lib, pkgs, ...}:
with lib; let
  cfg = config.mimonix.programs.steam;
in {
  options.mimonix.programs.steam = {
    enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [protonup-qt];
  };
}
```

## Module Namespace Organization

All modules are organized under the `mimonix.*` namespace:

### System Modules (`mimonix.system.*`)
- `mimonix.system.base` - Base system configuration
- `mimonix.system.boot` - Boot loader configuration

### Hardware Modules (`mimonix.hardware.*`) 
- `mimonix.hardware.nvidia` - NVIDIA graphics drivers

### Desktop Modules (`mimonix.desktop.*`)
- `mimonix.desktop.hyprland` - Hyprland Wayland compositor
- `mimonix.desktop.kde.system` - KDE Plasma system configuration
- `mimonix.desktop.kde.home` - KDE Plasma user configuration

### Program Modules (`mimonix.programs.*`)
- `mimonix.programs.steam` - Steam gaming platform
- `mimonix.programs.git` - Git version control (with user options)
- `mimonix.programs.kitty` - Kitty terminal (with theme options)
- `mimonix.programs.direnv` - direnv environment management
- `mimonix.programs.nixvim` - Neovim configuration
- `mimonix.programs.vscode` - Visual Studio Code

### Service Modules (`mimonix.services.*`)
- `mimonix.services.tailscale` - Tailscale VPN service
- `mimonix.services.adb` - Android Debug Bridge udev rules
- `mimonix.services.sddm` - SDDM display manager
- `mimonix.services.fprintd` - Fingerprint authentication

### Home Manager Modules
- `mimonix.home.base` - Base home-manager configuration
- `mimonix.shell` - Shell configuration (zsh, tmux, CLI tools)
- `mimonix.desktop.apps` - Desktop applications
- `mimonix.desktop.hyprland.home` - Hyprland user configuration

### Other Modules
- `mimonix.users.authorizedKeys` - SSH authorized keys
- `mimonix.networking.hostnames` - Local hostnames configuration
- `mimonix.virtualisation.docker` - Docker containerization

## Benefits of the New System

1. **Discoverability**: All available options are clearly defined with types and descriptions
2. **Modularity**: Features can be easily enabled/disabled per host
3. **Type Safety**: Options have proper types and validation
4. **Documentation**: Each option can have documentation built-in
5. **Consistency**: Follows standard NixOS module patterns
6. **Extensibility**: Easy to add new options to existing modules

## Migration Pattern

To migrate a module from old to new pattern:

1. Add proper module structure with `options` and `config`
2. Wrap configuration in `mkIf cfg.enable`
3. Use `with lib;` and define `cfg = config.mimonix.moduleName;`
4. Add module to `modules/mimonix.nix`
5. Update host configurations to use `mimonix.moduleName.enable = true;`

## Host Configuration Examples

### KDE Desktop Host
```nix
mimonix = {
  system.base.enable = true;
  system.boot.enable = true;
  desktop.kde.system.enable = true;
  programs.steam.enable = true;
};
```

### Hyprland Desktop Host  
```nix
mimonix = {
  system.base.enable = true;
  desktop.hyprland.enable = true;
  programs = {
    git.enable = true;
    kitty.enable = true;
  };
};
```

### Server Host
```nix
mimonix = {
  system.base.enable = true;
  services.tailscale.enable = true;
  networking.hostnames.enable = true;
};
```

This refactoring makes the configuration more maintainable, discoverable, and follows NixOS best practices.