{
  awesome,
  fetchFromGitHub,
}:
awesome.overrideAttrs (_: {
  __nocachix = true;
  version = "unstable-2022-06-30";
  patches = [];
  src = fetchFromGitHub {
    owner = "awesomeWM";
    repo = "awesome";
    rev = "9ca7bb487a5d1d2d5c102f94cd9e8cb5b6e7ffaa";
    sha256 = "0h7wn54hh546kpjwah9a3sl47r7nrvjzscldbhpllbhdhq0706j5";
  };
})
