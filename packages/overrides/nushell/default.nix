{
  rustPlatform,
  pkg-config,
  openssl,
  symlinkJoin,
  makeWrapper,
  carapace,
  nushell
}: let
  package = nushell;
in
  symlinkJoin {
    inherit (package) name pname version meta;
    paths = [
      package
      carapace
    ];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nu \
        --add-flags "--env-config ${./env.nu}" \
        --add-flags "--config ${./config.nu}" \
        --prefix PATH ':' $out/bin \
        --set STARSHIP_CONFIG ${./starship.toml}
    '';
  }
