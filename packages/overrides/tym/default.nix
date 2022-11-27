{
  tym,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  __nocachix = true;
  inherit (tym) name pname version;
  paths = [tym];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    TYM_DIR="$out/share/tym"
    mkdir -pv "$TYM_DIR"

    cp -vf ${./config.lua} "$TYM_DIR/config.lua"

    wrapProgram $out/bin/tym \
      --add-flags "--use=$TYM_DIR/config.lua"
  '';
}
