{
  symlinkJoin,
  nix-index-unwrapped,
  makeWrapper,
  runCommandLocal,
  #
  database,
  databaseDate,
}: let
  # Add a folder in between and set name to `file`
  database' = runCommandLocal "nix-index-database" {} ''
    mkdir -p $out
    ln -s ${database} $out/files
  '';
  inherit (nix-index-unwrapped) pname;
  version = "${nix-index-unwrapped.version}+db=${databaseDate}";
in
  symlinkJoin {
    name = "${pname}-${version}";
    inherit pname version;
    paths = [nix-index-unwrapped];
    buildInputs = [makeWrapper];
    postBuild = ''
      cp -fv ${./command-not-found.sh} $out/etc/profile.d/command-not-found.sh

      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace "nix-locate" "$out/bin/nix-locate"

      wrapProgram $out/bin/nix-index \
        --add-flags "--db ${database'}"
      wrapProgram $out/bin/nix-locate \
        --add-flags "--db ${database'}"
    '';
  }
