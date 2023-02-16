{
  pname,
  src,
  version,
  #
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    unzip $src -d $PWD

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    dest=$out/share/fonts/truetype
    mkdir -p $dest
    cp -avL *.ttf $dest

    runHook postInstall
  '';
}
