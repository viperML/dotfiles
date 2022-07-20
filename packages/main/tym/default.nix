{
  pname,
  version,
  src,
  #
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pcre2,
  vte,
  gtk3,
  lua5_3,
  lib,
}:
stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre2
    vte
    gtk3
    lua5_3
  ];

  meta = with lib; {
    description = "Lua-configurable terminal emulator";
    homepage = "https://github.com/endaaman/tym";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
