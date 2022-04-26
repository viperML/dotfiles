{
  stylua,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  __nocachix = true;
  inherit (stylua) name;
  paths = [stylua];
  buildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/stylua \
      --add-flags "--config-path ${./stylua.toml}"
  '';
}
