{
  nushell,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  __nocachix = true;
  inherit (nushell) name pname version meta;
  paths = [nushell];
  nativeBuildInputs = [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/nu \
      --add-flags "--env-config ${./env.nu}" \
      --add-flags "--config ${./config.nu}"
  '';
}
