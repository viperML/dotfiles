{
  stdenv,
  fetchFromGitHub,
  lib,
  gnome-themes-extra,
  gtk-engine-murrine,
  gtk_engines,
}:
stdenv.mkDerivation rec {
  __nocachix = true;
  pname = "rose-pine-gtk-theme";
  version = "unstable-2021-11-23";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    rev = "ec611972830f713bf6a0586ae5b7061384a41c1e";
    sha256 = "0mn4s0h1ag792x7majxv04wxcr14d2040pmf9rkr8sqqx1zki11z";
  };

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
    gtk_engines # pixmap engine for Gtk2
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine # murrine engine for Gtk2
  ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a rose-pine{-dawn,-moon,}-gtk $out/share/themes
  '';

  meta = with lib; {
    description = "Rosé Pine theme for GTK";
    homepage = "https://github.com/rose-pine/gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
