{ lib
, stdenv
, fetchFromGitHub
, gtk3
, cairo
, intltool
, gettext
, autoreconfHook
, pkgconfig
}:
stdenv.mkDerivation {
  pname = "multiload-ng";
  version = "unstable-2021-01-03";

  src = fetchFromGitHub {
    owner = "udda";
    repo = "multiload-ng";
    rev = "743885da84474bfffc5f5505c0d1a7160de6afef";
    sha256 = "1v64775qjk41wf0ilp6mbabb73li0awrzwy7xmry8ddlf8sxpj00";
  };

  buildInputs =
    [
      gtk3
      cairo
      intltool
      gettext
    ];

  nativeBuildInputs =
    [
      autoreconfHook
      pkgconfig
    ];

  preBuild = ''
    chmod +x data/generate-about-data.sh
    patchShebangs data/generate-about-data.sh
    chmod +x data/generate-binary-data.sh
    patchShebangs data/generate-binary-data.sh
    chmod +x data/generate-color-scheme-icons.sh
    patchShebangs data/generate-color-scheme-icons.sh
  '';

  configureFlags = [
    "--disable-autostart"
  ];

  meta =
    with lib; {
      description = "Modern graphical system monitor for any panel (only systray and standalone builds)";
      homepage = "https://github.com/udda/multiload-ng";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
