{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
  version = "unstable-2022-02-28";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    rev = "eca80a069d6f9c71e7b5c350eae9c8ef4a0e07d2";
    sha256 = "0gs85vjrgsfxq86m2hy72h4z9i1zf6jznqmds88rnag2gxalrrk4";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    ./install -P $out
  '';

  meta = with lib; {
    description = "Wrapper around podman or docker to create and start containers";
    longDescription = "Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution you’re more comfortable with";
    homepage = "https://distrobox.privatedns.org/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
