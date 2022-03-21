{
  stdenv,
  lib,
  fetchFromGitHub,
}: let
  metadata = rec {
    repo_git = "https://github.com/elFarto/nvidia-vaapi-driver";
    branch = "master";
    rev = "21d08037de0959ad2cbb1990d16f20d4c3e57c5f";
    sha256 = "sha256-sdgBAwgEITbdmxLdnbf6h9Rq+j8ljiND8bjyxxMUIss=";
    version = rev;
  };
in
  stdenv.mkDerivation rec {
    pname = "nvidia-vaapi-driver";
    version = "unstable-2022-03-13";

    src = fetchFromGitHub {
      owner = "elFarto";
      repo = "nvidia-vaapi-driver";
      rev = "ae5a33bb178fd72b0b09bbdd9c8791bcbcd69995";
      sha256 = "0zx8yj02dvyfclkyij2hkzrpxbhh0k91jd6y4g61na0bxchwjja5";
    };

    skipBuild = true;

    installPhase = ''
      cp -a "${src}" "$out"
    '';

    meta = with lib; {
      verinfo = metadata;
      description = "nvidia-vaapi-driver";
      homepage = "https://github.com/elFarto/nvidia-vaapi-driver";
      license = licenses.mit;
      maintainers = [];
    };
  }
