{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
  version = "unstable-2022-03-05";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    rev = "d98974b5a58b62f75ab6ea34a13368bd773652de";
    sha256 = "18xaldaq6vczfqy8s44f9z2x5ajh3dq6p8gi57cazks12x37hf7i";
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
