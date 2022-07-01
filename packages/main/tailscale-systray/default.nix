{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gtk3,
  pkg-config,
  libappindicator-gtk3,
}:
buildGoModule rec {
  pname = "tailscale-systray";
  version = "unstable-2022-06-26";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
  ];

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "tailscale-systray";
    rev = "8e943debe7801a79c0e146cf9f53f0b9aa9d5e72";
    sha256 = "1ap8x5pmjiydi88rz2m65w9q8s104b56m6s7hyww8wwgda3sv0l8";
  };

  vendorSha256 = "sha256-dTznGNi54vGldvE8/eujiUmZZ/Ks0vRVxQQIabwyVH4=";

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    license = licenses.mit;
  };
}
