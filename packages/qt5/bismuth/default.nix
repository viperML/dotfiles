{
  src,
  version,
  #
  bismuth,
}:
bismuth.overrideAttrs (prev: {
  inherit src version;
})
