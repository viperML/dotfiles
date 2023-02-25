# {
#   nushell,
#   symlinkJoin,
#   makeWrapper,
#   carapace,
# }: let
#   muNushell = nushell;
# in
# symlinkJoin {
#   __nocachix = true;
#   inherit (myU) name pname version meta;
#   paths = [
#     nushell
#     carapace
#   ];
#   nativeBuildInputs = [makeWrapper];
#   postBuild = ''
#     wrapProgram $out/bin/nu \
#       --add-flags "--env-config ${./env.nu}" \
#       --add-flags "--config ${./config.nu}" \
#       --prefix PATH ':' $out/bin
#   '';
# }
{
  nushell,
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
  };
in
  symlinkJoin {
    __nocachix = true;
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
        --prefix PATH ':' $out/bin
    '';
  }
