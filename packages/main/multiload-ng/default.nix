{
  pname,
  src,
  date,
  #
  stdenv,
  autoreconfHook,
  libappindicator,
  pkg-config,
  intltool,
  gettext,
}:
stdenv.mkDerivation {
  inherit pname src;
  version = date;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    gettext
  ];

  configureFlags = [
    "--disable-autostart"
    "--without-indicator"
  ];

  postUnpack = ''
    patchShebangs source/data/*.sh{.in,}
  '';

  buildInputs = [
    libappindicator
  ];
}
