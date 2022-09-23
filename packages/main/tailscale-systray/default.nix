{
  pname,
  version,
  src,
  #
  lib,
  buildGoModule,
  gtk3,
  pkg-config,
  libappindicator-gtk3,
}:
buildGoModule rec {
  inherit pname version src;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
  ];

  vendorSha256 = "sha256-dTznGNi54vGldvE8/eujiUmZZ/Ks0vRVxQQIabwyVH4=";

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    license = licenses.mit;
  };
}
