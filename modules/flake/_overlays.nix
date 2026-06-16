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
          (prev.fetchpatch {
            name = "niri-shm-screencast-26.04.patch";
            url = "https://github.com/wrvsrx/niri/compare/tag_support-shm-sharing_4~19..tag_support-shm-sharing_4.patch";
            hash = "sha256-mfX0CVJWSFb/Hr1lDvlggphpXc2PI6C5CBa+aGwkVIM=";
          })
        ];
    });
  })

  # GitHub flake packages overlay
  (final: _prev: {
    wifitui = inputs.wifitui.packages.${final.stdenv.hostPlatform.system}.default;
  })
]
