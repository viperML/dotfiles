{
  kitty,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  inherit (kitty) name pname version;
  paths = [kitty];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    KITTY_CONFIG_DIRECTORY="$out/share/kitty"
    mkdir -pv "$KITTY_CONFIG_DIRECTORY"

    cp -vf ${./kitty.conf} "$KITTY_CONFIG_DIRECTORY/kitty.conf"

    wrapProgram $out/bin/kitty \
      --set-default KITTY_CONFIG_DIRECTORY "$KITTY_CONFIG_DIRECTORY"
  '';
}
