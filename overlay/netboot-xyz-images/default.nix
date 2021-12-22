{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation rec {
  pname = "netboot-xyz-images";
  version = "2.0.54";

  srcs = [
    (fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
      sha256 = "00a94sl9d8f9ahh4fk68xxg18153w8s6phrilk9i5q5x26pfmddz";
    })
    (fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.lkrn";
      sha256 = "1jjlafny77l3j2vqa4aqzhinw1ymnms3z0ay4rk48m72na6fqlnw";
    })
  ];

  unpackPhase = ":";

  installPhase = ''
  mkdir $out
  for s in $srcs; do
    name="$(basename $s)"
    cp $s "$out/''${name#*-}"
  done
  '';

  meta = with lib; {
    description = "netboot.xyz bootloader images, uefi and legacy.";
    homepage = "https://netboot.xyz";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
