{
  pname,
  date,
  src,
  #
  picom,
}:
picom.overrideAttrs (_: {
  inherit pname src;
  version = date;
})
