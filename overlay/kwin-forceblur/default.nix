{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "kwin-forceblur";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "esjeon";
    repo = pname;
    rev = "e84def6a05a25b67ed6b0c1c87332e01389075f5";
    sha256 = "115dl1q9gmm9axcwwkfbh1viamkx4kilgnhchgvhifj3sxd5qhw4";
  };

  installPhase = ''
    install -d $out/share/kwin/scripts/forceblur
    cp -r bin/ contents/ LICENSE image.png metadata.desktop "$out/share/kwin/scripts/forceblur/"
    install -Dm644 metadata.desktop "$out/share/kservices5/kwin-script-forceblur.desktop"
  '';
}
