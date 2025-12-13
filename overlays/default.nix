inputs: [
  # Unstable packages overlay
  (final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = _prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  })

  # Custom packages overlay
  (final: _prev: {
    mimo = {
      assets = final.callPackage ../pkgs/assets.nix {};
      sway-volumectl = final.callPackage ../pkgs/sway-volumectl.nix {};
      sway-battery-notify = final.callPackage ../pkgs/sway-battery-notify.nix {};
      sway-close-gracefully = final.callPackage ../pkgs/sway-close-gracefully.nix {};
      sway-splash = final.callPackage ../pkgs/sway-splash.nix {};
    };
  })
]
