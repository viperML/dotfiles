{
  pname,
  src,
  date,
  #
  awesome,
}:
awesome.overrideAttrs (_: {
  __nocachix = true;
  inherit pname src;
  version = date;
  patches = [];
})
