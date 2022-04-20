{
  stylua,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  __nocachix = true;
  name = "stylua";
  paths = [stylua];
  buildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/stylua \
      --add-flags "--config-path ${./stylua.toml}"
  '';
}
