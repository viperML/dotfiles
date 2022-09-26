{
  src,
  date,
  #
  bismuth,
}:
bismuth.overrideAttrs (prev: {
  inherit src;
  version = date;
})
