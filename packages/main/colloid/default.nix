{
  pname,
  version,
  src,
  #
  stdenv,
  lib,
  fetchFromGitHub,
  gtk3,
  sassc,
  theme ? "default",
  tweaks ? "rimless",
}:
stdenv.mkDerivation {
  inherit pname version src;
  __nocachix = true;

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
    HOME=$PWD

    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons \
      --theme ${theme} \
      --tweaks ${tweaks}
  '';

  meta = with lib; {
    description = "Colloid icon theme for linux desktops";
    inherit (src) homepage;
    license = licenses.gpl3;
    platform = platforms.linux;
  };
}
