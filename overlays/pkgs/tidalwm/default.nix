{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "tidalwm";
  version = "unstable-2022-02-14";

  src = fetchFromGitHub {
    owner = "rustysec";
    repo = "tidalwm";
    rev = "bbf055a889267ade1d338398418f2fb485a3ba90";
    sha256 = "19h22hq34ng5jg52brzsn7w35d2vknycniviw6w2r3z7skz425y6";
  };

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${passthru.extensionUuid}
    cp -r $src/* $out/share/gnome-shell/extensions/${passthru.extensionUuid}
  '';

  passthru = {
    extensionUuid = "tidalwm@rustysec.github.io";
    extensionPortalSlug = "tidalwm";
  };
}
