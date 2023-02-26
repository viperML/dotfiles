{
  pname,
  version,
  src,
  date,
  rustPlatform,
  pkg-config,
  openssl,
  symlinkJoin,
  makeWrapper,
  carapace,
}: let
  package = rustPlatform.buildRustPackage {
    inherit pname src;
    version = date;
    cargoLock.lockFile = ./nushell-${version}/Cargo.lock;
    nativeBuildInputs = [pkg-config];
    buildInputs = [openssl];
    doCheck = false;
    buildFeatures = ["dataframe"];
    meta.mainProgram = "nu";
  };
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
