# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  tym = {
    pname = "tym";
    version = "e0e1e5249c6038294392acb06e91f92363d4d611";
    src = fetchFromGitHub ({
      owner = "endaaman";
      repo = "tym";
      rev = "e0e1e5249c6038294392acb06e91f92363d4d611";
      fetchSubmodules = false;
      sha256 = "sha256-aJTlO8JFNTVVfTEZcQdFyd4vfM7u9ezEFW3xb/41+3k=";
    });
    date = "2022-11-25";
  };
  vte = {
    pname = "vte";
    version = "adc5e8fa46cd328354570738aeb3418562b7695e";
    src = fetchgit {
      url = "https://gitlab.gnome.org/GNOME/vte";
      rev = "adc5e8fa46cd328354570738aeb3418562b7695e";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-ULxdwH/kSgrMdTm1gmXrlz2+khEoDmuhfF6Cgc59YF0=";
    };
    date = "2022-11-29";
  };
}
