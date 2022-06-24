{
  bismuth,
  fetchFromGitHub,
}:
bismuth.overrideAttrs (prev: {
  version = "unstable-2022-06-23";
  src = fetchFromGitHub {
    owner = "Bismuth-Forge";
    repo = "bismuth";
    rev = "c70285705bf90757b839936211fea00afd788fee";
    sha256 = "17i9i2piiw8py8wwk4lpabjcxmbd09vkcvzwz9hj9px25kcw4vpg";
  };
})
