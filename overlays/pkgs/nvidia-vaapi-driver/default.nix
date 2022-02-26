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
    version = "unstable-2022-02-24";

    src = fetchFromGitHub {
      owner = "elFarto";
      repo = "nvidia-vaapi-driver";
      rev = "59349fe55232c9a684a8379e13ddbdea9f9863d4";
      sha256 = "12rbcmri0pihgf65lgx0svri55zfhnzh5jzzkc14nnxci78gb1k8";
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
