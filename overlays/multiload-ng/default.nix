{ lib
, stdenv
, fetchFromGitHub
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "multiload-ng";
  version = "20210103";

  src = fetchFromGitHub {
    owner = "udda";
    repo = pname;
    rev = "743885da84474bfffc5f5505c0d1a7160de6afef";
    sha256 = "1v64775qjk41wf0ilp6mbabb73li0awrzwy7xmry8ddlf8sxpj00";
  };

  buildInputs = with pkgs; [
    gtk3
    cairo
    intltool
    gettext
    bash
  ];

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkgconfig
  ];


  meta = with lib; {
    description = "Modern graphical system monitor for any panel";
    homepage = "https://github.com/udda/multiload-ng";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
