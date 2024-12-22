{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "sddm-chili-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';
}
