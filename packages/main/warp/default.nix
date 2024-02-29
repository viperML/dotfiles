{ stdenv
, fetchurl
, dpkg
, makeWrapper
, patchelf
, zlib
, curl
, fontconfig
, lib
, xorg
, libxkbcommon
, wayland
, vulkan-loader
, platforms
}:
stdenv.mkDerivation (final: {
  pname = "warp";
  version = "0.2024.02.20.08.01.stable_01";

  src = fetchurl {
    url = "https://releases.warp.dev/stable/v0.2024.02.20.08.01.stable_01/warp-terminal_0.2024.02.20.08.01.stable.01_amd64.deb";
    hash = "sha256-x4ffSPEXfIQ05TcMwGjQswxeifFFy5ZLlOI0LbeBgBs=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
  ];

  buildInputs = [
    zlib
    curl
    fontconfig
    stdenv.cc.cc
    #
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    libxkbcommon
    wayland
    vulkan-loader
  ];

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -vr opt/warpdotdev/warp-terminal/warp $out/bin
  '';

  postFixup = ''
    patchelf  \
      --set-rpath "${lib.makeLibraryPath final.buildInputs}" \
      $out/bin/warp
  '';

  meta = {
    mainProgram = "warp";
    platforms = [ "x86_64-linux" ];
  };
})
