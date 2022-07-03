{
  bismuth,
  fetchFromGitHub,
}:
bismuth.overrideAttrs (prev: {
  version = "unstable-2022-07-03";
  src = fetchFromGitHub {
    owner = "Bismuth-Forge";
    repo = "bismuth";
    rev = "7c49292f1d2f0980931b187747361a9ac6046008";
    sha256 = "sha256-sYehZ9f+V7xeqYaw5p6BCm2XWsC/mpmsak6pUFIWAbI=";
  };
})
