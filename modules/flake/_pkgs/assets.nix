{
  stdenv,
  flakeRoot,
  ...
}:
stdenv.mkDerivation {
  name = "assets";
  src = flakeRoot + /assets;
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
