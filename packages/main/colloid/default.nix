{ pname
, version
, src
, #
  stdenvNoCC
, lib
, gtk3
, sassc
, theme ? "default"
, tweaks ? "rimless"
,
}:
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    gtk3
    sassc
  ];

  prePatch = ''
    scripts=(build.sh clean-old-theme.sh install.sh)
    for file in "''${scripts[@]}"; do
      sed -i '1s%.*%#!/usr/bin/env bash%' "$file"
      patchShebangs --build "$file"
    done
  '';

  installPhase = ''
    runHook preInstall
    HOME=$PWD

    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons \
      --theme ${theme} \
      --tweaks ${tweaks}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Colloid icon theme for linux desktops";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
