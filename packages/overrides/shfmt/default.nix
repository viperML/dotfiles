{
  shfmt,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  __nocachix = true;
  inherit (shfmt) name;
  paths = [shfmt];
  buildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/shfmt \
      --add-flags "-i 4"
  '';
}
