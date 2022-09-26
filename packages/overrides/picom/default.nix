{
  pname,
  date,
  src,
  #
  picom,
}:
picom.overrideAttrs (_: {
  __nocachix = true;
  inherit pname src;
  version = date;
})
