{ pname
, date
, src
, #
  lib
, buildGoModule
, pkg-config
, libayatana-appindicator-gtk3
, gtk3
,
}:
buildGoModule rec {
  inherit pname src;
  version = date;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator-gtk3
  ];

  vendorSha256 = "sha256-cztIq7Kkj5alAYDtbPU/6h5S+nG+KAyxJzHBb3pJujs=";

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    license = licenses.mit;
  };
}
