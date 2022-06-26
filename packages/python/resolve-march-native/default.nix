{
  buildPythonPackage,
  fetchFromGitHub,
  gcc,
  lib,
}:
buildPythonPackage rec {
  pname = "resolve-march-native";
  version = "unstable-2022-06-18";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "resolve-march-native";
    rev = "ee647691bfeb99eac69d20407062de9f090690c9";
    sha256 = "0apr7r7jq2j2kpm9qyf05dw6cq2jk3zad7qyvjx1g9ri5kdg3s9i";
  };

  propagatedBuildInputs = [
    gcc
  ];

  meta = with lib; {
    description = "Tool to determine what GCC flags -march=native would resolve into";
    inherit (src.meta) homepage;
    platforms = platforms.all;
  };
}
