# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  iosevka = {
    pname = "iosevka";
    version = "v1.4.5";
    src = fetchurl {
      url = "https://github.com/viperML/iosevka/releases/download/v1.4.5/iosevka.zip";
      sha256 = "sha256-MVY1B/Ob2v+lRaWBfuFBwhnLicVOdLQtbNsj7zIUhSU=";
    };
  };
}
