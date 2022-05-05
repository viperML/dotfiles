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
  version = "unstable-2022-02-09";

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
    rev = "64347899f5c60ccc3a7c5ebfa193364b918a38ef";
    sha256 = "1h1fm4ps28xzfg5n9bz346l0syxncpgrmff0jz5xjywh9a3z5153";
  };

  vendorSha256 = "sha256-dTznGNi54vGldvE8/eujiUmZZ/Ks0vRVxQQIabwyVH4=";

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    license = licenses.mit;
  };
}
