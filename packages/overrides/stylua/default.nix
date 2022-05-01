{
  stylua,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  inherit (stylua) name meta;
  paths = [stylua];
  buildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/stylua \
      --add-flags "--config-path ${./stylua.toml}"
  '';
}
