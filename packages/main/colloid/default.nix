{
  pname,
  version,
  src,
  #
  stdenv,
  lib,
  fetchFromGitHub,
  gtk3,
  theme ? "default",
  scheme ? "default",
}:
stdenv.mkDerivation {
  inherit pname version src;
  __nocachix = true;
  nativeBuildInputs = [gtk3];


  installPhase = ''
    mkdir -p $out/share/icons
    bash ./install.sh --dest $out/share/icons \
      --theme ${theme} \
      --scheme ${scheme}
  '';

  meta = with lib; {
    description = "Colloid icon theme for linux desktops";
    inherit (src) homepage;
    license = licenses.gpl3;
    platform = platforms.linux;
  };
}
