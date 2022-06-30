{
  picom,
  fetchFromGitHub,
}:
picom.overrideAttrs (_: {
  __nocachix = true;
  version = "unstable-2022-04-13";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "cd50596f0ed81c0aa28cefed62176bd6f050a1c6";
    sha256 = "0lh3p3lkafkb2f0vqd5d99xr4wi47sgb57x65wa2cika8pz5sikv";
  };
})
