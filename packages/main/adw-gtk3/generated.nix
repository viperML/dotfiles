# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  adw-gtk3 = {
    pname = "adw-gtk3";
    version = "v4.9";
    src = fetchFromGitHub {
      owner = "lassekongo83";
      repo = "adw-gtk3";
      rev = "v4.9";
      fetchSubmodules = false;
      sha256 = "sha256-ni1u6696jrwjYZ4gppF9yD1RAum0+D7WxQgu09cxVGg=";
    };
  };
}
