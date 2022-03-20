{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "kwin-forceblur";
  version = "unstable-2022-02-13";

  src = fetchFromGitHub {
    owner = "esjeon";
    repo = "kwin-forceblur";
    rev = "1f92ed59d4e445587ad4245f374f90f61850f29f";
    sha256 = "1sk0lx0v4iidsc3ph93p5qqm0vagjpvfficxg79z8zp31zmjv151";
  };

  installPhase = ''
    install -d $out/share/kwin/scripts/forceblur
    cp -r contents/ LICENSE image.png metadata.desktop "$out/share/kwin/scripts/forceblur/"
    install -Dm644 metadata.desktop "$out/share/kservices5/kwin-script-forceblur.desktop"
  '';

  meta = with lib; {
    description = "Force-enable blur effect to user-specified windows";
    homepage = "https://github.com/esjeon/kwin-forceblur";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
