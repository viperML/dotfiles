{
  pname,
  src,
  version,
  #
  bismuth,
  fetchFromGitHub,
}:
bismuth.overrideAttrs (prev: {
  inherit src version;
})
