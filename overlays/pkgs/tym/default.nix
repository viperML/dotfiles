{
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
  pname = "tym";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = pname;
    rev = version;
    sha256 = "0623i1m6cmy61msa9sj43wni6szmisk3zsnyl7a9qq9zjprayk74";
  };

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
