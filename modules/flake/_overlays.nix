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
      assets = final.callPackage ./_pkgs/assets.nix {};
      sway-volumectl = final.callPackage ./_pkgs/sway-volumectl.nix {};
      sway-battery-notify = final.callPackage ./_pkgs/sway-battery-notify.nix {};
      sway-close-gracefully = final.callPackage ./_pkgs/sway-close-gracefully.nix {};
    };
  })

  # GitHub flake packages overlay
  (final: _prev: {
    wifitui = inputs.wifitui.packages.${final.stdenv.hostPlatform.system}.default;
  })
]
