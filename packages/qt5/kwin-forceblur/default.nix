{
  pname,
  src,
  version,
  #
  stdenv,
  fetchFromGitHub,
  lib,
  kwindowsystem,
}:
stdenv.mkDerivation {
  inherit pname src version;

  installPhase = ''
    install -d $out/share/kwin/scripts/forceblur
    cp -r contents/ LICENSE image.png metadata.desktop "$out/share/kwin/scripts/forceblur/"
    install -Dm644 metadata.desktop "$out/share/kservices5/kwin-script-forceblur.desktop"
  '';

  meta = with lib; {
    description = "Force-enable blur effect to user-specified windows";
    homepage = "https://github.com/esjeon/kwin-forceblur";
    license = licenses.mit;
    inherit (kwindowsystem.meta) platforms;
  };
}
