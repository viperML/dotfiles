{
  wlroots,
}:
wlroots.overrideAttrs (prev: {
  __nocachix = true;
  pname = "wlroots-nvidia";
})
