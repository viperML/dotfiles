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
  version = "unstable-3.2.0";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "tym";
    rev = "7f0ff1d48e43a19fe4287c606b887f3d34e01e03";
    sha256 = "1s7cz60l61fgvl7sw6dm9pz4mjbrjwrspwa8rzmh5spl9wnskdy1";
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
