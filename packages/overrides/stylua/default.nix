{
  stylua,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  inherit (stylua) name;
  paths = [stylua];
  buildInputs = [makeWrapper];
  __nocachix = true;
  postBuild = ''
    wrapProgram $out/bin/stylua \
      --add-flags "--config-path ${./stylua.toml}"
  '';
}
