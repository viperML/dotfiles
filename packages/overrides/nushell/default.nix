{
  nushell,
  symlinkJoin,
  makeWrapper,
  carapace,
}:
symlinkJoin {
  __nocachix = true;
  inherit (nushell) name pname version meta;
  paths = [
    nushell
    carapace
  ];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/nu \
      --add-flags "--env-config ${./env.nu}" \
      --add-flags "--config ${./config.nu}" \
      --prefix PATH ':' $out/bin
  '';
}
