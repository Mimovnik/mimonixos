inputs: [
  # Unstable packages overlay
  (_final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (_prev.stdenv.hostPlatform) system;
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

  # niri's current PipeWire screencast path is dmabuf-only. Some Electron
  # clients, including Discord/Vesktop, need SHM fallback to negotiate video.
  (_final: prev: {
    niri = prev.niri.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          # SHM screencast fallback patch contributed by wrvsrx:
          # https://github.com/wrvsrx/niri/compare/8ed0da44d974c32c6877d2f4630c314da0717ecb..2ab59b90d55afbbe362a63e2a061afe4b524d8c4.patch
          ./_patches/niri-shm-screencast-26.04.patch
        ];
    });
  })

  # GitHub flake packages overlay
  (final: _prev: {
    wifitui = inputs.wifitui.packages.${final.stdenv.hostPlatform.system}.default;
  })
]
