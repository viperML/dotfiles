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
    version = "unstable-2022-03-21";

    src = fetchFromGitHub {
      owner = "elFarto";
      repo = "nvidia-vaapi-driver";
      rev = "dd27bbf53082c1884b0495c58999056af3c6bee9";
      sha256 = "16bshdjn659w931r8106wvqcp5k5xc3xva67kr5s50zw2jdgx1dx";
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
