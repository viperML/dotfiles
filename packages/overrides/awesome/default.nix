{
  pname,
  src,
  date,
  #
  awesome,
}:
awesome.overrideAttrs (_: {
  inherit pname src;
  version = date;
  patches = [];
})
