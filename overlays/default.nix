{nixpkgs-unstable}: [
  # Unstable packages overlay
  (final: _prev: {
    unstable = import nixpkgs-unstable {
      system = _prev.system;
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
    };
  })
]
