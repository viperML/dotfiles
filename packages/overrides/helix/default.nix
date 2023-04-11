{
  helix,
  symlinkJoin,
  makeWrapper,
}: symlinkJoin {
  paths = [helix];
  nativeBuildInputs = [makeWrapper];
  inherit (helix) name pname version meta;
  postBuild = ''
    wrapProgram $out/bin/hx \
      --add-flags -c --add-flags ${./config.toml}
  '';
}
