{
  lib,
  poetry2nix,
  python3,
}:
poetry2nix.mkPoetryApplication rec {
  python = python3;

  src = ./.;
  projectDir = src;

  meta = with lib; {
    inherit (python.meta) platforms;
    description = "My awesome poetry application";
    license = licenses.mit;
    homepage = "https://foo.bar";
  };
}
