{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "kwin-forceblur";
  version = "unstable-2020-05-15";

  src = fetchFromGitHub {
    owner = "esjeon";
    repo = "kwin-forceblur";
    rev = "fff423bafacbca8ae0b60aec3659b38bde16e82b";
    sha256 = "0jhqdh0j196j73fmxzxr5blyvhicisb49q6j57j2zyky549prdw9";
  };

  installPhase = ''
    install -d $out/share/kwin/scripts/forceblur
    cp -r bin/ contents/ LICENSE image.png metadata.desktop "$out/share/kwin/scripts/forceblur/"
    install -Dm644 metadata.desktop "$out/share/kservices5/kwin-script-forceblur.desktop"
  '';
}
