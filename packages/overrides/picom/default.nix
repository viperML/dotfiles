{
  pname,
  version,
  src,
  #
  picom,
}:
picom.overrideAttrs (_: {
  __nocachix = true;
  inherit pname version src;
})
