{
  pname,
  version,
  src,
  #
  awesome,
}:
awesome.overrideAttrs (_: {
  __nocachix = true;
  inherit pname version src;
  patches = [];
})
