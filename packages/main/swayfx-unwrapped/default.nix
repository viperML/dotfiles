{
  date,
  src,
  #
  sway-unwrapped,
  isNixOS ? false,
  enableXWayland ? true,
}:
sway-unwrapped.overrideAttrs (old: {
  pname = "swayfx";
  version = date;
  inherit src isNixOS enableXWayland;
})
