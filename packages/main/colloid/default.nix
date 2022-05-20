{
  stdenv,
  lib,
  fetchFromGitHub,
  gtk3,
  theme ? "default",
  scheme ? "default",
}:
stdenv.mkDerivation {
  __nocachix = true;
  pname = "colloid";
  version = "2022-04-22";

  nativeBuildInputs = [gtk3];

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-icon-theme";
    rev = "94253e63401df7b8073ca65f6d8cdba0f36cd0bb";
    sha256 = "sha256-0lUdsTjIfZ76Mm327jE1uudxtKVQbt17fsel6c2RdVM=";
  };

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
