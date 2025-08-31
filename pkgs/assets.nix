{stdenv, ...}:
stdenv.mkDerivation {
  name = "assets";
  src = ../assets;
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
