{zellij, symlinkJoin, makeWrapper }: symlinkJoin {
  inherit (zellij) name pname version;
  paths = [zellij];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    ZELLIJ_CONFIG_DIR="$out/share/zellij"
    mkdir -p "$ZELLIJ_CONFIG_DIR"

    cp -vf ${./config.kdl} "$ZELLIJ_CONFIG_DIR/config.kdl"

    wrapProgram  $out/bin/zellij \
      --set-default ZELLIJ_CONFIG_DIR "$ZELLIJ_CONFIG_DIR"
  '';
}
