# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  resolve-march-native = {
    pname = "resolve-march-native";
    version = "2c5bb31b210ca06812142bbd75780b72c92f4d86";
    src = fetchFromGitHub ({
      owner = "hartwork";
      repo = "resolve-march-native";
      rev = "2c5bb31b210ca06812142bbd75780b72c92f4d86";
      fetchSubmodules = false;
      sha256 = "sha256-VDWsIrRNq/DM0GKJvEDau2Za5d+jLA9tBb+3m3JSF5g=";
    });
    date = "2023-01-16";
  };
}
