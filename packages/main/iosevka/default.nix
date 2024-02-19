{ pname
, src
, version
, #
  stdenvNoCC
, unzip
, lib
,
}:
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = lib.removePrefix "v" version;

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
