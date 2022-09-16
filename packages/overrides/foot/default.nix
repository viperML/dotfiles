{
  symlinkJoin,
  foot,
  makeBinaryWrapper,
}:
symlinkJoin {
  inherit (foot) name pname version;
  paths = [foot];
  nativeBuildInputs = [makeBinaryWrapper];
  postBuild = ''
    echo "Validating config..."
    ${foot}/bin/foot --check-config --config=${./foot.ini}
    echo "Config OK"

    wrapProgram $out/bin/foot \
      --add-flags '--config=${./foot.ini}'
  '';
}
